// _<polymarket_client_sdk::error::Error_as_core::convert::From<alloy_signer::error::Error>>::from
// entry = 0039d8b0


/* _<polymarket_client_sdk::error::Error as core::convert::From<alloy_signer::error::Error>>::from
    */

void __rustcall
_<polymarket_client_sdk::error::Error_as_core::convert::From<alloy_signer::error::Error>>::from
          (undefined8 *param_1,undefined4 *param_2)

{
  undefined4 uVar1;
  undefined4 uVar2;
  undefined4 uVar3;
  undefined4 *puVar4;
  undefined8 local_48;
  undefined8 uStack_40;
  undefined8 local_38;
  undefined8 uStack_30;
  undefined8 local_28;
  undefined8 uStack_20;
  
  puVar4 = malloc(0x18);
  if (puVar4 != (undefined4 *)0x0) {
    *(undefined8 *)(puVar4 + 4) = *(undefined8 *)(param_2 + 4);
    uVar1 = param_2[1];
    uVar2 = param_2[2];
    uVar3 = param_2[3];
    *puVar4 = *param_2;
    puVar4[1] = uVar1;
    puVar4[2] = uVar2;
    puVar4[3] = uVar3;
                    /* try { // try from 0039d8e9 to 0039d8f0 has its CatchHandler @ 0039d938 */
    std::backtrace::Backtrace::capture(&local_48);
    *(undefined1 *)(param_1 + 8) = 3;
    param_1[6] = puVar4;
    param_1[7] = &PTR_drop_in_place<alloy_signer::error::Error>_00977a00;
    *param_1 = local_48;
    param_1[1] = uStack_40;
    param_1[2] = local_38;
    param_1[3] = uStack_30;
    param_1[4] = local_28;
    param_1[5] = uStack_20;
    return;
  }
                    /* try { // try from 0039d927 to 0039d935 has its CatchHandler @ 0039d951 */
                    /* WARNING: Subroutine does not return */
  alloc::alloc::handle_alloc_error(8,0x18);
}


