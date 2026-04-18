// _<polymarket_client_sdk::clob::types::_::<impl_serde_core::de::Deserialize_for_polymarket_client_sdk::clob::types::OrderType>::deserialize::{{closure}}::__FieldVisitor_as_serde_core::de::Visitor>::visit_str
// entry = 002b5830


/* _<polymarket_client_sdk::clob::types::_::<impl serde_core::de::Deserialize for
   polymarket_client_sdk::clob::types::OrderType>::deserialize::{{closure}}::__FieldVisitor as
   serde_core::de::Visitor>::visit_str */

void __rustcall
_<polymarket_client_sdk::clob::types::_::<impl_serde_core::de::Deserialize_for_polymarket_client_sdk::clob::types::OrderType>::deserialize::{{closure}}::__FieldVisitor_as_serde_core::de::Visitor>
::visit_str(undefined1 *param_1,short *param_2,long param_3)

{
  undefined8 uVar1;
  
  if (param_3 == 3) {
    if (((char)param_2[1] == 'C' && *param_2 == 0x5447) ||
       ((char)param_2[1] == 'c' && *param_2 == 0x7467)) {
      param_1[1] = 0;
      *param_1 = 0;
      return;
    }
    if (((char)param_2[1] == 'K' && *param_2 == 0x4f46) ||
       ((char)param_2[1] == 'k' && *param_2 == 0x6f66)) {
      param_1[1] = 1;
      *param_1 = 0;
      return;
    }
    if (((char)param_2[1] == 'D' && *param_2 == 0x5447) ||
       ((char)param_2[1] == 'd' && *param_2 == 0x7467)) {
      param_1[1] = 2;
      *param_1 = 0;
      return;
    }
    if (((char)param_2[1] == 'K' && *param_2 == 0x4146) ||
       ((char)param_2[1] == 'k' && *param_2 == 0x6166)) {
      param_1[1] = 3;
      *param_1 = 0;
      return;
    }
    param_3 = 3;
  }
  uVar1 = serde_core::de::Error::unknown_variant
                    (param_2,param_3,&PTR_s_GTCFOKGTDFAKgtcfokgtdfak_0096d9e8,8);
  *(undefined8 *)(param_1 + 8) = uVar1;
  *param_1 = 1;
  return;
}


