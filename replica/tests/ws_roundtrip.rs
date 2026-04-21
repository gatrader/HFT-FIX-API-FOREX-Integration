//! WS roundtrip integration test — PR 2 sanity check.
//!
//! Spins up a localhost `tokio-tungstenite` server, waits for the
//! client to subscribe, pushes a single synthetic `book` event,
//! and asserts that the cache was updated + the observability
//! counters moved correctly.
//!
//! No network. No TLS. Proves that the real tungstenite stream →
//! dispatch → book_cache path wires up end-to-end, without which
//! the `dispatch()` unit tests are only half the story.
//!
//! Gated on `--features ws`.

#![cfg(feature = "ws")]

use std::sync::Arc;
use std::time::Duration;

use futures_util::{SinkExt, StreamExt};
use parking_lot::RwLock;
use tokio::net::TcpListener;
use tokio::time::timeout;
use tokio_tungstenite::accept_async;
use tokio_tungstenite::tungstenite::Message;

use arbigab_replica::book::BookSnapshot;
use arbigab_replica::ws::{WsClient, WsStats};

#[tokio::test]
async fn subscribe_then_receive_book_updates_cache() {
    // ── Server side ────────────────────────────────────────────
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let port = listener.local_addr().unwrap().port();
    let server = tokio::spawn(async move {
        let (stream, _) = listener.accept().await.unwrap();
        let mut ws = accept_async(stream).await.unwrap();

        // Wait for client's subscribe message. We don't parse it
        // strictly — we just verify one Text frame shows up.
        let first = timeout(Duration::from_secs(2), ws.next())
            .await
            .expect("timeout waiting for subscribe")
            .expect("stream ended before subscribe")
            .expect("ws error");
        assert!(matches!(first, Message::Text(_)),
            "first frame must be the subscribe text");

        // Push one synthetic book snapshot.
        let book_event = r#"{
            "event_type":"book",
            "bids":[{"price":"0.49","size":"100"}],
            "asks":[{"price":"0.51","size":"200"}]
        }"#;
        ws.send(Message::Text(book_event.to_string().into()))
            .await
            .unwrap();

        // Give the client a moment to drain + dispatch before we
        // close, so the cache write lands before our assertion.
        tokio::time::sleep(Duration::from_millis(50)).await;
        let _ = ws.close(None).await;
    });

    // ── Client side ────────────────────────────────────────────
    let cache = Arc::new(RwLock::new(BookSnapshot::default()));
    let stats = Arc::new(WsStats::default());
    let client = WsClient::new(
        vec!["token_under_test".into()],
        cache.clone(),
        stats.clone(),
    )
    .with_url(format!("ws://127.0.0.1:{port}"));

    // One connect + natural close = one successful roundtrip.
    // `run_with_limit(Some(2))` bounds the reconnect loop so the
    // test can't hang if the server misbehaves.
    let client_handle = tokio::spawn(async move {
        let _ = client.run_with_limit(Some(2)).await;
    });

    // ── Assertions ─────────────────────────────────────────────
    // Give the client up to 3s to connect, subscribe, receive,
    // dispatch, and update the cache.
    let deadline = tokio::time::Instant::now() + Duration::from_secs(3);
    loop {
        if cache.read().best_bid().is_some() {
            break;
        }
        if tokio::time::Instant::now() >= deadline {
            panic!("book_cache was never updated by WS roundtrip");
        }
        tokio::time::sleep(Duration::from_millis(25)).await;
    }

    let r = cache.read();
    assert_eq!(r.best_bid(), Some(0.49));
    assert_eq!(r.best_ask(), Some(0.51));
    assert!(r.last_updated_at.is_some(), "cache must be stamped");
    drop(r);

    assert!(stats.ws_reconnect_count() >= 1,
        "reconnect counter should have ticked");
    let age = stats
        .last_ws_message_age_ms()
        .expect("at least one message was received");
    assert!(age < 5_000, "age should be small immediately after receive, got {age}");

    // Cleanup.
    let _ = timeout(Duration::from_secs(2), server).await;
    client_handle.abort();
}
