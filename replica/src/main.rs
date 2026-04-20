//! CLI entry.
//!
//! Loads a BotConfig (JSON on disk, matching the artifact's
//! format) and drives the replica spread-capture loop.

use std::path::PathBuf;

use alloy_primitives::U256;
use anyhow::{Context, Result};
use clap::Parser;
use tracing_subscriber::EnvFilter;

use arbigab_replica::book::BookSnapshot;
use arbigab_replica::client::TradingClient;
use arbigab_replica::config::{BotConfig, SpreadConfig};
use arbigab_replica::state_machine::{SpreadCapture, Tick};

#[derive(Parser)]
#[command(name = "arbigab-replica")]
struct Cli {
    /// Path to the BotConfig JSON file.
    #[arg(long)]
    config: PathBuf,
    /// Path to the nonce persistence file.
    #[arg(long, default_value = "./.nonce")]
    nonce: PathBuf,
    /// Hex private key. Prefer env var `REPLICA_KEY`.
    #[arg(long, env = "REPLICA_KEY")]
    key: String,
    /// Polymarket fee rate in basis points.
    #[arg(long, default_value_t = 0)]
    fee_rate_bps: u32,
    /// CLOB token id (decimal string). Determines which market.
    #[arg(long)]
    token_id: String,
}

#[tokio::main]
async fn main() -> Result<()> {
    tracing_subscriber::fmt()
        .with_env_filter(EnvFilter::from_default_env())
        .init();

    let cli = Cli::parse();
    let config_bytes = std::fs::read(&cli.config)
        .with_context(|| format!("reading config {:?}", cli.config))?;
    let cfg: BotConfig = serde_json::from_slice(&config_bytes)
        .context("deserializing BotConfig")?;

    tracing::info!(?cfg.symbol, ?cfg.dry_run, "replica starting");

    let client = TradingClient::new(
        &cli.key,
        cli.nonce.clone(),
        cfg.dry_run,
        cli.fee_rate_bps,
    )?;

    let token_id: U256 = cli.token_id.parse()
        .context("token_id must parse as U256")?;

    let spread_cfg = SpreadConfig::from_bot(&cfg);
    let mut sc = SpreadCapture::new(
        spread_cfg,
        cfg.max_position_size,
        cfg.min_price,
        cfg.max_price,
    );

    loop {
        client.fetch_book(&cli.token_id).await?;
        let book: BookSnapshot = client.book_cache().read().clone();
        let tick = Tick {
            token_id,
            // Replica does not yet integrate with a position
            // service — an external caller sets net_position.
            // For canary runs, wire this to the account fills
            // feed before deploying.
            net_position: 0.0,
            book,
        };
        sc.tick(&tick, &client).await?;
        tokio::time::sleep(std::time::Duration::from_millis(
            cfg.trade_cooldown.max(0) as u64,
        ))
        .await;
    }
}
