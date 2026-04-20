//! TradingClient: cached signer + persistent nonce + HTTP.
//!
//! Source: FINAL_AUDIT §9. Mirrors the original's layout with
//! signer-derived maker at +0x1b8 and atomic nonce at +0x1a8,
//! except the nonce is persisted (see nonce_store.rs).

use std::path::PathBuf;
use std::sync::atomic::{AtomicU64, Ordering};
use std::sync::Arc;
use std::time::{Duration, Instant};

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
/// Carries the signed order plus auth ownership, time-in-force,
/// and the postOnly flag (py-clob-client always emits `false`).
#[derive(Serialize)]
struct OrderEnvelope<'a> {
    order: &'a SignedOrder,
    owner: &'a str,
    #[serde(rename = "orderType")]
    order_type: &'a str,
    #[serde(rename = "postOnly")]
    post_only: bool,
}

pub struct TradingClient {
    signer: Eip712Signer,
    raw_signer: alloy_signer_local::PrivateKeySigner,
    maker: Address,
    /// TRACING-ONLY request counter. NOT a trading nonce and NOT
    /// sent on the wire. The EIP-712 `order.nonce` field is pinned
    /// to 0 (CTF Exchange cancel nonce); this counter exists solely
    /// to correlate log lines across the sign/submit/response spans
    /// and for future local bookkeeping (e.g. cancel-all semantics).
    ///
    /// Deliberately NOT fsynced per submit — that flush was measured
    /// to cost 1–5ms median / 10–50ms p99 on EBS gp3 and sat in the
    /// critical path of every place_single_order. Losing this counter
    /// on crash has no protocol-visible effect.
    nonce: Arc<AtomicU64>,
    /// Retained for bootstrap-time load (historical watermark) and
    /// eventual background flush; not written on the hot path.
    _nonce_store: NonceStore,
    http: HttpClient,
    /// Pre-parsed POST /order URL. Saved ~1–2µs per submit and
    /// eliminates an allocation on the hot path.
    order_url: Url,
    book_cache: Arc<RwLock<BookSnapshot>>,
    dry_run: bool,
    fee_rate_bps: u32,
    /// Creds behind Arc so the hot path clones a pointer (8 bytes)
    /// rather than three Strings (api_key + secret + passphrase).
    creds: RwLock<Option<Arc<ApiCredentials>>>,
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
        // Safe, conservative HTTP tuning:
        //   - tcp_keepalive: keep idle sockets warm so we reuse the
        //     TLS+TCP+h2 session across submits (biggest win).
        //   - pool_idle_timeout: don't age out faster than keepalive.
        //   - pool_max_idle_per_host: small bound; we only talk to
        //     one host, so 8 is plenty.
        //   - connect_timeout: 5s so DNS/TLS hiccups surface fast.
        //
        // Deliberately NOT calling http2_prior_knowledge(). rustls
        // negotiates h2 via ALPN automatically for HTTPS, which is
        // what Polymarket advertises; forcing prior-knowledge would
        // skip TLS entirely and fail.
        let http = HttpClient::builder()
            .user_agent("arbigab-replica/0.1")
            .tcp_keepalive(Duration::from_secs(30))
            .pool_idle_timeout(Duration::from_secs(90))
            .pool_max_idle_per_host(8)
            .connect_timeout(Duration::from_secs(5))
            .build()?;
        let order_url = Url::parse(&format!("{CLOB_BASE}/order"))?;
        Ok(Self {
            signer,
            raw_signer,
            maker,
            nonce,
            _nonce_store: nonce_store,
            http,
            order_url,
            book_cache: Arc::new(RwLock::new(BookSnapshot::default())),
            dry_run,
            fee_rate_bps,
            creds: RwLock::new(None),
        })
    }

    /// Seed credentials directly (if you already have them from a
    /// previous bootstrap saved on disk).
    pub fn set_credentials(&self, creds: ApiCredentials) {
        *self.creds.write() = Some(Arc::new(creds));
    }

    /// L1 bootstrap — one-time. Hits /auth/api-key, stores the
    /// resulting credentials in memory. Returns them so the caller
    /// can also persist them to disk if desired.
    pub async fn bootstrap(&self) -> Result<ApiCredentials, ClientError> {
        let c = bootstrap_credentials(&self.http, &self.raw_signer)
            .await
            .map_err(|e| ClientError::Other(e.to_string()))?;
        *self.creds.write() = Some(Arc::new(c.clone()));
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

    /// Monotonic counter for correlating log spans within a single
    /// submit (sign → send → response). TRACING-ONLY: this value is
    /// NEVER written to the EIP-712 order or any wire payload. The
    /// on-disk NonceStore is no longer written per submit — see the
    /// struct doc on `nonce` for why.
    fn next_request_id(&self) -> u64 {
        self.nonce.fetch_add(1, Ordering::Relaxed) + 1
    }

    /// Fresh salt in the u64 range, matching py-clob-client. The
    /// order-api unmarshals salt into a Go int64, so a 256-bit
    /// value gets rejected as "Invalid order payload".
    fn fresh_salt() -> u64 {
        rand::thread_rng().next_u64() >> 1 // keep positive in i64 range
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
    ///
    /// Staged instrumentation emits a single `hotpath` tracing event
    /// per submit with µs/ms fields. The EIP-712 order.nonce is
    /// pinned to 0 (CTF Exchange cancel nonce); our in-memory
    /// request counter (`request_id`) is advanced for audit only,
    /// with no fsync on the hot path.
    pub async fn place_single_order(
        &self,
        token_id: U256,
        maker_amount: U256,
        taker_amount: U256,
        side: Side,
    ) -> Result<(), ClientError> {
        let request_id = self.next_request_id();
        let order = ClobOrder::new(
            Self::fresh_salt(),
            self.maker,
            token_id,
            maker_amount,
            taker_amount,
            U256::ZERO, // expiration=0 => GTC per Polymarket CLOB
            U256::ZERO, // order.nonce: CTF cancel nonce, not request counter
            U256::from(self.fee_rate_bps),
            side,
        );

        let t_sign = Instant::now();
        let sig = self
            .signer
            .sign_order(&order.to_eip712())
            .map_err(|e| ClientError::Sign(e.to_string()))?;
        let sign_us = t_sign.elapsed().as_micros() as u64;
        let signed = SignedOrder { order, signature: sig };

        if self.dry_run {
            let body = serde_json::to_string(&signed)
                .map_err(|e| ClientError::Other(e.to_string()))?;
            tracing::info!(target: "dry_run", "{body}");
            return Ok(());
        }

        // Arc<ApiCredentials>: clone is a pointer copy.
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
            post_only: false,
        };
        let body = serde_json::to_string(&envelope)
            .map_err(|e| ClientError::Other(e.to_string()))?;
        tracing::info!(target: "order_body", "{body}");
        let headers = l2_headers(
            self.maker,
            &creds,
            Self::now_ts(),
            "POST",
            "/order",
            &body,
        )
        .map_err(|e| ClientError::Other(e.to_string()))?;

        let mut req = self
            .http
            .post(self.order_url.clone())
            .header("Content-Type", "application/json")
            .body(body);
        for (k, v) in headers {
            req = req.header(k, v);
        }

        let t_submit = Instant::now();
        let resp = req.send().await?;
        let submit_ms = t_submit.elapsed().as_millis() as u64;
        let status = resp.status();

        // Phase-1 instrumentation: body drain is still INLINE (the
        // function does not return until the full response body is
        // read). Decoupling (return-after-headers + detached drain)
        // is a deliberate phase-2 change on the architecture-shift
        // branch, not here.
        let t_body = Instant::now();
        let body_text = resp.text().await.unwrap_or_default();
        let body_ms = t_body.elapsed().as_millis() as u64;

        tracing::info!(
            target: "hotpath",
            request_id,
            sign_us,
            submit_ms,   // send() -> status headers
            body_ms,     // headers -> full body drained
            status = %status,
            "submit complete"
        );

        if !status.is_success() {
            return Err(ClientError::Other(
                format!("CLOB {status}: {body_text}"),
            ));
        }
        tracing::info!(target: "order_response", status = %status, body = %body_text);
        Ok(())
    }
}
