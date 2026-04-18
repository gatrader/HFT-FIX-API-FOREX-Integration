// polymarket_client_sdk::clob::client::Client::new
// entry = 0039ecd0


/* polymarket_client_sdk::clob::client::Client::new */

void __rustcall
polymarket_client_sdk::clob::client::Client::new
          (undefined8 *param_1,undefined8 param_2,ulong *param_3)

{
  undefined1 auVar1 [16];
  undefined1 auVar2 [16];
  undefined1 auVar3 [16];
  undefined8 uVar4;
  long lVar5;
  undefined1 uVar6;
  int iVar7;
  undefined1 *puVar8;
  long lVar9;
  ulong uVar10;
  void *pvVar11;
  ulong uVar12;
  ulong uVar13;
  ulong uVar14;
  undefined **ppuVar16;
  byte bVar17;
  byte bVar18;
  undefined8 uVar19;
  long lVar20;
  long lVar21;
  undefined8 uVar22;
  undefined8 uVar23;
  undefined1 *puVar24;
  undefined8 *puVar25;
  long lVar26;
  char *pcVar27;
  ulong unaff_R12;
  ulong uVar28;
  byte *pbVar29;
  undefined *puVar30;
  undefined1 *puVar31;
  ulong uVar32;
  ulong uVar33;
  byte *pbVar34;
  long in_FS_OFFSET;
  bool bVar35;
  undefined1 auVar36 [16];
  undefined1 auVar37 [16];
  undefined **local_a48;
  undefined1 *local_a40;
  undefined8 local_a38;
  undefined8 uStack_a30;
  undefined4 local_a28;
  undefined4 uStack_a24;
  undefined4 uStack_a20;
  undefined4 uStack_a1c;
  ulong local_a08;
  ulong local_a00;
  void *local_9f8;
  char *local_9f0;
  undefined1 *local_9e8;
  undefined8 *local_9e0;
  ulong local_9d8;
  undefined8 local_9d0;
  long local_9c8;
  long local_9c0;
  ulong local_9b8;
  undefined1 *local_9b0;
  undefined8 local_9a8;
  undefined8 uStack_9a0;
  undefined8 local_998;
  ulong uStack_990;
  long local_988;
  ulong uStack_980;
  undefined8 local_978;
  long lStack_970;
  ulong local_968;
  undefined8 uStack_960;
  undefined8 local_958;
  undefined8 uStack_950;
  undefined4 local_948;
  undefined4 uStack_944;
  undefined4 uStack_940;
  undefined4 uStack_93c;
  void **local_930;
  long local_928;
  undefined8 local_920;
  long local_918;
  long local_910;
  long local_908;
  undefined8 local_900;
  undefined8 local_8f8;
  undefined8 uStack_8f0;
  undefined8 local_8e8;
  undefined8 uStack_8e0;
  undefined8 local_8d8;
  undefined8 uStack_8d0;
  undefined8 local_8c8;
  undefined8 uStack_8c0;
  undefined8 local_8b8;
  undefined8 local_8a8 [2];
  undefined8 local_898;
  undefined8 uStack_890;
  long local_888;
  ulong uStack_880;
  undefined8 uStack_878;
  long lStack_870;
  ulong local_868;
  undefined8 uStack_860;
  undefined8 local_858;
  undefined2 uStack_850;
  undefined6 uStack_84e;
  undefined8 local_848;
  undefined8 uStack_840;
  undefined8 local_838;
  undefined8 uStack_830;
  undefined8 local_828;
  undefined8 uStack_820;
  undefined8 local_818;
  ulong uStack_810;
  undefined8 local_808;
  undefined8 uStack_800;
  undefined8 local_7f8;
  undefined8 uStack_7f0;
  undefined8 local_7e8;
  undefined1 *local_7e0;
  void *local_7d8;
  undefined4 local_7d0;
  undefined4 uStack_7cc;
  undefined4 uStack_7c8;
  undefined4 uStack_7c4;
  undefined4 local_7c0;
  undefined4 uStack_7bc;
  undefined4 uStack_7b8;
  undefined4 uStack_7b4;
  undefined4 local_7b0;
  undefined4 uStack_7ac;
  undefined4 uStack_7a8;
  undefined4 uStack_7a4;
  undefined4 local_7a0;
  undefined4 uStack_79c;
  undefined4 uStack_798;
  undefined4 uStack_794;
  undefined8 local_790;
  ulong local_788;
  char *local_780;
  undefined8 local_778;
  undefined8 uStack_770;
  long *local_768;
  undefined1 *local_760;
  undefined8 local_758;
  long local_750;
  long local_748;
  undefined8 local_740;
  undefined1 *local_738;
  undefined8 local_730;
  long local_728;
  long local_720;
  undefined8 local_718;
  undefined1 *local_710;
  undefined8 local_708;
  long local_700;
  long local_6f8;
  undefined8 local_6f0;
  code *local_6e8;
  undefined1 local_6e0;
  undefined1 local_6cb;
  undefined8 local_450 [2];
  undefined8 local_440;
  undefined8 local_430;
  undefined4 local_428;
  undefined4 uStack_424;
  undefined4 uStack_420;
  undefined4 uStack_41c;
  undefined4 local_418;
  undefined4 uStack_414;
  undefined4 uStack_410;
  undefined4 uStack_40c;
  undefined4 local_408;
  undefined4 uStack_404;
  undefined4 uStack_400;
  undefined4 uStack_3fc;
  undefined4 local_3f8;
  undefined4 uStack_3f4;
  undefined4 uStack_3f0;
  undefined4 uStack_3ec;
  undefined8 local_3e8;
  long *plVar15;
  
  uStack_850 = 0;
  uStack_860 = 2;
  local_858 = 0;
  uStack_890 = 0;
  local_888 = 8;
  uStack_880 = 0;
  uStack_878 = 0;
  lStack_870 = 8;
  local_868 = 0;
  local_8a8[0] = 0;
  uStack_840 = &PTR_static_clone_00977d78;
  local_838 = "rs_clob_client";
  uStack_830 = 0xe;
  local_828 = 0;
  uStack_820 = uStack_820 & 0xffffffffffffff00;
                    /* try { // try from 0039eda7 to 0039f088 has its CatchHandler @ 003a0867 */
  local_9e0 = param_1;
  local_848 = (undefined **)local_8a8;
  http::header::name::HdrName::from_static(&local_428,"User-Agent",10,&local_848);
  if ((char)local_408 != '\x03') {
    local_838 = (char *)CONCAT44(uStack_414,local_418);
    local_848 = (undefined **)CONCAT44(uStack_424,local_428);
    uStack_840 = (undefined **)CONCAT44(uStack_41c,uStack_420);
    if ((char)local_408 != '\x02') {
      (**(code **)((long)local_848 + 0x20))(&uStack_830,uStack_840,local_838);
    }
    uStack_840 = &PTR_static_clone_00977d78;
    local_838 = "*/*";
    uStack_830 = 3;
    local_828 = 0;
    uStack_820 = uStack_820 & 0xffffffffffffff00;
    local_848 = (undefined **)local_8a8;
    http::header::name::HdrName::from_static(&local_428,"Accept",6,&local_848);
    if ((char)local_408 != '\x03') {
      local_838 = (char *)CONCAT44(uStack_414,local_418);
      local_848 = (undefined **)CONCAT44(uStack_424,local_428);
      uStack_840 = (undefined **)CONCAT44(uStack_41c,uStack_420);
      if ((char)local_408 != '\x02') {
        (**(code **)((long)local_848 + 0x20))(&uStack_830,uStack_840,local_838);
      }
      uStack_840 = &PTR_static_clone_00977d78;
      local_838 = &DAT_0083884f;
      uStack_830 = 10;
      local_828 = 0;
      uStack_820 = uStack_820 & 0xffffffffffffff00;
      local_848 = (undefined **)local_8a8;
      http::header::name::HdrName::from_static(&local_428,"Connection",10,&local_848);
      if ((char)local_408 != '\x03') {
        local_838 = (char *)CONCAT44(uStack_414,local_418);
        local_848 = (undefined **)CONCAT44(uStack_424,local_428);
        uStack_840 = (undefined **)CONCAT44(uStack_41c,uStack_420);
        if ((char)local_408 != '\x02') {
          (**(code **)((long)local_848 + 0x20))(&uStack_830,uStack_840,local_838);
        }
        uStack_840 = &PTR_static_clone_00977d78;
        local_838 = "application/jsonconnection error\x01\x01";
        uStack_830 = 0x10;
        local_828 = 0;
        uStack_820 = uStack_820 & 0xffffffffffffff00;
        local_848 = (undefined **)local_8a8;
        http::header::name::HdrName::from_static(&local_428,"Content-Type",0xc,&local_848);
        if ((char)local_408 != '\x03') {
          local_828 = CONCAT44(uStack_404,local_408);
          local_838 = (char *)CONCAT44(uStack_414,local_418);
          uStack_830 = CONCAT44(uStack_40c,uStack_410);
          local_848 = (undefined **)CONCAT44(uStack_424,local_428);
          uStack_840 = (undefined **)CONCAT44(uStack_41c,uStack_420);
          if ((char)local_408 != '\x02') {
            (**(code **)((long)local_848 + 0x20))(&uStack_830,uStack_840,local_838);
          }
          reqwest::async_impl::client::Client::builder(&local_848);
          local_988 = local_888;
          uStack_980 = uStack_880;
          uStack_950 = CONCAT62(uStack_84e,uStack_850);
          local_958 = local_858;
          local_968 = local_868;
          uStack_960 = uStack_860;
          local_978 = uStack_878;
          lStack_970 = lStack_870;
          local_998 = local_898;
          uStack_990 = uStack_890;
          local_9a8 = local_8a8[0];
          bVar18 = (uStack_880 == 0) * '\x02';
          uVar32 = 0;
          local_a48 = &PTR_s__usr_local_cargo_registry_src_in_0097d470;
          do {
            if (bVar18 == 2) {
              uVar32 = uVar32 + 1;
              if (uStack_980 <= uVar32) {
                memcpy(&local_428,&local_848,0x3f8);
                    /* try { // try from 0039f2a1 to 0039f2d9 has its CatchHandler @ 003a07f9 */
                core::ptr::drop_in_place<http::header::map::HeaderMap>(&local_9a8);
                auVar36 = reqwest::async_impl::client::ClientBuilder::build(&local_428);
                plVar15 = auVar36._8_8_;
                if ((auVar36._0_8_ & 1) == 0) {
                  uVar32 = *param_3;
                  uVar12 = 0x16;
                  if (!SBORROW8(0,uVar32)) {
                    uVar12 = param_3[2];
                  }
                  local_9f0 = (char *)param_3[1];
                  pcVar27 = "https://polymarket.com";
                  if (!SBORROW8(0,uVar32)) {
                    pcVar27 = local_9f0;
                  }
                  local_430 = 0;
                  local_450[0] = 0;
                  local_440 = 0;
                    /* try { // try from 0039f381 to 0039f395 has its CatchHandler @ 003a0851 */
                  url::ParseOptions::parse(&local_848,local_450,pcVar27,uVar12);
                  uVar6 = (undefined1)uStack_840;
                  local_9e8 = (undefined1 *)local_848;
                  if (local_848 == (undefined **)0x8000000000000000) {
                    puVar8 = malloc(1);
                    if (puVar8 == (undefined1 *)0x0) {
                    /* try { // try from 003a049a to 003a04a8 has its CatchHandler @ 003a0851 */
                    /* WARNING: Subroutine does not return */
                      alloc::alloc::handle_alloc_error(1,1);
                    }
                    *puVar8 = uVar6;
                    /* try { // try from 0039f3e7 to 0039f3f3 has its CatchHandler @ 003a07ae */
                    std::backtrace::Backtrace::capture(&local_848);
                    local_9e0[4] = local_828;
                    local_9e0[5] = uStack_820;
                    local_9e0[2] = local_838;
                    local_9e0[3] = uStack_830;
                    *(undefined4 *)local_9e0 = (undefined4)local_848;
                    *(undefined4 *)((long)local_9e0 + 4) = local_848._4_4_;
                    *(undefined4 *)(local_9e0 + 1) = (undefined4)uStack_840;
                    *(undefined4 *)((long)local_9e0 + 0xc) = uStack_840._4_4_;
                    local_9e0[6] = puVar8;
                    local_9e0[7] = &DAT_00977b48;
                    *(undefined1 *)(local_9e0 + 8) = 3;
                    bVar17 = 1;
                    bVar18 = 1;
                    LOCK();
                    *plVar15 = *plVar15 + -1;
                    lVar21 = *plVar15;
                    UNLOCK();
                  }
                  else {
                    local_9f8 = (void *)(((ulong)uStack_840 >> 8 & 0xffffffff) << 8 |
                                         (ulong)uStack_840 & 0xffffff0000000000 |
                                        (ulong)uStack_840 & 0xff);
                    local_8f8 = local_838;
                    uStack_8f0 = uStack_830;
                    local_8e8 = local_828;
                    uStack_8e0 = uStack_820;
                    local_8d8 = local_818;
                    uStack_8d0 = uStack_810;
                    local_8c8 = local_808;
                    uStack_8c0 = uStack_800;
                    local_8b8 = local_7f8;
                    local_948 = (undefined4)param_3[2];
                    uStack_944 = *(undefined4 *)((long)param_3 + 0x14);
                    uStack_940 = (undefined4)param_3[3];
                    uStack_93c = *(undefined4 *)((long)param_3 + 0x1c);
                    /* try { // try from 0039f4dd to 0039f4fb has its CatchHandler @ 003a07d0 */
                    url::ParseOptions::parse(&local_848,local_450,param_2,0x1b);
                    uVar6 = (undefined1)uStack_840;
                    local_9b0 = (undefined1 *)local_848;
                    if (local_848 != (undefined **)0x8000000000000000) {
                      local_9b8 = ((ulong)uStack_840 >> 8 & 0xffffffff) << 8 |
                                  (ulong)uStack_840 & 0xffffff0000000000 | (ulong)uStack_840 & 0xff;
                      local_9a8 = local_838;
                      uStack_9a0 = uStack_830;
                      local_998 = local_828;
                      uStack_990 = uStack_820;
                      local_988 = local_818;
                      uStack_980 = uStack_810;
                      local_978 = local_808;
                      lStack_970 = uStack_800;
                      local_968 = local_7f8;
                      local_3e8 = local_8b8;
                      local_3f8 = (undefined4)local_8c8;
                      uStack_3f4 = local_8c8._4_4_;
                      uStack_3f0 = (undefined4)uStack_8c0;
                      uStack_3ec = uStack_8c0._4_4_;
                      local_408 = (undefined4)local_8d8;
                      uStack_404 = local_8d8._4_4_;
                      uStack_400 = (undefined4)uStack_8d0;
                      uStack_3fc = uStack_8d0._4_4_;
                      local_418 = (undefined4)local_8e8;
                      uStack_414 = local_8e8._4_4_;
                      uStack_410 = (undefined4)uStack_8e0;
                      uStack_40c = uStack_8e0._4_4_;
                      local_428 = (undefined4)local_8f8;
                      uStack_424 = local_8f8._4_4_;
                      uStack_420 = (undefined4)uStack_8f0;
                      uStack_41c = uStack_8f0._4_4_;
                      if (*(char *)(in_FS_OFFSET + -0x18) == '\x01') {
                        auVar36 = *(undefined1 (*) [16])(in_FS_OFFSET + -0x10);
                      }
                      else {
                        auVar36 = std::sys::random::linux::hashmap_random_keys();
                        *(undefined1 *)(in_FS_OFFSET + -0x18) = 1;
                        *(undefined1 (*) [16])(in_FS_OFFSET + -0x10) = auVar36;
                      }
                      uVar19 = auVar36._8_8_;
                      *(long *)(in_FS_OFFSET + -0x10) = auVar36._0_8_ + 1;
                      if (dashmap::default_shard_amount::DEFAULT_SHARD_AMOUNT._16_8_ != 2) {
                    /* try { // try from 003a04c2 to 003a0523 has its CatchHandler @ 003a0844 */
                        once_cell::imp::OnceCell<T>::initialize();
                      }
                      uVar4 = dashmap::default_shard_amount::DEFAULT_SHARD_AMOUNT._8_8_;
                      if ((ulong)dashmap::default_shard_amount::DEFAULT_SHARD_AMOUNT._8_8_ < 2) {
                        ppuVar16 = &PTR_s__usr_local_cargo_registry_src_in_00977ed8;
                        uVar19 = 0x22;
                        pcVar27 = "assertion failed: shard_amount > 1";
                      }
                      else {
                        local_900 = uVar19;
                        if ((dashmap::default_shard_amount::DEFAULT_SHARD_AMOUNT._8_8_ &
                            dashmap::default_shard_amount::DEFAULT_SHARD_AMOUNT._8_8_ - 1) == 0) {
                          local_a00 = 0;
                          uVar12 = dashmap::default_shard_amount::DEFAULT_SHARD_AMOUNT._8_8_ << 7;
                          uVar19 = 0;
                          if (((ulong)dashmap::default_shard_amount::DEFAULT_SHARD_AMOUNT._8_8_ >>
                               0x39 == 0) &&
                             (local_9d8 = 0x7fffffffffffff80, uVar12 < 0x7fffffffffffff81)) {
                            local_848 = (undefined **)0x0;
                            uVar19 = 0x80;
                            iVar7 = posix_memalign((void **)&local_848,0x80,uVar12);
                            uVar14 = local_a00;
                            if ((iVar7 == 0) && (local_848 != (undefined **)0x0)) {
                              local_a08 = 0;
                              for (uVar13 = uVar4; (uVar13 & 1) == 0;
                                  uVar13 = uVar13 >> 1 | 0x8000000000000000) {
                                local_a08 = local_a08 + 1;
                              }
                              local_a38 = (undefined1 *)uVar4;
                              uStack_a30 = (undefined1 *)local_848;
                              uVar13 = (local_a00 * 8) / 7 - 1;
                              lVar21 = 0x3f;
                              if (uVar13 != 0) {
                                for (; uVar13 >> lVar21 == 0; lVar21 = lVar21 + -1) {
                                }
                              }
                              bVar35 = 3 < local_a00;
                              puVar25 = (undefined8 *)((long)local_848 + 0x20);
                              lVar9 = 0;
                              local_9c0 = auVar36._0_8_;
                              do {
                                if (uVar14 == 0) {
                                  lVar26 = 0;
                                  lVar20 = 0;
                                  puVar30 = &DAT_007c8640;
                                }
                                else {
                                  uVar13 = (0xffffffffffffffffU >> (~(byte)lVar21 & 0x3f)) + 1;
                                  if (uVar14 < 8) {
                                    uVar13 = (ulong)bVar35 * 4 + 4;
                                  }
                                  if (((0x1fffffffffffffff < uVar14) ||
                                      (auVar36._8_8_ = 0, auVar36._0_8_ = uVar13,
                                      uVar10 = SUB168(auVar36 * ZEXT816(0x28),0),
                                      SUB168(auVar36 * ZEXT816(0x28),8) != 0)) ||
                                     (0xfffffffffffffff0 < uVar10)) {
LAB_003a03a5:
                                    local_848 = &PTR_s_Hash_table_capacity_overflow_00974b78;
                    /* try { // try from 003a03cb to 003a03db has its CatchHandler @ 003a08cc */
                    /* WARNING: Subroutine does not return */
                                    core::panicking::panic_fmt
                                              (&local_848,
                                               &PTR_s__usr_local_cargo_registry_src_in_00974b88);
                                  }
                                  uVar33 = uVar10 + 0xf & 0xfffffffffffffff0;
                                  uVar10 = uVar13 + 0x10;
                                  uVar28 = uVar33 + uVar10;
                                  if ((CARRY8(uVar33,uVar10)) || (0x7ffffffffffffff0 < uVar28))
                                  goto LAB_003a03a5;
                                  pvVar11 = malloc(uVar28);
                                  if (pvVar11 == (void *)0x0) {
                    /* try { // try from 003a0639 to 003a064e has its CatchHandler @ 003a08cc */
                    /* WARNING: Subroutine does not return */
                                    alloc::alloc::handle_alloc_error(0x10,uVar28);
                                  }
                                  lVar20 = uVar13 - 1;
                                  lVar26 = (uVar13 & 0xfffffffffffffff8) - (uVar13 >> 3);
                                  if (uVar13 < 9) {
                                    lVar26 = lVar20;
                                  }
                                  puVar30 = (undefined *)((long)pvVar11 + uVar33);
                                  memset(puVar30,0xff,uVar10);
                                }
                                puVar8 = uStack_a30;
                                lVar9 = lVar9 + 1;
                                puVar25[-4] = 0;
                                puVar25[-3] = puVar30;
                                puVar25[-2] = lVar20;
                                puVar25[-1] = lVar26;
                                *puVar25 = 0;
                                puVar25 = puVar25 + 0x10;
                              } while (uVar4 != lVar9);
                              local_848 = (undefined **)local_a38;
                              uStack_840 = (undefined **)uStack_a30;
                              local_838 = (char *)uVar4;
                              puVar31 = uStack_a30;
                              if ((ulong)uVar4 < local_a38) {
                                if (uVar4 == 0) {
                                  puVar31 = &DAT_00000080;
                                }
                                else {
                                  local_a38 = (undefined1 *)0x0;
                                  iVar7 = posix_memalign((void **)&local_a38,0x80,uVar12);
                                  puVar31 = local_a38;
                                  if ((iVar7 != 0) || (local_a38 == (undefined1 *)0x0)) {
                    /* try { // try from 003a06e8 to 003a06fb has its CatchHandler @ 003a077c */
                    /* WARNING: Subroutine does not return */
                                    alloc::raw_vec::handle_error(0x80,uVar12,&PTR_DAT_00984e08);
                                  }
                                  memcpy(local_a38,puVar8,uVar12);
                                }
                                free(puVar8);
                              }
                              if (*(char *)(in_FS_OFFSET + -0x18) == '\x01') {
                                auVar36 = *(undefined1 (*) [16])(in_FS_OFFSET + -0x10);
                              }
                              else {
                                auVar36 = std::sys::random::linux::hashmap_random_keys();
                                *(undefined1 *)(in_FS_OFFSET + -0x18) = 1;
                                *(undefined1 (*) [16])(in_FS_OFFSET + -0x10) = auVar36;
                              }
                              local_9d0 = auVar36._8_8_;
                              lVar21 = auVar36._0_8_;
                              *(long *)(in_FS_OFFSET + -0x10) = lVar21 + 1;
                              if (dashmap::default_shard_amount::DEFAULT_SHARD_AMOUNT._16_8_ != 2) {
                    /* try { // try from 003a0529 to 003a0597 has its CatchHandler @ 003a083a */
                                once_cell::imp::OnceCell<T>::initialize();
                              }
                              uVar19 = dashmap::default_shard_amount::DEFAULT_SHARD_AMOUNT._8_8_;
                              if ((ulong)dashmap::default_shard_amount::DEFAULT_SHARD_AMOUNT._8_8_ <
                                  2) {
                                ppuVar16 = &PTR_s__usr_local_cargo_registry_src_in_00977ed8;
                                uVar19 = 0x22;
                                pcVar27 = "assertion failed: shard_amount > 1";
                              }
                              else {
                                local_908 = lVar21;
                                if ((dashmap::default_shard_amount::DEFAULT_SHARD_AMOUNT._8_8_ &
                                    dashmap::default_shard_amount::DEFAULT_SHARD_AMOUNT._8_8_ - 1)
                                    == 0) {
                                  local_a00 = 0;
                                  uVar12 = dashmap::default_shard_amount::DEFAULT_SHARD_AMOUNT._8_8_
                                           << 7;
                                  uVar22 = 0;
                                  if (((ulong)dashmap::default_shard_amount::DEFAULT_SHARD_AMOUNT.
                                              _8_8_ < 0x200000000000000) && (uVar12 <= local_9d8)) {
                                    local_848 = (undefined **)0x0;
                                    uVar22 = 0x80;
                                    iVar7 = posix_memalign((void **)&local_848,0x80,uVar12);
                                    if ((iVar7 == 0) && (local_848 != (undefined **)0x0)) {
                                      local_910 = 0x40 - local_a08;
                                      local_9c8 = 0;
                                      for (uVar14 = uVar19; (uVar14 & 1) == 0;
                                          uVar14 = uVar14 >> 1 | 0x8000000000000000) {
                                        local_9c8 = local_9c8 + 1;
                                      }
                                      local_a38 = (undefined1 *)uVar19;
                                      uStack_a30 = (undefined1 *)local_848;
                                      uVar14 = (local_a00 * 8) / 7 - 1;
                                      lVar21 = 0x3f;
                                      if (uVar14 != 0) {
                                        for (; uVar14 >> lVar21 == 0; lVar21 = lVar21 + -1) {
                                        }
                                      }
                                      bVar35 = 3 < local_a00;
                                      puVar25 = (undefined8 *)((long)local_848 + 0x20);
                                      lVar9 = 0;
                                      local_a08 = local_a00;
                                      uVar14 = local_a00;
                                      do {
                                        if (uVar14 == 0) {
                                          lVar26 = 0;
                                          lVar20 = 0;
                                          puVar30 = &DAT_007c8640;
                                        }
                                        else {
                                          uVar13 = (0xffffffffffffffffU >> (~(byte)lVar21 & 0x3f)) +
                                                   1;
                                          if (uVar14 < 8) {
                                            uVar13 = (ulong)bVar35 * 4 + 4;
                                          }
                                          if (((0x1fffffffffffffff < uVar14) ||
                                              (auVar1._8_8_ = 0, auVar1._0_8_ = uVar13,
                                              uVar14 = SUB168(auVar1 * ZEXT816(0x28),0),
                                              SUB168(auVar1 * ZEXT816(0x28),8) != 0)) ||
                                             (0xfffffffffffffff0 < uVar14)) {
LAB_003a03e5:
                                            local_848 = &PTR_s_Hash_table_capacity_overflow_00974b78
                                            ;
                                            uStack_840 = (undefined **)0x1;
                                            local_838 = (char *)0x8;
                    /* try { // try from 003a040b to 003a0420 has its CatchHandler @ 003a08a8 */
                    /* WARNING: Subroutine does not return */
                                            core::panicking::panic_fmt
                                                      (&local_848,
                                                       &
                                                  PTR_s__usr_local_cargo_registry_src_in_00974b88);
                                          }
                                          uVar28 = uVar14 + 0xf & 0xfffffffffffffff0;
                                          uVar14 = uVar13 + 0x10;
                                          uVar10 = uVar28 + uVar14;
                                          if ((CARRY8(uVar28,uVar14)) ||
                                             (0x7ffffffffffffff0 < uVar10)) goto LAB_003a03e5;
                                          pvVar11 = malloc(uVar10);
                                          if (pvVar11 == (void *)0x0) {
                    /* try { // try from 003a0654 to 003a0673 has its CatchHandler @ 003a08a8 */
                    /* WARNING: Subroutine does not return */
                                            alloc::alloc::handle_alloc_error(0x10,uVar10);
                                          }
                                          lVar20 = uVar13 - 1;
                                          lVar26 = (uVar13 & 0xfffffffffffffff8) - (uVar13 >> 3);
                                          if (uVar13 < 9) {
                                            lVar26 = lVar20;
                                          }
                                          puVar30 = (undefined *)((long)pvVar11 + uVar28);
                                          memset(puVar30,0xff,uVar14);
                                          uVar14 = local_a08;
                                        }
                                        puVar8 = uStack_a30;
                                        lVar9 = lVar9 + 1;
                                        puVar25[-4] = 0;
                                        puVar25[-3] = puVar30;
                                        puVar25[-2] = lVar20;
                                        puVar25[-1] = lVar26;
                                        *puVar25 = 0;
                                        puVar25 = puVar25 + 0x10;
                                      } while (uVar19 != lVar9);
                                      local_848 = (undefined **)local_a38;
                                      uStack_840 = (undefined **)uStack_a30;
                                      local_838 = (char *)uVar19;
                                      local_a40 = (undefined1 *)uStack_840;
                                      if ((ulong)uVar19 < local_a38) {
                                        if (uVar19 == 0) {
                                          local_a40 = &DAT_00000080;
                                        }
                                        else {
                                          local_a38 = (undefined1 *)0x0;
                                          iVar7 = posix_memalign((void **)&local_a38,0x80,uVar12);
                                          if ((iVar7 != 0) || (local_a38 == (undefined1 *)0x0)) {
                    /* try { // try from 003a06fe to 003a0711 has its CatchHandler @ 003a0754 */
                    /* WARNING: Subroutine does not return */
                                            alloc::raw_vec::handle_error
                                                      (0x80,uVar12,&PTR_DAT_00984e08);
                                          }
                                          local_a40 = local_a38;
                                          memcpy(local_a38,puVar8,uVar12);
                                        }
                                        free(puVar8);
                                      }
                                      if (*(char *)(in_FS_OFFSET + -0x18) == '\x01') {
                                        auVar37 = *(undefined1 (*) [16])(in_FS_OFFSET + -0x10);
                                      }
                                      else {
                                        auVar37 = std::sys::random::linux::hashmap_random_keys();
                                        *(undefined1 *)(in_FS_OFFSET + -0x18) = 1;
                                        *(undefined1 (*) [16])(in_FS_OFFSET + -0x10) = auVar37;
                                      }
                                      *(long *)(in_FS_OFFSET + -0x10) = auVar37._0_8_ + 1;
                                      if (dashmap::default_shard_amount::DEFAULT_SHARD_AMOUNT._16_8_
                                          != 2) {
                    /* try { // try from 003a059d to 003a05fe has its CatchHandler @ 003a082b */
                                        once_cell::imp::OnceCell<T>::initialize();
                                      }
                                      uVar22 = dashmap::default_shard_amount::DEFAULT_SHARD_AMOUNT.
                                               _8_8_;
                                      if ((ulong)dashmap::default_shard_amount::DEFAULT_SHARD_AMOUNT
                                                 ._8_8_ < 2) {
                                        ppuVar16 = &PTR_s__usr_local_cargo_registry_src_in_00977ed8;
                                        uVar19 = 0x22;
                                        pcVar27 = "assertion failed: shard_amount > 1";
                                      }
                                      else {
                                        if ((dashmap::default_shard_amount::DEFAULT_SHARD_AMOUNT.
                                             _8_8_ & dashmap::default_shard_amount::
                                                     DEFAULT_SHARD_AMOUNT._8_8_ - 1) == 0) {
                                          local_a00 = 0;
                                          uVar12 = dashmap::default_shard_amount::
                                                   DEFAULT_SHARD_AMOUNT._8_8_ << 7;
                                          uVar23 = 0;
                                          if (((ulong)dashmap::default_shard_amount::
                                                      DEFAULT_SHARD_AMOUNT._8_8_ < 0x200000000000000
                                              ) && (uVar12 <= local_9d8)) {
                                            local_848 = (undefined **)0x0;
                                            local_930 = (void **)&local_848;
                                            uVar23 = 0x80;
                                            local_920 = auVar37._8_8_;
                                            local_918 = auVar37._0_8_;
                                            iVar7 = posix_memalign(local_930,0x80,uVar12);
                                            auVar37._8_8_ = local_920;
                                            auVar37._0_8_ = local_918;
                                            auVar3._8_8_ = local_920;
                                            auVar3._0_8_ = local_918;
                                            if ((iVar7 == 0) &&
                                               (auVar37 = auVar3, local_848 != (undefined **)0x0)) {
                                              local_9c8 = 0x40 - local_9c8;
                                              local_928 = 0;
                                              for (uVar14 = uVar22; (uVar14 & 1) == 0;
                                                  uVar14 = uVar14 >> 1 | 0x8000000000000000) {
                                                local_928 = local_928 + 1;
                                              }
                                              local_a38 = (undefined1 *)uVar22;
                                              uStack_a30 = (undefined1 *)local_848;
                                              uVar14 = (local_a00 * 8) / 7 - 1;
                                              lVar21 = 0x3f;
                                              if (uVar14 != 0) {
                                                for (; uVar14 >> lVar21 == 0; lVar21 = lVar21 + -1)
                                                {
                                                }
                                              }
                                              local_a08 = (ulong)(3 < local_a00) * 4 + 4;
                                              puVar25 = (undefined8 *)((long)local_848 + 0x20);
                                              lVar9 = 0;
                                              local_9d8 = local_a00;
                                              uVar14 = local_a00;
                                              do {
                                                if (uVar14 == 0) {
                                                  lVar26 = 0;
                                                  lVar20 = 0;
                                                  puVar30 = &DAT_007c8640;
                                                }
                                                else {
                                                  uVar13 = (0xffffffffffffffffU >>
                                                           (~(byte)lVar21 & 0x3f)) + 1;
                                                  if (uVar14 < 8) {
                                                    uVar13 = local_a08;
                                                  }
                                                  if (((0x1fffffffffffffff < uVar14) ||
                                                      (auVar2._8_8_ = 0, auVar2._0_8_ = uVar13,
                                                      uVar14 = SUB168(auVar2 * ZEXT816(0x28),0),
                                                      SUB168(auVar2 * ZEXT816(0x28),8) != 0)) ||
                                                     (0xfffffffffffffff0 < uVar14)) {
LAB_003a042a:
                                                    *local_930 = &
                                                  PTR_s_Hash_table_capacity_overflow_00974b78;
                                                  local_930[1] = &DAT_00000001;
                                                  local_930[2] = &DAT_00000008;
                                                  local_930[3] = (void *)0x0;
                                                  local_930[4] = (void *)0x0;
                    /* try { // try from 003a0453 to 003a0468 has its CatchHandler @ 003a0880 */
                    /* WARNING: Subroutine does not return */
                                                  core::panicking::panic_fmt
                                                            (local_930,
                                                             &
                                                  PTR_s__usr_local_cargo_registry_src_in_00974b88);
                                                  }
                                                  uVar28 = uVar14 + 0xf & 0xfffffffffffffff0;
                                                  uVar14 = uVar13 + 0x10;
                                                  uVar10 = uVar28 + uVar14;
                                                  if ((CARRY8(uVar28,uVar14)) ||
                                                     (0x7ffffffffffffff0 < uVar10))
                                                  goto LAB_003a042a;
                                                  pvVar11 = malloc(uVar10);
                                                  if (pvVar11 == (void *)0x0) {
                    /* try { // try from 003a0679 to 003a0698 has its CatchHandler @ 003a0880 */
                    /* WARNING: Subroutine does not return */
                                                    alloc::alloc::handle_alloc_error(0x10,uVar10);
                                                  }
                                                  lVar20 = uVar13 - 1;
                                                  lVar26 = (uVar13 & 0xfffffffffffffff8) -
                                                           (uVar13 >> 3);
                                                  if (uVar13 < 9) {
                                                    lVar26 = lVar20;
                                                  }
                                                  puVar30 = (undefined *)((long)pvVar11 + uVar28);
                                                  memset(puVar30,0xff,uVar14);
                                                  uVar14 = local_9d8;
                                                }
                                                lVar5 = local_9c0;
                                                puVar8 = uStack_a30;
                                                lVar9 = lVar9 + 1;
                                                puVar25[-4] = 0;
                                                puVar25[-3] = puVar30;
                                                puVar25[-2] = lVar20;
                                                puVar25[-1] = lVar26;
                                                *puVar25 = 0;
                                                puVar25 = puVar25 + 0x10;
                                                if (uVar22 == lVar9) {
                                                  local_848 = (undefined **)local_a38;
                                                  uStack_840 = (undefined **)uStack_a30;
                                                  local_710 = uStack_a30;
                                                  if ((ulong)uVar22 < local_a38) {
                                                    local_838 = (char *)uVar22;
                                                    if (uVar22 == 0) {
                                                      puVar24 = &DAT_00000080;
                                                    }
                                                    else {
                                                      local_a38 = (undefined1 *)0x0;
                                                      iVar7 = posix_memalign((void **)&local_a38,
                                                                             0x80,uVar12);
                                                      puVar24 = local_a38;
                                                      if ((iVar7 != 0) ||
                                                         (local_a38 == (undefined1 *)0x0)) {
                    /* try { // try from 003a0714 to 003a0729 has its CatchHandler @ 003a072c */
                    /* WARNING: Subroutine does not return */
                                                        alloc::raw_vec::handle_error
                                                                  (0x80,uVar12,&PTR_DAT_00984e08);
                                                      }
                                                      memcpy(local_a38,puVar8,uVar12);
                                                    }
                                                    free(puVar8);
                                                    local_710 = puVar24;
                                                  }
                                                  local_700 = 0x40 - local_928;
                                                  local_778 = CONCAT44(uStack_944,local_948);
                                                  uStack_770 = CONCAT44(uStack_93c,uStack_940);
                                                  local_7e8 = local_968;
                                                  local_828 = local_9a8;
                                                  uStack_820 = uStack_9a0;
                                                  local_818 = local_998;
                                                  uStack_810 = uStack_990;
                                                  local_808 = local_988;
                                                  uStack_800 = uStack_980;
                                                  local_7f8 = local_978;
                                                  uStack_7f0 = lStack_970;
                                                  local_790 = local_3e8;
                                                  local_7d0 = local_428;
                                                  uStack_7cc = uStack_424;
                                                  uStack_7c8 = uStack_420;
                                                  uStack_7c4 = uStack_41c;
                                                  local_7c0 = local_418;
                                                  uStack_7bc = uStack_414;
                                                  uStack_7b8 = uStack_410;
                                                  uStack_7b4 = uStack_40c;
                                                  local_7b0 = local_408;
                                                  uStack_7ac = uStack_404;
                                                  uStack_7a8 = uStack_400;
                                                  uStack_7a4 = uStack_3fc;
                                                  local_7a0 = local_3f8;
                                                  uStack_79c = uStack_3f4;
                                                  uStack_798 = uStack_3f0;
                                                  uStack_794 = uStack_3ec;
                                                  local_758 = uVar4;
                                                  local_750 = local_910;
                                                  local_748 = lVar5;
                                                  local_740 = local_900;
                                                  local_738 = local_a40;
                                                  local_730 = uVar19;
                                                  local_728 = local_9c8;
                                                  local_720 = local_908;
                                                  local_718 = local_9d0;
                                                  local_6f8 = local_918;
                                                  local_6f0 = local_920;
                                                  local_848 = (undefined **)&DAT_00000001;
                                                  uStack_840 = (undefined **)0x1;
                                                  local_838 = local_9b0;
                                                  uStack_830 = local_9b8;
                                                  local_7e0 = local_9e8;
                                                  local_7d8 = local_9f8;
                                                  local_780 = local_9f0;
                                                  local_6e8 = order_builder::generate_seed;
                                                  local_6e0 = 0;
                                                  local_6cb = 0;
                                                  local_788 = uVar32;
                                                  local_768 = plVar15;
                                                  local_760 = puVar31;
                                                  local_708 = uVar22;
                                                  pvVar11 = malloc(0x180);
                                                  if (pvVar11 != (void *)0x0) {
                                                    memcpy(pvVar11,&local_848,0x180);
                                                    local_9e0[1] = pvVar11;
                                                    *local_9e0 = 3;
                                                    return;
                                                  }
                    /* try { // try from 003a0604 to 003a0612 has its CatchHandler @ 003a0803 */
                    /* WARNING: Subroutine does not return */
                                                  alloc::alloc::handle_alloc_error(8,0x180);
                                                }
                                              } while( true );
                                            }
                                          }
                    /* try { // try from 003a06d4 to 003a06e5 has its CatchHandler @ 003a082b */
                                          local_920 = auVar37._8_8_;
                                          local_918 = auVar37._0_8_;
                    /* WARNING: Subroutine does not return */
                                          alloc::raw_vec::handle_error
                                                    (uVar23,uVar12,
                                                     &
                                                  PTR_s__rustc_6b00bc3880198600130e1cf62_00987f90);
                                        }
                                        ppuVar16 = &PTR_s__usr_local_cargo_registry_src_in_00977ef0;
                                        uVar19 = 0x30;
                                        pcVar27 = "assertion failed: shard_amount.is_power_of_two()"
                                        ;
                                      }
                    /* WARNING: Subroutine does not return */
                                      core::panicking::panic(pcVar27,uVar19,ppuVar16);
                                    }
                                  }
                    /* try { // try from 003a06b4 to 003a06cc has its CatchHandler @ 003a083a */
                    /* WARNING: Subroutine does not return */
                                  alloc::raw_vec::handle_error
                                            (uVar22,uVar12,
                                             &PTR_s__rustc_6b00bc3880198600130e1cf62_00987f90);
                                }
                                ppuVar16 = &PTR_s__usr_local_cargo_registry_src_in_00977ef0;
                                uVar19 = 0x30;
                                pcVar27 = "assertion failed: shard_amount.is_power_of_two()";
                              }
                    /* WARNING: Subroutine does not return */
                              core::panicking::panic(pcVar27,uVar19,ppuVar16);
                            }
                          }
                    /* try { // try from 003a069e to 003a06b1 has its CatchHandler @ 003a0844 */
                    /* WARNING: Subroutine does not return */
                          alloc::raw_vec::handle_error
                                    (uVar19,uVar12,&PTR_s__rustc_6b00bc3880198600130e1cf62_00987f90)
                          ;
                        }
                        ppuVar16 = &PTR_s__usr_local_cargo_registry_src_in_00977ef0;
                        uVar19 = 0x30;
                        pcVar27 = "assertion failed: shard_amount.is_power_of_two()";
                      }
                    /* WARNING: Subroutine does not return */
                      core::panicking::panic(pcVar27,uVar19,ppuVar16);
                    }
                    puVar8 = malloc(1);
                    if (puVar8 == (undefined1 *)0x0) {
                    /* try { // try from 003a04ae to 003a04bc has its CatchHandler @ 003a081d */
                    /* WARNING: Subroutine does not return */
                      alloc::alloc::handle_alloc_error(1,1);
                    }
                    *puVar8 = uVar6;
                    /* try { // try from 0039f548 to 0039f554 has its CatchHandler @ 003a0795 */
                    std::backtrace::Backtrace::capture(&local_848);
                    *(undefined4 *)(local_9e0 + 4) = (undefined4)local_828;
                    *(undefined4 *)((long)local_9e0 + 0x24) = local_828._4_4_;
                    *(undefined4 *)(local_9e0 + 5) = (undefined4)uStack_820;
                    *(undefined4 *)((long)local_9e0 + 0x2c) = uStack_820._4_4_;
                    *(undefined4 *)(local_9e0 + 2) = (undefined4)local_838;
                    *(undefined4 *)((long)local_9e0 + 0x14) = local_838._4_4_;
                    *(undefined4 *)(local_9e0 + 3) = (undefined4)uStack_830;
                    *(undefined4 *)((long)local_9e0 + 0x1c) = uStack_830._4_4_;
                    *(undefined4 *)local_9e0 = (undefined4)local_848;
                    *(undefined4 *)((long)local_9e0 + 4) = local_848._4_4_;
                    *(undefined4 *)(local_9e0 + 1) = (undefined4)uStack_840;
                    *(undefined4 *)((long)local_9e0 + 0xc) = uStack_840._4_4_;
                    local_9e0[6] = puVar8;
                    local_9e0[7] = &DAT_00977b48;
                    *(undefined1 *)(local_9e0 + 8) = 3;
                    if ((uVar32 & 0x7fffffffffffffff) != 0) {
                      free(local_9f0);
                    }
                    if (local_9e8 != (undefined1 *)0x0) {
                      free(local_9f8);
                    }
                    bVar17 = 0;
                    bVar18 = 0;
                    LOCK();
                    *plVar15 = *plVar15 + -1;
                    lVar21 = *plVar15;
                    UNLOCK();
                  }
                  if (lVar21 == 0) {
                    /* try { // try from 0039f5d4 to 0039f5dd has its CatchHandler @ 003a07f9 */
                    alloc::sync::Arc<T,A>::drop_slow(plVar15);
                    bVar18 = bVar17;
                  }
                  uVar32 = *param_3;
                  if (!(bool)(bVar18 & uVar32 != 0x8000000000000000)) {
                    return;
                  }
                }
                else {
                  _<polymarket_client_sdk::error::Error_as_core::convert::From<reqwest::error::Error>>
                  ::from(&local_848,plVar15);
                  local_9e0[8] = local_808;
                  local_9e0[6] = local_818;
                  local_9e0[7] = uStack_810;
                  local_9e0[4] = local_828;
                  local_9e0[5] = uStack_820;
                  local_9e0[2] = local_838;
                  local_9e0[3] = uStack_830;
                  *(undefined4 *)local_9e0 = (undefined4)local_848;
                  *(undefined4 *)((long)local_9e0 + 4) = local_848._4_4_;
                  *(undefined4 *)(local_9e0 + 1) = (undefined4)uStack_840;
                  *(undefined4 *)((long)local_9e0 + 0xc) = uStack_840._4_4_;
                  uVar32 = *param_3;
                  if (SBORROW8(0,uVar32)) {
                    return;
                  }
                }
                if (uVar32 == 0) {
                  return;
                }
                free((void *)param_3[1]);
                return;
              }
              pbVar29 = (byte *)(uVar32 * 0x68 + local_988);
LAB_0039f1b0:
              bVar18 = 2;
              if ((*pbVar29 & 1) != 0) {
                unaff_R12 = *(ulong *)(pbVar29 + 8);
                bVar18 = 1;
              }
              pbVar34 = pbVar29 + 0x18;
            }
            else {
              uVar12 = uStack_980;
              if (uStack_980 <= uVar32) {
LAB_003a0627:
                    /* try { // try from 003a0627 to 003a0633 has its CatchHandler @ 003a0801 */
                    /* WARNING: Subroutine does not return */
                core::panicking::panic_bounds_check(uVar32,uVar12,local_a48);
              }
              pbVar29 = (byte *)(uVar32 * 0x68 + local_988);
              if ((bVar18 & 1) == 0) goto LAB_0039f1b0;
              if (local_968 <= unaff_R12) {
                local_a48 = &PTR_s__usr_local_cargo_registry_src_in_0097d488;
                uVar12 = local_968;
                uVar32 = unaff_R12;
                goto LAB_003a0627;
              }
              lVar21 = lStack_970 + unaff_R12 * 0x48;
              bVar18 = 2;
              if (*(int *)(lStack_970 + 0x10 + unaff_R12 * 0x48) == 1) {
                unaff_R12 = *(ulong *)(lVar21 + 0x18);
                bVar18 = 1;
              }
              pbVar34 = (byte *)(lVar21 + 0x20);
            }
                    /* try { // try from 0039f1d8 to 0039f27e has its CatchHandler @ 003a085b */
            (*(code *)**(undefined8 **)pbVar34)
                      (&local_428,pbVar34 + 0x18,*(undefined8 *)(pbVar34 + 8),
                       *(undefined8 *)(pbVar34 + 0x10));
            local_8e8 = CONCAT44(uStack_414,local_418);
            uStack_8e0 = CONCAT44(uStack_40c,uStack_410);
            local_8f8 = CONCAT44(uStack_424,local_428);
            uStack_8f0 = CONCAT44(uStack_41c,uStack_420);
            local_8d8 = CONCAT71(local_8d8._1_7_,pbVar34[0x20]);
            http::header::map::HeaderMap<T>::try_insert2
                      (&local_428,&local_848,pbVar29 + 0x40,&local_8f8);
            if ((char)local_408 == '\x03') {
                    /* try { // try from 0039fa1a to 0039fa44 has its CatchHandler @ 003a097e */
                    /* WARNING: Subroutine does not return */
              core::result::unwrap_failed
                        ("size overflows MAX_SIZE",0x17,&local_948,&DAT_00986880,
                         &PTR_s__usr_local_cargo_registry_src_in_0097d3a0);
            }
            local_a28 = local_418;
            uStack_a24 = uStack_414;
            uStack_a20 = uStack_410;
            uStack_a1c = uStack_40c;
            local_a38 = (undefined1 *)CONCAT44(uStack_424,local_428);
            uStack_a30 = (undefined1 *)CONCAT44(uStack_41c,uStack_420);
            if ((char)local_408 != '\x02') {
              (**(code **)((long)local_a38 + 0x20))
                        (&uStack_a20,uStack_a30,CONCAT44(uStack_414,local_418));
            }
          } while( true );
        }
      }
    }
  }
                    /* try { // try from 003a046e to 003a0494 has its CatchHandler @ 003a0867 */
                    /* WARNING: Subroutine does not return */
  core::result::unwrap_failed
            ("size overflows MAX_SIZE",0x17,&local_948,&DAT_00986880,
             &PTR_s__usr_local_cargo_registry_src_in_0097d3a0);
}


