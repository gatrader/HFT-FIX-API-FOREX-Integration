// _<polymarket_client_sdk::error::Error_as_core::convert::From<polymarket_client_sdk::error::Status>>::from
// entry = 0039ea20


/* _<polymarket_client_sdk::error::Error as
   core::convert::From<polymarket_client_sdk::error::Status>>::from */

void __rustcall
_<polymarket_client_sdk::error::Error_as_core::convert::From<polymarket_client_sdk::error::Status>>
::from(undefined8 *param_1,undefined4 *param_2)

{
  undefined4 uVar1;
  undefined4 uVar2;
  undefined4 uVar3;
  undefined4 uVar4;
  undefined4 uVar5;
  undefined4 uVar6;
  undefined4 uVar7;
  undefined4 uVar8;
  undefined4 uVar9;
  undefined4 uVar10;
  undefined4 uVar11;
  undefined4 uVar12;
  undefined4 uVar13;
  undefined4 uVar14;
  undefined4 uVar15;
  undefined8 uVar16;
  undefined4 *puVar17;
  undefined8 local_48;
  undefined8 uStack_40;
  undefined8 local_38;
  undefined8 uStack_30;
  undefined8 local_28;
  undefined8 uStack_20;
  
  puVar17 = malloc(0x50);
  if (puVar17 != (undefined4 *)0x0) {
    uVar16 = *(undefined8 *)(param_2 + 0x12);
    *(undefined8 *)(puVar17 + 0x10) = *(undefined8 *)(param_2 + 0x10);
    *(undefined8 *)(puVar17 + 0x12) = uVar16;
    uVar1 = *param_2;
    uVar2 = param_2[1];
    uVar3 = param_2[2];
    uVar4 = param_2[3];
    uVar5 = param_2[4];
    uVar6 = param_2[5];
    uVar7 = param_2[6];
    uVar8 = param_2[7];
    uVar9 = param_2[8];
    uVar10 = param_2[9];
    uVar11 = param_2[10];
    uVar12 = param_2[0xb];
    uVar13 = param_2[0xd];
    uVar14 = param_2[0xe];
    uVar15 = param_2[0xf];
    puVar17[0xc] = param_2[0xc];
    puVar17[0xd] = uVar13;
    puVar17[0xe] = uVar14;
    puVar17[0xf] = uVar15;
    puVar17[8] = uVar9;
    puVar17[9] = uVar10;
    puVar17[10] = uVar11;
    puVar17[0xb] = uVar12;
    puVar17[4] = uVar5;
    puVar17[5] = uVar6;
    puVar17[6] = uVar7;
    puVar17[7] = uVar8;
    *puVar17 = uVar1;
    puVar17[1] = uVar2;
    puVar17[2] = uVar3;
    puVar17[3] = uVar4;
                    /* try { // try from 0039ea74 to 0039ea7b has its CatchHandler @ 0039eac3 */
    std::backtrace::Backtrace::capture(&local_48);
    *(undefined1 *)(param_1 + 8) = 0;
    param_1[6] = puVar17;
    param_1[7] = &PTR_drop_in_place<polymarket_client_sdk::error::Status>_00977af0;
    *param_1 = local_48;
    param_1[1] = uStack_40;
    param_1[2] = local_38;
    param_1[3] = uStack_30;
    param_1[4] = local_28;
    param_1[5] = uStack_20;
    return;
  }
                    /* try { // try from 0039eab2 to 0039eac0 has its CatchHandler @ 0039eadc */
                    /* WARNING: Subroutine does not return */
  alloc::alloc::handle_alloc_error(8,0x50);
}


