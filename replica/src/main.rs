//! CLI entry.
//!
//! Subcommands:
//!   bootstrap  — one-time: POST /auth/api-key, save creds.
//!   dryrun     — load creds, build + sign order, print payload, do not POST.
//!   canary     — load creds, build + sign order, POST once, print response.
//!
//! Key is read from env var `POLYMARKET_PRIVATE_KEY`. Never
//! pass the key on argv.

use std::path::PathBuf;

use alloy_primitives::U256;
use anyhow::{Context, Result};
use clap::{Parser, Subcommand};
use tracing_subscriber::EnvFilter;

use arbigab_replica::auth::ApiCredentials;
use arbigab_replica::client::TradingClient;
use arbigab_replica::config::{BotConfig, SpreadConfig};
use arbigab_replica::order::{pick_side, Side};
use arbigab_replica::runtime::{Runtime, RuntimeConfig, RuntimeStats};
use arbigab_replica::state_machine::{encode_amounts, SpreadCapture};

#[derive(Parser)]
#[command(name = "arbigab-replica", about = "Arbigab clean-room replica")]
struct Cli {
    #[command(subcommand)]
    cmd: Cmd,

    /// Hex private key. Prefer env var POLYMARKET_PRIVATE_KEY.
    #[arg(long, env = "POLYMARKET_PRIVATE_KEY", hide_env_values = true)]
    key: String,

    /// Path to the nonce persistence file.
    #[arg(long, default_value = "./.replica/nonce")]
    nonce: PathBuf,

    /// Path to the cached API credentials.
    #[arg(long, default_value = "./.replica/creds.json")]
    creds: PathBuf,
}

#[derive(Subcommand)]
enum Cmd {
    /// One-time: call /auth/api-key and cache the returned credentials.
    Bootstrap,
    /// Build + sign one order and print the payload. Does NOT post.
    Dryrun {
        #[arg(long)]
        config: PathBuf,
        #[arg(long)]
        token_id: String,
        /// Net position to simulate (used by the pivot).
        #[arg(long, default_value_t = 0.0)]
        net_position: f64,
    },
    /// Place ONE order on the live CLOB and print the response.
    Canary {
        #[arg(long)]
        config: PathBuf,
        #[arg(long)]
        token_id: String,
        /// Net position (controls pivot direction + surplus).
        #[arg(long)]
        net_position: f64,
        /// Fee rate in basis points (fetch from CLOB before running).
        #[arg(long, default_value_t = 0)]
        fee_rate_bps: u32,
    },
    /// Connect to the Polymarket WS market channel, subscribe to
    /// a token, and print observability stats every second.
    /// Exercise harness for PR 2; not part of any trading path.
    #[cfg(feature = "ws")]
    WsProbe {
        #[arg(long)]
        token_id: String,
        /// Seconds to run before exiting.
        #[arg(long, default_value_t = 10)]
        seconds: u64,
    },
    /// Long-lived decision loop (PR 3). Ticks at the configured
    /// cadence, reads the shared book_cache, and dispatches to the
    /// TradingClient subject to dedup + rate budget.
    /// With `--realtime` (requires --features ws), WS ingest
    /// populates the cache; otherwise REST fetch_book is called on
    /// every stale tick exactly as the legacy path.
    Runtime {
        #[arg(long)]
        config: PathBuf,
        #[arg(long)]
        token_id: String,
        #[arg(long)]
        net_position: f64,
        #[arg(long, default_value_t = 0)]
        fee_rate_bps: u32,
        /// Tick cadence (ms). User spec: 100–250.
        #[arg(long, default_value_t = 150)]
        tick_interval_ms: u64,
        #[arg(long, default_value_t = 1_000)]
        book_max_age_ms: u64,
        #[arg(long, default_value_t = 500)]
        dedup_window_ms: u64,
        #[arg(long, default_value_t = 5)]
        submit_budget_per_sec: u32,
        #[arg(long, default_value_t = 0.001)]
        price_bucket: f64,
        #[arg(long, default_value_t = 1.0)]
        size_bucket: f64,
        /// Stop after N seconds. 0 = run forever. Bounded default
        /// so accidental invocations don't loop unattended.
        #[arg(long, default_value_t = 60)]
        duration_secs: u64,
        /// Switch to WS-ingested book (requires --features ws).
        /// When false, REST fetch_book is used on every stale tick.
        #[arg(long, default_value_t = false)]
        realtime: bool,
    },
}

#[tokio::main]
async fn main() -> Result<()> {
    tracing_subscriber::fmt()
        .with_env_filter(
            EnvFilter::try_from_default_env()
                .unwrap_or_else(|_| EnvFilter::new("info")),
        )
        .init();

    let cli = Cli::parse();
    if let Some(parent) = cli.nonce.parent() {
        std::fs::create_dir_all(parent).ok();
    }
    if let Some(parent) = cli.creds.parent() {
        std::fs::create_dir_all(parent).ok();
    }

    match cli.cmd {
        Cmd::Bootstrap => {
            let client = TradingClient::new(&cli.key, cli.nonce, true, 0)?;
            tracing::info!(maker = %client.maker(), "bootstrapping");
            let creds = client.bootstrap().await?;
            std::fs::write(&cli.creds, serde_json::to_string_pretty(&creds)?)
                .with_context(|| format!("writing {:?}", cli.creds))?;
            tracing::info!(path = ?cli.creds, "credentials saved");
            Ok(())
        }

        Cmd::Dryrun { config, token_id, net_position } => {
            let (cfg, token) = load_config(&config, &token_id)?;
            let client = TradingClient::new(&cli.key, cli.nonce, true,
                                            0)?;
            load_creds_into(&cli.creds, &client)?;
            run_one(&cfg, &client, token, net_position).await
        }

        Cmd::Canary { config, token_id, net_position, fee_rate_bps } => {
            let (cfg, token) = load_config(&config, &token_id)?;
            if cfg.dry_run {
                anyhow::bail!(
                    "canary refuses to run with dry_run=true — flip to false first"
                );
            }
            let client = TradingClient::new(
                &cli.key, cli.nonce, false, fee_rate_bps,
            )?;
            load_creds_into(&cli.creds, &client)?;
            run_one(&cfg, &client, token, net_position).await
        }

        Cmd::Runtime {
            config, token_id, net_position, fee_rate_bps,
            tick_interval_ms, book_max_age_ms, dedup_window_ms,
            submit_budget_per_sec, price_bucket, size_bucket,
            duration_secs, realtime,
        } => {
            use std::sync::Arc;
            use std::time::Duration;

            let (cfg, token) = load_config(&config, &token_id)?;
            if cfg.dry_run {
                anyhow::bail!("runtime refuses to run with dry_run=true");
            }
            let client = TradingClient::new(
                &cli.key, cli.nonce, false, fee_rate_bps,
            )?;
            load_creds_into(&cli.creds, &client)?;

            let rt_cfg = RuntimeConfig {
                tick_interval_ms, book_max_age_ms, dedup_window_ms,
                submit_budget_per_sec, price_bucket, size_bucket,
            };
            let spread_cfg = SpreadConfig::from_bot(&cfg);
            let sm = SpreadCapture::new(
                spread_cfg,
                cfg.max_position_size,
                cfg.min_price,
                cfg.max_price,
            );
            let book = client.book_cache();
            let stats = Arc::new(RuntimeStats::default());

            let mut rt: Runtime;
            #[cfg(feature = "ws")]
            {
                use arbigab_replica::ws::{WsClient, WsStats};
                let base = Runtime::new(rt_cfg, sm, book.clone(), stats.clone());
                if realtime {
                    let ws_stats = Arc::new(WsStats::default());
                    let ws_client = WsClient::new(
                        vec![token_id.clone()],
                        book.clone(),
                        ws_stats.clone(),
                    );
                    tokio::spawn(async move { let _ = ws_client.run().await; });
                    rt = base.with_ws_stats(ws_stats);
                } else {
                    rt = base;
                }
            }
            #[cfg(not(feature = "ws"))]
            {
                if realtime {
                    anyhow::bail!(
                        "--realtime requires building with --features ws"
                    );
                }
                rt = Runtime::new(rt_cfg, sm, book.clone(), stats.clone());
            }
            rt.set_net_position(net_position);

            // 1 Hz stats logger — independent cadence from the
            // decision tick so the log isn't N×/sec at 150ms ticks.
            let stats_for_log = stats.clone();
            let book_for_log = book.clone();
            tokio::spawn(async move {
                loop {
                    tokio::time::sleep(Duration::from_secs(1)).await;
                    let b = book_for_log.read();
                    tracing::info!(
                        target: "runtime_tick",
                        ticks = stats_for_log.tick_count(),
                        tick_us = stats_for_log.observed_tick_us(),
                        dedups = stats_for_log.dedup_count(),
                        drops = stats_for_log.throttle_drops(),
                        last_decision_age_ms = ?stats_for_log.last_decision_age_ms(),
                        last_submit_age_ms = ?stats_for_log.last_submit_age_ms(),
                        book_age_ms = ?b.book_age_ms(),
                        best_bid = ?b.best_bid(),
                        best_ask = ?b.best_ask(),
                        "tick"
                    );
                }
            });

            let tick_fut = rt.run_forever(token, token_id.clone(), &client);
            if duration_secs == 0 {
                tick_fut.await?;
            } else {
                tokio::select! {
                    r = tick_fut => r?,
                    _ = tokio::time::sleep(Duration::from_secs(duration_secs)) => {
                        tracing::info!(
                            target: "runtime",
                            duration_secs,
                            "duration reached — exiting"
                        );
                    }
                }
            }
            Ok(())
        }

        #[cfg(feature = "ws")]
        Cmd::WsProbe { token_id, seconds } => {
            use std::sync::Arc;
            use parking_lot::RwLock;
            use arbigab_replica::book::BookSnapshot;
            use arbigab_replica::ws::{WsClient, WsStats};

            let cache = Arc::new(RwLock::new(BookSnapshot::default()));
            let stats = Arc::new(WsStats::default());
            let client = WsClient::new(
                vec![token_id.clone()], cache.clone(), stats.clone(),
            );
            // Drive the reconnect loop on a detached task so we can
            // print stats on our cadence.
            tokio::spawn(async move { let _ = client.run().await; });

            for _ in 0..seconds {
                tokio::time::sleep(std::time::Duration::from_secs(1)).await;
                let age = stats.last_ws_message_age_ms();
                let (bid, ask) = {
                    let r = cache.read();
                    (r.best_bid(), r.best_ask())
                };
                tracing::info!(
                    target: "ws_probe",
                    connected = stats.ws_connected(),
                    reconnects = stats.ws_reconnect_count(),
                    last_msg_age_ms = ?age,
                    fallbacks = stats.ws_fallback_to_rest_count(),
                    best_bid = ?bid,
                    best_ask = ?ask,
                    "probe tick"
                );
            }
            Ok(())
        }
    }
}

fn load_config(path: &PathBuf, token_id: &str) -> Result<(BotConfig, U256)> {
    let bytes = std::fs::read(path)
        .with_context(|| format!("reading {:?}", path))?;
    let cfg: BotConfig = serde_json::from_slice(&bytes)
        .context("deserializing BotConfig")?;
    let token: U256 = token_id.parse()
        .context("token_id must parse as U256")?;
    Ok((cfg, token))
}

fn load_creds_into(path: &PathBuf, client: &TradingClient) -> Result<()> {
    let bytes = std::fs::read(path)
        .with_context(|| format!("reading creds {:?} — run bootstrap first", path))?;
    let creds: ApiCredentials = serde_json::from_slice(&bytes)
        .context("parsing credentials")?;
    client.set_credentials(creds);
    Ok(())
}

async fn run_one(
    cfg: &BotConfig,
    client: &TradingClient,
    token_id: U256,
    net_position: f64,
) -> Result<()> {
    let spread_cfg = SpreadConfig::from_bot(cfg);

    let Some((side, surplus)) = pick_side(
        net_position, cfg.max_position_size, cfg.trade_side,
    ) else {
        tracing::info!(
            net_position,
            max_position_size = cfg.max_position_size,
            "pivot skipped — nothing to do"
        );
        return Ok(());
    };

    let price = match side {
        Side::Buy => cfg.min_price,
        Side::Sell => cfg.max_price,
    };
    let size = spread_cfg.order_size.min(surplus);
    let (maker_amount, taker_amount) = encode_amounts(side, price, size);

    tracing::info!(
        ?side, price, size, surplus, "placing single order"
    );
    client
        .place_single_order(token_id, maker_amount, taker_amount, side)
        .await?;
    tracing::info!("done");
    Ok(())
}
