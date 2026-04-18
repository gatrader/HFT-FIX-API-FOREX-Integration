// serde_json::ser::to_string
// entry = 001aa370


/* serde_json::ser::to_string */

void __rustcall serde_json::ser::to_string(long *param_1,undefined8 param_2)

{
  void *pvVar1;
  long local_38;
  void *local_30;
  long local_28;
  undefined1 *local_20;
  
  local_30 = malloc(0x80);
  if (local_30 == (void *)0x0) {
                    /* WARNING: Subroutine does not return */
    alloc::raw_vec::handle_error(1,0x80,&PTR_s__usr_local_cargo_registry_src_in_0096b050);
  }
  local_38 = 0x80;
  local_28 = 0;
                    /* try { // try from 001aa3b8 to 001aa3c4 has its CatchHandler @ 001aa432 */
  local_20 = (undefined1 *)&local_38;
  pvVar1 = (void *)arbitrage_bot::websocket::types::_::
                   _<impl_serde_core::ser::Serialize_for_arbitrage_bot::websocket::types::SubscribeMessage>
                   ::serialize(param_2,&local_20);
  if (pvVar1 == (void *)0x0) {
    pvVar1 = local_30;
    if (local_38 != -0x8000000000000000) {
      *param_1 = local_38;
      param_1[1] = (long)local_30;
      param_1[2] = local_28;
      return;
    }
  }
  else if (local_38 != 0) {
    free(local_30);
  }
  param_1[1] = (long)pvVar1;
  *param_1 = -0x8000000000000000;
  return;
}


