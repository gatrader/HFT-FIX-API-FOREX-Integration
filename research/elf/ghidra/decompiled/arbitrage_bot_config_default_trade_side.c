// arbitrage_bot::config::default_trade_side
// entry = 00276fc0


/* arbitrage_bot::config::default_trade_side */

void __rustcall arbitrage_bot::config::default_trade_side(undefined8 *param_1)

{
  undefined2 *puVar1;
  
  puVar1 = malloc(2);
  if (puVar1 != (undefined2 *)0x0) {
    *puVar1 = 0x7075;
    *param_1 = 2;
    param_1[1] = puVar1;
    param_1[2] = 2;
    return;
  }
                    /* WARNING: Subroutine does not return */
  alloc::raw_vec::handle_error(1,2,&PTR_s__rustc_6b00bc3880198600130e1cf62_00987e78);
}


