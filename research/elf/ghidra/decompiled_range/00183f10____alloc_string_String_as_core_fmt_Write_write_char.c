// _<alloc::string::String_as_core::fmt::Write>::write_char
// entry = 00183f10


/* _<alloc::string::String as core::fmt::Write>::write_char */

undefined8 __rustcall
_<alloc::string::String_as_core::fmt::Write>::write_char(long *param_1,uint param_2)

{
  long lVar1;
  long lVar2;
  long lVar3;
  byte bVar4;
  ulong uVar5;
  
  lVar1 = param_1[2];
  uVar5 = 1;
  if ((0x7f < param_2) && (uVar5 = 2, 0x7ff < param_2)) {
    uVar5 = 4 - (ulong)(param_2 < 0x10000);
  }
  bVar4 = (byte)param_2;
  if ((ulong)(*param_1 - lVar1) < uVar5) {
    alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle(param_1,lVar1,uVar5,1,1);
    lVar2 = param_1[1];
    lVar3 = param_1[2];
  }
  else {
    lVar2 = param_1[1];
    lVar3 = lVar1;
  }
  if (param_2 < 0x80) {
    *(byte *)(lVar2 + lVar3) = bVar4;
  }
  else if (param_2 < 0x800) {
    *(byte *)(lVar2 + lVar3) = (byte)(param_2 >> 6) | 0xc0;
    *(byte *)(lVar2 + 1 + lVar3) = bVar4 & 0x3f | 0x80;
  }
  else if (param_2 < 0x10000) {
    *(byte *)(lVar2 + lVar3) = (byte)(param_2 >> 0xc) | 0xe0;
    *(byte *)(lVar2 + 1 + lVar3) = (byte)(param_2 >> 6) & 0x3f | 0x80;
    *(byte *)(lVar2 + 2 + lVar3) = bVar4 & 0x3f | 0x80;
  }
  else {
    *(byte *)(lVar2 + lVar3) = (byte)(param_2 >> 0x12) | 0xf0;
    *(byte *)(lVar2 + 1 + lVar3) = (byte)(param_2 >> 0xc) & 0x3f | 0x80;
    *(byte *)(lVar2 + 2 + lVar3) = (byte)(param_2 >> 6) & 0x3f | 0x80;
    *(byte *)(lVar2 + 3 + lVar3) = bVar4 & 0x3f | 0x80;
  }
  param_1[2] = uVar5 + lVar1;
  return 0;
}


