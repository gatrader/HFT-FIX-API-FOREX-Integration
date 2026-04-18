// arbitrage_bot::market::time::generate_slug
// entry = 0027ff40


/* WARNING: Type propagation algorithm not settling */
/* arbitrage_bot::market::time::generate_slug */

void __rustcall
arbitrage_bot::market::time::generate_slug
          (undefined8 *param_1,undefined8 param_2,undefined8 param_3,int param_4,long param_5)

{
  uint uVar1;
  long lVar3;
  int local_110;
  uint local_10c;
  uint local_108;
  int local_104;
  int iStack_100;
  undefined4 local_fc;
  undefined *local_f8;
  short *local_f0;
  undefined8 *local_e8;
  undefined8 local_e0;
  undefined8 local_d8;
  char *local_c8;
  void *local_c0;
  undefined8 local_b0;
  code *local_a8;
  char **local_a0;
  code *local_98;
  uint *local_90;
  code *local_88;
  uint *local_80;
  code *local_78;
  char **local_70;
  code *local_68;
  long local_60;
  undefined8 local_58;
  undefined8 local_50;
  char *local_48;
  undefined8 uStack_40;
  undefined8 local_38;
  char *local_30;
  undefined8 local_28;
  ulong uVar2;
  
  local_110 = param_4;
  local_60 = param_5;
  if (param_4 != 0x3c) {
    alloc::str::_<impl_str>::to_lowercase(&local_c8,param_2,param_3);
    local_a8 = _<alloc::string::String_as_core::fmt::Display>::fmt;
    local_a0 = (char **)&local_110;
    local_98 = core::fmt::num::imp::_<impl_core::fmt::Display_for_u32>::fmt;
    local_90 = (uint *)&local_60;
    local_88 = core::fmt::num::imp::_<impl_core::fmt::Display_for_i64>::fmt;
    local_f8 = &DAT_0096bb78;
    local_f0 = (short *)0x3;
    local_d8 = 0;
    local_e8 = &local_b0;
    local_e0 = 3;
                    /* try { // try from 00280137 to 00280148 has its CatchHandler @ 00280421 */
    local_b0 = &local_c8;
    alloc::fmt::format::format_inner(&local_48,&local_f8);
    if (local_c8 != (char *)0x0) {
      free(local_c0);
    }
    param_1[2] = local_38;
    *param_1 = local_48;
    param_1[1] = uStack_40;
    return;
  }
  lVar3 = param_5 % 0x15180;
  local_104 = chrono::naive::date::NaiveDate::from_num_days_from_ce_opt
                        ((int)(lVar3 >> 0x3f) + (int)(param_5 / 0x15180) + 0xaf93b);
  if (local_104 == 0) {
                    /* WARNING: Subroutine does not return */
    core::option::expect_failed(&DAT_00842de0,0x11,&PTR_s_src_market_time_rsjanuarymarchap_0096bb00)
    ;
  }
  iStack_100 = (int)lVar3 + 0x15180;
  if (-1 < lVar3) {
    iStack_100 = (int)lVar3;
  }
  local_fc = 0;
  local_58 = CONCAT44(iStack_100,local_104);
  local_50 = 0xffffc7c000000000;
  alloc::str::_<impl_str>::to_lowercase(&local_f8,param_2,param_3);
  if (local_e8 == (undefined8 *)0x3) {
    if ((char)local_f0[1] == 'c' && *local_f0 == 0x7462) {
      local_30 = "bitcoin";
      local_a0 = (char **)7;
      goto joined_r0x002801a2;
    }
    if ((char)local_f0[1] == 'h' && *local_f0 == 0x7465) {
      local_30 = "ethereumfebruary";
      local_a0 = (char **)0x8;
      goto joined_r0x002801a2;
    }
    if ((char)local_f0[1] == 'l' && *local_f0 == 0x6f73) {
      local_30 = "solana";
      local_a0 = (char **)6;
      goto joined_r0x002801a2;
    }
    if ((char)local_f0[1] == 'p' && *local_f0 == 0x7278) {
      local_30 = "xrp";
      local_a0 = (char **)0x3;
      goto joined_r0x002801a2;
    }
  }
                    /* try { // try from 0028007f to 0028008e has its CatchHandler @ 00280411 */
  alloc::str::_<impl_str>::to_lowercase(&local_b0,param_2,param_3);
  local_30 = (char *)local_a8;
joined_r0x002801a2:
  if (local_f8 != (undefined *)0x0) {
    free(local_f0);
  }
  local_28 = local_a0;
  chrono::naive::datetime::NaiveDateTime::overflowing_add_offset(&local_b0,&local_58,0xffffc7c0);
  uVar1 = (uint)local_b0 >> 3 & 0x3ff;
  uVar2 = (ulong)uVar1;
  if (uVar1 < 0x2dd) {
    uVar1 = (uVar1 + (byte)""[uVar2] >> 6) - 1;
    if (uVar1 < 0xc) {
      local_48 = &DAT_007dd304 + *(int *)(&DAT_007dd304 + (ulong)uVar1 * 4);
      uStack_40 = *(undefined8 *)(&DAT_007dd338 + (ulong)uVar1 * 8);
    }
    else {
      uStack_40 = 7;
      local_48 = "unknown";
    }
    chrono::naive::datetime::NaiveDateTime::overflowing_add_offset(&local_b0,&local_58,0xffffc7c0);
    uVar1 = (uint)local_b0 >> 3 & 0x3ff;
    uVar2 = (ulong)uVar1;
    if (uVar1 < 0x2dd) {
      local_10c = ((uint)local_b0 >> 3) + (uint)(byte)""[uVar2] >> 1 & 0x1f;
      chrono::naive::datetime::NaiveDateTime::overflowing_add_offset
                (&local_b0,&local_104,0xffffc7c0);
      local_108 = 0xc;
      local_c8 = "am";
      if ((0xe0f < local_b0._4_4_) && (local_108 = local_b0._4_4_ / 0xe10, 0xa8bf < local_b0._4_4_))
      {
        local_108 = 0xc;
        if (0xe0f < local_b0._4_4_ - 0xa8c0) {
          local_108 = local_b0._4_4_ / 0xe10 - 0xc;
        }
        local_c8 = "pmm-";
      }
      local_c0 = (void *)0x2;
      local_b0 = &local_30;
      local_a8 = _<&T_as_core::fmt::Display>::fmt;
      local_a0 = &local_48;
      local_98 = _<&T_as_core::fmt::Display>::fmt;
      local_90 = &local_10c;
      local_88 = core::fmt::num::imp::_<impl_core::fmt::Display_for_u32>::fmt;
      local_80 = &local_108;
      local_78 = core::fmt::num::imp::_<impl_core::fmt::Display_for_u32>::fmt;
      local_70 = &local_c8;
      local_68 = _<&T_as_core::fmt::Display>::fmt;
      local_f8 = &DAT_0096bb18;
      local_f0 = (short *)0x6;
      local_d8 = 0;
      local_e0 = 5;
      local_e8 = &local_b0;
      alloc::fmt::format::format_inner(param_1,&local_f8);
      return;
    }
  }
                    /* WARNING: Subroutine does not return */
  core::panicking::panic_bounds_check(uVar2,0x2dd,&PTR_DAT_0096edc0);
}


