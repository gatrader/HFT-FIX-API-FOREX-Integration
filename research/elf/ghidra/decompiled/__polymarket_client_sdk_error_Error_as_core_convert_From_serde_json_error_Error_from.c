// _<polymarket_client_sdk::error::Error_as_core::convert::From<serde_json::error::Error>>::from
// entry = 0039d800


/* _<polymarket_client_sdk::error::Error as core::convert::From<serde_json::error::Error>>::from */

void __rustcall
_<polymarket_client_sdk::error::Error_as_core::convert::From<serde_json::error::Error>>::from
          (undefined8 *param_1,undefined8 param_2)

{
  undefined8 *puVar1;
  undefined8 local_48;
  undefined8 uStack_40;
  undefined8 local_38;
  undefined8 uStack_30;
  undefined8 local_28;
  undefined8 uStack_20;
  
  local_48 = param_2;
  puVar1 = malloc(8);
  if (puVar1 != (undefined8 *)0x0) {
    *puVar1 = param_2;
                    /* try { // try from 0039d830 to 0039d837 has its CatchHandler @ 0039d87f */
    std::backtrace::Backtrace::capture(&local_48);
    *(undefined1 *)(param_1 + 8) = 3;
    param_1[6] = puVar1;
    param_1[7] = &PTR_drop_in_place<serde_json::error::Error>_00977cb0;
    *param_1 = local_48;
    param_1[1] = uStack_40;
    param_1[2] = local_38;
    param_1[3] = uStack_30;
    param_1[4] = local_28;
    param_1[5] = uStack_20;
    return;
  }
                    /* try { // try from 0039d86e to 0039d87c has its CatchHandler @ 0039d898 */
                    /* WARNING: Subroutine does not return */
  alloc::alloc::handle_alloc_error(8,8);
}


