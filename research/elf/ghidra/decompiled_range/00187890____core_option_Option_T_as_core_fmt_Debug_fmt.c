// _<core::option::Option<T>as_core::fmt::Debug>::fmt
// entry = 00187890


/* _<core::option::Option<T> as core::fmt::Debug>::fmt */

ulong __rustcall
_<core::option::Option<T>as_core::fmt::Debug>::fmt(long param_1,undefined8 *param_2)

{
  long lVar1;
  char cVar2;
  uint uVar3;
  ulong uVar4;
  undefined8 unaff_RBX;
  code *pcVar5;
  undefined8 uVar6;
  undefined1 local_61;
  undefined8 *local_60;
  undefined *local_58;
  undefined8 local_50;
  undefined8 local_48;
  long local_40;
  undefined1 *local_38;
  
  if (*(short *)(param_1 + 0x20) == 0x12) {
                    /* WARNING: Could not recover jumptable at 0x001878cd. Too many branches */
                    /* WARNING: Treating indirect jump as call */
    uVar4 = (**(code **)(param_2[1] + 0x18))(*param_2,&DAT_007cd3dc,4);
    return uVar4;
  }
  uVar6 = *param_2;
  lVar1 = param_2[1];
  pcVar5 = *(code **)(lVar1 + 0x18);
  cVar2 = (*pcVar5)(uVar6,&DAT_007cd3e0,4);
  uVar4 = CONCAT71((int7)((ulong)unaff_RBX >> 8),1);
  if (cVar2 != '\0') goto LAB_001878f5;
  if ((*(byte *)((long)param_2 + 0x12) & 0x80) == 0) {
    cVar2 = (*pcVar5)(uVar6,&DAT_0083f23b,1);
    if (cVar2 != '\0') goto LAB_001878f5;
    cVar2 = _<&T_as_core::fmt::Debug>::fmt(param_1,param_2);
    if (cVar2 != '\0') goto LAB_001878f5;
    uVar6 = *param_2;
    pcVar5 = *(code **)(param_2[1] + 0x18);
  }
  else {
    cVar2 = (*pcVar5)(uVar6,&DAT_007e4b36,2);
    if (cVar2 != '\0') goto LAB_001878f5;
    local_61 = 1;
    local_38 = &local_61;
    local_50 = param_2[2];
    local_60 = &local_48;
    local_58 = &DAT_00971760;
    local_48 = uVar6;
    local_40 = lVar1;
    cVar2 = _<&T_as_core::fmt::Debug>::fmt(param_1,&local_60);
    if (cVar2 != '\0') goto LAB_001878f5;
    cVar2 = (**(code **)(local_58 + 0x18))(local_60,",\n",2);
    if (cVar2 != '\0') goto LAB_001878f5;
  }
  uVar3 = (*pcVar5)(uVar6,")",1);
  uVar4 = (ulong)uVar3;
LAB_001878f5:
  return uVar4 & 0xffffffff;
}


