// core::option::Option<T>::ok_or_else
// entry = 001ab860


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
  local_18 = malloc(0x5f);
  if (local_18 != (undefined4 *)0x0) {
    *(undefined8 *)((long)local_18 + 0x4f) = 0x207265646e756620;
    *(undefined8 *)((long)local_18 + 0x57) = 0x2e73736572646461;
    *(undefined8 *)(local_18 + 0x10) = 0x65206e6120656469;
    *(undefined8 *)(local_18 + 0x12) = 0x20746963696c7078;
    *(undefined8 *)(local_18 + 0xc) = 0x656c50202e6e6961;
    *(undefined8 *)(local_18 + 0xe) = 0x766f727020657361;
    *(undefined8 *)(local_18 + 8) = 0x6e6f20646574726f;
    *(undefined8 *)(local_18 + 10) = 0x6863207369687420;
    *(undefined8 *)(local_18 + 4) = 0x206e6f6974617669;
    *(undefined8 *)(local_18 + 6) = 0x7070757320746f6e;
    *local_18 = 0x786f7250;
    local_18[1] = 0x61772079;
    local_18[2] = 0x74656c6c;
    local_18[3] = 0x72656420;
    local_20 = 0x5f;
    local_10 = 0x5f;
    _<polymarket_client_sdk::error::Error_as_core::convert::From<polymarket_client_sdk::error::Validation>>
    ::from(param_1,&local_20);
    return;
  }
                    /* WARNING: Subroutine does not return */
  alloc::raw_vec::handle_error(1,0x5f,&PTR_s__rustc_6b00bc3880198600130e1cf62_00987e78);
}


