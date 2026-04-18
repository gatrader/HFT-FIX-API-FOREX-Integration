// core::option::Option<T>::ok_or_else
// entry = 001ab920


/* core::option::Option<T>::ok_or_else */

void __rustcall core::option::Option<T>::ok_or_else(undefined8 *param_1,char *param_2)

{
  undefined8 uVar1;
  undefined8 local_20;
  undefined4 *local_18;
  undefined8 local_10;
  
  if (*param_2 == '\x01') {
    *(undefined4 *)(param_1 + 3) = *(undefined4 *)(param_2 + 0x11);
    uVar1 = *(undefined8 *)(param_2 + 9);
    param_1[1] = *(undefined8 *)(param_2 + 1);
    param_1[2] = uVar1;
    *param_1 = 3;
    return;
  }
  local_18 = malloc(0x5e);
  if (local_18 != (undefined4 *)0x0) {
    *(undefined8 *)((long)local_18 + 0x4e) = 0x207265646e756620;
    *(undefined8 *)((long)local_18 + 0x56) = 0x2e73736572646461;
    *(undefined8 *)(local_18 + 0x10) = 0x7865206e61206564;
    *(undefined8 *)(local_18 + 0x12) = 0x6620746963696c70;
    *(undefined8 *)(local_18 + 0xc) = 0x61656c50202e6e69;
    *(undefined8 *)(local_18 + 0xe) = 0x69766f7270206573;
    *(undefined8 *)(local_18 + 8) = 0x206e6f2064657472;
    *(undefined8 *)(local_18 + 10) = 0x6168632073696874;
    *(undefined8 *)(local_18 + 4) = 0x6e206e6f69746176;
    *(undefined8 *)(local_18 + 6) = 0x6f7070757320746f;
    *local_18 = 0x65666153;
    local_18[1] = 0x6c617720;
    local_18[2] = 0x2074656c;
    local_18[3] = 0x69726564;
    local_20 = 0x5e;
    local_10 = 0x5e;
    _<polymarket_client_sdk::error::Error_as_core::convert::From<polymarket_client_sdk::error::Validation>>
    ::from(param_1,&local_20);
    return;
  }
                    /* WARNING: Subroutine does not return */
  alloc::raw_vec::handle_error(1,0x5e,&PTR_s__rustc_6b00bc3880198600130e1cf62_00987e78);
}


