// _<T_as_alloc::string::ToString>::to_string
// entry = 001af220


/* _<T as alloc::string::ToString>::to_string */

void __rustcall
_<T_as_alloc::string::ToString>::to_string(size_t *param_1,void *param_2,size_t param_3)

{
  undefined1 *__dest;
  size_t sVar1;
  
  if ((long)param_3 < 0) {
                    /* WARNING: Subroutine does not return */
    alloc::raw_vec::handle_error(0,param_3,&PTR_s__rustc_6b00bc3880198600130e1cf62_00987e78);
  }
  if (param_3 == 0) {
    __dest = &DAT_00000001;
    sVar1 = 0;
  }
  else {
    __dest = malloc(param_3);
    sVar1 = param_3;
    if (__dest == (undefined1 *)0x0) {
                    /* WARNING: Subroutine does not return */
      alloc::raw_vec::handle_error(1,param_3,&PTR_s__rustc_6b00bc3880198600130e1cf62_00987e78);
    }
  }
  memcpy(__dest,param_2,param_3);
  *param_1 = sVar1;
  param_1[1] = (size_t)__dest;
  param_1[2] = param_3;
  return;
}


