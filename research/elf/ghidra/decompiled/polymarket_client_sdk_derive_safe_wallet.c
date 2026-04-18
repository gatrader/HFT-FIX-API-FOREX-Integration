// polymarket_client_sdk::derive_safe_wallet
// entry = 003a2e30


/* polymarket_client_sdk::derive_safe_wallet */

void __rustcall
polymarket_client_sdk::derive_safe_wallet(long param_1,undefined4 *param_2,long param_3)

{
  long lVar1;
  undefined8 uVar2;
  long lVar3;
  undefined8 local_b0;
  undefined4 local_a8;
  undefined4 local_a4;
  undefined4 uStack_a0;
  undefined4 uStack_9c;
  undefined4 uStack_98;
  undefined4 local_94;
  undefined1 local_90;
  undefined3 local_8f;
  int iStack_8c;
  int iStack_88;
  undefined5 uStack_84;
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
  lVar3 = (ulong)(iStack_8c + iStack_88 & 1) * 0x38;
  lVar1 = *(long *)(&DAT_00836ec8 + lVar3);
  if (lVar1 == param_3) {
    local_7f = *(undefined4 *)(&DAT_00836ef5 + lVar3);
    uVar2 = *(undefined8 *)(&DAT_00836ee5 + lVar3);
    local_8f = (undefined3)uVar2;
    iStack_8c = (int)((ulong)uVar2 >> 0x18);
    iStack_88._0_1_ = (undefined1)((ulong)uVar2 >> 0x38);
    iStack_88._1_3_ = (undefined3)*(undefined8 *)(&UNK_00836eed + lVar3);
    uStack_84 = (undefined5)((ulong)*(undefined8 *)(&UNK_00836eed + lVar3) >> 0x18);
    local_b0 = 0;
    local_a8 = 0;
    local_a4 = *param_2;
    uStack_a0 = param_2[1];
    uStack_9c = param_2[2];
    uStack_98 = param_2[3];
    local_94 = param_2[4];
    alloy_primitives::utils::keccak256_impl(local_7b,&local_b0,0x20);
    local_4b = 0xd900ed8b1641481f;
    uStack_43 = 0xcfce6fdb5d71efe6;
    local_5b = 0x2721ce2b;
    uStack_57 = 0x63fb07ff;
    uStack_53 = 0x34c8162d;
    uStack_4f = 0x50bf4e7c;
    local_90 = 0xff;
    alloy_primitives::utils::keccak256_impl(local_38,&local_90,0x55);
    *(undefined4 *)(param_1 + 0x11) = local_1c;
    *(undefined8 *)(param_1 + 1) = local_2c;
    *(undefined8 *)(param_1 + 9) = uStack_24;
  }
  *(bool *)param_1 = lVar1 == param_3;
  return;
}


