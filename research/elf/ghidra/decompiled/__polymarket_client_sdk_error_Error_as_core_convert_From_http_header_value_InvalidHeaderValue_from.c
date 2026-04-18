// _<polymarket_client_sdk::error::Error_as_core::convert::From<http::header::value::InvalidHeaderValue>>::from
// entry = 0039d790


/* _<polymarket_client_sdk::error::Error as
   core::convert::From<http::header::value::InvalidHeaderValue>>::from */

void __rustcall
_<polymarket_client_sdk::error::Error_as_core::convert::From<http::header::value::InvalidHeaderValue>>
::from(undefined8 *param_1)

{
  undefined8 local_38;
  undefined8 uStack_30;
  undefined8 local_28;
  undefined8 uStack_20;
  undefined8 local_18;
  undefined8 uStack_10;
  
                    /* try { // try from 0039d798 to 0039d79f has its CatchHandler @ 0039d7d6 */
  std::backtrace::Backtrace::capture(&local_38);
  *(undefined1 *)(param_1 + 8) = 3;
  param_1[6] = 1;
  param_1[7] = &DAT_00977c38;
  *param_1 = local_38;
  param_1[1] = uStack_30;
  param_1[2] = local_28;
  param_1[3] = uStack_20;
  param_1[4] = local_18;
  param_1[5] = uStack_10;
  return;
}


