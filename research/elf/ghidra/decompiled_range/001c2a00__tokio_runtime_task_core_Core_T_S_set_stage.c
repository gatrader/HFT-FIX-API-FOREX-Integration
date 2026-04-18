// tokio::runtime::task::core::Core<T,S>::set_stage
// entry = 001c2a00


/* tokio::runtime::task::core::Core<T,S>::set_stage */

void __rustcall tokio::runtime::task::core::Core<T,S>::set_stage(long param_1,void *param_2)

{
  int iVar1;
  long lVar2;
  void *__ptr;
  undefined8 *puVar3;
  code *pcVar4;
  long lVar5;
  long *in_FS_OFFSET;
  
  lVar2 = *(long *)(param_1 + 8);
  if ((char)in_FS_OFFSET[-0x30] != '\x01') {
    if ((char)in_FS_OFFSET[-0x30] == '\x02') {
      lVar5 = 0;
      iVar1 = *(int *)(param_1 + 0x10);
      goto joined_r0x001c2abd;
    }
                    /* try { // try from 001c2a79 to 001c2a94 has its CatchHandler @ 001c2b34 */
    std::sys::thread_local::destructors::linux_like::register
              (*in_FS_OFFSET + -0x1c8,std::sys::thread_local::native::eager::destroy);
    *(undefined1 *)(in_FS_OFFSET + -0x30) = 1;
  }
  lVar5 = in_FS_OFFSET[-0x33];
  in_FS_OFFSET[-0x33] = lVar2;
  iVar1 = *(int *)(param_1 + 0x10);
joined_r0x001c2abd:
  if (iVar1 == 1) {
    if ((*(long *)(param_1 + 0x18) != 0) &&
       (__ptr = *(void **)(param_1 + 0x20), __ptr != (void *)0x0)) {
      puVar3 = *(undefined8 **)(param_1 + 0x28);
      pcVar4 = (code *)*puVar3;
      if (pcVar4 != (code *)0x0) {
                    /* try { // try from 001c2a62 to 001c2a66 has its CatchHandler @ 001c2b41 */
        (*pcVar4)(__ptr);
      }
      if (puVar3[1] != 0) {
        free(__ptr);
      }
    }
  }
  else if (iVar1 == 0) {
                    /* try { // try from 001c2acb to 001c2ad2 has its CatchHandler @ 001c2b56 */
    ::core::ptr::
    drop_in_place<arbitrage_bot::websocket::market_ws::run_trading_loop::__closure__::__closure__>
              (param_1 + 0x18);
  }
  memcpy((void *)(param_1 + 0x10),param_2,0xc40);
  if ((char)in_FS_OFFSET[-0x30] != '\x01') {
    if ((char)in_FS_OFFSET[-0x30] == '\x02') {
      return;
    }
    std::sys::thread_local::destructors::linux_like::register
              (*in_FS_OFFSET + -0x1c8,std::sys::thread_local::native::eager::destroy);
    *(undefined1 *)(in_FS_OFFSET + -0x30) = 1;
  }
  in_FS_OFFSET[-0x33] = lVar5;
  return;
}


