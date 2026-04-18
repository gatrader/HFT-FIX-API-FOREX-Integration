// rust_decimal::arithmetic_impls::_<impl_core::ops::arith::Mul_for_rust_decimal::decimal::Decimal>::mul
// entry = 001d9400


/* rust_decimal::arithmetic_impls::_<impl core::ops::arith::Mul for
   rust_decimal::decimal::Decimal>::mul */

void __rustcall
rust_decimal::arithmetic_impls::_<impl_core::ops::arith::Mul_for_rust_decimal::decimal::Decimal>::
mul(undefined8 *param_1)

{
  int local_4c;
  undefined8 local_48;
  undefined8 uStack_40;
  undefined *local_38;
  undefined8 local_30;
  undefined8 local_28;
  undefined8 local_20;
  undefined8 uStack_18;
  
  ops::mul::mul_impl(&local_4c);
  if (local_4c == 0) {
    *param_1 = local_48;
    param_1[1] = uStack_40;
    return;
  }
  local_38 = &DAT_00967bf0;
  local_30 = 1;
  local_28 = 8;
  local_20 = 0;
  uStack_18 = 0;
                    /* WARNING: Subroutine does not return */
  core::panicking::panic_fmt(&local_38,&DAT_00967c00);
}


