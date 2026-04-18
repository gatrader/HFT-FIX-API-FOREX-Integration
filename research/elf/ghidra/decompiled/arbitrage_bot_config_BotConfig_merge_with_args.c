// arbitrage_bot::config::BotConfig::merge_with_args
// entry = 00277480


/* arbitrage_bot::config::BotConfig::merge_with_args */

void __rustcall
arbitrage_bot::config::BotConfig::merge_with_args(void *param_1,void *param_2,long param_3)

{
  char cVar1;
  void *pvVar2;
  long lVar3;
  undefined1 *puVar4;
  size_t __size;
  
  if (*(char *)(param_3 + 0x84) != '\0') {
    __size = *(size_t *)(param_3 + 0x10);
    if ((long)__size < 0) goto LAB_0027775f;
    pvVar2 = *(void **)(param_3 + 8);
    if (__size == 0) {
      puVar4 = &DAT_00000001;
    }
    else {
      puVar4 = malloc(__size);
      if (puVar4 == (undefined1 *)0x0) goto LAB_0027776d;
    }
    memcpy(puVar4,pvVar2,__size);
    if (*(long *)((long)param_2 + 0x18) != 0) {
      free(*(void **)((long)param_2 + 0x20));
    }
    *(size_t *)((long)param_2 + 0x18) = __size;
    *(undefined1 **)((long)param_2 + 0x20) = puVar4;
    *(size_t *)((long)param_2 + 0x28) = __size;
  }
  if (*(char *)(param_3 + 0x85) == '\0') {
    if (*(char *)(param_3 + 0x86) != '\0') goto LAB_002775f1;
LAB_0027751c:
    if (*(char *)(param_3 + 0x87) != '\0') goto LAB_00277606;
LAB_0027752a:
    if (*(char *)(param_3 + 0x88) != '\0') goto LAB_0027761f;
LAB_00277538:
    if (*(char *)(param_3 + 0x89) != '\0') goto LAB_00277638;
LAB_00277546:
    if (*(char *)(param_3 + 0x8a) != '\0') goto LAB_0027764e;
LAB_00277554:
    if (*(char *)(param_3 + 0x8b) != '\0') goto LAB_00277667;
LAB_00277562:
    if (*(char *)(param_3 + 0x8c) != '\0') goto LAB_0027767c;
LAB_00277570:
    if (*(char *)(param_3 + 0x8d) != '\0') goto LAB_00277691;
LAB_0027757e:
    if (*(char *)(param_3 + 0x8e) != '\0') goto LAB_002776aa;
LAB_0027758c:
    if (*(char *)(param_3 + 0x8f) != '\0') goto LAB_002776c6;
LAB_0027759a:
    lVar3 = *(long *)(param_3 + 0x30);
  }
  else {
    *(undefined4 *)((long)param_2 + 0xe0) = *(undefined4 *)(param_3 + 0x80);
    if (*(char *)(param_3 + 0x86) == '\0') goto LAB_0027751c;
LAB_002775f1:
    *(undefined1 *)((long)param_2 + 0xe4) = 1;
    if (*(char *)(param_3 + 0x87) == '\0') goto LAB_0027752a;
LAB_00277606:
    *(undefined8 *)((long)param_2 + 0x60) = *(undefined8 *)(param_3 + 0x48);
    if (*(char *)(param_3 + 0x88) == '\0') goto LAB_00277538;
LAB_0027761f:
    *(undefined8 *)((long)param_2 + 0x68) = *(undefined8 *)(param_3 + 0x50);
    if (*(char *)(param_3 + 0x89) == '\0') goto LAB_00277546;
LAB_00277638:
    *(undefined8 *)((long)param_2 + 0x70) = *(undefined8 *)(param_3 + 0x58);
    if (*(char *)(param_3 + 0x8a) == '\0') goto LAB_00277554;
LAB_0027764e:
    *(undefined8 *)((long)param_2 + 0x78) = *(undefined8 *)(param_3 + 0x60);
    if (*(char *)(param_3 + 0x8b) == '\0') goto LAB_00277562;
LAB_00277667:
    *(undefined1 *)((long)param_2 + 0xe5) = 1;
    if (*(char *)(param_3 + 0x8c) == '\0') goto LAB_00277570;
LAB_0027767c:
    *(undefined1 *)((long)param_2 + 0xe6) = 0;
    if (*(char *)(param_3 + 0x8d) == '\0') goto LAB_0027757e;
LAB_00277691:
    *(undefined8 *)((long)param_2 + 0x80) = *(undefined8 *)(param_3 + 0x68);
    if (*(char *)(param_3 + 0x8e) == '\0') goto LAB_0027758c;
LAB_002776aa:
    *(undefined8 *)((long)param_2 + 0x90) = *(undefined8 *)(param_3 + 0x70);
    if (*(char *)(param_3 + 0x8f) == '\0') goto LAB_0027759a;
LAB_002776c6:
    *(undefined8 *)((long)param_2 + 0x98) = *(undefined8 *)(param_3 + 0x78);
    lVar3 = *(long *)(param_3 + 0x30);
  }
  if (SBORROW8(0,lVar3)) {
    cVar1 = *(char *)(param_3 + 0x90);
  }
  else {
    __size = *(size_t *)(param_3 + 0x40);
    if ((long)__size < 0) {
LAB_0027775f:
                    /* try { // try from 0027775f to 00277779 has its CatchHandler @ 0027777c */
                    /* WARNING: Subroutine does not return */
      alloc::raw_vec::capacity_overflow(&PTR_DAT_00967518);
    }
    pvVar2 = *(void **)(param_3 + 0x38);
    if (__size == 0) {
      puVar4 = &DAT_00000001;
    }
    else {
      puVar4 = malloc(__size);
      if (puVar4 == (undefined1 *)0x0) {
LAB_0027776d:
                    /* WARNING: Subroutine does not return */
        alloc::alloc::handle_alloc_error(1,__size);
      }
    }
    memcpy(puVar4,pvVar2,__size);
    if ((*(long *)((long)param_2 + 0x48) != -0x8000000000000000) &&
       (*(long *)((long)param_2 + 0x48) != 0)) {
      free(*(void **)((long)param_2 + 0x50));
    }
    *(size_t *)((long)param_2 + 0x48) = __size;
    *(undefined1 **)((long)param_2 + 0x50) = puVar4;
    *(size_t *)((long)param_2 + 0x58) = __size;
    cVar1 = *(char *)(param_3 + 0x90);
  }
  if (cVar1 != '\0') {
    *(undefined1 *)((long)param_2 + 0xe8) = 0;
  }
  memcpy(param_1,param_2,0xf0);
  return;
}


