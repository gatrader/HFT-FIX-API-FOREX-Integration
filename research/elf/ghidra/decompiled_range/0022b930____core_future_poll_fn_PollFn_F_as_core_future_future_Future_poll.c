// _<core::future::poll_fn::PollFn<F>as_core::future::future::Future>::poll
// entry = 0022b930


/* _<core::future::poll_fn::PollFn<F> as core::future::future::Future>::poll */

void __rustcall
_<core::future::poll_fn::PollFn<F>as_core::future::future::Future>::poll
          (undefined8 *param_1,byte *param_2,undefined8 *param_3,undefined8 *param_4)

{
  char cVar1;
  byte bVar2;
  uint uVar3;
  undefined8 uVar4;
  undefined8 *extraout_RDX;
  uint uVar5;
  long *in_FS_OFFSET;
  bool bVar6;
  int local_b0 [34];
  
  if ((char)in_FS_OFFSET[-0x30] != '\x01') {
    if ((char)in_FS_OFFSET[-0x30] == '\x02') {
      std::thread::local::panic_access_error(&PTR_DAT_009858f0);
      param_3 = extraout_RDX;
    }
    std::sys::thread_local::destructors::linux_like::register
              (*in_FS_OFFSET + -0x1c8,std::sys::thread_local::native::eager::destroy);
    *(undefined1 *)(in_FS_OFFSET + -0x30) = 1;
  }
  if ((*(char *)((long)in_FS_OFFSET + -0x184) == '\x01') &&
     (*(char *)((long)in_FS_OFFSET + -0x183) == '\0')) {
    tokio::runtime::context::defer(*param_4,param_4[1]);
    *param_1 = 0x13;
    return;
  }
  if ((*(byte *)(in_FS_OFFSET + -0x32) & 1) == 0) {
    uVar4 = tokio::loom::std::rand::seed();
    uVar3 = (uint)((ulong)uVar4 >> 0x20);
    uVar5 = 1;
    if (1 < (uint)uVar4) {
      uVar5 = (uint)uVar4;
    }
  }
  else {
    uVar3 = *(uint *)((long)in_FS_OFFSET + -0x18c);
    uVar5 = *(uint *)(in_FS_OFFSET + -0x31);
  }
  uVar3 = uVar3 << 0x11 ^ uVar3;
  uVar3 = uVar5 >> 0x10 ^ uVar3 >> 7 ^ uVar5 ^ uVar3;
  *(undefined4 *)(in_FS_OFFSET + -0x32) = 1;
  *(uint *)((long)in_FS_OFFSET + -0x18c) = uVar5;
  *(uint *)(in_FS_OFFSET + -0x31) = uVar3;
  bVar2 = *param_2;
  if ((int)(uVar3 + uVar5) < 0) {
    bVar6 = (bVar2 & 2) == 0;
    if (bVar6) {
      cVar1 = _<tokio::time::sleep::Sleep_as_core::future::future::Future>::poll
                        (param_3 + 1,param_4);
      if (cVar1 == '\0') goto LAB_0022baea;
      bVar2 = *param_2;
    }
    if ((bVar2 & 1) == 0) {
      _<futures_util::stream::stream::split::SplitStream<S>as_futures_core::stream::Stream>::
      poll_next(local_b0,*param_3,param_4);
      if (local_b0[0] != 0x11) {
LAB_0022bb05:
        memcpy(param_1,local_b0,0x88);
        *param_2 = *param_2 | 1;
        return;
      }
      goto LAB_0022bafc;
    }
  }
  else {
    bVar6 = (bVar2 & 1) == 0;
    if (bVar6) {
      _<futures_util::stream::stream::split::SplitStream<S>as_futures_core::stream::Stream>::
      poll_next(local_b0,*param_3,param_4);
      if (local_b0[0] != 0x11) goto LAB_0022bb05;
      bVar2 = *param_2;
    }
    if ((bVar2 & 2) == 0) {
      cVar1 = _<tokio::time::sleep::Sleep_as_core::future::future::Future>::poll
                        (param_3 + 1,param_4);
      if (cVar1 == '\0') {
LAB_0022baea:
        *param_2 = *param_2 | 2;
        *param_1 = 0x11;
        return;
      }
      goto LAB_0022bafc;
    }
  }
  if (!bVar6) {
    *param_1 = 0x12;
    return;
  }
LAB_0022bafc:
  *param_1 = 0x13;
  return;
}


