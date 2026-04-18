// tokio::runtime::task::core::Core<T,S>::poll
// entry = 001b57b0


/* tokio::runtime::task::core::Core<T,S>::poll */

void __rustcall tokio::runtime::task::core::Core<T,S>::poll(long param_1)

{
  long lVar1;
  long *in_FS_OFFSET;
  undefined1 local_16c0 [168];
  undefined **local_1618;
  undefined8 local_1610;
  undefined1 *local_1608;
  undefined8 local_1600;
  undefined8 uStack_15f8;
  undefined8 local_1030;
  
  local_1030 = 0;
  if (*(int *)(param_1 + 0x10) != 0) {
    local_1618 = &PTR_DAT_00984f70;
    local_1610 = 1;
    local_1608 = local_16c0;
    local_1600 = 0;
    uStack_15f8 = 0;
                    /* WARNING: Subroutine does not return */
    ::core::panicking::panic_fmt(&local_1618,&PTR_DAT_00984f80);
  }
  lVar1 = *(long *)(param_1 + 8);
  if ((char)in_FS_OFFSET[-0x30] != '\x01') {
    if ((char)in_FS_OFFSET[-0x30] == '\x02') goto LAB_001b5891;
    std::sys::thread_local::destructors::linux_like::register
              (*in_FS_OFFSET + -0x1c8,std::sys::thread_local::native::eager::destroy);
    *(undefined1 *)(in_FS_OFFSET + -0x30) = 1;
  }
  in_FS_OFFSET[-0x33] = lVar1;
LAB_001b5891:
                    /* WARNING: Could not recover jumptable at 0x001b58a6. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (*(code *)(&DAT_007cb5d8 + *(int *)(&DAT_007cb5d8 + (ulong)*(byte *)(param_1 + 0x15f0) * 4)))();
  return;
}


