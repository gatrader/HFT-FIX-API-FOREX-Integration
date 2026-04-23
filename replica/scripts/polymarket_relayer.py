from __future__ import annotations

import time
from dataclasses import dataclass
from typing import Any

import requests
from eth_abi import encode
from eth_account import Account
from eth_account.messages import encode_defunct
from eth_utils import keccak, to_bytes, to_checksum_address
from web3 import Web3

POLYGON_CHAIN_ID = 137
RELAYER_URL = "https://relayer-v2.polymarket.com"
CTF_ADDRESS = Web3.to_checksum_address("0x4D97DCd97eC945f40cF65F87097ACe5EA0476045")
PUSD_ADDRESS = Web3.to_checksum_address("0xC011a7E12a19f7B1f670d46F03B03f3342E82DFB")
ZERO_ADDRESS = Web3.to_checksum_address("0x0000000000000000000000000000000000000000")
ZERO_BYTES32 = "0x" + ("00" * 32)
SAFE_FACTORY = Web3.to_checksum_address("0xaacFeEa03eb1561C4e67d661e40682Bd20E3541b")
SAFE_MULTISEND = Web3.to_checksum_address("0xA238CBeb142c10Ef7Ad8442C6D1f9E89e07e7761")
PROXY_FACTORY = Web3.to_checksum_address("0xaB45c5A4B0c941a2F231C04C3f49182e1A254052")
RELAY_HUB = Web3.to_checksum_address("0xD216153c06E857cD7f72665E0aF1d7D82172F494")
SAFE_INIT_CODE_HASH = bytes.fromhex(
    "2bce2127ff07fb632d16c8347c4ebf501f4841168bed00d9e6ef715ddb6fcecf"
)
PROXY_INIT_CODE_HASH = bytes.fromhex(
    "d21df8dc65880a8606f09fe0ce3df9b8869287ab0b058be05aa9e8af6330a00b"
)
SAFE_TX_TYPEHASH = keccak(
    text=(
        "SafeTx(address to,uint256 value,bytes data,uint8 operation,"
        "uint256 safeTxGas,uint256 baseGas,uint256 gasPrice,address gasToken,"
        "address refundReceiver,uint256 nonce)"
    )
)
EIP712_DOMAIN_TYPEHASH = keccak(
    text="EIP712Domain(uint256 chainId,address verifyingContract)"
)
DEFAULT_PROXY_GAS_LIMIT = 10_000_000
TERMINAL_STATES = {"STATE_CONFIRMED", "STATE_FAILED", "STATE_INVALID"}


class RelayerError(RuntimeError):
    pass


@dataclass
class RelayerCredentials:
    api_key: str
    api_key_address: str


@dataclass
class RelayPayload:
    address: str
    nonce: str


@dataclass
class RelayerResult:
    transaction_id: str
    state: str
    transaction_hash: str
    proxy_address: str | None = None


def checksum(address: str) -> str:
    return Web3.to_checksum_address(address)


def wallet_type_from_signature_type(signature_type: int) -> str:
    if signature_type == 0:
        return "eoa"
    if signature_type == 1:
        return "proxy"
    if signature_type == 2:
        return "safe"
    raise ValueError(f"Unsupported signature type: {signature_type}")


def derive_safe_address(owner_address: str, safe_factory: str = SAFE_FACTORY) -> str:
    owner = checksum(owner_address)
    factory = checksum(safe_factory)
    salt = keccak(encode(["address"], [owner]))
    return checksum(
        Web3.keccak(b"\xff" + to_bytes(hexstr=factory) + salt + SAFE_INIT_CODE_HASH)[12:]
    )


def derive_proxy_address(owner_address: str, proxy_factory: str = PROXY_FACTORY) -> str:
    owner = checksum(owner_address)
    factory = checksum(proxy_factory)
    salt = keccak(to_bytes(hexstr=owner))
    return checksum(
        Web3.keccak(
            b"\xff" + to_bytes(hexstr=factory) + salt + PROXY_INIT_CODE_HASH
        )[12:]
    )


def split_and_pack_safe_signature(signature_hex: str) -> str:
    raw = bytes.fromhex(signature_hex[2:] if signature_hex.startswith("0x") else signature_hex)
    if len(raw) != 65:
        raise ValueError(f"Invalid signature length: {len(raw)}")
    r = int.from_bytes(raw[0:32], "big")
    s = int.from_bytes(raw[32:64], "big")
    v = raw[64]
    if v in (0, 1):
        packed_v = v + 31
    elif v in (27, 28):
        packed_v = v + 4
    else:
        raise ValueError(f"Invalid signature v: {v}")
    packed = (
        r.to_bytes(32, "big")
        + s.to_bytes(32, "big")
        + packed_v.to_bytes(1, "big")
    )
    return "0x" + packed.hex()


def encode_redeem_positions_call(
    condition_id: str,
    collateral_token: str = PUSD_ADDRESS,
    parent_collection_id: str = ZERO_BYTES32,
    index_sets: list[int] | None = None,
) -> str:
    if index_sets is None:
        index_sets = [1, 2]
    selector = keccak(
        text="redeemPositions(address,bytes32,bytes32,uint256[])"
    )[:4]
    calldata = selector + encode(
        ["address", "bytes32", "bytes32", "uint256[]"],
        [
            checksum(collateral_token),
            to_bytes(hexstr=parent_collection_id),
            to_bytes(hexstr=condition_id),
            index_sets,
        ],
    )
    return "0x" + calldata.hex()


def encode_proxy_batch_call(calls: list[dict[str, Any]]) -> str:
    selector = keccak(text="proxy((uint8,address,uint256,bytes)[])")[:4]
    encoded_calls = []
    for call in calls:
        encoded_calls.append(
            (
                int(call["typeCode"]),
                checksum(call["to"]),
                int(call.get("value", "0")),
                to_bytes(hexstr=call["data"]),
            )
        )
    return "0x" + (selector + encode(["(uint8,address,uint256,bytes)[]"], [encoded_calls])).hex()


def _safe_domain_separator(chain_id: int, safe_address: str) -> bytes:
    return keccak(
        encode(
            ["bytes32", "uint256", "address"],
            [EIP712_DOMAIN_TYPEHASH, chain_id, checksum(safe_address)],
        )
    )


def _safe_struct_hash(
    safe_address: str,
    to: str,
    value: int,
    data: str,
    operation: int,
    safe_tx_gas: int,
    base_gas: int,
    gas_price: int,
    gas_token: str,
    refund_receiver: str,
    nonce: int,
) -> bytes:
    return keccak(
        encode(
            [
                "bytes32",
                "address",
                "uint256",
                "bytes32",
                "uint8",
                "uint256",
                "uint256",
                "uint256",
                "address",
                "address",
                "uint256",
            ],
            [
                SAFE_TX_TYPEHASH,
                checksum(to),
                value,
                keccak(to_bytes(hexstr=data)),
                operation,
                safe_tx_gas,
                base_gas,
                gas_price,
                checksum(gas_token),
                checksum(refund_receiver),
                nonce,
            ],
        )
    )


def build_safe_request(
    *,
    private_key: str,
    signer_address: str,
    nonce: str,
    to: str,
    data: str,
    value: str = "0",
    metadata: str = "",
    chain_id: int = POLYGON_CHAIN_ID,
) -> dict[str, Any]:
    safe_address = derive_safe_address(signer_address)
    domain_separator = _safe_domain_separator(chain_id, safe_address)
    message_hash = _safe_struct_hash(
        safe_address=safe_address,
        to=to,
        value=int(value),
        data=data,
        operation=0,
        safe_tx_gas=0,
        base_gas=0,
        gas_price=0,
        gas_token=ZERO_ADDRESS,
        refund_receiver=ZERO_ADDRESS,
        nonce=int(nonce),
    )
    typed_hash = keccak(b"\x19\x01" + domain_separator + message_hash)
    signature = Account.sign_message(
        encode_defunct(primitive=typed_hash),
        private_key=private_key,
    ).signature.hex()
    return {
        "type": "SAFE",
        "from": checksum(signer_address),
        "to": checksum(to),
        "proxyWallet": safe_address,
        "value": value,
        "data": data,
        "nonce": str(nonce),
        "signature": split_and_pack_safe_signature("0x" + signature),
        "signatureParams": {
            "gasPrice": "0",
            "operation": "0",
            "safeTxnGas": "0",
            "baseGas": "0",
            "gasToken": ZERO_ADDRESS,
            "refundReceiver": ZERO_ADDRESS,
        },
        "metadata": metadata,
    }


def build_proxy_request(
    *,
    private_key: str,
    signer_address: str,
    nonce: str,
    relay_address: str,
    data: str,
    gas_limit: int,
    metadata: str = "",
) -> dict[str, Any]:
    proxy_address = derive_proxy_address(signer_address)
    tx_fee = 0
    gas_price = 0
    payload = b"".join(
        [
            b"rlx:",
            to_bytes(hexstr=checksum(signer_address)),
            to_bytes(hexstr=PROXY_FACTORY),
            to_bytes(hexstr=data),
            tx_fee.to_bytes(32, "big"),
            gas_price.to_bytes(32, "big"),
            int(gas_limit).to_bytes(32, "big"),
            int(nonce).to_bytes(32, "big"),
            to_bytes(hexstr=RELAY_HUB),
            to_bytes(hexstr=checksum(relay_address)),
        ]
    )
    struct_hash = keccak(payload)
    signature = Account.sign_message(
        encode_defunct(primitive=struct_hash),
        private_key=private_key,
    ).signature.hex()
    return {
        "type": "PROXY",
        "from": checksum(signer_address),
        "to": PROXY_FACTORY,
        "proxyWallet": proxy_address,
        "data": data,
        "nonce": str(nonce),
        "signature": "0x" + signature,
        "signatureParams": {
            "gasPrice": "0",
            "gasLimit": str(gas_limit),
            "relayerFee": "0",
            "relayHub": RELAY_HUB,
            "relay": checksum(relay_address),
        },
        "metadata": metadata,
    }


def estimate_proxy_gas(
    rpc_url: str | None,
    signer_address: str,
    data: str,
    default_gas_limit: int = DEFAULT_PROXY_GAS_LIMIT,
) -> int:
    if not rpc_url:
        return default_gas_limit
    try:
        w3 = Web3(Web3.HTTPProvider(rpc_url, request_kwargs={"timeout": 20}))
        if not w3.is_connected():
            return default_gas_limit
        return int(
            w3.eth.estimate_gas(
                {
                    "from": checksum(signer_address),
                    "to": PROXY_FACTORY,
                    "data": data,
                    "value": 0,
                }
            )
        )
    except Exception:
        return default_gas_limit


class RelayerClient:
    def __init__(
        self,
        *,
        credentials: RelayerCredentials,
        relayer_url: str = RELAYER_URL,
        session: requests.Session | None = None,
    ) -> None:
        self.credentials = credentials
        self.relayer_url = relayer_url.rstrip("/")
        self.session = session or requests.Session()

    def _headers(self) -> dict[str, str]:
        return {
            "RELAYER_API_KEY": self.credentials.api_key,
            "RELAYER_API_KEY_ADDRESS": checksum(self.credentials.api_key_address),
            "Content-Type": "application/json",
        }

    def _get(self, path: str, params: dict[str, Any]) -> Any:
        response = self.session.get(
            f"{self.relayer_url}{path}",
            params=params,
            headers=self._headers(),
            timeout=30,
        )
        response.raise_for_status()
        return response.json()

    def _post(self, path: str, payload: dict[str, Any]) -> Any:
        response = self.session.post(
            f"{self.relayer_url}{path}",
            json=payload,
            headers=self._headers(),
            timeout=30,
        )
        response.raise_for_status()
        return response.json()

    def get_nonce(self, signer_address: str, wallet_type: str) -> str:
        payload = self._get(
            "/nonce",
            {"address": checksum(signer_address), "type": wallet_type.upper()},
        )
        return str(payload["nonce"])

    def get_relay_payload(self, signer_address: str) -> RelayPayload:
        payload = self._get(
            "/relay-payload",
            {"address": checksum(signer_address), "type": "PROXY"},
        )
        return RelayPayload(address=checksum(payload["address"]), nonce=str(payload["nonce"]))

    def get_deployed(self, wallet_address: str) -> bool:
        payload = self._get("/deployed", {"address": checksum(wallet_address)})
        return bool(payload.get("deployed"))

    def submit(self, payload: dict[str, Any]) -> RelayerResult:
        body = self._post("/submit", payload)
        return RelayerResult(
            transaction_id=body.get("transactionID", ""),
            state=body.get("state", ""),
            transaction_hash=body.get("transactionHash", body.get("hash", "")),
            proxy_address=body.get("proxyAddress"),
        )

    def get_transaction(self, transaction_id: str) -> RelayerResult | None:
        body = self._get("/transaction", {"id": transaction_id})
        if isinstance(body, list) and body:
            row = body[0]
        elif isinstance(body, dict):
            row = body
        else:
            return None
        return RelayerResult(
            transaction_id=row.get("transactionID", transaction_id),
            state=row.get("state", ""),
            transaction_hash=row.get("transactionHash", row.get("hash", "")),
            proxy_address=row.get("proxyAddress") or row.get("proxyWallet"),
        )

    def wait_for_terminal(
        self,
        transaction_id: str,
        *,
        timeout_seconds: int = 180,
        poll_seconds: float = 2.0,
    ) -> RelayerResult | None:
        deadline = time.time() + timeout_seconds
        while time.time() < deadline:
            current = self.get_transaction(transaction_id)
            if current and current.state in TERMINAL_STATES:
                return current
            time.sleep(poll_seconds)
        return None


def send_eoa_redeem(
    *,
    private_key: str,
    rpc_url: str,
    signer_address: str,
    condition_id: str,
    collateral_token: str = PUSD_ADDRESS,
    gas_multiplier: float = 1.2,
    timeout_seconds: int = 180,
) -> str:
    w3 = Web3(Web3.HTTPProvider(rpc_url, request_kwargs={"timeout": 20}))
    if not w3.is_connected():
        raise RelayerError(f"Could not connect to Polygon RPC at {rpc_url}")
    calldata = encode_redeem_positions_call(
        condition_id=condition_id,
        collateral_token=collateral_token,
    )
    tx = {
        "from": checksum(signer_address),
        "to": CTF_ADDRESS,
        "data": calldata,
        "value": 0,
        "nonce": w3.eth.get_transaction_count(checksum(signer_address)),
        "chainId": POLYGON_CHAIN_ID,
        "gasPrice": w3.eth.gas_price,
    }
    gas_estimate = w3.eth.estimate_gas(tx)
    tx["gas"] = max(int(gas_estimate * gas_multiplier), gas_estimate + 20_000)
    signed = Account.sign_transaction(tx, private_key)
    tx_hash = w3.eth.send_raw_transaction(signed.raw_transaction)
    receipt = w3.eth.wait_for_transaction_receipt(tx_hash, timeout=timeout_seconds)
    if receipt.status != 1:
        raise RelayerError(f"EOA redeem failed for {condition_id}")
    return tx_hash.hex()
