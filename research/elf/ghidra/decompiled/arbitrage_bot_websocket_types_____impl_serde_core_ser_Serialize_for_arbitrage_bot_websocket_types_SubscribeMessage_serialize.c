// arbitrage_bot::websocket::types::_::_<impl_serde_core::ser::Serialize_for_arbitrage_bot::websocket::types::SubscribeMessage>::serialize
// entry = 0024b610


/* arbitrage_bot::websocket::types::_::_<impl serde_core::ser::Serialize for
   arbitrage_bot::websocket::types::SubscribeMessage>::serialize */

undefined8 __rustcall
arbitrage_bot::websocket::types::_::
_<impl_serde_core::ser::Serialize_for_arbitrage_bot::websocket::types::SubscribeMessage>::serialize
          (long param_1,long *param_2)

{
  long *plVar1;
  long lVar2;
  undefined8 uVar3;
  undefined2 local_40;
  long *local_38;
  undefined8 local_30 [3];
  
  plVar1 = (long *)*param_2;
  lVar2 = plVar1[2];
  if (*plVar1 == lVar2) {
    alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle(plVar1,lVar2,1,1,1);
    lVar2 = plVar1[2];
  }
  *(undefined1 *)(plVar1[1] + lVar2) = 0x7b;
  plVar1[2] = lVar2 + 1;
  local_40 = 0x100;
  local_38 = param_2;
  serde_core::ser::SerializeMap::serialize_entry
            (&local_40,&DAT_007dc120,10,*(undefined8 *)(param_1 + 8),*(undefined8 *)(param_1 + 0x10)
            );
  if ((char)local_40 == '\x01') {
    local_30[0] = 10;
    uVar3 = serde_json::error::Error::syntax(local_30,0,0);
  }
  else {
    serde_core::ser::SerializeMap::serialize_entry
              (&local_40,"type",4,*(undefined8 *)(param_1 + 0x20),*(undefined8 *)(param_1 + 0x28));
    uVar3 = 0;
    if (((local_40 & 1) == 0) && (local_40._1_1_ != '\0')) {
      plVar1 = (long *)*local_38;
      lVar2 = plVar1[2];
      if (*plVar1 == lVar2) {
        alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle(plVar1,lVar2,1,1,1);
        lVar2 = plVar1[2];
      }
      *(undefined1 *)(plVar1[1] + lVar2) = 0x7d;
      plVar1[2] = lVar2 + 1;
      uVar3 = 0;
    }
  }
  return uVar3;
}


