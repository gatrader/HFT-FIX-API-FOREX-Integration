// tokio::runtime::task::core::Core<T,S>::poll
// entry = 001d9b00


/* tokio::runtime::task::core::Core<T,S>::poll */

void __rustcall tokio::runtime::task::core::Core<T,S>::poll(long param_1)

{
  long lVar1;
  long *in_FS_OFFSET;
  undefined1 local_dd0 [8];
  undefined **local_dc8;
  undefined8 local_dc0;
  undefined1 *local_db8;
  undefined8 local_db0;
  undefined8 uStack_da8;
  
  if (*(int *)(param_1 + 0x10) != 0) {
    local_dc8 = &PTR_DAT_00984f70;
    local_dc0 = 1;
    local_db8 = local_dd0;
    local_db0 = 0;
    uStack_da8 = 0;
                    /* WARNING: Subroutine does not return */
    ::core::panicking::panic_fmt(&local_dc8,&PTR_DAT_00984f80);
  }
  lVar1 = *(long *)(param_1 + 8);
  if ((char)in_FS_OFFSET[-0x30] != '\x01') {
    if ((char)in_FS_OFFSET[-0x30] == '\x02') goto LAB_001d9bac;
    std::sys::thread_local::destructors::linux_like::register
              (*in_FS_OFFSET + -0x1c8,std::sys::thread_local::native::eager::destroy);
    *(undefined1 *)(in_FS_OFFSET + -0x30) = 1;
  }
  in_FS_OFFSET[-0x33] = lVar1;
LAB_001d9bac:
                    /* WARNING: Could not recover jumptable at 0x001d9bc1. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (*(code *)(&DAT_007cb904 + *(int *)(&DAT_007cb904 + (ulong)*(byte *)(param_1 + 0xda9) * 4)))();
  return;
}


