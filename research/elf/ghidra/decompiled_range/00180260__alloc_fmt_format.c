// alloc::fmt::format
// entry = 00180260


/* alloc::fmt::format */

void __rustcall alloc::fmt::format(size_t *param_1,undefined8 *param_2)

{
  size_t __size;
  undefined1 *__src;
  undefined1 *__dest;
  
  if (param_2[1] == 1) {
    if (param_2[3] != 0) goto LAB_00180297;
    __size = ((undefined8 *)*param_2)[1];
    if ((long)__size < 0) {
                    /* WARNING: Subroutine does not return */
      raw_vec::handle_error(0,__size,&PTR_s__rustc_6b00bc3880198600130e1cf62_00987e78);
    }
    __src = *(undefined1 **)*param_2;
    if (__size == 0) {
      __dest = &DAT_00000001;
      __size = 0;
    }
    else {
      __dest = malloc(__size);
      if (__dest == (undefined1 *)0x0) {
                    /* WARNING: Subroutine does not return */
        raw_vec::handle_error(1,__size,&PTR_s__rustc_6b00bc3880198600130e1cf62_00987e78);
      }
    }
  }
  else {
    if ((param_2[1] != 0) || (param_2[3] != 0)) {
LAB_00180297:
      format::format_inner();
      return;
    }
    __dest = &DAT_00000001;
    __size = 0;
    __src = &DAT_00000001;
  }
  memcpy(__dest,__src,__size);
  *param_1 = __size;
  param_1[1] = (size_t)__dest;
  param_1[2] = __size;
  return;
}


