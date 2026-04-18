// tokio::runtime::task::core::Core<T,S>::poll
// entry = 001b3ec0


/* tokio::runtime::task::core::Core<T,S>::poll */

void __rustcall tokio::runtime::task::core::Core<T,S>::poll(long param_1)

{
  long lVar1;
  long *in_FS_OFFSET;
  undefined **local_178;
  undefined8 local_170;
  undefined1 *local_168;
  undefined8 local_160;
  undefined8 uStack_158;
  undefined1 local_b8 [136];
  
  if (*(int *)(param_1 + 0x10) != 0) {
    local_178 = &PTR_DAT_00984f70;
    local_170 = 1;
    local_168 = local_b8;
    local_160 = 0;
    uStack_158 = 0;
                    /* WARNING: Subroutine does not return */
    ::core::panicking::panic_fmt(&local_178,&PTR_DAT_00984f80);
  }
  lVar1 = *(long *)(param_1 + 8);
  if ((char)in_FS_OFFSET[-0x30] != '\x01') {
    if ((char)in_FS_OFFSET[-0x30] == '\x02') goto LAB_001b3f6b;
    std::sys::thread_local::destructors::linux_like::register
              (*in_FS_OFFSET + -0x1c8,std::sys::thread_local::native::eager::destroy);
    *(undefined1 *)(in_FS_OFFSET + -0x30) = 1;
  }
  in_FS_OFFSET[-0x33] = lVar1;
LAB_001b3f6b:
                    /* WARNING: Could not recover jumptable at 0x001b3f7d. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (*(code *)(&DAT_007cb578 + *(int *)(&DAT_007cb578 + (ulong)*(byte *)(param_1 + 0x38) * 4)))();
  return;
}


