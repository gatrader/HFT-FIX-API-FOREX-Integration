// _<polymarket_client_sdk::clob::types::Side_as_core::fmt::Display>::fmt
// entry = 003a3140


/* _<polymarket_client_sdk::clob::types::Side as core::fmt::Display>::fmt */

void __rustcall
_<polymarket_client_sdk::clob::types::Side_as_core::fmt::Display>::fmt
          (char *param_1,undefined8 param_2)

{
  if (*param_1 == '\0') {
    core::fmt::Formatter::pad(param_2,"BUY",3);
    return;
  }
  if (*param_1 == '\x01') {
    core::fmt::Formatter::pad(param_2,&DAT_007cd2e4,4);
    return;
  }
  core::fmt::Formatter::pad(param_2,"UNKNOWN",7);
  return;
}


