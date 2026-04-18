// tokio::runtime::park::CachedParkThread::block_on
// entry = 00208600


/* WARNING: Removing unreachable block (ram,0x0020a4b1) */
/* WARNING: Removing unreachable block (ram,0x0020a4c0) */
/* WARNING: Removing unreachable block (ram,0x0020b67b) */
/* WARNING: Removing unreachable block (ram,0x0020a4c9) */
/* WARNING: Removing unreachable block (ram,0x0020a4d0) */
/* tokio::runtime::park::CachedParkThread::block_on */

undefined1  [16] __rustcall
tokio::runtime::park::CachedParkThread::block_on(undefined8 *param_1,long *param_2)

{
  char cVar1;
  long *plVar2;
  ulong *puVar3;
  code *pcVar4;
  undefined ***pppuVar5;
  ulong uVar6;
  ulong uVar7;
  ulong uVar8;
  undefined **ppuVar9;
  undefined *puVar10;
  long lVar11;
  ulong *puVar12;
  undefined **ppuVar13;
  long unaff_R12;
  long lVar14;
  long *in_FS_OFFSET;
  bool bVar15;
  undefined1 auVar16 [16];
  undefined1 local_499;
  ulong local_450 [9];
  long local_408;
  long local_400;
  ulong local_3f8 [14];
  ulong *local_388;
  long local_350;
  ulong *local_348;
  ulong *local_340 [30];
  ulong *local_250;
  long local_240;
  long local_238;
  long local_230;
  undefined8 local_228;
  long local_210;
  long local_208;
  long local_200;
  undefined **local_1f8;
  long *local_1f0;
  undefined **local_1e8;
  undefined8 *local_1b8;
  long local_1b0;
  long local_1a8;
  long local_1a0;
  long local_198;
  long local_190;
  long local_188;
  long local_180;
  long local_178;
  long local_170;
  long local_168;
  long local_160;
  long local_158;
  long local_150;
  long local_148;
  undefined ***local_140;
  undefined ***local_138;
  undefined8 local_130;
  undefined8 local_120 [30];
  
  lVar14 = in_FS_OFFSET[-5];
  if (lVar14 != 1) {
    if ((int)lVar14 == 2) {
LAB_00208626:
      auVar16._8_8_ = unaff_R12;
      auVar16._0_8_ = lVar14;
      return auVar16;
    }
    std::sys::thread_local::native::lazy::Storage<T,D>::initialize();
  }
  plVar2 = (long *)in_FS_OFFSET[-4];
  LOCK();
  lVar14 = *plVar2;
  *plVar2 = *plVar2 + 1;
  UNLOCK();
  if (*plVar2 == 0 || SCARRY8(lVar14,1) != *plVar2 < 0) {
LAB_0020b99b:
                    /* WARNING: Does not return */
    pcVar4 = (code *)invalidInstructionException();
    (*pcVar4)();
  }
  local_1f0 = plVar2 + 2;
  local_1f8 = &PTR_clone_00985c80;
  local_140 = &local_1f8;
  local_130 = 0;
  param_1 = (undefined8 *)*param_1;
  local_348 = param_1 + 2;
  lVar14 = *param_2;
  local_210 = lVar14 + 0x18;
  local_238 = lVar14 + 0x98;
  local_148 = lVar14 + 0x178;
  local_178 = lVar14 + 0xf8;
  local_170 = lVar14 + 0x108;
  local_180 = lVar14 + 0x110;
  local_150 = lVar14 + 0x118;
  local_158 = lVar14 + 0x128;
  local_188 = lVar14 + 0x138;
  local_190 = lVar14 + 0x168;
  local_400 = lVar14 + 0x188;
  local_168 = lVar14 + 0x100;
  local_198 = lVar14 + 0x140;
  local_1a0 = lVar14 + 0x148;
  local_1a8 = lVar14 + 0x158;
  local_1b0 = lVar14 + 0x150;
  local_160 = lVar14 + 0x130;
  local_408 = lVar14 + 0x1d0;
  local_350 = lVar14 + 0x1e0;
  local_200 = lVar14 + 0x1e8;
  local_240 = lVar14 + 0x1f8;
  local_208 = lVar14 + 0x1c0;
  local_230 = lVar14 + 0x1a0;
  local_1b8 = local_120;
  local_1e8 = &PTR_s__usr_local_cargo_registry_src_in_0096edd8;
  cVar1 = (char)in_FS_OFFSET[-0x30];
  local_138 = local_140;
  if (cVar1 != '\x01') {
    if (cVar1 == '\x02') goto LAB_002088a1;
                    /* try { // try from 0020884e to 00208869 has its CatchHandler @ 0020bdbd */
    std::sys::thread_local::destructors::linux_like::register
              (*in_FS_OFFSET + -0x1c8,std::sys::thread_local::native::eager::destroy);
    *(undefined1 *)(in_FS_OFFSET + -0x30) = 1;
  }
  cVar1 = *(char *)((long)in_FS_OFFSET + -0x184);
  local_499 = *(undefined1 *)((long)in_FS_OFFSET + -0x183);
  *(undefined2 *)((long)in_FS_OFFSET + -0x184) = 0x8001;
LAB_002088a1:
  pppuVar5 = local_140;
  puVar12 = (ulong *)*param_1;
  local_388 = puVar12 + 1;
  local_250 = puVar12 + 2;
  do {
    while (*(char *)(param_1 + 7) == '\0') {
      LOCK();
      bVar15 = (*puVar12 & 0xfffffffffffffffc) + 2 == *puVar12;
      if (bVar15) {
        *puVar12 = *puVar12 & 0xfffffffffffffffc;
      }
      UNLOCK();
      if (bVar15) {
        *(undefined1 *)(param_1 + 7) = 2;
      }
      else {
                    /* try { // try from 002088fc to 002089cb has its CatchHandler @ 0020bdc9 */
        auVar16 = (*(code *)**pppuVar5)(pppuVar5[1]);
        unaff_R12 = auVar16._0_8_;
        LOCK();
        bVar15 = (char)*local_388 == '\0';
        if (bVar15) {
          *(undefined1 *)local_388 = 1;
        }
        UNLOCK();
        if (!bVar15) {
                    /* try { // try from 00208aed to 00208b17 has its CatchHandler @ 0020b9b3 */
          parking_lot::raw_mutex::RawMutex::lock_slow(local_388);
        }
        uVar8 = *puVar12;
        if (uVar8 >> 2 == param_1[1]) {
LAB_0020892a:
          switch((uint)uVar8 & 3) {
          case 0:
            uVar6 = uVar8 & 0xfffffffffffffffc;
            LOCK();
            uVar8 = *puVar12;
            bVar15 = uVar6 == uVar8;
            if (bVar15) {
              *puVar12 = uVar6 + 1;
              uVar8 = uVar6;
            }
            UNLOCK();
            if (!bVar15) {
              local_450[0] = (ulong)((uint)uVar8 & 3);
              if (local_450[0] != 2) {
                ppuVar13 = &PTR_DAT_009863c0;
                puVar10 = &DAT_007cb210;
                puVar12 = local_450;
                goto LAB_0020b716;
              }
              goto LAB_0020892a;
            }
          case 1:
            if (unaff_R12 == 0) {
              local_340[0] = local_348;
              puVar3 = (ulong *)*local_250;
              if (puVar3 == local_348) {
                local_120[0] = 0;
                    /* try { // try from 0020b7f1 to 0020b805 has its CatchHandler @ 0020bec9 */
                core::panicking::assert_failed(local_250,local_340,local_120);
                goto LAB_0020b99b;
              }
              param_1[3] = puVar3;
              param_1[2] = 0;
              if (puVar3 != (ulong *)0x0) {
                *puVar3 = (ulong)local_348;
              }
              puVar12[2] = (ulong)local_348;
              if (puVar12[3] == 0) {
                puVar12[3] = (ulong)local_348;
              }
              *(undefined1 *)(param_1 + 7) = 1;
              LOCK();
              bVar15 = (char)*local_388 == '\x01';
              if (bVar15) {
                *(undefined1 *)local_388 = 0;
              }
              UNLOCK();
              if (!bVar15) {
                    /* try { // try from 0020a3a4 to 0020a3a8 has its CatchHandler @ 0020bdc2 */
                parking_lot::raw_mutex::RawMutex::unlock_slow();
              }
              goto LAB_00208c4c;
            }
            lVar11 = param_1[4];
            local_228 = param_1[5];
            *(undefined1 (*) [16])(param_1 + 4) = auVar16;
            local_340[0] = local_348;
            puVar3 = (ulong *)*local_250;
            if (puVar3 == local_348) {
              local_120[0] = 0;
                    /* try { // try from 0020b7cb to 0020b7df has its CatchHandler @ 0020bedb */
              core::panicking::assert_failed(local_250,local_340,local_120);
              goto LAB_0020b99b;
            }
            param_1[3] = puVar3;
            param_1[2] = 0;
            if (puVar3 != (ulong *)0x0) {
              *puVar3 = (ulong)local_348;
            }
            puVar12[2] = (ulong)local_348;
            if (puVar12[3] == 0) {
              puVar12[3] = (ulong)local_348;
            }
            *(undefined1 *)(param_1 + 7) = 1;
            LOCK();
            bVar15 = (char)*local_388 == '\x01';
            if (bVar15) {
              *(undefined1 *)local_388 = 0;
            }
            UNLOCK();
            if (!bVar15) {
                    /* try { // try from 0020a36f to 0020a373 has its CatchHandler @ 0020b9a7 */
              parking_lot::raw_mutex::RawMutex::unlock_slow();
            }
            if (lVar11 == 0) goto LAB_00208c4c;
            goto LAB_00208bd0;
          case 2:
            uVar7 = uVar8 & 0xfffffffffffffffc;
            uVar6 = uVar7 + 2;
            LOCK();
            uVar8 = *puVar12;
            bVar15 = uVar6 == uVar8;
            if (bVar15) {
              *puVar12 = uVar7;
              uVar8 = uVar6;
            }
            UNLOCK();
            if (!bVar15) goto code_r0x00208985;
            break;
          case 3:
                    /* try { // try from 0020b6bf to 0020b72b has its CatchHandler @ 0020bfc5 */
                    /* WARNING: Subroutine does not return */
            core::panicking::panic
                      ("internal error: entered unreachable code",0x28,&PTR_DAT_009863f0);
          }
        }
        *(undefined1 *)(param_1 + 7) = 2;
        LOCK();
        bVar15 = (char)*local_388 == '\x01';
        if (bVar15) {
          *(undefined1 *)local_388 = 0;
        }
        UNLOCK();
        if (!bVar15) {
          parking_lot::raw_mutex::RawMutex::unlock_slow(local_388);
        }
        if (unaff_R12 != 0) {
          (**(code **)(unaff_R12 + 0x18))(auVar16._8_8_);
        }
      }
    }
    if (*(char *)(param_1 + 7) != '\x01') {
LAB_002090a0:
      lVar14 = 0;
      if (cVar1 != '\x02') {
        if ((char)in_FS_OFFSET[-0x30] != '\x01') {
          if ((char)in_FS_OFFSET[-0x30] == '\x02') goto LAB_0020a4a9;
                    /* try { // try from 0020a46a to 0020a4e1 has its CatchHandler @ 0020bdbd */
          std::sys::thread_local::destructors::linux_like::register
                    (*in_FS_OFFSET + -0x1c8,std::sys::thread_local::native::eager::destroy);
          *(undefined1 *)(in_FS_OFFSET + -0x30) = 1;
        }
        *(char *)((long)in_FS_OFFSET + -0x184) = cVar1;
        *(undefined1 *)((long)in_FS_OFFSET + -0x183) = local_499;
      }
LAB_0020a4a9:
      (*(code *)local_1f8[3])(local_1f0);
      goto LAB_00208626;
    }
    lVar11 = param_1[6];
    if (lVar11 - 1U < 2) {
LAB_00209078:
      lVar14 = param_1[4];
      param_1[4] = 0;
      if (lVar14 != 0) {
                    /* try { // try from 00209090 to 00209092 has its CatchHandler @ 0020bdc2 */
        (**(code **)(lVar14 + 0x18))(param_1[5]);
      }
      param_1[6] = 0;
LAB_0020909b:
      *(undefined1 *)(param_1 + 7) = 2;
      goto LAB_002090a0;
    }
    if (lVar11 != 0) {
      if (lVar11 != 5) {
                    /* try { // try from 0020b845 to 0020b85c has its CatchHandler @ 0020bdf7 */
                    /* WARNING: Subroutine does not return */
        core::panicking::panic("internal error: entered unreachable code",0x28,&PTR_DAT_00986330);
      }
      goto LAB_00209078;
    }
    LOCK();
    bVar15 = (char)*local_388 == '\0';
    if (bVar15) {
      *(undefined1 *)local_388 = 1;
    }
    UNLOCK();
    if (!bVar15) {
                    /* try { // try from 00208b1d to 00208b29 has its CatchHandler @ 0020ba02 */
      parking_lot::raw_mutex::RawMutex::lock_slow(local_388);
    }
    puVar3 = local_388;
    lVar11 = param_1[6];
    if (lVar11 - 1U < 2) {
LAB_0020a31d:
      lVar14 = param_1[4];
      local_228 = param_1[5];
      param_1[4] = 0;
      param_1[6] = 0;
      LOCK();
      bVar15 = (char)*local_388 == '\x01';
      if (bVar15) {
        *(undefined1 *)local_388 = 0;
      }
      UNLOCK();
      if (!bVar15) {
                    /* try { // try from 0020a3f0 to 0020a401 has its CatchHandler @ 0020b9ac */
        parking_lot::raw_mutex::RawMutex::unlock_slow();
      }
      if (lVar14 != 0) {
                    /* try { // try from 0020a35f to 0020a369 has its CatchHandler @ 0020bdc2 */
        (**(code **)(lVar14 + 0x18))(local_228);
      }
      goto LAB_0020909b;
    }
    if (lVar11 != 0) {
      if (lVar11 != 5) {
                    /* try { // try from 0020b862 to 0020b879 has its CatchHandler @ 0020bdcb */
                    /* WARNING: Subroutine does not return */
        core::panicking::panic("internal error: entered unreachable code",0x28,&PTR_DAT_00986330);
      }
      goto LAB_0020a31d;
    }
    ppuVar13 = (undefined **)param_1[4];
    if (*puVar12 >> 2 == param_1[1]) {
      if (ppuVar13 == (undefined **)0x0) {
        ppuVar9 = *pppuVar5;
      }
      else {
        ppuVar9 = *pppuVar5;
        if (ppuVar13 == ppuVar9 && (undefined **)param_1[5] == pppuVar5[1]) {
          lVar11 = 0;
          goto LAB_0020a3d7;
        }
      }
                    /* try { // try from 0020a3ba to 0020a3bb has its CatchHandler @ 0020b9ae */
      auVar16 = (*(code *)*ppuVar9)();
      lVar11 = param_1[4];
      local_228 = param_1[5];
      *(undefined1 (*) [16])(param_1 + 4) = auVar16;
LAB_0020a3d7:
      LOCK();
      bVar15 = (char)*puVar3 == '\x01';
      if (bVar15) {
        *(undefined1 *)puVar3 = 0;
      }
      UNLOCK();
      if (!bVar15) {
        parking_lot::raw_mutex::RawMutex::unlock_slow(puVar3);
      }
      if (lVar11 != 0) {
LAB_00208bd0:
                    /* try { // try from 00208bd0 to 00208bda has its CatchHandler @ 0020bdc2 */
        (**(code **)(lVar11 + 0x18))(local_228);
      }
LAB_00208c4c:
                    /* WARNING: Could not recover jumptable at 0x00208c66. Too many branches */
                    /* WARNING: Treating indirect jump as call */
      auVar16 = (*(code *)(&DAT_007cbd44 +
                          *(int *)(&DAT_007cbd44 + (ulong)*(byte *)(lVar14 + 0x1c4) * 4)))();
      return auVar16;
    }
    local_228 = param_1[5];
    param_1[4] = 0;
    if (param_1[2] == 0) {
      if ((ulong *)*local_250 == local_348) {
        puVar3 = (ulong *)param_1[3];
        *local_250 = (ulong)puVar3;
        goto joined_r0x00208aad;
      }
    }
    else {
      puVar3 = (ulong *)param_1[3];
      *(ulong **)(param_1[2] + 8) = puVar3;
joined_r0x00208aad:
      if (puVar3 == (ulong *)0x0) {
        if ((ulong *)puVar12[3] != local_348) goto LAB_00208abd;
        puVar12[3] = *local_348;
      }
      else {
        *puVar3 = *local_348;
      }
      *local_348 = 0;
      local_348[1] = 0;
    }
LAB_00208abd:
    *(undefined1 *)(param_1 + 7) = 2;
    LOCK();
    bVar15 = (char)*local_388 == '\x01';
    if (bVar15) {
      *(undefined1 *)local_388 = 0;
    }
    UNLOCK();
    if (!bVar15) {
                    /* try { // try from 00208b2f to 00208b3b has its CatchHandler @ 0020b9c0 */
      parking_lot::raw_mutex::RawMutex::unlock_slow(local_388);
    }
    if (ppuVar13 != (undefined **)0x0) {
                    /* try { // try from 00208add to 00208ae7 has its CatchHandler @ 0020ba02 */
      (*(code *)ppuVar13[3])(local_228);
    }
  } while( true );
code_r0x00208985:
  local_3f8[0] = uVar8 & 3;
  if (local_3f8[0] != 0) {
    ppuVar13 = &PTR_DAT_009863d8;
    puVar10 = &DAT_007cab98;
    puVar12 = local_3f8;
LAB_0020b716:
    *local_1b8 = 0;
                    /* WARNING: Subroutine does not return */
    core::panicking::assert_failed(0,puVar12,puVar10,local_1b8,ppuVar13);
  }
  goto LAB_0020892a;
}


