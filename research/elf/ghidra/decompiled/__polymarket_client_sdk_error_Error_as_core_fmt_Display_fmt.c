// _<polymarket_client_sdk::error::Error_as_core::fmt::Display>::fmt
// entry = 0039d1b0


/* _<polymarket_client_sdk::error::Error as core::fmt::Display>::fmt */

void __rustcall
_<polymarket_client_sdk::error::Error_as_core::fmt::Display>::fmt(long param_1,undefined8 *param_2)

{
  long local_58;
  long local_50;
  code *local_48;
  undefined1 *local_40;
  code *local_38;
  undefined *local_30;
  undefined8 local_28;
  long *local_20;
  undefined8 local_18;
  undefined8 local_10;
  
  if (*(long *)(param_1 + 0x30) == 0) {
    local_30 = &DAT_007c86a0;
    local_28 = 1;
    local_18 = 1;
  }
  else {
    local_58 = param_1 + 0x30;
    local_38 = _<&T_as_core::fmt::Display>::fmt;
    local_30 = &DAT_00984250;
    local_28 = 2;
    local_18 = 2;
    local_40 = (undefined1 *)&local_58;
  }
  local_20 = &local_50;
  local_50 = param_1 + 0x40;
  local_10 = 0;
  local_48 = _<polymarket_client_sdk::error::Kind_as_core::fmt::Debug>::fmt;
  core::fmt::write(*param_2,param_2[1],&local_30);
  return;
}


