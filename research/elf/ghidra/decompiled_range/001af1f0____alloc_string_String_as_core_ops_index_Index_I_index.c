// _<alloc::string::String_as_core::ops::index::Index<I>>::index
// entry = 001af1f0


/* _<alloc::string::String as core::ops::index::Index<I>>::index */

undefined1  [16] __rustcall
_<alloc::string::String_as_core::ops::index::Index<I>>::index
          (long param_1,ulong param_2,ulong param_3,undefined8 param_4)

{
  undefined1 auVar1 [16];
  
  if (param_3 != 0) {
    if (param_3 < param_2) {
      if (-0x41 < *(char *)(param_1 + param_3)) goto LAB_001af210;
    }
    else if (param_3 == param_2) goto LAB_001af210;
                    /* WARNING: Subroutine does not return */
    core::str::slice_error_fail(param_1,param_2,0,param_3,param_4);
  }
LAB_001af210:
  auVar1._8_8_ = param_3;
  auVar1._0_8_ = param_1;
  return auVar1;
}


