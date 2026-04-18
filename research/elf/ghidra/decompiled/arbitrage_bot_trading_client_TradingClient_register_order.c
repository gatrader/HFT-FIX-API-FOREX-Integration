// arbitrage_bot::trading::client::TradingClient::register_order
// entry = 002a6aa0


/* arbitrage_bot::trading::client::TradingClient::register_order */

void __rustcall
arbitrage_bot::trading::client::TradingClient::register_order
          (long param_1,void *param_2,size_t param_3,undefined1 param_4)

{
  int *piVar1;
  undefined1 auVar2 [16];
  undefined1 (*pauVar3) [16];
  ulong uVar4;
  uint uVar5;
  byte bVar6;
  char cVar7;
  ushort uVar8;
  int iVar9;
  uint uVar10;
  undefined1 *__dest;
  ulong uVar11;
  ulong uVar12;
  uint uVar13;
  long lVar14;
  undefined8 uVar15;
  byte bVar16;
  bool bVar17;
  byte bVar18;
  undefined1 auVar19 [16];
  undefined1 auVar20 [16];
  char cVar21;
  char cVar22;
  byte bVar23;
  undefined1 auVar24 [16];
  size_t local_a0;
  ulong local_88;
  
  piVar1 = (int *)(param_1 + 0x188);
  LOCK();
  bVar17 = *(int *)(param_1 + 0x188) == 0;
  if (bVar17) {
    *(int *)(param_1 + 0x188) = 0x3fffffff;
  }
  UNLOCK();
  if (bVar17) {
    if ((std::panicking::panic_count::GLOBAL_PANIC_COUNT & 0x7fffffffffffffff) == 0)
    goto LAB_002a6ae2;
LAB_002a6b67:
    bVar6 = std::panicking::panic_count::is_zero_slow_path();
    bVar6 = bVar6 ^ 1;
    cVar7 = *(char *)(param_1 + 400);
  }
  else {
    std::sys::sync::rwlock::futex::RwLock::write_contended(piVar1);
    if ((std::panicking::panic_count::GLOBAL_PANIC_COUNT & 0x7fffffffffffffff) != 0)
    goto LAB_002a6b67;
LAB_002a6ae2:
    bVar6 = 0;
    cVar7 = *(char *)(param_1 + 400);
  }
  if (cVar7 != '\0') {
    if (((bVar6 == 0) &&
        ((std::panicking::panic_count::GLOBAL_PANIC_COUNT & 0x7fffffffffffffff) != 0)) &&
       (cVar7 = std::panicking::panic_count::is_zero_slow_path(), cVar7 == '\0')) {
      *(undefined1 *)(param_1 + 400) = 1;
    }
    LOCK();
    iVar9 = *piVar1;
    *piVar1 = *piVar1 + -0x3fffffff;
    UNLOCK();
    if (iVar9 + 0xc0000001U < 0x40000000) {
      return;
    }
    std::sys::sync::rwlock::futex::RwLock::wake_writer_or_readers(piVar1);
    return;
  }
  if ((long)param_3 < 0) {
    uVar15 = 0;
LAB_002a6e48:
                    /* try { // try from 002a6e48 to 002a6e56 has its CatchHandler @ 002a6eaa */
                    /* WARNING: Subroutine does not return */
    alloc::raw_vec::handle_error(uVar15,param_3,&PTR_s__rustc_6b00bc3880198600130e1cf62_00987e78);
  }
  if (param_3 == 0) {
    __dest = &DAT_00000001;
    local_a0 = 0;
  }
  else {
    __dest = malloc(param_3);
    local_a0 = param_3;
    if (__dest == (undefined1 *)0x0) {
      uVar15 = 1;
      goto LAB_002a6e48;
    }
  }
  memcpy(__dest,param_2,param_3);
  uVar11 = core::hash::BuildHasher::hash_one();
  if (*(long *)(param_1 + 0x1a8) == 0) {
                    /* try { // try from 002a6e11 to 002a6e23 has its CatchHandler @ 002a6e88 */
    hashbrown::raw::RawTable<T,A>::reserve_rehash();
  }
  pauVar3 = *(undefined1 (**) [16])(param_1 + 0x198);
  uVar4 = *(ulong *)(param_1 + 0x1a0);
  bVar16 = (byte)(uVar11 >> 0x38);
  bVar18 = bVar16 >> 1;
  auVar19 = ZEXT216(CONCAT11(bVar18,bVar18));
  auVar19 = pshuflw(auVar19,auVar19,0);
  lVar14 = 0;
  bVar17 = false;
  do {
    uVar11 = uVar11 & uVar4;
    auVar2 = *(undefined1 (*) [16])(*pauVar3 + uVar11);
    cVar7 = auVar19[0];
    auVar20[0] = -(auVar2[0] == cVar7);
    cVar21 = auVar19[1];
    auVar20[1] = -(auVar2[1] == cVar21);
    cVar22 = auVar19[2];
    auVar20[2] = -(auVar2[2] == cVar22);
    bVar23 = auVar19[3];
    auVar20[3] = -(auVar2[3] == bVar23);
    auVar20[4] = -(auVar2[4] == cVar7);
    auVar20[5] = -(auVar2[5] == cVar21);
    auVar20[6] = -(auVar2[6] == cVar22);
    auVar20[7] = -(auVar2[7] == bVar23);
    auVar20[8] = -(auVar2[8] == cVar7);
    auVar20[9] = -(auVar2[9] == cVar21);
    auVar20[10] = -(auVar2[10] == cVar22);
    auVar20[0xb] = -(auVar2[0xb] == bVar23);
    auVar20[0xc] = -(auVar2[0xc] == cVar7);
    auVar20[0xd] = -(auVar2[0xd] == cVar21);
    bVar18 = auVar2[0xf];
    auVar20[0xe] = -(auVar2[0xe] == cVar22);
    auVar20[0xf] = -(bVar18 == bVar23);
    uVar8 = (ushort)(SUB161(auVar20 >> 7,0) & 1) | (ushort)(SUB161(auVar20 >> 0xf,0) & 1) << 1 |
            (ushort)(SUB161(auVar20 >> 0x17,0) & 1) << 2 |
            (ushort)(SUB161(auVar20 >> 0x1f,0) & 1) << 3 |
            (ushort)(SUB161(auVar20 >> 0x27,0) & 1) << 4 |
            (ushort)(SUB161(auVar20 >> 0x2f,0) & 1) << 5 |
            (ushort)(SUB161(auVar20 >> 0x37,0) & 1) << 6 |
            (ushort)(SUB161(auVar20 >> 0x3f,0) & 1) << 7 |
            (ushort)(SUB161(auVar20 >> 0x47,0) & 1) << 8 |
            (ushort)(SUB161(auVar20 >> 0x4f,0) & 1) << 9 |
            (ushort)(SUB161(auVar20 >> 0x57,0) & 1) << 10 |
            (ushort)(SUB161(auVar20 >> 0x5f,0) & 1) << 0xb |
            (ushort)(SUB161(auVar20 >> 0x67,0) & 1) << 0xc |
            (ushort)(SUB161(auVar20 >> 0x6f,0) & 1) << 0xd |
            (ushort)(SUB161(auVar20 >> 0x77,0) & 1) << 0xe | (ushort)(auVar20[0xf] >> 7) << 0xf;
    uVar13 = (uint)uVar8;
    while (uVar8 != 0) {
      uVar10 = 0;
      for (uVar5 = uVar13; (uVar5 & 1) == 0; uVar5 = uVar5 >> 1 | 0x80000000) {
        uVar10 = uVar10 + 1;
      }
      uVar12 = uVar10 + uVar11 & uVar4;
      if ((param_3 == *(size_t *)pauVar3[uVar12 * -2 + -1]) &&
         (iVar9 = bcmp(__dest,*(void **)(pauVar3[uVar12 * -2 + -2] + 8),param_3), iVar9 == 0)) {
        pauVar3[uVar12 * -2 + -1][8] = param_4;
        if (local_a0 != 0) {
          free(__dest);
        }
        goto joined_r0x002a6d61;
      }
      uVar8 = (ushort)(uVar13 - 1) & (ushort)uVar13;
      uVar13 = CONCAT22((short)(uVar13 - 1 >> 0x10),uVar8);
    }
    if (bVar17) goto LAB_002a6d13;
    uVar8 = (ushort)(SUB161(auVar2 >> 7,0) & 1) | (ushort)(SUB161(auVar2 >> 0xf,0) & 1) << 1 |
            (ushort)(SUB161(auVar2 >> 0x17,0) & 1) << 2 |
            (ushort)(SUB161(auVar2 >> 0x1f,0) & 1) << 3 |
            (ushort)(SUB161(auVar2 >> 0x27,0) & 1) << 4 |
            (ushort)(SUB161(auVar2 >> 0x2f,0) & 1) << 5 |
            (ushort)(SUB161(auVar2 >> 0x37,0) & 1) << 6 |
            (ushort)(SUB161(auVar2 >> 0x3f,0) & 1) << 7 |
            (ushort)(SUB161(auVar2 >> 0x47,0) & 1) << 8 |
            (ushort)(SUB161(auVar2 >> 0x4f,0) & 1) << 9 |
            (ushort)(SUB161(auVar2 >> 0x57,0) & 1) << 10 |
            (ushort)(SUB161(auVar2 >> 0x5f,0) & 1) << 0xb |
            (ushort)(SUB161(auVar2 >> 0x67,0) & 1) << 0xc |
            (ushort)(SUB161(auVar2 >> 0x6f,0) & 1) << 0xd |
            (ushort)(SUB161(auVar2 >> 0x77,0) & 1) << 0xe | (ushort)(bVar18 >> 7) << 0xf;
    if (uVar8 == 0) {
      bVar17 = false;
    }
    else {
      uVar13 = 0;
      for (uVar10 = (uint)uVar8; (uVar10 & 1) == 0; uVar10 = uVar10 >> 1 | 0x80000000) {
        uVar13 = uVar13 + 1;
      }
      local_88 = uVar13 + uVar11 & uVar4;
LAB_002a6d13:
      auVar24[0] = -(auVar2[0] == -1);
      auVar24[1] = -(auVar2[1] == -1);
      auVar24[2] = -(auVar2[2] == -1);
      auVar24[3] = -(auVar2[3] == 0xff);
      auVar24[4] = -(auVar2[4] == -1);
      auVar24[5] = -(auVar2[5] == -1);
      auVar24[6] = -(auVar2[6] == -1);
      auVar24[7] = -(auVar2[7] == 0xff);
      auVar24[8] = -(auVar2[8] == -1);
      auVar24[9] = -(auVar2[9] == -1);
      auVar24[10] = -(auVar2[10] == -1);
      auVar24[0xb] = -(auVar2[0xb] == 0xff);
      auVar24[0xc] = -(auVar2[0xc] == -1);
      auVar24[0xd] = -(auVar2[0xd] == -1);
      auVar24[0xe] = -(auVar2[0xe] == -1);
      auVar24[0xf] = -(bVar18 == 0xff);
      if ((((((((((((((((SUB161(auVar24 >> 7,0) & 1) != 0 || (SUB161(auVar24 >> 0xf,0) & 1) != 0) ||
                      (SUB161(auVar24 >> 0x17,0) & 1) != 0) || (SUB161(auVar24 >> 0x1f,0) & 1) != 0)
                    || (SUB161(auVar24 >> 0x27,0) & 1) != 0) || (SUB161(auVar24 >> 0x2f,0) & 1) != 0
                   ) || (SUB161(auVar24 >> 0x37,0) & 1) != 0) ||
                 (SUB161(auVar24 >> 0x3f,0) & 1) != 0) || (SUB161(auVar24 >> 0x47,0) & 1) != 0) ||
               (SUB161(auVar24 >> 0x4f,0) & 1) != 0) || (SUB161(auVar24 >> 0x57,0) & 1) != 0) ||
             (SUB161(auVar24 >> 0x5f,0) & 1) != 0) || (SUB161(auVar24 >> 0x67,0) & 1) != 0) ||
           (SUB161(auVar24 >> 0x6f,0) & 1) != 0) || (SUB161(auVar24 >> 0x77,0) & 1) != 0) ||
          auVar24[0xf] < '\0') {
        bVar18 = (*pauVar3)[local_88];
        if (-1 < (char)bVar18) {
          auVar19 = *pauVar3;
          uVar13 = 0;
          for (uVar10 = (uint)(ushort)((ushort)(SUB161(auVar19 >> 7,0) & 1) |
                                       (ushort)(SUB161(auVar19 >> 0xf,0) & 1) << 1 |
                                       (ushort)(SUB161(auVar19 >> 0x17,0) & 1) << 2 |
                                       (ushort)(SUB161(auVar19 >> 0x1f,0) & 1) << 3 |
                                       (ushort)(SUB161(auVar19 >> 0x27,0) & 1) << 4 |
                                       (ushort)(SUB161(auVar19 >> 0x2f,0) & 1) << 5 |
                                       (ushort)(SUB161(auVar19 >> 0x37,0) & 1) << 6 |
                                       (ushort)(SUB161(auVar19 >> 0x3f,0) & 1) << 7 |
                                       (ushort)(SUB161(auVar19 >> 0x47,0) & 1) << 8 |
                                       (ushort)(SUB161(auVar19 >> 0x4f,0) & 1) << 9 |
                                       (ushort)(SUB161(auVar19 >> 0x57,0) & 1) << 10 |
                                       (ushort)(SUB161(auVar19 >> 0x5f,0) & 1) << 0xb |
                                       (ushort)(SUB161(auVar19 >> 0x67,0) & 1) << 0xc |
                                       (ushort)(SUB161(auVar19 >> 0x6f,0) & 1) << 0xd |
                                       (ushort)(SUB161(auVar19 >> 0x77,0) & 1) << 0xe |
                                      (ushort)(byte)(auVar19[0xf] >> 7) << 0xf); (uVar10 & 1) == 0;
              uVar10 = uVar10 >> 1 | 0x80000000) {
            uVar13 = uVar13 + 1;
          }
          local_88 = (ulong)uVar13;
          bVar18 = (*pauVar3)[local_88];
        }
        *(long *)(param_1 + 0x1a8) = *(long *)(param_1 + 0x1a8) - (ulong)(bVar18 & 1);
        bVar16 = bVar16 >> 1;
        (*pauVar3)[local_88] = bVar16;
        pauVar3[1][uVar4 & local_88 - 0x10] = bVar16;
        *(long *)(param_1 + 0x1b0) = *(long *)(param_1 + 0x1b0) + 1;
        *(size_t *)pauVar3[local_88 * -2 + -2] = local_a0;
        *(undefined1 **)(pauVar3[local_88 * -2 + -2] + 8) = __dest;
        *(size_t *)pauVar3[local_88 * -2 + -1] = param_3;
        pauVar3[local_88 * -2 + -1][8] = param_4;
joined_r0x002a6d61:
        if (((bVar6 == 0) &&
            ((std::panicking::panic_count::GLOBAL_PANIC_COUNT & 0x7fffffffffffffff) != 0)) &&
           (cVar7 = std::panicking::panic_count::is_zero_slow_path(), cVar7 == '\0')) {
          *(undefined1 *)(param_1 + 400) = 1;
        }
        LOCK();
        iVar9 = *piVar1;
        *piVar1 = *piVar1 + -0x3fffffff;
        UNLOCK();
        if (iVar9 + 0xc0000001U < 0x40000000) {
          return;
        }
        std::sys::sync::rwlock::futex::RwLock::wake_writer_or_readers(piVar1);
        return;
      }
      bVar17 = true;
    }
    uVar11 = uVar11 + lVar14 + 0x10;
    lVar14 = lVar14 + 0x10;
  } while( true );
}


