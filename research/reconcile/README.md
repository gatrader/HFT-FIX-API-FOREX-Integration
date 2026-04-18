# Slug-by-slug reconciler

Cross-checks the **arbigab bot DB** against **public Polymarket activity** for
one or more reference wallets, to detect patterns like:

- same slug touched by both reference wallets around the same timestamp
  (a "follow the author" signal);
- bot DB fill for a slug that a reference wallet also bought/sold nearby;
- reference wallet holds a position on a slug the bot never traded.

## Usage

### Live mode (needs outbound to `data-api.polymarket.com`)

```bash
./reconcile.py \
    --wallet 0x0006af12cd4dacc450836a0e1ec6ce47365d8c63:main \
    --wallet 0xb27bc932bf8110d8f78e55da7d5f0497a18b5b82:alt \
    --db ../../bot/web/data/gabagool.db \
    --out report.md \
    --raw-out report.json
```

Note: the sandbox used for this investigation **cannot** reach
`data-api.polymarket.com` (egress allowlist). Run this step from a machine
with open outbound HTTPS.

### Offline / fixture mode

If you've already fetched the JSON (e.g. via a browser's devtools, or a
separate `curl` run), drop them into `fixtures/` as
`{label}.positions.json` and `{label}.trades.json`, then:

```bash
./reconcile.py \
    --wallet 0x0006af12cd4dacc450836a0e1ec6ce47365d8c63:main \
    --wallet 0xb27bc932bf8110d8f78e55da7d5f0497a18b5b82:alt \
    --fixtures fixtures/ \
    --out report.md
```

### Downloading the fixtures manually

```bash
# main wallet
curl -sS 'https://data-api.polymarket.com/positions?user=0x0006af12cd4dacc450836a0e1ec6ce47365d8c63&limit=500&sizeThreshold=0' \
    > fixtures/main.positions.json
curl -sS 'https://data-api.polymarket.com/trades?user=0x0006af12cd4dacc450836a0e1ec6ce47365d8c63&limit=500' \
    > fixtures/main.trades.json

# alt wallet
curl -sS 'https://data-api.polymarket.com/positions?user=0xb27bc932bf8110d8f78e55da7d5f0497a18b5b82&limit=500&sizeThreshold=0' \
    > fixtures/alt.positions.json
curl -sS 'https://data-api.polymarket.com/trades?user=0xb27bc932bf8110d8f78e55da7d5f0497a18b5b82&limit=500' \
    > fixtures/alt.trades.json
```

If you have > 500 positions or trades, paginate with `&offset=500`, `&offset=1000`, etc.,
and concatenate the JSON arrays.

## Output

Two files per run:

- `report.md` — human-readable overlap matrix + per-slug detail for rows that
  overlap multiple sources.
- `report.json` (optional, via `--raw-out`) — machine-readable dump of the
  same data; useful for further analysis / joining against other sources.

Exit codes:

- `0` — no bot↔wallet or wallet↔wallet overlap found.
- `2` — at least one overlap found (worth manual review).

## Sample (fixture-driven)

Running against the checked-in synthetic fixtures in `fixtures/`:

```
./reconcile.py \
    --wallet 0x0006af12cd4dacc450836a0e1ec6ce47365d8c63:main \
    --wallet 0xb27bc932bf8110d8f78e55da7d5f0497a18b5b82:alt \
    --fixtures fixtures/ --out fixtures/fixture_report.md
```

flags one slug (`btc-up-or-down-2026-04-18-16utc`) where both wallets bought
YES within 40 seconds of each other — the exact pattern a follow-the-author
scheme would produce. See `fixtures/fixture_report.md` for the rendered table.

## Schema notes

The Prisma `Trade` model joins to `Market` via `marketId`:

```sql
SELECT m.slug, m.symbol, t.side, t.traderSide, t.size, t.price, t.timestamp
FROM Trade t JOIN Market m ON m.id = t.marketId;
```

`side` is `"BUY" | "SELL"` (wire direction) and `traderSide` is
`"UP" | "DOWN"` (which outcome leg). The reconciler keys on `slug` only —
outcome-level comparison requires the `asset` (tokenId) from Polymarket's
data API, which the bot DB doesn't currently persist. If you need
outcome-level reconciliation you can enrich the DB with `conditionId` +
`tokenId` per market.
