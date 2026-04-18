// _<polymarket_client_sdk::error::Status_as_core::fmt::Display>::fmt
// entry = 0039d2b0


/* _<polymarket_client_sdk::error::Status as core::fmt::Display>::fmt */

void __rustcall
_<polymarket_client_sdk::error::Status_as_core::fmt::Display>::fmt(long param_1,undefined8 *param_2)

{
  long local_70;
  code *local_68;
  long local_60;
  code *local_58;
  long local_50;
  code *local_48;
  long local_40;
  code *local_38;
  undefined **local_30;
  undefined8 local_28;
  long *local_20;
  undefined8 local_18;
  undefined8 local_10;
  
  local_70 = param_1 + 0x48;
  local_60 = param_1 + 0x30;
  local_68 = _<http::status::StatusCode_as_core::fmt::Display>::fmt;
  local_58 = _<http::method::Method_as_core::fmt::Debug>::fmt;
  local_40 = param_1 + 0x18;
  local_48 = _<alloc::string::String_as_core::fmt::Display>::fmt;
  local_38 = _<alloc::string::String_as_core::fmt::Display>::fmt;
  local_30 = &PTR_s_error___making_call_to_with_00977d08;
  local_28 = 4;
  local_10 = 0;
  local_20 = &local_70;
  local_18 = 4;
  local_50 = param_1;
  core::fmt::write(*param_2,param_2[1],&local_30);
  return;
}


