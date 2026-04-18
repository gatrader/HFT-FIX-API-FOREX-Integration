// _<polymarket_client_sdk::clob::types::_::<impl_serde_core::de::Deserialize_for_polymarket_client_sdk::clob::types::OrderStatusType>::deserialize::{{closure}}::__FieldVisitor_as_serde_core::de::Visitor>::visit_str
// entry = 002b5cc0


/* _<polymarket_client_sdk::clob::types::_::<impl serde_core::de::Deserialize for
   polymarket_client_sdk::clob::types::OrderStatusType>::deserialize::{{closure}}::__FieldVisitor as
   serde_core::de::Visitor>::visit_str */

void __rustcall
_<polymarket_client_sdk::clob::types::_::<impl_serde_core::de::Deserialize_for_polymarket_client_sdk::clob::types::OrderStatusType>::deserialize::{{closure}}::__FieldVisitor_as_serde_core::de::Visitor>
::visit_str(undefined1 *param_1,long *param_2,undefined8 param_3)

{
  undefined8 uVar1;
  
  switch(param_3) {
  case 4:
    if (((int)*param_2 == 0x4556494c) || ((int)*param_2 == 0x6576696c)) {
      param_1[1] = 0;
      *param_1 = 0;
      return;
    }
    break;
  case 7:
    if ((*(int *)((long)param_2 + 3) == 0x44454843 && (int)*param_2 == 0x4354414d) ||
       (*(int *)((long)param_2 + 3) == 0x64656863 && (int)*param_2 == 0x6374616d)) {
      param_1[1] = 1;
      *param_1 = 0;
      return;
    }
    if ((*(int *)((long)param_2 + 3) == 0x44455941 && (int)*param_2 == 0x414c4544) ||
       (*(int *)((long)param_2 + 3) == 0x64657961 && (int)*param_2 == 0x616c6564)) {
      param_1[1] = 3;
      *param_1 = 0;
      return;
    }
    break;
  case 8:
    if ((*param_2 == 0x44454c45434e4143) || (*param_2 == 0x64656c65636e6163)) {
      param_1[1] = 2;
      *param_1 = 0;
      return;
    }
    break;
  case 9:
    if (((char)param_2[1] == 'D' && *param_2 == 0x45484354414d4e55) ||
       ((char)param_2[1] == 'd' && *param_2 == 0x65686374616d6e75)) {
      param_1[1] = 4;
      *param_1 = 0;
      return;
    }
  }
  uVar1 = serde_core::de::Error::unknown_variant(param_2,param_3,&PTR_DAT_0096da68,10);
  *(undefined8 *)(param_1 + 8) = uVar1;
  *param_1 = 1;
  return;
}


