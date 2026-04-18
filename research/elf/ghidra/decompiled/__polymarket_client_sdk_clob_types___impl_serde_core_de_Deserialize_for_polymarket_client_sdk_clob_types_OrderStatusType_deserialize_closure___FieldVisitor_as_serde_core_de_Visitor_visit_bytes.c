// _<polymarket_client_sdk::clob::types::_::<impl_serde_core::de::Deserialize_for_polymarket_client_sdk::clob::types::OrderStatusType>::deserialize::{{closure}}::__FieldVisitor_as_serde_core::de::Visitor>::visit_bytes
// entry = 002b5940


/* _<polymarket_client_sdk::clob::types::_::<impl serde_core::de::Deserialize for
   polymarket_client_sdk::clob::types::OrderStatusType>::deserialize::{{closure}}::__FieldVisitor as
   serde_core::de::Visitor>::visit_bytes */

void __rustcall
_<polymarket_client_sdk::clob::types::_::<impl_serde_core::de::Deserialize_for_polymarket_client_sdk::clob::types::OrderStatusType>::deserialize::{{closure}}::__FieldVisitor_as_serde_core::de::Visitor>
::visit_bytes(undefined2 *param_1,byte *param_2,undefined8 param_3)

{
  byte bVar1;
  undefined8 uVar2;
  ulong local_28;
  void *local_20;
  undefined8 local_18;
  
  switch(param_3) {
  case 4:
    if (*param_2 == 0x4c) {
      if (((param_2[1] == 0x49) && (param_2[2] == 0x56)) && (param_2[3] == 0x45)) goto LAB_002b5b9a;
    }
    else if (((*param_2 == 0x6c) && (param_2[1] == 0x69)) &&
            ((param_2[2] == 0x76 && (param_2[3] == 0x65)))) {
LAB_002b5b9a:
      *param_1 = 0;
      return;
    }
    break;
  case 7:
    bVar1 = *param_2;
    if (bVar1 < 100) {
      if (bVar1 == 0x44) {
        if ((((param_2[1] == 0x45) && (param_2[2] == 0x4c)) && (param_2[3] == 0x41)) &&
           (((param_2[4] == 0x59 && (param_2[5] == 0x45)) && (param_2[6] == 0x44)))) {
LAB_002b5c3a:
          *param_1 = 0x300;
          return;
        }
      }
      else if (((bVar1 == 0x4d) && (param_2[1] == 0x41)) &&
              ((param_2[2] == 0x54 &&
               ((((param_2[3] == 0x43 && (param_2[4] == 0x48)) && (param_2[5] == 0x45)) &&
                (param_2[6] == 0x44)))))) {
LAB_002b5b1c:
        *param_1 = 0x100;
        return;
      }
    }
    else if (bVar1 == 100) {
      if (((param_2[1] == 0x65) && (param_2[2] == 0x6c)) &&
         ((param_2[3] == 0x61 &&
          (((param_2[4] == 0x79 && (param_2[5] == 0x65)) && (param_2[6] == 100))))))
      goto LAB_002b5c3a;
    }
    else if (((((bVar1 == 0x6d) && (param_2[1] == 0x61)) && (param_2[2] == 0x74)) &&
             ((param_2[3] == 99 && (param_2[4] == 0x68)))) &&
            ((param_2[5] == 0x65 && (param_2[6] == 100)))) goto LAB_002b5b1c;
    break;
  case 8:
    if (*param_2 == 99) {
      if (((((param_2[1] == 0x61) && (param_2[2] == 0x6e)) && (param_2[3] == 99)) &&
          ((param_2[4] == 0x65 && (param_2[5] == 0x6c)))) &&
         ((param_2[6] == 0x65 && (param_2[7] == 100)))) {
        *param_1 = 0x200;
        return;
      }
    }
    else if (((*param_2 == 0x43) && (param_2[1] == 0x41)) &&
            ((param_2[2] == 0x4e &&
             ((((param_2[3] == 0x43 && (param_2[4] == 0x45)) && (param_2[5] == 0x4c)) &&
              ((param_2[6] == 0x45 && (param_2[7] == 0x44)))))))) {
      *param_1 = 0x200;
      return;
    }
    break;
  case 9:
    if (*param_2 == 0x75) {
      if (((((param_2[1] == 0x6e) && (param_2[2] == 0x6d)) && (param_2[3] == 0x61)) &&
          ((param_2[4] == 0x74 && (param_2[5] == 99)))) &&
         ((param_2[6] == 0x68 && ((param_2[7] == 0x65 && (param_2[8] == 100)))))) goto LAB_002b5be3;
    }
    else if (((*param_2 == 0x55) &&
             (((param_2[1] == 0x4e && (param_2[2] == 0x4d)) && (param_2[3] == 0x41)))) &&
            (((param_2[4] == 0x54 && (param_2[5] == 0x43)) &&
             ((param_2[6] == 0x48 && ((param_2[7] == 0x45 && (param_2[8] == 0x44)))))))) {
LAB_002b5be3:
      *param_1 = 0x400;
      return;
    }
  }
  alloc::string::String::from_utf8_lossy(&local_28);
                    /* try { // try from 002b5c5c to 002b5c6f has its CatchHandler @ 002b5c99 */
  uVar2 = serde_core::de::Error::unknown_variant(local_20,local_18,&PTR_DAT_0096da68,10);
  *(undefined8 *)(param_1 + 4) = uVar2;
  *(undefined1 *)param_1 = 1;
  if ((local_28 & 0x7fffffffffffffff) == 0) {
    return;
  }
  free(local_20);
  return;
}


