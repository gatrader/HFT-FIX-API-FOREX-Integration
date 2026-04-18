// polymarket_client_sdk::derive_proxy_wallet
// entry = 003a2d60


/* polymarket_client_sdk::derive_proxy_wallet */

void __rustcall
polymarket_client_sdk::derive_proxy_wallet(undefined1 *param_1,undefined8 param_2,long param_3)

{
  undefined1 uVar1;
  long lVar2;
  undefined1 local_90;
  uint local_8f;
  uint uStack_8b;
  undefined4 uStack_87;
  undefined4 uStack_83;
  undefined4 local_7f;
  undefined1 local_7b [32];
  undefined4 local_5b;
  undefined4 uStack_57;
  undefined4 uStack_53;
  undefined4 uStack_4f;
  undefined8 local_4b;
  undefined8 uStack_43;
  undefined1 local_38 [12];
  undefined8 local_2c;
  undefined8 uStack_24;
  undefined4 local_1c;
  
  phf_shared::hash(&local_90,param_3,0x3a55cde48e4e284e);
  lVar2 = (ulong)((local_8f >> 0x18) + (uStack_8b >> 0x18) & 1) * 0x38;
  if ((*(long *)(&DAT_00836ec8 + lVar2) == param_3) && (((&DAT_00836ed0)[lVar2] & 1) != 0)) {
    local_7f = *(undefined4 *)(&DAT_00836ee1 + lVar2);
    local_8f = *(uint *)(&DAT_00836ed1 + lVar2);
    uStack_8b = *(uint *)(&UNK_00836ed5 + lVar2);
    uStack_87 = *(undefined4 *)(&UNK_00836ed9 + lVar2);
    uStack_83 = *(undefined4 *)(&UNK_00836edd + lVar2);
    alloy_primitives::utils::keccak256_impl(local_7b,param_2,0x14);
    local_4b = 0xe08b050bab879286;
    uStack_43 = 0xba03063afe8a95a;
    local_5b = 0xdcf81dd2;
    uStack_57 = 0x860a8865;
    uStack_53 = 0xe09ff006;
    uStack_4f = 0xb8f93dce;
    local_90 = 0xff;
    alloy_primitives::utils::keccak256_impl(local_38,&local_90,0x55);
    *(undefined4 *)(param_1 + 0x11) = local_1c;
    *(undefined8 *)(param_1 + 1) = local_2c;
    *(undefined8 *)(param_1 + 9) = uStack_24;
    uVar1 = 1;
  }
  else {
    uVar1 = 0;
  }
  *param_1 = uVar1;
  return;
}


