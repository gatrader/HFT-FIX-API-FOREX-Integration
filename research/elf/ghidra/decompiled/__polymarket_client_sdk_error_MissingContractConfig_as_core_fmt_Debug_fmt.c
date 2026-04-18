// _<polymarket_client_sdk::error::MissingContractConfig_as_core::fmt::Debug>::fmt
// entry = 0039d030


/* _<polymarket_client_sdk::error::MissingContractConfig as core::fmt::Debug>::fmt */

ulong __rustcall
_<polymarket_client_sdk::error::MissingContractConfig_as_core::fmt::Debug>::fmt
          (long param_1,undefined8 *param_2)

{
  ulong uVar1;
  undefined8 uVar3;
  char *pcVar4;
  undefined8 uVar5;
  undefined8 *local_28;
  byte local_20;
  byte local_1f;
  long local_18;
  long lVar2;
  
  local_18 = param_1 + 8;
  local_20 = (**(code **)(param_2[1] + 0x18))(*param_2,"MissingContractConfig",0x15);
  local_1f = 0;
  local_28 = param_2;
  core::fmt::builders::DebugStruct::field
            (&local_28,"chain_id",8,param_1,core::fmt::num::_<impl_core::fmt::Debug_for_u64>::fmt);
  core::fmt::builders::DebugStruct::field
            (&local_28,"neg_risk",8,&local_18,_<&T_as_core::fmt::Debug>::fmt);
  if (((~local_1f | local_20) & 1) == 0) {
    if ((*(byte *)((long)local_28 + 0x12) & 0x80) == 0) {
      uVar5 = *local_28;
      lVar2 = local_28[1];
      pcVar4 = &DAT_00842049;
      uVar3 = 2;
    }
    else {
      uVar5 = *local_28;
      lVar2 = local_28[1];
      pcVar4 = "}";
      uVar3 = 1;
    }
    uVar1 = (**(code **)(lVar2 + 0x18))(uVar5,pcVar4,uVar3);
  }
  else {
    uVar1 = (ulong)(local_1f | local_20);
  }
  return uVar1 & 0xffffffffffffff01;
}


