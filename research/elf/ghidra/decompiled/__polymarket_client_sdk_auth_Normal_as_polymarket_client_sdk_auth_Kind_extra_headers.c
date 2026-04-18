// _<polymarket_client_sdk::auth::Normal_as_polymarket_client_sdk::auth::Kind>::extra_headers
// entry = 0039ce80


/* _<polymarket_client_sdk::auth::Normal as polymarket_client_sdk::auth::Kind>::extra_headers */

void __rustcall
_<polymarket_client_sdk::auth::Normal_as_polymarket_client_sdk::auth::Kind>::extra_headers
          (undefined8 param_1,undefined8 param_2)

{
  undefined8 *puVar1;
  
  puVar1 = malloc(0x18);
  if (puVar1 != (undefined8 *)0x0) {
    *puVar1 = param_1;
    puVar1[1] = param_2;
    *(undefined1 *)(puVar1 + 2) = 0;
    return;
  }
                    /* WARNING: Subroutine does not return */
  alloc::alloc::handle_alloc_error(8,0x18);
}


