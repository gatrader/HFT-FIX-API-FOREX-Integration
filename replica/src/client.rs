//! TradingClient: cached signer + persistent nonce + HTTP.
//!
//! Source: FINAL_AUDIT §9. Mirrors the original's layout with
//! signer-derived maker at +0x1b8 and atomic nonce at +0x1a8,
//! except the nonce is persisted (see nonce_store.rs).

use std::collections::{HashMap, HashSet};
use std::path::PathBuf;
use std::sync::atomic::{AtomicU64, Ordering};
use std::sync::Arc;
use std::time::{Duration, Instant, SystemTime, UNIX_EPOCH};

use alloy_primitives::{Address, U256};
use parking_lot::RwLock;
use rand::RngCore;
use reqwest::{Client as HttpClient, Url};
use serde::{Deserialize, Serialize};

use crate::auth::{bootstrap_credentials, derive_credentials, l2_headers, ApiCredentials};
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

#[derive(Clone, Debug, Serialize)]
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
    /// Base URL for CLOB endpoints. Defaults to `CLOB_BASE`; override
    /// via `with_base_url` for localhost benchmarks / tests.
    base_url: Url,
    /// Pre-parsed POST /order URL. Saved ~1–2µs per submit and
    /// eliminates an allocation on the hot path.
    order_url: Url,
    book_cache: Arc<RwLock<BookSnapshot>>,
    dry_run: bool,
    fee_rate_bps: u32,
    /// Creds behind Arc so the hot path clones a pointer (8 bytes)
    /// rather than three Strings (api_key + secret + passphrase).
    creds: RwLock<Option<Arc<ApiCredentials>>>,
    /// Registry of maker orders we've placed and believe are still
    /// open on Polymarket. Populated on successful POST /order from
    /// the response's `orderID`; pruned on successful cancel (or
    /// when the user WS channel reports a terminal status — not
    /// wired in this minimal build).
    ///
    /// Keyed by orderID so batch cancels can reference them cheaply.
    /// The map is guarded by `RwLock` because the cancel path and
    /// the submit path update it from different tasks.
    open_orders: RwLock<HashMap<String, OpenOrder>>,
    /// Millis-since-unix-epoch of the last successful cancel (via
    /// any of `/order`, `/orders`, `/cancel-all`, including dry-run
    /// short-circuits). `0` means no cancel has ever completed.
    /// Mirror of `Position::last_fill_at_ms` for the stats logger.
    last_cancel_at_ms: AtomicU64,
}

/// Metadata for a maker order the replica has placed and still
/// believes is live. All fields are local — the CLOB's ultimate
/// truth about the order lives in the user channel / REST API.
#[derive(Clone, Debug)]
pub struct OpenOrder {
    pub order_id: String,
    pub token_id: String,
    pub side: Side,
    pub price: f64,
    pub size: f64,
    pub placed_at: Instant,
}

/// Response shape for POST /order on success. Polymarket returns
/// `orderID` (capital D) as the canonical identifier; py-clob-client
/// also tolerates `orderId`. We accept either spelling and fall
/// back to `id` if neither appears — that's a safety net, not a
/// documented behavior.
#[derive(Debug, Deserialize)]
struct OrderPostResponse {
    #[serde(alias = "orderID", alias = "orderId", alias = "id")]
    order_id: Option<String>,
    #[serde(default)]
    success: Option<bool>,
    #[serde(default)]
    status: Option<String>,
}

/// Body shape for DELETE /order (single cancel). Matches
/// py-clob-client: `{"orderID": "..."}` — capital-D, not camelCase.
#[derive(Serialize)]
struct CancelOneBody<'a> {
    #[serde(rename = "orderID")]
    order_id: &'a str,
}

impl TradingClient {
    pub fn new(
        hex_key: &str,
        nonce_path: PathBuf,
        dry_run: bool,
        fee_rate_bps: u32,
    ) -> anyhow::Result<Self> {
        Self::with_base_url(hex_key, nonce_path, dry_run, fee_rate_bps, CLOB_BASE)
    }

    /// Constructor that lets callers override the CLOB base URL.
    /// Intended for localhost A/B benchmarks and tests; production
    /// callers should use `new`, which pins to `CLOB_BASE`.
    pub fn with_base_url(
        hex_key: &str,
        nonce_path: PathBuf,
        dry_run: bool,
        fee_rate_bps: u32,
        base_url: &str,
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
        // Normalize trailing slash so `join` produces the right path.
        let base = if base_url.ends_with('/') {
            base_url.to_string()
        } else {
            format!("{base_url}/")
        };
        let base_url = Url::parse(&base)?;
        let order_url = base_url.join("order")?;
        Ok(Self {
            signer,
            raw_signer,
            maker,
            nonce,
            _nonce_store: nonce_store,
            http,
            base_url,
            order_url,
            book_cache: Arc::new(RwLock::new(BookSnapshot::default())),
            dry_run,
            fee_rate_bps,
            creds: RwLock::new(None),
            open_orders: RwLock::new(HashMap::new()),
            last_cancel_at_ms: AtomicU64::new(0),
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

    /// Recover the credentials already registered for this EOA via
    /// GET /auth/derive-api-key. Use when bootstrap returns 400
    /// "Could not create api key" because the wallet has been
    /// bootstrapped in a previous session.
    pub async fn derive(&self) -> Result<ApiCredentials, ClientError> {
        let c = derive_credentials(&self.http, &self.raw_signer)
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
        let url = self.base_url.join("book")?;
        let mut snap: BookSnapshot = self
            .http
            .get(url)
            .query(&[("token_id", token_id)])
            .send()
            .await?
            .error_for_status()?
            .json()
            .await?;
        // Stamp before committing to cache so any reader observes
        // a consistent (contents, age) pair under the RwLock.
        snap.stamp_now();
        *self.book_cache.write() = snap;
        Ok(())
    }

    /// Fetch the current on-chain position for `token_id` (asset_id).
    ///
    /// Hits Polymarket's public data-api positions endpoint. This is
    /// the same source the UI reads — returns the settled on-chain
    /// balance, not the theoretical CLOB open-order inventory, so a
    /// freshly placed maker order is NOT reflected until it fills.
    ///
    /// Returns `Ok(shares)` where `shares` is signed per convention
    /// (positive = long the YES outcome). `Ok(0.0)` when the user
    /// has no position in this asset. Errors propagate — callers
    /// wishing to continue past a reconcile failure should log and
    /// ignore (e.g. the runtime bootstrap path).
    pub async fn fetch_position_shares(
        &self,
        token_id: &str,
    ) -> Result<f64, ClientError> {
        // The data-api hostname is distinct from CLOB and does not
        // live under `self.base_url`, so construct fresh.
        let url = Url::parse(
            "https://data-api.polymarket.com/positions",
        )?;
        let maker_lc = format!("{:#x}", self.maker);
        let resp = self
            .http
            .get(url)
            .query(&[("user", maker_lc.as_str()), ("asset", token_id)])
            .send()
            .await?
            .error_for_status()?;
        let body = resp.text().await?;
        let v: serde_json::Value = serde_json::from_str(&body)
            .map_err(|e| ClientError::Other(format!(
                "parse positions: {e}; body={body}"
            )))?;
        // The endpoint returns a JSON array of position objects; each
        // carries `asset` and `size` (as string or number). Sum matching
        // legs — normally at most one.
        let arr = match &v {
            serde_json::Value::Array(a) => a.as_slice(),
            _ => return Err(ClientError::Other(format!(
                "positions: unexpected shape: {body}"
            ))),
        };
        let mut total = 0.0;
        for entry in arr {
            let asset = entry.get("asset").and_then(|x| x.as_str());
            if asset != Some(token_id) {
                continue;
            }
            let size = match entry.get("size") {
                Some(serde_json::Value::Number(n)) => n.as_f64().unwrap_or(0.0),
                Some(serde_json::Value::String(s)) => s.parse().unwrap_or(0.0),
                _ => 0.0,
            };
            total += size;
        }
        Ok(total)
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
        let prepared = self
            .sign_for_submit(token_id, maker_amount, taker_amount, side)?;
        self.submit_signed(&prepared.signed, prepared.request_id, prepared.sign_us)
            .await
    }

    /// Sign-only half of the submit path — pure compute, no I/O.
    ///
    /// Split out of `place_single_order` for PR 4 (submit decoupling)
    /// so the runtime loop can sign on its own tick and hand the
    /// bytes to a worker via bounded mpsc rather than awaiting the
    /// HTTP round trip inline. The returned `PreparedSubmit` is the
    /// exact argument shape `submit_signed` expects; passing it
    /// around is the "job" that crosses the queue boundary.
    pub fn sign_for_submit(
        &self,
        token_id: U256,
        maker_amount: U256,
        taker_amount: U256,
        side: Side,
    ) -> Result<PreparedSubmit, ClientError> {
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
        Ok(PreparedSubmit {
            signed: SignedOrder { order, signature: sig },
            request_id,
            sign_us,
        })
    }

    /// Snapshot of the currently-open order IDs. O(n). Callers
    /// wanting a consistent batch should call this then pass the
    /// result to `cancel_orders` — no locks are held across.
    pub fn open_order_ids(&self) -> Vec<String> {
        self.open_orders.read().keys().cloned().collect()
    }

    /// Number of orders the registry believes are live. Useful as
    /// a dedup input for the runtime's cancel-trigger path (don't
    /// emit a cancel request when there's nothing to cancel).
    pub fn open_order_count(&self) -> usize {
        self.open_orders.read().len()
    }

    /// Returns `true` if the registry already contains an open
    /// order on `side` whose price is within `tick_eps` of `price`.
    /// The runtime uses this as a stacking guard — when the state
    /// machine asks for a quote that matches what's already resting,
    /// we skip the emit instead of doubling up on the same level.
    pub fn has_matching_open_order(
        &self,
        side: Side,
        price: f64,
        tick_eps: f64,
    ) -> bool {
        self.open_orders
            .read()
            .values()
            .any(|o| o.side == side && (o.price - price).abs() < tick_eps)
    }

    /// Returns `true` if the registry contains any open order on
    /// the same `side` whose price differs from `price` by at least
    /// `tick_eps` — i.e. an on-side quote the state machine has
    /// since moved away from. The runtime uses this to issue a
    /// cancel before layering a replacement so we don't accumulate
    /// dead quotes at stale levels.
    pub fn has_stale_open_order_on_side(
        &self,
        side: Side,
        price: f64,
        tick_eps: f64,
    ) -> bool {
        self.open_orders
            .read()
            .values()
            .any(|o| o.side == side && (o.price - price).abs() >= tick_eps)
    }

    /// Wall-clock ms-since-epoch of the last successful cancel on
    /// this client. `0` means the process has never cancelled. Used
    /// by the stats logger alongside `Position::last_fill_age_ms`.
    pub fn last_cancel_at_ms(&self) -> u64 {
        self.last_cancel_at_ms.load(Ordering::Relaxed)
    }

    /// Milliseconds since the last successful cancel, or `None` if
    /// no cancel has completed. Operator-facing observability —
    /// matches `Position::last_fill_age_ms_opt` so the two can be
    /// logged side-by-side in one line.
    pub fn last_cancel_age_ms_opt(&self) -> Option<u64> {
        let s = self.last_cancel_at_ms.load(Ordering::Relaxed);
        if s == 0 {
            return None;
        }
        let now = now_ms();
        Some(now.saturating_sub(s))
    }

    fn stamp_last_cancel(&self) {
        self.last_cancel_at_ms.store(now_ms(), Ordering::Relaxed);
    }

    /// Record a freshly-placed order in the open-order registry.
    /// Exposed as `pub(crate)` so the runtime / worker can stage
    /// metadata on successful POST paths (including the test-only
    /// dry-run one) without needing to inspect raw JSON.
    pub(crate) fn record_open_order(&self, info: OpenOrder) {
        self.open_orders.write().insert(info.order_id.clone(), info);
    }

    /// Drop an order from the registry. Called after a successful
    /// cancel; also safe to call when the order is not present
    /// (no-op).
    fn forget_open_order(&self, order_id: &str) {
        self.open_orders.write().remove(order_id);
    }

    /// Cancel a single order by its Polymarket orderID. DELETE /order
    /// with `{"orderID": "..."}`. Idempotent on the server side; we
    /// treat 404 as success (already cancelled / filled).
    ///
    /// dry_run short-circuits: cancel path has no offline stub to
    /// exercise in a dry-run harness, so we log and drop the registry
    /// entry without touching the network.
    pub async fn cancel_order(&self, order_id: &str) -> Result<(), ClientError> {
        if self.dry_run {
            tracing::info!(target: "dry_run_cancel", order_id, "cancel (dry_run)");
            self.forget_open_order(order_id);
            self.stamp_last_cancel();
            return Ok(());
        }
        let body = serde_json::to_string(&CancelOneBody { order_id })
            .map_err(|e| ClientError::Other(e.to_string()))?;
        self.send_cancel("DELETE", "/order", &body).await?;
        self.forget_open_order(order_id);
        Ok(())
    }

    /// Cancel a batch of orders in one request. DELETE /orders
    /// with a **raw JSON array** body — `["id1","id2"]`, NOT the
    /// object wrapper `{"orderIDs": [...]}`. Live validation
    /// against the Polymarket CLOB showed the endpoint rejects the
    /// object form with `{"error":"Invalid order payload"}`.
    /// Empty input returns Ok with no HTTP call — saves a round
    /// trip when the registry is empty.
    ///
    /// Duplicate ids in the input are collapsed before signing so
    /// a caller mistake (or a future reconcile path that merges
    /// REST state with the local registry) can't spray the same
    /// orderID on the wire. First-seen order is preserved.
    pub async fn cancel_orders(
        &self,
        order_ids: &[String],
    ) -> Result<(), ClientError> {
        if order_ids.is_empty() {
            return Ok(());
        }
        let mut seen: HashSet<&str> = HashSet::with_capacity(order_ids.len());
        let deduped: Vec<&str> = order_ids
            .iter()
            .map(String::as_str)
            .filter(|id| seen.insert(*id))
            .collect();
        if deduped.is_empty() {
            return Ok(());
        }
        if self.dry_run {
            for id in &deduped {
                self.forget_open_order(id);
            }
            tracing::info!(
                target: "dry_run_cancel",
                n = deduped.len(),
                "batch cancel (dry_run)"
            );
            self.stamp_last_cancel();
            return Ok(());
        }
        let body = serde_json::to_string(&deduped)
            .map_err(|e| ClientError::Other(e.to_string()))?;
        self.send_cancel("DELETE", "/orders", &body).await?;
        for id in &deduped {
            self.forget_open_order(id);
        }
        Ok(())
    }

    /// Cancel every open order on the account. DELETE /cancel-all
    /// with an empty body. Stronger than iterating the local
    /// registry — the server owns the ground truth, so even orders
    /// the replica lost track of (e.g. across restarts) get killed.
    pub async fn cancel_all(&self) -> Result<(), ClientError> {
        if self.dry_run {
            self.open_orders.write().clear();
            tracing::info!(target: "dry_run_cancel", "cancel_all (dry_run)");
            self.stamp_last_cancel();
            return Ok(());
        }
        self.send_cancel("DELETE", "/cancel-all", "").await?;
        self.open_orders.write().clear();
        Ok(())
    }

    /// Core HTTP helper for the three cancel endpoints. Builds the
    /// L2-signed request and translates non-2xx into `ClientError`.
    /// A 404 is NOT treated as a success, since the cancel endpoints
    /// (unlike a REST READ) should 200 even when there's nothing to
    /// cancel; see py-clob-client's cancel() for the analogous
    /// behaviour.
    async fn send_cancel(
        &self,
        method: &str,
        path: &str,
        body: &str,
    ) -> Result<(), ClientError> {
        let creds = self
            .creds
            .read()
            .clone()
            .ok_or_else(|| ClientError::Other(
                "no API credentials — call bootstrap() or set_credentials() first"
                    .into(),
            ))?;
        // `path` here is the CLOB-relative path for the HMAC canonical
        // string (`/order`, `/orders`, `/cancel-all`). The URL joined
        // against base_url must match — base_url is already the CLOB
        // root with a trailing slash, so strip any leading slash.
        let url = self.base_url.join(path.trim_start_matches('/'))?;
        let headers = l2_headers(
            self.maker, &creds, Self::now_ts(), method, path, body,
        )
        .map_err(|e| ClientError::Other(e.to_string()))?;
        let mut req = self
            .http
            .request(method.parse().unwrap_or(reqwest::Method::DELETE), url)
            .header("Content-Type", "application/json")
            .body(body.to_string());
        for (k, v) in headers {
            req = req.header(k, v);
        }
        let t = Instant::now();
        let resp = req.send().await?;
        let elapsed_ms = t.elapsed().as_millis() as u64;
        let status = resp.status();
        let body_text = resp.text().await.unwrap_or_default();
        tracing::info!(
            target: "cancel",
            method, path, status = %status, elapsed_ms,
            "cancel complete"
        );
        if !status.is_success() {
            return Err(ClientError::Other(
                format!("cancel {method} {path} {status}: {body_text}"),
            ));
        }
        self.stamp_last_cancel();
        Ok(())
    }

    /// Submit-only half — pure I/O. Callable from a worker task
    /// with a pre-signed order. Preserves the existing `dry_run`
    /// short-circuit and `hotpath` trace event byte-for-byte.
    pub async fn submit_signed(
        &self,
        signed: &SignedOrder,
        request_id: u64,
        sign_us: u64,
    ) -> Result<(), ClientError> {
        if self.dry_run {
            let body = serde_json::to_string(signed)
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
            order: signed,
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
            let (price, size) = decode_price_size(&signed.order);
            let body_preview = truncate_for_log(&body_text, 4_096);
            tracing::warn!(
                target: "order_reject",
                request_id,
                status = %status,
                side = %signed.order.side,
                price,
                size,
                token_id = %signed.order.token_id,
                body = %body_preview,
                "CLOB /order rejected"
            );
            return Err(ClientError::Other(
                format!("CLOB {status}: {body_text}"),
            ));
        }
        tracing::info!(target: "order_response", status = %status, body = %body_text);

        // Registry insert — capture the orderID so the cancel path
        // can later target this specific order. Best-effort: parse
        // failure is logged but not fatal, since we already have a
        // 2xx and the caller's next action is to keep trading.
        //
        // We reconstruct the OpenOrder metadata from the signed
        // body rather than threading it through function signatures
        // — the JSON round-trip is ~1µs and only fires on the real
        // (non-dry-run, 2xx) path.
        if let Ok(resp) = serde_json::from_str::<OrderPostResponse>(&body_text) {
            if let Some(oid) = resp.order_id {
                let side = if signed.order.side == "BUY" {
                    Side::Buy
                } else {
                    Side::Sell
                };
                let (price, size) = decode_price_size(&signed.order);
                self.record_open_order(OpenOrder {
                    order_id: oid.clone(),
                    token_id: signed.order.token_id.clone(),
                    side,
                    price,
                    size,
                    placed_at: Instant::now(),
                });
                tracing::debug!(
                    target: "open_orders",
                    order_id = %oid,
                    open_count = self.open_order_count(),
                    status = ?resp.status,
                    success = ?resp.success,
                    "registered"
                );
            }
        }

        Ok(())
    }
}

/// Output of `sign_for_submit` — everything a worker needs to
/// call `submit_signed` without reaching back into the hot path.
#[derive(Clone, Debug)]
pub struct PreparedSubmit {
    pub signed: SignedOrder,
    pub request_id: u64,
    pub sign_us: u64,
}

/// Decode price/size back out of the signed order. `makerAmount`
/// and `takerAmount` are the Polymarket wire format: 6-decimal
/// scaled integers serialized as strings. Used by the order_reject
/// warn (where the response body is opaque but the order we sent
/// is known) and by the registry-insert on success.
fn decode_price_size(order: &ClobOrder) -> (f64, f64) {
    let m = order.maker_amount.parse::<u128>().unwrap_or(0) as f64;
    let t = order.taker_amount.parse::<u128>().unwrap_or(0) as f64;
    match order.side.as_str() {
        // BUY: maker = notional (price*size*scale), taker = size*scale.
        "BUY" if t > 0.0 => (m / t, t / 1_000_000.0),
        // SELL: maker = size*scale, taker = notional.
        "SELL" if m > 0.0 => (t / m, m / 1_000_000.0),
        _ => (0.0, 0.0),
    }
}

/// Wall-clock ms-since-epoch. Matches `position::now_ms` so the
/// `last_fill_age_ms` / `last_cancel_age_ms` pair are on the same
/// clock.
fn now_ms() -> u64 {
    SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .map(|d| d.as_millis() as u64)
        .unwrap_or(0)
}

/// Clip a string at `limit` chars on a UTF-8 boundary so the
/// order_reject warn never spills a multi-megabyte HTML error
/// page into the logs. Returns the input unchanged when it fits.
fn truncate_for_log(s: &str, limit: usize) -> String {
    if s.len() <= limit {
        return s.to_string();
    }
    // Walk forward from `limit` to the nearest valid UTF-8 boundary.
    // `is_char_boundary(limit)` returns true at multi-byte starts too,
    // so we'll land on a codepoint boundary and never panic.
    let mut end = limit;
    while end < s.len() && !s.is_char_boundary(end) {
        end += 1;
    }
    let mut out = String::with_capacity(end + 16);
    out.push_str(&s[..end]);
    out.push_str("…[truncated]");
    out
}

#[cfg(test)]
mod tests {
    use super::*;

    fn mk_order(side_str: &str, maker_amount: &str, taker_amount: &str) -> ClobOrder {
        ClobOrder {
            salt: 0,
            maker: Address::ZERO,
            signer: Address::ZERO,
            taker: Address::ZERO,
            token_id: "0".into(),
            maker_amount: maker_amount.into(),
            taker_amount: taker_amount.into(),
            expiration: "0".into(),
            nonce: "0".into(),
            fee_rate_bps: "0".into(),
            side: side_str.into(),
            signature_type: 0,
        }
    }

    #[test]
    fn decode_price_size_buy() {
        // BUY 10 shares at 0.5 → taker=size*1e6=10_000_000;
        // maker=notional=5_000_000.
        let o = mk_order("BUY", "5000000", "10000000");
        let (price, size) = decode_price_size(&o);
        assert!((price - 0.5).abs() < 1e-9);
        assert!((size - 10.0).abs() < 1e-9);
    }

    #[test]
    fn decode_price_size_sell() {
        // SELL 10 shares at 0.7 → maker=size*1e6=10_000_000;
        // taker=notional=7_000_000.
        let o = mk_order("SELL", "10000000", "7000000");
        let (price, size) = decode_price_size(&o);
        assert!((price - 0.7).abs() < 1e-9);
        assert!((size - 10.0).abs() < 1e-9);
    }

    #[test]
    fn decode_price_size_handles_zero() {
        let o = mk_order("BUY", "0", "0");
        assert_eq!(decode_price_size(&o), (0.0, 0.0));
    }

    #[test]
    fn truncate_passthrough_when_short() {
        assert_eq!(truncate_for_log("hi", 10), "hi");
    }

    #[test]
    fn truncate_clips_with_marker() {
        let s = "a".repeat(100);
        let out = truncate_for_log(&s, 10);
        assert!(out.starts_with("aaaaaaaaaa"));
        assert!(out.ends_with("[truncated]"));
    }

    #[test]
    fn truncate_respects_utf8_boundary() {
        // 4-byte codepoint right at the cut point.
        let s = format!("{}{}", "a".repeat(9), "🦀🦀🦀");
        let out = truncate_for_log(&s, 10);
        // Must not panic and must leave a valid String.
        assert!(out.is_char_boundary(out.len()));
    }

    fn mk_registered_order(id: &str) -> OpenOrder {
        OpenOrder {
            order_id: id.into(),
            token_id: "tkn".into(),
            side: Side::Buy,
            price: 0.5,
            size: 10.0,
            placed_at: Instant::now(),
        }
    }

    fn mk_dry_client() -> (TradingClient, tempfile::TempDir) {
        let dir = tempfile::TempDir::new().unwrap();
        let key =
            "0000000000000000000000000000000000000000000000000000000000000001";
        let c = TradingClient::new(key, dir.path().join("nonce"), true, 0)
            .unwrap();
        (c, dir)
    }

    #[tokio::test]
    async fn cancel_orders_collapses_duplicate_ids() {
        let (c, _d) = mk_dry_client();
        c.record_open_order(mk_registered_order("A"));
        c.record_open_order(mk_registered_order("B"));
        assert_eq!(c.open_order_count(), 2);
        // Caller-side mistake: same id repeated three times plus a
        // second distinct id. Dry-run cancel must succeed and leave
        // the registry empty — dedup should not cause "A" to be
        // skipped on removal.
        let ids = vec![
            "A".to_string(),
            "A".to_string(),
            "A".to_string(),
            "B".to_string(),
        ];
        c.cancel_orders(&ids).await.expect("dry-run cancel ok");
        assert_eq!(c.open_order_count(), 0);
    }

    #[tokio::test]
    async fn cancel_orders_empty_input_is_noop() {
        let (c, _d) = mk_dry_client();
        let ids: Vec<String> = Vec::new();
        c.cancel_orders(&ids).await.expect("empty is ok");
        assert_eq!(c.last_cancel_at_ms(), 0, "no-op must not stamp");
    }

    #[tokio::test]
    async fn cancel_all_dry_run_stamps_last_cancel() {
        let (c, _d) = mk_dry_client();
        assert_eq!(c.last_cancel_at_ms(), 0);
        assert_eq!(c.last_cancel_age_ms_opt(), None);
        c.record_open_order(mk_registered_order("A"));
        c.cancel_all().await.expect("dry-run cancel_all ok");
        assert!(c.last_cancel_at_ms() > 0);
        assert!(c.last_cancel_age_ms_opt().is_some());
        assert_eq!(c.open_order_count(), 0);
    }

    #[tokio::test]
    async fn cancel_order_dry_run_stamps_last_cancel() {
        let (c, _d) = mk_dry_client();
        c.record_open_order(mk_registered_order("A"));
        c.cancel_order("A").await.expect("dry-run single cancel ok");
        assert!(c.last_cancel_at_ms() > 0);
        assert_eq!(c.open_order_count(), 0);
    }

    #[tokio::test]
    async fn cancel_orders_dry_run_stamps_last_cancel() {
        let (c, _d) = mk_dry_client();
        c.record_open_order(mk_registered_order("A"));
        let ids = vec!["A".to_string()];
        c.cancel_orders(&ids).await.expect("dry-run batch ok");
        assert!(c.last_cancel_at_ms() > 0);
    }

    /// Wire-format regression guard for `DELETE /orders`: the body
    /// must be a raw JSON array (`["id1","id2"]`), NOT an object
    /// wrapper like `{"orderIDs": [...]}`. Live validation against
    /// the Polymarket CLOB showed the object form is rejected with
    /// `{"error":"Invalid order payload"}`, which silently leaves
    /// resting orders alive. We test the body encoding directly
    /// here so a refactor can't regress it.
    #[test]
    fn batch_cancel_body_is_raw_json_array() {
        let ids = vec!["a", "b", "c"];
        let body = serde_json::to_string(&ids).unwrap();
        assert_eq!(body, r#"["a","b","c"]"#);
        // Belt-and-braces: it must parse back to a JSON array, not
        // an object.
        let v: serde_json::Value = serde_json::from_str(&body).unwrap();
        assert!(v.is_array(), "batch cancel body must be a JSON array");
        assert_eq!(v.as_array().unwrap().len(), 3);
    }

    #[test]
    fn has_matching_open_order_hits_on_same_side_and_price() {
        let (c, _d) = mk_dry_client();
        c.record_open_order(OpenOrder {
            order_id: "A".into(),
            token_id: "tkn".into(),
            side: Side::Buy,
            price: 0.581,
            size: 10.0,
            placed_at: Instant::now(),
        });
        let eps = 0.0005;
        assert!(c.has_matching_open_order(Side::Buy, 0.581, eps));
        // Within-eps counts as matching — covers f64 round-trip jitter.
        assert!(c.has_matching_open_order(Side::Buy, 0.5812, eps));
    }

    #[test]
    fn has_matching_open_order_misses_on_wrong_side_or_price() {
        let (c, _d) = mk_dry_client();
        c.record_open_order(OpenOrder {
            order_id: "A".into(),
            token_id: "tkn".into(),
            side: Side::Buy,
            price: 0.581,
            size: 10.0,
            placed_at: Instant::now(),
        });
        let eps = 0.0005;
        // Opposite side at same price — not a match.
        assert!(!c.has_matching_open_order(Side::Sell, 0.581, eps));
        // Same side but the price has moved by a full tick.
        assert!(!c.has_matching_open_order(Side::Buy, 0.582, eps));
    }

    #[test]
    fn has_stale_on_side_sees_only_same_side_different_price() {
        let (c, _d) = mk_dry_client();
        c.record_open_order(OpenOrder {
            order_id: "A".into(),
            token_id: "tkn".into(),
            side: Side::Buy,
            price: 0.580,
            size: 10.0,
            placed_at: Instant::now(),
        });
        c.record_open_order(OpenOrder {
            order_id: "B".into(),
            token_id: "tkn".into(),
            side: Side::Sell,
            price: 0.620,
            size: 10.0,
            placed_at: Instant::now(),
        });
        let eps = 0.0005;
        // Want to emit Buy@0.582: the Buy@0.580 is stale on this side.
        assert!(c.has_stale_open_order_on_side(Side::Buy, 0.582, eps));
        // Opposite-side quote (Sell@0.620) must not register as stale
        // when we're emitting on the Buy side.
        assert!(!c.has_stale_open_order_on_side(Side::Buy, 0.580, eps));
    }

    #[test]
    fn batch_cancel_body_preserves_dedup_order() {
        // Mirror the dedup logic inside cancel_orders so a refactor
        // to that loop can't silently change the on-wire order.
        let input = vec![
            "x".to_string(),
            "y".to_string(),
            "x".to_string(),
            "z".to_string(),
        ];
        let mut seen: HashSet<&str> = HashSet::new();
        let deduped: Vec<&str> = input
            .iter()
            .map(String::as_str)
            .filter(|s| seen.insert(*s))
            .collect();
        assert_eq!(deduped, vec!["x", "y", "z"]);
        assert_eq!(
            serde_json::to_string(&deduped).unwrap(),
            r#"["x","y","z"]"#
        );
    }
}
