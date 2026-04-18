// polymarket_client_sdk::clob::types::ser_salt::_{{closure}}
// entry = 0014e3f0


/* polymarket_client_sdk::clob::types::ser_salt::_{{closure}} */

void __rustcall polymarket_client_sdk::clob::types::ser_salt::___closure__(undefined8 param_1)

{
  undefined8 local_60;
  code *local_58;
  undefined **local_50;
  undefined8 local_48;
  undefined8 *local_40;
  undefined8 local_38;
  undefined8 local_30;
  undefined1 local_20 [24];
  
  local_58 = _<ruint::from::FromUintError<T>as_core::fmt::Display>::fmt;
  local_50 = &PTR_s_salt_does_not_fit_into_u64__vari_0096db08;
  local_48 = 1;
  local_30 = 0;
  local_40 = &local_60;
  local_38 = 1;
  local_60 = param_1;
  alloc::fmt::format::format_inner(local_20,&local_50);
  _<serde_json::error::Error_as_serde_core::ser::Error>::custom(local_20);
  return;
}


