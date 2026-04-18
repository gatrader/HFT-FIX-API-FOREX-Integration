// _<polymarket_client_sdk::error::MissingContractConfig_as_core::fmt::Display>::fmt
// entry = 0039d110


/* _<polymarket_client_sdk::error::MissingContractConfig as core::fmt::Display>::fmt */

void __rustcall
_<polymarket_client_sdk::error::MissingContractConfig_as_core::fmt::Display>::fmt
          (long param_1,undefined8 *param_2)

{
  long local_50;
  code *local_48;
  long local_40;
  code *local_38;
  undefined **local_30;
  undefined8 local_28;
  long *local_20;
  undefined8 local_18;
  undefined8 local_10;
  
  local_40 = param_1 + 8;
  local_48 = core::fmt::num::imp::_<impl_core::fmt::Display_for_u64>::fmt;
  local_38 = _<bool_as_core::fmt::Display>::fmt;
  local_30 = &PTR_s_missing_contract_config_for_chai_00977d58;
  local_28 = 2;
  local_10 = 0;
  local_20 = &local_50;
  local_18 = 2;
  local_50 = param_1;
  core::fmt::write(*param_2,param_2[1],&local_30);
  return;
}


