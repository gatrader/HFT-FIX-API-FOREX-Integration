// _<polymarket_client_sdk::clob::types::_::<impl_serde_core::de::Deserialize_for_polymarket_client_sdk::clob::types::OrderType>::deserialize::{{closure}}::__FieldVisitor_as_serde_core::de::Visitor>::visit_bytes
// entry = 002b56e0


/* _<polymarket_client_sdk::clob::types::_::<impl serde_core::de::Deserialize for
   polymarket_client_sdk::clob::types::OrderType>::deserialize::{{closure}}::__FieldVisitor as
   serde_core::de::Visitor>::visit_bytes */

void __rustcall
_<polymarket_client_sdk::clob::types::_::<impl_serde_core::de::Deserialize_for_polymarket_client_sdk::clob::types::OrderType>::deserialize::{{closure}}::__FieldVisitor_as_serde_core::de::Visitor>
::visit_bytes(undefined2 *param_1,undefined1 *param_2,long param_3)

{
  undefined8 uVar1;
  ulong local_28;
  void *local_20;
  undefined8 local_18;
  
  if (param_3 == 3) {
    switch(*param_2) {
    case 0x46:
      if (param_2[1] == 'A') {
        if (param_2[2] == 'K') {
LAB_002b57a8:
          *param_1 = 0x300;
          return;
        }
      }
      else if ((param_2[1] == 'O') && (param_2[2] == 'K')) {
        *param_1 = 0x100;
        return;
      }
      break;
    case 0x47:
      if (param_2[1] == 'T') {
        if (param_2[2] == 'D') {
LAB_002b5795:
          *param_1 = 0x200;
          return;
        }
        if (param_2[2] == 'C') {
LAB_002b5767:
          *param_1 = 0;
          return;
        }
      }
      break;
    case 0x66:
      if (param_2[1] == 'a') {
        if (param_2[2] == 'k') goto LAB_002b57a8;
      }
      else if ((param_2[1] == 'o') && (param_2[2] == 'k')) {
        *param_1 = 0x100;
        return;
      }
      break;
    case 0x67:
      if (param_2[1] == 't') {
        if (param_2[2] == 'd') goto LAB_002b5795;
        if (param_2[2] == 'c') goto LAB_002b5767;
      }
    }
  }
  alloc::string::String::from_utf8_lossy(&local_28);
                    /* try { // try from 002b57d0 to 002b57e3 has its CatchHandler @ 002b580d */
  uVar1 = serde_core::de::Error::unknown_variant
                    (local_20,local_18,&PTR_s_GTCFOKGTDFAKgtcfokgtdfak_0096d9e8,8);
  *(undefined8 *)(param_1 + 4) = uVar1;
  *(undefined1 *)param_1 = 1;
  if ((local_28 & 0x7fffffffffffffff) == 0) {
    return;
  }
  free(local_20);
  return;
}


