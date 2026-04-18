# Research notes — arbigab bot reverse engineering

- [`FINDINGS.md`](FINDINGS.md) — current findings, architecture map, suspicions, open questions.
- [`mitm/`](mitm/) — scripts to rebuild the MITM harness in a fresh sandbox.

Private keys / certs are **not** committed. Run `mitm/setup.sh` (as root)
to regenerate the CA + server cert, install trust, and patch `/etc/hosts`.
