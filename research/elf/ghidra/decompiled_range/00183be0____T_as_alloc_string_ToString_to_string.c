// _<T_as_alloc::string::ToString>::to_string
// entry = 00183be0


/* _<T as alloc::string::ToString>::to_string */

void __rustcall _<T_as_alloc::string::ToString>::to_string(undefined8 *param_1,long param_2)

{
  char cVar1;
  long lVar2;
  undefined1 local_39;
  undefined8 local_38;
  undefined8 uStack_30;
  undefined8 local_28;
  undefined8 *local_20;
  undefined **local_18;
  undefined8 local_10;
  
  local_38 = 0;
  uStack_30 = 1;
  local_28 = 0;
  local_10 = 0xe0000020;
  local_20 = &local_38;
  lVar2 = -param_2;
  if (-param_2 < 0) {
    lVar2 = param_2;
  }
  local_18 = &
             PTR_drop_in_place<alloc::boxed::convert::<impl_core::convert::From<alloc::string::String>for_alloc::boxed::Box<dyn_core::error::Error_core::marker::Send_core::marker::Sync>>::from::StringError>_00967b60
  ;
                    /* try { // try from 00183c35 to 00183c7f has its CatchHandler @ 00183c82 */
  cVar1 = core::fmt::num::imp::_<impl_u64>::_fmt(lVar2,-1 < param_2,&local_20);
  if (cVar1 == '\0') {
    param_1[2] = local_28;
    *param_1 = local_38;
    param_1[1] = uStack_30;
    return;
  }
                    /* WARNING: Subroutine does not return */
  core::result::unwrap_failed
            ("a Display implementation returned an error unexpectedly",0x37,&local_39,&DAT_00967b90,
             &PTR_s__rustc_6b00bc3880198600130e1cf62_00986788);
}


