// polymarket_client_sdk::error::Error::status
// entry = 00166a40


/* polymarket_client_sdk::error::Error::status */

void __rustcall
polymarket_client_sdk::error::Error::status
          (undefined8 param_1,undefined1 *param_2,undefined4 *param_3,undefined8 *param_4)

{
  undefined1 uVar1;
  undefined8 uVar2;
  undefined8 uVar3;
  undefined4 uVar4;
  undefined4 uVar5;
  undefined4 uVar6;
  undefined8 uVar7;
  undefined8 uVar8;
  undefined4 local_88;
  undefined4 uStack_84;
  undefined4 uStack_80;
  undefined4 uStack_7c;
  undefined8 local_78;
  long local_70;
  undefined8 *local_68;
  undefined8 local_60;
  undefined1 local_58;
  undefined3 local_57;
  undefined1 uStack_54;
  undefined3 uStack_53;
  undefined8 local_50;
  undefined8 local_48;
  undefined2 local_40;
  
  uVar1 = *param_2;
  uVar2 = *(undefined8 *)(param_2 + 8);
  uVar3 = *(undefined8 *)(param_2 + 0x10);
  local_68 = malloc(0x21);
  local_70 = (ulong)(local_68 != (undefined8 *)0x0) * 0x20 + 1;
  if (local_68 == (undefined8 *)0x0) {
                    /* try { // try from 00166b29 to 00166b41 has its CatchHandler @ 00166b44 */
                    /* WARNING: Subroutine does not return */
    alloc::raw_vec::handle_error(1,0x21,&PTR_s__rustc_6b00bc3880198600130e1cf62_00987e78);
  }
  *(undefined1 *)(local_68 + 4) = *(undefined1 *)(param_4 + 4);
  uVar7 = *param_4;
  uVar8 = param_4[1];
  uVar4 = *(undefined4 *)((long)param_4 + 0x14);
  uVar5 = *(undefined4 *)(param_4 + 3);
  uVar6 = *(undefined4 *)((long)param_4 + 0x1c);
  *(undefined4 *)(local_68 + 2) = *(undefined4 *)(param_4 + 2);
  *(undefined4 *)((long)local_68 + 0x14) = uVar4;
  *(undefined4 *)(local_68 + 3) = uVar5;
  *(undefined4 *)((long)local_68 + 0x1c) = uVar6;
  *local_68 = uVar7;
  local_68[1] = uVar8;
  local_40 = 0x194;
  local_57 = (undefined3)*(undefined4 *)(param_2 + 1);
  uStack_54 = (undefined1)*(undefined4 *)(param_2 + 4);
  uStack_53 = (undefined3)((uint)*(undefined4 *)(param_2 + 4) >> 8);
  local_88 = *param_3;
  uStack_84 = param_3[1];
  uStack_80 = param_3[2];
  uStack_7c = param_3[3];
  local_78 = *(undefined8 *)(param_3 + 4);
  local_60 = 0x21;
  local_58 = uVar1;
  local_50 = uVar2;
  local_48 = uVar3;
  _<polymarket_client_sdk::error::Error_as_core::convert::From<polymarket_client_sdk::error::Status>>
  ::from(param_1,&local_88);
  return;
}


