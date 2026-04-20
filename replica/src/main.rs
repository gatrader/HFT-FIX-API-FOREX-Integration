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
use arbigab_replica::state_machine::encode_amounts;

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
