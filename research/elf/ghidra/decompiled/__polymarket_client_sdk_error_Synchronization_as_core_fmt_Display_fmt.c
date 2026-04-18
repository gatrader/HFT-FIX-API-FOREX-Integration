// _<polymarket_client_sdk::error::Synchronization_as_core::fmt::Display>::fmt
// entry = 0039d3b0


/* _<polymarket_client_sdk::error::Synchronization as core::fmt::Display>::fmt */

void __rustcall
_<polymarket_client_sdk::error::Synchronization_as_core::fmt::Display>::fmt
          (undefined8 param_1,undefined8 *param_2)

{
                    /* WARNING: Could not recover jumptable at 0x0039d3c7. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (**(code **)(param_2[1] + 0x18))
            (*param_2,"synchronization error: multiple threads are attempting to log in or log out",
             0x4b);
  return;
}


