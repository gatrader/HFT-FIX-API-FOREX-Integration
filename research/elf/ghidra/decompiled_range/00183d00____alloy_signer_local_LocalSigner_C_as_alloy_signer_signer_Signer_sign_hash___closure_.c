// _<alloy_signer_local::LocalSigner<C>as_alloy_signer::signer::Signer>::sign_hash::_{{closure}}
// entry = 00183d00


/* _<alloy_signer_local::LocalSigner<C> as alloy_signer::signer::Signer>::sign_hash::_{{closure}} */

undefined8 * __rustcall
_<alloy_signer_local::LocalSigner<C>as_alloy_signer::signer::Signer>::sign_hash::___closure__
          (undefined8 *param_1,long *param_2)

{
  undefined4 *puVar1;
  undefined8 local_128;
  undefined8 local_120;
  byte local_e8;
  undefined1 local_e7;
  undefined4 local_e0;
  undefined3 uStack_dc;
  undefined4 local_d9;
  undefined4 uStack_d5;
  undefined4 uStack_d1;
  undefined4 uStack_cd;
  undefined8 local_c9;
  undefined1 local_c1;
  undefined8 local_c0;
  undefined8 local_b8;
  undefined8 local_b0;
  undefined8 local_a8;
  undefined8 local_a0;
  undefined8 uStack_98;
  undefined8 local_90;
  undefined8 uStack_88;
  undefined1 local_80;
  undefined7 uStack_7f;
  
  if ((char)param_2[2] != '\0') {
    if ((char)param_2[2] == '\x01') {
      core::panicking::panic_const::panic_const_async_fn_resumed(&PTR_DAT_00969e28);
    }
                    /* WARNING: Subroutine does not return */
    core::panicking::panic_const::panic_const_async_fn_resumed_panic();
  }
  puVar1 = (undefined4 *)param_2[1];
  local_e0 = *puVar1;
  uStack_dc = (undefined3)((uint)*(undefined4 *)((long)puVar1 + 3) >> 8);
  local_d9 = *(undefined4 *)((long)puVar1 + 7);
  uStack_d5 = *(undefined4 *)((long)puVar1 + 0xb);
  uStack_d1 = *(undefined4 *)((long)puVar1 + 0xf);
  uStack_cd = *(undefined4 *)((long)puVar1 + 0x13);
  local_c9 = *(undefined8 *)((long)puVar1 + 0x17);
  local_c1 = *(undefined1 *)((long)puVar1 + 0x1f);
                    /* try { // try from 00183d4e to 00183ddf has its CatchHandler @ 00183e73 */
  ecdsa::hazmat::SignPrimitive::try_sign_prehashed_rfc6979(&local_128,*param_2 + 0x10,&local_e0);
  if (local_e8 != 2) {
    if ((local_e8 & 1) != 0) {
      local_e8 = local_e7;
      _<alloy_primitives::signature::sig::Signature_as_core::convert::From<(ecdsa::Signature<k256::Secp256k1>,ecdsa::recovery::RecoveryId)>>
      ::from(&local_c0,&local_128);
      goto LAB_00183dff;
    }
    local_128 = 0;
  }
  local_c0 = 6;
  local_b0 = local_120;
  local_80 = 2;
  local_b8 = local_128;
LAB_00183dff:
  param_1[8] = CONCAT71(uStack_7f,local_80);
  param_1[6] = local_90;
  param_1[7] = uStack_88;
  param_1[4] = local_a0;
  param_1[5] = uStack_98;
  param_1[2] = local_b0;
  param_1[3] = local_a8;
  *param_1 = local_c0;
  param_1[1] = local_b8;
  *(undefined1 *)(param_2 + 2) = 1;
  return param_1;
}


