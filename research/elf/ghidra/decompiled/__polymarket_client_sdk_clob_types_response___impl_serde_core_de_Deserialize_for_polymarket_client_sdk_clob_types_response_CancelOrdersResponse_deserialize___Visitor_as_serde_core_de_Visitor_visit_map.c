// _<<polymarket_client_sdk::clob::types::response::_::<impl_serde_core::de::Deserialize_for_polymarket_client_sdk::clob::types::response::CancelOrdersResponse>::deserialize::__Visitor_as_serde_core::de::Visitor>::visit_map::__DeserializeWith_as_serde_core::de::Deserialize>::deserialize
// entry = 0025bf30


/* WARNING: Removing unreachable block (ram,0x0025c61a) */
/* _<<polymarket_client_sdk::clob::types::response::_::<impl serde_core::de::Deserialize for
   polymarket_client_sdk::clob::types::response::CancelOrdersResponse>::deserialize::__Visitor as
   serde_core::de::Visitor>::visit_map::__DeserializeWith as
   serde_core::de::Deserialize>::deserialize */

void __rustcall
_<<polymarket_client_sdk::clob::types::response::_::<impl_serde_core::de::Deserialize_for_polymarket_client_sdk::clob::types::response::CancelOrdersResponse>::deserialize::__Visitor_as_serde_core::de::Visitor>::visit_map::__DeserializeWith_as_serde_core::de::Deserialize>
::deserialize(undefined8 *param_1,char *param_2)

{
  ulong __size;
  undefined8 *puVar1;
  undefined4 *puVar2;
  long lVar3;
  undefined8 uVar4;
  undefined1 auVar5 [16];
  uint uVar6;
  uint uVar7;
  undefined8 uVar8;
  undefined8 uVar9;
  ulong uVar10;
  void *pvVar11;
  ulong uVar12;
  undefined1 (*pauVar13) [16];
  ulong uVar14;
  undefined1 (*pauVar15) [16];
  undefined1 (*pauVar16) [16];
  uint uVar17;
  undefined1 (**ppauVar18) [16];
  long lVar19;
  long in_FS_OFFSET;
  undefined1 auVar20 [16];
  undefined1 (*local_1e8) [16];
  undefined1 (*local_1e0) [16];
  undefined1 local_1d1;
  undefined8 *local_1d0;
  char local_1c8;
  undefined7 uStack_1c7;
  undefined1 uStack_1c0;
  undefined7 uStack_1bf;
  undefined4 local_1b8;
  undefined4 uStack_1b4;
  undefined1 auStack_1b0 [16];
  undefined1 (*local_190) [16];
  undefined1 (*local_188) [16];
  undefined1 (*local_180) [16];
  long lStack_178;
  undefined1 local_170 [16];
  long local_160;
  undefined1 (*pauStack_158) [16];
  long local_150;
  undefined1 (*local_148) [16];
  long lStack_140;
  ulong local_138;
  undefined1 (*local_128) [16];
  long lStack_120;
  ulong local_118;
  undefined8 uStack_110;
  long local_108;
  undefined8 local_100;
  ulong local_f8;
  undefined8 local_f0;
  long local_e8;
  undefined8 local_e0;
  ulong local_d8;
  char local_d0;
  undefined7 uStack_cf;
  undefined1 uStack_c8;
  undefined7 uStack_c7;
  undefined4 local_c0;
  undefined4 uStack_bc;
  undefined4 uStack_b8;
  undefined4 uStack_b4;
  undefined1 (*local_a8) [16];
  long lStack_a0;
  long local_90;
  undefined1 (*local_88) [16];
  undefined8 local_80;
  undefined1 (*local_78) [16];
  undefined1 (*local_70) [16];
  undefined1 (*local_68) [16];
  long lStack_60;
  undefined1 local_58 [16];
  long local_48;
  undefined1 (*pauStack_40) [16];
  long local_38;
  
  if (*param_2 == '\0') {
    core::ptr::drop_in_place<serde_json::value::Value>(param_2);
    if (*(char *)(in_FS_OFFSET + -0x18) == '\x01') {
      auVar20 = *(undefined1 (*) [16])(in_FS_OFFSET + -0x10);
    }
    else {
      auVar20 = std::sys::random::linux::hashmap_random_keys();
      *(undefined1 *)(in_FS_OFFSET + -0x18) = 1;
      *(undefined1 (*) [16])(in_FS_OFFSET + -0x10) = auVar20;
    }
    *(long *)(in_FS_OFFSET + -0x10) = auVar20._0_8_ + 1;
    pauVar15 = (undefined1 (*) [16])&DAT_007c8640;
    ppauVar18 = (undefined1 (**) [16])&DAT_00984d90;
    local_1e8 = (undefined1 (*) [16])0x0;
LAB_0025c5e2:
    pauVar13 = ppauVar18[1];
    param_1[2] = *ppauVar18;
    param_1[3] = pauVar13;
    *(undefined1 (*) [16])(param_1 + 4) = auVar20;
  }
  else {
    if (*param_2 == '\x05') {
      local_108 = *(long *)(param_2 + 8);
      local_100 = *(undefined8 *)(param_2 + 0x10);
      uVar14 = *(ulong *)(param_2 + 0x18);
      local_118 = (ulong)(local_108 != 0);
      uVar10 = uVar14;
      if (local_108 == 0) {
        uVar10 = 0;
      }
      uStack_110 = 0;
      local_f0 = 0;
      local_d0 = '\x06';
      uVar12 = 0x5555;
      if (uVar10 < 0x5555) {
        uVar12 = uVar10;
      }
      local_f8 = local_118;
      local_e8 = local_108;
      local_e0 = local_100;
      local_d8 = uVar10;
      if (*(char *)(in_FS_OFFSET + -0x18) == '\x01') {
        auVar20 = *(undefined1 (*) [16])(in_FS_OFFSET + -0x10);
      }
      else {
                    /* try { // try from 0025c69e to 0025c6a2 has its CatchHandler @ 0025c7e0 */
        auVar20 = std::sys::random::linux::hashmap_random_keys();
        *(undefined1 *)(in_FS_OFFSET + -0x18) = 1;
        *(undefined1 (*) [16])(in_FS_OFFSET + -0x10) = auVar20;
      }
      *(undefined1 **)(in_FS_OFFSET + -0x10) = *auVar20._0_8_ + 1;
      local_1d0 = param_1;
      local_138 = uVar14;
      if (uVar10 == 0) {
        pauVar16 = (undefined1 (*) [16])&DAT_007c8640;
        pauVar13 = (undefined1 (*) [16])0x0;
        pauVar15 = (undefined1 (*) [16])0x0;
      }
      else {
        if (uVar10 < 0xf) {
          uVar14 = 4;
          if (3 < uVar10) {
            uVar14 = (ulong)(7 < uVar10) * 8 + 8;
          }
        }
        else {
          uVar14 = (ulong)((uint)((int)uVar12 * 8) / 7) - 1;
          lVar3 = 0x3f;
          if (uVar14 != 0) {
            for (; uVar14 >> lVar3 == 0; lVar3 = lVar3 + -1) {
            }
          }
          uVar14 = (0xffffffffffffffffU >> (~(byte)lVar3 & 0x3f)) + 1;
        }
        auVar5._8_8_ = 0;
        auVar5._0_8_ = uVar14;
        uVar10 = SUB168(auVar5 * ZEXT816(0x30),0);
        if (((SUB168(auVar5 * ZEXT816(0x30),8) != 0) ||
            (uVar12 = uVar14 + 0x10, CARRY8(uVar10,uVar12))) ||
           (__size = uVar10 + uVar12, 0x7ffffffffffffff0 < __size)) {
          local_1c8 = 'x';
          uStack_1c7 = 0x974b;
          uStack_1c0 = 1;
          uStack_1bf = 0;
          local_1b8 = 8;
          uStack_1b4 = 0;
          auStack_1b0 = (undefined1  [16])0x0;
                    /* try { // try from 0025c65f to 0025c674 has its CatchHandler @ 0025c7e0 */
                    /* WARNING: Subroutine does not return */
          core::panicking::panic_fmt(&local_1c8,&PTR_s__rust_deps_hashbrown_0_15_3_src__00974b60);
        }
        pvVar11 = malloc(__size);
        if (pvVar11 == (void *)0x0) {
                    /* try { // try from 0025c72a to 0025c73b has its CatchHandler @ 0025c7e0 */
                    /* WARNING: Subroutine does not return */
          alloc::alloc::handle_alloc_error(0x10,__size);
        }
        pauVar15 = (undefined1 (*) [16])(uVar14 - 1);
        pauVar13 = (undefined1 (*) [16])((uVar14 & 0xfffffffffffffff8) - (uVar14 >> 3));
        if (pauVar15 < (undefined1 (*) [16])&DAT_00000008) {
          pauVar13 = pauVar15;
        }
        pauVar16 = (undefined1 (*) [16])((long)pvVar11 + uVar10);
        memset(pauVar16,0xff,uVar12);
        local_1e0 = auVar20._0_8_;
      }
      lStack_178 = 0;
      local_190 = pauVar16;
      local_188 = pauVar15;
      local_180 = pauVar13;
      local_170 = auVar20;
      while( true ) {
                    /* try { // try from 0025c1c0 to 0025c1cf has its CatchHandler @ 0025c7cc */
        alloc::collections::btree::map::IntoIter<K,V,A>::dying_next(&local_160,&local_118);
        if (local_160 == 0) break;
        lVar3 = *(long *)(local_160 + 0x168 + local_150 * 0x18);
        pauVar13 = *(undefined1 (**) [16])(local_160 + 0x170 + local_150 * 0x18);
        uVar4 = *(undefined8 *)(local_160 + 0x178 + local_150 * 0x18);
        puVar1 = (undefined8 *)(local_160 + local_150 * 0x20);
        uVar8 = *puVar1;
        uVar9 = puVar1[1];
        puVar2 = (undefined4 *)(local_160 + 0x10 + local_150 * 0x20);
        local_1b8 = *puVar2;
        uStack_1b4 = puVar2[1];
        local_1c8 = (char)uVar8;
        uStack_1c7 = (undefined7)((ulong)uVar8 >> 8);
        uStack_1c0 = (undefined1)uVar9;
        uStack_1bf = (undefined7)((ulong)uVar9 >> 8);
        auStack_1b0._0_8_ = *(undefined8 *)(puVar2 + 2);
        if (lVar3 == -0x8000000000000000) break;
        if (local_d0 != '\x06') {
                    /* try { // try from 0025c23c to 0025c243 has its CatchHandler @ 0025c7a3 */
          core::ptr::drop_in_place<serde_json::value::Value>(&local_d0);
        }
        local_c0 = local_1b8;
        uStack_bc = uStack_1b4;
        uStack_b8 = auStack_1b0._0_4_;
        uStack_b4 = auStack_1b0._4_4_;
        uStack_cf = uStack_1c7;
        uStack_c8 = uStack_1c0;
        uStack_c7 = uStack_1bf;
        local_d0 = '\x06';
        if (local_1c8 == '\x06') {
                    /* try { // try from 0025c42a to 0025c43f has its CatchHandler @ 0025c753 */
          local_1e8 = (undefined1 (*) [16])
                      _<serde_json::error::Error_as_serde_core::de::Error>::custom
                                (&DAT_007c9290,0x10);
LAB_0025c44f:
          param_1 = local_1d0;
          pauVar15 = local_188;
          lVar19 = lStack_178;
          if (lVar3 != 0) {
            free(pauVar13);
            pauVar15 = local_188;
            lVar19 = lStack_178;
          }
joined_r0x0025c477:
          local_188 = pauVar15;
          lStack_178 = lVar19;
          if (pauVar15 != (undefined1 (*) [16])0x0) {
            if (lVar19 != 0) {
              auVar20 = *local_190;
              uVar17 = ~(uint)(ushort)((ushort)(SUB161(auVar20 >> 7,0) & 1) |
                                       (ushort)(SUB161(auVar20 >> 0xf,0) & 1) << 1 |
                                       (ushort)(SUB161(auVar20 >> 0x17,0) & 1) << 2 |
                                       (ushort)(SUB161(auVar20 >> 0x1f,0) & 1) << 3 |
                                       (ushort)(SUB161(auVar20 >> 0x27,0) & 1) << 4 |
                                       (ushort)(SUB161(auVar20 >> 0x2f,0) & 1) << 5 |
                                       (ushort)(SUB161(auVar20 >> 0x37,0) & 1) << 6 |
                                       (ushort)(SUB161(auVar20 >> 0x3f,0) & 1) << 7 |
                                       (ushort)(SUB161(auVar20 >> 0x47,0) & 1) << 8 |
                                       (ushort)(SUB161(auVar20 >> 0x4f,0) & 1) << 9 |
                                       (ushort)(SUB161(auVar20 >> 0x57,0) & 1) << 10 |
                                       (ushort)(SUB161(auVar20 >> 0x5f,0) & 1) << 0xb |
                                       (ushort)(SUB161(auVar20 >> 0x67,0) & 1) << 0xc |
                                       (ushort)(SUB161(auVar20 >> 0x6f,0) & 1) << 0xd |
                                       (ushort)(SUB161(auVar20 >> 0x77,0) & 1) << 0xe |
                                      (ushort)(byte)(auVar20[0xf] >> 7) << 0xf);
              pauVar16 = local_190 + 1;
              pauVar13 = local_190;
              do {
                if ((short)uVar17 == 0) {
                  do {
                    auVar20 = *pauVar16;
                    pauVar13 = pauVar13 + -0x30;
                    pauVar16 = pauVar16 + 1;
                    uVar17 = (uint)(ushort)((ushort)(SUB161(auVar20 >> 7,0) & 1) |
                                            (ushort)(SUB161(auVar20 >> 0xf,0) & 1) << 1 |
                                            (ushort)(SUB161(auVar20 >> 0x17,0) & 1) << 2 |
                                            (ushort)(SUB161(auVar20 >> 0x1f,0) & 1) << 3 |
                                            (ushort)(SUB161(auVar20 >> 0x27,0) & 1) << 4 |
                                            (ushort)(SUB161(auVar20 >> 0x2f,0) & 1) << 5 |
                                            (ushort)(SUB161(auVar20 >> 0x37,0) & 1) << 6 |
                                            (ushort)(SUB161(auVar20 >> 0x3f,0) & 1) << 7 |
                                            (ushort)(SUB161(auVar20 >> 0x47,0) & 1) << 8 |
                                            (ushort)(SUB161(auVar20 >> 0x4f,0) & 1) << 9 |
                                            (ushort)(SUB161(auVar20 >> 0x57,0) & 1) << 10 |
                                            (ushort)(SUB161(auVar20 >> 0x5f,0) & 1) << 0xb |
                                            (ushort)(SUB161(auVar20 >> 0x67,0) & 1) << 0xc |
                                            (ushort)(SUB161(auVar20 >> 0x6f,0) & 1) << 0xd |
                                            (ushort)(SUB161(auVar20 >> 0x77,0) & 1) << 0xe |
                                           (ushort)(byte)(auVar20[0xf] >> 7) << 0xf);
                  } while (uVar17 == 0xffff);
                  uVar17 = ~uVar17;
                }
                uVar6 = 0;
                for (uVar7 = uVar17; (uVar7 & 1) == 0; uVar7 = uVar7 >> 1 | 0x80000000) {
                  uVar6 = uVar6 + 1;
                }
                uVar14 = (ulong)uVar6;
                if (*(long *)pauVar13[uVar14 * -3 + -3] != 0) {
                  free(*(void **)(pauVar13[uVar14 * -3 + -3] + 8));
                }
                if (*(long *)(pauVar13[uVar14 * -3 + -2] + 8) != 0) {
                  free(*(void **)pauVar13[uVar14 * -3 + -1]);
                }
                uVar17 = uVar17 - 1 & uVar17;
                lVar19 = lVar19 + -1;
              } while (lVar19 != 0);
            }
            param_1 = local_1d0;
            local_1e0 = pauVar15;
            if ((long)pauVar15 * 0x31 != -0x41) {
              free(local_190 + (long)pauVar15 * -3 + -3);
            }
          }
          goto LAB_0025c599;
        }
                    /* try { // try from 0025c282 to 0025c28e has its CatchHandler @ 0025c7b9 */
        serde_json::value::de::_<impl_serde_core::de::Deserializer_for_serde_json::value::Value>::
        deserialize_string(&local_160,&local_1c8);
        if (local_160 == -0x8000000000000000) {
          local_1e8 = pauStack_158;
          goto LAB_0025c44f;
        }
        local_38 = local_150;
        local_48 = local_160;
        pauStack_40 = pauStack_158;
        if (SBORROW8(0,lVar3)) break;
        local_1e8 = pauVar13;
        param_1 = local_1d0;
        pauVar15 = local_188;
        lVar19 = lStack_178;
        if (lVar3 == -0x7fffffffffffffff) goto joined_r0x0025c477;
                    /* try { // try from 0025c2fc to 0025c31a has its CatchHandler @ 0025c7cc */
        local_90 = lVar3;
        local_88 = pauVar13;
        local_80 = uVar4;
        hashbrown::map::HashMap<K,V,S,A>::insert(&local_1c8,&local_190,&local_90,&local_48);
        if ((CONCAT71(uStack_1c7,local_1c8) != -0x8000000000000000) &&
           (CONCAT71(uStack_1c7,local_1c8) != 0)) {
          free((void *)CONCAT71(uStack_1bf,uStack_1c0));
        }
      }
      param_1 = local_1d0;
      pauVar13 = (undefined1 (*) [16])local_170._0_8_;
      local_148 = local_180;
      lStack_140 = lStack_178;
      local_1e8 = local_188;
      local_1e0 = (undefined1 (*) [16])local_170._8_8_;
      if (local_190 == (undefined1 (*) [16])0x0) {
LAB_0025c599:
        local_a8 = local_148;
        lStack_a0 = lStack_140;
                    /* try { // try from 0025c5ab to 0025c5b7 has its CatchHandler @ 0025c77b */
        core::ptr::
        drop_in_place<alloc::collections::btree::map::IntoIter<alloc::string::String,serde_json::value::Value>>
                  (&local_118);
        if (local_d0 == '\x06') goto LAB_0025c615;
        pauVar15 = (undefined1 (*) [16])0x0;
LAB_0025c5c4:
                    /* try { // try from 0025c5c4 to 0025c5cb has its CatchHandler @ 0025c776 */
        core::ptr::drop_in_place<serde_json::value::Value>(&local_d0);
      }
      else {
        local_68 = local_180;
        lStack_60 = lStack_178;
        local_78 = local_190;
        local_70 = local_188;
        local_58 = local_170;
        if (local_d8 == 0) {
          local_a8 = local_180;
          lStack_a0 = lStack_178;
          pauVar15 = local_190;
        }
        else {
                    /* try { // try from 0025c6f6 to 0025c715 has its CatchHandler @ 0025c73e */
          local_1e8 = (undefined1 (*) [16])
                      serde_core::de::Error::invalid_length
                                (local_138,&PTR_s_fewer_elements_in_map_0096af48,&DAT_0096d9a0);
          _<hashbrown::raw::RawTable<T,A>as_core::ops::drop::Drop>::drop(&local_78);
          pauVar15 = (undefined1 (*) [16])0x0;
        }
                    /* try { // try from 0025c3f3 to 0025c3ff has its CatchHandler @ 0025c755 */
        core::ptr::
        drop_in_place<alloc::collections::btree::map::IntoIter<alloc::string::String,serde_json::value::Value>>
                  (&local_118);
        if (local_d0 != '\x06') goto LAB_0025c5c4;
      }
      auVar20._8_8_ = local_1e0;
      auVar20._0_8_ = pauVar13;
      ppauVar18 = &local_128;
      if (pauVar15 != (undefined1 (*) [16])0x0) {
        local_128 = local_a8;
        lStack_120 = lStack_a0;
        goto LAB_0025c5e2;
      }
    }
    else {
                    /* try { // try from 0025c67a to 0025c68d has its CatchHandler @ 0025c776 */
      local_1e8 = (undefined1 (*) [16])
                  serde_json::value::de::_<impl_serde_json::value::Value>::invalid_type
                            (param_2,&local_1d1,&DAT_009671d8);
      core::ptr::drop_in_place<serde_json::value::Value>(param_2);
    }
LAB_0025c615:
    pauVar15 = (undefined1 (*) [16])0x0;
  }
  *param_1 = pauVar15;
  param_1[1] = local_1e8;
  return;
}


