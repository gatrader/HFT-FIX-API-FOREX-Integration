//! TradingClient: cached signer + persistent nonce + HTTP.
//!
//! Source: FINAL_AUDIT §9. Mirrors the original's layout with
//! signer-derived maker at +0x1b8 and atomic nonce at +0x1a8,
//! except the nonce is persisted (see nonce_store.rs).

use std::path::PathBuf;
use std::sync::atomic::{AtomicU64, Ordering};
use std::sync::Arc;
use std::time::{SystemTime, UNIX_EPOCH};

use alloy_primitives::{Address, U256};
use parking_lot::RwLock;
use rand::RngCore;
use reqwest::{Client as HttpClient, Url};
use serde::Serialize;

use crate::book::BookSnapshot;
use crate::nonce_store::NonceStore;
use crate::order::{ClobOrder, Side};
use crate::signer::Eip712Signer;

pub const CLOB_BASE: &str = "https://clob.polymarket.com";
pub const EXPIRATION_WINDOW_SECS: u64 = 60;

#[derive(Debug, thiserror::Error)]
pub enum ClientError {
    #[error("http: {0}")]
    Http(#[from] reqwest::Error),
    #[error("url: {0}")]
    Url(#[from] url::ParseError),
    #[error("sign: {0}")]
    Sign(String),
    #[error("io: {0}")]
    Io(#[from] std::io::Error),
    #[error("{0}")]
    Other(String),
}

impl From<anyhow::Error> for ClientError {
    fn from(e: anyhow::Error) -> Self {
        ClientError::Other(e.to_string())
    }
}

#[derive(Clone, Serialize)]
pub struct SignedOrder {
    #[serde(flatten)]
    pub order: ClobOrder,
    pub signature: String,
}

pub struct TradingClient {
    signer: Eip712Signer,
    maker: Address,
    nonce: Arc<AtomicU64>,
    nonce_store: NonceStore,
    http: HttpClient,
    book_cache: Arc<RwLock<BookSnapshot>>,
    dry_run: bool,
    fee_rate_bps: u32,
}

impl TradingClient {
    pub fn new(
        hex_key: &str,
        nonce_path: PathBuf,
        dry_run: bool,
        fee_rate_bps: u32,
    ) -> anyhow::Result<Self> {
        let signer = Eip712Signer::from_hex(hex_key)?;
        let maker = signer.maker();
        let nonce_store = NonceStore::open(nonce_path)?;
        let nonce = Arc::new(AtomicU64::new(nonce_store.load()));
        let http = HttpClient::builder()
            .user_agent("arbigab-replica/0.1")
            .build()?;
        Ok(Self {
            signer,
            maker,
            nonce,
            nonce_store,
            http,
            book_cache: Arc::new(RwLock::new(BookSnapshot::default())),
            dry_run,
            fee_rate_bps,
        })
    }

    pub fn maker(&self) -> Address {
        self.maker
    }

    pub fn book_cache(&self) -> Arc<RwLock<BookSnapshot>> {
        self.book_cache.clone()
    }

    fn next_nonce(&self) -> anyhow::Result<u64> {
        let n = self.nonce.fetch_add(1, Ordering::SeqCst) + 1;
        self.nonce_store.record(n)?;
        Ok(n)
    }

    fn fresh_salt() -> U256 {
        let mut buf = [0u8; 32];
        rand::thread_rng().fill_bytes(&mut buf);
        U256::from_be_bytes(buf)
    }

    fn expiration(&self) -> U256 {
        let now = SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .map(|d| d.as_secs())
            .unwrap_or(0);
        U256::from(now + EXPIRATION_WINDOW_SECS)
    }

    pub async fn fetch_book(&self, token_id: &str) -> Result<(), ClientError> {
        let url = Url::parse(&format!("{CLOB_BASE}/book"))?;
        let snap: BookSnapshot = self
            .http
            .get(url)
            .query(&[("token_id", token_id)])
            .send()
            .await?
            .error_for_status()?
            .json()
            .await?;
        *self.book_cache.write() = snap;
        Ok(())
    }

    /// place_single_order (FINAL_AUDIT §9).
    pub async fn place_single_order(
        &self,
        token_id: U256,
        maker_amount: U256,
        taker_amount: U256,
        side: Side,
    ) -> Result<(), ClientError> {
        let order = ClobOrder::new(
            Self::fresh_salt(),
            self.maker,
            token_id,
            maker_amount,
            taker_amount,
            self.expiration(),
            U256::from(self.next_nonce()?),
            U256::from(self.fee_rate_bps),
            side,
        );
        let sig = self
            .signer
            .sign_order(&order.to_eip712())
            .map_err(|e| ClientError::Sign(e.to_string()))?;
        let signed = SignedOrder { order, signature: sig };

        if self.dry_run {
            tracing::info!(
                target: "dry_run",
                "{}",
                serde_json::to_string(&signed)
                    .unwrap_or_else(|_| "<ser fail>".into())
            );
            return Ok(());
        }

        let url = Url::parse(&format!("{CLOB_BASE}/data/orders"))?;
        let resp = self.http.post(url).json(&signed).send().await?;
        resp.error_for_status()?;
        Ok(())
    }
}
