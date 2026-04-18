// _<polymarket_client_sdk::error::Error_as_core::fmt::Debug>::fmt
// entry = 00294880


/* _<polymarket_client_sdk::error::Error as core::fmt::Debug>::fmt */

ulong __rustcall
_<polymarket_client_sdk::error::Error_as_core::fmt::Debug>::fmt(long param_1,undefined8 *param_2)

{
  code *pcVar1;
  char cVar2;
  byte bVar3;
  ulong uVar4;
  undefined8 uVar6;
  char *pcVar7;
  undefined8 uVar8;
  undefined1 local_69;
  undefined8 *local_68;
  byte local_60;
  byte local_5f;
  undefined4 local_58;
  undefined4 uStack_54;
  undefined4 uStack_50;
  undefined4 uStack_4c;
  undefined1 *local_48;
  long local_38;
  long lVar5;
  
  uVar8 = *param_2;
  pcVar1 = *(code **)(param_2[1] + 0x18);
  local_38 = param_1;
  cVar2 = (*pcVar1)(uVar8,&DAT_0084720e,5);
  bVar3 = 1;
  local_68 = param_2;
  if (cVar2 == '\0') {
    if ((*(byte *)((long)param_2 + 0x12) & 0x80) == 0) {
      cVar2 = (*pcVar1)(uVar8,&DAT_0083bcf5,3);
      bVar3 = 1;
      if (((cVar2 == '\0') &&
          (cVar2 = (**(code **)(param_2[1] + 0x18))(*param_2,"kind",4), cVar2 == '\0')) &&
         (cVar2 = (**(code **)(param_2[1] + 0x18))(*param_2,": ",2), cVar2 == '\0')) {
        bVar3 = (**(code **)(param_2[1] + 0x18))
                          (*param_2,(&PTR_s_Status_0096d668)[*(byte *)(param_1 + 0x40)],
                           *(undefined8 *)(&DAT_007dd5f0 + (ulong)*(byte *)(param_1 + 0x40) * 8));
      }
    }
    else {
      cVar2 = (*pcVar1)(uVar8,&DAT_007e4b2c,3);
      bVar3 = 1;
      if (cVar2 == '\0') {
        local_69 = 1;
        local_58 = *(undefined4 *)param_2;
        uStack_54 = *(undefined4 *)((long)param_2 + 4);
        uStack_50 = *(undefined4 *)(param_2 + 1);
        uStack_4c = *(undefined4 *)((long)param_2 + 0xc);
        local_48 = &local_69;
        cVar2 = _<core::fmt::builders::PadAdapter_as_core::fmt::Write>::write_str
                          (&local_58,"kind",4);
        if (((cVar2 == '\0') &&
            (cVar2 = _<core::fmt::builders::PadAdapter_as_core::fmt::Write>::write_str
                               (&local_58,": ",2), cVar2 == '\0')) &&
           (cVar2 = _<core::fmt::builders::PadAdapter_as_core::fmt::Write>::write_str
                              (&local_58,(&PTR_s_Status_0096d668)[*(byte *)(param_1 + 0x40)],
                               *(undefined8 *)(&DAT_007dd5f0 + (ulong)*(byte *)(param_1 + 0x40) * 8)
                              ), cVar2 == '\0')) {
          bVar3 = _<core::fmt::builders::PadAdapter_as_core::fmt::Write>::write_str
                            (&local_58,",\n",2);
        }
      }
    }
  }
  local_5f = 1;
  local_60 = bVar3;
  core::fmt::builders::DebugStruct::field
            (&local_68,&DAT_00839398,6,param_1 + 0x30,
             _<core::option::Option<T>as_core::fmt::Debug>::fmt);
  core::fmt::builders::DebugStruct::field
            (&local_68,"backtrace",9,&local_38,_<&T_as_core::fmt::Debug>::fmt);
  if (((~local_5f | local_60) & 1) == 0) {
    if ((*(byte *)((long)local_68 + 0x12) & 0x80) == 0) {
      uVar8 = *local_68;
      lVar5 = local_68[1];
      pcVar7 = &DAT_00842049;
      uVar6 = 2;
    }
    else {
      uVar8 = *local_68;
      lVar5 = local_68[1];
      pcVar7 = "}";
      uVar6 = 1;
    }
    uVar4 = (**(code **)(lVar5 + 0x18))(uVar8,pcVar7,uVar6);
  }
  else {
    uVar4 = (ulong)(local_5f | local_60);
  }
  return uVar4 & 0xffffffffffffff01;
}


