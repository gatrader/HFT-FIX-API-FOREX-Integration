// core::option::Option<T>::unwrap_or_else
// entry = 001af140


/* core::option::Option<T>::unwrap_or_else */

void __rustcall
core::option::Option<T>::unwrap_or_else
          (size_t *param_1,size_t *param_2,void *param_3,size_t param_4)

{
  undefined1 *__dest;
  size_t sVar1;
  
  if (SBORROW8(0,*param_2)) {
    if ((long)param_4 < 0) {
                    /* WARNING: Subroutine does not return */
      alloc::raw_vec::handle_error(0,param_4,&PTR_s__rustc_6b00bc3880198600130e1cf62_00987e78);
    }
    if (param_4 == 0) {
      __dest = &DAT_00000001;
      sVar1 = 0;
    }
    else {
      __dest = malloc(param_4);
      sVar1 = param_4;
      if (__dest == (undefined1 *)0x0) {
                    /* WARNING: Subroutine does not return */
        alloc::raw_vec::handle_error(1,param_4,&PTR_s__rustc_6b00bc3880198600130e1cf62_00987e78);
      }
    }
    memcpy(__dest,param_3,param_4);
    *param_1 = sVar1;
    param_1[1] = (size_t)__dest;
    param_1[2] = param_4;
  }
  else {
    param_1[2] = param_2[2];
    sVar1 = param_2[1];
    *param_1 = *param_2;
    param_1[1] = sVar1;
  }
  return;
}


