//! Validation harness for PR 3 — NOT a correctness test.
//!
//! Both tests are `#[ignore]` so they don't land in the default
//! `cargo test` run. Invoke explicitly:
//!
//!   cargo test --features ws --test runtime_realtime_dry_run \
//!       -- --ignored --nocapture
//!
//! The first test measures pure-compute signing latency — pulls
//! signer onto the hot path, loops `sign_order` 10k times,
//! dumps p50/p95/p99/max µs.
//!
//! The second test stands up a localhost tungstenite WS server
//! that pushes synthetic book events at a known cadence, runs the
//! Runtime::run_forever loop for a bounded duration against a
//! dry-run TradingClient (no live orders, no live network), then
//! dumps all RuntimeStats + WsStats so a human can read them off.

#![cfg(feature = "ws")]

use std::sync::Arc;
use std::time::{Duration, Instant};

use alloy_primitives::U256;
use futures_util::{SinkExt, StreamExt};
use parking_lot::RwLock;
use tempfile::TempDir;
use tokio::net::TcpListener;
use tokio_tungstenite::accept_async;
use tokio_tungstenite::tungstenite::Message;

use arbigab_replica::book::{BookLevel, BookSnapshot};
use arbigab_replica::client::TradingClient;
use arbigab_replica::config::{SpreadConfig, TradeSideMode};
use arbigab_replica::order::{ClobOrder, Side};
use arbigab_replica::runtime::{
    Runtime, RuntimeConfig, RuntimeStats, SubmitWorker,
};
use arbigab_replica::state_machine::SpreadCapture;
use arbigab_replica::ws::{WsClient, WsStats};

// Deterministic dev key — NOT a real maker; signing is pure-compute.
const DEV_KEY: &str =
    "0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d";

#[tokio::test]
#[ignore]
async fn sign_us_microbench() {
    use alloy_primitives::Address;
    use arbigab_replica::signer::Eip712Signer;

    let signer = Eip712Signer::from_hex(DEV_KEY).expect("signer");
    let maker = signer.maker();

    // Canonical synthetic order — representative of a real submit.
    let sample = |salt: u64| {
        ClobOrder::new(
            salt,
            maker,
            U256::from(42u64),
            U256::from(1_000_000_u64),
            U256::from(500_000_u64),
            U256::ZERO,
            U256::ZERO,
            U256::from(0u64),
            Side::Sell,
        )
    };

    // Warm-up — prime the signer's internal state + CPU caches.
    for i in 0..128 {
        let o = sample(i);
        signer.sign_order(&o.to_eip712()).unwrap();
    }

    const N: usize = 10_000;
    let mut samples: Vec<u64> = Vec::with_capacity(N);
    for i in 0..N as u64 {
        let o = sample(i);
        let eip = o.to_eip712();
        let t0 = Instant::now();
        let _sig = signer.sign_order(&eip).unwrap();
        samples.push(t0.elapsed().as_micros() as u64);
    }

    samples.sort_unstable();
    let pct = |q: f64| samples[((samples.len() as f64 - 1.0) * q) as usize];
    eprintln!(
        "sign_us  n={}  p50={}  p95={}  p99={}  max={}  (maker={:?})",
        N,
        pct(0.50),
        pct(0.95),
        pct(0.99),
        *samples.last().unwrap(),
        Address::from(maker),
    );
}

/// Realtime dry-run:
///   - localhost tungstenite server publishing book snapshots every 75ms
///   - WsClient streaming into a shared book_cache
///   - TradingClient(dry_run=true) sharing the same book_cache
///   - Runtime::run_forever ticking at 150ms with dedup/throttle on
///   - duration ~3s, then snapshot + print all observables
#[tokio::test]
#[ignore]
async fn runtime_realtime_dry_run() {
    // ── WS server ───────────────────────────────────────────────
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let port = listener.local_addr().unwrap().port();
    let server = tokio::spawn(async move {
        let (stream, _) = listener.accept().await.unwrap();
        let mut ws = accept_async(stream).await.unwrap();
        // Drain the subscribe frame so the dispatcher proceeds.
        let _ = ws.next().await;

        // Alternating price scheme: hold a price for 450ms (3 server
        // ticks @ 75ms ≈ 6 runtime ticks @ 75ms cadence, so multiple
        // runtime ticks see the same price → dedup fires), then step.
        let ladder: [(f64, f64); 4] =
            [(0.49, 0.51), (0.490, 0.511), (0.491, 0.511), (0.492, 0.511)];
        let mut idx: usize = 0;
        let mut pushed: u64 = 0;
        let deadline = Instant::now() + Duration::from_millis(3_100);
        while Instant::now() < deadline {
            let (bid, ask) = ladder[idx % ladder.len()];
            let msg = format!(
                r#"{{"event_type":"book","bids":[{{"price":"{bid}","size":"100"}}],"asks":[{{"price":"{ask}","size":"200"}}]}}"#
            );
            if ws.send(Message::Text(msg.into())).await.is_err() {
                break;
            }
            pushed += 1;
            if pushed % 6 == 0 {
                idx += 1;
            }
            tokio::time::sleep(Duration::from_millis(75)).await;
        }
        let _ = ws.close(None).await;
        pushed
    });

    // ── Client side ─────────────────────────────────────────────
    let tmp = TempDir::new().unwrap();
    let nonce_path = tmp.path().join("nonce");
    let client = TradingClient::new(DEV_KEY, nonce_path, /* dry_run */ true, 0)
        .expect("TradingClient");

    let book: Arc<RwLock<BookSnapshot>> = client.book_cache();

    // Pre-stamp a fresh book so the very first tick doesn't fall
    // through the freshness gate before WS connects and delivers
    // its first snapshot. After that, WS keeps it fresh.
    {
        let mut w = book.write();
        w.bids = vec![BookLevel { price: 0.48, size: 100.0 }];
        w.asks = vec![BookLevel { price: 0.52, size: 200.0 }];
        w.stamp_now();
    }

    let ws_stats = Arc::new(WsStats::default());
    let ws_client = WsClient::new(
        vec!["token_under_test".into()],
        book.clone(),
        ws_stats.clone(),
    )
    .with_url(format!("ws://127.0.0.1:{port}"));
    let ws_handle = tokio::spawn(async move {
        let _ = ws_client.run_with_limit(Some(2)).await;
    });

    // Runtime — gate tuned so synthetic 0.02 spread triggers Emit.
    let rt_cfg = RuntimeConfig {
        tick_interval_ms: 150,
        book_max_age_ms: 1_000,
        dedup_window_ms: 500,
        submit_budget_per_sec: 5,
        price_bucket: 0.001,
        size_bucket: 1.0,
    };
    let spread_cfg = SpreadConfig {
        order_size: 1.0,
        edge_threshold: 0.005,
        target_spread: 0.005,
        trade_side: TradeSideMode::Both,
    };
    let sm = SpreadCapture::new(spread_cfg, /* max_position */ 5.0, 0.01, 0.99);
    let stats = Arc::new(RuntimeStats::default());
    let mut rt = Runtime::new(rt_cfg, sm, book.clone(), stats.clone())
        .with_ws_stats(ws_stats.clone());

    // Force a pivot: net_position >> max_position → Emit(Sell).
    rt.set_net_position(10.0);

    // 500ms stats sampler — gives us shape of book_age / cadence
    // over time, not just an endpoint snapshot.
    let stats_probe = stats.clone();
    let book_probe = book.clone();
    let ws_probe = ws_stats.clone();
    let sampler = tokio::spawn(async move {
        let mut samples: Vec<String> = Vec::new();
        let deadline = Instant::now() + Duration::from_millis(3_000);
        while Instant::now() < deadline {
            tokio::time::sleep(Duration::from_millis(500)).await;
            let b = book_probe.read();
            samples.push(format!(
                "t={:>4}ms  ticks={:>3}  tick_us={:>5}  dedup={:>2}  drops={:>2}  fb={:>2}  \
                 dec_age={:>5?}  sub_age={:>5?}  book_age={:>5?}  ws_age={:>5?}  connected={}",
                Instant::now().elapsed().as_millis(),
                stats_probe.tick_count(),
                stats_probe.observed_tick_us(),
                stats_probe.dedup_count(),
                stats_probe.throttle_drops(),
                ws_probe.ws_fallback_to_rest_count(),
                stats_probe.last_decision_age_ms(),
                stats_probe.last_submit_age_ms(),
                b.book_age_ms(),
                ws_probe.last_ws_message_age_ms(),
                ws_probe.ws_connected(),
            ));
        }
        samples
    });

    // ── Run the loop under a hard wall-clock bound ─────────────
    let token_id = U256::from(42u64);
    let token_id_str = "token_under_test".to_string();
    let run_fut = rt.run_forever(token_id, token_id_str, &client);
    tokio::select! {
        _ = run_fut => {},
        _ = tokio::time::sleep(Duration::from_millis(3_050)) => {},
    }

    // ── Collect + print ────────────────────────────────────────
    let per_tick_samples = sampler.await.unwrap_or_default();
    let pushed = tokio::time::timeout(Duration::from_secs(1), server)
        .await
        .ok()
        .and_then(|r| r.ok())
        .unwrap_or(0);
    ws_handle.abort();

    eprintln!("── per-500ms samples ──");
    for line in &per_tick_samples {
        eprintln!("  {line}");
    }

    let b = book.read();
    eprintln!("── final snapshot ──");
    eprintln!(
        "  tick_count           = {}",
        stats.tick_count()
    );
    eprintln!(
        "  observed_tick_us     = {}",
        stats.observed_tick_us()
    );
    eprintln!(
        "  dedup_count          = {}",
        stats.dedup_count()
    );
    eprintln!(
        "  throttle_drops       = {}",
        stats.throttle_drops()
    );
    eprintln!(
        "  last_decision_age_ms = {:?}",
        stats.last_decision_age_ms()
    );
    eprintln!(
        "  last_submit_age_ms   = {:?}",
        stats.last_submit_age_ms()
    );
    eprintln!(
        "  book_age_ms          = {:?}",
        b.book_age_ms()
    );
    eprintln!(
        "  best_bid / best_ask  = {:?} / {:?}",
        b.best_bid(),
        b.best_ask()
    );
    eprintln!(
        "  ws_connected         = {}",
        ws_stats.ws_connected()
    );
    eprintln!(
        "  ws_reconnect_count   = {}",
        ws_stats.ws_reconnect_count()
    );
    eprintln!(
        "  last_ws_message_age  = {:?}",
        ws_stats.last_ws_message_age_ms()
    );
    eprintln!(
        "  ws_fallback_to_rest  = {}",
        ws_stats.ws_fallback_to_rest_count()
    );
    eprintln!("  server_pushed_events = {}", pushed);

    // ── Minimum sanity assertions — if these fail, the test is a
    // real validation failure, not a cosmetic one.
    // Expectation: at 150ms cadence over 3s ≈ 20 ticks (minus
    // startup slack); we assert ≥ 12 so CPU-starved CI doesn't
    // false-positive.
    assert!(
        stats.tick_count() >= 12,
        "runtime fell below minimum tick rate: {}",
        stats.tick_count()
    );
    // Cadence should be near 150_000µs. Tolerate up to 250ms
    // (top of user's stated 100–250ms spec envelope).
    assert!(
        stats.observed_tick_us() <= 250_000,
        "cadence too loose: {}µs",
        stats.observed_tick_us()
    );
    // WS must have actually connected + delivered data.
    assert!(ws_stats.ws_reconnect_count() >= 1);
    assert!(
        ws_stats.last_ws_message_age_ms().unwrap_or(u64::MAX) < 500,
        "last_ws_message_age too old: {:?}",
        ws_stats.last_ws_message_age_ms()
    );
    // Dedup OR throttle should have fired at least once — with a
    // held price for 450ms at 150ms ticks we expect ≥1 dedup.
    assert!(
        stats.dedup_count() + stats.throttle_drops() >= 1,
        "neither dedup nor throttle ever fired — bucketing may be broken"
    );
}

/// PR 4 decoupling proof:
///   - Same WS scaffolding as the PR 3 test, but the runtime is
///     wired with a `SubmitWorker` over a bounded mpsc.
///   - Asserts that every queue observable (depth, full_drops,
///     queue_wait_us, http_submit_us) populates correctly.
///   - Asserts tick cadence still hits ~150ms — i.e. ticks did
///     not inherit submit latency.
#[tokio::test]
#[ignore]
async fn runtime_queued_submit_dry_run() {
    // ── WS server ───────────────────────────────────────────────
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let port = listener.local_addr().unwrap().port();
    let server = tokio::spawn(async move {
        let (stream, _) = listener.accept().await.unwrap();
        let mut ws = accept_async(stream).await.unwrap();
        let _ = ws.next().await;
        let ladder: [(f64, f64); 4] =
            [(0.49, 0.51), (0.490, 0.511), (0.491, 0.511), (0.492, 0.511)];
        let mut idx: usize = 0;
        let mut pushed: u64 = 0;
        let deadline = Instant::now() + Duration::from_millis(3_100);
        while Instant::now() < deadline {
            let (bid, ask) = ladder[idx % ladder.len()];
            let msg = format!(
                r#"{{"event_type":"book","bids":[{{"price":"{bid}","size":"100"}}],"asks":[{{"price":"{ask}","size":"200"}}]}}"#
            );
            if ws.send(Message::Text(msg.into())).await.is_err() {
                break;
            }
            pushed += 1;
            if pushed % 6 == 0 {
                idx += 1;
            }
            tokio::time::sleep(Duration::from_millis(75)).await;
        }
        let _ = ws.close(None).await;
        pushed
    });

    // ── Client (Arc; shared between runtime + worker) ──────────
    let tmp = TempDir::new().unwrap();
    let client = Arc::new(
        TradingClient::new(DEV_KEY, tmp.path().join("nonce"), true, 0)
            .expect("TradingClient"),
    );
    let book: Arc<RwLock<BookSnapshot>> = client.book_cache();
    {
        let mut w = book.write();
        w.bids = vec![BookLevel { price: 0.48, size: 100.0 }];
        w.asks = vec![BookLevel { price: 0.52, size: 200.0 }];
        w.stamp_now();
    }

    let ws_stats = Arc::new(WsStats::default());
    let ws_client = WsClient::new(
        vec!["token_under_test".into()],
        book.clone(),
        ws_stats.clone(),
    )
    .with_url(format!("ws://127.0.0.1:{port}"));
    let ws_handle = tokio::spawn(async move {
        let _ = ws_client.run_with_limit(Some(2)).await;
    });

    // Runtime + Worker over capacity-4 mpsc.
    let rt_cfg = RuntimeConfig {
        tick_interval_ms: 150,
        book_max_age_ms: 1_000,
        // dedup_window_ms small so multiple submits per ladder rung
        // exercise the queue rather than getting suppressed.
        dedup_window_ms: 100,
        // Bigger budget than dedup so we see queue activity, but
        // not so big that we overrun a 4-slot queue every time.
        submit_budget_per_sec: 10,
        price_bucket: 0.001,
        size_bucket: 1.0,
    };
    let spread_cfg = SpreadConfig {
        order_size: 1.0,
        edge_threshold: 0.005,
        target_spread: 0.005,
        trade_side: TradeSideMode::Both,
    };
    let sm = SpreadCapture::new(spread_cfg, 5.0, 0.01, 0.99);
    let stats = Arc::new(RuntimeStats::default());

    let (tx, rx) = tokio::sync::mpsc::channel(4);
    let worker = SubmitWorker::new(client.clone(), rx, stats.clone());
    let worker_handle = tokio::spawn(worker.run());

    let mut rt = Runtime::new(rt_cfg, sm, book.clone(), stats.clone())
        .with_ws_stats(ws_stats.clone())
        .with_submit_queue(tx);
    rt.set_net_position(10.0);

    // 500ms sampler.
    let stats_probe = stats.clone();
    let book_probe = book.clone();
    let ws_probe = ws_stats.clone();
    let sampler = tokio::spawn(async move {
        let mut samples: Vec<String> = Vec::new();
        let deadline = Instant::now() + Duration::from_millis(3_000);
        while Instant::now() < deadline {
            tokio::time::sleep(Duration::from_millis(500)).await;
            let b = book_probe.read();
            samples.push(format!(
                "ticks={:>3}  tick_us={:>5}  dedup={:>2}  drops={:>2}  \
                 q_depth={:>2}  q_full={:>2}  q_wait_us={:>5}  http_us={:>5}  \
                 dec_age={:>5?}  sub_age={:>5?}  book_age={:>5?}  ws_age={:>5?}",
                stats_probe.tick_count(),
                stats_probe.observed_tick_us(),
                stats_probe.dedup_count(),
                stats_probe.throttle_drops(),
                stats_probe.queue_depth(),
                stats_probe.queue_full_drops(),
                stats_probe.last_queue_wait_us(),
                stats_probe.last_http_submit_us(),
                stats_probe.last_decision_age_ms(),
                stats_probe.last_submit_age_ms(),
                b.book_age_ms(),
                ws_probe.last_ws_message_age_ms(),
            ));
        }
        samples
    });

    let token_id = U256::from(42u64);
    let token_id_str = "token_under_test".to_string();
    let run_fut = rt.run_forever(token_id, token_id_str, &*client);
    tokio::select! {
        _ = run_fut => {},
        _ = tokio::time::sleep(Duration::from_millis(3_050)) => {},
    }

    let per_tick_samples = sampler.await.unwrap_or_default();
    let pushed = tokio::time::timeout(Duration::from_secs(1), server)
        .await
        .ok()
        .and_then(|r| r.ok())
        .unwrap_or(0);
    ws_handle.abort();
    // Worker keeps running until the sender drops — the runtime
    // has its own `submit_tx` clone inside `rt`, which we now drop.
    drop(rt);
    let _ = tokio::time::timeout(Duration::from_secs(1), worker_handle).await;

    eprintln!("── per-500ms samples (queued path) ──");
    for line in &per_tick_samples {
        eprintln!("  {line}");
    }
    eprintln!("── final snapshot (queued path) ──");
    eprintln!("  tick_count           = {}", stats.tick_count());
    eprintln!("  observed_tick_us     = {}", stats.observed_tick_us());
    eprintln!("  dedup_count          = {}", stats.dedup_count());
    eprintln!("  throttle_drops       = {}", stats.throttle_drops());
    eprintln!("  queue_depth          = {}", stats.queue_depth());
    eprintln!("  queue_full_drops     = {}", stats.queue_full_drops());
    eprintln!("  last_queue_wait_us   = {}", stats.last_queue_wait_us());
    eprintln!("  last_http_submit_us  = {}", stats.last_http_submit_us());
    eprintln!("  last_submit_age_ms   = {:?}", stats.last_submit_age_ms());
    eprintln!("  ws_reconnect_count   = {}", ws_stats.ws_reconnect_count());
    eprintln!("  last_ws_message_age  = {:?}", ws_stats.last_ws_message_age_ms());
    eprintln!("  ws_fallback_to_rest  = {}", ws_stats.ws_fallback_to_rest_count());
    eprintln!("  server_pushed_events = {}", pushed);

    // ── Decoupling assertions ─────────────────────────────────
    // Cadence preserved despite a worker doing real (sign+drain)
    // work on a separate task.
    assert!(
        stats.tick_count() >= 12,
        "tick_count too low: {}",
        stats.tick_count()
    );
    assert!(
        stats.observed_tick_us() <= 250_000,
        "cadence too loose: {}µs",
        stats.observed_tick_us()
    );
    // Worker actually moved jobs.
    assert!(
        stats.last_queue_wait_us() > 0,
        "queue_wait never observed — worker may not have drained"
    );
    assert!(
        stats.last_http_submit_us() > 0,
        "http_submit never observed — worker may not have called submit_signed"
    );
    // After 1s of idle drain (well past the 3s test bound), depth
    // should be near zero. Allow ≤2 in-flight from final ticks.
    assert!(
        stats.queue_depth() <= 2,
        "queue depth high at end: {}",
        stats.queue_depth()
    );
}
