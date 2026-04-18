// polymarket_client_sdk::auth::to_message
// entry = 0039b250


/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */
/* polymarket_client_sdk::auth::to_message */

void __rustcall
polymarket_client_sdk::auth::to_message(undefined8 param_1,int *param_2,undefined8 param_3)

{
  byte *pbVar1;
  byte *pbVar2;
  ulong uVar3;
  byte bVar4;
  byte bVar5;
  byte bVar6;
  byte bVar7;
  byte bVar8;
  byte bVar9;
  byte bVar10;
  byte bVar11;
  byte bVar12;
  byte bVar13;
  byte bVar14;
  byte bVar15;
  byte bVar16;
  byte bVar17;
  byte bVar18;
  byte bVar19;
  byte bVar20;
  byte bVar21;
  byte bVar22;
  byte bVar23;
  byte bVar24;
  byte bVar25;
  byte bVar26;
  byte bVar27;
  byte bVar28;
  byte bVar29;
  byte bVar30;
  byte bVar31;
  byte bVar32;
  byte bVar33;
  byte bVar34;
  undefined1 auVar35 [16];
  ulong uVar36;
  ulong uVar37;
  char cVar38;
  undefined8 uVar39;
  undefined1 *puVar40;
  int **ppiVar41;
  ulong uVar42;
  byte bVar43;
  byte bVar44;
  byte bVar45;
  byte bVar46;
  byte bVar47;
  byte bVar48;
  byte bVar49;
  byte bVar50;
  byte bVar51;
  byte bVar52;
  byte bVar53;
  byte bVar54;
  byte bVar55;
  byte bVar56;
  byte bVar57;
  byte bVar58;
  byte bVar59;
  byte bVar60;
  byte bVar61;
  byte bVar62;
  byte bVar63;
  byte bVar64;
  byte bVar65;
  byte bVar66;
  byte bVar67;
  byte bVar68;
  byte bVar69;
  byte bVar70;
  byte bVar71;
  byte bVar72;
  byte bVar73;
  byte bVar74;
  size_t local_d8;
  undefined1 *local_d0;
  size_t local_c8;
  undefined8 local_c0;
  int *local_b8;
  undefined8 *local_b0;
  code *local_a8;
  int **local_a0;
  code *local_98;
  undefined1 *local_90;
  code *local_88;
  undefined1 *local_80;
  code *local_78;
  undefined1 local_70 [16];
  undefined *local_60;
  undefined8 local_58;
  undefined8 **local_50;
  undefined8 local_48;
  undefined8 local_40;
  
  local_b8 = param_2 + 0x38;
  puVar40 = &DAT_00000001;
  local_c0 = param_3;
  if ((*param_2 != 1) || (*(long *)(param_2 + 2) == 0)) {
    ppiVar41 = (int **)0x0;
    goto LAB_0039b465;
  }
  alloc::string::String::from_utf8_lossy
            (&local_b0,*(undefined8 *)(param_2 + 4),*(undefined8 *)(param_2 + 6));
  if ((long)local_a0 < 0) {
    uVar39 = 0;
LAB_0039b559:
                    /* try { // try from 0039b559 to 0039b567 has its CatchHandler @ 0039b56a */
                    /* WARNING: Subroutine does not return */
    alloc::raw_vec::handle_error(uVar39,local_a0,&PTR_s__rustc_6b00bc3880198600130e1cf62_00987f90);
  }
  if (local_a0 == (int **)0x0) {
    puVar40 = &DAT_00000001;
    ppiVar41 = (int **)0x0;
  }
  else {
    puVar40 = malloc((size_t)local_a0);
    auVar35 = _DAT_007c8d30;
    if (puVar40 == (undefined1 *)0x0) {
      uVar39 = 1;
      goto LAB_0039b559;
    }
    ppiVar41 = local_a0;
    if ((ulong)((long)puVar40 - (long)local_a8) < 0x20 || local_a0 < 8) {
      uVar36 = 0;
    }
    else {
      if (local_a0 < 0x20) {
        uVar37 = 0;
      }
      else {
        uVar36 = (ulong)local_a0 & 0x7fffffffffffffe0;
        uVar37 = 0;
        do {
          pbVar1 = (byte *)((long)local_a8 + uVar37);
          bVar4 = pbVar1[1];
          bVar5 = pbVar1[2];
          bVar6 = pbVar1[3];
          bVar7 = pbVar1[4];
          bVar8 = pbVar1[5];
          bVar9 = pbVar1[6];
          bVar10 = pbVar1[7];
          bVar11 = pbVar1[8];
          bVar12 = pbVar1[9];
          bVar13 = pbVar1[10];
          bVar14 = pbVar1[0xb];
          bVar15 = pbVar1[0xc];
          bVar16 = pbVar1[0xd];
          bVar17 = pbVar1[0xe];
          bVar18 = pbVar1[0xf];
          pbVar2 = (byte *)((long)local_a8 + uVar37 + 0x10);
          bVar19 = *pbVar2;
          bVar20 = pbVar2[1];
          bVar21 = pbVar2[2];
          bVar22 = pbVar2[3];
          bVar23 = pbVar2[4];
          bVar24 = pbVar2[5];
          bVar25 = pbVar2[6];
          bVar26 = pbVar2[7];
          bVar27 = pbVar2[8];
          bVar28 = pbVar2[9];
          bVar29 = pbVar2[10];
          bVar30 = pbVar2[0xb];
          bVar31 = pbVar2[0xc];
          bVar32 = pbVar2[0xd];
          bVar33 = pbVar2[0xe];
          bVar34 = pbVar2[0xf];
          bVar43 = -(*pbVar1 == auVar35[0]);
          bVar44 = -(bVar4 == auVar35[1]);
          bVar45 = -(bVar5 == auVar35[2]);
          bVar46 = -(bVar6 == auVar35[3]);
          bVar47 = -(bVar7 == auVar35[4]);
          bVar48 = -(bVar8 == auVar35[5]);
          bVar49 = -(bVar9 == auVar35[6]);
          bVar50 = -(bVar10 == auVar35[7]);
          bVar51 = -(bVar11 == auVar35[8]);
          bVar52 = -(bVar12 == auVar35[9]);
          bVar53 = -(bVar13 == auVar35[10]);
          bVar54 = -(bVar14 == auVar35[0xb]);
          bVar55 = -(bVar15 == auVar35[0xc]);
          bVar56 = -(bVar16 == auVar35[0xd]);
          bVar57 = -(bVar17 == auVar35[0xe]);
          bVar58 = -(bVar18 == auVar35[0xf]);
          bVar59 = -(bVar19 == auVar35[0]);
          bVar60 = -(bVar20 == auVar35[1]);
          bVar61 = -(bVar21 == auVar35[2]);
          bVar62 = -(bVar22 == auVar35[3]);
          bVar63 = -(bVar23 == auVar35[4]);
          bVar64 = -(bVar24 == auVar35[5]);
          bVar65 = -(bVar25 == auVar35[6]);
          bVar66 = -(bVar26 == auVar35[7]);
          bVar67 = -(bVar27 == auVar35[8]);
          bVar68 = -(bVar28 == auVar35[9]);
          bVar69 = -(bVar29 == auVar35[10]);
          bVar70 = -(bVar30 == auVar35[0xb]);
          bVar71 = -(bVar31 == auVar35[0xc]);
          bVar72 = -(bVar32 == auVar35[0xd]);
          bVar73 = -(bVar33 == auVar35[0xe]);
          bVar74 = -(bVar34 == auVar35[0xf]);
          pbVar2 = puVar40 + uVar37;
          *pbVar2 = bVar43 & 0x22 | ~bVar43 & *pbVar1;
          pbVar2[1] = bVar44 & 0x22 | ~bVar44 & bVar4;
          pbVar2[2] = bVar45 & 0x22 | ~bVar45 & bVar5;
          pbVar2[3] = bVar46 & 0x22 | ~bVar46 & bVar6;
          pbVar2[4] = bVar47 & 0x22 | ~bVar47 & bVar7;
          pbVar2[5] = bVar48 & 0x22 | ~bVar48 & bVar8;
          pbVar2[6] = bVar49 & 0x22 | ~bVar49 & bVar9;
          pbVar2[7] = bVar50 & 0x22 | ~bVar50 & bVar10;
          pbVar2[8] = bVar51 & 0x22 | ~bVar51 & bVar11;
          pbVar2[9] = bVar52 & 0x22 | ~bVar52 & bVar12;
          pbVar2[10] = bVar53 & 0x22 | ~bVar53 & bVar13;
          pbVar2[0xb] = bVar54 & 0x22 | ~bVar54 & bVar14;
          pbVar2[0xc] = bVar55 & 0x22 | ~bVar55 & bVar15;
          pbVar2[0xd] = bVar56 & 0x22 | ~bVar56 & bVar16;
          pbVar2[0xe] = bVar57 & 0x22 | ~bVar57 & bVar17;
          pbVar2[0xf] = bVar58 & 0x22 | ~bVar58 & bVar18;
          pbVar1 = puVar40 + uVar37 + 0x10;
          *pbVar1 = bVar59 & 0x22 | ~bVar59 & bVar19;
          pbVar1[1] = bVar60 & 0x22 | ~bVar60 & bVar20;
          pbVar1[2] = bVar61 & 0x22 | ~bVar61 & bVar21;
          pbVar1[3] = bVar62 & 0x22 | ~bVar62 & bVar22;
          pbVar1[4] = bVar63 & 0x22 | ~bVar63 & bVar23;
          pbVar1[5] = bVar64 & 0x22 | ~bVar64 & bVar24;
          pbVar1[6] = bVar65 & 0x22 | ~bVar65 & bVar25;
          pbVar1[7] = bVar66 & 0x22 | ~bVar66 & bVar26;
          pbVar1[8] = bVar67 & 0x22 | ~bVar67 & bVar27;
          pbVar1[9] = bVar68 & 0x22 | ~bVar68 & bVar28;
          pbVar1[10] = bVar69 & 0x22 | ~bVar69 & bVar29;
          pbVar1[0xb] = bVar70 & 0x22 | ~bVar70 & bVar30;
          pbVar1[0xc] = bVar71 & 0x22 | ~bVar71 & bVar31;
          pbVar1[0xd] = bVar72 & 0x22 | ~bVar72 & bVar32;
          pbVar1[0xe] = bVar73 & 0x22 | ~bVar73 & bVar33;
          pbVar1[0xf] = bVar74 & 0x22 | ~bVar74 & bVar34;
          uVar37 = uVar37 + 0x20;
        } while (uVar36 != uVar37);
        if (local_a0 == (int **)uVar36) goto LAB_0039b439;
        uVar37 = uVar36;
        if (((ulong)local_a0 & 0x18) == 0) goto LAB_0039b3e2;
      }
      auVar35 = _s__________007c8d50;
      uVar36 = (ulong)local_a0 & 0x7ffffffffffffff8;
      do {
        uVar3 = *(ulong *)((long)local_a8 + uVar37);
        uVar42 = CONCAT17(-((char)(uVar3 >> 0x38) == auVar35[7]),
                          CONCAT16(-((char)(uVar3 >> 0x30) == auVar35[6]),
                                   CONCAT15(-((char)(uVar3 >> 0x28) == auVar35[5]),
                                            CONCAT14(-((char)(uVar3 >> 0x20) == auVar35[4]),
                                                     CONCAT13(-((char)(uVar3 >> 0x18) == auVar35[3])
                                                              ,CONCAT12(-((char)(uVar3 >> 0x10) ==
                                                                         auVar35[2]),
                                                                        CONCAT11(-((char)(uVar3 >> 8
                                                                                         ) ==
                                                                                  auVar35[1]),
                                                                                 -((char)uVar3 ==
                                                                                  auVar35[0]))))))))
        ;
        *(ulong *)(puVar40 + uVar37) = uVar42 & 0x2222222222222222 | ~uVar42 & uVar3;
        uVar37 = uVar37 + 8;
      } while (uVar36 != uVar37);
      if (local_a0 == (int **)uVar36) goto LAB_0039b439;
    }
LAB_0039b3e2:
    uVar37 = uVar36 | 1;
    if (((ulong)local_a0 & 1) != 0) {
      cVar38 = '\"';
      if (*(char *)((long)local_a8 + uVar36) != '\'') {
        cVar38 = *(char *)((long)local_a8 + uVar36);
      }
      puVar40[uVar36] = cVar38;
      uVar36 = uVar37;
    }
    while (local_a0 != (int **)uVar37) {
      cVar38 = *(char *)((long)local_a8 + uVar36);
      if (cVar38 == '\'') {
        cVar38 = '\"';
      }
      puVar40[uVar36] = cVar38;
      cVar38 = *(char *)((long)local_a8 + uVar36 + 1);
      if (cVar38 == '\'') {
        cVar38 = '\"';
      }
      puVar40[uVar36 + 1] = cVar38;
      uVar37 = uVar36 + 2;
      uVar36 = uVar37;
    }
  }
LAB_0039b439:
  if (((ulong)local_b0 & 0x7fffffffffffffff) != 0) {
    free(local_a8);
  }
  if (ppiVar41 == (int **)0x8000000000000000) {
    puVar40 = &DAT_00000001;
    ppiVar41 = (int **)0;
  }
LAB_0039b465:
  local_d8 = (size_t)ppiVar41;
  local_d0 = puVar40;
  local_c8 = (size_t)ppiVar41;
                    /* try { // try from 0039b47a to 0039b52b has its CatchHandler @ 0039b57f */
  local_70 = url::Url::path(param_2 + 0x22);
  local_b0 = &local_c0;
  local_a8 = core::fmt::num::imp::_<impl_core::fmt::Display_for_i64>::fmt;
  local_a0 = &local_b8;
  local_98 = _<&T_as_core::fmt::Display>::fmt;
  local_90 = local_70;
  local_88 = _<&T_as_core::fmt::Display>::fmt;
  local_78 = _<alloc::string::String_as_core::fmt::Display>::fmt;
  local_60 = &DAT_00836688;
  local_58 = 4;
  local_40 = 0;
  local_50 = &local_b0;
  local_48 = 4;
  local_80 = (undefined1 *)&local_d8;
  alloc::fmt::format::format_inner(param_1,&local_60);
  if (local_d8 != 0) {
    free(local_d0);
  }
  return;
}


