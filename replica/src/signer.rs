//! EIP-712 signing wrapper.
//!
//! Source: FINAL_AUDIT §10. Matches the artifact's use of
//! `alloy_signer_local::PrivateKeySigner`.

use alloy_primitives::{hex, Address};
use alloy_signer::SignerSync;
use alloy_signer_local::PrivateKeySigner;
use alloy_sol_types::SolStruct;

use crate::order::{polymarket_domain, Order};

#[derive(Clone)]
pub struct Eip712Signer {
    signer: PrivateKeySigner,
    maker: Address,
}

impl Eip712Signer {
    pub fn from_hex(hex_key: &str) -> anyhow::Result<Self> {
        let signer: PrivateKeySigner = hex_key.parse()?;
        let maker = signer.address();
        Ok(Self { signer, maker })
    }

    pub fn maker(&self) -> Address {
        self.maker
    }

    /// Signs the EIP-712 Order struct and returns a hex
    /// signature suitable for the CLOB POST body.
    pub fn sign_order(&self, order: &Order) -> anyhow::Result<String> {
        let domain = polymarket_domain();
        let hash = order.eip712_signing_hash(&domain);
        let sig = self.signer.sign_hash_sync(&hash)?;
        Ok(format!("0x{}", hex::encode(sig.as_bytes())))
    }
}
