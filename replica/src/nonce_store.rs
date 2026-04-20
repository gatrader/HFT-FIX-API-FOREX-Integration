//! Persistent nonce store.
//!
//! REPLICA-ADDED. The artifact keeps the CLOB nonce counter in
//! memory only (TradingClient+0x1a8). On restart it resets to
//! zero, which causes order rejection until the counter climbs
//! past historical highs. See FINAL_AUDIT §13 and
//! IMPLEMENTATION_SPEC §10.

use std::fs::{self, OpenOptions};
use std::io::{Read, Seek, SeekFrom, Write};
use std::path::PathBuf;

use parking_lot::Mutex;

pub struct NonceStore {
    path: PathBuf,
    inner: Mutex<Inner>,
}

struct Inner {
    last: u64,
}

impl NonceStore {
    pub fn open(path: impl Into<PathBuf>) -> anyhow::Result<Self> {
        let path = path.into();
        let last = read_or_zero(&path)?;
        Ok(Self {
            path,
            inner: Mutex::new(Inner { last }),
        })
    }

    pub fn load(&self) -> u64 {
        self.inner.lock().last
    }

    /// Record a used nonce. The stored value is the maximum
    /// ever observed so crash recovery always resumes above the
    /// highest previously-accepted nonce.
    pub fn record(&self, nonce: u64) -> anyhow::Result<()> {
        let mut inner = self.inner.lock();
        if nonce <= inner.last {
            return Ok(());
        }
        inner.last = nonce;
        let mut f = OpenOptions::new()
            .create(true)
            .write(true)
            .truncate(true)
            .open(&self.path)?;
        writeln!(f, "{}", nonce)?;
        f.sync_all()?;
        Ok(())
    }
}

fn read_or_zero(path: &PathBuf) -> anyhow::Result<u64> {
    match OpenOptions::new().read(true).open(path) {
        Ok(mut f) => {
            let mut s = String::new();
            f.seek(SeekFrom::Start(0))?;
            f.read_to_string(&mut s)?;
            Ok(s.trim().parse().unwrap_or(0))
        }
        Err(e) if e.kind() == std::io::ErrorKind::NotFound => {
            if let Some(dir) = path.parent() {
                fs::create_dir_all(dir).ok();
            }
            Ok(0)
        }
        Err(e) => Err(e.into()),
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::sync::atomic::{AtomicU64, Ordering};

    #[test]
    fn load_zero_when_missing() {
        let dir = tempfile::tempdir().unwrap();
        let p = dir.path().join("nonce");
        let s = NonceStore::open(&p).unwrap();
        assert_eq!(s.load(), 0);
    }

    #[test]
    fn record_persists_and_monotonic() {
        let dir = tempfile::tempdir().unwrap();
        let p = dir.path().join("nonce");
        let s = NonceStore::open(&p).unwrap();
        s.record(5).unwrap();
        s.record(3).unwrap();  // ignored
        s.record(7).unwrap();
        drop(s);
        let s2 = NonceStore::open(&p).unwrap();
        assert_eq!(s2.load(), 7);
    }

    #[test]
    fn concurrent_counter_pattern() {
        let dir = tempfile::tempdir().unwrap();
        let p = dir.path().join("nonce");
        let s = NonceStore::open(&p).unwrap();
        let n = AtomicU64::new(s.load());
        for _ in 0..10 {
            let v = n.fetch_add(1, Ordering::SeqCst) + 1;
            s.record(v).unwrap();
        }
        assert_eq!(s.load(), 10);
    }
}
