// arbitrage_bot::utils::now_str
// entry = 00270e20


/* arbitrage_bot::utils::now_str */

void __rustcall arbitrage_bot::utils::now_str(undefined8 param_1)

{
  long lVar1;
  undefined1 auVar2 [4];
  uint uVar3;
  undefined4 uVar4;
  char cVar5;
  int iVar6;
  int iVar7;
  int iVar8;
  long lVar9;
  undefined **ppuVar10;
  undefined8 *puVar11;
  ulong uVar12;
  ulong uVar13;
  long lVar14;
  ulong uVar15;
  long lVar16;
  long lVar17;
  int *piVar18;
  void *__ptr;
  undefined **unaff_R13;
  undefined **unaff_R14;
  undefined **unaff_R15;
  long *in_FS_OFFSET;
  undefined1 auVar19 [12];
  undefined1 local_188 [4];
  undefined4 uStack_184;
  undefined4 uStack_180;
  int aiStack_17c [2];
  uint local_174;
  uint uStack_170;
  undefined4 local_16c;
  undefined8 local_168;
  undefined8 uStack_160;
  undefined8 uStack_158;
  void *local_150;
  undefined8 local_148;
  undefined **ppuStack_140;
  undefined **local_138;
  undefined8 uStack_130;
  undefined8 local_128;
  undefined8 uStack_120;
  undefined8 local_118;
  undefined8 uStack_110;
  undefined1 local_108;
  undefined7 uStack_107;
  undefined4 uStack_100;
  uint uStack_fc;
  undefined4 uStack_f8;
  uint uStack_f4;
  long lStack_f0;
  long local_e8;
  long lStack_e0;
  long local_d8;
  undefined8 local_c8;
  undefined8 uStack_c0;
  undefined **local_b8;
  undefined4 uStack_b0;
  undefined4 uStack_ac;
  undefined4 local_a8;
  undefined4 uStack_a4;
  undefined4 uStack_a0;
  undefined4 uStack_9c;
  undefined4 local_98;
  undefined4 uStack_94;
  undefined4 uStack_90;
  undefined4 uStack_8c;
  long local_88;
  long lStack_80;
  long local_78;
  long lStack_70;
  long local_68;
  long lStack_60;
  long local_58;
  undefined8 local_48;
  undefined8 uStack_40;
  undefined8 local_38;
  
  chrono::offset::utc::Utc::now(&local_174);
  if (in_FS_OFFSET[-0x2f] != 1) {
    if ((int)in_FS_OFFSET[-0x2f] == 2) {
      std::thread::local::panic_access_error(&PTR_DAT_009858f0);
    }
    std::sys::thread_local::native::lazy::Storage<T,D>::initialize(0);
  }
  if (in_FS_OFFSET[-0x2e] != 0) {
    core::cell::panic_already_borrowed(&PTR_s__usr_local_cargo_registry_src_in_0096ed38);
    goto LAB_002716a3;
  }
  in_FS_OFFSET[-0x2e] = -1;
  local_38 = param_1;
  if (SBORROW8(0,in_FS_OFFSET[-0x2d])) {
                    /* try { // try from 00270e9b to 00270eb3 has its CatchHandler @ 002717ce */
    std::env::_var_os(&local_c8,
                      "TZFindLocalTimeTypeLocalTimeTypeInvalidSliceInvalidTzFileInvalidTzStringOutOfRangeProjectDateTimeSystemTimeTransitionRuleUnsupportedTzFileUnsupportedTzString"
                      ,2);
    if (local_c8 == (undefined8 *)0x8000000000000000) {
      puVar11 = (undefined8 *)0x0;
      unaff_R13 = (undefined **)0x0;
    }
    else {
      core::str::converts::from_utf8(&local_148,uStack_c0,local_b8);
      unaff_R14 = uStack_c0;
      unaff_R15 = local_b8;
      if ((int)local_148 == 1) {
        if (((ulong)local_c8 & 0x7fffffffffffffff) != 0) {
          free(uStack_c0);
        }
        puVar11 = (undefined8 *)0x0;
        unaff_R13 = (undefined **)0x0;
      }
      else {
        puVar11 = local_c8;
        unaff_R13 = (undefined **)0x0;
        if (local_c8 != (undefined8 *)0x8000000000000000) {
          unaff_R13 = uStack_c0;
        }
      }
    }
                    /* try { // try from 00270f2e to 00270f57 has its CatchHandler @ 002717a9 */
    auVar19 = std::sys::pal::unix::time::Timespec::now(0);
    chrono::offset::local::inner::Source::new(local_188,unaff_R13,unaff_R15);
    chrono::offset::local::inner::current_zone(&local_148,unaff_R13,unaff_R15);
    local_58 = local_d8;
    local_68 = local_e8;
    lStack_60 = lStack_e0;
    local_78 = CONCAT44(uStack_f4,uStack_f8);
    lStack_70 = lStack_f0;
    local_88 = CONCAT71(uStack_107,local_108);
    lStack_80 = CONCAT44(uStack_fc,uStack_100);
    local_98 = (undefined4)local_118;
    uStack_94 = local_118._4_4_;
    uStack_90 = (undefined4)uStack_110;
    uStack_8c = uStack_110._4_4_;
    local_a8 = (undefined4)local_128;
    uStack_a4 = local_128._4_4_;
    uStack_a0 = (undefined4)uStack_120;
    uStack_9c = uStack_120._4_4_;
    local_b8 = local_138;
    uStack_b0 = (undefined4)uStack_130;
    uStack_ac = uStack_130._4_4_;
    local_c8 = local_148;
    uStack_c0 = ppuStack_140;
    local_168 = CONCAT44(local_188,(undefined4)local_168);
    uStack_160 = (undefined1 *)CONCAT44(uStack_180,uStack_184);
    uStack_158 = CONCAT44(uStack_158._4_4_,aiStack_17c[0]);
    if (((ulong)puVar11 & 0x7fffffffffffffff) != 0) {
      free(unaff_R14);
    }
    in_FS_OFFSET[-0x1f] = local_58;
    in_FS_OFFSET[-0x21] = local_68;
    in_FS_OFFSET[-0x20] = lStack_60;
    in_FS_OFFSET[-0x23] = local_78;
    in_FS_OFFSET[-0x22] = lStack_70;
    in_FS_OFFSET[-0x25] = local_88;
    in_FS_OFFSET[-0x24] = lStack_80;
    in_FS_OFFSET[-0x27] = CONCAT44(uStack_94,local_98);
    in_FS_OFFSET[-0x26] = CONCAT44(uStack_8c,uStack_90);
    in_FS_OFFSET[-0x29] = CONCAT44(uStack_a4,local_a8);
    in_FS_OFFSET[-0x28] = CONCAT44(uStack_9c,uStack_a0);
    in_FS_OFFSET[-0x2b] = (long)local_b8;
    in_FS_OFFSET[-0x2a] = CONCAT44(uStack_ac,uStack_b0);
    in_FS_OFFSET[-0x2d] = (long)local_c8;
    in_FS_OFFSET[-0x2c] = (long)uStack_c0;
    *(undefined1 (*) [12])(in_FS_OFFSET + -0x1e) = auVar19;
    *(undefined4 *)((long)in_FS_OFFSET + -0xd4) = (undefined4)uStack_158;
    *(undefined4 *)((long)in_FS_OFFSET + -0xe4) = (undefined4)local_168;
    *(undefined4 *)(in_FS_OFFSET + -0x1c) = local_168._4_4_;
    *(undefined4 *)((long)in_FS_OFFSET + -0xdc) = (undefined4)uStack_160;
    *(undefined4 *)(in_FS_OFFSET + -0x1b) = uStack_160._4_4_;
  }
  uVar3 = local_174;
  uVar12 = (ulong)uStack_170;
                    /* try { // try from 002710a2 to 00271119 has its CatchHandler @ 002717ce */
  auVar19 = std::sys::pal::unix::time::Timespec::now(0);
  local_168 = auVar19._0_8_;
  uStack_160 = (undefined1 *)CONCAT44(uStack_160._4_4_,auVar19._8_4_);
  local_c8 = (undefined8 *)in_FS_OFFSET[-0x1e];
  uStack_c0 = (undefined **)CONCAT44(uStack_c0._4_4_,(int)in_FS_OFFSET[-0x1d]);
  std::sys::pal::unix::time::Timespec::sub_timespec(&local_148,&local_168,&local_c8);
  if ((ppuStack_140 != (undefined **)0x0) || (((ulong)local_148 & 1) != 0)) {
    std::env::_var_os(&local_c8,
                      "TZFindLocalTimeTypeLocalTimeTypeInvalidSliceInvalidTzFileInvalidTzStringOutOfRangeProjectDateTimeSystemTimeTransitionRuleUnsupportedTzFileUnsupportedTzString"
                      ,2);
    __ptr = uStack_c0;
    uVar13 = (ulong)local_c8;
    local_48 = uVar12;
    if (local_c8 == (undefined8 *)0x8000000000000000) {
      __ptr = (void *)0x0;
      uVar13 = 0;
    }
    else {
      core::str::converts::from_utf8(&local_148,uStack_c0,local_b8);
      local_150 = __ptr;
      unaff_R13 = local_b8;
      if (((ulong)local_148 & 1) != 0) {
        if ((uVar13 & 0x7fffffffffffffff) != 0) {
          free(__ptr);
        }
        __ptr = (void *)0x0;
        uVar13 = 0;
      }
    }
                    /* try { // try from 0027118d to 002711f1 has its CatchHandler @ 00271780 */
    chrono::offset::local::inner::Source::new(&local_c8,__ptr,unaff_R13);
    if ((int)in_FS_OFFSET[-0x1b] == 1000000000) {
      if ((int)uStack_c0 != 1000000000) goto LAB_002711e2;
      uVar12 = in_FS_OFFSET[-0x1c];
joined_r0x00271672:
      if ((undefined8 *)uVar12 != local_c8) goto LAB_002711e2;
    }
    else {
      if (((int)uStack_c0 != 1000000000) && ((int)in_FS_OFFSET[-0x1b] == (int)uStack_c0)) {
        uVar12 = in_FS_OFFSET[-0x1c];
        goto joined_r0x00271672;
      }
LAB_002711e2:
      chrono::offset::local::inner::current_zone(&local_148,__ptr,unaff_R13);
      if (in_FS_OFFSET[-0x2d] != 0) {
        free((void *)in_FS_OFFSET[-0x2c]);
      }
      if (in_FS_OFFSET[-0x2a] != 0) {
        free((void *)in_FS_OFFSET[-0x29]);
      }
      if (in_FS_OFFSET[-0x27] != 0) {
        free((void *)in_FS_OFFSET[-0x26]);
      }
      in_FS_OFFSET[-0x1f] = local_d8;
      in_FS_OFFSET[-0x21] = local_e8;
      in_FS_OFFSET[-0x20] = lStack_e0;
      in_FS_OFFSET[-0x23] = CONCAT44(uStack_f4,uStack_f8);
      in_FS_OFFSET[-0x22] = lStack_f0;
      in_FS_OFFSET[-0x25] = CONCAT71(uStack_107,local_108);
      in_FS_OFFSET[-0x24] = CONCAT44(uStack_fc,uStack_100);
      in_FS_OFFSET[-0x27] = local_118;
      in_FS_OFFSET[-0x26] = uStack_110;
      in_FS_OFFSET[-0x29] = (long)local_128;
      in_FS_OFFSET[-0x28] = uStack_120;
      in_FS_OFFSET[-0x2b] = (long)local_138;
      in_FS_OFFSET[-0x2a] = uStack_130;
      in_FS_OFFSET[-0x2d] = (long)local_148;
      in_FS_OFFSET[-0x2c] = (long)ppuStack_140;
    }
    uVar12 = local_48;
    *(undefined1 (*) [12])(in_FS_OFFSET + -0x1e) = auVar19;
    *(undefined4 *)(in_FS_OFFSET + -0x1c) = (undefined4)local_c8;
    *(undefined4 *)((long)in_FS_OFFSET + -0xdc) = local_c8._4_4_;
    *(int *)(in_FS_OFFSET + -0x1b) = (int)uStack_c0;
    *(undefined4 *)((long)in_FS_OFFSET + -0xd4) = uStack_c0._4_4_;
    if ((uVar13 & 0x7fffffffffffffff) != 0) {
      free(local_150);
    }
  }
  iVar8 = (int)uVar3 >> 0xd;
  iVar7 = iVar8 + -1;
  iVar6 = 0;
  if (iVar8 < 1) {
    iVar6 = (1U - iVar8) / 400 + 1;
    iVar7 = iVar7 + iVar6 * 400;
    iVar6 = iVar6 * -0x23ab1;
  }
  lVar9 = (long)(int)((iVar7 / 100 >> 2) +
                      (((uVar3 >> 4 & 0x1ff) + iVar6) - iVar7 / 100) + (iVar7 * 0x5b5 >> 2) +
                     -0xaf93b) * 0x15180 + uVar12;
  uVar12 = in_FS_OFFSET[-0x2b];
  uVar13 = in_FS_OFFSET[-0x28];
  if (uVar12 == 0) {
    if (*(char *)((long)in_FS_OFFSET + -0xf3) == '\x03') {
      ppuStack_140 = (undefined **)in_FS_OFFSET[-0x29];
      if (uVar13 == 0) {
        ppuVar10 = &PTR_s__usr_local_cargo_registry_src_in_0096eb98;
        uVar15 = 0;
        uVar13 = 0;
        goto LAB_00271765;
      }
    }
    else {
LAB_00271444:
                    /* try { // try from 00271444 to 0027145d has its CatchHandler @ 002717ce */
      chrono::offset::local::tz_info::rule::TransitionRule::find_local_time_type
                (&local_148,*in_FS_OFFSET + -0x120);
      if ((char)local_148 != '\x10') {
        cVar5 = '\x01';
        if ((char)local_148 != '\a') {
          uVar4 = local_148._1_4_;
          uStack_184 = (undefined4)(CONCAT14(uStack_184._3_1_,local_148._4_4_) >> 8);
          _local_188 = CONCAT44(uStack_184,uVar4);
          cVar5 = (char)local_148;
        }
        auVar2 = local_188;
        local_148._0_5_ = CONCAT41(auVar2,cVar5);
        local_148 = (undefined **)CONCAT44(stack0xfffffffffffffe7b,(int)local_148);
                    /* try { // try from 00271738 to 0027175b has its CatchHandler @ 0027176c */
                    /* WARNING: Subroutine does not return */
        core::result::unwrap_failed
                  (&DAT_007c9d00,0x20,&local_148,
                   &PTR_drop_in_place<chrono::offset::local::tz_info::Error>_0096ec70,
                   &PTR_s__usr_local_cargo_registry_src_in_0096ecc0);
      }
    }
  }
  else {
    lVar1 = in_FS_OFFSET[-0x2c];
    lVar17 = in_FS_OFFSET[-0x25];
    lVar14 = uVar12 * 0x10 + lVar1;
    lVar16 = lVar9;
    if (lVar17 != 0) {
      piVar18 = (int *)(in_FS_OFFSET[-0x26] + 8);
      do {
        if (lVar16 < *(long *)(piVar18 + -2)) break;
        lVar16 = *piVar18 + lVar9;
        piVar18 = piVar18 + 4;
        lVar17 = lVar17 + -1;
      } while (lVar17 != 0);
    }
    if (lVar16 < *(long *)(lVar14 + -0x10)) {
      if (uVar12 == 1) {
        lVar17 = 0;
      }
      else {
        uVar15 = uVar12;
        lVar9 = 0;
        do {
          lVar17 = (uVar15 >> 1) + lVar9;
          if (lVar16 < *(long *)(lVar1 + lVar17 * 0x10)) {
            lVar17 = lVar9;
          }
          uVar15 = uVar15 - (uVar15 >> 1);
          lVar9 = lVar17;
        } while (1 < uVar15);
      }
      lVar9 = *(long *)(lVar1 + lVar17 * 0x10);
      if (lVar9 != lVar16) {
        lVar17 = lVar17 + (ulong)(lVar9 < lVar16);
      }
      lVar17 = lVar17 + (ulong)(lVar9 == lVar16);
      if (lVar17 == 0) {
        uVar15 = 0;
        if (uVar13 == 0) {
LAB_00271688:
          ppuVar10 = &PTR_s__usr_local_cargo_registry_src_in_0096ebc8;
LAB_00271765:
                    /* WARNING: Subroutine does not return */
                    /* try { // try from 00271765 to 00271769 has its CatchHandler @ 002717ce */
          core::panicking::panic_bounds_check(uVar15,uVar13,ppuVar10);
        }
      }
      else {
        uVar15 = lVar17 - 1;
        if (uVar12 <= uVar15) {
          ppuVar10 = &PTR_s__usr_local_cargo_registry_src_in_0096ebb0;
          uVar13 = uVar12;
          goto LAB_00271765;
        }
        uVar15 = *(ulong *)(lVar1 + 8 + uVar15 * 0x10);
        if (uVar13 <= uVar15) goto LAB_00271688;
      }
    }
    else {
      if (*(char *)((long)in_FS_OFFSET + -0xf3) != '\x03') goto LAB_00271444;
      uVar15 = *(ulong *)(lVar14 + -8);
      if (uVar13 <= uVar15) {
        ppuVar10 = &PTR_s__usr_local_cargo_registry_src_in_0096ebe0;
        goto LAB_00271765;
      }
    }
    ppuStack_140 = (undefined **)in_FS_OFFSET[-0x29] + uVar15 * 2;
  }
  iVar7 = *(int *)ppuStack_140;
  in_FS_OFFSET[-0x2e] = in_FS_OFFSET[-0x2e] + 1;
  if (0x2a2fe < iVar7 + 0x1517fU) {
    local_148 = &PTR_s_No_such_local_time_0096ed98;
    ppuStack_140 = (undefined **)0x1;
    local_138 = (undefined **)0x8;
    uStack_130 = 0;
    local_128 = (char *)0x0;
                    /* WARNING: Subroutine does not return */
    core::panicking::panic_fmt(&local_148,&PTR_s__usr_local_cargo_registry_src_in_0096ed80);
  }
  uStack_180 = local_16c;
  aiStack_17c[0] = iVar7;
  chrono::naive::datetime::NaiveDateTime::overflowing_add_offset(&local_174,local_188,iVar7);
  local_48._0_4_ = uStack_170;
  local_48._4_4_ = local_16c;
  uStack_40 = 0;
  local_168 = 0;
  uStack_160 = &DAT_00000001;
  uStack_158 = 0;
  local_b8 = (undefined **)0xe0000020;
  local_c8 = &local_168;
  uStack_c0 = &
              PTR_drop_in_place<alloc::boxed::convert::<impl_core::convert::From<alloc::string::String>for_alloc::boxed::Box<dyn_core::error::Error_core::marker::Send_core::marker::Sync>>::from::StringError>_0096b700
  ;
                    /* try { // try from 0027158f to 0027159e has its CatchHandler @ 002717df */
  cVar5 = _<chrono::offset::fixed::FixedOffset_as_core::fmt::Debug>::fmt(aiStack_17c,&local_c8);
  if (cVar5 == '\0') {
    local_148 = (undefined **)local_168;
    ppuStack_140 = (undefined **)uStack_160;
    local_138 = (undefined **)uStack_158;
    uStack_f4 = local_174;
    uStack_100 = 1;
    uStack_fc = (uint)local_48;
    uStack_f8 = local_48._4_4_;
    uStack_130 = CONCAT44(uStack_130._4_4_,iVar7);
    local_128 = "%H:%M:%S%.3f";
    uStack_120 = 0xc;
    local_118 = 8;
    uStack_110 = 0;
    local_108 = 0;
                    /* try { // try from 0027161b to 0027162c has its CatchHandler @ 00271792 */
    _<T_as_alloc::string::SpecToString>::spec_to_string(local_38,&local_148);
    if ((local_148 != (undefined **)0x8000000000000000) && (local_148 != (undefined **)0x0)) {
      free(ppuStack_140);
    }
    return;
  }
LAB_002716a3:
                    /* try { // try from 002716a3 to 002716c6 has its CatchHandler @ 002717df */
                    /* WARNING: Subroutine does not return */
  core::result::unwrap_failed
            ("a Display implementation returned an error unexpectedly",0x37,&local_148,&DAT_0096b748
             ,&PTR_s__rustc_6b00bc3880198600130e1cf62_00986788);
}


