// arbitrage_bot::market::time::format_timestamp
// entry = 00281330


/* arbitrage_bot::market::time::format_timestamp */

void __rustcall arbitrage_bot::market::time::format_timestamp(long *param_1,long param_2)

{
  int iVar1;
  undefined4 *puVar2;
  long lVar3;
  int iVar4;
  long local_b8;
  undefined1 *puStack_b0;
  long local_a8;
  int local_a0;
  int local_9c;
  undefined4 local_98;
  undefined4 local_94;
  undefined8 local_90;
  long local_88;
  undefined1 *puStack_80;
  long local_78;
  undefined4 local_70;
  char *local_68;
  undefined8 local_60;
  undefined8 local_58;
  undefined8 local_50;
  undefined1 local_48;
  undefined4 local_40;
  undefined4 local_3c;
  undefined4 uStack_38;
  undefined4 local_34;
  undefined8 local_28;
  undefined8 uStack_20;
  
  lVar3 = param_2 % 0x15180;
  iVar1 = (int)(param_2 / 0x15180);
  iVar4 = (int)param_2 + 0x15180 + iVar1 * -0x15180;
  if (-1 < lVar3) {
    iVar4 = (int)lVar3;
  }
  if ((0xfffffffeffffffff < ((lVar3 >> 0x3f) + param_2 / 0x15180) - 0x7ff506c5U) &&
     (local_a0 = chrono::naive::date::NaiveDate::from_num_days_from_ce_opt
                           ((int)(lVar3 >> 0x3f) + iVar1 + 0xaf93b), local_a0 != 0)) {
    local_98 = 0;
    local_9c = iVar4;
    chrono::naive::datetime::NaiveDateTime::overflowing_add_offset(&local_94,&local_a0,0);
    local_28 = local_90;
    uStack_20 = 0;
    local_b8 = 0;
    puStack_b0 = &DAT_00000001;
    local_a8 = 0;
                    /* try { // try from 00281405 to 0028141e has its CatchHandler @ 0028154b */
    alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle(&local_b8,0,3,1,1);
    puStack_b0[local_a8 + 2] = 0x43;
    *(undefined2 *)(puStack_b0 + local_a8) = 0x5455;
    local_78 = local_a8 + 3;
    local_88 = local_b8;
    puStack_80 = puStack_b0;
    local_34 = local_94;
    local_40 = 1;
    local_3c = (undefined4)local_28;
    uStack_38 = local_28._4_4_;
    local_70 = 0;
    local_68 = "%Y-%m-%d %H:%M:%S UTC";
    local_60 = 0x15;
    local_58 = 8;
    local_50 = 0;
    local_48 = 0;
                    /* try { // try from 002814a0 to 002814ac has its CatchHandler @ 00281532 */
    _<T_as_alloc::string::SpecToString>::spec_to_string(&local_b8,&local_88);
    if ((local_88 != -0x8000000000000000) && (local_88 != 0)) {
      free(puStack_80);
    }
    param_1[2] = local_a8;
    *param_1 = local_b8;
    param_1[1] = (long)puStack_b0;
    return;
  }
  puVar2 = malloc(7);
  if (puVar2 != (undefined4 *)0x0) {
    *(undefined4 *)((long)puVar2 + 3) = 0x64696c61;
    *puVar2 = 0x61766e49;
    *param_1 = 7;
    param_1[1] = (long)puVar2;
    param_1[2] = 7;
    return;
  }
                    /* WARNING: Subroutine does not return */
  alloc::raw_vec::handle_error(1,7,&PTR_s__rustc_6b00bc3880198600130e1cf62_00987e78);
}


