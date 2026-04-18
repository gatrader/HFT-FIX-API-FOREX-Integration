// _<polymarket_client_sdk::clob::types::response::_::<impl_serde_core::de::Deserialize_for_polymarket_client_sdk::clob::types::response::PostOrderResponse>::deserialize::__FieldVisitor_as_serde_core::de::Visitor>::visit_str
// entry = 0025ac00


/* _<polymarket_client_sdk::clob::types::response::_::<impl serde_core::de::Deserialize for
   polymarket_client_sdk::clob::types::response::PostOrderResponse>::deserialize::__FieldVisitor as
   serde_core::de::Visitor>::visit_str */

void __rustcall
_<polymarket_client_sdk::clob::types::response::_::<impl_serde_core::de::Deserialize_for_polymarket_client_sdk::clob::types::response::PostOrderResponse>::deserialize::__FieldVisitor_as_serde_core::de::Visitor>
::visit_str(undefined1 *param_1,long *param_2,undefined8 param_3)

{
  ushort uVar1;
  undefined1 auVar2 [16];
  undefined1 auVar3 [16];
  undefined1 auVar4 [16];
  undefined1 auVar5 [16];
  
  switch(param_3) {
  case 6:
    if (*(short *)((long)param_2 + 4) == 0x7375 && (int)*param_2 == 0x74617473) {
      param_1[1] = 4;
      *param_1 = 0;
      return;
    }
    break;
  case 7:
    if (*(int *)((long)param_2 + 3) == 0x44497265 && (int)*param_2 == 0x6564726f) {
      param_1[1] = 3;
      *param_1 = 0;
      return;
    }
    if (*(int *)((long)param_2 + 3) == 0x73736563 && (int)*param_2 == 0x63637573) {
      param_1[1] = 5;
      *param_1 = 0;
      return;
    }
    break;
  case 8:
    if (*param_2 == 0x67734d726f727265) {
      param_1[1] = 0;
      *param_1 = 0;
      return;
    }
    if (*param_2 != 0x7364496564617274) {
      param_1[1] = 8;
      *param_1 = 0;
      return;
    }
    param_1[1] = 7;
    *param_1 = 0;
    return;
  case 0xc:
    if ((int)param_2[1] == 0x746e756f && *param_2 == 0x6d41676e696b616d) {
      param_1[1] = 1;
      *param_1 = 0;
      return;
    }
    if ((int)param_2[1] == 0x746e756f && *param_2 == 0x6d41676e696b6174) {
      param_1[1] = 2;
      *param_1 = 0;
      return;
    }
    break;
  case 0x11:
    auVar3[0] = -((char)*param_2 == 't');
    auVar3[1] = -(*(char *)((long)param_2 + 1) == 'r');
    auVar3[2] = -(*(char *)((long)param_2 + 2) == 'a');
    auVar3[3] = -(*(char *)((long)param_2 + 3) == 'n');
    auVar3[4] = -(*(char *)((long)param_2 + 4) == 's');
    auVar3[5] = -(*(char *)((long)param_2 + 5) == 'a');
    auVar3[6] = -(*(char *)((long)param_2 + 6) == 'c');
    auVar3[7] = -(*(char *)((long)param_2 + 7) == 't');
    auVar3[8] = -((char)param_2[1] == 'i');
    auVar3[9] = -(*(char *)((long)param_2 + 9) == 'o');
    auVar3[10] = -(*(char *)((long)param_2 + 10) == 'n');
    auVar3[0xb] = -(*(char *)((long)param_2 + 0xb) == 'H');
    auVar3[0xc] = -(*(char *)((long)param_2 + 0xc) == 'a');
    auVar3[0xd] = -(*(char *)((long)param_2 + 0xd) == 's');
    auVar3[0xe] = -(*(char *)((long)param_2 + 0xe) == 'h');
    auVar3[0xf] = -(*(char *)((long)param_2 + 0xf) == 'e');
    auVar5[0] = -((char)param_2[2] == 's');
    auVar5[1] = 0xff;
    auVar5[2] = 0xff;
    auVar5[3] = 0xff;
    auVar5[4] = 0xff;
    auVar5[5] = 0xff;
    auVar5[6] = 0xff;
    auVar5[7] = 0xff;
    auVar5[8] = 0xff;
    auVar5[9] = 0xff;
    auVar5[10] = 0xff;
    auVar5[0xb] = 0xff;
    auVar5[0xc] = 0xff;
    auVar5[0xd] = 0xff;
    auVar5[0xe] = 0xff;
    auVar5[0xf] = 0xff;
    auVar5 = auVar5 & auVar3;
    uVar1 = (ushort)(SUB161(auVar5 >> 7,0) & 1) | (ushort)(SUB161(auVar5 >> 0xf,0) & 1) << 1 |
            (ushort)(SUB161(auVar5 >> 0x17,0) & 1) << 2 |
            (ushort)(SUB161(auVar5 >> 0x1f,0) & 1) << 3 |
            (ushort)(SUB161(auVar5 >> 0x27,0) & 1) << 4 |
            (ushort)(SUB161(auVar5 >> 0x2f,0) & 1) << 5 |
            (ushort)(SUB161(auVar5 >> 0x37,0) & 1) << 6 |
            (ushort)(SUB161(auVar5 >> 0x3f,0) & 1) << 7 |
            (ushort)(SUB161(auVar5 >> 0x47,0) & 1) << 8 |
            (ushort)(SUB161(auVar5 >> 0x4f,0) & 1) << 9 |
            (ushort)(SUB161(auVar5 >> 0x57,0) & 1) << 10 |
            (ushort)(SUB161(auVar5 >> 0x5f,0) & 1) << 0xb |
            (ushort)(SUB161(auVar5 >> 0x67,0) & 1) << 0xc |
            (ushort)(SUB161(auVar5 >> 0x6f,0) & 1) << 0xd |
            (ushort)(SUB161(auVar5 >> 0x77,0) & 1) << 0xe | (ushort)(byte)(auVar5[0xf] >> 7) << 0xf;
    goto joined_r0x0025ac99;
  case 0x12:
    auVar2[0] = -((char)*param_2 == 't');
    auVar2[1] = -(*(char *)((long)param_2 + 1) == 'r');
    auVar2[2] = -(*(char *)((long)param_2 + 2) == 'a');
    auVar2[3] = -(*(char *)((long)param_2 + 3) == 'n');
    auVar2[4] = -(*(char *)((long)param_2 + 4) == 's');
    auVar2[5] = -(*(char *)((long)param_2 + 5) == 'a');
    auVar2[6] = -(*(char *)((long)param_2 + 6) == 'c');
    auVar2[7] = -(*(char *)((long)param_2 + 7) == 't');
    auVar2[8] = -((char)param_2[1] == 'i');
    auVar2[9] = -(*(char *)((long)param_2 + 9) == 'o');
    auVar2[10] = -(*(char *)((long)param_2 + 10) == 'n');
    auVar2[0xb] = -(*(char *)((long)param_2 + 0xb) == 's');
    auVar2[0xc] = -(*(char *)((long)param_2 + 0xc) == 'H');
    auVar2[0xd] = -(*(char *)((long)param_2 + 0xd) == 'a');
    auVar2[0xe] = -(*(char *)((long)param_2 + 0xe) == 's');
    auVar2[0xf] = -(*(char *)((long)param_2 + 0xf) == 'h');
    auVar4[0] = -((char)(short)param_2[2] == 'e');
    auVar4[1] = -((char)((ushort)(short)param_2[2] >> 8) == 's');
    auVar4[2] = 0xff;
    auVar4[3] = 0xff;
    auVar4[4] = 0xff;
    auVar4[5] = 0xff;
    auVar4[6] = 0xff;
    auVar4[7] = 0xff;
    auVar4[8] = 0xff;
    auVar4[9] = 0xff;
    auVar4[10] = 0xff;
    auVar4[0xb] = 0xff;
    auVar4[0xc] = 0xff;
    auVar4[0xd] = 0xff;
    auVar4[0xe] = 0xff;
    auVar4[0xf] = 0xff;
    auVar4 = auVar4 & auVar2;
    uVar1 = (ushort)(SUB161(auVar4 >> 7,0) & 1) | (ushort)(SUB161(auVar4 >> 0xf,0) & 1) << 1 |
            (ushort)(SUB161(auVar4 >> 0x17,0) & 1) << 2 |
            (ushort)(SUB161(auVar4 >> 0x1f,0) & 1) << 3 |
            (ushort)(SUB161(auVar4 >> 0x27,0) & 1) << 4 |
            (ushort)(SUB161(auVar4 >> 0x2f,0) & 1) << 5 |
            (ushort)(SUB161(auVar4 >> 0x37,0) & 1) << 6 |
            (ushort)(SUB161(auVar4 >> 0x3f,0) & 1) << 7 |
            (ushort)(SUB161(auVar4 >> 0x47,0) & 1) << 8 |
            (ushort)(SUB161(auVar4 >> 0x4f,0) & 1) << 9 |
            (ushort)(SUB161(auVar4 >> 0x57,0) & 1) << 10 |
            (ushort)(SUB161(auVar4 >> 0x5f,0) & 1) << 0xb |
            (ushort)(SUB161(auVar4 >> 0x67,0) & 1) << 0xc |
            (ushort)(SUB161(auVar4 >> 0x6f,0) & 1) << 0xd |
            (ushort)(SUB161(auVar4 >> 0x77,0) & 1) << 0xe | (ushort)(byte)(auVar4[0xf] >> 7) << 0xf;
joined_r0x0025ac99:
    if (uVar1 == 0xffff) {
      param_1[1] = 6;
      *param_1 = 0;
      return;
    }
  }
  param_1[1] = 8;
  *param_1 = 0;
  return;
}


