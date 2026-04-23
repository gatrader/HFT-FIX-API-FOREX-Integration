from __future__ import annotations

import argparse
import json
import os
import sys
import time
from dataclasses import asdict, dataclass, field
from typing import Iterable

import requests
from eth_account import Account

from polymarket_relayer import (
    CTF_ADDRESS,
    POLYGON_CHAIN_ID,
    PUSD_ADDRESS,
    RELAYER_URL,
    RelayerClient,
    RelayerCredentials,
    RelayerError,
    build_proxy_request,
    build_safe_request,
    checksum,
    derive_proxy_address,
    derive_safe_address,
    encode_proxy_batch_call,
    encode_redeem_positions_call,
    estimate_proxy_gas,
    send_eoa_redeem,
    wallet_type_from_signature_type,
)

DATA_API = "https://data-api.polymarket.com"
DEFAULT_RPC_URL = "https://polygon-rpc.com"


@dataclass
class RedeemCandidate:
    condition_id: str
    title: str
    collateral_token: str
    total_value: float = 0.0
    negative_risk: bool = False
    outcomes: list[str] = field(default_factory=list)


@dataclass
class RedeemAttempt:
    condition_id: str
    title: str
    total_value: float
    wallet_type: str
    dry_run: bool
    submitted: bool = False
    transaction_id: str = ""
    transaction_hash: str = ""
    terminal_state: str = ""
    error: str = ""


@dataclass
class ScanStats:
    total_rows: int = 0
    redeemable_rows: int = 0
    skipped_zero_value_rows: int = 0
    skipped_negative_risk_rows: int = 0
    skipped_filter_rows: int = 0


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description=(
            "Auto-redeem resolved Polymarket positions. Defaults to a dry run; "
            "add --execute to actually submit redeems."
        )
    )
    parser.add_argument("--execute", action="store_true", help="Submit real redeems instead of printing candidates.")
    parser.add_argument("--interval-seconds", type=int, default=0, help="Loop forever on this cadence. 0 runs once.")
    parser.add_argument("--max-runs", type=int, default=0, help="Optional cap when --interval-seconds is set.")
    parser.add_argument("--min-value", type=float, default=0.01, help="Skip conditions worth less than this many pUSD.")
    parser.add_argument("--limit", type=int, default=0, help="Only process the top N redeemable conditions.")
    parser.add_argument("--condition-id", action="append", default=[], help="Optional conditionId filter. Repeat to narrow execution.")
    parser.add_argument("--wallet-type", choices=["eoa", "proxy", "safe"], default="", help="Override POLYMARKET_SIGNATURE_TYPE.")
    parser.add_argument("--wallet-address", default="", help="Override POLYMARKET_FUNDER / derived signer address.")
    parser.add_argument("--private-key", default=os.environ.get("POLYMARKET_PRIVATE_KEY", ""), help="Signer private key. Defaults to POLYMARKET_PRIVATE_KEY.")
    parser.add_argument("--rpc-url", default=os.environ.get("POLYGON_RPC_URL", DEFAULT_RPC_URL), help="Polygon RPC URL for EOA execution and proxy gas estimation.")
    parser.add_argument("--relayer-url", default=os.environ.get("POLYMARKET_RELAYER_URL", RELAYER_URL), help="Relayer base URL.")
    parser.add_argument("--relayer-api-key", default=os.environ.get("RELAYER_API_KEY", ""), help="Relayer API key for SAFE / PROXY execution.")
    parser.add_argument("--relayer-api-key-address", default=os.environ.get("RELAYER_API_KEY_ADDRESS", ""), help="Owner address of the relayer API key.")
    parser.add_argument("--collateral-token", default=os.environ.get("POLYMARKET_COLLATERAL_TOKEN", PUSD_ADDRESS), help="Fallback collateral token when positions do not include one.")
    parser.add_argument("--wait-timeout-seconds", type=int, default=180, help="How long to wait for each relayer transaction to reach a terminal state.")
    parser.add_argument("--include-negative-risk", action="store_true", help="Include negative-risk conditions. Off by default to stay conservative.")
    parser.add_argument("--allow-wallet-mismatch", action="store_true", help="Skip the derived-wallet safety check.")
    parser.add_argument("--metadata", default="auto redeem positions", help="Relayer transaction metadata.")
    parser.add_argument("--json", action="store_true", help="Print machine-readable output in addition to the human summary.")
    return parser


def env_wallet_type(explicit_wallet_type: str) -> str:
    if explicit_wallet_type:
        return explicit_wallet_type
    signature_type_raw = os.environ.get("POLYMARKET_SIGNATURE_TYPE", "0")
    return wallet_type_from_signature_type(int(signature_type_raw))


def wallet_address_for_type(wallet_type: str, signer_address: str, explicit_wallet_address: str) -> str:
    if explicit_wallet_address:
        return checksum(explicit_wallet_address)
    env_wallet = os.environ.get("POLYMARKET_FUNDER", "")
    if env_wallet:
        return checksum(env_wallet)
    if wallet_type == "safe":
        return derive_safe_address(signer_address)
    if wallet_type == "proxy":
        return derive_proxy_address(signer_address)
    return checksum(signer_address)


def fetch_positions(wallet_address: str) -> list[dict]:
    session = requests.Session()
    limit = 500
    offset = 0
    rows: list[dict] = []
    while True:
        response = session.get(
            f"{DATA_API}/positions",
            params={"user": wallet_address, "limit": limit, "offset": offset},
            timeout=30,
        )
        response.raise_for_status()
        payload = response.json()
        if not isinstance(payload, list) or not payload:
            break
        rows.extend(payload)
        if len(payload) < limit:
            break
        offset += limit
    return rows


def negative_risk_flag(row: dict) -> bool:
    for key in ("negativeRisk", "negative_risk", "negRisk", "neg_risk"):
        value = row.get(key)
        if value is not None:
            return bool(value)
    return False


def collateral_token_from_row(row: dict, default_collateral_token: str) -> str:
    for key in ("denominationToken", "collateralToken", "collateral_token"):
        value = row.get(key)
        if value:
            return checksum(str(value))
    return checksum(default_collateral_token)


def parse_value(row: dict, key: str) -> float:
    raw = row.get(key)
    if raw in (None, ""):
        return 0.0
    return float(raw)


def build_candidates(
    rows: Iterable[dict],
    *,
    min_value: float,
    include_negative_risk: bool,
    default_collateral_token: str,
    condition_filters: set[str],
) -> tuple[list[RedeemCandidate], ScanStats]:
    grouped: dict[str, RedeemCandidate] = {}
    stats = ScanStats()
    for row in rows:
        stats.total_rows += 1
        condition_id = row.get("conditionId")
        if not condition_id:
            continue
        condition_id = str(condition_id)
        if condition_filters and condition_id.lower() not in condition_filters:
            stats.skipped_filter_rows += 1
            continue
        if not bool(row.get("redeemable")):
            continue
        stats.redeemable_rows += 1
        current_value = parse_value(row, "currentValue")
        if current_value <= 0:
            stats.skipped_zero_value_rows += 1
            continue
        negative_risk = negative_risk_flag(row)
        if negative_risk and not include_negative_risk:
            stats.skipped_negative_risk_rows += 1
            continue
        title = str(row.get("title") or row.get("slug") or condition_id)
        candidate = grouped.setdefault(
            condition_id,
            RedeemCandidate(
                condition_id=condition_id,
                title=title,
                collateral_token=collateral_token_from_row(row, default_collateral_token),
                negative_risk=negative_risk,
            ),
        )
        candidate.total_value += current_value
        outcome = str(row.get("outcome") or "?")
        size = parse_value(row, "size")
        candidate.outcomes.append(f"{outcome} x{size:.6f} -> ${current_value:.6f}")
    candidates = [candidate for candidate in grouped.values() if candidate.total_value >= min_value]
    candidates.sort(key=lambda item: item.total_value, reverse=True)
    return candidates, stats


def print_candidates(
    wallet_address: str,
    wallet_type: str,
    candidates: list[RedeemCandidate],
    stats: ScanStats,
) -> None:
    print("=" * 88)
    print("POLYMARKET AUTO REDEEM CHECK")
    print("=" * 88)
    print(f"Wallet:      {wallet_address}")
    print(f"Wallet type: {wallet_type}")
    print(f"Candidates:  {len(candidates)}")
    print(f"Rows seen:   {stats.total_rows}")
    print(f"Redeemable:  {stats.redeemable_rows}")
    print(f"Zero value:  {stats.skipped_zero_value_rows} skipped")
    print(f"Neg-risk:    {stats.skipped_negative_risk_rows} skipped")
    print("-" * 88)
    for index, candidate in enumerate(candidates, start=1):
        risk_text = " neg-risk" if candidate.negative_risk else ""
        print(
            f"[{index:02d}] ${candidate.total_value:,.6f}{risk_text} | "
            f"{candidate.title}"
        )
        print(f"     Condition:  {candidate.condition_id}")
        print(f"     Collateral: {candidate.collateral_token}")
        for outcome in candidate.outcomes:
            print(f"     Outcome:    {outcome}")
    if not candidates:
        print("No redeemable conditions passed the current filters.")
    print("=" * 88)


def validate_wallet_match(
    *,
    wallet_type: str,
    signer_address: str,
    wallet_address: str,
    allow_wallet_mismatch: bool,
    execute: bool,
) -> None:
    if allow_wallet_mismatch:
        if execute:
            raise RelayerError(
                "--allow-wallet-mismatch is dry-run only. Refusing to execute "
                "because the relayer derives the SAFE / PROXY wallet from the signer."
            )
        return
    if wallet_type == "safe":
        expected = derive_safe_address(signer_address)
    elif wallet_type == "proxy":
        expected = derive_proxy_address(signer_address)
    else:
        expected = checksum(signer_address)
    if checksum(wallet_address) != checksum(expected):
        raise RelayerError(
            f"Wallet mismatch: expected {expected} from signer {signer_address}, "
            f"but configured wallet is {wallet_address}"
        )


def execute_candidate(
    candidate: RedeemCandidate,
    *,
    args: argparse.Namespace,
    signer_address: str,
    wallet_address: str,
    wallet_type: str,
    relayer_client: RelayerClient | None,
) -> RedeemAttempt:
    attempt = RedeemAttempt(
        condition_id=candidate.condition_id,
        title=candidate.title,
        total_value=candidate.total_value,
        wallet_type=wallet_type,
        dry_run=not args.execute,
    )
    if not args.execute:
        return attempt
    try:
        if wallet_type == "eoa":
            attempt.transaction_hash = send_eoa_redeem(
                private_key=args.private_key,
                rpc_url=args.rpc_url,
                signer_address=signer_address,
                condition_id=candidate.condition_id,
                collateral_token=candidate.collateral_token,
                timeout_seconds=args.wait_timeout_seconds,
            )
            attempt.submitted = True
            attempt.terminal_state = "EOA_CONFIRMED"
            return attempt

        if relayer_client is None:
            raise RelayerError("Missing relayer client for SAFE / PROXY execution")

        calldata = encode_redeem_positions_call(
            condition_id=candidate.condition_id,
            collateral_token=candidate.collateral_token,
        )
        if wallet_type == "safe":
            safe_address = derive_safe_address(signer_address)
            if not relayer_client.get_deployed(safe_address):
                raise RelayerError(f"SAFE wallet {safe_address} is not deployed")
            nonce = relayer_client.get_nonce(signer_address, "SAFE")
            request = build_safe_request(
                private_key=args.private_key,
                signer_address=signer_address,
                nonce=nonce,
                to=CTF_ADDRESS,
                data=calldata,
                metadata=args.metadata,
                chain_id=POLYGON_CHAIN_ID,
            )
        else:
            relay_payload = relayer_client.get_relay_payload(signer_address)
            proxy_data = encode_proxy_batch_call(
                [
                    {
                        "typeCode": 1,
                        "to": CTF_ADDRESS,
                        "value": "0",
                        "data": calldata,
                    }
                ]
            )
            gas_limit = estimate_proxy_gas(args.rpc_url, signer_address, proxy_data)
            request = build_proxy_request(
                private_key=args.private_key,
                signer_address=signer_address,
                nonce=relay_payload.nonce,
                relay_address=relay_payload.address,
                data=proxy_data,
                gas_limit=gas_limit,
                metadata=args.metadata,
            )
        result = relayer_client.submit(request)
        attempt.submitted = True
        attempt.transaction_id = result.transaction_id
        attempt.transaction_hash = result.transaction_hash
        terminal = relayer_client.wait_for_terminal(
            result.transaction_id,
            timeout_seconds=args.wait_timeout_seconds,
        )
        attempt.terminal_state = terminal.state if terminal else "TIMEOUT"
        if terminal and terminal.transaction_hash:
            attempt.transaction_hash = terminal.transaction_hash
        return attempt
    except Exception as exc:
        attempt.error = str(exc)
        return attempt


def run_once(args: argparse.Namespace) -> tuple[list[RedeemCandidate], ScanStats, list[RedeemAttempt]]:
    if not args.private_key:
        raise RelayerError("Missing private key. Set POLYMARKET_PRIVATE_KEY or pass --private-key.")
    signer_address = Account.from_key(args.private_key).address
    wallet_type = env_wallet_type(args.wallet_type)
    wallet_address = wallet_address_for_type(wallet_type, signer_address, args.wallet_address)
    validate_wallet_match(
        wallet_type=wallet_type,
        signer_address=signer_address,
        wallet_address=wallet_address,
        allow_wallet_mismatch=args.allow_wallet_mismatch,
        execute=args.execute,
    )
    rows = fetch_positions(wallet_address)
    candidates, stats = build_candidates(
        rows,
        min_value=args.min_value,
        include_negative_risk=args.include_negative_risk,
        default_collateral_token=args.collateral_token,
        condition_filters={condition.lower() for condition in args.condition_id},
    )
    if args.limit > 0:
        candidates = candidates[: args.limit]
    print_candidates(wallet_address, wallet_type, candidates, stats)
    if not args.execute and args.json:
        print(json.dumps({"wallet": wallet_address, "walletType": wallet_type, "stats": asdict(stats), "candidates": [asdict(candidate) for candidate in candidates]}, indent=2))
    if not args.execute:
        return candidates, stats, []

    relayer_client = None
    if wallet_type in {"safe", "proxy"}:
        if not args.relayer_api_key or not args.relayer_api_key_address:
            raise RelayerError(
                "SAFE / PROXY execution needs RELAYER_API_KEY and RELAYER_API_KEY_ADDRESS."
            )
        relayer_client = RelayerClient(
            credentials=RelayerCredentials(
                api_key=args.relayer_api_key,
                api_key_address=args.relayer_api_key_address,
            ),
            relayer_url=args.relayer_url,
        )

    attempts = [
        execute_candidate(
            candidate,
            args=args,
            signer_address=signer_address,
            wallet_address=wallet_address,
            wallet_type=wallet_type,
            relayer_client=relayer_client,
        )
        for candidate in candidates
    ]
    if args.json:
        print(
            json.dumps(
                {
                    "wallet": wallet_address,
                    "walletType": wallet_type,
                    "stats": asdict(stats),
                    "candidates": [asdict(candidate) for candidate in candidates],
                    "attempts": [asdict(attempt) for attempt in attempts],
                },
                indent=2,
            )
        )
    print("-" * 88)
    for attempt in attempts:
        status = attempt.terminal_state or ("SUBMITTED" if attempt.submitted else "SKIPPED")
        print(
            f"{status:>12} | ${attempt.total_value:,.6f} | {attempt.title} | "
            f"{attempt.condition_id}"
        )
        if attempt.transaction_id:
            print(f"             Relayer tx: {attempt.transaction_id}")
        if attempt.transaction_hash:
            print(f"             Chain tx:   {attempt.transaction_hash}")
        if attempt.error:
            print(f"             Error:      {attempt.error}")
    print("-" * 88)
    return candidates, stats, attempts


def main() -> int:
    args = build_parser().parse_args()
    run_count = 0
    while True:
        run_count += 1
        print(f"Run {run_count} at {time.strftime('%Y-%m-%d %H:%M:%S %Z')}")
        try:
            _, _, attempts = run_once(args)
        except Exception as exc:
            print(f"ERROR: {exc}", file=sys.stderr)
            return 1
        if attempts and any(
            attempt.error or attempt.terminal_state in {"STATE_FAILED", "STATE_INVALID", "TIMEOUT"}
            for attempt in attempts
        ):
            return 1

        if args.interval_seconds <= 0:
            break
        if args.max_runs > 0 and run_count >= args.max_runs:
            break
        if attempts and any(attempt.error for attempt in attempts):
            print("Stopping after the first failed execute cycle.")
            break
        time.sleep(args.interval_seconds)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
