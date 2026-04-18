// _<polymarket_client_sdk::clob::types::response::_::<impl_serde_core::de::Deserialize_for_polymarket_client_sdk::clob::types::response::OpenOrderResponse>::deserialize::__FieldVisitor_as_serde_core::de::Visitor>::visit_str
// entry = 0025a9c0


/* _<polymarket_client_sdk::clob::types::response::_::<impl serde_core::de::Deserialize for
   polymarket_client_sdk::clob::types::response::OpenOrderResponse>::deserialize::__FieldVisitor as
   serde_core::de::Visitor>::visit_str */

void __rustcall
_<polymarket_client_sdk::clob::types::response::_::<impl_serde_core::de::Deserialize_for_polymarket_client_sdk::clob::types::response::OpenOrderResponse>::deserialize::__FieldVisitor_as_serde_core::de::Visitor>
::visit_str(undefined1 *param_1,long *param_2,size_t param_3)

{
  int iVar1;
  undefined1 auVar2 [16];
  
  switch(param_3) {
  case 2:
    if ((short)*param_2 == 0x6469) {
      param_1[1] = 0;
      *param_1 = 0;
      return;
    }
    break;
  case 4:
    if ((int)*param_2 == 0x65646973) {
      param_1[1] = 6;
      *param_1 = 0;
      return;
    }
    break;
  case 5:
    if (*(char *)((long)param_2 + 4) == 'r' && (int)*param_2 == 0x656e776f) {
      param_1[1] = 2;
      *param_1 = 0;
      return;
    }
    iVar1 = bcmp(param_2,&DAT_007dc368,param_3);
    if (iVar1 == 0) {
      param_1[1] = 9;
      *param_1 = 0;
      return;
    }
    break;
  case 6:
    if (*(short *)((long)param_2 + 4) == 0x7375 && (int)*param_2 == 0x74617473) {
      param_1[1] = 1;
      *param_1 = 0;
      return;
    }
    if (*(short *)((long)param_2 + 4) == 0x7465 && (int)*param_2 == 0x6b72616d) {
      param_1[1] = 4;
      *param_1 = 0;
      return;
    }
    break;
  case 7:
    if (*(int *)((long)param_2 + 3) == 0x656d6f63 && (int)*param_2 == 0x6374756f) {
      param_1[1] = 0xb;
      *param_1 = 0;
      return;
    }
    break;
  case 8:
    if (*param_2 == 0x64695f7465737361) {
      param_1[1] = 5;
      *param_1 = 0;
      return;
    }
    break;
  case 10:
    if ((short)param_2[1] == 0x7461 && *param_2 == 0x5f64657461657263) {
      param_1[1] = 0xc;
      *param_1 = 0;
      return;
    }
    if ((short)param_2[1] == 0x6e6f && *param_2 == 0x6974617269707865) {
      param_1[1] = 0xd;
      *param_1 = 0;
      return;
    }
    if ((short)param_2[1] == 0x6570 && *param_2 == 0x79745f726564726f) {
      param_1[1] = 0xe;
      *param_1 = 0;
      return;
    }
    goto LAB_0025abb7;
  case 0xc:
    if ((int)param_2[1] == 0x64656863 && *param_2 == 0x74616d5f657a6973) {
      param_1[1] = 8;
      *param_1 = 0;
      return;
    }
    break;
  case 0xd:
    if (*(long *)((long)param_2 + 5) == 0x737365726464615f && *param_2 == 0x64615f72656b616d) {
      param_1[1] = 3;
      *param_1 = 0;
      return;
    }
    if (*(long *)((long)param_2 + 5) == 0x657a69735f6c616e && *param_2 == 0x6c616e696769726f) {
      param_1[1] = 7;
      *param_1 = 0;
      return;
    }
    break;
  case 0x10:
    auVar2[0] = -((char)*param_2 == 'a');
    auVar2[1] = -(*(char *)((long)param_2 + 1) == 's');
    auVar2[2] = -(*(char *)((long)param_2 + 2) == 's');
    auVar2[3] = -(*(char *)((long)param_2 + 3) == 'o');
    auVar2[4] = -(*(char *)((long)param_2 + 4) == 'c');
    auVar2[5] = -(*(char *)((long)param_2 + 5) == 'i');
    auVar2[6] = -(*(char *)((long)param_2 + 6) == 'a');
    auVar2[7] = -(*(char *)((long)param_2 + 7) == 't');
    auVar2[8] = -((char)param_2[1] == 'e');
    auVar2[9] = -(*(char *)((long)param_2 + 9) == '_');
    auVar2[10] = -(*(char *)((long)param_2 + 10) == 't');
    auVar2[0xb] = -(*(char *)((long)param_2 + 0xb) == 'r');
    auVar2[0xc] = -(*(char *)((long)param_2 + 0xc) == 'a');
    auVar2[0xd] = -(*(char *)((long)param_2 + 0xd) == 'd');
    auVar2[0xe] = -(*(char *)((long)param_2 + 0xe) == 'e');
    auVar2[0xf] = -(*(char *)((long)param_2 + 0xf) == 's');
    if ((ushort)((ushort)(SUB161(auVar2 >> 7,0) & 1) | (ushort)(SUB161(auVar2 >> 0xf,0) & 1) << 1 |
                 (ushort)(SUB161(auVar2 >> 0x17,0) & 1) << 2 |
                 (ushort)(SUB161(auVar2 >> 0x1f,0) & 1) << 3 |
                 (ushort)(SUB161(auVar2 >> 0x27,0) & 1) << 4 |
                 (ushort)(SUB161(auVar2 >> 0x2f,0) & 1) << 5 |
                 (ushort)(SUB161(auVar2 >> 0x37,0) & 1) << 6 |
                 (ushort)(SUB161(auVar2 >> 0x3f,0) & 1) << 7 |
                 (ushort)(SUB161(auVar2 >> 0x47,0) & 1) << 8 |
                 (ushort)(SUB161(auVar2 >> 0x4f,0) & 1) << 9 |
                 (ushort)(SUB161(auVar2 >> 0x57,0) & 1) << 10 |
                 (ushort)(SUB161(auVar2 >> 0x5f,0) & 1) << 0xb |
                 (ushort)(SUB161(auVar2 >> 0x67,0) & 1) << 0xc |
                 (ushort)(SUB161(auVar2 >> 0x6f,0) & 1) << 0xd |
                 (ushort)(SUB161(auVar2 >> 0x77,0) & 1) << 0xe | (ushort)(auVar2[0xf] >> 7) << 0xf)
        == 0xffff) {
      param_1[1] = 10;
      *param_1 = 0;
      return;
    }
  }
LAB_0025abb7:
  param_1[1] = 0xf;
  *param_1 = 0;
  return;
}


