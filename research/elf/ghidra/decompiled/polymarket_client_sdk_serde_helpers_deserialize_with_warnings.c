// polymarket_client_sdk::serde_helpers::deserialize_with_warnings
// entry = 0028dd10


/* polymarket_client_sdk::serde_helpers::deserialize_with_warnings */

void __rustcall
polymarket_client_sdk::serde_helpers::deserialize_with_warnings
          (undefined8 *param_1,undefined1 (*param_2) [16],undefined8 param_3,
          undefined1 (*param_4) [16])

{
  undefined4 *puVar1;
  char cVar2;
  long *__ptr;
  void *__ptr_00;
  uint uVar3;
  uint uVar4;
  undefined8 uVar5;
  undefined1 auVar6 [16];
  bool bVar7;
  undefined7 uVar8;
  undefined7 uVar9;
  undefined4 uVar10;
  undefined4 uVar11;
  ulong uVar12;
  undefined8 uVar13;
  undefined1 (*extraout_RDX) [16];
  uint uVar14;
  undefined1 (*unaff_RBP) [16];
  void *pvVar15;
  undefined *puVar16;
  char cVar17;
  undefined1 (*pauVar19) [16];
  undefined8 *puVar20;
  long lVar21;
  undefined1 (*pauVar22) [16];
  long lVar23;
  undefined1 (*unaff_R15) [16];
  long in_FS_OFFSET;
  bool bVar24;
  bool bVar25;
  undefined1 auVar26 [16];
  undefined1 auVar27 [16];
  undefined1 (*local_228) [16];
  undefined1 (*local_220) [16];
  char local_208 [16];
  undefined4 local_1f8;
  undefined4 uStack_1f4;
  undefined4 uStack_1f0;
  undefined4 uStack_1ec;
  undefined1 (*local_1e8) [16];
  char local_1e0 [16];
  undefined4 uStack_1d0;
  undefined4 uStack_1cc;
  undefined1 (*pauStack_1c8) [16];
  ulong local_1c0;
  undefined8 uStack_1b8;
  undefined1 (*local_1b0) [16];
  undefined1 (*local_1a8) [16];
  undefined1 (*local_1a0) [16];
  char local_198 [8];
  undefined1 uStack_190;
  undefined1 uStack_18f;
  undefined1 uStack_18e;
  undefined1 uStack_18d;
  undefined1 uStack_18c;
  undefined1 uStack_18b;
  undefined1 uStack_18a;
  undefined1 uStack_189;
  undefined4 local_188;
  undefined4 uStack_184;
  undefined4 uStack_180;
  undefined4 uStack_17c;
  long local_178;
  undefined1 (*pauStack_170) [16];
  undefined1 (*local_168) [16];
  undefined1 local_158 [16];
  undefined1 (*local_148) [16];
  undefined1 (*pauStack_140) [16];
  undefined8 local_138;
  undefined8 uStack_130;
  long local_128;
  undefined1 (*pauStack_120) [16];
  undefined1 (*local_118) [16];
  ulong local_108;
  undefined8 uStack_100;
  undefined1 (*local_f8) [16];
  undefined8 *local_e8;
  undefined1 (*local_e0) [16];
  undefined1 (*pauStack_d8) [16];
  undefined1 (*local_d0) [16];
  undefined1 (*pauStack_c8) [16];
  undefined8 local_c0;
  undefined8 uStack_b8;
  char local_b0;
  undefined7 uStack_af;
  undefined1 uStack_a8;
  undefined7 uStack_a7;
  undefined4 uStack_a0;
  undefined4 uStack_9c;
  undefined1 (*pauStack_98) [16];
  undefined8 local_90;
  undefined8 uStack_88;
  undefined8 local_80;
  undefined1 (*local_78) [16];
  undefined1 (*local_70) [16];
  undefined1 (*local_68) [16];
  long local_60;
  undefined1 (*pauStack_58) [16];
  undefined1 (*local_50) [16];
  ulong local_48;
  undefined8 uStack_40;
  undefined1 (*local_38) [16];
  char cVar18;
  
  if ((*param_2)[0] != '\0') {
    cVar2 = (*param_2)[0];
    local_e8 = param_1;
    if (cVar2 == '\x04') {
      local_d0 = *(undefined1 (**) [16])(*param_2 + 8);
      local_e0 = *(undefined1 (**) [16])param_2[1];
      lVar21 = *(long *)(param_2[1] + 8);
      pauVar22 = local_e0 + lVar21 * 2;
      local_228 = (undefined1 (*) [16])&DAT_00000008;
      pauStack_c8 = pauVar22;
      if (lVar21 == 0) {
        lVar23 = 0;
        unaff_RBP = (undefined1 (*) [16])0x0;
        unaff_R15 = local_e0;
        pauStack_d8 = local_e0;
LAB_0028e244:
        local_208[0] = (char)lVar23;
        cVar17 = local_208[0];
        local_208._1_7_ = (undefined7)((ulong)lVar23 >> 8);
        uVar8 = local_208._1_7_;
        local_208[8] = (char)local_228;
        cVar18 = local_208[8];
        local_208._9_7_ = (undefined7)((ulong)local_228 >> 8);
        uVar9 = local_208._9_7_;
        local_1f8 = SUB84(unaff_RBP,0);
        uVar10 = local_1f8;
        uStack_1f4 = (undefined4)((ulong)unaff_RBP >> 0x20);
        uVar11 = uStack_1f4;
        pauVar19 = pauVar22;
        if (unaff_R15 == pauVar22) {
LAB_0028e277:
          if (*(char *)(in_FS_OFFSET + -0x18) == '\x01') {
            auVar26 = *(undefined1 (*) [16])(in_FS_OFFSET + -0x10);
          }
          else {
                    /* try { // try from 0028e9f6 to 0028e9fa has its CatchHandler @ 0028eacd */
            auVar26 = std::sys::random::linux::hashmap_random_keys();
            *(undefined1 *)(in_FS_OFFSET + -0x18) = 1;
            *(undefined1 (*) [16])(in_FS_OFFSET + -0x10) = auVar26;
          }
          *(long *)(in_FS_OFFSET + -0x10) = auVar26._0_8_ + 1;
          local_158 = (undefined1  [16])0x0;
          local_148 = (undefined1 (*) [16])0x0;
          unaff_R15 = (undefined1 (*) [16])&DAT_007c8640;
        }
        else {
          pauVar19 = unaff_R15 + 2;
          pauStack_d8 = pauVar19;
          if ((*unaff_R15)[0] == '\x06') goto LAB_0028e277;
          uStack_a0 = *(undefined4 *)unaff_R15[1];
          uStack_9c = *(undefined4 *)(unaff_R15[1] + 4);
          pauStack_98 = *(undefined1 (**) [16])(unaff_R15[1] + 8);
          uStack_af = (undefined7)*(undefined8 *)(*unaff_R15 + 1);
          uStack_a8 = (undefined1)((ulong)*(undefined8 *)(*unaff_R15 + 1) >> 0x38);
          uStack_a7 = (undefined7)*(undefined8 *)(*unaff_R15 + 9);
                    /* try { // try from 0028e43f to 0028e450 has its CatchHandler @ 0028eacd */
          local_b0 = (*unaff_R15)[0];
          _<<polymarket_client_sdk::clob::types::response::_::<impl_serde_core::de::Deserialize_for_polymarket_client_sdk::clob::types::response::CancelOrdersResponse>::deserialize::__Visitor_as_serde_core::de::Visitor>::visit_map::__DeserializeWith_as_serde_core::de::Deserialize>
          ::deserialize(local_1e0,&local_b0);
          unaff_R15 = (undefined1 (*) [16])CONCAT71(local_1e0._1_7_,local_1e0[0]);
          if (unaff_R15 == (undefined1 (*) [16])0x0) {
            pauVar22 = (undefined1 (*) [16])CONCAT71(local_1e0._9_7_,local_1e0[8]);
            pauVar19 = local_228;
            while( true ) {
              unaff_R15 = (undefined1 (*) [16])(*pauVar19 + 8);
              bVar24 = unaff_RBP == (undefined1 (*) [16])0x0;
              unaff_RBP = (undefined1 (*) [16])(unaff_RBP[-1] + 0xf);
              if (bVar24) break;
              if (*(long *)*pauVar19 != 0) {
                free(*(void **)*unaff_R15);
              }
              pauVar19 = (undefined1 (*) [16])(pauVar19[1] + 8);
            }
            if (lVar23 != 0) {
              free(local_228);
            }
            unaff_RBP = (undefined1 (*) [16])0xffffffffffffffff;
            local_228 = pauVar22;
            goto LAB_0028e55c;
          }
          local_148 = pauStack_1c8;
          local_158[1] = local_1e0[9];
          local_158[2] = local_1e0[10];
          local_158[3] = local_1e0[0xb];
          local_158[4] = local_1e0[0xc];
          local_158[5] = local_1e0[0xd];
          local_158[6] = local_1e0[0xe];
          local_158[7] = local_1e0[0xf];
          local_158[0] = local_1e0[8];
          local_158._12_4_ = uStack_1cc;
          local_158._8_4_ = uStack_1d0;
          auVar26._8_8_ = uStack_1b8;
          auVar26._0_8_ = local_1c0;
        }
        local_220 = auVar26._8_8_;
        local_1e8 = auVar26._0_8_;
        local_1c0 = local_158._0_8_;
        uStack_1b8 = local_158._8_8_;
        local_1b0 = local_148;
        local_1a0 = local_220;
        local_1e0[0] = cVar17;
        local_1e0._1_7_ = uVar8;
        local_1e0[8] = cVar18;
        local_1e0._9_7_ = uVar9;
        uStack_1d0 = uVar10;
        uStack_1cc = uVar11;
        pauStack_1c8 = unaff_R15;
        local_1a8 = local_1e8;
        if (pauVar22 == pauVar19) {
          local_f8 = local_148;
          local_108 = local_158._0_8_;
          uStack_100 = local_158._8_8_;
        }
        else {
                    /* try { // try from 0028e9c3 to 0028e9dc has its CatchHandler @ 0028eabe */
          local_228 = (undefined1 (*) [16])
                      serde_core::de::Error::invalid_length
                                (lVar21,&PTR_s_fewer_elements_in_array_0096af38,&DAT_0096d9a0);
          core::ptr::
          drop_in_place<polymarket_client_sdk::clob::types::response::CancelOrdersResponse>
                    (local_1e0);
          lVar23 = -0x8000000000000000;
        }
      }
      else {
        unaff_R15 = local_e0 + 2;
        pauStack_d8 = unaff_R15;
        if ((*local_e0)[0] == '\x06') {
          lVar23 = 0;
          unaff_RBP = (undefined1 (*) [16])0x0;
          goto LAB_0028e244;
        }
        uStack_1d0 = *(undefined4 *)local_e0[1];
        uStack_1cc = *(undefined4 *)(local_e0[1] + 4);
        pauStack_1c8 = *(undefined1 (**) [16])(local_e0[1] + 8);
        local_1e0._1_7_ = (undefined7)*(undefined8 *)(*local_e0 + 1);
        local_1e0[8] = (char)((ulong)*(undefined8 *)(*local_e0 + 1) >> 0x38);
        local_1e0._9_7_ = (undefined7)*(undefined8 *)(*local_e0 + 9);
                    /* try { // try from 0028e20a to 0028e21b has its CatchHandler @ 0028eb07 */
        local_1e0[0] = (*local_e0)[0];
        _<<polymarket_client_sdk::clob::types::response::_::<impl_serde_core::de::Deserialize_for_polymarket_client_sdk::clob::types::response::OpenOrderResponse>::deserialize::__Visitor_as_serde_core::de::Visitor>::visit_map::__DeserializeWith_as_serde_core::de::Deserialize>
        ::deserialize(&local_b0,local_1e0);
        lVar23 = CONCAT71(uStack_af,local_b0);
        local_228 = (undefined1 (*) [16])CONCAT71(uStack_a7,uStack_a8);
        if (lVar23 != -0x8000000000000000) {
          unaff_RBP = (undefined1 (*) [16])CONCAT44(uStack_9c,uStack_a0);
          goto LAB_0028e244;
        }
LAB_0028e55c:
        local_108 = local_158._0_8_;
        uStack_100 = local_158._8_8_;
        local_f8 = local_148;
        lVar23 = -0x8000000000000000;
      }
                    /* try { // try from 0028e586 to 0028e592 has its CatchHandler @ 0028eb47 */
      _<alloc::vec::into_iter::IntoIter<T,A>as_core::ops::drop::Drop>::drop(&local_e0);
      bVar24 = true;
      bVar7 = false;
      bVar25 = false;
      goto joined_r0x0028e5a8;
    }
    if (cVar2 == '\x05') {
      local_1b0 = *(undefined1 (**) [16])(*param_2 + 8);
      pauStack_1c8 = *(undefined1 (**) [16])param_2[1];
      local_68 = *(undefined1 (**) [16])(param_2[1] + 8);
      local_1e0[0] = local_1b0 != (undefined1 (*) [16])0x0;
      local_1c0 = (ulong)(byte)local_1e0[0];
      local_1a0 = local_68;
      if (!(bool)local_1e0[0]) {
        local_1a0 = (undefined1 (*) [16])0x0;
      }
      local_1e0[1] = '\0';
      local_1e0[2] = '\0';
      local_1e0[3] = '\0';
      local_1e0[4] = '\0';
      local_1e0[5] = '\0';
      local_1e0[6] = '\0';
      local_1e0[7] = '\0';
      local_1e0[8] = 0;
      local_1e0[9] = '\0';
      local_1e0[10] = '\0';
      local_1e0[0xb] = '\0';
      local_1e0[0xc] = '\0';
      local_1e0[0xd] = '\0';
      local_1e0[0xe] = '\0';
      local_1e0[0xf] = '\0';
      uStack_1d0 = SUB84(local_1b0,0);
      uStack_1cc = (undefined4)((ulong)local_1b0 >> 0x20);
      uStack_1b8 = 0;
      local_198[0] = '\x06';
      local_178 = -0x8000000000000000;
      auVar6._8_8_ = 0;
      auVar6._0_8_ = local_158._8_8_;
      local_158 = auVar6 << 0x40;
      unaff_RBP = (undefined1 (*) [16])local_1e0;
      local_1a8 = pauStack_1c8;
LAB_0028ddf0:
                    /* try { // try from 0028ddf0 to 0028ddff has its CatchHandler @ 0028ebbd */
      alloc::collections::btree::map::IntoIter<K,V,A>::dying_next(&local_128,unaff_RBP);
      if (local_128 == 0) goto LAB_0028e165;
      unaff_R15 = *(undefined1 (**) [16])(local_128 + 0x168 + (long)local_118 * 0x18);
      __ptr = *(long **)(local_128 + 0x170 + (long)local_118 * 0x18);
      lVar21 = *(long *)(local_128 + 0x178 + (long)local_118 * 0x18);
      puVar20 = (undefined8 *)(local_128 + (long)local_118 * 0x20);
      uVar13 = *puVar20;
      uVar5 = puVar20[1];
      puVar1 = (undefined4 *)(local_128 + 0x10 + (long)local_118 * 0x20);
      local_1f8 = *puVar1;
      uStack_1f4 = puVar1[1];
      uStack_1f0 = puVar1[2];
      uStack_1ec = puVar1[3];
      local_208[0] = (char)uVar13;
      local_208._1_7_ = (undefined7)((ulong)uVar13 >> 8);
      local_208[8] = (char)uVar5;
      local_208._9_7_ = (undefined7)((ulong)uVar5 >> 8);
      if (unaff_R15 == (undefined1 (*) [16])0x8000000000000000) goto LAB_0028e165;
      if (local_198[0] != '\x06') {
                    /* try { // try from 0028de69 to 0028de70 has its CatchHandler @ 0028eb4f */
        core::ptr::drop_in_place<serde_json::value::Value>(local_198);
      }
      local_188 = local_1f8;
      uStack_184 = uStack_1f4;
      uStack_180 = uStack_1f0;
      uStack_17c = uStack_1ec;
      local_198[0] = local_208[0];
      local_198[1] = local_208[1];
      local_198[2] = local_208[2];
      local_198[3] = local_208[3];
      local_198[4] = local_208[4];
      local_198[5] = local_208[5];
      local_198[6] = local_208[6];
      local_198[7] = local_208[7];
      uStack_190 = local_208[8];
      uStack_18f = local_208[9];
      uStack_18e = local_208[10];
      uStack_18d = local_208[0xb];
      uStack_18c = local_208[0xc];
      uStack_18b = local_208[0xd];
      uStack_18a = local_208[0xe];
      uStack_189 = local_208[0xf];
      if (lVar21 == 0xc) {
        if ((int)__ptr[1] != 0x64656c65 || *__ptr != 0x636e61635f746f6e) goto LAB_0028deea;
LAB_0028e0d3:
        cVar18 = '\x01';
        cVar17 = '\x01';
      }
      else {
        if (lVar21 == 0xb) {
          if (*(long *)((long)__ptr + 3) == 0x64656c65636e6143 && *__ptr == 0x65636e6143746f6e)
          goto LAB_0028e0d3;
        }
        else if ((lVar21 == 8) && (*__ptr == 0x64656c65636e6163)) {
          cVar18 = '\0';
          cVar17 = '\0';
          goto joined_r0x0028e0d9;
        }
LAB_0028deea:
        cVar18 = '\x02';
        cVar17 = '\x02';
      }
joined_r0x0028e0d9:
      if (unaff_R15 != (undefined1 (*) [16])0x0) {
        free(__ptr);
        cVar17 = cVar18;
      }
      cVar18 = local_198[0];
      if (cVar17 == '\0') {
        if (local_178 == -0x8000000000000000) {
          local_198[0] = '\x06';
          if (cVar18 == '\x06') {
            local_228 = (undefined1 (*) [16])
                        _<serde_json::error::Error_as_serde_core::de::Error>::custom
                                  (&DAT_007c9290,0x10);
          }
          else {
            local_208[0] = cVar18;
            uStack_1f4 = uStack_184;
            uStack_1f0 = uStack_180;
            uStack_1ec = uStack_17c;
            local_208[1] = local_198[1];
            local_208[2] = local_198[2];
            local_208[3] = local_198[3];
            local_208[4] = local_198[4];
            local_208[5] = local_198[5];
            local_208[6] = local_198[6];
            local_208[7] = local_198[7];
            local_208[8] = uStack_190;
            local_208[9] = uStack_18f;
            local_208[10] = uStack_18e;
            local_208[0xb] = uStack_18d;
            local_208[0xc] = uStack_18c;
            local_208[0xd] = uStack_18b;
            local_208[0xe] = uStack_18a;
            local_208[0xf] = uStack_189;
            local_1f8 = local_188;
            _<<polymarket_client_sdk::clob::types::response::_::<impl_serde_core::de::Deserialize_for_polymarket_client_sdk::clob::types::response::OpenOrderResponse>::deserialize::__Visitor_as_serde_core::de::Visitor>::visit_map::__DeserializeWith_as_serde_core::de::Deserialize>
            ::deserialize(&local_60,local_208);
            local_228 = pauStack_58;
            if (local_60 != -0x8000000000000000) {
              local_168 = local_50;
              local_178 = local_60;
              pauStack_170 = pauStack_58;
              goto LAB_0028ddf0;
            }
          }
        }
        else {
          uVar13 = 8;
          puVar16 = &DAT_007cadf8;
LAB_0028e974:
                    /* try { // try from 0028e974 to 0028e97c has its CatchHandler @ 0028eadc */
          local_228 = (undefined1 (*) [16])serde_core::de::Error::duplicate_field(puVar16,uVar13);
        }
      }
      else {
        if (cVar17 != '\x01') {
          local_198[0] = '\x06';
          if (cVar18 == '\x06') {
                    /* try { // try from 0028e635 to 0028e681 has its CatchHandler @ 0028eadc */
            local_228 = (undefined1 (*) [16])
                        _<serde_json::error::Error_as_serde_core::de::Error>::custom
                                  (&DAT_007c9290,0x10);
            goto LAB_0028e69a;
          }
          uStack_1f4 = uStack_184;
          uStack_1f0 = uStack_180;
          uStack_1ec = uStack_17c;
          local_208[1] = local_198[1];
          local_208[2] = local_198[2];
          local_208[3] = local_198[3];
          local_208[4] = local_198[4];
          local_208[5] = local_198[5];
          local_208[6] = local_198[6];
          local_208[7] = local_198[7];
          local_208[8] = uStack_190;
          local_208[9] = uStack_18f;
          local_208[10] = uStack_18e;
          local_208[0xb] = uStack_18d;
          local_208[0xc] = uStack_18c;
          local_208[0xd] = uStack_18b;
          local_208[0xe] = uStack_18a;
          local_208[0xf] = uStack_189;
          local_1f8 = local_188;
          local_208[0] = cVar18;
          core::ptr::drop_in_place<serde_json::value::Value>(local_208);
          goto LAB_0028ddf0;
        }
        if (local_158._0_8_ != 0) {
          uVar13 = 0xb;
          puVar16 = &DAT_007dc3bf;
          goto LAB_0028e974;
        }
        local_198[0] = '\x06';
        if (cVar18 != '\x06') {
          local_208[0] = cVar18;
          uStack_1f4 = uStack_184;
          uStack_1f0 = uStack_180;
          uStack_1ec = uStack_17c;
          local_208[1] = local_198[1];
          local_208[2] = local_198[2];
          local_208[3] = local_198[3];
          local_208[4] = local_198[4];
          local_208[5] = local_198[5];
          local_208[6] = local_198[6];
          local_208[7] = local_198[7];
          local_208[8] = uStack_190;
          local_208[9] = uStack_18f;
          local_208[10] = uStack_18e;
          local_208[0xb] = uStack_18d;
          local_208[0xc] = uStack_18c;
          local_208[0xd] = uStack_18b;
          local_208[0xe] = uStack_18a;
          local_208[0xf] = uStack_189;
          local_1f8 = local_188;
                    /* try { // try from 0028df5d to 0028e09c has its CatchHandler @ 0028ebbd */
          _<<polymarket_client_sdk::clob::types::response::_::<impl_serde_core::de::Deserialize_for_polymarket_client_sdk::clob::types::response::CancelOrdersResponse>::deserialize::__Visitor_as_serde_core::de::Visitor>::visit_map::__DeserializeWith_as_serde_core::de::Deserialize>
          ::deserialize(&local_e0,local_208);
          local_228 = pauStack_d8;
          if (local_e0 == (undefined1 (*) [16])0x0) goto LAB_0028e69a;
          local_148 = local_d0;
          pauStack_140 = pauStack_c8;
          local_138 = local_c0;
          uStack_130 = uStack_b8;
          local_158._8_8_ = pauStack_d8;
          local_158._0_8_ = local_e0;
          goto LAB_0028ddf0;
        }
        local_228 = (undefined1 (*) [16])
                    _<serde_json::error::Error_as_serde_core::de::Error>::custom(&DAT_007c9290,0x10)
        ;
      }
LAB_0028e69a:
      uVar13 = local_158._0_8_;
      if (((undefined1 (*) [16])local_158._0_8_ != (undefined1 (*) [16])0x0) &&
         ((undefined1 (*) [16])local_158._8_8_ != (undefined1 (*) [16])0x0)) {
        local_1e8 = (undefined1 (*) [16])local_158._8_8_;
        local_220 = (undefined1 (*) [16])local_158._0_8_;
        if (pauStack_140 != (undefined1 (*) [16])0x0) {
          auVar26 = *(undefined1 (*) [16])local_158._0_8_;
          uVar14 = ~(uint)(ushort)((ushort)(SUB161(auVar26 >> 7,0) & 1) |
                                   (ushort)(SUB161(auVar26 >> 0xf,0) & 1) << 1 |
                                   (ushort)(SUB161(auVar26 >> 0x17,0) & 1) << 2 |
                                   (ushort)(SUB161(auVar26 >> 0x1f,0) & 1) << 3 |
                                   (ushort)(SUB161(auVar26 >> 0x27,0) & 1) << 4 |
                                   (ushort)(SUB161(auVar26 >> 0x2f,0) & 1) << 5 |
                                   (ushort)(SUB161(auVar26 >> 0x37,0) & 1) << 6 |
                                   (ushort)(SUB161(auVar26 >> 0x3f,0) & 1) << 7 |
                                   (ushort)(SUB161(auVar26 >> 0x47,0) & 1) << 8 |
                                   (ushort)(SUB161(auVar26 >> 0x4f,0) & 1) << 9 |
                                   (ushort)(SUB161(auVar26 >> 0x57,0) & 1) << 10 |
                                   (ushort)(SUB161(auVar26 >> 0x5f,0) & 1) << 0xb |
                                   (ushort)(SUB161(auVar26 >> 0x67,0) & 1) << 0xc |
                                   (ushort)(SUB161(auVar26 >> 0x6f,0) & 1) << 0xd |
                                   (ushort)(SUB161(auVar26 >> 0x77,0) & 1) << 0xe |
                                  (ushort)(byte)(auVar26[0xf] >> 7) << 0xf);
          unaff_R15 = (undefined1 (*) [16])(local_158._0_8_ + 0x10);
          unaff_RBP = (undefined1 (*) [16])local_158._0_8_;
          pauVar22 = pauStack_140;
          do {
            if ((short)uVar14 == 0) {
              do {
                auVar26 = *unaff_R15;
                unaff_RBP = unaff_RBP + -0x30;
                unaff_R15 = unaff_R15 + 1;
                uVar14 = (uint)(ushort)((ushort)(SUB161(auVar26 >> 7,0) & 1) |
                                        (ushort)(SUB161(auVar26 >> 0xf,0) & 1) << 1 |
                                        (ushort)(SUB161(auVar26 >> 0x17,0) & 1) << 2 |
                                        (ushort)(SUB161(auVar26 >> 0x1f,0) & 1) << 3 |
                                        (ushort)(SUB161(auVar26 >> 0x27,0) & 1) << 4 |
                                        (ushort)(SUB161(auVar26 >> 0x2f,0) & 1) << 5 |
                                        (ushort)(SUB161(auVar26 >> 0x37,0) & 1) << 6 |
                                        (ushort)(SUB161(auVar26 >> 0x3f,0) & 1) << 7 |
                                        (ushort)(SUB161(auVar26 >> 0x47,0) & 1) << 8 |
                                        (ushort)(SUB161(auVar26 >> 0x4f,0) & 1) << 9 |
                                        (ushort)(SUB161(auVar26 >> 0x57,0) & 1) << 10 |
                                        (ushort)(SUB161(auVar26 >> 0x5f,0) & 1) << 0xb |
                                        (ushort)(SUB161(auVar26 >> 0x67,0) & 1) << 0xc |
                                        (ushort)(SUB161(auVar26 >> 0x6f,0) & 1) << 0xd |
                                        (ushort)(SUB161(auVar26 >> 0x77,0) & 1) << 0xe |
                                       (ushort)(byte)(auVar26[0xf] >> 7) << 0xf);
              } while (uVar14 == 0xffff);
              uVar14 = ~uVar14;
            }
            uVar3 = 0;
            for (uVar4 = uVar14; (uVar4 & 1) == 0; uVar4 = uVar4 >> 1 | 0x80000000) {
              uVar3 = uVar3 + 1;
            }
            uVar12 = (ulong)uVar3;
            if (*(long *)unaff_RBP[uVar12 * -3 + -3] != 0) {
              free(*(void **)(unaff_RBP[uVar12 * -3 + -3] + 8));
            }
            if (*(long *)(unaff_RBP[uVar12 * -3 + -2] + 8) != 0) {
              free(*(void **)unaff_RBP[uVar12 * -3 + -1]);
            }
            uVar14 = uVar14 - 1 & uVar14;
            pauVar22 = (undefined1 (*) [16])(pauVar22[-1] + 0xf);
          } while (pauVar22 != (undefined1 (*) [16])0x0);
        }
        if ((long)local_1e8 * 0x31 != -0x41) {
          free((undefined1 (*) [16])(uVar13 + ((long)local_1e8 * -3 + -3) * 0x10));
        }
      }
      lVar21 = local_178;
      auVar27._8_8_ = local_220;
      auVar27._0_8_ = local_1e8;
      if (local_178 != -0x8000000000000000) {
        puVar20 = (undefined8 *)(*pauStack_170 + 8);
        pauVar22 = local_168;
        while( true ) {
          auVar27._0_8_ = local_1e8;
          bVar24 = pauVar22 == (undefined1 (*) [16])0x0;
          pauVar22 = (undefined1 (*) [16])(pauVar22[-1] + 0xf);
          if (bVar24) break;
          if (puVar20[-1] != 0) {
            free((void *)*puVar20);
          }
          puVar20 = puVar20 + 3;
        }
        unaff_R15 = (undefined1 (*) [16])0xffffffffffffffff;
        if (lVar21 != 0) {
          free(pauStack_170);
          auVar27._0_8_ = local_1e8;
        }
      }
      goto LAB_0028e7f5;
    }
    bVar24 = true;
                    /* try { // try from 0028e984 to 0028e9a1 has its CatchHandler @ 0028eb47 */
    local_228 = (undefined1 (*) [16])
                serde_json::value::de::_<impl_serde_json::value::Value>::invalid_type
                          (param_2,&local_b0,&DAT_00967318);
    lVar23 = -0x8000000000000000;
    bVar7 = true;
    if (cVar2 == '\x04') goto LAB_0028e850;
    goto LAB_0028e5ae;
  }
  lVar23 = -0x8000000000000000;
  core::ptr::drop_in_place<serde_json::value::Value>(param_2);
  local_1e8 = extraout_RDX;
LAB_0028e907:
  param_1[3] = unaff_RBP;
  param_1[4] = unaff_R15;
  param_1[5] = local_48;
  param_1[6] = uStack_40;
  param_1[7] = local_38;
  param_1[8] = local_1e8;
  param_1[9] = param_2;
  param_1[1] = lVar23;
  param_1[2] = param_4;
  uVar13 = 0;
  goto LAB_0028e93b;
LAB_0028e165:
  if (local_178 == -0x8000000000000000) {
    local_128 = 0;
    pauStack_120 = (undefined1 (*) [16])&DAT_00000008;
    local_118 = (undefined1 (*) [16])0x0;
    if ((undefined1 (*) [16])local_158._0_8_ == (undefined1 (*) [16])0x0) goto LAB_0028e304;
LAB_0028e1b6:
    local_1f8 = SUB84(pauStack_140,0);
    uStack_1f4 = (undefined4)((ulong)pauStack_140 >> 0x20);
    local_208[0] = local_158[8];
    local_208._1_7_ = local_158._9_7_;
    local_208[8] = (char)local_148;
    local_208._9_7_ = (undefined7)((ulong)local_148 >> 8);
    auVar27._8_8_ = uStack_130;
    auVar27._0_8_ = local_138;
    unaff_R15 = (undefined1 (*) [16])local_158._0_8_;
  }
  else {
    local_118 = local_168;
    local_128 = local_178;
    pauStack_120 = pauStack_170;
    if ((undefined1 (*) [16])local_158._0_8_ != (undefined1 (*) [16])0x0) goto LAB_0028e1b6;
LAB_0028e304:
    if (*(char *)(in_FS_OFFSET + -0x18) == '\x01') {
      auVar27 = *(undefined1 (*) [16])(in_FS_OFFSET + -0x10);
    }
    else {
                    /* try { // try from 0028ea5b to 0028ea64 has its CatchHandler @ 0028ea94 */
      auVar27 = std::sys::random::linux::hashmap_random_keys();
      *(undefined1 *)(in_FS_OFFSET + -0x18) = 1;
      *(undefined1 (*) [16])(in_FS_OFFSET + -0x10) = auVar27;
    }
    *(long *)(in_FS_OFFSET + -0x10) = auVar27._0_8_ + 1;
    local_208[0] = '\0';
    local_208[1] = '\0';
    local_208[2] = '\0';
    local_208[3] = '\0';
    local_208[4] = '\0';
    local_208[5] = '\0';
    local_208[6] = '\0';
    local_208[7] = '\0';
    local_208[8] = 0;
    local_208[9] = '\0';
    local_208[10] = '\0';
    local_208[0xb] = '\0';
    local_208[0xc] = '\0';
    local_208[0xd] = '\0';
    local_208[0xe] = '\0';
    local_208[0xf] = '\0';
    local_1f8 = 0;
    uStack_1f4 = 0;
    unaff_R15 = (undefined1 (*) [16])&DAT_007c8640;
  }
  unaff_RBP = local_118;
  local_220 = auVar27._8_8_;
  local_1e8 = auVar27._0_8_;
  local_228 = pauStack_120;
  if (local_128 == -0x8000000000000000) {
LAB_0028e7f5:
    local_220 = auVar27._8_8_;
    local_1e8 = auVar27._0_8_;
    local_f8 = (undefined1 (*) [16])CONCAT44(uStack_1f4,local_1f8);
    local_108 = CONCAT71(local_208._1_7_,local_208[0]);
    uStack_100 = CONCAT71(local_208._9_7_,local_208[8]);
                    /* try { // try from 0028e811 to 0028e81a has its CatchHandler @ 0028eb21 */
    core::ptr::
    drop_in_place<alloc::collections::btree::map::IntoIter<alloc::string::String,serde_json::value::Value>>
              (local_1e0);
    lVar23 = -0x8000000000000000;
  }
  else {
    local_90 = CONCAT71(local_208._1_7_,local_208[0]);
    uStack_88 = CONCAT71(local_208._9_7_,local_208[8]);
    local_80 = CONCAT44(uStack_1f4,local_1f8);
    local_b0 = (char)local_128;
    uStack_af = (undefined7)((ulong)local_128 >> 8);
    uStack_a8 = SUB81(pauStack_120,0);
    uStack_a7 = (undefined7)((ulong)pauStack_120 >> 8);
    uStack_a0 = SUB84(local_118,0);
    uStack_9c = (undefined4)((ulong)local_118 >> 0x20);
    local_70 = local_220;
    pauStack_98 = unaff_R15;
    local_78 = local_1e8;
    if (local_1a0 == (undefined1 (*) [16])0x0) {
      local_f8 = (undefined1 (*) [16])CONCAT44(uStack_1f4,local_1f8);
      local_108 = CONCAT71(local_208._1_7_,local_208[0]);
      uStack_100 = CONCAT71(local_208._9_7_,local_208[8]);
      lVar23 = local_128;
    }
    else {
                    /* try { // try from 0028ea20 to 0028ea3e has its CatchHandler @ 0028eaa9 */
      local_228 = (undefined1 (*) [16])
                  serde_core::de::Error::invalid_length
                            (local_68,&PTR_s_fewer_elements_in_map_0096af48,&DAT_0096d9a0);
      core::ptr::drop_in_place<polymarket_client_sdk::clob::types::response::CancelOrdersResponse>
                (&local_b0);
      lVar23 = -0x8000000000000000;
    }
                    /* try { // try from 0028e401 to 0028e40a has its CatchHandler @ 0028eae1 */
    core::ptr::
    drop_in_place<alloc::collections::btree::map::IntoIter<alloc::string::String,serde_json::value::Value>>
              (local_1e0);
  }
  if (local_198[0] != '\x06') {
                    /* try { // try from 0028e82d to 0028e834 has its CatchHandler @ 0028eb47 */
    core::ptr::drop_in_place<serde_json::value::Value>(local_198);
  }
  bVar7 = true;
  bVar24 = false;
  bVar25 = true;
joined_r0x0028e5a8:
  if (bVar25) {
LAB_0028e5ae:
    if (cVar2 == '\x05') {
      if (bVar24) {
        pauVar22 = *(undefined1 (**) [16])(*param_2 + 8);
        if (pauVar22 == (undefined1 (*) [16])0x0) {
          local_1a0 = (undefined1 (*) [16])0x0;
        }
        else {
          pauStack_1c8 = *(undefined1 (**) [16])param_2[1];
          local_1a0 = *(undefined1 (**) [16])(param_2[1] + 8);
          local_1e0[8] = 0;
          local_1e0[9] = '\0';
          local_1e0[10] = '\0';
          local_1e0[0xb] = '\0';
          local_1e0[0xc] = '\0';
          local_1e0[0xd] = '\0';
          local_1e0[0xe] = '\0';
          local_1e0[0xf] = '\0';
          uStack_1d0 = SUB84(pauVar22,0);
          uStack_1cc = (undefined4)((ulong)pauVar22 >> 0x20);
          uStack_1b8 = 0;
          local_1b0 = pauVar22;
          local_1a8 = pauStack_1c8;
        }
        local_1e0[0] = pauVar22 != (undefined1 (*) [16])0x0;
        local_1c0 = (ulong)(byte)local_1e0[0];
        local_1e0[1] = '\0';
        local_1e0[2] = '\0';
        local_1e0[3] = '\0';
        local_1e0[4] = '\0';
        local_1e0[5] = '\0';
        local_1e0[6] = '\0';
        local_1e0[7] = '\0';
        core::ptr::
        drop_in_place<alloc::collections::btree::map::IntoIter<alloc::string::String,serde_json::value::Value>>
                  (local_1e0);
      }
    }
    else {
      core::ptr::drop_in_place<serde_json::value::Value>(param_2);
    }
  }
  else {
LAB_0028e850:
    if (bVar7) {
      __ptr_00 = *(void **)param_2[1];
      pvVar15 = __ptr_00;
      for (lVar21 = *(long *)(param_2[1] + 8) + 1; lVar21 != 1; lVar21 = lVar21 + -1) {
                    /* try { // try from 0028e87d to 0028e881 has its CatchHandler @ 0028eb7a */
        core::ptr::drop_in_place<serde_json::value::Value>(pvVar15);
        pvVar15 = (void *)((long)pvVar15 + 0x20);
      }
      if (*(long *)(*param_2 + 8) != 0) {
        free(__ptr_00);
      }
    }
  }
  param_1 = local_e8;
  if (lVar23 != -0x8000000000000000) {
    local_38 = local_f8;
    local_48 = local_108;
    uStack_40 = uStack_100;
    param_4 = local_228;
    param_2 = local_220;
    if (lVar23 != -0x7fffffffffffffff) goto LAB_0028e907;
  }
  _<polymarket_client_sdk::error::Error_as_core::convert::From<serde_json::error::Error>>::from
            (local_e8 + 1,local_228);
  uVar13 = 1;
LAB_0028e93b:
  *param_1 = uVar13;
  return;
}


