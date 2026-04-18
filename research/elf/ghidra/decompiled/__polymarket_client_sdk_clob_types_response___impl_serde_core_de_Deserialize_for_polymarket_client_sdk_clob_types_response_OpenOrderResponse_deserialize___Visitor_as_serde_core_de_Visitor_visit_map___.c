// _<<polymarket_client_sdk::clob::types::response::_::<impl_serde_core::de::Deserialize_for_polymarket_client_sdk::clob::types::response::OpenOrderResponse>::deserialize::__Visitor_as_serde_core::de::Visitor>::visit_map::__DeserializeWith_as_serde_core::de::Deserialize>::deserialize
// entry = 0025b690


/* _<<polymarket_client_sdk::clob::types::response::_::<impl serde_core::de::Deserialize for
   polymarket_client_sdk::clob::types::response::OpenOrderResponse>::deserialize::__Visitor as
   serde_core::de::Visitor>::visit_map::__DeserializeWith as
   serde_core::de::Deserialize>::deserialize */

void __rustcall
_<<polymarket_client_sdk::clob::types::response::_::<impl_serde_core::de::Deserialize_for_polymarket_client_sdk::clob::types::response::OpenOrderResponse>::deserialize::__Visitor_as_serde_core::de::Visitor>::visit_map::__DeserializeWith_as_serde_core::de::Deserialize>
::deserialize(undefined4 *param_1,char *param_2)

{
  int iVar1;
  undefined4 uVar2;
  ulong uVar3;
  long lVar4;
  uint uVar5;
  undefined1 local_41;
  undefined1 local_40 [8];
  ulong local_38;
  
  if (*param_2 == '\x02') {
    uVar3 = *(ulong *)(param_2 + 0x10);
    if (*(long *)(param_2 + 8) == 0) {
      if (-1 < (long)uVar3) {
        if (0xfffffffeffffffff < uVar3 / 0x15180 - 0x7ff506c5) {
          iVar1 = chrono::naive::date::NaiveDate::from_num_days_from_ce_opt
                            ((int)(uVar3 / 0x15180) + 0xaf93b);
          if (iVar1 != 0) {
            uVar3 = uVar3 % 0x15180;
            goto LAB_0025b794;
          }
        }
      }
      uVar3 = _<serde_json::error::Error_as_serde_core::de::Error>::custom(uVar3);
    }
    else if (*(long *)(param_2 + 8) == 1) {
      lVar4 = (long)uVar3 % 0x15180;
      iVar1 = (int)((long)uVar3 / 0x15180);
      uVar5 = (int)uVar3 + 0x15180 + iVar1 * -0x15180;
      if (-1 < lVar4) {
        uVar5 = (uint)lVar4;
      }
      if (0xfffffffeffffffff < ((lVar4 >> 0x3f) + (long)uVar3 / 0x15180) - 0x7ff506c5U) {
                    /* try { // try from 0025b730 to 0025b783 has its CatchHandler @ 0025b810 */
        iVar1 = chrono::naive::date::NaiveDate::from_num_days_from_ce_opt
                          ((int)(lVar4 >> 0x3f) + iVar1 + 0xaf93b);
        if (iVar1 != 0) {
          uVar3 = (ulong)uVar5;
LAB_0025b794:
          core::ptr::drop_in_place<serde_json::value::Value>(param_2);
          param_1[1] = iVar1;
          uVar2 = 0;
          goto LAB_0025b7e7;
        }
      }
      uVar3 = _<serde_json::error::Error_as_serde_core::de::Error>::custom(uVar3);
    }
    else {
      local_40[0] = 3;
                    /* try { // try from 0025b7ad to 0025b7d6 has its CatchHandler @ 0025b810 */
      local_38 = uVar3;
      uVar3 = _<serde_json::error::Error_as_serde_core::de::Error>::invalid_type
                        (local_40,&local_41,&DAT_0096b588);
    }
  }
  else {
                    /* try { // try from 0025b7fa to 0025b80d has its CatchHandler @ 0025b810 */
    uVar3 = serde_json::value::de::_<impl_serde_json::value::Value>::invalid_type
                      (param_2,&local_41,&DAT_0096b588);
  }
  core::ptr::drop_in_place<serde_json::value::Value>(param_2);
  uVar2 = 1;
LAB_0025b7e7:
  *(ulong *)(param_1 + 2) = uVar3;
  *param_1 = uVar2;
  return;
}


