// arbitrage_bot::trading::client::TradingClient::get_api_creds
// entry = 002a68c0


/* arbitrage_bot::trading::client::TradingClient::get_api_creds */

void __rustcall
arbitrage_bot::trading::client::TradingClient::get_api_creds(size_t *param_1,long param_2)

{
  size_t __size;
  void *pvVar1;
  size_t __size_00;
  size_t __size_01;
  undefined1 *__dest;
  undefined1 *__dest_00;
  undefined1 *__dest_01;
  
  if (SBORROW8(0,*(long *)(param_2 + 0x100))) {
    *param_1 = 0x8000000000000000;
  }
  else {
    __size = *(size_t *)(param_2 + 0x110);
    if ((long)__size < 0) {
                    /* WARNING: Subroutine does not return */
      alloc::raw_vec::capacity_overflow(&PTR_DAT_00967518);
    }
    pvVar1 = *(void **)(param_2 + 0x108);
    if (__size == 0) {
      __dest = &DAT_00000001;
    }
    else {
      __dest = malloc(__size);
      if (__dest == (undefined1 *)0x0) {
                    /* WARNING: Subroutine does not return */
        alloc::alloc::handle_alloc_error(1,__size);
      }
    }
    memcpy(__dest,pvVar1,__size);
    __size_00 = *(size_t *)(param_2 + 0x128);
    if ((long)__size_00 < 0) {
                    /* try { // try from 002a6a26 to 002a6a31 has its CatchHandler @ 002a6a80 */
                    /* WARNING: Subroutine does not return */
      alloc::raw_vec::capacity_overflow(&PTR_DAT_00967518);
    }
    pvVar1 = *(void **)(param_2 + 0x120);
    if (__size_00 == 0) {
      __dest_00 = &DAT_00000001;
    }
    else {
      __dest_00 = malloc(__size_00);
      if (__dest_00 == (undefined1 *)0x0) {
                    /* try { // try from 002a6a4f to 002a6a5b has its CatchHandler @ 002a6a80 */
                    /* WARNING: Subroutine does not return */
        alloc::alloc::handle_alloc_error(1,__size_00);
      }
    }
    memcpy(__dest_00,pvVar1,__size_00);
    __size_01 = *(size_t *)(param_2 + 0x140);
    if ((long)__size_01 < 0) {
                    /* try { // try from 002a6a34 to 002a6a3f has its CatchHandler @ 002a6a6d */
                    /* WARNING: Subroutine does not return */
      alloc::raw_vec::capacity_overflow(&PTR_DAT_00967518);
    }
    pvVar1 = *(void **)(param_2 + 0x138);
    if (__size_01 == 0) {
      __dest_01 = &DAT_00000001;
    }
    else {
      __dest_01 = malloc(__size_01);
      if (__dest_01 == (undefined1 *)0x0) {
                    /* try { // try from 002a6a5e to 002a6a6a has its CatchHandler @ 002a6a6d */
                    /* WARNING: Subroutine does not return */
        alloc::alloc::handle_alloc_error(1,__size_01);
      }
    }
    memcpy(__dest_01,pvVar1,__size_01);
    *param_1 = __size;
    param_1[1] = (size_t)__dest;
    param_1[2] = __size;
    param_1[3] = __size_00;
    param_1[4] = (size_t)__dest_00;
    param_1[5] = __size_00;
    param_1[6] = __size_01;
    param_1[7] = (size_t)__dest_01;
    param_1[8] = __size_01;
  }
  return;
}


