// polymarket_client_sdk::clob::types::_::_<impl_serde_core::de::Deserialize_for_polymarket_client_sdk::clob::types::OrderStatusType>::deserialize
// entry = 002b50b0


/* polymarket_client_sdk::clob::types::_::_<impl serde_core::de::Deserialize for
   polymarket_client_sdk::clob::types::OrderStatusType>::deserialize */

void __rustcall
polymarket_client_sdk::clob::types::_::
_<impl_serde_core::de::Deserialize_for_polymarket_client_sdk::clob::types::OrderStatusType>::
deserialize(long *param_1)

{
  long lVar1;
  undefined4 local_50;
  undefined4 uStack_4c;
  undefined4 uStack_48;
  undefined4 uStack_44;
  undefined4 local_40;
  undefined4 uStack_3c;
  undefined4 uStack_38;
  undefined4 uStack_34;
  char local_30;
  undefined4 uStack_2f;
  undefined3 uStack_2b;
  undefined4 local_20;
  undefined4 uStack_1c;
  undefined4 uStack_18;
  undefined4 uStack_14;
  
  serde_core::de::Deserializer::__deserialize_content_v1(&local_50);
  if ((char)local_50 == '\x16') {
    param_1[1] = CONCAT44(uStack_44,uStack_48);
    *param_1 = -0x7ffffffffffffffb;
    return;
  }
  uStack_2f = CONCAT13((undefined1)uStack_4c,local_50._1_3_);
  uStack_2b = (undefined3)((uint)uStack_4c >> 8);
  local_20 = local_40;
  uStack_1c = uStack_3c;
  uStack_18 = uStack_38;
  uStack_14 = uStack_34;
  local_30 = (char)local_50;
                    /* try { // try from 002b5113 to 002b5174 has its CatchHandler @ 002b51b3 */
  _<serde::private::de::content::ContentRefDeserializer<E>as_serde_core::de::Deserializer>::
  deserialize_enum(&local_50,&local_30);
  if (CONCAT44(uStack_4c,local_50) == -0x7ffffffffffffffb) {
    core::ptr::drop_in_place<serde_json::error::Error>(CONCAT44(uStack_44,uStack_48));
    _<serde::private::de::content::ContentRefDeserializer<E>as_serde_core::de::Deserializer>::
    deserialize_str(&local_50,&local_30);
    if (CONCAT44(uStack_4c,local_50) == -0x8000000000000000) {
      core::ptr::drop_in_place<serde_json::error::Error>();
      lVar1 = _<serde_json::error::Error_as_serde_core::de::Error>::custom
                        ("data did not match any variant of untagged enum OrderStatusType",0x3f);
      param_1[1] = lVar1;
      *param_1 = -0x7ffffffffffffffb;
    }
    else {
      *param_1 = CONCAT44(uStack_4c,local_50);
      param_1[1] = CONCAT44(uStack_44,uStack_48);
      param_1[2] = CONCAT44(uStack_3c,local_40);
    }
  }
  else {
    param_1[2] = CONCAT44(uStack_3c,local_40);
    *(undefined4 *)param_1 = local_50;
    *(undefined4 *)((long)param_1 + 4) = uStack_4c;
    *(undefined4 *)(param_1 + 1) = uStack_48;
    *(undefined4 *)((long)param_1 + 0xc) = uStack_44;
  }
  core::ptr::drop_in_place<serde_core::private::content::Content>(&local_30);
  return;
}


