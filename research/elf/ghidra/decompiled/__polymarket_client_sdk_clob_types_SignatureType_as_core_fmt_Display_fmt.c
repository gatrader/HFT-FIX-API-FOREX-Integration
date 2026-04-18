// _<polymarket_client_sdk::clob::types::SignatureType_as_core::fmt::Display>::fmt
// entry = 003a3190


/* _<polymarket_client_sdk::clob::types::SignatureType as core::fmt::Display>::fmt */

void __rustcall
_<polymarket_client_sdk::clob::types::SignatureType_as_core::fmt::Display>::fmt
          (char *param_1,undefined8 param_2)

{
  if (*param_1 == '\0') {
    core::fmt::Formatter::pad(param_2,"Eoa",3);
    return;
  }
  if (*param_1 == '\x01') {
    core::fmt::Formatter::pad(param_2,"Proxy",5);
    return;
  }
  core::fmt::Formatter::pad(param_2,"GnosisSafe",10);
  return;
}


