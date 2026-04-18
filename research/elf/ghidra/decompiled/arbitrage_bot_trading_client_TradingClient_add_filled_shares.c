// arbitrage_bot::trading::client::TradingClient::add_filled_shares
// entry = 002a6560


/* arbitrage_bot::trading::client::TradingClient::add_filled_shares */

void __rustcall
arbitrage_bot::trading::client::TradingClient::add_filled_shares
          (double param_1,long param_2,ulong param_3)

{
  int *piVar1;
  int iVar2;
  byte bVar3;
  char cVar4;
  ulong uVar5;
  bool bVar6;
  int *local_d8;
  code *local_d0;
  undefined ***local_c8;
  code *local_c0;
  long local_b8;
  code *local_b0;
  long local_a8;
  void *pvStack_a0;
  undefined8 local_98;
  undefined **local_90;
  code *local_88;
  int **local_80;
  code *local_78;
  undefined *local_70;
  undefined8 local_68;
  undefined *local_60;
  void *local_58;
  long local_48;
  void *pvStack_40;
  undefined8 local_38;
  
  piVar1 = (int *)(param_2 + 0x168);
  LOCK();
  bVar6 = *(int *)(param_2 + 0x168) == 0;
  if (bVar6) {
    *(int *)(param_2 + 0x168) = 0x3fffffff;
  }
  UNLOCK();
  if (!bVar6) {
    std::sys::sync::rwlock::futex::RwLock::write_contended(piVar1);
    param_3 = param_3 & 0xffffffff;
  }
  if ((std::panicking::panic_count::GLOBAL_PANIC_COUNT & 0x7fffffffffffffff) == 0) {
    bVar3 = 0;
    cVar4 = *(char *)(param_2 + 0x170);
  }
  else {
    bVar3 = std::panicking::panic_count::is_zero_slow_path();
    param_3 = param_3 & 0xffffffff;
    bVar3 = bVar3 ^ 1;
    cVar4 = *(char *)(param_2 + 0x170);
  }
  if (cVar4 != '\0') {
    uVar5 = (ulong)local_d0 >> 8;
    local_d0 = (code *)CONCAT71((int7)uVar5,bVar3);
                    /* try { // try from 002a67b8 to 002a67db has its CatchHandler @ 002a6844 */
    local_d8 = piVar1;
                    /* WARNING: Subroutine does not return */
    core::result::unwrap_failed
              ("called `Result::unwrap()` on an `Err` value",0x2b,&local_d8,
               &
               PTR_drop_in_place<std::sync::poison::PoisonError<std::sync::poison::rwlock::RwLockWriteGuard<arbitrage_bot::trading::position::Position>>>_0096d6c8
               ,&PTR_DAT_0096d7a8);
  }
  uVar5 = (param_3 ^ 1) & 0xff;
  *(double *)(param_2 + 0x178 + uVar5 * 8) = param_1 + *(double *)(param_2 + 0x178 + uVar5 * 8);
                    /* try { // try from 002a65c9 to 002a65d8 has its CatchHandler @ 002a682e */
  utils::now_str(&local_60);
  local_d8 = (int *)(param_2 + 0xd0);
  local_c8 = (undefined ***)(param_2 + 0x178);
  local_b8 = param_2 + 0x180;
  local_d0 = _<alloc::string::String_as_core::fmt::Display>::fmt;
  local_c0 = core::fmt::float::_<impl_core::fmt::Display_for_f64>::fmt;
  local_b0 = core::fmt::float::_<impl_core::fmt::Display_for_f64>::fmt;
  local_90 = &PTR_s___0096d7c0;
  local_88 = (code *)0x3;
  local_70 = &DAT_007dd7c8;
  local_68 = 3;
  local_80 = &local_d8;
  local_78 = (code *)0x3;
                    /* try { // try from 002a665a to 002a666e has its CatchHandler @ 002a6810 */
  alloc::fmt::format::format_inner(&local_48,&local_90);
  local_a8 = local_48;
  pvStack_a0 = pvStack_40;
  local_98 = local_38;
  local_88 = _<alloc::string::String_as_core::fmt::Display>::fmt;
  local_80 = (int **)&local_a8;
  local_78 = _<alloc::string::String_as_core::fmt::Display>::fmt;
  local_d8 = (int *)&DAT_0096d7f0;
  local_d0 = (code *)0x3;
  local_b8 = 0;
  local_c0 = (code *)0x2;
                    /* try { // try from 002a66d0 to 002a66d9 has its CatchHandler @ 002a67f8 */
  local_c8 = &local_90;
  local_90 = &local_60;
  std::io::stdio::_print(&local_d8);
  if (local_a8 != 0) {
    free(pvStack_a0);
  }
  if (local_60 != (undefined *)0x0) {
    free(local_58);
  }
  if (((bVar3 == 0) && ((std::panicking::panic_count::GLOBAL_PANIC_COUNT & 0x7fffffffffffffff) != 0)
      ) && (cVar4 = std::panicking::panic_count::is_zero_slow_path(), cVar4 == '\0')) {
    *(undefined1 *)(param_2 + 0x170) = 1;
  }
  LOCK();
  iVar2 = *piVar1;
  *piVar1 = *piVar1 + -0x3fffffff;
  UNLOCK();
  if (0x3fffffff < iVar2 + 0xc0000001U) {
    std::sys::sync::rwlock::futex::RwLock::wake_writer_or_readers(piVar1);
  }
  return;
}


