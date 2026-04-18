// _<core::option::Option<T>as_core::fmt::Debug>::fmt
// entry = 001d6f40


/* _<core::option::Option<T> as core::fmt::Debug>::fmt */

ulong __rustcall
_<core::option::Option<T>as_core::fmt::Debug>::fmt(long *param_1,undefined8 *param_2)

{
  undefined8 uVar1;
  long lVar2;
  code *pcVar3;
  char cVar4;
  uint uVar5;
  ulong uVar6;
  undefined8 unaff_RBP;
  undefined1 local_49;
  undefined8 local_48;
  long local_40;
  undefined1 *local_38;
  
  if (SBORROW8(0,*param_1)) {
                    /* WARNING: Could not recover jumptable at 0x001d6f7d. Too many branches */
                    /* WARNING: Treating indirect jump as call */
    uVar6 = (**(code **)(param_2[1] + 0x18))(*param_2,&DAT_007cd3dc,4);
    return uVar6;
  }
  uVar1 = *param_2;
  lVar2 = param_2[1];
  pcVar3 = *(code **)(lVar2 + 0x18);
  cVar4 = (*pcVar3)(uVar1,&DAT_007cd3e0,4);
  uVar6 = CONCAT71((int7)((ulong)unaff_RBP >> 8),1);
  if (cVar4 != '\0') goto LAB_001d6fa6;
  if ((*(byte *)((long)param_2 + 0x12) & 0x80) == 0) {
    cVar4 = (*pcVar3)(uVar1,&DAT_0083f23b,1);
    if (cVar4 != '\0') goto LAB_001d6fa6;
    cVar4 = _<str_as_core::fmt::Debug>::fmt(param_1[1],param_1[2],uVar1,lVar2);
  }
  else {
    cVar4 = (*pcVar3)(uVar1,&DAT_007e4b36,2);
    if (cVar4 != '\0') goto LAB_001d6fa6;
    local_49 = 1;
    local_38 = &local_49;
    local_48 = uVar1;
    local_40 = lVar2;
    cVar4 = _<str_as_core::fmt::Debug>::fmt(param_1[1],param_1[2],&local_48,&DAT_00971760);
    if (cVar4 != '\0') goto LAB_001d6fa6;
    cVar4 = _<core::fmt::builders::PadAdapter_as_core::fmt::Write>::write_str(&local_48,",\n",2);
  }
  if (cVar4 == '\0') {
    uVar5 = (*pcVar3)(uVar1,")",1);
    uVar6 = (ulong)uVar5;
  }
LAB_001d6fa6:
  return uVar6 & 0xffffffff;
}


