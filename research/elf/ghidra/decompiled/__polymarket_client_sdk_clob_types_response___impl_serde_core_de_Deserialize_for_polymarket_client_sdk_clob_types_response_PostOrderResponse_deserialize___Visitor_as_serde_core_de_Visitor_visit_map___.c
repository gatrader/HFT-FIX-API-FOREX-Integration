// _<<polymarket_client_sdk::clob::types::response::_::<impl_serde_core::de::Deserialize_for_polymarket_client_sdk::clob::types::response::PostOrderResponse>::deserialize::__Visitor_as_serde_core::de::Visitor>::visit_map::__DeserializeWith_as_serde_core::de::Deserialize>::deserialize
// entry = 0025bbb0


/* _<<polymarket_client_sdk::clob::types::response::_::<impl serde_core::de::Deserialize for
   polymarket_client_sdk::clob::types::response::PostOrderResponse>::deserialize::__Visitor as
   serde_core::de::Visitor>::visit_map::__DeserializeWith as
   serde_core::de::Deserialize>::deserialize */

void __rustcall
_<<polymarket_client_sdk::clob::types::response::_::<impl_serde_core::de::Deserialize_for_polymarket_client_sdk::clob::types::response::PostOrderResponse>::deserialize::__Visitor_as_serde_core::de::Visitor>::visit_map::__DeserializeWith_as_serde_core::de::Deserialize>
::deserialize(ulong *param_1,char *param_2)

{
  undefined4 *puVar1;
  undefined8 uVar2;
  undefined1 *__ptr;
  undefined1 *puVar3;
  char *pcVar4;
  undefined1 *puVar5;
  ulong uVar6;
  long lVar7;
  char *pcVar8;
  ulong uVar9;
  ulong uVar10;
  undefined1 local_109;
  ulong *local_108;
  undefined4 local_100;
  undefined2 local_fc;
  char *local_f8;
  ulong local_f0;
  undefined1 *local_e8;
  ulong local_e0;
  char *local_d8;
  char *local_d0;
  char *local_c8;
  undefined8 local_c0;
  char *local_b8;
  ulong local_b0;
  char *local_a8;
  long local_a0;
  undefined4 local_98;
  undefined4 uStack_94;
  undefined4 uStack_90;
  undefined4 uStack_8c;
  undefined2 local_88;
  char local_78;
  undefined4 local_77;
  undefined2 local_73;
  undefined1 local_71;
  undefined7 uStack_70;
  undefined4 local_69;
  undefined4 uStack_65;
  undefined4 uStack_61;
  undefined4 uStack_5d;
  undefined2 local_59;
  char local_50;
  undefined4 local_4f;
  undefined4 uStack_4b;
  undefined4 uStack_47;
  undefined4 uStack_43;
  undefined3 uStack_3f;
  undefined4 uStack_3c;
  undefined4 uStack_38;
  undefined4 uStack_34;
  
  if (*param_2 == '\0') {
    core::ptr::drop_in_place<serde_json::value::Value>(param_2);
    puVar3 = &DAT_00000001;
    uVar10 = 0;
    uVar6 = 0;
  }
  else {
    local_d8 = param_2;
    if (*param_2 != '\x04') {
      puVar3 = (undefined1 *)
               serde_json::value::de::_<impl_serde_json::value::Value>::invalid_type
                         (param_2,&local_109,&DAT_009671f8);
      uVar9 = 0x8000000000000000;
      core::ptr::drop_in_place<serde_json::value::Value>(local_d8);
      goto LAB_0025be44;
    }
    local_c0 = *(undefined8 *)(param_2 + 8);
    pcVar8 = *(char **)(param_2 + 0x10);
    local_b0 = *(ulong *)(param_2 + 0x18);
    local_a0 = local_b0 * 0x20;
    local_b8 = pcVar8 + local_a0;
    uVar10 = 0x8000;
    if (local_b0 < 0x8000) {
      uVar10 = local_b0;
    }
    local_108 = param_1;
    local_d0 = pcVar8;
    local_c8 = pcVar8;
    local_a8 = local_b8;
    if (local_b0 == 0) {
      puVar3 = &DAT_00000001;
      uVar10 = 0;
    }
    else {
      uVar6 = (ulong)(uint)((int)uVar10 << 5);
      puVar3 = malloc(uVar6);
      if (puVar3 == (undefined1 *)0x0) {
                    /* try { // try from 0025bc53 to 0025bc66 has its CatchHandler @ 0025bec8 */
                    /* WARNING: Subroutine does not return */
        alloc::raw_vec::handle_error(1,uVar6,&PTR_DAT_0096b310);
      }
    }
    local_e0 = 0;
    local_f8 = pcVar8;
    local_f0 = uVar10;
    local_e8 = puVar3;
    for (lVar7 = 0; uVar10 = local_e0, uVar6 = local_f0, pcVar4 = local_a8, local_a0 != lVar7;
        lVar7 = lVar7 + 0x20) {
      if (*pcVar8 == '\x06') {
        pcVar4 = local_f8 + lVar7 + 0x20;
        break;
      }
      local_4f = *(undefined4 *)(pcVar8 + 1);
      uStack_4b = *(undefined4 *)(pcVar8 + 5);
      uStack_47 = *(undefined4 *)(pcVar8 + 9);
      uStack_43 = *(undefined4 *)(pcVar8 + 0xd);
      uStack_3c = *(undefined4 *)(pcVar8 + 0x14);
      uStack_38 = *(undefined4 *)(pcVar8 + 0x18);
      uStack_34 = *(undefined4 *)(pcVar8 + 0x1c);
      uStack_3f = (undefined3)((uint)*(undefined4 *)(pcVar8 + 0x10) >> 8);
                    /* try { // try from 0025bd3c to 0025bd50 has its CatchHandler @ 0025bed4 */
      local_50 = *pcVar8;
      alloy_primitives::bits::serde::
      _<impl_serde_core::de::Deserialize_for_alloy_primitives::bits::fixed::FixedBytes<_>>::
      deserialize(&local_78,&local_50);
      if (local_78 != '\0') {
        local_c8 = local_f8 + lVar7 + 0x20;
        __ptr = local_e8;
        puVar3 = (undefined1 *)CONCAT17((undefined1)local_69,uStack_70);
        uVar6 = local_f0;
        goto joined_r0x0025be0e;
      }
      local_fc = local_73;
      local_100 = local_77;
      uVar2 = CONCAT71(uStack_70,local_71);
      local_98 = local_69;
      uStack_94 = uStack_65;
      uStack_90 = uStack_61;
      uStack_8c = uStack_5d;
      local_88 = local_59;
      if (uVar10 == local_f0) {
                    /* try { // try from 0025bd9a to 0025bda3 has its CatchHandler @ 0025bed2 */
        alloc::raw_vec::RawVec<T,A>::grow_one(&local_f0);
        puVar3 = local_e8;
      }
      pcVar8 = pcVar8 + 0x20;
      *(undefined2 *)(puVar3 + lVar7 + 4) = local_fc;
      *(undefined4 *)(puVar3 + lVar7) = local_100;
      *(undefined8 *)(puVar3 + lVar7 + 6) = uVar2;
      puVar1 = (undefined4 *)(puVar3 + lVar7 + 0xe);
      *puVar1 = local_98;
      puVar1[1] = uStack_94;
      puVar1[2] = uStack_90;
      puVar1[3] = uStack_8c;
      *(undefined2 *)(puVar3 + lVar7 + 0x1e) = local_88;
      local_e0 = uVar10 + 1;
    }
    local_c8 = pcVar4;
    if (local_f0 == 0x8000000000000000) {
LAB_0025be25:
      uVar6 = 0x8000000000000000;
    }
    else if (local_b8 != pcVar4) {
                    /* try { // try from 0025be8f to 0025bea6 has its CatchHandler @ 0025bebb */
      puVar5 = (undefined1 *)
               serde_core::de::Error::invalid_length
                         (local_b0,&PTR_s_fewer_elements_in_array_0096af38,&DAT_0096d9a0);
      __ptr = puVar3;
      puVar3 = puVar5;
joined_r0x0025be0e:
      if (uVar6 != 0) {
        free(__ptr);
      }
      goto LAB_0025be25;
    }
    param_1 = local_108;
                    /* try { // try from 0025be2d to 0025be75 has its CatchHandler @ 0025becd */
    _<alloc::vec::into_iter::IntoIter<T,A>as_core::ops::drop::Drop>::drop(&local_d0);
    uVar9 = 0x8000000000000000;
    if (uVar6 == 0x8000000000000000) goto LAB_0025be44;
  }
  param_1[2] = uVar10;
  uVar9 = uVar6;
LAB_0025be44:
  param_1[1] = (ulong)puVar3;
  *param_1 = uVar9;
  return;
}


