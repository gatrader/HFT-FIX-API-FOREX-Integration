// _<polymarket_client_sdk::error::Validation_as_core::fmt::Debug>::fmt
// entry = 0039e880


/* _<polymarket_client_sdk::error::Validation as core::fmt::Debug>::fmt */

ulong __rustcall
_<polymarket_client_sdk::error::Validation_as_core::fmt::Debug>::fmt
          (long param_1,undefined8 *param_2)

{
  undefined8 uVar1;
  long lVar2;
  code *pcVar3;
  char cVar4;
  uint uVar5;
  undefined8 uVar6;
  undefined8 unaff_RBX;
  ulong uVar7;
  char *pcVar8;
  undefined1 local_49;
  undefined8 local_48;
  long local_40;
  undefined1 *local_38;
  
  uVar1 = *param_2;
  lVar2 = param_2[1];
  pcVar3 = *(code **)(lVar2 + 0x18);
  cVar4 = (*pcVar3)(uVar1,"Validation",10);
  uVar7 = CONCAT71((int7)((ulong)unaff_RBX >> 8),1);
  if (cVar4 != '\0') goto LAB_0039e8b7;
  if ((*(byte *)((long)param_2 + 0x12) & 0x80) == 0) {
    cVar4 = (*pcVar3)(uVar1,&DAT_0083bcf5,3);
    if (cVar4 != '\0') goto LAB_0039e8b7;
    cVar4 = (*pcVar3)(uVar1,"reason",6);
    if (cVar4 != '\0') goto LAB_0039e8b7;
    cVar4 = (*pcVar3)(uVar1,": ",2);
    if (cVar4 != '\0') goto LAB_0039e8b7;
    cVar4 = _<str_as_core::fmt::Debug>::fmt
                      (*(undefined8 *)(param_1 + 8),*(undefined8 *)(param_1 + 0x10),uVar1,lVar2);
    if (cVar4 != '\0') goto LAB_0039e8b7;
    pcVar8 = &DAT_00842049;
    uVar6 = 2;
  }
  else {
    cVar4 = (*pcVar3)(uVar1,&DAT_007e4b2c,3);
    if (cVar4 != '\0') goto LAB_0039e8b7;
    local_49 = 1;
    local_38 = &local_49;
    local_48 = uVar1;
    local_40 = lVar2;
    cVar4 = _<core::fmt::builders::PadAdapter_as_core::fmt::Write>::write_str(&local_48,"reason",6);
    if (cVar4 != '\0') goto LAB_0039e8b7;
    cVar4 = _<core::fmt::builders::PadAdapter_as_core::fmt::Write>::write_str(&local_48,": ",2);
    if (cVar4 != '\0') goto LAB_0039e8b7;
    cVar4 = _<str_as_core::fmt::Debug>::fmt
                      (*(undefined8 *)(param_1 + 8),*(undefined8 *)(param_1 + 0x10),&local_48,
                       &DAT_00971760);
    if (cVar4 != '\0') goto LAB_0039e8b7;
    cVar4 = _<core::fmt::builders::PadAdapter_as_core::fmt::Write>::write_str(&local_48,",\n",2);
    if (cVar4 != '\0') goto LAB_0039e8b7;
    pcVar8 = "}";
    uVar6 = 1;
  }
  uVar5 = (*pcVar3)(uVar1,pcVar8,uVar6);
  uVar7 = (ulong)uVar5;
LAB_0039e8b7:
  return uVar7 & 0xffffffff;
}


