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

use crate::auth::{bootstrap_credentials, l2_headers, ApiCredentials};
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

/// Outer envelope for POST /order (Polymarket CLOB).
/// Carries the signed order plus auth ownership + time-in-force.
#[derive(Serialize)]
struct OrderEnvelope<'a> {
    order: &'a SignedOrder,
    owner: &'a str,
    #[serde(rename = "orderType")]
    order_type: &'a str,
}

pub struct TradingClient {
    signer: Eip712Signer,
    raw_signer: alloy_signer_local::PrivateKeySigner,
    maker: Address,
    nonce: Arc<AtomicU64>,
    nonce_store: NonceStore,
    http: HttpClient,
    book_cache: Arc<RwLock<BookSnapshot>>,
    dry_run: bool,
    fee_rate_bps: u32,
    creds: RwLock<Option<ApiCredentials>>,
}

impl TradingClient {
    pub fn new(
        hex_key: &str,
        nonce_path: PathBuf,
        dry_run: bool,
        fee_rate_bps: u32,
    ) -> anyhow::Result<Self> {
        let signer = Eip712Signer::from_hex(hex_key)?;
        let raw_signer: alloy_signer_local::PrivateKeySigner =
            hex_key.parse()?;
        let maker = signer.maker();
        let nonce_store = NonceStore::open(nonce_path)?;
        let nonce = Arc::new(AtomicU64::new(nonce_store.load()));
        let http = HttpClient::builder()
            .user_agent("arbigab-replica/0.1")
            .build()?;
        Ok(Self {
            signer,
            raw_signer,
            maker,
            nonce,
            nonce_store,
            http,
            book_cache: Arc::new(RwLock::new(BookSnapshot::default())),
            dry_run,
            fee_rate_bps,
            creds: RwLock::new(None),
        })
    }

    /// Seed credentials directly (if you already have them from a
    /// previous bootstrap saved on disk).
    pub fn set_credentials(&self, creds: ApiCredentials) {
        *self.creds.write() = Some(creds);
    }

    /// L1 bootstrap — one-time. Hits /auth/api-key, stores the
    /// resulting credentials in memory. Returns them so the caller
    /// can also persist them to disk if desired.
    pub async fn bootstrap(&self) -> Result<ApiCredentials, ClientError> {
        let c = bootstrap_credentials(&self.http, &self.raw_signer)
            .await
            .map_err(|e| ClientError::Other(e.to_string()))?;
        *self.creds.write() = Some(c.clone());
        Ok(c)
    }

    fn now_ts() -> i64 {
        chrono::Utc::now().timestamp()
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
        // Record a monotonic request-tracking nonce for our own
        // audit trail, but the EIP-712 order.nonce field is the
        // on-chain CTF Exchange cancel nonce — always 0 for a
        // regular order (Polymarket convention).
        let _req_nonce = self.next_nonce()?;
        let order = ClobOrder::new(
            Self::fresh_salt(),
            self.maker,
            token_id,
            maker_amount,
            taker_amount,
            self.expiration(),
            U256::ZERO,
            U256::from(self.fee_rate_bps),
            side,
        );
        let sig = self
            .signer
            .sign_order(&order.to_eip712())
            .map_err(|e| ClientError::Sign(e.to_string()))?;
        let signed = SignedOrder { order, signature: sig };

        if self.dry_run {
            let body = serde_json::to_string(&signed)
                .map_err(|e| ClientError::Other(e.to_string()))?;
            tracing::info!(target: "dry_run", "{body}");
            return Ok(());
        }

        let path = "/order";
        let url = Url::parse(&format!("{CLOB_BASE}{path}"))?;
        let creds = self
            .creds
            .read()
            .clone()
            .ok_or_else(|| ClientError::Other(
                "no API credentials — call bootstrap() or set_credentials() first"
                    .into(),
            ))?;
        let envelope = OrderEnvelope {
            order: &signed,
            owner: &creds.api_key,
            order_type: "GTC",
        };
        let body = serde_json::to_string(&envelope)
            .map_err(|e| ClientError::Other(e.to_string()))?;
        tracing::info!(target: "order_body", "{body}");
        let headers = l2_headers(
            self.maker,
            &creds,
            Self::now_ts(),
            "POST",
            path,
            &body,
        )
        .map_err(|e| ClientError::Other(e.to_string()))?;

        let mut req = self
            .http
            .post(url)
            .header("Content-Type", "application/json")
            .body(body);
        for (k, v) in headers {
            req = req.header(k, v);
        }
        let resp = req.send().await?;
        let status = resp.status();
        let body_text = resp.text().await.unwrap_or_default();
        if !status.is_success() {
            return Err(ClientError::Other(
                format!("CLOB {status}: {body_text}"),
            ));
        }
        tracing::info!(target: "order_response", status = %status, body = %body_text);
        Ok(())
    }
}
