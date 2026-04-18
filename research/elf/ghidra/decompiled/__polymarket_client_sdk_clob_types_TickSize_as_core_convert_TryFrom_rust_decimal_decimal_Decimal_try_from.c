// _<polymarket_client_sdk::clob::types::TickSize_as_core::convert::TryFrom<rust_decimal::decimal::Decimal>>::try_from
// entry = 003a3020


/* _<polymarket_client_sdk::clob::types::TickSize as
   core::convert::TryFrom<rust_decimal::decimal::Decimal>>::try_from */

void __rustcall
_<polymarket_client_sdk::clob::types::TickSize_as_core::convert::TryFrom<rust_decimal::decimal::Decimal>>
::try_from(undefined8 *param_1,undefined4 *param_2)

{
  char cVar1;
  undefined **local_78;
  undefined8 uStack_70;
  undefined4 **local_68;
  undefined8 local_60;
  undefined8 local_58;
  undefined4 *local_48;
  code *local_40;
  undefined4 local_38;
  undefined4 uStack_34;
  undefined4 uStack_30;
  undefined4 uStack_2c;
  undefined1 local_28 [24];
  
  local_78 = (undefined **)0x10000;
  uStack_70 = 1;
  cVar1 = _<rust_decimal::decimal::Decimal_as_core::cmp::Ord>::cmp(param_2,&local_78);
  if (cVar1 == '\0') {
    *(undefined1 *)(param_1 + 1) = 0;
  }
  else {
    local_78 = (undefined **)0x20000;
    uStack_70 = 1;
    cVar1 = _<rust_decimal::decimal::Decimal_as_core::cmp::Ord>::cmp(param_2,&local_78);
    if (cVar1 == '\0') {
      *(undefined1 *)(param_1 + 1) = 1;
    }
    else {
      local_78 = (undefined **)0x30000;
      uStack_70 = 1;
      cVar1 = _<rust_decimal::decimal::Decimal_as_core::cmp::Ord>::cmp(param_2,&local_78);
      if (cVar1 == '\0') {
        *(undefined1 *)(param_1 + 1) = 2;
      }
      else {
        local_78 = (undefined **)0x40000;
        uStack_70 = 1;
        cVar1 = _<rust_decimal::decimal::Decimal_as_core::cmp::Ord>::cmp(param_2,&local_78);
        if (cVar1 != '\0') {
          local_38 = *param_2;
          uStack_34 = param_2[1];
          uStack_30 = param_2[2];
          uStack_2c = param_2[3];
          local_48 = &local_38;
          local_40 = _<rust_decimal::decimal::Decimal_as_core::fmt::Display>::fmt;
          local_78 = &PTR_s_Unknown_tick_size____Expected_on_00977eb8;
          uStack_70 = 2;
          local_58 = 0;
          local_68 = &local_48;
          local_60 = 1;
          alloc::fmt::format::format_inner(local_28,&local_78);
          _<polymarket_client_sdk::error::Error_as_core::convert::From<polymarket_client_sdk::error::Validation>>
          ::from(param_1,local_28);
          return;
        }
        *(undefined1 *)(param_1 + 1) = 3;
      }
    }
  }
  *param_1 = 3;
  return;
}


