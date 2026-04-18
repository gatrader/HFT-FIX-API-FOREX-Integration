// _<alloc::string::String_as_core::fmt::Write>::write_str
// entry = 00183ea0


/* _<alloc::string::String as core::fmt::Write>::write_str */

undefined8 __rustcall
_<alloc::string::String_as_core::fmt::Write>::write_str(long *param_1,void *param_2,ulong param_3)

{
  long lVar1;
  
  lVar1 = param_1[2];
  if ((ulong)(*param_1 - lVar1) < param_3) {
    alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle(param_1,lVar1,param_3,1,1);
    lVar1 = param_1[2];
  }
  memcpy((void *)(param_1[1] + lVar1),param_2,param_3);
  param_1[2] = lVar1 + param_3;
  return 0;
}


