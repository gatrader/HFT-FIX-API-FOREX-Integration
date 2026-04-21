//! Arbigab Polymarket quoter — clean-room replica.
//!
//! Spec reference: research/IMPLEMENTATION_SPEC.md
//! Artifact reference: bot/bin/arbitrage_bot (BuildID 0e348a5a...)
//!
//! This crate does NOT implement the exfil path, the decorative
//! fields, or any guardrails absent from the artifact. See §11
//! of the spec for what is deliberately omitted.

pub mod auth;
pub mod book;
pub mod client;
pub mod config;
pub mod nonce_store;
pub mod order;
pub mod position;
pub mod runtime;
pub mod signer;
pub mod state_machine;

#[cfg(feature = "ws")]
pub mod user_ws;
#[cfg(feature = "ws")]
pub mod ws;

pub use config::{BotConfig, SpreadConfig, TradeSideMode};
pub use order::{ClobOrder, Side};
