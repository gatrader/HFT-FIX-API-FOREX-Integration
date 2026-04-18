// arbitrage_bot::main
// entry = 002672c0


/* arbitrage_bot::main */

undefined8 * __rustcall arbitrage_bot::main(void)

{
  undefined ****ppppuVar1;
  undefined ***pppuVar2;
  code *pcVar3;
  long lVar4;
  undefined ****ppppuVar5;
  undefined4 uVar6;
  undefined8 *puVar7;
  undefined8 uVar8;
  undefined8 uVar9;
  ulong uVar10;
  undefined4 extraout_EDX;
  undefined ****ppppuVar11;
  undefined **ppuVar12;
  long lVar13;
  undefined4 uVar14;
  uint uVar15;
  long *plVar16;
  long *in_FS_OFFSET;
  undefined1 auVar17 [16];
  long local_4ce0;
  undefined4 local_4cd8;
  undefined4 uStack_4cd4;
  undefined4 uStack_4cd0;
  undefined4 uStack_4ccc;
  undefined ***local_4cc8;
  undefined ***pppuStack_4cc0;
  undefined ***pppuStack_4cb8;
  undefined8 uStack_4cb0;
  undefined8 uStack_4ca8;
  undefined8 uStack_4ca0;
  undefined8 uStack_4c98;
  int local_4c90;
  undefined4 local_4c8c;
  undefined ***local_4c88;
  undefined8 local_4c78;
  undefined ***local_4c70;
  undefined8 local_4c68;
  undefined ***local_4c60;
  undefined8 local_4c58;
  undefined8 uStack_4c50;
  undefined8 local_4c48;
  undefined8 local_4c40;
  undefined ***local_4c38;
  uint *local_4c30;
  undefined ***local_4c28;
  uint *local_4c20;
  undefined ***local_4c18;
  undefined ***pppuStack_4c10;
  undefined ***local_4c08;
  undefined ***pppuStack_4c00;
  undefined4 local_4bf8;
  undefined4 uStack_4bf4;
  undefined4 uStack_4bf0;
  undefined4 uStack_4bec;
  undefined8 local_4be8;
  undefined8 uStack_4be0;
  undefined ***local_4bd8;
  undefined8 local_4bc8;
  uint *local_4bc0;
  undefined ***local_4bb8;
  ulong **local_4bb0;
  undefined8 uStack_4ba8;
  undefined ***local_4b98;
  undefined ***local_4b80;
  uint local_4b78;
  undefined4 uStack_4b74;
  undefined4 uStack_4b70;
  undefined4 uStack_4b6c;
  undefined4 local_4b68;
  undefined4 uStack_4b64;
  undefined4 uStack_4b60;
  undefined4 uStack_4b5c;
  undefined4 local_4b58;
  undefined4 uStack_4b54;
  undefined4 uStack_4b50;
  undefined4 uStack_4b4c;
  uint local_4b48;
  undefined4 uStack_4b44;
  undefined4 uStack_4b40;
  undefined4 uStack_4b3c;
  undefined8 local_4b38;
  undefined8 uStack_4b30;
  undefined ***local_4b20;
  long local_4b18;
  undefined8 *local_4b10;
  undefined ***local_4b08;
  undefined ***local_4b00;
  undefined ***local_4af8;
  undefined ***local_4af0;
  undefined8 local_4ae8 [2];
  undefined8 local_4ad8;
  undefined4 local_4ac8;
  undefined4 local_4ab8;
  undefined8 *local_4ab0;
  undefined *local_4aa8;
  undefined8 local_4aa0;
  undefined8 local_4a98;
  undefined8 local_4a90;
  undefined8 local_4a80;
  undefined8 local_4a70;
  undefined8 local_4a60;
  undefined8 local_4a50;
  undefined8 local_4a40;
  undefined8 local_4a30;
  undefined4 local_4a28;
  uint local_4a24;
  undefined4 local_4a20;
  undefined4 local_4a1c;
  undefined2 local_4a18;
  uint local_4a10;
  undefined4 uStack_4a0c;
  undefined4 uStack_4a08;
  undefined4 uStack_4a04;
  undefined4 local_4a00;
  undefined4 uStack_49fc;
  undefined4 uStack_49f8;
  undefined4 uStack_49f4;
  undefined4 local_49f0;
  undefined4 uStack_49ec;
  undefined4 uStack_49e8;
  undefined4 uStack_49e4;
  uint local_49e0;
  undefined4 uStack_49dc;
  undefined4 uStack_49d8;
  undefined4 uStack_49d4;
  undefined8 local_49d0;
  undefined8 uStack_49c8;
  undefined8 local_4030;
  undefined1 local_3178 [328];
  undefined8 local_3030;
  undefined1 local_2fb4;
  undefined8 local_2030;
  undefined1 local_18e0 [2224];
  undefined8 local_1030;
  
  local_1030 = 0;
  local_2030 = 0;
  local_3030 = 0;
  local_4030 = 0;
  local_2fb4 = 0;
  puVar7 = malloc(0x10);
  if (puVar7 == (undefined8 *)0x0) {
                    /* try { // try from 002674fa to 00267508 has its CatchHandler @ 00267f3d */
                    /* WARNING: Subroutine does not return */
    alloc::alloc::handle_alloc_error(8,0x10);
  }
  *puVar7 = 1;
  puVar7[1] = 1;
                    /* try { // try from 00267342 to 00267346 has its CatchHandler @ 00267e64 */
  uVar8 = tokio::loom::std::rand::seed();
  local_4a24 = 1;
  if (1 < (uint)uVar8) {
    local_4a24 = (uint)uVar8;
  }
  local_4aa0 = 0x400;
  local_4ae8[0] = 0;
  local_4a98 = 0x200;
  local_4aa8 = &DAT_00984d38;
  local_4ad8 = 0;
  local_4a90 = 0;
  local_4a80 = 0;
  local_4a70 = 0;
  local_4a60 = 0;
  local_4a50 = 0;
  local_4a40 = 0;
  local_4ab8 = 1000000000;
  local_4ac8 = 0;
  local_4a20 = 0x3d;
  local_4a18 = 0;
  local_4a30 = 0;
  local_4a28 = (undefined4)((ulong)uVar8 >> 0x20);
  local_4a1c = 0x10101;
                    /* try { // try from 0026743b to 0026744f has its CatchHandler @ 00267e8f */
  local_4ab0 = puVar7;
  tokio::runtime::builder::Builder::build(&local_4a10,local_4ae8);
  if (local_4a10 == 2) {
                    /* try { // try from 0026751e to 00267544 has its CatchHandler @ 00267f20 */
                    /* WARNING: Subroutine does not return */
    core::result::unwrap_failed
              (&DAT_007dc5dd,0x1b,local_18e0,&PTR_drop_in_place<std::io::error::Error>_0096b500,
               &PTR_DAT_0096b550);
  }
  local_4b38 = local_49d0;
  uStack_4b30 = uStack_49c8;
  local_4b48 = local_49e0;
  uStack_4b44 = uStack_49dc;
  uStack_4b40 = uStack_49d8;
  uStack_4b3c = uStack_49d4;
  local_4b58 = local_49f0;
  uStack_4b54 = uStack_49ec;
  uStack_4b50 = uStack_49e8;
  uStack_4b4c = uStack_49e4;
  local_4b68 = local_4a00;
  uStack_4b64 = uStack_49fc;
  uStack_4b60 = uStack_49f8;
  uStack_4b5c = uStack_49f4;
  local_4b78 = local_4a10;
  uStack_4b74 = uStack_4a0c;
  uStack_4b70 = uStack_4a08;
  uStack_4b6c = uStack_4a04;
  memcpy(local_18e0,local_3178,0x1898);
  uVar8 = CONCAT44(uStack_4b44,local_4b48);
  uVar9 = CONCAT44(uStack_4b3c,uStack_4b40);
  if ((char)in_FS_OFFSET[-0x30] == '\x01') {
LAB_0026756f:
    tokio::runtime::context::current::_<impl_tokio::runtime::context::Context>::set_current
              (&local_4a10,*in_FS_OFFSET + -0x1c8,uVar8,uVar9);
    local_4ce0 = CONCAT44(uStack_4a0c,local_4a10);
    if (local_4ce0 != 3) {
      local_4cd8 = uStack_4a08;
      uStack_4cd4 = uStack_4a04;
      uStack_4cd0 = local_4a00;
      uStack_4ccc = uStack_49fc;
      if ((local_4b78 & 1) != 0) {
        memcpy(&local_4a10,local_3178,0x1898);
                    /* try { // try from 002675ee to 002675f5 has its CatchHandler @ 00267e38 */
        puVar7 = (undefined8 *)
                 tokio::runtime::context::runtime::enter_runtime
                           (CONCAT44(uStack_4b44,local_4b48),CONCAT44(uStack_4b3c,uStack_4b40),
                            &local_4a10);
        goto LAB_00267ba7;
      }
      memcpy(&local_4a10,local_3178,0x1898);
      uVar15 = local_4b48;
      uVar8 = CONCAT44(uStack_4b44,local_4b48);
      lVar4 = CONCAT44(uStack_4b3c,uStack_4b40);
      if ((char)in_FS_OFFSET[-0x30] == '\x01') {
LAB_00267672:
        if (*(char *)((long)in_FS_OFFSET + -0x182) != '\x02') {
          local_4b98 = (undefined ***)0x3;
LAB_00267d41:
          local_4cc8 = (undefined ***)&PTR_DAT_00985948;
          pppuStack_4cc0 = (undefined ***)0x1;
          pppuStack_4cb8 = (undefined ***)0x8;
          uStack_4cb0 = (undefined ****)0x0;
          uStack_4ca8 = 0;
                    /* try { // try from 00267d67 to 00267d77 has its CatchHandler @ 00267e17 */
                    /* WARNING: Subroutine does not return */
          core::panicking::panic_fmt(&local_4cc8,&PTR_DAT_0096b550);
        }
        *(undefined1 *)((long)in_FS_OFFSET + -0x182) = 0;
        lVar13 = lVar4 + 0x220;
        if ((uVar15 & 1) != 0) {
          lVar13 = lVar4 + 0x1d8;
        }
        uVar6 = tokio::util::rand::rt::RngSeedGenerator::next_seed(lVar13);
        if ((*(byte *)(in_FS_OFFSET + -0x32) & 1) == 0) {
          uVar9 = tokio::loom::std::rand::seed();
          uVar14 = (undefined4)((ulong)uVar9 >> 0x20);
          uVar15 = 1;
          if (1 < (uint)uVar9) {
            uVar15 = (uint)uVar9;
          }
        }
        else {
          uVar14 = *(undefined4 *)((long)in_FS_OFFSET + -0x18c);
          uVar15 = *(uint *)(in_FS_OFFSET + -0x31);
        }
        *(undefined4 *)(in_FS_OFFSET + -0x32) = 1;
        *(undefined4 *)((long)in_FS_OFFSET + -0x18c) = uVar6;
        *(undefined4 *)(in_FS_OFFSET + -0x31) = extraout_EDX;
        ppppuVar11 = &local_4cc8;
        tokio::runtime::context::current::_<impl_tokio::runtime::context::Context>::set_current
                  (ppppuVar11,*in_FS_OFFSET + -0x1c8,uVar8,lVar4);
        uStack_4cb0 = (undefined ****)CONCAT44(uVar15,uVar14);
        local_4c18 = pppuStack_4cc0;
        pppuStack_4c10 = pppuStack_4cb8;
        local_4c08 = (undefined ***)uStack_4cb0;
        if (local_4cc8 != (undefined ***)&DAT_00000004) {
          local_4b98 = local_4cc8;
          local_4b80 = (undefined ***)uStack_4cb0;
          if ((undefined ****)local_4cc8 == (undefined ****)0x3) goto LAB_00267d41;
          local_4c30 = &local_4b48;
          local_4c28 = (undefined ***)&uStack_4b70;
          local_4af8 = pppuStack_4cb8;
          local_4af0 = (undefined ***)uStack_4cb0;
          local_4b08 = local_4cc8;
          local_4b00 = pppuStack_4cc0;
          local_4c20 = &local_4a10;
          if (local_4b48 == 1) {
            local_4cc8 = (undefined ***)&PTR_DAT_00985ad0;
            ppuVar12 = &PTR_DAT_00985ae0;
LAB_00267d14:
            ppppuVar11[1] = (undefined ***)0x1;
            ppppuVar11[2] = (undefined ***)0x8;
            ppppuVar11[3] = (undefined ***)0x0;
            ppppuVar11[4] = (undefined ***)0x0;
                    /* try { // try from 00267d2b to 00267d32 has its CatchHandler @ 00267f1b */
                    /* WARNING: Subroutine does not return */
            core::panicking::panic_fmt(ppppuVar11,ppuVar12);
          }
          while( true ) {
            LOCK();
            ppppuVar1 = (undefined ****)local_4c28[4];
            local_4c28[4] = (undefined **)0x0;
            UNLOCK();
            if (ppppuVar1 != (undefined ****)0x0) break;
            local_4c78 = 2;
            pppuStack_4cc0 = (undefined ***)((ulong)*local_4c28 >> 2);
            pppuStack_4cb8 = (undefined ***)0x0;
            uStack_4cb0 = (undefined ****)0x0;
            uStack_4ca8 = 0;
            local_4cc8 = local_4c28;
            uStack_4ca0 = 0;
            uStack_4c98 = 0;
            local_4c90 = (int)local_4bc8;
            local_4c90 = local_4c90 << 8;
                    /* try { // try from 00267890 to 0026789f has its CatchHandler @ 00267ed2 */
            local_4c8c = local_4bc8._3_4_;
            local_4c18 = (undefined ***)ppppuVar11;
            auVar17 = tokio::runtime::park::CachedParkThread::block_on(&local_4c18,&local_4c20);
            puVar7 = auVar17._8_8_;
            uVar10 = auVar17._0_8_;
            if (uVar10 == 2) {
                    /* try { // try from 00267c23 to 00267c49 has its CatchHandler @ 00267f45 */
                    /* WARNING: Subroutine does not return */
              core::result::unwrap_failed
                        (&DAT_007dd734,0x1b,&local_4b20,&DAT_00985b90,&PTR_DAT_0096d738);
            }
            if ((uVar10 & 1) != 0) {
                    /* try { // try from 00267b2b to 00267b34 has its CatchHandler @ 00267dad */
              _<tokio::sync::notify::Notified_as_core::ops::drop::Drop>::drop(&local_4cc8);
              if (uStack_4ca8 != 0) {
                    /* try { // try from 00267b44 to 00267b46 has its CatchHandler @ 00267d96 */
                (**(code **)(uStack_4ca8 + 0x18))(uStack_4ca0);
              }
              if ((int)local_4c78 != 2) {
                    /* try { // try from 00267b4e to 00267b57 has its CatchHandler @ 00267d7f */
                _<tokio::runtime::scheduler::current_thread::CoreGuard_as_core::ops::drop::Drop>::
                drop(&local_4c78);
                    /* try { // try from 00267b58 to 00267b61 has its CatchHandler @ 00267f1b */
                core::ptr::drop_in_place<tokio::runtime::scheduler::Context>(&local_4c78);
              }
              goto LAB_00267b8d;
            }
                    /* try { // try from 002678ba to 002678c1 has its CatchHandler @ 00267e97 */
            _<tokio::sync::notify::Notified_as_core::ops::drop::Drop>::drop(ppppuVar11);
            if (uStack_4ca8 != 0) {
                    /* try { // try from 002678d1 to 002678d3 has its CatchHandler @ 00267e8a */
              (**(code **)(uStack_4ca8 + 0x18))(uStack_4ca0);
            }
            if (puVar7 != (undefined8 *)0x0 && uVar10 != 0) {
                    /* try { // try from 002678e7 to 002678eb has its CatchHandler @ 00267e40 */
              (**(code **)*puVar7)(puVar7);
            }
            if ((int)local_4c78 != 2) {
                    /* try { // try from 002678f7 to 002678fe has its CatchHandler @ 00267e4d */
              _<tokio::runtime::scheduler::current_thread::CoreGuard_as_core::ops::drop::Drop>::drop
                        (&local_4c78);
                    /* try { // try from 002678ff to 00267906 has its CatchHandler @ 00267e48 */
              core::ptr::drop_in_place<tokio::runtime::scheduler::Context>(&local_4c78);
            }
          }
          ppppuVar5 = (undefined ****)CONCAT44(uStack_4b3c,uStack_4b40);
          LOCK();
          pppuVar2 = *ppppuVar5;
          *ppppuVar5 = (undefined ***)((long)*ppppuVar5 + 1);
          UNLOCK();
          if (*ppppuVar5 != (undefined ***)0x0 && SCARRY8((long)pppuVar2,1) == (long)*ppppuVar5 < 0)
          {
            local_4c78 = 0;
            local_4c68 = 0;
            local_4c58 = 0;
            uStack_4c50 = 0;
            local_4c48 = 8;
            local_4c40 = 0;
            local_4be8 = 8;
            uStack_4be0 = 0;
            local_4bf8 = 0;
            uStack_4bf4 = 0;
            uStack_4bf0 = 0;
            uStack_4bec = 0;
            local_4c08 = (undefined ***)0x0;
            local_4c18 = (undefined ***)0x0;
            lVar4 = CONCAT44(uStack_4b3c,uStack_4b40);
            uVar10 = in_FS_OFFSET[-6];
            local_4c70 = (undefined ***)ppppuVar5;
            local_4c60 = (undefined ***)ppppuVar1;
            local_4c38 = local_4c28;
            pppuStack_4c10 = (undefined ***)ppppuVar5;
            pppuStack_4c00 = (undefined ***)ppppuVar1;
            local_4bd8 = local_4c28;
            if (uVar10 < 3) {
                    /* try { // try from 00267c67 to 00267c6e has its CatchHandler @ 00267d7a */
              plVar16 = (long *)std::thread::current::init_current(uVar10);
            }
            else {
              LOCK();
              plVar16 = (long *)(uVar10 - 0x10);
              lVar13 = *plVar16;
              *plVar16 = *plVar16 + 1;
              UNLOCK();
              if (*plVar16 == 0 || SCARRY8(lVar13,1) != *plVar16 < 0) goto LAB_00267d78;
              plVar16 = (long *)(uVar10 - 0x10);
            }
                    /* try { // try from 00267a12 to 00267a19 has its CatchHandler @ 00267dec */
            tokio::runtime::metrics::worker::WorkerMetrics::set_thread_id(lVar4 + 0x80,plVar16[2]);
            LOCK();
            *plVar16 = *plVar16 + -1;
            UNLOCK();
            if (*plVar16 == 0) {
              alloc::sync::Arc<T,A>::drop_slow(plVar16);
            }
            local_4cc8 = local_4c18;
            pppuStack_4cc0 = pppuStack_4c10;
            local_4c88 = local_4bd8;
            uStack_4c98 = local_4be8;
            local_4c90 = (int)uStack_4be0;
            local_4c8c = uStack_4be0._4_4_;
            uStack_4ca8 = CONCAT44(uStack_4bf4,local_4bf8);
            uStack_4ca0 = CONCAT44(uStack_4bec,uStack_4bf0);
            pppuStack_4cb8 = local_4c08;
            uStack_4cb0 = (undefined ****)pppuStack_4c00;
            if ((int)local_4c18 == 1) {
              local_4bc8 = &PTR_DAT_00985af8;
              local_4bc0 = (uint *)0x1;
              local_4bb8 = (undefined ***)0x8;
              local_4bb0 = (ulong **)0x0;
              uStack_4ba8 = 0;
                    /* try { // try from 00267ca9 to 00267ccd has its CatchHandler @ 00267f07 */
                    /* WARNING: Subroutine does not return */
              core::panicking::panic_fmt(&local_4bc8,&PTR_DAT_00984b70);
            }
            if ((undefined ****)local_4c08 == (undefined ****)0x0) {
              uStack_4cb0 = (undefined ****)0x0;
              if ((undefined ****)pppuStack_4c00 == (undefined ****)0x0) {
                    /* try { // try from 00267cd3 to 00267cea has its CatchHandler @ 00267ef9 */
                    /* WARNING: Subroutine does not return */
                core::option::expect_failed(&DAT_008453fd,0xc,&PTR_DAT_00984b88);
              }
              local_4bb0 = (ulong **)&pppuStack_4cc0;
              pppuStack_4cb8 = (undefined ***)0x0;
              local_4bc0 = local_4c20;
                    /* try { // try from 00267acd to 00267ae4 has its CatchHandler @ 00267de7 */
              local_4bc8 = (undefined **)ppppuVar11;
              local_4bb8 = pppuStack_4c00;
              std::thread::local::LocalKey<T>::with(&local_4b20,&local_4bc8);
              if ((undefined ****)pppuStack_4cb8 == (undefined ****)0x0) {
                pppuStack_4cb8 = (undefined ***)0xffffffffffffffff;
                if (uStack_4cb0 == (undefined ****)0x0) {
                  pppuStack_4cb8 = (undefined ***)0x0;
                }
                else {
                    /* try { // try from 00267b1c to 00267b20 has its CatchHandler @ 00267d9b */
                  core::ptr::
                  drop_in_place<alloc::boxed::Box<tokio::runtime::scheduler::current_thread::Core>>
                            ();
                  pppuStack_4cb8 = (undefined ***)((long)pppuStack_4cb8 + 1);
                }
                uStack_4cb0 = (undefined ****)local_4b20;
                    /* try { // try from 00267b70 to 00267b79 has its CatchHandler @ 00267dd0 */
                _<tokio::runtime::scheduler::current_thread::CoreGuard_as_core::ops::drop::Drop>::
                drop(&local_4cc8);
                    /* try { // try from 00267b7a to 00267b83 has its CatchHandler @ 00267f1b */
                core::ptr::drop_in_place<tokio::runtime::scheduler::Context>(&local_4cc8);
                puVar7 = local_4b10;
                if (local_4b18 != 0) {
LAB_00267b8d:
                    /* try { // try from 00267b8d to 00267b99 has its CatchHandler @ 00267f7c */
                  core::ptr::drop_in_place<tokio::runtime::context::runtime::EnterRuntimeGuard>
                            (&local_4b08);
                    /* try { // try from 00267b9a to 00267ba6 has its CatchHandler @ 00267e38 */
                  core::ptr::drop_in_place<arbitrage_bot::main::__closure__>(&local_4a10);
LAB_00267ba7:
                    /* try { // try from 00267bac to 00267bb5 has its CatchHandler @ 00267e1c */
                  std::thread::local::LocalKey<T>::with
                            (&local_4ce0,CONCAT44(uStack_4ccc,uStack_4cd0));
                  if (local_4ce0 != 2) {
                    if (local_4ce0 == 0) {
                      plVar16 = (long *)CONCAT44(uStack_4cd4,local_4cd8);
                      LOCK();
                      *plVar16 = *plVar16 + -1;
                      UNLOCK();
                      if (*plVar16 == 0) {
                        alloc::sync::Arc<T,A>::drop_slow(CONCAT44(uStack_4cd4,local_4cd8));
                      }
                    }
                    else {
                      plVar16 = (long *)CONCAT44(uStack_4cd4,local_4cd8);
                      LOCK();
                      *plVar16 = *plVar16 + -1;
                      UNLOCK();
                      if (*plVar16 == 0) {
                    /* try { // try from 00267bd6 to 00267bf1 has its CatchHandler @ 00267e0f */
                        alloc::sync::Arc<T,A>::drop_slow(CONCAT44(uStack_4cd4,local_4cd8));
                      }
                    }
                  }
                    /* try { // try from 00267bf4 to 00267c00 has its CatchHandler @ 00267e8f */
                  core::ptr::drop_in_place<tokio::runtime::runtime::Runtime>(&local_4b78);
                  core::ptr::drop_in_place<tokio::runtime::builder::Builder>(local_4ae8);
                  return puVar7;
                }
                local_4bc8 = &PTR_s_a_spawned_task_panicked_and_the_r_0096b080;
                ppuVar12 = &PTR_DAT_0096d720;
                ppppuVar11 = (undefined ****)&local_4bc8;
                goto LAB_00267d14;
              }
                    /* try { // try from 00267cf0 to 00267cfb has its CatchHandler @ 00267ed4 */
              core::cell::panic_already_borrowed(&PTR_DAT_00984ba0);
            }
            else {
              core::cell::panic_already_borrowed(&PTR_DAT_00984bb8);
            }
          }
          goto LAB_00267d78;
        }
      }
      else if ((char)in_FS_OFFSET[-0x30] != '\x02') {
        std::sys::thread_local::destructors::linux_like::register
                  (*in_FS_OFFSET + -0x1c8,std::sys::thread_local::native::eager::destroy);
        *(undefined1 *)(in_FS_OFFSET + -0x30) = 1;
        goto LAB_00267672;
      }
                    /* try { // try from 0026763c to 00267721 has its CatchHandler @ 00267f7c */
      std::thread::local::panic_access_error(&PTR_DAT_009858f0);
      goto LAB_00267d78;
    }
  }
  else if ((char)in_FS_OFFSET[-0x30] != '\x02') {
                    /* try { // try from 0026754a to 00267591 has its CatchHandler @ 00267ff4 */
    std::sys::thread_local::destructors::linux_like::register
              (*in_FS_OFFSET + -0x1c8,std::sys::thread_local::native::eager::destroy);
    *(undefined1 *)(in_FS_OFFSET + -0x30) = 1;
    goto LAB_0026756f;
  }
                    /* try { // try from 002674f0 to 002674f4 has its CatchHandler @ 00267ff4 */
  tokio::runtime::handle::Handle::enter::panic_cold_display();
LAB_00267d78:
                    /* WARNING: Does not return */
  pcVar3 = (code *)invalidInstructionException();
  (*pcVar3)();
}


