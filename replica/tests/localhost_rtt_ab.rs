//! Localhost-RTT A/B (Option 3 Step 2) — mechanics validation only.
//!
//! NOT a replacement for the EC2/CLOB benchmark. This exercises the
//! submit decoupling path against a tokio mock HTTP server that
//! sleeps `sleep_ms` before returning 200 OK, so we can measure — in
//! the sandbox — what the PR 4 queue does to tick cadence and to
//! the five new observables:
//!
//!   - queue_depth
//!   - queue_full_drops
//!   - last_queue_wait_us
//!   - last_http_submit_us
//!   - observed_tick_us (cadence)
//!
//! Both tests are `#[ignore]`-gated; invoke explicitly:
//!
//!   cargo test --test localhost_rtt_ab -- --ignored --nocapture
//!
//! NB: `tokio::time::interval` with `MissedTickBehavior::Delay` pins
//! the tick schedule as long as `run_tick` returns in under
//! `tick_interval_ms`. At 50–100ms RTT that's true for both inline
//! and queued modes, so the cadence difference is small. The signal
//! we're primarily after is mechanical: the queue path populates
//! the new observables and offloads HTTP off the tick, even when
//! the cadence number itself doesn't move.

use std::sync::atomic::{AtomicU64, Ordering};
use std::sync::Arc;
use std::time::{Duration, Instant};

use alloy_primitives::U256;
use parking_lot::RwLock;
use tempfile::TempDir;
use tokio::io::{AsyncReadExt, AsyncWriteExt};
use tokio::net::TcpListener;

use arbigab_replica::auth::ApiCredentials;
use arbigab_replica::book::{BookLevel, BookSnapshot};
use arbigab_replica::client::TradingClient;
use arbigab_replica::config::{SpreadConfig, TradeSideMode};
use arbigab_replica::runtime::{
    Runtime, RuntimeConfig, RuntimeStats, SubmitWorker,
};
use arbigab_replica::state_machine::SpreadCapture;

// Deterministic dev key. Signs real EIP-712 but the maker has no
// CLOB creds — our mock server does not validate.
const DEV_KEY: &str =
    "0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d";

// ── mock HTTP server ────────────────────────────────────────────────

struct Mock {
    url: String,
    calls: Arc<AtomicU64>,
    task: tokio::task::JoinHandle<()>,
}

impl Mock {
    fn shutdown(self) {
        self.task.abort();
    }
}

/// A minimum-viable HTTP/1.1 server that:
///   - accepts POST /order
///   - reads headers + Content-Length body
///   - tokio::sleep(sleep_ms) to simulate RTT
///   - writes 200 OK with {"success":true}
///
/// Serial per-connection but reqwest pools the TCP socket so the
/// steady-state submits hit the same handler. One connection is
/// sufficient for ≤10 req/s.
async fn spawn_mock(sleep_ms: u64) -> Mock {
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let addr = listener.local_addr().unwrap();
    let calls = Arc::new(AtomicU64::new(0));
    let calls_for_task = calls.clone();
    let task = tokio::spawn(async move {
        loop {
            let Ok((mut sock, _)) = listener.accept().await else { break };
            let calls_for_conn = calls_for_task.clone();
            tokio::spawn(async move {
                // Keep-alive loop: handle multiple pipelined requests
                // on the same TCP socket, since reqwest will reuse.
                loop {
                    let mut buf: Vec<u8> = Vec::with_capacity(4096);
                    let mut chunk = [0u8; 1024];
                    let header_end;
                    loop {
                        let n = match sock.read(&mut chunk).await {
                            Ok(0) => return,
                            Ok(n) => n,
                            Err(_) => return,
                        };
                        buf.extend_from_slice(&chunk[..n]);
                        if let Some(p) = find_header_end(&buf) {
                            header_end = p;
                            break;
                        }
                    }
                    let headers = std::str::from_utf8(&buf[..header_end])
                        .unwrap_or("");
                    let clen = parse_content_length(headers).unwrap_or(0);
                    let body_start = header_end + 4;
                    while buf.len() < body_start + clen {
                        let n = match sock.read(&mut chunk).await {
                            Ok(0) => return,
                            Ok(n) => n,
                            Err(_) => return,
                        };
                        buf.extend_from_slice(&chunk[..n]);
                    }
                    calls_for_conn.fetch_add(1, Ordering::Relaxed);
                    tokio::time::sleep(Duration::from_millis(sleep_ms)).await;
                    let body = r#"{"success":true}"#;
                    let resp = format!(
                        "HTTP/1.1 200 OK\r\n\
                         Content-Type: application/json\r\n\
                         Content-Length: {}\r\n\
                         Connection: keep-alive\r\n\
                         \r\n{}",
                        body.len(),
                        body
                    );
                    if sock.write_all(resp.as_bytes()).await.is_err() {
                        return;
                    }
                    let _ = sock.flush().await;
                }
            });
        }
    });
    Mock {
        url: format!("http://{addr}"),
        calls,
        task,
    }
}

fn find_header_end(buf: &[u8]) -> Option<usize> {
    buf.windows(4).position(|w| w == b"\r\n\r\n")
}

fn parse_content_length(headers: &str) -> Option<usize> {
    for line in headers.lines() {
        let mut it = line.splitn(2, ':');
        let name = it.next()?.trim();
        let value = it.next()?.trim();
        if name.eq_ignore_ascii_case("content-length") {
            return value.parse().ok();
        }
    }
    None
}

// ── arm runner ──────────────────────────────────────────────────────

struct ArmResult {
    stats: Arc<RuntimeStats>,
    tick_us_samples: Vec<u64>,
    mock_calls: u64,
}

async fn run_arm(queued: bool, sleep_ms: u64, duration_ms: u64) -> ArmResult {
    let mock = spawn_mock(sleep_ms).await;

    let tmp = TempDir::new().unwrap();
    let client = Arc::new(
        TradingClient::with_base_url(
            DEV_KEY,
            tmp.path().join("nonce"),
            /* dry_run */ false,
            0,
            &mock.url,
        )
        .expect("TradingClient"),
    );
    // Creds — mock doesn't validate them, but l2_headers needs a
    // base64url-decodable secret.
    client.set_credentials(ApiCredentials {
        api_key: "00000000-0000-0000-0000-000000000000".into(),
        secret: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA".into(),
        passphrase: "p".into(),
    });

    let book: Arc<RwLock<BookSnapshot>> = client.book_cache();
    {
        let mut w = book.write();
        w.bids = vec![BookLevel { price: 0.48, size: 100.0 }];
        w.asks = vec![BookLevel { price: 0.52, size: 200.0 }];
        w.stamp_now();
    }
    // Rotate bid slightly every 50ms so dedup doesn't suppress every
    // tick's submission — we want the submit path exercised.
    let book_for_stamp = book.clone();
    let stamp_task = tokio::spawn(async move {
        let ladder: [f64; 4] = [0.490, 0.491, 0.492, 0.493];
        let mut i = 0usize;
        loop {
            tokio::time::sleep(Duration::from_millis(50)).await;
            {
                let mut w = book_for_stamp.write();
                w.bids = vec![BookLevel { price: ladder[i % 4], size: 100.0 }];
                w.asks = vec![BookLevel { price: 0.520, size: 200.0 }];
                w.stamp_now();
            }
            i += 1;
        }
    });

    let rt_cfg = RuntimeConfig {
        tick_interval_ms: 150,
        book_max_age_ms: 1_000,
        dedup_window_ms: 100,
        submit_budget_per_sec: 10,
        price_bucket: 0.001,
        size_bucket: 1.0,
        cancel_dedup_ms: 500,
    };
    let spread_cfg = SpreadConfig {
        order_size: 1.0,
        edge_threshold: 0.005,
        target_spread: 0.005,
        trade_side: TradeSideMode::Both,
    };
    let sm = SpreadCapture::new(spread_cfg, 5.0, 0.01, 0.99);
    let stats = Arc::new(RuntimeStats::default());
    let mut rt = Runtime::new(rt_cfg, sm, book.clone(), stats.clone());
    rt.set_net_position(10.0);

    let worker_handle = if queued {
        let (tx, rx) = tokio::sync::mpsc::channel(32);
        let worker = SubmitWorker::new(client.clone(), rx, stats.clone());
        rt = rt.with_submit_queue(tx);
        Some(tokio::spawn(worker.run()))
    } else {
        None
    };

    // Cadence sampler — poll observed_tick_us every 100ms so we see
    // the shape over the run, not just the final value.
    let stats_probe = stats.clone();
    let duration = Duration::from_millis(duration_ms);
    let sampler = tokio::spawn(async move {
        let mut out: Vec<u64> = Vec::new();
        let deadline = Instant::now() + duration;
        while Instant::now() < deadline {
            tokio::time::sleep(Duration::from_millis(100)).await;
            let v = stats_probe.observed_tick_us();
            if v > 0 {
                out.push(v);
            }
        }
        out
    });

    let token_id = U256::from(42u64);
    let token_id_str = "token_under_test".to_string();
    let run_fut = rt.run_forever(token_id, token_id_str, &*client);
    tokio::select! {
        _ = run_fut => {},
        _ = tokio::time::sleep(duration) => {},
    }
    stamp_task.abort();
    drop(rt);
    if let Some(h) = worker_handle {
        // Give the worker a moment to drain in-flight submits before
        // the mock is shut down — otherwise last_http_submit_us can
        // race in the pathological short-duration case.
        let _ = tokio::time::timeout(Duration::from_millis(500), h).await;
    }

    let tick_us_samples = sampler.await.unwrap_or_default();
    let mock_calls = mock.calls.load(Ordering::Relaxed);
    mock.shutdown();
    ArmResult {
        stats,
        tick_us_samples,
        mock_calls,
    }
}

fn summarize(xs: &[u64]) -> (u64, u64, u64) {
    if xs.is_empty() {
        return (0, 0, 0);
    }
    let mut s = xs.to_vec();
    s.sort_unstable();
    let p = |q: f64| s[((s.len() - 1) as f64 * q) as usize];
    (p(0.5), p(0.99), *s.last().unwrap())
}

fn report(label: &str, r: &ArmResult, sleep_ms: u64) {
    let (p50, p99, max) = summarize(&r.tick_us_samples);
    eprintln!("── {label} arm  (RTT={sleep_ms}ms) ──");
    eprintln!("  tick_count            = {}", r.stats.tick_count());
    eprintln!("  observed_tick_us last = {}", r.stats.observed_tick_us());
    eprintln!(
        "  observed_tick_us p50/p99/max = {}/{}/{}",
        p50, p99, max
    );
    eprintln!("  dedup_count           = {}", r.stats.dedup_count());
    eprintln!("  throttle_drops        = {}", r.stats.throttle_drops());
    eprintln!("  queue_depth (end)     = {}", r.stats.queue_depth());
    eprintln!("  queue_full_drops      = {}", r.stats.queue_full_drops());
    eprintln!("  last_queue_wait_us    = {}", r.stats.last_queue_wait_us());
    eprintln!("  last_http_submit_us   = {}", r.stats.last_http_submit_us());
    eprintln!("  last_decision_age_ms  = {:?}", r.stats.last_decision_age_ms());
    eprintln!("  last_submit_age_ms    = {:?}", r.stats.last_submit_age_ms());
    eprintln!("  mock_calls (real HTTP) = {}", r.mock_calls);
}

// ── tests ───────────────────────────────────────────────────────────

#[tokio::test(flavor = "multi_thread", worker_threads = 4)]
#[ignore]
async fn localhost_rtt_ab_50ms() {
    const SLEEP_MS: u64 = 50;
    const DUR_MS: u64 = 3_000;

    let inline = run_arm(false, SLEEP_MS, DUR_MS).await;
    report("inline", &inline, SLEEP_MS);

    let queued = run_arm(true, SLEEP_MS, DUR_MS).await;
    report("queued", &queued, SLEEP_MS);

    // ── mechanics assertions ──
    // Queued path populates the queue observables.
    assert!(
        queued.stats.last_queue_wait_us() > 0,
        "queued: last_queue_wait_us never moved"
    );
    assert!(
        queued.stats.last_http_submit_us() > 0,
        "queued: last_http_submit_us never moved"
    );
    // Inline path does NOT populate queue observables (tick bypasses queue).
    assert_eq!(
        inline.stats.last_queue_wait_us(),
        0,
        "inline: queue_wait should stay zero"
    );
    assert_eq!(
        inline.stats.last_http_submit_us(),
        0,
        "inline: http_submit should stay zero (the HTTP is in-tick, not in-worker)"
    );
    // Both paths actually hit the mock — HTTP is real on both arms.
    assert!(
        inline.mock_calls > 0,
        "inline made no HTTP calls — test setup broken"
    );
    assert!(
        queued.mock_calls > 0,
        "queued made no HTTP calls — test setup broken"
    );
    // Queue shouldn't be backed up at end.
    assert!(
        queued.stats.queue_depth() <= 2,
        "queued: queue_depth pathologically high at end: {}",
        queued.stats.queue_depth()
    );
}

#[tokio::test(flavor = "multi_thread", worker_threads = 4)]
#[ignore]
async fn localhost_rtt_ab_100ms() {
    const SLEEP_MS: u64 = 100;
    const DUR_MS: u64 = 3_000;

    let inline = run_arm(false, SLEEP_MS, DUR_MS).await;
    report("inline", &inline, SLEEP_MS);

    let queued = run_arm(true, SLEEP_MS, DUR_MS).await;
    report("queued", &queued, SLEEP_MS);

    assert!(queued.stats.last_queue_wait_us() > 0);
    assert!(queued.stats.last_http_submit_us() > 0);
    assert_eq!(inline.stats.last_queue_wait_us(), 0);
    assert_eq!(inline.stats.last_http_submit_us(), 0);
    assert!(inline.mock_calls > 0);
    assert!(queued.mock_calls > 0);
}
