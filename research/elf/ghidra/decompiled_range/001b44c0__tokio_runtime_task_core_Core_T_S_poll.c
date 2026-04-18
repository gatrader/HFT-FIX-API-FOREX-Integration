// tokio::runtime::task::core::Core<T,S>::poll
// entry = 001b44c0


/* tokio::runtime::task::core::Core<T,S>::poll */

void __rustcall tokio::runtime::task::core::Core<T,S>::poll(long param_1,undefined8 param_2)

{
  long lVar1;
  long *in_FS_OFFSET;
  undefined1 local_288 [120];
  long local_210;
  undefined **local_1f0;
  undefined8 local_1e8;
  undefined1 *local_1e0;
  undefined8 local_1d8;
  undefined8 uStack_1d0;
  undefined8 local_160;
  
  local_160 = param_2;
  if (*(int *)(param_1 + 0x10) != 0) {
    local_1f0 = &PTR_DAT_00984f70;
    local_1e8 = 1;
    local_1e0 = local_288;
    local_1d8 = 0;
    uStack_1d0 = 0;
                    /* WARNING: Subroutine does not return */
    ::core::panicking::panic_fmt(&local_1f0,&PTR_DAT_00984f80);
  }
  lVar1 = *(long *)(param_1 + 8);
  if ((char)in_FS_OFFSET[-0x30] != '\x01') {
    if ((char)in_FS_OFFSET[-0x30] == '\x02') {
      local_210 = 0;
      goto LAB_001b4594;
    }
    std::sys::thread_local::destructors::linux_like::register
              (*in_FS_OFFSET + -0x1c8,std::sys::thread_local::native::eager::destroy);
    *(undefined1 *)(in_FS_OFFSET + -0x30) = 1;
  }
  local_210 = in_FS_OFFSET[-0x33];
  in_FS_OFFSET[-0x33] = lVar1;
LAB_001b4594:
                    /* WARNING: Could not recover jumptable at 0x001b45ad. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (*(code *)(&DAT_007cb590 + *(int *)(&DAT_007cb590 + (ulong)*(byte *)(param_1 + 0x38) * 4)))();
  return;
}


