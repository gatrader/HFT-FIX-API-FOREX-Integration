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
use arbigab_replica::runtime::{
    CancelWorker, Runtime, RuntimeConfig, RuntimeStats, SubmitWorker,
};
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
        /// Number of submits to run in THIS process. Default 1
        /// preserves original single-shot behavior. Use >1 for
        /// latency benchmarks — the HTTP keepalive pool stays
        /// warm across iterations, which is the whole point.
        #[arg(long, default_value_t = 1)]
        iterations: u32,
        /// Delay between iterations in milliseconds. Ignored when
        /// iterations == 1.
        #[arg(long, default_value_t = 1000)]
        interval_ms: u64,
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
        /// Initial net_position seed, in shares. Overwritten by
        /// reconcile (if enabled) and then adjusted by every fill
        /// received on the user WS channel. For the unwinder
        /// live-fire test this is the manually pre-positioned
        /// share count.
        #[arg(long, default_value_t = 0.0)]
        net_position: f64,
        /// Condition IDs (markets) for the user WS subscribe
        /// payload. Required when `--user-ws` is set; repeatable
        /// for multi-market subscriptions. Ignored otherwise.
        #[arg(long, value_name = "CONDITION_ID")]
        market: Vec<String>,
        /// Subscribe to the authenticated user WS channel and
        /// apply fills to net_position as they arrive. Requires
        /// `--features ws` and a valid creds file on disk.
        #[arg(long, default_value_t = false)]
        user_ws: bool,
        /// Before the first tick, fetch the on-chain position
        /// for `token_id` via data-api.polymarket.com/positions
        /// and seed net_position with the returned value.
        /// Non-fatal on error — `--net-position` then stands as
        /// the seed. Useful as a sanity check for the live-fire
        /// test that we actually hold the shares we think we do.
        #[arg(long, default_value_t = false)]
        reconcile_on_start: bool,
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
        /// Bounded mpsc capacity between runtime tick and submit
        /// worker. Larger = more burst tolerance, more memory; the
        /// budget gate (submit_budget_per_sec) means steady-state
        /// depth stays small. 32 is comfortable headroom at 5/s.
        #[arg(long, default_value_t = 32)]
        submit_queue_capacity: usize,
        /// Rollback switch: when true, runtime submits inline as in
        /// PR 3 (decision tick blocks on HTTP). Off by default —
        /// the whole point of PR 4 is to keep ticks off HTTP.
        #[arg(long, default_value_t = false)]
        inline_submit: bool,
        /// Minimum gap between cancel enqueues (ms). The state
        /// machine says Cancel* every tick the pivot isn't firing;
        /// this keeps the cancel worker from being spammed.
        #[arg(long, default_value_t = 500)]
        cancel_dedup_ms: u64,
        /// Bounded mpsc capacity for the cancel worker. Same spirit
        /// as `--submit-queue-capacity` — small is fine because the
        /// dedup window keeps the rate low.
        #[arg(long, default_value_t = 8)]
        cancel_queue_capacity: usize,
        /// Before starting the decision loop, issue one cancel-all
        /// to clear any stale orders left from a prior process.
        /// Honours `BotConfig.cancel_orders_on_start` if unset;
        /// the flag is provided as an override for the bench path
        /// where the BotConfig might carry a conservative default.
        #[arg(long, default_value_t = false)]
        force_cancel_on_start: bool,
    },
}

#[tokio::main]
async fn main() -> Result<()> {
    // JSON output is opt-in via RUNTIME_LOG_JSON=1 so interactive
    // runs keep the ANSI fmt. The EC2 benchmark recipe sets it to
    // get structured JSONL lines for the post-processing parser.
    let env_filter = EnvFilter::try_from_default_env()
        .unwrap_or_else(|_| EnvFilter::new("info"));
    if std::env::var("RUNTIME_LOG_JSON").ok().as_deref() == Some("1") {
        tracing_subscriber::fmt()
            .with_env_filter(env_filter)
            .json()
            .flatten_event(true)
            .with_current_span(false)
            .with_span_list(false)
            .init();
    } else {
        tracing_subscriber::fmt()
            .with_env_filter(env_filter)
            .init();
    }

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

        Cmd::Canary {
            config, token_id, net_position, fee_rate_bps,
            iterations, interval_ms,
        } => {
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
            // Single TradingClient = single reqwest::Client = shared
            // HTTP keepalive pool across all iterations. That's what
            // lets the benchmark observe the patch #3 connection-
            // reuse win; spawning the binary 50 times from a shell
            // for-loop would throw the pool away each time.
            for i in 1..=iterations {
                tracing::info!(
                    target: "canary_iter",
                    iteration = i, total = iterations,
                    "iteration start"
                );
                if let Err(e) = run_one(&cfg, &client, token, net_position).await {
                    // Keep going so we still collect N hotpath samples
                    // even if one submit is rejected (rate limit, etc.).
                    tracing::error!(
                        target: "canary_iter",
                        iteration = i, error = %e,
                        "iteration failed — continuing"
                    );
                }
                if i < iterations {
                    tokio::time::sleep(
                        std::time::Duration::from_millis(interval_ms),
                    ).await;
                }
            }
            Ok(())
        }

        Cmd::Runtime {
            config, token_id, net_position, market, user_ws,
            reconcile_on_start, fee_rate_bps,
            tick_interval_ms, book_max_age_ms, dedup_window_ms,
            submit_budget_per_sec, price_bucket, size_bucket,
            duration_secs, realtime,
            submit_queue_capacity, inline_submit,
            cancel_dedup_ms, cancel_queue_capacity, force_cancel_on_start,
        } => {
            use std::sync::Arc;
            use std::time::Duration;

            let (cfg, token) = load_config(&config, &token_id)?;
            if cfg.dry_run {
                anyhow::bail!("runtime refuses to run with dry_run=true");
            }
            // Arc<TradingClient>: shared between runtime tick (sign)
            // and submit worker (HTTP). Cheap clone.
            let client = Arc::new(TradingClient::new(
                &cli.key, cli.nonce, false, fee_rate_bps,
            )?);
            load_creds_into(&cli.creds, &client)?;

            let rt_cfg = RuntimeConfig {
                tick_interval_ms, book_max_age_ms, dedup_window_ms,
                submit_budget_per_sec, price_bucket, size_bucket,
                cancel_dedup_ms,
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
            // Hoisted so the 1 Hz stats logger below can read
            // ws_fallback_to_rest_count into the runtime_tick event.
            #[cfg(feature = "ws")]
            let mut ws_stats_for_log: Option<Arc<arbigab_replica::ws::WsStats>> = None;
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
                    ws_stats_for_log = Some(ws_stats.clone());
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
            // Seed in priority order: --net-position first (the
            // user-facing default), then overwrite with reconcile
            // result if enabled and successful. Fills landing
            // during startup get applied on top of whichever seed
            // won — that's inherent to an unordered reconcile.
            rt.set_net_position(net_position);
            if reconcile_on_start {
                match client.fetch_position_shares(&token_id).await {
                    Ok(on_chain) => {
                        rt.set_net_position(on_chain);
                        tracing::info!(
                            target: "reconcile",
                            token_id = %token_id,
                            on_chain,
                            "seeded net_position from data-api"
                        );
                    }
                    Err(e) => {
                        tracing::warn!(
                            target: "reconcile",
                            error = %e,
                            seed = net_position,
                            "position reconcile failed; keeping --net-position"
                        );
                    }
                }
            }

            // ── Fill ingestion (user WS channel) ──────────────────
            // Spawns an authenticated WS subscriber that applies
            // fills to the shared Position handle. Disabled by
            // default so dry-run and benchmark paths stay hermetic.
            #[cfg(feature = "ws")]
            if user_ws {
                if market.is_empty() {
                    anyhow::bail!(
                        "--user-ws requires at least one --market CONDITION_ID"
                    );
                }
                use arbigab_replica::user_ws::UserWsClient;
                use arbigab_replica::ws::WsStats;
                let creds = load_creds(&cli.creds)?;
                let user_stats = Arc::new(WsStats::default());
                let pos_handle = rt.position();
                let uws = UserWsClient::new(
                    Arc::new(creds),
                    market.clone(),
                    pos_handle,
                    user_stats,
                );
                tokio::spawn(async move { let _ = uws.run().await; });
                tracing::info!(
                    target: "user_ws",
                    markets = market.len(),
                    "user WS fill ingest started"
                );
            }
            #[cfg(not(feature = "ws"))]
            if user_ws {
                anyhow::bail!(
                    "--user-ws requires building with --features ws"
                );
            }

            // ── Submit decoupling (PR 4) ──────────────────────────
            // Default: bounded mpsc + worker. Rollback: --inline-submit
            // restores the PR 3 behavior of awaiting HTTP on the tick.
            if !inline_submit {
                let (tx, rx) = tokio::sync::mpsc::channel(submit_queue_capacity);
                let worker = SubmitWorker::new(
                    client.clone(), rx, stats.clone(),
                );
                tokio::spawn(worker.run());
                rt = rt.with_submit_queue(tx);
                tracing::info!(
                    target: "runtime",
                    capacity = submit_queue_capacity,
                    "submit worker spawned (queued submit path)"
                );
            } else {
                tracing::warn!(
                    target: "runtime",
                    "--inline-submit set: ticks will block on HTTP (PR 3 fallback)"
                );
            }

            // ── Cancel worker (B) ─────────────────────────────────
            // Always wired. The dedup window inside Runtime keeps
            // the rate sane, and Cancel* decisions are the state
            // machine's only self-throttle.
            let (ctx, crx) = tokio::sync::mpsc::channel(cancel_queue_capacity);
            let cancel_worker = CancelWorker::new(
                client.clone(), crx, stats.clone(),
            );
            tokio::spawn(cancel_worker.run());
            rt = rt.with_cancel_queue(ctx);

            // ── Startup cancel-all ─────────────────────────────────
            // Honors BotConfig.cancel_orders_on_start and the
            // `--force-cancel-on-start` CLI override. Fires before
            // the first tick so the unwinder starts from a known
            // "no resting orders" state.
            if cfg.cancel_orders_on_start || force_cancel_on_start {
                match client.cancel_all().await {
                    Ok(()) => tracing::info!(
                        target: "runtime", "startup cancel_all ok"
                    ),
                    Err(e) => tracing::warn!(
                        target: "runtime",
                        error = %e,
                        "startup cancel_all failed; continuing"
                    ),
                }
            }

            // ── SIGINT → cancel-all → exit ────────────────────────
            // Signal handler runs outside tokio::select! below so
            // Ctrl-C at any point flushes open orders before the
            // process exits. Cloned client so the handler task
            // owns its own reference.
            let shutdown_client = client.clone();
            tokio::spawn(async move {
                if let Err(e) = tokio::signal::ctrl_c().await {
                    tracing::error!(target: "shutdown",
                        error = %e, "ctrl_c listener failed");
                    return;
                }
                tracing::warn!(
                    target: "shutdown",
                    open = shutdown_client.open_order_count(),
                    "SIGINT received; cancelling open orders"
                );
                if let Err(e) = shutdown_client.cancel_all().await {
                    tracing::error!(
                        target: "shutdown",
                        error = %e,
                        "cancel_all on shutdown failed"
                    );
                }
                std::process::exit(0);
            });

            // 1 Hz stats logger — independent cadence from the
            // decision tick so the log isn't N×/sec at 150ms ticks.
            let stats_for_log = stats.clone();
            let book_for_log = book.clone();
            #[cfg(feature = "ws")]
            let ws_stats_for_logger = ws_stats_for_log.clone();
            tokio::spawn(async move {
                loop {
                    tokio::time::sleep(Duration::from_secs(1)).await;
                    let b = book_for_log.read();
                    #[cfg(feature = "ws")]
                    let ws_fallbacks: u64 = ws_stats_for_logger
                        .as_ref()
                        .map(|s| s.ws_fallback_to_rest_count())
                        .unwrap_or(0);
                    #[cfg(not(feature = "ws"))]
                    let ws_fallbacks: u64 = 0;
                    tracing::info!(
                        target: "runtime_tick",
                        ticks = stats_for_log.tick_count(),
                        tick_us = stats_for_log.observed_tick_us(),
                        dedups = stats_for_log.dedup_count(),
                        drops = stats_for_log.throttle_drops(),
                        last_decision_age_ms = ?stats_for_log.last_decision_age_ms(),
                        last_submit_age_ms = ?stats_for_log.last_submit_age_ms(),
                        queue_depth = stats_for_log.queue_depth(),
                        queue_full_drops = stats_for_log.queue_full_drops(),
                        last_queue_wait_us = stats_for_log.last_queue_wait_us(),
                        last_http_submit_us = stats_for_log.last_http_submit_us(),
                        ws_fallback_to_rest_count = ws_fallbacks,
                        book_age_ms = ?b.book_age_ms(),
                        best_bid = ?b.best_bid(),
                        best_ask = ?b.best_ask(),
                        "tick"
                    );
                }
            });

            let tick_fut = rt.run_forever(token, token_id.clone(), &*client);
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
    let creds = load_creds(path)?;
    client.set_credentials(creds);
    Ok(())
}

fn load_creds(path: &PathBuf) -> Result<ApiCredentials> {
    let bytes = std::fs::read(path)
        .with_context(|| format!("reading creds {:?} — run bootstrap first", path))?;
    let creds: ApiCredentials = serde_json::from_slice(&bytes)
        .context("parsing credentials")?;
    Ok(creds)
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
