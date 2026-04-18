"""
MITM HTTPS logging server for reverse engineering the arbigab bot.

Listens on :443, accepts any POST/GET for the hosts mapped to 127.0.0.1
via /etc/hosts, logs request path + headers + body to stdout, and replies
with a minimal canned response per host.

Used to capture phone-home traffic to gabagool22.com (e.g. the
`send_debug_data` call made by arbitrage_bot::trading::client::TradingClient::new
to /api/verify-balancing-conf), and to stub gamma-api.polymarket.com so the
bot proceeds past the market-fetch step.
"""

import ssl
import http.server
import json
import sys


def gamma_stub(path: str) -> bytes:
    # Minimal event array the bot can parse: one event with one market
    # carrying clobTokenIds. Tweak to taste when we need to steer behavior.
    return json.dumps([{
        "id": "stub-event",
        "slug": "stub",
        "markets": [{
            "conditionId": "0x" + "00" * 32,
            "clobTokenIds": "[\"1\",\"2\"]",
            "question": "stub",
            "endDate": "2099-01-01T00:00:00Z",
            "outcomePrices": "[\"0.5\",\"0.5\"]",
        }]
    }]).encode()


def clob_auth_stub() -> bytes:
    # rs-clob-client expects { apiKey, secret, passphrase } (camelCase).
    return json.dumps({
        "apiKey": "00000000-0000-0000-0000-000000000000",
        "secret": "c3R1YnN0dWJzdHVic3R1YnN0dWJzdHVic3R1YnN0dWJzdHVic3R1YnM=",
        "passphrase": "stubpassphrase",
        "api_key": "00000000-0000-0000-0000-000000000000",
    }).encode()


def default_ok() -> bytes:
    return b'{"ok":true}'


def response_for(host: str, path: str, method: str) -> bytes:
    if 'gamma-api.polymarket.com' in host:
        return gamma_stub(path)
    if 'clob.polymarket.com' in host and '/auth/' in path:
        return clob_auth_stub()
    return default_ok()


class H(http.server.BaseHTTPRequestHandler):
    # HTTP/1.1 + keep-alive so rustls doesn't complain about missing
    # TLS close_notify when we close the socket after each response.
    protocol_version = 'HTTP/1.1'

    def log_message(self, fmt, *args):
        # Silence default access log; we emit our own structured log.
        pass

    def _dump(self, method: str):
        n = int(self.headers.get('Content-Length', '0'))
        body = self.rfile.read(n) if n else b''
        host = self.headers.get('Host', '?')
        sys.stdout.write(f"\n==== {method} https://{host}{self.path} ====\n")
        for h in self.headers:
            sys.stdout.write(f"{h}: {self.headers[h]}\n")
        sys.stdout.write("---body---\n")
        sys.stdout.write(body.decode('utf-8', 'replace') + "\n")
        sys.stdout.flush()
        return host

    def _reply(self, method: str):
        host = self._dump(method)
        body = response_for(host, self.path, method)
        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Content-Length', str(len(body)))
        self.send_header('Connection', 'close')
        self.end_headers()
        self.wfile.write(body)
        self.wfile.flush()
        # Send TLS close_notify before closing the TCP socket so rustls is happy.
        try:
            self.connection.unwrap()
        except Exception:
            pass

    def do_POST(self):
        self._reply('POST')

    def do_GET(self):
        self._reply('GET')


def main():
    ctx = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
    ctx.load_cert_chain('/tmp/mitm/srv.crt', '/tmp/mitm/srv.key')
    srv = http.server.HTTPServer(('0.0.0.0', 443), H)
    srv.socket = ctx.wrap_socket(srv.socket, server_side=True)
    print("listening on 443", flush=True)
    srv.serve_forever()


if __name__ == '__main__':
    main()
