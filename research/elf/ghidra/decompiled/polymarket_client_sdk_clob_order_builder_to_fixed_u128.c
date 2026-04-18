// polymarket_client_sdk::clob::order_builder::to_fixed_u128
// entry = 003a29d0


/* polymarket_client_sdk::clob::order_builder::to_fixed_u128 */

long __rustcall polymarket_client_sdk::clob::order_builder::to_fixed_u128(uint *param_1)

{
  undefined1 auVar1 [16];
  undefined1 auVar2 [16];
  long lVar3;
  ulong uVar4;
  ulong uVar5;
  uint uVar6;
  ulong uVar7;
  ulong uVar8;
  uint uVar9;
  uint local_40;
  uint local_3c;
  uint local_38;
  uint local_34;
  int local_30;
  uint local_2c;
  long local_28;
  
  local_3c = param_1[1];
  local_38 = param_1[2];
  uVar5 = (ulong)local_38;
  local_34 = param_1[3];
  uVar8 = (ulong)local_34;
  if ((local_38 == 0 && local_3c == 0) && local_34 == 0) {
    local_40 = 0;
  }
  else {
    local_40 = *param_1;
    uVar9 = local_40 >> 0x10 & 0xff;
    if (uVar9 != 0) {
      do {
        uVar6 = local_3c / 10;
        uVar4 = uVar8 | (ulong)(local_3c % 10) << 0x20;
        auVar1._8_8_ = 0;
        auVar1._0_8_ = uVar4;
        uVar7 = uVar5 | (ulong)(uint)((int)uVar8 +
                                     SUB164(auVar1 * ZEXT816(0x199999999999999a),8) * -10) << 0x20;
        auVar2._8_8_ = 0;
        auVar2._0_8_ = uVar7;
        uVar7 = uVar7 * -0x3333333333333333;
        if (0x1999999999999999 < (uVar7 >> 1 | (ulong)((uVar7 & 1) != 0) << 0x3f))
        goto LAB_003a2a97;
        uVar5 = (ulong)SUB164(auVar2 * ZEXT816(0x199999999999999a),8);
        uVar8 = uVar4 / 10 & 0xffffffff;
        local_3c = local_3c / 10;
        uVar9 = uVar9 - 1;
      } while (uVar9 != 0);
      uVar9 = 0;
      local_3c = uVar6;
LAB_003a2a97:
      local_34 = (uint)uVar8;
      local_38 = (uint)uVar5;
      local_40 = local_40 & 0x80000000 | uVar9 << 0x10;
    }
  }
  rust_decimal::decimal::Decimal::trunc_with_scale(&local_30,&local_40,6);
  uVar5 = -(ulong)(local_28 != 0) - (ulong)local_2c;
  lVar3 = -local_28;
  if (-1 < local_30) {
    uVar5 = (ulong)local_2c;
    lVar3 = local_28;
  }
  if (-1 < (long)uVar5) {
    return lVar3;
  }
                    /* WARNING: Subroutine does not return */
  core::option::expect_failed
            ("The `build` call in `OrderBuilder<S, OrderKind, K>` ensures that only positive values are being multiplied/divided"
             ,0x72,&PTR_s__usr_local_cargo_git_checkouts_r_00977e78);
}


