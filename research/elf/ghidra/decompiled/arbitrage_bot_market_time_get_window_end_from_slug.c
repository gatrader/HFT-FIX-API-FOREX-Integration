// arbitrage_bot::market::time::get_window_end_from_slug
// entry = 00280e40


/* arbitrage_bot::market::time::get_window_end_from_slug */

undefined8 __rustcall
arbitrage_bot::market::time::get_window_end_from_slug(long param_1,ulong param_2)

{
  bool bVar1;
  char cVar2;
  uint uVar3;
  ulong uVar4;
  undefined8 uVar5;
  uint uVar6;
  long lVar7;
  ulong uVar8;
  ulong uVar9;
  char *pcVar10;
  ulong uVar11;
  ulong uVar12;
  long lVar13;
  ulong uVar14;
  ulong uVar15;
  bool bVar16;
  
  uVar4 = get_window_start_from_slug();
  if ((uVar4 & 1) == 0) {
    uVar5 = 0;
  }
  else {
    cVar2 = _<&str_as_core::str::pattern::Pattern>::is_contained_in
                      ("-up-or-down--et",0xc,param_1,param_2);
    if (((param_2 < 3) || (cVar2 == '\0')) ||
       (*(char *)(param_1 + -1 + param_2) != 't' || *(short *)(param_1 + -3 + param_2) != 0x652d)) {
      bVar1 = false;
      uVar4 = 0;
      uVar8 = 0;
joined_r0x00280f40:
      uVar15 = uVar4;
      if (uVar4 <= param_2) {
        uVar9 = param_2 - uVar4;
        lVar7 = param_1 + uVar4;
        uVar15 = param_2;
        if (uVar9 < 0x10) {
          if (param_2 != uVar4) {
            uVar12 = 0;
            do {
              if (*(char *)(lVar7 + uVar12) == '-') goto LAB_00281094;
              uVar12 = uVar12 + 1;
            } while (uVar9 != uVar12);
          }
        }
        else {
          uVar14 = (lVar7 + 7U & 0xfffffffffffffff8) - lVar7;
          if (uVar14 == 0) {
            uVar14 = 0;
LAB_00280fb9:
            lVar13 = param_1 + 8 + uVar4;
            do {
              uVar12 = *(ulong *)(lVar13 + -8 + uVar14);
              uVar11 = *(ulong *)(lVar13 + uVar14) ^ 0x2d2d2d2d2d2d2d2d;
              if (((0x101010101010100 - (uVar12 ^ 0x2d2d2d2d2d2d2d2d) | uVar12) & 0x8080808080808080
                  & (0x101010101010100 - uVar11 | uVar11)) != 0x8080808080808080) break;
              uVar14 = uVar14 + 0x10;
            } while (uVar14 <= uVar9 - 0x10);
          }
          else {
            uVar12 = 0;
            do {
              if (*(char *)(lVar7 + uVar12) == '-') goto LAB_00281094;
              uVar12 = uVar12 + 1;
            } while (uVar14 != uVar12);
            if (uVar14 <= uVar9 - 0x10) goto LAB_00280fb9;
          }
          if (uVar9 != uVar14) {
            lVar13 = 0;
            do {
              if (*(char *)(lVar7 + uVar14 + lVar13) == '-') {
                uVar12 = lVar13 + uVar14;
                goto LAB_00281094;
              }
              lVar13 = lVar13 + 1;
            } while ((param_2 - uVar14) - uVar4 != lVar13);
          }
        }
      }
      bVar16 = !bVar1;
      uVar12 = param_2;
      uVar9 = uVar8;
      bVar1 = true;
      if (bVar16) goto LAB_002810ec;
    }
LAB_002811fe:
    uVar5 = 1;
  }
  return uVar5;
LAB_00281094:
  uVar12 = uVar4 + uVar12;
  uVar15 = uVar12 + 1;
  uVar4 = uVar15;
  if (((uVar15 == 0) || (param_2 < uVar15)) || (uVar9 = uVar15, *(char *)(param_1 + uVar12) != '-'))
  goto joined_r0x00280f40;
LAB_002810ec:
  lVar7 = uVar12 - uVar8;
  if (((lVar7 == 0) || (*(char *)(param_1 + -1 + uVar12) != 'm')) || (lVar7 == 1))
  goto LAB_00280f30;
  pcVar10 = (char *)(uVar8 + param_1);
  if (lVar7 == 2) {
    if ((*pcVar10 == '+') || (uVar4 = 1, *pcVar10 == '-')) goto LAB_00280f30;
  }
  else {
    uVar4 = lVar7 - 1;
    if (*pcVar10 == '+') {
      pcVar10 = pcVar10 + 1;
      bVar16 = 9 < uVar4;
      uVar4 = lVar7 - 2;
      if (bVar16) {
LAB_0028114e:
        uVar14 = 0;
        uVar8 = 0;
        do {
          if (uVar4 == uVar14) goto LAB_002811fe;
          uVar3 = (uint)(uVar8 * 10);
          if (((int)(uVar8 * 10 >> 0x20) != 0) || (uVar6 = (byte)pcVar10[uVar14] - 0x30, 9 < uVar6))
          break;
          uVar14 = uVar14 + 1;
          uVar8 = (ulong)(uVar3 + uVar6);
        } while (!CARRY4(uVar3,uVar6));
        goto LAB_00280f30;
      }
    }
    else if (8 < uVar4) goto LAB_0028114e;
  }
  uVar8 = 0;
  while ((byte)pcVar10[uVar8] - 0x30 < 10) {
    uVar8 = uVar8 + 1;
    if (uVar4 == uVar8) goto LAB_002811fe;
  }
LAB_00280f30:
  uVar4 = uVar15;
  uVar8 = uVar9;
  if (bVar1) goto LAB_002811fe;
  goto joined_r0x00280f40;
}


