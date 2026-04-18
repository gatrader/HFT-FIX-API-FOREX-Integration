// tokio::runtime::task::core::Core<T,S>::poll
// entry = 001c0210


/* tokio::runtime::task::core::Core<T,S>::poll */

void __rustcall tokio::runtime::task::core::Core<T,S>::poll(long param_1)

{
  long lVar1;
  long *in_FS_OFFSET;
  undefined1 local_d58 [112];
  long local_ce8;
  undefined **local_c70;
  undefined8 local_c68;
  undefined1 *local_c60;
  undefined8 local_c58;
  undefined8 uStack_c50;
  
  if (*(int *)(param_1 + 0x10) != 0) {
    local_c70 = &PTR_DAT_00984f70;
    local_c68 = 1;
    local_c60 = local_d58;
    local_c58 = 0;
    uStack_c50 = 0;
                    /* WARNING: Subroutine does not return */
    ::core::panicking::panic_fmt(&local_c70,&PTR_DAT_00984f80);
  }
  lVar1 = *(long *)(param_1 + 8);
  if ((char)in_FS_OFFSET[-0x30] != '\x01') {
    if ((char)in_FS_OFFSET[-0x30] == '\x02') {
      local_ce8 = 0;
      goto LAB_001c02e7;
    }
    std::sys::thread_local::destructors::linux_like::register
              (*in_FS_OFFSET + -0x1c8,std::sys::thread_local::native::eager::destroy);
    *(undefined1 *)(in_FS_OFFSET + -0x30) = 1;
  }
  local_ce8 = in_FS_OFFSET[-0x33];
  in_FS_OFFSET[-0x33] = lVar1;
LAB_001c02e7:
                    /* WARNING: Could not recover jumptable at 0x001c0301. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (*(code *)(&DAT_007cb6d0 + *(int *)(&DAT_007cb6d0 + (ulong)*(byte *)(param_1 + 0x151) * 4)))();
  return;
}


