// chrono::datetime::DateTime<Tz>::timestamp
// entry = 001d9460


/* chrono::datetime::DateTime<Tz>::timestamp */

long __rustcall chrono::datetime::DateTime<Tz>::timestamp(uint param_1,uint param_2)

{
  int iVar1;
  int iVar2;
  int iVar3;
  
  iVar3 = (int)param_1 >> 0xd;
  iVar2 = iVar3 + -1;
  iVar1 = 0;
  if (iVar3 < 1) {
    iVar1 = (1U - iVar3) / 400 + 1;
    iVar2 = iVar2 + iVar1 * 400;
    iVar1 = iVar1 * -0x23ab1;
  }
  return (long)(int)((iVar2 / 100 >> 2) +
                     (((param_1 >> 4 & 0x1ff) + iVar1) - iVar2 / 100) + (iVar2 * 0x5b5 >> 2) +
                    -0xaf93b) * 0x15180 + (ulong)param_2;
}


