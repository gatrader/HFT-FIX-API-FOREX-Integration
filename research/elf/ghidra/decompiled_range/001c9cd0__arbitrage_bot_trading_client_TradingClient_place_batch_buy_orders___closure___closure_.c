// arbitrage_bot::trading::client::TradingClient::place_batch_buy_orders::_{{closure}}::_{{closure}}
// entry = 001c9cd0


/* arbitrage_bot::trading::client::TradingClient::place_batch_buy_orders::_{{closure}}::_{{closure}}
    */

void __rustcall
arbitrage_bot::trading::client::TradingClient::place_batch_buy_orders::_{{closure}}::___closure__
          (undefined **param_1)

{
  code *pcVar1;
  long *__ptr;
  long *plVar2;
  long *plVar3;
  long in_FS_OFFSET;
  bool bVar4;
  long *local_a0;
  long **local_98;
  long *plStack_90;
  long *local_88 [2];
  long **local_78;
  long *plStack_70;
  long *local_68;
  long **local_60;
  void *pvStack_58;
  long ****local_50;
  undefined8 local_48;
  undefined8 local_40;
  long ***local_30;
  code *local_28;
  
  if (*(long *)(in_FS_OFFSET + -0x90) != 1) {
    if ((int)*(long *)(in_FS_OFFSET + -0x90) == 2) {
      param_1 = &PTR_DAT_009858f0;
      std::thread::local::panic_access_error(&PTR_DAT_009858f0);
    }
    std::sys::thread_local::native::lazy::Storage<T,D>::initialize(0);
  }
  local_a0 = *(long **)(in_FS_OFFSET + -0x88);
  *local_a0 = *local_a0 + 1;
  if (*local_a0 != 0) {
    plStack_90 = malloc(0x600);
    if (plStack_90 != (long *)0x0) {
      local_98 = (long **)0x40;
      local_60 = local_88;
      local_88[0] = (long *)0x0;
      local_78 = &local_a0;
      plStack_70 = (long *)0x4000000000;
      pvStack_58 = (void *)0x0;
                    /* try { // try from 001c9d88 to 001c9d96 has its CatchHandler @ 001c9eec */
      local_50 = (long ****)plStack_90;
      _<core::iter::adapters::map::Map<I,F>as_core::iter::traits::iterator::Iterator>::fold
                (&local_78,&local_60);
      plVar2 = local_88[0];
      __ptr = plStack_90;
      local_78 = local_98;
      plStack_70 = plStack_90;
      local_68 = local_88[0];
                    /* try { // try from 001c9db0 to 001c9dc7 has its CatchHandler @ 001c9edd */
      alloc::str::join_generic_copy(&local_60,plStack_90,local_88[0],1,0);
      local_88[0] = (long *)local_50;
      local_98 = local_60;
      plStack_90 = pvStack_58;
      local_30 = &local_98;
      local_28 = _<alloc::string::String_as_core::fmt::Display>::fmt;
      local_60 = (long **)&PTR_s_0x_0096d880;
      pvStack_58 = (void *)0x1;
      local_40 = 0;
      local_50 = &local_30;
      local_48 = 1;
                    /* try { // try from 001c9e26 to 001c9e32 has its CatchHandler @ 001c9ec5 */
      alloc::fmt::format::format_inner(param_1,&local_60);
      if (local_98 != (long **)0x0) {
        free(plStack_90);
      }
      plVar3 = __ptr + 1;
      while (bVar4 = plVar2 != (long *)0x0, plVar2 = (long *)((long)plVar2 + -1), bVar4) {
        if (plVar3[-1] != 0) {
          free((void *)*plVar3);
        }
        plVar3 = plVar3 + 3;
      }
      if (local_78 != (long **)0x0) {
        free(__ptr);
      }
      *local_a0 = *local_a0 + -1;
      if (*local_a0 == 0) {
        alloc::rc::Rc<T,A>::drop_slow(local_a0);
      }
      return;
    }
                    /* try { // try from 001c9ead to 001c9ec2 has its CatchHandler @ 001c9efb */
                    /* WARNING: Subroutine does not return */
    alloc::raw_vec::handle_error(8,0x600,&PTR_s__rustc_6b00bc3880198600130e1cf62_00987f90);
  }
                    /* WARNING: Does not return */
  pcVar1 = (code *)invalidInstructionException();
  (*pcVar1)();
}


