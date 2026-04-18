// _<polymarket_client_sdk::error::Status_as_core::fmt::Debug>::fmt
// entry = 0039eb30


/* _<polymarket_client_sdk::error::Status as core::fmt::Debug>::fmt */

void __rustcall
_<polymarket_client_sdk::error::Status_as_core::fmt::Debug>::fmt(long param_1,undefined8 param_2)

{
  long local_38;
  
  local_38 = param_1 + 0x18;
  core::fmt::Formatter::debug_struct_field4_finish
            (param_2,"Status",6,"status_code",0xb,param_1 + 0x48,
             _<http::status::StatusCode_as_core::fmt::Debug>::fmt,"method",6,param_1 + 0x30,
             _<http::method::Method_as_core::fmt::Debug>::fmt,&DAT_007cd2e0,4,param_1,
             _<alloc::string::String_as_core::fmt::Debug>::fmt,&DAT_00842461,7,&local_38,
             _<&T_as_core::fmt::Debug>::fmt);
  return;
}


