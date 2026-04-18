// arbitrage_bot::config::BotConfig::load_from_file
// entry = 00277010


/* arbitrage_bot::config::BotConfig::load_from_file */

void __rustcall
arbitrage_bot::config::BotConfig::load_from_file
          (long *param_1,undefined8 param_2,undefined8 param_3)

{
  long lVar1;
  undefined1 *puVar2;
  ulong uVar3;
  undefined **ppuVar4;
  undefined8 *local_390;
  code *local_388;
  undefined8 local_380;
  void *local_378;
  ulong local_370;
  ulong local_368;
  undefined8 uStack_360;
  void *local_358;
  ulong local_350;
  undefined1 local_348;
  void *local_340;
  void *local_338;
  void *local_330;
  long local_328;
  undefined1 *local_320;
  undefined **local_318;
  long local_310;
  undefined8 local_308;
  undefined8 local_300;
  undefined8 *local_2f8;
  code *local_2f0;
  undefined **local_2e0;
  undefined1 *local_2d8;
  undefined8 **local_2d0;
  long local_2c8;
  void *local_2c0;
  long local_2b0;
  void *local_2a8;
  ulong local_298;
  void *local_290;
  long local_1f0;
  void *local_1e8;
  ulong local_1e0;
  undefined1 local_110 [224];
  
  local_308 = param_2;
  local_300 = param_3;
  std::fs::read_to_string::inner(&local_1f0);
  if (SBORROW8(0,local_1f0)) {
    local_390 = &local_308;
    local_388 = _<&T_as_core::fmt::Display>::fmt;
    local_2e0 = &PTR_DAT_0096d770;
    local_2d8 = (undefined1 *)0x1;
    local_2c0 = (void *)0x0;
    local_2d0 = &local_390;
    local_2c8 = 1;
                    /* try { // try from 00277345 to 00277359 has its CatchHandler @ 00277441 */
    alloc::fmt::format::format_inner(local_110,&local_2e0);
    lVar1 = _<E_as_anyhow::context::ext::StdError>::ext_context(local_1e8,local_110);
    param_1[1] = lVar1;
    *param_1 = -0x8000000000000000;
  }
  else {
    local_378 = local_1e8;
    local_370 = local_1e0;
    local_368 = 0;
    uStack_360 = 0;
    local_358 = local_1e8;
    local_350 = local_1e0;
    local_390 = (undefined8 *)0x0;
    local_388 = (code *)&DAT_00000001;
    local_380 = 0;
    local_348 = 0x80;
                    /* try { // try from 002770ab to 002770bc has its CatchHandler @ 00277453 */
    _<&mut_serde_json::de::Deserializer<R>as_serde_core::de::Deserializer>::deserialize_struct
              (&local_2e0,&local_390);
    puVar2 = local_2d8;
    ppuVar4 = local_2e0;
    if (local_2e0 == (undefined **)0x8000000000000000) {
      memcpy(local_110,&local_2d0,0xe0);
LAB_002770f1:
      ppuVar4 = (undefined **)0x8000000000000000;
    }
    else {
      if (local_368 < local_370) {
        local_318 = local_2e0;
        local_320 = local_2d8;
        local_310 = local_2c8;
        do {
          uVar3 = local_368 + 1;
          if ((0x20 < (ulong)*(byte *)((long)local_378 + local_368)) ||
             ((0x100002600U >> ((ulong)*(byte *)((long)local_378 + local_368) & 0x3f) & 1) == 0)) {
            local_338 = local_2c0;
            local_340 = local_290;
            local_328 = local_2b0;
            local_330 = local_2a8;
            local_2f8 = (undefined8 *)0x16;
                    /* try { // try from 00277399 to 002773aa has its CatchHandler @ 00277418 */
            puVar2 = (undefined1 *)
                     serde_json::de::Deserializer<R>::peek_error(&local_390,&local_2f8);
            if (local_318 != (undefined **)0x0) {
              free(local_320);
            }
            if (local_310 != 0) {
              free(local_338);
            }
            if ((local_298 & 0x7fffffffffffffff) != 0) {
              free(local_340);
            }
            if (local_328 == 0) goto LAB_002770f1;
            free(local_330);
            ppuVar4 = (undefined **)0x8000000000000000;
            goto joined_r0x0027740d;
          }
          local_368 = uVar3;
        } while (uVar3 != local_370);
      }
      memcpy(local_110,&local_2d0,0xe0);
    }
joined_r0x0027740d:
    if (local_390 != (undefined8 *)0x0) {
      free(local_388);
    }
    if (ppuVar4 == (undefined **)0x8000000000000000) {
      local_2f8 = &local_308;
      local_2f0 = _<&T_as_core::fmt::Display>::fmt;
      local_2e0 = &PTR_DAT_0096d780;
      local_2d8 = &DAT_00000001;
      local_2c0 = (void *)0x0;
      local_2d0 = &local_2f8;
      local_2c8 = 1;
                    /* try { // try from 00277172 to 00277183 has its CatchHandler @ 0027742f */
      alloc::fmt::format::format_inner(&local_390,&local_2e0);
                    /* try { // try from 00277184 to 00277190 has its CatchHandler @ 0027742a */
      lVar1 = _<E_as_anyhow::context::ext::StdError>::ext_context(puVar2,&local_390);
      param_1[1] = lVar1;
      *param_1 = -0x8000000000000000;
    }
    else {
      memcpy(&local_1f0,local_110,0xe0);
      memcpy(param_1 + 2,&local_1f0,0xe0);
      *param_1 = (long)ppuVar4;
      param_1[1] = (long)puVar2;
    }
    if (local_1f0 != 0) {
      free(local_1e8);
    }
  }
  return;
}


