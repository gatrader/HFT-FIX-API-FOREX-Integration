// arbitrage_bot::trading::client::TradingClient::set_fill_notifier
// entry = 002a71e0


/* arbitrage_bot::trading::client::TradingClient::set_fill_notifier */

void __rustcall
arbitrage_bot::trading::client::TradingClient::set_fill_notifier(long param_1,long *param_2)

{
  int *piVar1;
  long *plVar2;
  int iVar3;
  byte bVar4;
  char cVar5;
  long lVar6;
  ulong uVar7;
  ulong uVar8;
  long lVar9;
  bool bVar10;
  
  piVar1 = (int *)(param_1 + 0x1c8);
  LOCK();
  bVar10 = *(int *)(param_1 + 0x1c8) == 0;
  if (bVar10) {
    *(int *)(param_1 + 0x1c8) = 0x3fffffff;
  }
  UNLOCK();
  if (!bVar10) {
    std::sys::sync::rwlock::futex::RwLock::write_contended(piVar1);
  }
  if ((std::panicking::panic_count::GLOBAL_PANIC_COUNT & 0x7fffffffffffffff) == 0) {
    bVar4 = 0;
    cVar5 = *(char *)(param_1 + 0x1d0);
  }
  else {
    bVar4 = std::panicking::panic_count::is_zero_slow_path();
    bVar4 = bVar4 ^ 1;
    cVar5 = *(char *)(param_1 + 0x1d0);
  }
  if (cVar5 == '\0') {
    lVar6 = *(long *)(param_1 + 0x1d8);
    if (lVar6 != 0) {
      LOCK();
      plVar2 = (long *)(lVar6 + 0x1c8);
      *plVar2 = *plVar2 + -1;
      UNLOCK();
      if (*plVar2 == 0) {
        LOCK();
        plVar2 = (long *)(lVar6 + 0x88);
        lVar9 = *plVar2;
        *plVar2 = *plVar2 + 1;
        UNLOCK();
                    /* try { // try from 002a738d to 002a73f0 has its CatchHandler @ 002a7492 */
        lVar9 = tokio::sync::mpsc::list::Tx<T>::find_block(lVar6 + 0x80,lVar9);
        LOCK();
        *(ulong *)(lVar9 + 0x610) = *(ulong *)(lVar9 + 0x610) | 0x200000000;
        UNLOCK();
        uVar7 = *(ulong *)(lVar6 + 0x110);
        do {
          LOCK();
          uVar8 = *(ulong *)(lVar6 + 0x110);
          bVar10 = uVar7 == uVar8;
          if (bVar10) {
            *(ulong *)(lVar6 + 0x110) = uVar7 | 2;
            uVar8 = uVar7;
          }
          UNLOCK();
          uVar7 = uVar8;
        } while (!bVar10);
        if (uVar8 == 0) {
          lVar9 = *(long *)(lVar6 + 0x100);
          *(undefined8 *)(lVar6 + 0x100) = 0;
          LOCK();
          *(undefined8 *)(lVar6 + 0x110) = 0;
          UNLOCK();
          if (lVar9 != 0) {
            (**(code **)(lVar9 + 8))(*(undefined8 *)(lVar6 + 0x108));
          }
        }
      }
      plVar2 = *(long **)(param_1 + 0x1d8);
      LOCK();
      *plVar2 = *plVar2 + -1;
      UNLOCK();
      if (*plVar2 == 0) {
                    /* try { // try from 002a7405 to 002a7409 has its CatchHandler @ 002a748d */
        alloc::sync::Arc<T,A>::drop_slow(*(undefined8 *)(param_1 + 0x1d8));
      }
    }
    *(long **)(param_1 + 0x1d8) = param_2;
    if (((bVar4 == 0) &&
        ((std::panicking::panic_count::GLOBAL_PANIC_COUNT & 0x7fffffffffffffff) != 0)) &&
       (cVar5 = std::panicking::panic_count::is_zero_slow_path(), cVar5 == '\0')) {
      *(undefined1 *)(param_1 + 0x1d0) = 1;
    }
    LOCK();
    iVar3 = *piVar1;
    *piVar1 = *piVar1 + -0x3fffffff;
    UNLOCK();
    if (0x3fffffff < iVar3 + 0xc0000001U) {
      std::sys::sync::rwlock::futex::RwLock::wake_writer_or_readers(piVar1);
    }
  }
  else {
    if (((bVar4 == 0) &&
        ((std::panicking::panic_count::GLOBAL_PANIC_COUNT & 0x7fffffffffffffff) != 0)) &&
       (cVar5 = std::panicking::panic_count::is_zero_slow_path(), cVar5 == '\0')) {
      *(undefined1 *)(param_1 + 0x1d0) = 1;
    }
    LOCK();
    iVar3 = *piVar1;
    *piVar1 = *piVar1 + -0x3fffffff;
    UNLOCK();
    if (0x3fffffff < iVar3 + 0xc0000001U) {
                    /* try { // try from 002a7311 to 002a7318 has its CatchHandler @ 002a7480 */
      std::sys::sync::rwlock::futex::RwLock::wake_writer_or_readers(piVar1);
    }
    LOCK();
    plVar2 = param_2 + 0x39;
    *plVar2 = *plVar2 + -1;
    UNLOCK();
    if (*plVar2 == 0) {
      LOCK();
      plVar2 = param_2 + 0x11;
      lVar6 = *plVar2;
      *plVar2 = *plVar2 + 1;
      UNLOCK();
                    /* try { // try from 002a728c to 002a72f0 has its CatchHandler @ 002a74cd */
      lVar6 = tokio::sync::mpsc::list::Tx<T>::find_block(param_2 + 0x10,lVar6);
      LOCK();
      *(ulong *)(lVar6 + 0x610) = *(ulong *)(lVar6 + 0x610) | 0x200000000;
      UNLOCK();
      uVar7 = param_2[0x22];
      do {
        LOCK();
        uVar8 = param_2[0x22];
        bVar10 = uVar7 == uVar8;
        if (bVar10) {
          param_2[0x22] = uVar7 | 2;
          uVar8 = uVar7;
        }
        UNLOCK();
        uVar7 = uVar8;
      } while (!bVar10);
      if (uVar8 == 0) {
        lVar6 = param_2[0x20];
        param_2[0x20] = 0;
        LOCK();
        param_2[0x22] = 0;
        UNLOCK();
        if (lVar6 != 0) {
          (**(code **)(lVar6 + 8))(param_2[0x21]);
        }
      }
    }
    LOCK();
    *param_2 = *param_2 + -1;
    UNLOCK();
    if (*param_2 == 0) {
      alloc::sync::Arc<T,A>::drop_slow(param_2);
      return;
    }
  }
  return;
}


