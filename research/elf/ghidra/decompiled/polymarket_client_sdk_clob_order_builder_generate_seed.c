// polymarket_client_sdk::clob::order_builder::generate_seed
// entry = 003a2b20


/* polymarket_client_sdk::clob::order_builder::generate_seed */

ulong __rustcall polymarket_client_sdk::clob::order_builder::generate_seed(void)

{
  long lVar1;
  undefined4 uVar2;
  long *plVar3;
  code *pcVar4;
  ulong uVar5;
  ulong uVar6;
  long in_FS_OFFSET;
  double dVar7;
  undefined1 auVar8 [16];
  int local_60 [2];
  int local_58;
  undefined4 uStack_54;
  int local_50;
  undefined1 local_48 [12];
  undefined8 local_38;
  undefined4 local_30;
  
  local_48 = std::sys::pal::unix::time::Timespec::now(0);
  local_38 = 0;
  local_30 = 0;
  std::sys::pal::unix::time::Timespec::sub_timespec(local_60,local_48,&local_38);
  auVar8._4_4_ = uStack_54;
  auVar8._0_4_ = local_58;
  if (local_60[0] == 1) {
LAB_003a2b91:
    local_58 = local_50;
                    /* WARNING: Subroutine does not return */
    core::result::unwrap_failed
              ("time went backwards",0x13,local_60,&DAT_00977e40,
               &PTR_s__usr_local_cargo_git_checkouts_r_00977e90);
  }
  if (*(long *)(in_FS_OFFSET + -0xa0) != 1) {
    if ((int)*(long *)(in_FS_OFFSET + -0xa0) == 2) {
      std::thread::local::panic_access_error(&PTR_DAT_009858f0);
      goto LAB_003a2b91;
    }
    std::sys::thread_local::native::lazy::Storage<T,D>::initialize();
  }
  plVar3 = *(long **)(in_FS_OFFSET + -0x98);
  *plVar3 = *plVar3 + 1;
  if (*plVar3 == 0) {
                    /* WARNING: Does not return */
    pcVar4 = (code *)invalidInstructionException();
    (*pcVar4)();
  }
  uVar6 = plVar3[0x2a];
  if (uVar6 < 0x3f) {
    plVar3[0x2a] = uVar6 + 2;
    uVar6 = *(ulong *)((long)plVar3 + uVar6 * 4 + 0x10);
    *plVar3 = *plVar3 + -1;
    lVar1 = *plVar3;
  }
  else if (uVar6 == 0x3f) {
    uVar2 = *(undefined4 *)((long)plVar3 + 0x10c);
    if (plVar3[0x29] < 1) {
      rand::rngs::reseeding::ReseedingCore<R,Rsdr>::reseed_and_generate(plVar3 + 0x22,plVar3 + 2);
    }
    else {
      plVar3[0x29] = plVar3[0x29] + -0x100;
                    /* try { // try from 003a2c2d to 003a2c81 has its CatchHandler @ 003a2d3d */
      rand_chacha::guts::refill_wide();
    }
    plVar3[0x2a] = 1;
    uVar6 = CONCAT44((int)plVar3[2],uVar2);
    *plVar3 = *plVar3 + -1;
    lVar1 = *plVar3;
  }
  else {
    if (plVar3[0x29] < 1) {
      rand::rngs::reseeding::ReseedingCore<R,Rsdr>::reseed_and_generate(plVar3 + 0x22,plVar3 + 2);
    }
    else {
      plVar3[0x29] = plVar3[0x29] + -0x100;
      rand_chacha::guts::refill_wide();
    }
    plVar3[0x2a] = 2;
    uVar6 = plVar3[2];
    *plVar3 = *plVar3 + -1;
    lVar1 = *plVar3;
  }
  if (lVar1 == 0) {
    alloc::rc::Rc<T,A>::drop_slow(plVar3);
  }
  auVar8._8_4_ = uStack_54;
  auVar8._12_4_ = 0x45300000;
  dVar7 = round(((auVar8._8_8_ - 1.9342813113834067e+25) +
                 ((double)CONCAT44(0x43300000,local_58) - 4503599627370496.0) +
                (double)local_50 / 1000000000.0) * (double)(uVar6 >> 0xb) * 1.1102230246251565e-16);
  uVar6 = 0;
  if (0.0 <= dVar7) {
    uVar6 = (long)(dVar7 - 9.223372036854776e+18) & (long)dVar7 >> 0x3f | (long)dVar7;
  }
  uVar5 = 0xffffffffffffffff;
  if (dVar7 <= 1.844674407370955e+19) {
    uVar5 = uVar6;
  }
  return uVar5;
}


