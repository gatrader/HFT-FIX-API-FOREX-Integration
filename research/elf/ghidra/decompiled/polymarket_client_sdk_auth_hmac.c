// polymarket_client_sdk::auth::hmac
// entry = 0039b5c0


/* WARNING: Removing unreachable block (ram,0x0039be05) */
/* WARNING: Removing unreachable block (ram,0x0039bd11) */
/* WARNING: Removing unreachable block (ram,0x0039bef0) */
/* WARNING: Removing unreachable block (ram,0x0039beb2) */
/* WARNING: Removing unreachable block (ram,0x0039be74) */
/* WARNING: Removing unreachable block (ram,0x0039be36) */
/* WARNING: Removing unreachable block (ram,0x0039be1c) */
/* WARNING: Removing unreachable block (ram,0x0039be55) */
/* WARNING: Removing unreachable block (ram,0x0039be93) */
/* WARNING: Removing unreachable block (ram,0x0039bed1) */
/* WARNING: Removing unreachable block (ram,0x0039bd2b) */
/* WARNING: Removing unreachable block (ram,0x0039bcdd) */
/* WARNING: Removing unreachable block (ram,0x0039ca9c) */
/* polymarket_client_sdk::auth::hmac */

void __rustcall
polymarket_client_sdk::auth::hmac
          (undefined8 *param_1,long param_2,ulong param_3,void *param_4,ulong param_5)

{
  byte *pbVar1;
  byte bVar2;
  byte bVar3;
  byte bVar4;
  byte bVar5;
  short sVar6;
  short sVar7;
  short sVar8;
  short sVar9;
  short sVar10;
  short sVar11;
  short sVar12;
  short sVar13;
  short sVar14;
  short sVar15;
  short sVar16;
  short sVar17;
  short sVar18;
  short sVar19;
  short sVar20;
  short sVar21;
  short sVar22;
  short sVar23;
  short sVar24;
  short sVar25;
  short sVar26;
  short sVar27;
  short sVar28;
  short sVar29;
  short sVar30;
  short sVar31;
  short sVar32;
  short sVar33;
  short sVar34;
  short sVar35;
  short sVar36;
  short sVar37;
  undefined1 auVar38 [15];
  undefined1 auVar39 [15];
  undefined1 auVar40 [15];
  undefined1 auVar41 [15];
  undefined1 auVar42 [15];
  undefined1 auVar43 [15];
  int iVar44;
  undefined1 auVar45 [15];
  undefined1 auVar46 [15];
  undefined1 auVar47 [15];
  undefined1 auVar48 [15];
  undefined1 auVar49 [15];
  undefined1 auVar50 [15];
  undefined1 auVar51 [15];
  undefined1 auVar52 [15];
  undefined1 auVar53 [12];
  undefined1 auVar54 [16];
  undefined1 auVar55 [12];
  undefined1 auVar56 [15];
  undefined1 auVar57 [15];
  undefined1 auVar58 [15];
  undefined1 auVar59 [15];
  undefined1 auVar60 [15];
  undefined1 auVar61 [15];
  ulong uVar62;
  ulong uVar63;
  ulong uVar64;
  ulong *puVar65;
  undefined **ppuVar66;
  void *pvVar67;
  ulong uVar68;
  uint uVar69;
  byte bVar70;
  ulong uVar71;
  ulong uVar72;
  size_t __nmemb;
  long lVar73;
  byte *pbVar74;
  ulong uVar75;
  uint uVar76;
  int iVar77;
  uint *puVar78;
  long lVar79;
  byte bVar80;
  undefined8 uVar81;
  long lVar82;
  ulong uVar83;
  ulong uVar84;
  uint uVar85;
  uint uVar86;
  ulong uVar87;
  long lVar88;
  byte bVar89;
  byte bVar90;
  undefined1 auVar91 [16];
  undefined1 auVar92 [16];
  undefined1 auVar93 [16];
  undefined1 auVar94 [16];
  undefined1 auVar95 [16];
  uint *local_310;
  uint local_2e8;
  uint uStack_2e4;
  uint uStack_2e0;
  uint uStack_2dc;
  undefined8 local_2d8;
  uint uStack_2d0;
  uint uStack_2cc;
  undefined8 local_2c8;
  undefined8 uStack_2c0;
  undefined8 local_2b8;
  undefined8 uStack_2b0;
  undefined8 local_2a8;
  long lStack_2a0;
  undefined8 local_298;
  undefined8 uStack_290;
  ulong local_288;
  undefined1 auStack_280 [5];
  undefined2 uStack_27b;
  undefined1 uStack_279;
  undefined8 local_278;
  undefined8 local_270;
  undefined8 uStack_268;
  undefined8 local_260;
  undefined8 uStack_258;
  undefined8 local_250;
  undefined8 uStack_248;
  undefined8 local_240;
  undefined8 uStack_238;
  undefined1 local_230;
  undefined8 *local_220;
  undefined1 local_218 [16];
  undefined1 local_208 [16];
  undefined1 local_1f8 [16];
  undefined1 local_1e8 [16];
  ulong local_1d8;
  ulong local_1d0;
  void *local_1c8;
  ulong local_1c0;
  undefined1 local_1b8 [16];
  undefined1 local_1a8 [16];
  undefined1 local_198 [16];
  undefined8 uStack_188;
  ulong uStack_180;
  undefined8 uStack_178;
  long local_170;
  undefined8 local_168;
  undefined8 uStack_160;
  undefined8 local_158;
  undefined8 uStack_150;
  undefined8 local_148;
  undefined **local_138;
  code *pcStack_130;
  undefined8 local_128;
  undefined8 uStack_120;
  ulong local_118;
  undefined1 auStack_110 [16];
  undefined1 auStack_100 [16];
  undefined1 local_f0 [16];
  undefined1 local_e0 [16];
  byte local_d0;
  undefined4 local_cf;
  undefined2 local_cb;
  undefined1 local_c9;
  undefined1 local_c0 [64];
  byte local_80;
  undefined1 local_78 [16];
  undefined1 local_68 [16];
  undefined8 local_58;
  undefined8 uStack_50;
  undefined8 local_48;
  undefined8 uStack_40;
  
  uVar71 = param_3 & 3;
  uVar83 = (ulong)(uVar71 != 0) + (param_3 >> 2);
  __nmemb = uVar83 * 3;
  if ((long)__nmemb < 0) {
    uVar81 = 0;
LAB_0039cc0b:
                    /* WARNING: Subroutine does not return */
    alloc::raw_vec::handle_error(uVar81,__nmemb,&PTR_s__usr_local_cargo_registry_src_in_00977dc0);
  }
  local_220 = param_1;
  local_1c0 = param_5;
  if (uVar83 == 0) {
    local_310 = (uint *)&DAT_00000001;
  }
  else {
    uVar81 = 1;
    local_310 = calloc(__nmemb,1);
    if (local_310 == (uint *)0x0) goto LAB_0039cc0b;
  }
  if ((int)uVar71 == 1) {
    bVar70 = *(byte *)(param_2 + -1 + param_3);
    if (((ulong)bVar70 != 0x3d) && ((&DAT_0083670b)[bVar70] == -1)) {
      uVar71 = param_3 - 1;
      uVar62 = (ulong)bVar70 << 8;
      goto LAB_0039bfda;
    }
  }
  uVar62 = 0;
  if (uVar71 <= param_3) {
    uVar62 = param_3 - uVar71;
  }
  uVar84 = uVar62;
  if (uVar71 == 0) {
    uVar84 = uVar62 - 4;
    if (uVar62 < 4) {
      uVar84 = 0;
    }
  }
  uVar62 = uVar84 >> 2;
  local_1c8 = param_4;
  if (uVar83 < uVar62) goto LAB_0039cc1f;
  uVar71 = uVar84 & 0xffffffffffffffe0;
  if (param_3 < uVar71) {
    ppuVar66 = &PTR_s__usr_local_cargo_registry_src_in_0096e0e0;
LAB_0039cac9:
                    /* WARNING: Subroutine does not return */
    core::slice::index::slice_end_index_len_fail(uVar71,param_3,ppuVar66);
  }
  if (uVar71 != 0) {
    local_1d8 = (uVar83 >> 3) * 0x18 + 0x18;
    uVar75 = 0;
    uVar87 = 0;
    puVar78 = local_310;
    do {
      local_1d0 = uVar84;
      if (uVar83 >> 3 == uVar87) {
        ppuVar66 = &PTR_s__usr_local_cargo_registry_src_in_0096e140;
        param_3 = __nmemb;
        uVar71 = local_1d8;
        goto LAB_0039cac9;
      }
      if ((ulong)(byte)(&DAT_0083670b)[*(byte *)(param_2 + uVar75)] == 0xff) {
        uVar71 = uVar87 << 5;
        uVar62 = (ulong)*(byte *)(param_2 + uVar75) << 8;
        goto LAB_0039bfda;
      }
      bVar70 = *(byte *)(param_2 + 1 + uVar75);
      if ((ulong)(byte)(&DAT_0083670b)[bVar70] == 0xff) {
        uVar71 = uVar87 * 0x20 + 1;
        uVar62 = (ulong)bVar70 << 8;
        goto LAB_0039bfda;
      }
      bVar89 = *(byte *)(param_2 + 2 + uVar75);
      if ((ulong)(byte)(&DAT_0083670b)[bVar89] == 0xff) {
        uVar71 = uVar87 << 5 | 2;
        uVar62 = (ulong)bVar89 << 8;
        goto LAB_0039bfda;
      }
      bVar80 = *(byte *)(param_2 + 3 + uVar75);
      if ((ulong)(byte)(&DAT_0083670b)[bVar80] == 0xff) {
        uVar71 = uVar87 << 5 | 3;
        uVar62 = (ulong)bVar80 << 8;
        goto LAB_0039bfda;
      }
      bVar90 = *(byte *)(param_2 + 4 + uVar75);
      if ((ulong)(byte)(&DAT_0083670b)[bVar90] == 0xff) {
        uVar71 = uVar87 << 5 | 4;
        uVar62 = (ulong)bVar90 << 8;
        goto LAB_0039bfda;
      }
      bVar2 = *(byte *)(param_2 + 5 + uVar75);
      if ((ulong)(byte)(&DAT_0083670b)[bVar2] == 0xff) {
        uVar71 = uVar87 << 5 | 5;
        uVar62 = (ulong)bVar2 << 8;
        goto LAB_0039bfda;
      }
      bVar3 = *(byte *)(param_2 + 6 + uVar75);
      if ((&DAT_0083670b)[bVar3] == 0xff) {
        uVar71 = uVar87 << 5 | 6;
        uVar62 = (ulong)bVar3 << 8;
        goto LAB_0039bfda;
      }
      bVar4 = *(byte *)(param_2 + 7 + uVar75);
      bVar5 = (&DAT_0083670b)[bVar4];
      if (bVar5 == 0xff) {
        uVar71 = uVar87 << 5 | 7;
        uVar62 = (ulong)bVar4 << 8;
        goto LAB_0039bfda;
      }
      uVar72 = (ulong)(byte)(&DAT_0083670b)[bVar70] << 0x34 |
               (ulong)(byte)(&DAT_0083670b)[*(byte *)(param_2 + uVar75)] << 0x3a;
      uVar68 = (ulong)(byte)(&DAT_0083670b)[bVar3] << 0x16;
      uVar63 = uVar68 | (ulong)(byte)(&DAT_0083670b)[bVar2] << 0x1c |
                        (ulong)(byte)(&DAT_0083670b)[bVar90] << 0x22;
      uVar64 = uVar63 | (ulong)(byte)(&DAT_0083670b)[bVar80] << 0x28 |
                        (ulong)(byte)(&DAT_0083670b)[bVar89] << 0x2e | uVar72;
      *puVar78 = (uint)(byte)(uVar72 >> 0x38) | ((uint)(uVar64 >> 0x20) & 0xff0000) >> 8 |
                 (uint)(uVar64 >> 0x18) & 0xff0000 | (uint)(uVar63 >> 8) & 0xff000000;
      *(ushort *)(puVar78 + 1) =
           (ushort)(uVar63 >> 0x18) & 0xff |
           (ushort)(((ulong)bVar5 << 0x10) >> 8) | (ushort)(uVar68 >> 8);
      bVar70 = *(byte *)(param_2 + 8 + uVar75);
      uVar85 = (uint)bVar70;
      if ((ulong)(byte)(&DAT_0083670b)[bVar70] == 0xff) {
        uVar71 = 8;
LAB_0039bfc1:
        uVar71 = uVar87 << 5 | uVar71;
        uVar62 = (ulong)(uVar85 << 8);
        goto LAB_0039bfda;
      }
      bVar89 = *(byte *)(param_2 + 9 + uVar75);
      uVar85 = (uint)bVar89;
      if ((ulong)(byte)(&DAT_0083670b)[bVar89] == 0xff) {
        uVar71 = 9;
        goto LAB_0039bfc1;
      }
      bVar80 = *(byte *)(param_2 + 10 + uVar75);
      uVar85 = (uint)bVar80;
      if ((ulong)(byte)(&DAT_0083670b)[bVar80] == 0xff) {
        uVar71 = 10;
        goto LAB_0039bfc1;
      }
      bVar90 = *(byte *)(param_2 + 0xb + uVar75);
      uVar85 = (uint)bVar90;
      if ((ulong)(byte)(&DAT_0083670b)[bVar90] == 0xff) {
        uVar71 = 0xb;
        goto LAB_0039bfc1;
      }
      bVar2 = *(byte *)(param_2 + 0xc + uVar75);
      uVar85 = (uint)bVar2;
      if ((ulong)(byte)(&DAT_0083670b)[bVar2] == 0xff) {
        uVar71 = 0xc;
        goto LAB_0039bfc1;
      }
      bVar3 = *(byte *)(param_2 + 0xd + uVar75);
      uVar85 = (uint)bVar3;
      if ((ulong)(byte)(&DAT_0083670b)[bVar3] == 0xff) {
        uVar71 = 0xd;
        goto LAB_0039bfc1;
      }
      bVar4 = *(byte *)(param_2 + 0xe + uVar75);
      uVar85 = (uint)bVar4;
      if ((&DAT_0083670b)[bVar4] == 0xff) {
        uVar71 = 0xe;
        goto LAB_0039bfc1;
      }
      bVar5 = *(byte *)(param_2 + 0xf + uVar75);
      uVar85 = (uint)bVar5;
      bVar5 = (&DAT_0083670b)[bVar5];
      if (bVar5 == 0xff) {
        uVar71 = 0xf;
        goto LAB_0039bfc1;
      }
      uVar68 = (ulong)(byte)(&DAT_0083670b)[bVar89] << 0x34 |
               (ulong)(byte)(&DAT_0083670b)[bVar70] << 0x3a;
      uVar63 = (ulong)(byte)(&DAT_0083670b)[bVar4] << 0x16;
      uVar64 = uVar63 | (ulong)(byte)(&DAT_0083670b)[bVar3] << 0x1c |
                        (ulong)(byte)(&DAT_0083670b)[bVar2] << 0x22;
      uVar72 = uVar64 | (ulong)(byte)(&DAT_0083670b)[bVar90] << 0x28 |
                        (ulong)(byte)(&DAT_0083670b)[bVar80] << 0x2e | uVar68;
      *(uint *)((long)puVar78 + 6) =
           (uint)(byte)(uVar68 >> 0x38) | ((uint)(uVar72 >> 0x20) & 0xff0000) >> 8 |
           (uint)(uVar72 >> 0x18) & 0xff0000 | (uint)(uVar64 >> 8) & 0xff000000;
      *(ushort *)((long)puVar78 + 10) =
           (ushort)(uVar64 >> 0x18) & 0xff |
           (ushort)(((ulong)bVar5 << 0x10) >> 8) | (ushort)(uVar63 >> 8);
      bVar70 = *(byte *)(param_2 + 0x10 + uVar75);
      uVar85 = (uint)bVar70;
      if ((ulong)(byte)(&DAT_0083670b)[bVar70] == 0xff) {
        uVar71 = 0x10;
        goto LAB_0039bfc1;
      }
      bVar89 = *(byte *)(param_2 + 0x11 + uVar75);
      uVar85 = (uint)bVar89;
      if ((ulong)(byte)(&DAT_0083670b)[bVar89] == 0xff) {
        uVar71 = 0x11;
        goto LAB_0039bfc1;
      }
      bVar80 = *(byte *)(param_2 + 0x12 + uVar75);
      uVar85 = (uint)bVar80;
      if ((ulong)(byte)(&DAT_0083670b)[bVar80] == 0xff) {
        uVar71 = 0x12;
        goto LAB_0039bfc1;
      }
      bVar90 = *(byte *)(param_2 + 0x13 + uVar75);
      uVar85 = (uint)bVar90;
      if ((ulong)(byte)(&DAT_0083670b)[bVar90] == 0xff) {
        uVar71 = 0x13;
        goto LAB_0039bfc1;
      }
      bVar2 = *(byte *)(param_2 + 0x14 + uVar75);
      uVar85 = (uint)bVar2;
      if ((ulong)(byte)(&DAT_0083670b)[bVar2] == 0xff) {
        uVar71 = 0x14;
        goto LAB_0039bfc1;
      }
      bVar3 = *(byte *)(param_2 + 0x15 + uVar75);
      uVar85 = (uint)bVar3;
      if ((ulong)(byte)(&DAT_0083670b)[bVar3] == 0xff) {
        uVar71 = 0x15;
        goto LAB_0039bfc1;
      }
      bVar4 = *(byte *)(param_2 + 0x16 + uVar75);
      uVar85 = (uint)bVar4;
      if ((&DAT_0083670b)[bVar4] == 0xff) {
        uVar71 = 0x16;
        goto LAB_0039bfc1;
      }
      bVar5 = *(byte *)(param_2 + 0x17 + uVar75);
      uVar85 = (uint)bVar5;
      bVar5 = (&DAT_0083670b)[bVar5];
      if (bVar5 == 0xff) {
        uVar71 = 0x17;
        goto LAB_0039bfc1;
      }
      uVar68 = (ulong)(byte)(&DAT_0083670b)[bVar89] << 0x34 |
               (ulong)(byte)(&DAT_0083670b)[bVar70] << 0x3a;
      uVar63 = (ulong)(byte)(&DAT_0083670b)[bVar4] << 0x16;
      uVar64 = uVar63 | (ulong)(byte)(&DAT_0083670b)[bVar3] << 0x1c |
                        (ulong)(byte)(&DAT_0083670b)[bVar2] << 0x22;
      uVar72 = uVar64 | (ulong)(byte)(&DAT_0083670b)[bVar90] << 0x28 |
                        (ulong)(byte)(&DAT_0083670b)[bVar80] << 0x2e | uVar68;
      puVar78[3] = (uint)(byte)(uVar68 >> 0x38) | ((uint)(uVar72 >> 0x20) & 0xff0000) >> 8 |
                   (uint)(uVar72 >> 0x18) & 0xff0000 | (uint)(uVar64 >> 8) & 0xff000000;
      *(ushort *)(puVar78 + 4) =
           (ushort)(uVar64 >> 0x18) & 0xff |
           (ushort)(((ulong)bVar5 << 0x10) >> 8) | (ushort)(uVar63 >> 8);
      bVar70 = *(byte *)(param_2 + 0x18 + uVar75);
      uVar85 = (uint)bVar70;
      if ((ulong)(byte)(&DAT_0083670b)[bVar70] == 0xff) {
        uVar71 = 0x18;
        goto LAB_0039bfc1;
      }
      bVar89 = *(byte *)(param_2 + 0x19 + uVar75);
      uVar85 = (uint)bVar89;
      if ((ulong)(byte)(&DAT_0083670b)[bVar89] == 0xff) {
        uVar71 = 0x19;
        goto LAB_0039bfc1;
      }
      bVar80 = *(byte *)(param_2 + 0x1a + uVar75);
      uVar85 = (uint)bVar80;
      if ((ulong)(byte)(&DAT_0083670b)[bVar80] == 0xff) {
        uVar71 = 0x1a;
        goto LAB_0039bfc1;
      }
      bVar90 = *(byte *)(param_2 + 0x1b + uVar75);
      uVar85 = (uint)bVar90;
      if ((ulong)(byte)(&DAT_0083670b)[bVar90] == 0xff) {
        uVar71 = 0x1b;
        goto LAB_0039bfc1;
      }
      bVar2 = *(byte *)(param_2 + 0x1c + uVar75);
      uVar85 = (uint)bVar2;
      if ((ulong)(byte)(&DAT_0083670b)[bVar2] == 0xff) {
        uVar71 = 0x1c;
        goto LAB_0039bfc1;
      }
      bVar3 = *(byte *)(param_2 + 0x1d + uVar75);
      uVar85 = (uint)bVar3;
      if ((ulong)(byte)(&DAT_0083670b)[bVar3] == 0xff) {
        uVar71 = 0x1d;
        goto LAB_0039bfc1;
      }
      bVar4 = *(byte *)(param_2 + 0x1e + uVar75);
      uVar85 = (uint)bVar4;
      if ((&DAT_0083670b)[bVar4] == 0xff) {
        uVar71 = 0x1e;
        goto LAB_0039bfc1;
      }
      bVar5 = *(byte *)(param_2 + 0x1f + uVar75);
      uVar85 = (uint)bVar5;
      bVar5 = (&DAT_0083670b)[bVar5];
      if (bVar5 == 0xff) {
        uVar71 = 0x1f;
        goto LAB_0039bfc1;
      }
      uVar68 = (ulong)(byte)(&DAT_0083670b)[bVar89] << 0x34 |
               (ulong)(byte)(&DAT_0083670b)[bVar70] << 0x3a;
      uVar63 = (ulong)(byte)(&DAT_0083670b)[bVar4] << 0x16;
      uVar64 = uVar63 | (ulong)(byte)(&DAT_0083670b)[bVar3] << 0x1c |
                        (ulong)(byte)(&DAT_0083670b)[bVar2] << 0x22;
      uVar72 = uVar64 | (ulong)(byte)(&DAT_0083670b)[bVar90] << 0x28 |
                        (ulong)(byte)(&DAT_0083670b)[bVar80] << 0x2e | uVar68;
      *(uint *)((long)puVar78 + 0x12) =
           (uint)(byte)(uVar68 >> 0x38) | ((uint)(uVar72 >> 0x20) & 0xff0000) >> 8 |
           (uint)(uVar72 >> 0x18) & 0xff0000 | (uint)(uVar64 >> 8) & 0xff000000;
      *(ushort *)((long)puVar78 + 0x16) =
           (ushort)(uVar64 >> 0x18) & 0xff |
           (ushort)(((ulong)bVar5 << 0x10) >> 8) | (ushort)(uVar63 >> 8);
      uVar75 = uVar75 + 0x20;
      puVar78 = puVar78 + 6;
      uVar87 = uVar87 + 1;
    } while (uVar71 != uVar75);
  }
  uVar87 = uVar71 >> 2;
  lVar88 = uVar87 * 3;
  uVar75 = uVar62 * 3;
  if (uVar62 < uVar87) {
                    /* try { // try from 0039caab to 0039cb5b has its CatchHandler @ 0039cd43 */
                    /* WARNING: Subroutine does not return */
    core::slice::index::slice_index_order_fail
              (lVar88,uVar75,&PTR_s__usr_local_cargo_registry_src_in_0096e0f8);
  }
  if (param_3 < uVar84) {
    ppuVar66 = &PTR_s__usr_local_cargo_registry_src_in_0096e110;
    uVar71 = uVar84;
    goto LAB_0039cac9;
  }
  if ((uVar84 & 0x1c) != 0) {
    uVar87 = uVar75 + uVar87 * -3;
    lVar73 = uVar71 + param_2;
    lVar79 = -(ulong)(((uint)uVar62 & 7) << 2);
    uVar68 = 3;
    lVar82 = 0;
    do {
      if (uVar87 < uVar68) {
        ppuVar66 = &PTR_s__usr_local_cargo_registry_src_in_0096e128;
        param_3 = uVar87;
        uVar71 = uVar68;
        goto LAB_0039cac9;
      }
      bVar70 = *(byte *)(lVar73 + lVar82 * 4);
      if ((byte)(&DAT_0083670b)[bVar70] == 0xff) {
        uVar71 = uVar71 + lVar82 * 4;
        uVar62 = (ulong)bVar70 << 8;
        goto LAB_0039bfda;
      }
      bVar89 = *(byte *)(lVar73 + 1 + lVar82 * 4);
      if ((&DAT_0083670b)[bVar89] == 0xff) {
        uVar71 = uVar71 + lVar82 * 4 + 1;
        uVar62 = (ulong)bVar89 << 8;
        goto LAB_0039bfda;
      }
      bVar80 = *(byte *)(lVar73 + 2 + lVar82 * 4);
      uVar63 = (ulong)bVar80;
      if ((&DAT_0083670b)[uVar63] == 0xff) {
        uVar71 = uVar71 + lVar82 * 4 + 2;
LAB_0039bdf3:
        uVar62 = (ulong)bVar80 << 8;
        goto LAB_0039bfda;
      }
      bVar80 = *(byte *)(lVar73 + 3 + lVar82 * 4);
      if ((&DAT_0083670b)[bVar80] == 0xff) {
        uVar71 = uVar71 + lVar82 * 4 + 3;
        goto LAB_0039bdf3;
      }
      iVar77 = (uint)(byte)(&DAT_0083670b)[bVar89] << 0x14;
      uVar85 = (uint)(byte)(&DAT_0083670b)[bVar80] << 8 | (uint)(byte)(&DAT_0083670b)[uVar63] << 0xe
      ;
      *(ushort *)((long)local_310 + uVar68 + lVar88 + -3) =
           (ushort)(byte)((byte)((uint)iVar77 >> 0x18) |
                         (byte)(((uint)(byte)(&DAT_0083670b)[bVar70] << 0x1a) >> 0x18)) |
           (ushort)(uVar85 >> 8) & 0xff00 | (ushort)((uint)iVar77 >> 8);
      *(char *)((long)local_310 + uVar68 + lVar88 + -1) = (char)(uVar85 >> 8);
      uVar68 = uVar68 + 3;
      lVar82 = lVar82 + 1;
      lVar79 = lVar79 + 4;
    } while (lVar79 != 0);
  }
  if (param_3 == uVar84) {
    bVar70 = 0;
    bVar89 = 0;
    uVar71 = 0;
joined_r0x0039bcb5:
    if (param_3 != 0) {
      uVar71 = uVar71 + uVar84;
      uVar62 = 1;
      goto LAB_0039bfda;
    }
    iVar77 = 0;
    bVar80 = 0;
    goto LAB_0039c077;
  }
  bVar89 = *(byte *)(param_2 + uVar84);
  uVar87 = (ulong)bVar89;
  if (uVar87 == 0x3d) {
LAB_0039bcee:
    lVar88 = 0;
LAB_0039bcf1:
    uVar71 = lVar88 + uVar84;
    uVar62 = 0x3d00;
    goto LAB_0039bfda;
  }
  bVar70 = (&DAT_0083670b)[uVar87];
  if (bVar70 == 0xff) {
    lVar88 = 0;
    goto LAB_0039bf4b;
  }
  pbVar1 = (byte *)(param_3 + param_2);
  if ((byte *)(uVar84 + param_2 + 1) == pbVar1) {
    uVar71 = 1;
    goto joined_r0x0039bcb5;
  }
  param_2 = param_2 + uVar84;
  bVar89 = *(byte *)(param_2 + 1);
  uVar87 = (ulong)bVar89;
  lVar88 = 1;
  if (uVar87 == 0x3d) goto LAB_0039bcf1;
  bVar80 = (&DAT_0083670b)[uVar87];
  if (bVar80 == 0xff) {
    lVar88 = 1;
    goto LAB_0039bf4b;
  }
  uVar71 = 2;
  if ((byte *)(param_2 + 2) == pbVar1) {
    iVar77 = 0;
LAB_0039c077:
    uVar85 = 0;
    bVar90 = bVar89;
LAB_0039c079:
    uVar76 = 0;
LAB_0039c07c:
    uVar86 = (uint)uVar71;
    if ((iVar77 + uVar86 & 3) != 0) {
      uVar62 = 3;
      goto LAB_0039bfda;
    }
    uVar69 = (uint)bVar80 << 0x14 | (uint)bVar70 << 0x1a;
    uVar85 = uVar76 << 8 | uVar85 << 0xe;
    uVar76 = uVar85 | uVar69;
    if (uVar76 << ((byte)(uVar86 * 6) & 0x18) == 0) {
      uVar71 = uVar75;
      if (1 < uVar86) {
        if (uVar83 <= uVar62) goto LAB_0039cc1f;
        *(char *)((long)local_310 + uVar75) = (char)(uVar69 >> 0x18);
        uVar71 = uVar75 + 1;
        if (uVar86 != 2) {
          if (__nmemb <= uVar75 + 1) goto LAB_0039cc1f;
          *(char *)((long)local_310 + uVar75 + 1) = (char)(uVar76 >> 0x10);
          uVar71 = uVar75 + 2;
          if ((uVar86 * 6 & 0xfffffff8) != 0x10) {
            if (__nmemb <= uVar75 + 2) goto LAB_0039cc1f;
            *(char *)((long)local_310 + uVar75 + 2) = (char)(uVar85 >> 8);
            uVar71 = uVar75 + 3;
          }
        }
      }
      if (uVar71 < __nmemb) {
        __nmemb = uVar71;
      }
      local_1e8 = (undefined1  [16])0x0;
      local_1f8 = (undefined1  [16])0x0;
      local_208 = (undefined1  [16])0x0;
      local_218 = (undefined1  [16])0x0;
      if (__nmemb < 0x41) {
        memcpy(local_218,local_310,__nmemb);
      }
      else {
        local_e0 = (undefined1  [16])0x0;
        local_f0 = (undefined1  [16])0x0;
        auStack_100 = (undefined1  [16])0x0;
        auStack_110 = (undefined1  [16])0x0;
        local_d0 = 0;
        local_138 = (undefined **)0xbb67ae856a09e667;
        pcStack_130 = (code *)0xa54ff53a3c6ef372;
        local_128 = 0x9b05688c510e527f;
        uStack_120 = 0x5be0cd191f83d9ab;
        local_118 = __nmemb >> 6;
                    /* try { // try from 0039c230 to 0039c241 has its CatchHandler @ 0039cd10 */
        sha2::sha256::compress256(&local_138,local_310);
        uVar85 = (uint)__nmemb & 0x3f;
        memcpy(auStack_110,(undefined1 *)((__nmemb & 0x7fffffffffffffc0) + (long)local_310),
               (ulong)uVar85);
        bVar70 = (byte)uVar85;
        local_288 = local_e0._8_8_;
        _auStack_280 = CONCAT25(local_cb,CONCAT41(local_cf,bVar70));
        _auStack_280 = CONCAT17(local_c9,_auStack_280);
        local_2c8 = local_118;
        uStack_2c0 = (undefined **)auStack_110._0_8_;
        local_298 = local_f0._8_8_;
        uStack_290 = local_e0._0_8_;
        local_2a8 = auStack_100._8_8_;
        lStack_2a0 = local_f0._0_8_;
        local_2b8 = auStack_110._8_8_;
        uStack_2b0 = auStack_100._0_8_;
        local_2d8._0_4_ = (uint)local_128;
        local_2d8._4_4_ = (uint)((ulong)local_128 >> 0x20);
        uStack_2d0 = (uint)uStack_120;
        uStack_2cc = (uint)((ulong)uStack_120 >> 0x20);
        local_2e8 = (uint)local_138;
        uStack_2e4 = (uint)((ulong)local_138 >> 0x20);
        uStack_2e0 = (uint)pcStack_130;
        uStack_2dc = (uint)((ulong)pcStack_130 >> 0x20);
        uVar62 = (ulong)_auStack_280 & 0xff;
        uVar71 = local_118 << 9;
        uVar71 = uVar71 >> 0x38 | (uVar71 & 0xff000000000000) >> 0x28 |
                 (uVar71 & 0xff0000000000) >> 0x18 | (uVar71 & 0xff00000000) >> 8 |
                 (uVar71 & 0xff000000) << 8 | (uVar71 & 0xff0000) << 0x18 |
                 ((uVar85 * 8 | uVar71) & 0xff00) << 0x28 | (ulong)(uVar85 * 8) << 0x38;
        local_d0 = bVar70;
        *(undefined1 *)((long)&uStack_2c0 + uVar62) = 0x80;
        if ((bVar70 == 0x3f) ||
           (memset((void *)((long)&uStack_2c0 + uVar62 + 1),0,uVar62 ^ 0x3f), (bVar70 ^ 0x38) < 8))
        {
                    /* try { // try from 0039c36a to 0039c615 has its CatchHandler @ 0039cd10 */
          sha2::sha256::compress256(&local_2e8,&uStack_2c0,1);
          local_198 = (undefined1  [16])0x0;
          local_1a8 = (undefined1  [16])0x0;
          local_1b8 = (undefined1  [16])0x0;
          uStack_188 = 0;
          uStack_180 = uVar71;
          sha2::sha256::compress256(&local_2e8,local_1b8,1);
        }
        else {
          local_288 = uVar71;
          sha2::sha256::compress256(&local_2e8,&uStack_2c0,1);
        }
        auVar53._8_4_ = uStack_2e0;
        auVar53._0_8_ = CONCAT44(uStack_2e4,local_2e8);
        auVar91._12_4_ = uStack_2dc;
        auVar91._0_12_ = auVar53;
        auVar55._8_4_ = uStack_2d0;
        auVar55._0_8_ = CONCAT44(local_2d8._4_4_,(uint)local_2d8);
        auVar54._12_4_ = uStack_2cc;
        auVar54._0_12_ = auVar55;
        auVar94[1] = 0;
        auVar94[0] = (byte)uStack_2e0;
        auVar94[2] = (char)(uStack_2e0 >> 8);
        auVar94[3] = 0;
        auVar94[4] = (char)(uStack_2e0 >> 0x10);
        auVar94[5] = 0;
        auVar94[6] = (char)(uStack_2e0 >> 0x18);
        auVar94[7] = 0;
        auVar94[8] = (char)uStack_2dc;
        auVar94[9] = 0;
        auVar94[10] = (char)(uStack_2dc >> 8);
        auVar94[0xb] = 0;
        auVar94[0xc] = (char)(uStack_2dc >> 0x10);
        auVar94[0xd] = 0;
        auVar94[0xe] = (char)(uStack_2dc >> 0x18);
        auVar94[0xf] = 0;
        auVar93 = pshuflw(auVar94,auVar94,0x1b);
        auVar94 = pshufhw(auVar93,auVar93,0x1b);
        auVar38[0xd] = 0;
        auVar38._0_13_ = auVar91._0_13_;
        auVar38[0xe] = (char)(uStack_2e4 >> 0x18);
        auVar40[0xc] = (char)(uStack_2e4 >> 0x10);
        auVar40._0_12_ = auVar53;
        auVar40._13_2_ = auVar38._13_2_;
        auVar42[0xb] = 0;
        auVar42._0_11_ = auVar53._0_11_;
        auVar42._12_3_ = auVar40._12_3_;
        auVar45[10] = (char)(uStack_2e4 >> 8);
        auVar45._0_10_ = auVar53._0_10_;
        auVar45._11_4_ = auVar42._11_4_;
        auVar47[9] = 0;
        auVar47._0_9_ = auVar53._0_9_;
        auVar47._10_5_ = auVar45._10_5_;
        auVar49[8] = (char)uStack_2e4;
        auVar49._0_8_ = CONCAT44(uStack_2e4,local_2e8);
        auVar49._9_6_ = auVar47._9_6_;
        auVar56._7_8_ = 0;
        auVar56._0_7_ = auVar49._8_7_;
        auVar58._1_8_ = SUB158(auVar56 << 0x40,7);
        auVar58[0] = (char)(local_2e8 >> 0x18);
        auVar58._9_6_ = 0;
        auVar59._1_10_ = SUB1510(auVar58 << 0x30,5);
        auVar59[0] = (char)(local_2e8 >> 0x10);
        auVar59._11_4_ = 0;
        auVar51[2] = (char)(local_2e8 >> 8);
        auVar51._0_2_ = (ushort)local_2e8;
        auVar51._3_12_ = SUB1512(auVar59 << 0x20,3);
        auVar93._0_2_ = (ushort)local_2e8 & 0xff;
        auVar93._2_13_ = auVar51._2_13_;
        auVar93[0xf] = 0;
        auVar91 = pshuflw(auVar93,auVar93,0x1b);
        auVar93 = pshufhw(auVar91,auVar91,0x1b);
        sVar6 = auVar93._0_2_;
        sVar8 = auVar93._2_2_;
        sVar10 = auVar93._4_2_;
        sVar12 = auVar93._6_2_;
        sVar14 = auVar93._8_2_;
        sVar16 = auVar93._10_2_;
        sVar18 = auVar93._12_2_;
        sVar20 = auVar93._14_2_;
        sVar22 = auVar94._0_2_;
        sVar24 = auVar94._2_2_;
        sVar26 = auVar94._4_2_;
        sVar28 = auVar94._6_2_;
        sVar30 = auVar94._8_2_;
        sVar32 = auVar94._10_2_;
        sVar34 = auVar94._12_2_;
        sVar36 = auVar94._14_2_;
        auVar95[1] = 0;
        auVar95[0] = (byte)uStack_2d0;
        auVar95[2] = (char)(uStack_2d0 >> 8);
        auVar95[3] = 0;
        auVar95[4] = (char)(uStack_2d0 >> 0x10);
        auVar95[5] = 0;
        auVar95[6] = (char)(uStack_2d0 >> 0x18);
        auVar95[7] = 0;
        auVar95[8] = (char)uStack_2cc;
        auVar95[9] = 0;
        auVar95[10] = (char)(uStack_2cc >> 8);
        auVar95[0xb] = 0;
        auVar95[0xc] = (char)(uStack_2cc >> 0x10);
        auVar95[0xd] = 0;
        auVar95[0xe] = (char)(uStack_2cc >> 0x18);
        auVar95[0xf] = 0;
        auVar91 = pshuflw(auVar95,auVar95,0x1b);
        auVar95 = pshufhw(auVar91,auVar91,0x1b);
        auVar39[0xd] = 0;
        auVar39._0_13_ = auVar54._0_13_;
        auVar39[0xe] = (char)(local_2d8._4_4_ >> 0x18);
        auVar41[0xc] = (char)(local_2d8._4_4_ >> 0x10);
        auVar41._0_12_ = auVar55;
        auVar41._13_2_ = auVar39._13_2_;
        auVar43[0xb] = 0;
        auVar43._0_11_ = auVar55._0_11_;
        auVar43._12_3_ = auVar41._12_3_;
        auVar46[10] = (char)(local_2d8._4_4_ >> 8);
        auVar46._0_10_ = auVar55._0_10_;
        auVar46._11_4_ = auVar43._11_4_;
        auVar48[9] = 0;
        auVar48._0_9_ = auVar55._0_9_;
        auVar48._10_5_ = auVar46._10_5_;
        auVar50[8] = (char)local_2d8._4_4_;
        auVar50._0_8_ = CONCAT44(local_2d8._4_4_,(uint)local_2d8);
        auVar50._9_6_ = auVar48._9_6_;
        auVar57._7_8_ = 0;
        auVar57._0_7_ = auVar50._8_7_;
        auVar60._1_8_ = SUB158(auVar57 << 0x40,7);
        auVar60[0] = (char)((uint)local_2d8 >> 0x18);
        auVar60._9_6_ = 0;
        auVar61._1_10_ = SUB1510(auVar60 << 0x30,5);
        auVar61[0] = (char)((uint)local_2d8 >> 0x10);
        auVar61._11_4_ = 0;
        auVar52[2] = (char)((uint)local_2d8 >> 8);
        auVar52._0_2_ = (ushort)(uint)local_2d8;
        auVar52._3_12_ = SUB1512(auVar61 << 0x20,3);
        auVar92._0_2_ = (ushort)(uint)local_2d8 & 0xff;
        auVar92._2_13_ = auVar52._2_13_;
        auVar92[0xf] = 0;
        auVar91 = pshuflw((undefined1  [16])0x0,auVar92,0x1b);
        auVar91 = pshufhw(auVar91,auVar91,0x1b);
        sVar7 = auVar91._0_2_;
        sVar9 = auVar91._2_2_;
        sVar11 = auVar91._4_2_;
        sVar13 = auVar91._6_2_;
        sVar15 = auVar91._8_2_;
        sVar17 = auVar91._10_2_;
        sVar19 = auVar91._12_2_;
        sVar21 = auVar91._14_2_;
        sVar23 = auVar95._0_2_;
        sVar25 = auVar95._2_2_;
        sVar27 = auVar95._4_2_;
        sVar29 = auVar95._6_2_;
        sVar31 = auVar95._8_2_;
        sVar33 = auVar95._10_2_;
        sVar35 = auVar95._12_2_;
        sVar37 = auVar95._14_2_;
        local_218[1] = (0 < sVar8) * (sVar8 < 0x100) * auVar93[2] - (0xff < sVar8);
        local_218[0] = (0 < sVar6) * (sVar6 < 0x100) * auVar93[0] - (0xff < sVar6);
        local_218[2] = (0 < sVar10) * (sVar10 < 0x100) * auVar93[4] - (0xff < sVar10);
        local_218[3] = (0 < sVar12) * (sVar12 < 0x100) * auVar93[6] - (0xff < sVar12);
        local_218[4] = (0 < sVar14) * (sVar14 < 0x100) * auVar93[8] - (0xff < sVar14);
        local_218[5] = (0 < sVar16) * (sVar16 < 0x100) * auVar93[10] - (0xff < sVar16);
        local_218[6] = (0 < sVar18) * (sVar18 < 0x100) * auVar93[0xc] - (0xff < sVar18);
        local_218[7] = (0 < sVar20) * (sVar20 < 0x100) * auVar93[0xe] - (0xff < sVar20);
        local_218[8] = (0 < sVar22) * (sVar22 < 0x100) * auVar94[0] - (0xff < sVar22);
        local_218[9] = (0 < sVar24) * (sVar24 < 0x100) * auVar94[2] - (0xff < sVar24);
        local_218[10] = (0 < sVar26) * (sVar26 < 0x100) * auVar94[4] - (0xff < sVar26);
        local_218[0xb] = (0 < sVar28) * (sVar28 < 0x100) * auVar94[6] - (0xff < sVar28);
        local_218[0xc] = (0 < sVar30) * (sVar30 < 0x100) * auVar94[8] - (0xff < sVar30);
        local_218[0xd] = (0 < sVar32) * (sVar32 < 0x100) * auVar94[10] - (0xff < sVar32);
        local_218[0xe] = (0 < sVar34) * (sVar34 < 0x100) * auVar94[0xc] - (0xff < sVar34);
        local_218[0xf] = (0 < sVar36) * (sVar36 < 0x100) * auVar94[0xe] - (0xff < sVar36);
        local_208[1] = (0 < sVar9) * (sVar9 < 0x100) * auVar91[2] - (0xff < sVar9);
        local_208[0] = (0 < sVar7) * (sVar7 < 0x100) * auVar91[0] - (0xff < sVar7);
        local_208[2] = (0 < sVar11) * (sVar11 < 0x100) * auVar91[4] - (0xff < sVar11);
        local_208[3] = (0 < sVar13) * (sVar13 < 0x100) * auVar91[6] - (0xff < sVar13);
        local_208[4] = (0 < sVar15) * (sVar15 < 0x100) * auVar91[8] - (0xff < sVar15);
        local_208[5] = (0 < sVar17) * (sVar17 < 0x100) * auVar91[10] - (0xff < sVar17);
        local_208[6] = (0 < sVar19) * (sVar19 < 0x100) * auVar91[0xc] - (0xff < sVar19);
        local_208[7] = (0 < sVar21) * (sVar21 < 0x100) * auVar91[0xe] - (0xff < sVar21);
        local_208[8] = (0 < sVar23) * (sVar23 < 0x100) * auVar95[0] - (0xff < sVar23);
        local_208[9] = (0 < sVar25) * (sVar25 < 0x100) * auVar95[2] - (0xff < sVar25);
        local_208[10] = (0 < sVar27) * (sVar27 < 0x100) * auVar95[4] - (0xff < sVar27);
        local_208[0xb] = (0 < sVar29) * (sVar29 < 0x100) * auVar95[6] - (0xff < sVar29);
        local_208[0xc] = (0 < sVar31) * (sVar31 < 0x100) * auVar95[8] - (0xff < sVar31);
        local_208[0xd] = (0 < sVar33) * (sVar33 < 0x100) * auVar95[10] - (0xff < sVar33);
        local_208[0xe] = (0 < sVar35) * (sVar35 < 0x100) * auVar95[0xc] - (0xff < sVar35);
        local_208[0xf] = (0 < sVar37) * (sVar37 < 0x100) * auVar95[0xe] - (0xff < sVar37);
      }
      local_2e8 = local_218._0_4_ ^ 0x36363636;
      uStack_2e4 = local_218._4_4_ ^ 0x36363636;
      uStack_2e0 = local_218._8_4_ ^ 0x36363636;
      uStack_2dc = local_218._12_4_ ^ 0x36363636;
      local_2d8._0_4_ = local_208._0_4_ ^ 0x36363636;
      local_2d8._4_4_ = local_208._4_4_ ^ 0x36363636;
      uStack_2d0 = local_208._8_4_ ^ 0x36363636;
      uStack_2cc = local_208._12_4_ ^ 0x36363636;
      local_2c8._0_4_ = local_1f8._0_4_ ^ 0x36363636;
      local_2c8._4_4_ = local_1f8._4_4_ ^ 0x36363636;
      uStack_2c0._0_4_ = local_1f8._8_4_ ^ 0x36363636;
      uStack_2c0._4_4_ = local_1f8._12_4_ ^ 0x36363636;
      local_2b8._0_4_ = local_1e8._0_4_ ^ 0x36363636;
      local_2b8._4_4_ = local_1e8._4_4_ ^ 0x36363636;
      uStack_2b0._0_4_ = local_1e8._8_4_ ^ 0x36363636;
      uStack_2b0._4_4_ = local_1e8._12_4_ ^ 0x36363636;
      local_208._0_8_ = 0x9b05688c510e527f;
      local_208._8_8_ = 0x5be0cd191f83d9ab;
      local_218._0_8_ = 0xbb67ae856a09e667;
      local_218._8_8_ = 0xa54ff53a3c6ef372;
      local_1f8._0_8_ = 1;
      sha2::sha256::compress256(local_218,&local_2e8,1);
      local_2e8 = local_2e8 ^ 0x6a6a6a6a;
      uStack_2e4 = uStack_2e4 ^ 0x6a6a6a6a;
      uStack_2e0 = uStack_2e0 ^ 0x6a6a6a6a;
      uStack_2dc = uStack_2dc ^ 0x6a6a6a6a;
      local_2d8._0_4_ = (uint)local_2d8 ^ 0x6a6a6a6a;
      local_2d8._4_4_ = local_2d8._4_4_ ^ 0x6a6a6a6a;
      uStack_2d0 = uStack_2d0 ^ 0x6a6a6a6a;
      uStack_2cc = uStack_2cc ^ 0x6a6a6a6a;
      local_2c8 = CONCAT44(local_2c8._4_4_,(uint)local_2c8) ^ 0x6a6a6a6a6a6a6a6a;
      uStack_2c0 = (undefined **)(CONCAT44(uStack_2c0._4_4_,(uint)uStack_2c0) ^ 0x6a6a6a6a6a6a6a6a);
      local_2b8 = CONCAT44(local_2b8._4_4_,(uint)local_2b8) ^ 0x6a6a6a6a6a6a6a6a;
      uStack_2b0 = CONCAT44(uStack_2b0._4_4_,(uint)uStack_2b0) ^ 0x6a6a6a6a6a6a6a6a;
      local_128 = 0x9b05688c510e527f;
      uStack_120 = 0x5be0cd191f83d9ab;
      local_138 = (undefined **)0xbb67ae856a09e667;
      pcStack_130 = (code *)0xa54ff53a3c6ef372;
      local_118 = 1;
      sha2::sha256::compress256(&local_138,&local_2e8,1);
      local_148 = local_1f8._0_8_;
      local_158 = local_208._0_8_;
      uStack_150 = local_208._8_8_;
      local_168 = local_218._0_8_;
      uStack_160 = local_218._8_8_;
      uStack_188 = pcStack_130;
      uStack_180 = local_128;
      uStack_178 = uStack_120;
      local_170 = local_118;
      local_1b8._8_8_ = local_218._8_8_;
      local_1b8._0_8_ = local_218._0_8_;
      local_1a8._8_8_ = local_208._8_8_;
      local_1a8._0_8_ = local_208._0_8_;
      local_198._8_8_ = local_138;
      local_198._0_8_ = local_1f8._0_8_;
      local_240 = 0;
      uStack_238 = 0;
      local_250 = 0;
      uStack_248 = 0;
      local_260 = 0;
      uStack_258 = 0;
      local_270 = 0;
      uStack_268 = 0;
      local_230 = 0;
      local_278 = local_1f8._0_8_;
      local_288 = local_208._0_8_;
      _auStack_280 = local_208._8_8_;
      local_298 = local_218._0_8_;
      uStack_290 = local_218._8_8_;
      local_2a8 = uStack_120;
      lStack_2a0 = local_118;
      local_2b8 = (ulong)pcStack_130;
      uStack_2b0 = local_128;
      local_2c8 = local_1f8._0_8_;
      uStack_2c0 = local_138;
      local_2d8._0_4_ = (uint)local_208._0_8_;
      local_2d8._4_4_ = SUB84(local_208._0_8_,4);
      uStack_2d0 = (uint)local_208._8_8_;
      uStack_2cc = SUB84(local_208._8_8_,4);
      local_2e8 = (uint)local_218._0_8_;
      uStack_2e4 = SUB84(local_218._0_8_,4);
      uStack_2e0 = (uint)local_218._8_8_;
      uStack_2dc = SUB84(local_218._8_8_,4);
      memcpy(&local_138,&local_2e8,0xc0);
      uVar71 = local_1c0;
      uVar75 = (ulong)local_80;
      uVar62 = 0x40 - uVar75;
      uVar84 = local_1c0 - uVar62;
      if (local_1c0 < uVar62) {
        memcpy(local_c0 + uVar75,param_4,local_1c0);
        uVar71 = uVar71 + uVar75;
      }
      else {
        uVar87 = local_1c0;
        if (uVar75 != 0) {
          memcpy(local_c0 + uVar75,param_4,uVar62);
          local_118 = local_118 + 1;
                    /* try { // try from 0039c7b0 to 0039c7f1 has its CatchHandler @ 0039cd10 */
          sha2::sha256::compress256(&local_138,local_c0,1);
          param_4 = (void *)((long)param_4 + uVar62);
          uVar87 = uVar84;
        }
        if (0x3f < uVar87) {
          local_118 = local_118 + (uVar87 >> 6);
          sha2::sha256::compress256(&local_138,param_4);
        }
        uVar71 = (ulong)((uint)uVar87 & 0x3f);
        memcpy(local_c0,(void *)((long)param_4 + (uVar87 & 0xffffffffffffffc0)),uVar71);
      }
      local_80 = (byte)uVar71;
      memcpy(&local_2e8,&local_138,0xc0);
      local_68 = (undefined1  [16])0x0;
      local_78 = (undefined1  [16])0x0;
      local_208 = (undefined1  [16])0x0;
      local_218 = (undefined1  [16])0x0;
                    /* try { // try from 0039c862 to 0039c8d6 has its CatchHandler @ 0039cd10 */
      _<digest::core_api::ct_variable::CtVariableCoreWrapper<T,OutSize,O>as_digest::core_api::FixedOutputCore>
      ::finalize_fixed_core(&local_2e8,&local_270,local_218);
      local_198._0_8_ = lStack_2a0;
      local_1a8._8_8_ = local_2a8;
      local_1a8._0_8_ = uStack_2b0;
      local_1b8._8_8_ = local_2b8;
      local_1b8._0_8_ = uStack_2c0;
      local_260 = local_208._0_8_;
      uStack_258 = local_208._8_8_;
      local_270 = local_218._0_8_;
      uStack_268 = local_218._8_8_;
      local_230 = 0x20;
      _<digest::core_api::ct_variable::CtVariableCoreWrapper<T,OutSize,O>as_digest::core_api::FixedOutputCore>
      ::finalize_fixed_core(local_1b8,&local_270,local_78);
      local_58 = local_78._0_8_;
      uStack_50 = local_78._8_8_;
      local_48 = local_68._0_8_;
      uStack_40 = local_68._8_8_;
      pvVar67 = calloc(0x2c,1);
      if (pvVar67 == (void *)0x0) {
                    /* try { // try from 0039cc9d to 0039ccb2 has its CatchHandler @ 0039cd10 */
                    /* WARNING: Subroutine does not return */
        alloc::raw_vec::handle_error(1,0x2c,&PTR_s__usr_local_cargo_registry_src_in_00977e10);
      }
                    /* try { // try from 0039c919 to 0039c941 has its CatchHandler @ 0039cd2e */
      uVar71 = _<base64::engine::general_purpose::GeneralPurpose_as_base64::engine::Engine>::
               internal_encode(&DAT_008366c8,&local_58,0x20,pvVar67,0x2c);
      if (0x2c < uVar71) {
                    /* try { // try from 0039cbef to 0039cc02 has its CatchHandler @ 0039cd2e */
                    /* WARNING: Subroutine does not return */
        core::slice::index::slice_start_index_len_fail(uVar71,0x2c,&PTR_DAT_0097d418);
      }
      uVar85 = -(int)uVar71 & 3;
      if (uVar85 != 0) {
        if (uVar71 == 0x2c) {
LAB_0039cc84:
                    /* try { // try from 0039cc84 to 0039cc9a has its CatchHandler @ 0039cd2e */
                    /* WARNING: Subroutine does not return */
          core::panicking::panic_bounds_check(0x2c - uVar71,0x2c - uVar71,&PTR_DAT_0096e058);
        }
        *(undefined1 *)((long)pvVar67 + uVar71) = 0x3d;
        if (uVar85 != 1) {
          if (uVar71 == 0x2b) goto LAB_0039cc84;
          *(undefined1 *)((long)pvVar67 + uVar71 + 1) = 0x3d;
          if (uVar85 != 2) {
            if (uVar71 == 0x2a) goto LAB_0039cc84;
            *(undefined1 *)((long)pvVar67 + uVar71 + 2) = 0x3d;
          }
        }
      }
      core::str::converts::from_utf8(&local_2e8,pvVar67,0x2c);
      uVar76 = uStack_2dc;
      uVar85 = uStack_2e0;
      if (local_2e8 == 1) {
        local_2c8 = CONCAT44(local_2d8._4_4_,(uint)local_2d8);
        local_2e8 = 0x2c;
        uStack_2e4 = 0;
        uStack_2e0 = (uint)pvVar67;
        uStack_2dc = (uint)((ulong)pvVar67 >> 0x20);
        local_2d8._0_4_ = 0x2c;
        local_2d8._4_4_ = 0;
        uStack_2d0 = uVar85;
        uStack_2cc = uVar76;
                    /* try { // try from 0039ccd8 to 0039ccfb has its CatchHandler @ 0039ccfe */
                    /* WARNING: Subroutine does not return */
        core::result::unwrap_failed
                  ("Invalid UTF8",0xc,&local_2e8,
                   &PTR_drop_in_place<alloc::string::FromUtf8Error>_00977da0,
                   &PTR_s__usr_local_cargo_registry_src_in_00977e28);
      }
      local_220[1] = 0x2c;
      local_220[2] = pvVar67;
      local_220[3] = 0x2c;
      *local_220 = 3;
      if (uVar83 == 0) {
        return;
      }
      free(local_310);
      return;
    }
    uVar71 = (uVar71 + uVar84) - 1;
    uVar62 = (ulong)bVar90 << 8 | 2;
  }
  else {
    pbVar74 = (byte *)(param_2 + 3);
    bVar90 = *(byte *)(param_2 + 2);
    uVar87 = (ulong)bVar90;
    iVar44 = (int)pbVar1;
    if (uVar87 == 0x3d) {
      iVar77 = iVar44 - (int)(byte *)(param_2 + 2);
      if (pbVar74 == pbVar1) goto LAB_0039c077;
      uVar87 = 3;
      uVar85 = 0;
      do {
        if (*(char *)(param_2 + uVar87) != '=') {
          lVar73 = 2;
          goto LAB_0039ca3e;
        }
        if (uVar87 == 0) goto LAB_0039bcee;
        uVar87 = uVar87 + 1;
        bVar90 = bVar89;
      } while (param_3 - uVar84 != uVar87);
      goto LAB_0039c079;
    }
    uVar85 = (uint)(byte)(&DAT_0083670b)[uVar87];
    if ((&DAT_0083670b)[uVar87] == 0xff) {
      lVar88 = 2;
      goto LAB_0039bf4b;
    }
    if (pbVar74 == pbVar1) {
      uVar71 = 3;
      iVar77 = 0;
      goto LAB_0039c079;
    }
    bVar89 = *(byte *)(param_2 + 3);
    if (bVar89 == 0x3d) {
      iVar77 = iVar44 - (int)pbVar74;
      if ((byte *)(param_2 + 4) == pbVar1) {
        uVar71 = 3;
        uVar76 = 0;
      }
      else {
        uVar76 = 0;
        uVar87 = 4;
        do {
          lVar73 = 3;
          uVar68 = uVar87 + 1;
          bVar89 = *(byte *)(param_2 + uVar87);
          if (bVar89 != 0x3d) {
            if (uVar87 != 3) goto LAB_0039ca3e;
            uVar87 = (ulong)bVar89;
            bVar2 = (&DAT_0083670b)[uVar87];
            bVar90 = bVar89;
            if (bVar2 != 0xff) goto LAB_0039ca71;
            lVar88 = 3;
            goto LAB_0039bf4b;
          }
          if (uVar87 < 2) {
            lVar88 = 0;
            goto LAB_0039bcf1;
          }
          uVar71 = 3;
          uVar87 = uVar68;
        } while (param_3 - uVar84 != uVar68);
      }
      goto LAB_0039c07c;
    }
    lVar88 = 3;
    uVar87 = (ulong)bVar89;
    bVar2 = (&DAT_0083670b)[uVar87];
    bVar90 = bVar89;
    if (bVar2 != 0xff) {
LAB_0039ca71:
      pbVar74 = (byte *)(param_2 + 4);
      uVar76 = (uint)bVar2;
      uVar71 = 4;
      if (pbVar74 == pbVar1) {
        iVar77 = 0;
      }
      else {
        bVar89 = *pbVar74;
        if (bVar89 != 0x3d) {
LAB_0039cb32:
          lVar88 = 4;
          uVar87 = (ulong)bVar89;
          if ((&DAT_0083670b)[uVar87] != -1) {
                    /* WARNING: Subroutine does not return */
            core::panicking::panic_bounds_check
                      (4,4,&PTR_s__usr_local_cargo_registry_src_in_0096e040);
          }
          goto LAB_0039bf4b;
        }
        iVar77 = iVar44 - (int)pbVar74;
        if ((byte *)(param_2 + 5) != pbVar1) {
          lVar88 = 1;
          while( true ) {
            lVar73 = 4;
            bVar89 = pbVar74[lVar88];
            if (bVar89 != 0x3d) break;
            if (lVar88 + 4U < 2) {
              lVar88 = lVar88 + 4;
              goto LAB_0039bcf1;
            }
            lVar73 = lVar88 + 1;
            lVar88 = lVar88 + 1;
            if (pbVar74 + lVar73 == pbVar1) goto LAB_0039c07c;
          }
          if (lVar88 == 0) goto LAB_0039cb32;
LAB_0039ca3e:
          uVar71 = lVar73 + uVar84;
          uVar62 = 0x3d00;
          goto LAB_0039bfda;
        }
      }
      goto LAB_0039c07c;
    }
LAB_0039bf4b:
    uVar71 = lVar88 + uVar84;
    uVar62 = (ulong)(uint)((int)uVar87 << 8);
  }
  if ((char)uVar62 == '\x04') {
LAB_0039cc1f:
    local_138 = &PTR_s_Vec_is_sized_conservatively_00977dd8;
    pcStack_130 = _<&T_as_core::fmt::Display>::fmt;
    local_2e8 = 0x977de8;
    uStack_2e4 = 0;
    uStack_2e0 = 1;
    uStack_2dc = 0;
    local_2c8 = 0;
    local_2d8 = &local_138;
    uStack_2d0 = 1;
    uStack_2cc = 0;
                    /* try { // try from 0039cc71 to 0039cc81 has its CatchHandler @ 0039cd43 */
                    /* WARNING: Subroutine does not return */
    core::panicking::panic_fmt(&local_2e8,&PTR_s__usr_local_cargo_registry_src_in_00977df8);
  }
LAB_0039bfda:
  if (uVar83 != 0) {
    free(local_310);
  }
  puVar65 = malloc(0x10);
  if (puVar65 != (ulong *)0x0) {
    *puVar65 = uVar62;
    puVar65[1] = uVar71;
                    /* try { // try from 0039c00f to 0039c018 has its CatchHandler @ 0039cd15 */
    std::backtrace::Backtrace::capture(&local_2e8);
    *(undefined1 *)(local_220 + 8) = 3;
    local_220[6] = puVar65;
    local_220[7] = &DAT_00977a78;
    *local_220 = CONCAT44(uStack_2e4,local_2e8);
    local_220[1] = CONCAT44(uStack_2dc,uStack_2e0);
    local_220[2] = CONCAT44(local_2d8._4_4_,(uint)local_2d8);
    local_220[3] = CONCAT44(uStack_2cc,uStack_2d0);
    local_220[4] = local_2c8;
    local_220[5] = uStack_2c0;
    return;
  }
                    /* WARNING: Subroutine does not return */
  alloc::alloc::handle_alloc_error(8,0x10);
}


