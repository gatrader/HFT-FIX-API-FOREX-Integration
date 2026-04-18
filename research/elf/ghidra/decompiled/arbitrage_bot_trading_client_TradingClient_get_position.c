// arbitrage_bot::trading::client::TradingClient::get_position
// entry = 002a6420


/* arbitrage_bot::trading::client::TradingClient::get_position */

ulong __rustcall arbitrage_bot::trading::client::TradingClient::get_position(long param_1)

{
  uint *puVar1;
  int *piVar2;
  uint uVar3;
  int iVar4;
  char cVar5;
  uint uVar6;
  ulong uVar7;
  long local_28;
  uint *puStack_20;
  
  puVar1 = (uint *)(param_1 + 0x168);
  uVar6 = *(uint *)(param_1 + 0x168);
  if (uVar6 < 0x3ffffffe) {
    LOCK();
    uVar3 = *puVar1;
    if (uVar6 == uVar3) {
      *puVar1 = uVar6 + 1;
    }
    UNLOCK();
    if (uVar6 == uVar3) {
      cVar5 = *(char *)(param_1 + 0x170);
      goto joined_r0x002a6498;
    }
  }
  std::sys::sync::rwlock::futex::RwLock::read_contended(puVar1);
  cVar5 = *(char *)(param_1 + 0x170);
joined_r0x002a6498:
  if (cVar5 != '\0') {
    local_28 = param_1 + 0x178;
                    /* try { // try from 002a64b5 to 002a64d8 has its CatchHandler @ 002a6501 */
    puStack_20 = puVar1;
                    /* WARNING: Subroutine does not return */
    core::result::unwrap_failed
              ("called `Result::unwrap()` on an `Err` value",0x2b,&local_28,
               &
               PTR_drop_in_place<std::sync::poison::PoisonError<std::sync::poison::rwlock::RwLockReadGuard<arbitrage_bot::trading::position::Position>>>_0096d6e8
               ,&PTR_DAT_0096d790);
  }
  LOCK();
  piVar2 = (int *)(param_1 + 0x168);
  iVar4 = *piVar2;
  *piVar2 = *piVar2 + -1;
  UNLOCK();
  uVar6 = iVar4 - 1U & 0xbfffffff;
  if (!SBORROW4(0,uVar6)) {
    return (ulong)-uVar6;
  }
  uVar7 = std::sys::sync::rwlock::futex::RwLock::wake_writer_or_readers(puVar1);
  return uVar7;
}


