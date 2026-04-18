// polymarket_client_sdk::error::Error::validation
// entry = 001669c0


/* polymarket_client_sdk::error::Error::validation */

void __rustcall
polymarket_client_sdk::error::Error::validation(undefined8 param_1,void *param_2,size_t param_3)

{
  void *__dest;
  size_t local_38;
  void *local_30;
  size_t local_28;
  
  __dest = malloc(param_3);
  if (__dest != (void *)0x0) {
    memcpy(__dest,param_2,param_3);
    local_38 = param_3;
    local_30 = __dest;
    local_28 = param_3;
    _<polymarket_client_sdk::error::Error_as_core::convert::From<polymarket_client_sdk::error::Validation>>
    ::from(param_1,&local_38);
    return;
  }
                    /* WARNING: Subroutine does not return */
  alloc::raw_vec::handle_error(1,param_3,&PTR_s__rustc_6b00bc3880198600130e1cf62_00987e78);
}


