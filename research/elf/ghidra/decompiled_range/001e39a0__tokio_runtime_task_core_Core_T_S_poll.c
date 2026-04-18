// tokio::runtime::task::core::Core<T,S>::poll
// entry = 001e39a0


/* tokio::runtime::task::core::Core<T,S>::poll */

ulong __rustcall tokio::runtime::task::core::Core<T,S>::poll(long param_1,undefined8 param_2)

{
  long lVar1;
  char cVar2;
  ulong uVar3;
  long lVar4;
  long *in_FS_OFFSET;
  undefined1 local_120 [8];
  undefined8 local_118;
  undefined8 local_110;
  undefined1 *local_108;
  undefined8 local_100;
  undefined8 uStack_f8;
  
  if (*(int *)(param_1 + 0x10) != 0) {
    local_118 = &PTR_DAT_00984f70;
    local_110 = 1;
    local_108 = local_120;
    local_100 = 0;
    uStack_f8 = 0;
                    /* WARNING: Subroutine does not return */
    ::core::panicking::panic_fmt(&local_118,&PTR_DAT_00984f80);
  }
  lVar1 = *(long *)(param_1 + 8);
  if ((char)in_FS_OFFSET[-0x30] == '\x01') {
LAB_001e3a4a:
    lVar4 = in_FS_OFFSET[-0x33];
    in_FS_OFFSET[-0x33] = lVar1;
  }
  else {
    if ((char)in_FS_OFFSET[-0x30] != '\x02') {
      std::sys::thread_local::destructors::linux_like::register
                (*in_FS_OFFSET + -0x1c8,std::sys::thread_local::native::eager::destroy);
      *(undefined1 *)(in_FS_OFFSET + -0x30) = 1;
      goto LAB_001e3a4a;
    }
    lVar4 = 0;
  }
                    /* try { // try from 001e3a5c to 001e3a60 has its CatchHandler @ 001e3ad9 */
  uVar3 = arbitrage_bot::websocket::spread_capture_ws::run_spread_capture_loop::_{{closure}}::
          ___closure__(param_1 + 0x18,param_2);
  if ((char)in_FS_OFFSET[-0x30] != '\x01') {
    if ((char)in_FS_OFFSET[-0x30] == '\x02') {
      cVar2 = (char)uVar3;
      goto joined_r0x001e3ad5;
    }
    uVar3 = uVar3 & 0xffffffff;
    std::sys::thread_local::destructors::linux_like::register
              (*in_FS_OFFSET + -0x1c8,std::sys::thread_local::native::eager::destroy);
    *(undefined1 *)(in_FS_OFFSET + -0x30) = 1;
  }
  in_FS_OFFSET[-0x33] = lVar4;
  cVar2 = (char)uVar3;
joined_r0x001e3ad5:
  if (cVar2 == '\0') {
    local_118 = (undefined **)CONCAT44(local_118._4_4_,2);
    uVar3 = uVar3 & 0xffffffff;
    set_stage(param_1,&local_118);
  }
  return uVar3;
}


