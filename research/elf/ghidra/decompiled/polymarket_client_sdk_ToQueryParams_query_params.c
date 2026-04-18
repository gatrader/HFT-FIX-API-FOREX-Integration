// polymarket_client_sdk::ToQueryParams::query_params
// entry = 002b4940


/* WARNING: Type propagation algorithm not settling */
/* polymarket_client_sdk::ToQueryParams::query_params */

void __rustcall
polymarket_client_sdk::ToQueryParams::query_params
          (undefined8 *param_1,int *param_2,undefined8 *******param_3,undefined **param_4)

{
  byte bVar1;
  undefined1 uVar2;
  undefined8 *******pppppppuVar3;
  undefined **ppuVar4;
  undefined8 ******ppppppuVar5;
  undefined8 ******ppppppuVar6;
  undefined8 ******ppppppuVar7;
  undefined2 uVar8;
  undefined6 uVar9;
  undefined8 ******ppppppuVar10;
  undefined **ppuVar11;
  char cVar12;
  long lVar13;
  undefined1 *puVar14;
  bool bVar15;
  undefined1 local_111;
  undefined8 *******local_110;
  undefined **local_108;
  undefined8 local_100;
  undefined8 ******local_f8;
  undefined1 *local_f0;
  undefined8 ******local_e8;
  undefined8 local_e0;
  undefined8 local_d8;
  undefined8 uStack_d0;
  undefined8 local_c8;
  undefined1 local_c0;
  undefined2 local_b8;
  undefined1 uStack_b6;
  undefined1 auStack_b5 [5];
  undefined2 uStack_b0;
  undefined6 uStack_ae;
  undefined2 uStack_a8;
  undefined6 uStack_a6;
  undefined1 local_a0;
  undefined1 uStack_9f;
  undefined6 uStack_9e;
  undefined2 local_98;
  undefined6 uStack_96;
  undefined2 uStack_90;
  undefined8 uStack_8e;
  undefined8 local_86;
  undefined8 uStack_7e;
  undefined8 ******local_70;
  undefined1 *local_68;
  undefined8 ******local_60;
  undefined8 *local_58;
  undefined **local_50;
  undefined8 *******local_48;
  undefined **local_40;
  
  local_70 = (undefined8 ******)0x0;
  local_68 = &DAT_00000001;
  local_60 = (undefined8 ******)0x0;
  local_e8 = &local_70;
  local_e0 = 0;
  local_f8 = (undefined8 ******)0x0;
  local_b8 = SUB82(&local_f8,0);
  uVar8 = local_b8;
  _uStack_b6 = (undefined6)((ulong)&local_f8 >> 0x10);
  uVar9 = _uStack_b6;
  uStack_b0 = 0xe1d8;
  uStack_ae = 0x83;
  uStack_a8 = 2;
  uStack_a6 = 0;
  local_a0 = 0;
  local_58 = param_1;
  local_50 = param_4;
                    /* try { // try from 002b49ec to 002b4b0f has its CatchHandler @ 002b4ebb */
  if ((*(long *)(param_2 + 10) == -0x8000000000000000) ||
     (_<serde_html_form::ser::value::ValueSink<Target>as_serde_html_form::ser::part::Sink>::
      serialize_str(&local_d8,&local_b8,*(undefined8 *)(param_2 + 0xc),
                    *(undefined8 *)(param_2 + 0xe)), pppppppuVar3 = local_d8, ppuVar4 = uStack_d0,
     local_d8 == (undefined8 *******)0x8000000000000002)) {
    uStack_d0 = (undefined **)0x7ddc6b;
    local_c8 = 6;
    local_c0 = 0;
    local_d8 = &local_f8;
    if ((char)param_2[0x10] == '\x01') {
      local_86 = 0;
      uStack_7e = 0;
      uStack_96 = 0;
      uStack_90 = 0;
      uStack_8e = 0;
      uStack_a6 = 0;
      local_a0 = 0;
      uStack_9f = 0;
      uStack_9e = 0;
      local_98 = 0;
      _uStack_b6 = 0;
      uStack_b0 = 0;
      uStack_ae = 0;
      uStack_a8 = 0;
      local_b8 = 0x7830;
      lVar13 = std_detect::detect::cache::CACHE;
      if (std_detect::detect::cache::CACHE == 0) {
                    /* try { // try from 002b4e4e to 002b4e52 has its CatchHandler @ 002b4ebb */
        lVar13 = std_detect::detect::cache::detect_and_initialize();
      }
      if ((short)lVar13 < 0) {
        const_hex::arch::x86::encode_avx2((long)param_2 + 0x41,0x20,&uStack_b6);
      }
      else {
        lVar13 = 0;
        do {
          bVar1 = *(byte *)((long)param_2 + lVar13 + 0x41);
          uVar2 = (&DAT_007c99b0)[bVar1 & 0xf];
          auStack_b5[lVar13 * 2 + -1] = (&DAT_007c99b0)[bVar1 >> 4];
          auStack_b5[lVar13 * 2] = uVar2;
          bVar1 = *(byte *)((long)param_2 + lVar13 + 0x42);
          uVar2 = (&DAT_007c99b0)[bVar1 & 0xf];
          auStack_b5[lVar13 * 2 + 1] = (&DAT_007c99b0)[bVar1 >> 4];
          auStack_b5[lVar13 * 2 + 2] = uVar2;
          lVar13 = lVar13 + 2;
        } while (lVar13 != 0x20);
      }
      _<serde_html_form::ser::value::ValueSink<Target>as_serde_html_form::ser::part::Sink>::
      serialize_str(&local_110,&local_d8,&local_b8,0x42);
      pppppppuVar3 = local_110;
      ppuVar4 = local_108;
      if (local_110 != (undefined8 *******)0x8000000000000002) goto joined_r0x002b4ccd;
    }
    uStack_b0 = 0xae00;
    uStack_ae = 0x7c;
    uStack_a8 = 8;
    uStack_a6 = 0;
    local_a0 = 0;
    local_b8 = uVar8;
    _uStack_b6 = uVar9;
    if (*param_2 == 1) {
      local_110 = (undefined8 *******)0x0;
      local_108 = (undefined **)&DAT_00000001;
      local_100 = 0;
      local_c8 = 0xe0000020;
      local_d8 = &local_110;
      uStack_d0 = &
                  PTR_drop_in_place<alloc::boxed::convert::<impl_core::convert::From<alloc::string::String>for_alloc::boxed::Box<dyn_core::error::Error_core::marker::Send_core::marker::Sync>>::from::StringError>_0096b700
      ;
                    /* try { // try from 002b4b87 to 002b4b93 has its CatchHandler @ 002b4ea3 */
      cVar12 = ruint::fmt::_<impl_core::fmt::Display_for_ruint::Uint<_,_>>::fmt
                         (param_2 + 2,&local_d8);
      ppuVar4 = local_108;
      pppppppuVar3 = local_110;
      if (cVar12 != '\0') {
                    /* try { // try from 002b4e58 to 002b4e7b has its CatchHandler @ 002b4ea3 */
                    /* WARNING: Subroutine does not return */
        core::result::unwrap_failed
                  ("a Display implementation returned an error unexpectedly",0x37,&local_111,
                   &DAT_0096b748,&PTR_s__rustc_6b00bc3880198600130e1cf62_00986788);
      }
                    /* try { // try from 002b4bab to 002b4bbf has its CatchHandler @ 002b4e7e */
      _<serde_html_form::ser::value::ValueSink<Target>as_serde_html_form::ser::part::Sink>::
      serialize_str(&local_48,&local_b8,local_108,local_100);
      if (pppppppuVar3 != (undefined8 *******)0x0) {
        free(ppuVar4);
      }
      pppppppuVar3 = local_48;
      ppuVar4 = local_40;
      if (local_48 != (undefined8 *******)0x8000000000000002) goto joined_r0x002b4ccd;
    }
    bVar15 = local_e8 == (undefined8 ******)0x0;
    local_e8 = (undefined8 ******)0x0;
    ppppppuVar10 = local_70;
    local_f0 = local_68;
    ppppppuVar6 = local_60;
    ppuVar4 = local_108;
    ppppppuVar7 = local_70;
    puVar14 = local_68;
    ppppppuVar5 = local_60;
    ppuVar11 = local_50;
    if (bVar15) {
                    /* try { // try from 002b4e0b to 002b4e22 has its CatchHandler @ 002b4ebb */
                    /* WARNING: Subroutine does not return */
      core::option::expect_failed
                ("url::form_urlencoded::Serializer double finish",0x2e,
                 &PTR_s__usr_local_cargo_registry_src_in_0096d8a8);
    }
  }
  else {
joined_r0x002b4ccd:
    if (local_70 != (undefined8 ******)0x0) {
      free(local_68);
    }
    local_f8 = (undefined8 ******)0x0;
    local_f0 = &DAT_00000001;
    local_e8 = (undefined8 ******)0x0;
    if ((-0x7fffffffffffffff < (long)pppppppuVar3) && (pppppppuVar3 != (undefined8 *******)0x0)) {
      free(ppuVar4);
    }
    ppppppuVar10 = local_f8;
    ppppppuVar6 = local_e8;
    ppuVar4 = local_108;
    ppppppuVar7 = (undefined8 ******)0x0;
    puVar14 = &DAT_00000001;
    ppppppuVar5 = (undefined8 ******)0x0;
    ppuVar11 = local_50;
  }
  local_108 = ppuVar11;
  local_f8 = ppppppuVar10;
  local_e8 = ppppppuVar6;
  local_50 = local_108;
  if (param_3 != (undefined8 *******)0x0) {
    local_110 = param_3;
    if (ppppppuVar5 != (undefined8 ******)0x0) {
      local_e8 = ppppppuVar5;
      if (ppppppuVar7 == ppppppuVar5) {
                    /* try { // try from 002b4e25 to 002b4e3e has its CatchHandler @ 002b4e91 */
        local_e8 = ppppppuVar6;
        alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle(&local_f8,ppppppuVar7,1,1,1);
        puVar14 = local_f0;
      }
      puVar14[(long)local_e8] = 0x26;
      local_e8 = (undefined8 ******)((long)ppppppuVar5 + 1);
    }
    local_d8 = &local_110;
    uStack_d0 = (undefined **)_<&T_as_core::fmt::Display>::fmt;
    local_b8 = 0xd9d8;
    _uStack_b6 = 0x96;
    uStack_b0 = 1;
    uStack_ae = 0;
    local_98 = 0;
    uStack_96 = 0;
    uStack_a8 = SUB82(&local_d8,0);
    uStack_a6 = (undefined6)((ulong)&local_d8 >> 0x10);
    local_a0 = 1;
    uStack_9f = 0;
    uStack_9e = 0;
    core::fmt::write(&local_f8,
                     &
                     PTR_drop_in_place<alloc::boxed::convert::<impl_core::convert::From<alloc::string::String>for_alloc::boxed::Box<dyn_core::error::Error_core::marker::Send_core::marker::Sync>>::from::StringError>_0096db68
                     ,&local_b8);
    ppuVar4 = local_108;
    ppppppuVar5 = local_e8;
  }
  local_108 = ppuVar4;
  if (ppppppuVar5 == (undefined8 ******)0x0) {
    *local_58 = 0;
    local_58[1] = 1;
    local_58[2] = 0;
  }
  else {
    local_108 = (undefined **)_<alloc::string::String_as_core::fmt::Display>::fmt;
    local_b8 = 0x4c30;
    _uStack_b6 = 0x97;
    uStack_b0 = 1;
    uStack_ae = 0;
    local_98 = 0;
    uStack_96 = 0;
    uStack_a8 = SUB82(&local_110,0);
    uStack_a6 = (undefined6)((ulong)&local_110 >> 0x10);
    local_a0 = 1;
    uStack_9f = 0;
    uStack_9e = 0;
                    /* try { // try from 002b4c72 to 002b4db0 has its CatchHandler @ 002b4e91 */
    local_110 = &local_f8;
    alloc::fmt::format::format_inner(&local_d8,&local_b8);
    local_58[2] = local_c8;
    *(undefined4 *)local_58 = (undefined4)local_d8;
    *(undefined4 *)((long)local_58 + 4) = local_d8._4_4_;
    *(undefined4 *)(local_58 + 1) = (undefined4)uStack_d0;
    *(undefined4 *)((long)local_58 + 0xc) = uStack_d0._4_4_;
  }
  if (local_f8 != (undefined8 ******)0x0) {
    free(local_f0);
  }
  return;
}


