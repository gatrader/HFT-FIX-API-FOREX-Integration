// arbitrage_bot::market::time::is_in_window
// entry = 00281220


/* arbitrage_bot::market::time::is_in_window */

byte __rustcall arbitrage_bot::market::time::is_in_window(undefined8 param_1,undefined8 param_2)

{
  char cVar1;
  byte bVar2;
  int iVar3;
  int iVar4;
  long lVar5;
  int iVar6;
  undefined1 auVar7 [16];
  undefined1 auVar8 [16];
  uint local_3c;
  uint local_38;
  
  cVar1 = is_standard_slug();
  bVar2 = 1;
  if (cVar1 != '\0') {
    chrono::offset::utc::Utc::now(&local_3c);
    iVar3 = (int)local_3c >> 0xd;
    iVar6 = iVar3 + -1;
    iVar4 = 0;
    if (iVar3 < 1) {
      iVar4 = (1U - iVar3) / 400 + 1;
      iVar6 = iVar6 + iVar4 * 400;
      iVar4 = iVar4 * -0x23ab1;
    }
    auVar7 = get_window_start_from_slug(param_1,param_2);
    auVar8 = get_window_end_from_slug(param_1,param_2);
    if ((auVar7._0_8_ & 1) == 0) {
      bVar2 = 0;
    }
    else {
      lVar5 = (long)(int)((iVar6 / 100 >> 2) +
                          (((local_3c >> 4 & 0x1ff) + iVar4) - iVar6 / 100) + (iVar6 * 0x5b5 >> 2) +
                         -0xaf93b) * 0x15180 + (ulong)local_38;
      bVar2 = lVar5 < auVar8._8_8_ & auVar7._8_8_ <= lVar5 & auVar8[0];
    }
  }
  return bVar2;
}


