// arbitrage_bot::market::time::get_window_start_from_slug
// entry = 00280440


/* arbitrage_bot::market::time::get_window_start_from_slug */

undefined1  [16] __rustcall
arbitrage_bot::market::time::get_window_start_from_slug(ulong param_1,ulong param_2)

{
  short sVar1;
  long *__s1;
  size_t __n;
  ulong uVar2;
  undefined1 (*__ptr) [16];
  char cVar3;
  uint uVar4;
  uint uVar5;
  undefined8 uVar6;
  undefined1 (*pauVar7) [16];
  ulong uVar8;
  char *pcVar9;
  int iVar10;
  int iVar12;
  int iVar13;
  ulong uVar14;
  long lVar15;
  uint uVar16;
  undefined **ppuVar17;
  bool bVar18;
  undefined1 auVar19 [16];
  undefined1 auVar20 [16];
  ulong local_118;
  undefined1 (*local_110) [16];
  ulong local_108;
  char *local_100;
  undefined8 local_f8;
  ulong uStack_f0;
  ulong local_e8;
  ulong uStack_e0;
  undefined8 local_d8;
  ulong uStack_d0;
  undefined8 local_c8;
  undefined8 uStack_c0;
  undefined8 local_b8;
  long local_b0;
  ulong local_90;
  ulong local_88;
  undefined2 local_80;
  ulong local_78;
  ulong uStack_70;
  ulong local_68;
  ulong uStack_60;
  undefined8 local_58;
  ulong uStack_50;
  undefined8 local_48;
  undefined1 uStack_40;
  undefined7 uStack_3f;
  undefined2 local_38;
  undefined6 uStack_36;
  ulong uVar11;
  
  cVar3 = _<&str_as_core::str::pattern::Pattern>::is_contained_in
                    ("-up-or-down--et",0xc,param_1,param_2);
  if (((2 < param_2) && (cVar3 != '\0')) &&
     (*(char *)((param_1 - 1) + param_2) == 't' && *(short *)((param_1 - 3) + param_2) == 0x652d)) {
    core::str::pattern::StrSearcher::new(&local_f8,param_1,param_2,"-up-or-down--et",0xc);
    local_90 = 0;
    local_80 = 1;
    local_88 = param_2;
    _<core::str::pattern::StrSearcher_as_core::str::pattern::Searcher>::next_match
              (&local_78,&local_f8);
    lVar15 = local_b0;
    if (((local_78 & 1) != 0) && (local_90 = local_68, (local_80 & 0x100) == 0)) {
      _<core::str::pattern::StrSearcher_as_core::str::pattern::Searcher>::next_match
                (&local_78,&local_f8);
      if ((int)local_78 == 1) {
        uStack_70 = uStack_70 - local_90;
        local_b0 = lVar15;
      }
      else {
        if ((local_80._1_1_ != '\0') || (((char)local_80 != '\x01' && (local_88 == local_90))))
        goto LAB_00280d3a;
        uStack_70 = local_88 - local_90;
      }
      local_68 = local_b0 + local_90;
      local_78 = 0;
      local_58 = 0;
      local_48 = 0x2d0000002d;
      uStack_40 = 1;
      local_38 = 1;
      uStack_60 = uStack_70;
      uStack_50 = uStack_70;
      auVar19 = _<core::str::iter::Split<P>as_core::iter::traits::iterator::Iterator>::next
                          (&local_78);
      if (auVar19._0_8_ != 0) {
        pauVar7 = malloc(0x40);
        if (pauVar7 == (undefined1 (*) [16])0x0) {
                    /* WARNING: Subroutine does not return */
          alloc::raw_vec::handle_error(8,0x40,&PTR_s__rustc_6b00bc3880198600130e1cf62_00987f90);
        }
        *pauVar7 = auVar19;
        local_118 = 4;
        local_108 = 1;
        local_b8 = CONCAT62(uStack_36,local_38);
        uStack_c0 = CONCAT71(uStack_3f,uStack_40);
        local_c8 = local_48;
        local_d8 = local_58;
        uStack_d0 = uStack_50;
        local_e8 = local_68;
        uStack_e0 = uStack_60;
        local_f8 = local_78;
        uStack_f0 = uStack_70;
        lVar15 = 0x18;
        local_110 = pauVar7;
        while( true ) {
                    /* try { // try from 002808ea to 0028091d has its CatchHandler @ 00280e13 */
          param_1 = local_108;
          auVar19 = _<core::str::iter::Split<P>as_core::iter::traits::iterator::Iterator>::next();
          __ptr = local_110;
          uVar11 = local_118;
          if (auVar19._0_8_ == 0) break;
          if (param_1 == local_118) {
            alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle
                      (&local_118,param_1,1,8,0x10);
            pauVar7 = local_110;
          }
          *(long *)(pauVar7[-1] + lVar15 + 8) = auVar19._0_8_;
          *(long *)((long)*pauVar7 + lVar15) = auVar19._8_8_;
          local_108 = param_1 + 1;
          lVar15 = lVar15 + 0x10;
        }
        if ((3 < param_1) && (uVar14 = *(ulong *)(local_110[1] + 8), uVar14 != 0)) {
          __s1 = *(long **)*local_110;
          __n = *(size_t *)(*local_110 + 8);
          pcVar9 = *(char **)local_110[1];
          if (uVar14 == 1) {
            if ((*pcVar9 != '+') && (uVar14 = 1, *pcVar9 != '-')) goto LAB_002809c4;
            goto LAB_00280d2c;
          }
          if (*pcVar9 == '+') {
            pcVar9 = pcVar9 + 1;
            uVar8 = uVar14 - 1;
            bVar18 = 9 < uVar14;
            uVar14 = uVar8;
            if (bVar18) {
LAB_00280982:
              uVar8 = 0;
              param_1 = 0;
              do {
                if (uVar14 == uVar8) goto LAB_002809e9;
                uVar2 = param_1 * 10;
                if ((int)(uVar2 >> 0x20) != 0) break;
                param_1 = uVar2 & 0xffffffff;
                uVar16 = (byte)pcVar9[uVar8] - 0x30;
                if (9 < uVar16) break;
                uVar8 = uVar8 + 1;
                param_1 = (ulong)((uint)uVar2 + uVar16);
              } while (!CARRY4((uint)uVar2,uVar16));
              goto LAB_00280d2c;
            }
          }
          else if (8 < uVar14) goto LAB_00280982;
LAB_002809c4:
          uVar8 = 0;
          param_1 = 0;
          do {
            if (9 < (byte)pcVar9[uVar8] - 0x30) goto LAB_00280d2c;
            param_1 = (ulong)(((byte)pcVar9[uVar8] - 0x30) + (int)param_1 * 10);
            uVar8 = uVar8 + 1;
          } while (uVar14 != uVar8);
LAB_002809e9:
          if (6 < __n - 3) goto LAB_00280d2c;
          pcVar9 = *(char **)local_110[2];
          uVar14 = *(ulong *)(local_110[2] + 8);
          switch(__n) {
          case 3:
            if (*(char *)((long)__s1 + 2) != 'y' || (short)*__s1 != 0x616d) goto LAB_00280d2c;
            uVar6 = 5;
            break;
          case 4:
            if ((int)*__s1 == 0x656e756a) {
              uVar6 = 6;
            }
            else {
              if ((int)*__s1 != 0x796c756a) goto LAB_00280d2c;
              uVar6 = 7;
            }
            break;
          case 5:
            if (*(char *)((long)__s1 + 4) == 'h' && (int)*__s1 == 0x6372616d) {
              uVar6 = 3;
            }
            else {
              if (*(char *)((long)__s1 + 4) != 'l' || (int)*__s1 != 0x69727061) goto LAB_00280d2c;
              uVar6 = 4;
            }
            break;
          case 6:
            if (*(short *)((long)__s1 + 4) != 0x7473 || (int)*__s1 != 0x75677561) goto LAB_00280d2c;
            uVar6 = 8;
            break;
          case 7:
            if (*(int *)((long)__s1 + 3) == 0x79726175 && (int)*__s1 == 0x756e616a) {
              uVar6 = 1;
            }
            else {
              iVar13 = bcmp(__s1,"october",__n);
              if (iVar13 != 0) goto LAB_00280d2c;
              uVar6 = 10;
            }
            break;
          case 8:
            if (*__s1 == 0x7972617572626566) {
              uVar6 = 2;
            }
            else {
              local_100 = pcVar9;
              iVar13 = bcmp(__s1,"november",__n);
              if (iVar13 == 0) {
                uVar6 = 0xb;
                pcVar9 = local_100;
              }
              else {
                iVar13 = bcmp(__s1,"december-updown-",__n);
                if (iVar13 != 0) goto LAB_00280d2c;
                uVar6 = 0xc;
                pcVar9 = local_100;
              }
            }
            break;
          case 9:
            if ((char)__s1[1] != 'r' || *__s1 != 0x65626d6574706573) goto LAB_00280d2c;
            uVar6 = 9;
          }
          if (uVar14 < 2) goto LAB_00280d2c;
          sVar1 = *(short *)(pcVar9 + (uVar14 - 2));
          if (sVar1 == 0x6d70) {
            if (uVar14 - 2 != 0) {
              if (pcVar9[uVar14 - 2] < -0x40) {
                ppuVar17 = &PTR_s_src_market_time_rsjanuarymarchap_0096bbc0;
                goto LAB_00280dfd;
              }
              goto LAB_00280c09;
            }
            goto LAB_00280d2c;
          }
          if ((*(short *)(pcVar9 + (uVar14 - 2)) != 0x6d61) || (uVar14 - 2 == 0)) goto LAB_00280d2c;
          if (pcVar9[uVar14 - 2] < -0x40) {
            ppuVar17 = &PTR_s_src_market_time_rsjanuarymarchap_0096bba8;
LAB_00280dfd:
                    /* try { // try from 00280dfd to 00280e06 has its CatchHandler @ 00280e09 */
                    /* WARNING: Subroutine does not return */
            core::str::slice_error_fail(pcVar9,uVar14,0,uVar14 - 2,ppuVar17);
          }
LAB_00280c09:
          uVar8 = uVar14 - 2;
          cVar3 = *pcVar9;
          if (uVar8 == 1) {
            if ((cVar3 != '+') && (uVar8 = 1, cVar3 != '-')) goto LAB_00280c82;
            goto LAB_00280d2c;
          }
          if (cVar3 == '+') {
            pcVar9 = pcVar9 + 1;
            bVar18 = 9 < uVar8;
            uVar8 = uVar14 - 3;
            if (bVar18) {
LAB_00280c41:
              uVar14 = 0;
              uVar16 = 0;
              do {
                if (uVar8 == uVar14) goto LAB_00280ca8;
                uVar4 = (uint)((ulong)uVar16 * 10);
                if (((int)((ulong)uVar16 * 10 >> 0x20) != 0) ||
                   (uVar5 = (byte)pcVar9[uVar14] - 0x30, 9 < uVar5)) break;
                uVar14 = uVar14 + 1;
                uVar16 = uVar4 + uVar5;
              } while (!CARRY4(uVar4,uVar5));
              goto LAB_00280d2c;
            }
          }
          else if (8 < uVar8) goto LAB_00280c41;
LAB_00280c82:
          uVar14 = 0;
          uVar16 = 0;
          do {
            if (9 < (byte)pcVar9[uVar14] - 0x30) goto LAB_00280d2c;
            uVar16 = ((byte)pcVar9[uVar14] - 0x30) + uVar16 * 10;
            uVar14 = uVar14 + 1;
          } while (uVar8 != uVar14);
LAB_00280ca8:
                    /* try { // try from 00280ca8 to 00280cb4 has its CatchHandler @ 00280e09 */
          chrono::offset::utc::Utc::now(&local_78);
          uVar4 = uVar16 + 0xc;
          uVar5 = 0xc;
          if (sVar1 != 0x6d70) {
            uVar4 = uVar16;
            uVar5 = 0;
          }
          if (uVar16 == 0xc) {
            uVar4 = uVar5;
          }
          chrono::naive::datetime::NaiveDateTime::overflowing_add_offset(&local_f8,&local_78,0);
          chrono::offset::TimeZone::with_ymd_and_hms
                    (&local_f8,(int)local_f8 >> 0xd,uVar6,param_1,uVar4);
          iVar13 = 0;
          uVar14 = uStack_f0 & 0xffffffff;
          if ((int)local_f8 != 0) {
            uVar14 = 0;
          }
          if (local_f8._4_4_ == 0 || (int)local_f8 != 0) goto LAB_00280d2c;
          iVar12 = (int)local_f8._4_4_ >> 0xd;
          iVar10 = iVar12 + -1;
          if (iVar12 < 1) {
            iVar13 = (1U - iVar12) / 400 + 1;
            iVar10 = iVar10 + iVar13 * 400;
            iVar13 = iVar13 * -0x23ab1;
          }
          param_1 = (long)(int)((((local_f8._4_4_ >> 4 & 0x1ff) + iVar13) - iVar10 / 100) +
                                (iVar10 * 0x5b5 >> 2) + (iVar10 / 100 >> 2) + -0xaf93b) * 0x15180 +
                    uVar14;
          if (uVar11 != 0) {
            free(__ptr);
          }
LAB_002806d2:
          uVar6 = 1;
          goto LAB_00280d3c;
        }
LAB_00280d2c:
        if (uVar11 != 0) {
          free(__ptr);
        }
      }
    }
LAB_00280d3a:
    uVar6 = 0;
    goto LAB_00280d3c;
  }
  local_f8 = 0;
  local_d8 = 0;
  local_c8 = 0x2d0000002d;
  uStack_c0 = CONCAT71(uStack_c0._1_7_,1);
  local_b8 = CONCAT62(local_b8._2_6_,1);
  uStack_f0 = param_2;
  local_e8 = param_1;
  uStack_e0 = param_2;
  uStack_d0 = param_2;
  auVar19 = core::str::iter::SplitInternal<P>::next_back(&local_f8);
  uVar11 = auVar19._8_8_;
  pcVar9 = auVar19._0_8_;
  if (pcVar9 == (char *)0x0) goto LAB_00280d3a;
  if (uVar11 == 0) {
    uVar6 = 0;
    goto LAB_00280d3c;
  }
  if (uVar11 == 1) {
    cVar3 = *pcVar9;
    uVar6 = 0;
    if ((cVar3 == '+') || (cVar3 == '-')) goto LAB_00280d3c;
    if (cVar3 == '-') goto LAB_0028061e;
LAB_00280520:
    if (cVar3 == '+') {
      auVar19._8_8_ = uVar11 - 1;
      auVar19._0_8_ = pcVar9 + 1;
      if (uVar11 < 0x11) {
        if (uVar11 - 1 != 0) goto LAB_002806a5;
        goto LAB_00280765;
      }
    }
    else if (uVar11 < 0x10) {
LAB_002806a5:
      uVar6 = 0;
      lVar15 = 0;
      param_1 = 0;
      do {
        uVar16 = *(byte *)(auVar19._0_8_ + lVar15) - 0x30;
        if (9 < uVar16) goto LAB_00280d3c;
        param_1 = (ulong)uVar16 + param_1 * 10;
        lVar15 = lVar15 + 1;
      } while (auVar19._8_8_ != lVar15);
      goto LAB_002806d2;
    }
    uVar6 = 0;
    lVar15 = 0;
    param_1 = 0;
    do {
      if (auVar19._8_8_ == lVar15) goto LAB_002806d2;
      auVar20 = SEXT816((long)param_1);
      param_1 = param_1 * 10;
      uVar16 = *(byte *)(auVar19._0_8_ + lVar15) - 0x30;
      if ((9 < uVar16) || (SEXT816((long)param_1) != auVar20 * SEXT816(10))) break;
      lVar15 = lVar15 + 1;
      bVar18 = SCARRY8(param_1,(ulong)uVar16);
      param_1 = param_1 + uVar16;
    } while (!bVar18);
  }
  else {
    cVar3 = *pcVar9;
    if (cVar3 != '-') goto LAB_00280520;
LAB_0028061e:
    if (0x10 < uVar11) {
      uVar6 = 0;
      uVar14 = 1;
      param_1 = 0;
      do {
        if (uVar11 == uVar14) goto LAB_002806d2;
        auVar19 = SEXT816((long)param_1);
        param_1 = param_1 * 10;
        uVar16 = (byte)pcVar9[uVar14] - 0x30;
        if ((9 < uVar16) || (SEXT816((long)param_1) != auVar19 * SEXT816(10))) break;
        uVar14 = uVar14 + 1;
        bVar18 = SBORROW8(param_1,(ulong)uVar16);
        param_1 = param_1 - uVar16;
      } while (!bVar18);
      goto LAB_00280d3c;
    }
    if (uVar11 != 1) {
      uVar14 = 1;
      param_1 = 0;
      do {
        if (9 < (byte)pcVar9[uVar14] - 0x30) goto LAB_00280d3a;
        param_1 = param_1 * 10 - (ulong)((byte)pcVar9[uVar14] - 0x30);
        uVar14 = uVar14 + 1;
        uVar6 = 1;
      } while (uVar11 != uVar14);
      goto LAB_00280d3c;
    }
LAB_00280765:
    uVar6 = 1;
    param_1 = 0;
  }
LAB_00280d3c:
  auVar20._8_8_ = param_1;
  auVar20._0_8_ = uVar6;
  return auVar20;
}


