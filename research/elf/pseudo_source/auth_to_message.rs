// Reconstruction of `polymarket_client_sdk::auth::to_message` at
// 0x29b250..0x29b5a0. Builds the canonical string that the L2 HMAC is
// computed over.
//
// Key asm landmarks:
//
//   0x29b297  call String::from_utf8_lossy(body_bytes)
//   0x29b2bb..0x29b438  vectorised SSE2 loop: every b'\'' -> b'"'
//                       (hence "Python-style dict" bodies get coerced to
//                       proper JSON before signing)
//   0x29b47d  call url::Url::path                   -> path component only
//   0x29b4b8..0x29b527  fmt::format with four {} args using format string
//                       at 0x736688, invoking:
//                         arg[0] = &timestamp (i64)
//                         arg[1] = &method    (enum Display; "GET"/"POST"/..)
//                         arg[2] = &path      (String)
//                         arg[3] = &body      (quote-rewritten String)
//
// The canonical string is therefore:
//
//     "{timestamp}{method}{path}{body}"
//
// with **no separators** (no newline, no space). That's how Polymarket's
// Python reference client happens to serialise it, and this fork matches.
//
// Equivalent Rust:

pub fn to_message(
    request: &PreparedRequest, // carries method, url, body, timestamp, nonce
) -> String {
    // 0x29b28a..0x29b297: the body is held as a `Option<Vec<u8>>`. When
    // present (discriminant == 1 at offset 0x0), we convert to a lossy
    // UTF-8 string. When absent, the body segment is the empty string.
    let body_str = match &request.body {
        Some(bytes) => String::from_utf8_lossy(bytes).into_owned(),
        None => String::new(),
    };

    // 0x29b2bb..0x29b438: single-quote -> double-quote rewrite. This is
    // identical in effect to `body_str.replace('\'', '"')`; the compiler
    // vectorised it with pcmpeqb/pand/pandn SSE2 intrinsics.
    let body_str = body_str.replace('\'', "\"");

    // 0x29b47d: url.path() — scheme/host/port are NOT signed.
    let path = request.url.path();

    // 0x29b527: fmt::format with the 4-piece format string at .rodata
    // 0x736688. The format is effectively "{}{}{}{}".
    format!(
        "{}{}{}{}",
        request.timestamp, // i64 seconds since epoch, Display-formatted
        request.method,    // reqwest::Method -> "GET" | "POST" | ...
        path,
        body_str,
    )
}

// `PreparedRequest` is a private struct in the SDK. Inferred fields from
// the asm (offsets relative to %rsi at the auth::hmac call-site):
//
//   0x00  Option<Vec<u8>> body   (discriminant + Vec<u8> inline)
//   0x20  u8[N]             ...
//   0x88  url::Url           url
//   ...   enum Method        method
//   ...   i64                timestamp
//   ...   i64                nonce      (not used in the canonical string,
//                                        only as the poly_nonce header)
