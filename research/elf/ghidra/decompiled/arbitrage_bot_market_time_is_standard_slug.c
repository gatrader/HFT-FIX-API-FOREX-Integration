// arbitrage_bot::market::time::is_standard_slug
// entry = 0027fba0


/* arbitrage_bot::market::time::is_standard_slug */

ulong __rustcall arbitrage_bot::market::time::is_standard_slug(long param_1,ulong param_2)

{
  char cVar1;
  ushort uVar2;
  ushort uVar4;
  ulong uVar5;
  ulong uVar6;
  uint uVar7;
  long lVar9;
  long lVar10;
  long lVar11;
  ulong uVar12;
  undefined1 auVar13 [16];
  undefined8 local_58;
  ulong local_50;
  long local_48;
  ulong local_40;
  undefined8 local_38;
  ulong local_30;
  undefined8 local_28;
  undefined1 local_20;
  undefined2 local_18;
  char *pcVar3;
  ulong uVar8;
  
  uVar5 = param_2;
  cVar1 = _<&str_as_core::str::pattern::Pattern>::is_contained_in
                    ("-up-or-down--et",0xc,param_1,param_2);
  if ((2 < param_2) && (cVar1 != '\0')) {
    uVar2 = *(ushort *)(param_1 + -3 + param_2) ^ 0x652d;
    uVar4 = *(byte *)(param_1 + -1 + param_2) ^ 0x74 | uVar2;
    uVar5 = (ulong)uVar4;
    if (uVar4 == 0) {
      uVar6 = CONCAT71((uint7)(byte)(uVar2 >> 8),1);
      goto LAB_0027fd9f;
    }
  }
  local_58 = 0;
  local_38 = 0;
  local_28 = 0x2d0000002d;
  local_20 = 1;
  local_18 = 1;
  local_50 = param_2;
  local_48 = param_1;
  local_40 = param_2;
  local_30 = param_2;
  auVar13 = core::str::iter::SplitInternal<P>::next_back(&local_58);
  uVar8 = auVar13._8_8_;
  pcVar3 = auVar13._0_8_;
  if ((pcVar3 == (char *)0x0) || (uVar8 == 0)) {
LAB_0027fd9d:
    uVar6 = 0;
    goto LAB_0027fd9f;
  }
  if (uVar8 == 1) {
    cVar1 = *pcVar3;
    uVar6 = 0;
    if ((cVar1 == '+') || (cVar1 == '-')) goto LAB_0027fd9f;
    uVar5 = uVar6;
    if (cVar1 == '-') goto LAB_0027fc9c;
LAB_0027fc68:
    if (cVar1 == '+') {
      auVar13._8_8_ = uVar8 - 1;
      auVar13._0_8_ = pcVar3 + 1;
      if (0x10 < uVar8) {
LAB_0027fd27:
        lVar9 = 0;
        lVar11 = 0;
        do {
          uVar5 = 0;
          if (auVar13._8_8_ == lVar9) goto LAB_0027fdab;
          lVar10 = lVar11 * 10;
          uVar7 = *(byte *)(auVar13._0_8_ + lVar9) - 0x30;
          if ((9 < uVar7) || (SEXT816(lVar10) != SEXT816(lVar11) * SEXT816(10))) goto LAB_0027fd9d;
          lVar9 = lVar9 + 1;
          uVar6 = 0;
          lVar11 = lVar10 + (ulong)uVar7;
        } while (!SCARRY8(lVar10,(ulong)uVar7));
        goto LAB_0027fd9f;
      }
      if (uVar8 - 1 != 0) goto LAB_0027fcf2;
LAB_0027fda9:
      uVar5 = 0;
      lVar11 = 0;
    }
    else {
      if (0xf < uVar8) goto LAB_0027fd27;
LAB_0027fcf2:
      uVar5 = 0;
      lVar11 = 0;
      do {
        uVar7 = *(byte *)(auVar13._0_8_ + uVar5) - 0x30;
        if (9 < uVar7) goto LAB_0027fd9d;
        lVar11 = (ulong)uVar7 + lVar11 * 10;
        uVar5 = uVar5 + 1;
      } while (auVar13._8_8_ != uVar5);
    }
  }
  else {
    cVar1 = *pcVar3;
    if (cVar1 != '-') goto LAB_0027fc68;
LAB_0027fc9c:
    if (0x10 < uVar8) {
      uVar12 = 1;
      lVar11 = 0;
      do {
        if (uVar8 == uVar12) goto LAB_0027fdab;
        lVar9 = lVar11 * 10;
        uVar7 = (byte)pcVar3[uVar12] - 0x30;
        if ((9 < uVar7) || (SEXT816(lVar9) != SEXT816(lVar11) * SEXT816(10))) goto LAB_0027fd9d;
        uVar12 = uVar12 + 1;
        uVar5 = 0;
        uVar6 = 0;
        lVar11 = lVar9 - (ulong)uVar7;
      } while (!SBORROW8(lVar9,(ulong)uVar7));
      goto LAB_0027fd9f;
    }
    if (uVar8 == 1) goto LAB_0027fda9;
    uVar5 = 1;
    lVar11 = 0;
    do {
      if (9 < (byte)pcVar3[uVar5] - 0x30) goto LAB_0027fd9d;
      lVar11 = lVar11 * 10 - (ulong)((byte)pcVar3[uVar5] - 0x30);
      uVar5 = uVar5 + 1;
    } while (uVar8 != uVar5);
  }
LAB_0027fdab:
  uVar6 = CONCAT71((int7)(uVar5 >> 8),0x5e0be100 < lVar11);
LAB_0027fd9f:
  return uVar6 & 0xffffffff;
}


