
bot/bin/arbitrage_bot:     file format elf64-x86-64


Disassembly of section .text:

00000000000d0ef0 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905>:
   d0ef0:	push   %rbp
   d0ef1:	push   %r15
   d0ef3:	push   %r14
   d0ef5:	push   %r13
   d0ef7:	push   %r12
   d0ef9:	push   %rbx
   d0efa:	sub    $0xc78,%rsp
   d0f01:	mov    %rdx,%rbp
   d0f04:	mov    %rdi,0x3f8(%rsp)
   d0f0c:	movzbl 0x148(%rsi),%eax
   d0f13:	lea    0x5fa91a(%rip),%rcx        # 6cb834 <encoding_rs::data::KSX1001_LOWERCASE+0x1a54>
   d0f1a:	movslq (%rcx,%rax,4),%rax
   d0f1e:	add    %rcx,%rax
   d0f21:	mov    %rsi,0x8(%rsp)
   d0f26:	jmp    *%rax
   d0f28:	movw   $0x0,0x149(%rsi)
   d0f31:	mov    0x18(%rsi),%rax
   d0f35:	mov    %rax,0x20(%rsi)
   d0f39:	movups (%rsi),%xmm0
   d0f3c:	movups %xmm0,0x28(%rsi)
   d0f40:	mov    0x10(%rsi),%rcx
   d0f44:	mov    %rcx,0x38(%rsi)
   d0f48:	mov    (%rax),%r14
   d0f4b:	movabs $0x202020202020202,%rax
   d0f55:	mov    %rax,0x550(%rsp)
   d0f5d:	movaps 0x5f772c(%rip),%xmm0        # 6c8690 <_fini+0x1584>
   d0f64:	movaps %xmm0,0x540(%rsp)
   d0f6c:	lea    0x10(%r14),%rax
   d0f70:	mov    %rax,0x5e8(%rsp)
   d0f78:	lea    0x5e8(%rsp),%rax
   d0f80:	mov    %rax,0x320(%rsp)
   d0f88:	lea    0x9f451(%rip),%rax        # 1703e0 <<&T as core::fmt::Display>::fmt>
   d0f8f:	mov    %rax,0x328(%rsp)
   d0f97:	lea    0x796e52(%rip),%rax        # 867df0 <aws_lc_0_37_1_kem_asn1_meth+0xcf0>
   d0f9e:	mov    %rax,0x200(%rsp)
   d0fa6:	movq   $0x2,0x208(%rsp)
   d0fb2:	movq   $0x0,0x220(%rsp)
   d0fbe:	lea    0x320(%rsp),%rbx
   d0fc6:	mov    %rbx,0x210(%rsp)
   d0fce:	movq   $0x1,0x218(%rsp)
   d0fda:	lea    0x4a0(%rsp),%rdi
   d0fe2:	lea    0x200(%rsp),%rsi
   d0fea:	call   77f00 <alloc::fmt::format::format_inner>
   d0fef:	mov    %rbp,0x50(%rsp)
   d0ff4:	movups 0x4a0(%rsp),%xmm0
   d0ffc:	movaps %xmm0,0xc0(%rsp)
   d1004:	mov    0x4b0(%rsp),%rax
   d100c:	mov    %rax,0xd0(%rsp)
   d1014:	mov    0x128(%r14),%rsi
   d101b:	lea    0x6e0(%rsp),%rdi
   d1023:	lea    0x540(%rsp),%rdx
   d102b:	lea    0xc0(%rsp),%rcx
   d1033:	call   148990 <reqwest::async_impl::client::Client::request>
   d1038:	mov    $0x2,%eax
   d103d:	mov    %rax,0x40(%rsp)
   d1042:	mov    $0x1,%bpl
   d1045:	cmpl   $0x2,0x6e0(%rsp)
   d104d:	je     d330f <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x241f>
   d1053:	mov    0x8(%rsp),%rax
   d1058:	mov    0x30(%rax),%rcx
   d105c:	mov    %rcx,(%rsp)
   d1060:	mov    0x38(%rax),%r15
   d1064:	movzbl 0x7b9c1d(%rip),%eax        # 88ac88 <__rust_no_alloc_shim_is_unstable>
   d106b:	mov    $0x80,%edi
   d1070:	call   *0x7b8b9a(%rip)        # 889c10 <malloc@GLIBC_2.2.5>
   d1076:	test   %rax,%rax
   d1079:	je     d663d <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x574d>
   d107f:	mov    %rax,%r14
   d1082:	movq   $0x80,0x320(%rsp)
   d108e:	mov    %rax,0x328(%rsp)
   d1096:	movq   $0x0,0x330(%rsp)
   d10a2:	mov    %rbx,0x130(%rsp)
   d10aa:	movb   $0x5b,(%rax)
   d10ad:	movq   $0x1,0x330(%rsp)
   d10b9:	test   %r15,%r15
   d10bc:	je     d3030 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2140>
   d10c2:	imul   $0x198,%r15,%rax
   d10c9:	mov    %rax,0x20(%rsp)
   d10ce:	mov    $0x1,%al
   d10d0:	xor    %r15d,%r15d
   d10d3:	jmp    d10f4 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x204>
   d10d5:	data16 cs nopw 0x0(%rax,%rax,1)
   d10e0:	add    $0x198,%r15
   d10e7:	xor    %eax,%eax
   d10e9:	cmp    %r15,0x20(%rsp)
   d10ee:	je     d41d2 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x32e2>
   d10f4:	mov    0x130(%rsp),%r14
   d10fc:	test   $0x1,%al
   d10fe:	jne    d1124 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x234>
   d1100:	mov    0x10(%r14),%rsi
   d1104:	cmp    %rsi,(%r14)
   d1107:	je     d2e45 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1f55>
   d110d:	mov    0x8(%r14),%rax
   d1111:	movb   $0x2c,(%rax,%rsi,1)
   d1115:	inc    %rsi
   d1118:	mov    %rsi,0x10(%r14)
   d111c:	mov    0x130(%rsp),%r14
   d1124:	mov    (%rsp),%rax
   d1128:	movzbl 0x190(%rax,%r15,1),%eax
   d1131:	mov    %al,0x88(%rsp)
   d1138:	mov    0x10(%r14),%rsi
   d113c:	cmp    %rsi,(%r14)
   d113f:	je     d2568 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1678>
   d1145:	mov    0x8(%r14),%rax
   d1149:	movb   $0x7b,(%rax,%rsi,1)
   d114d:	inc    %rsi
   d1150:	mov    %rsi,0x10(%r14)
   d1154:	mov    (%rsp),%rax
   d1158:	movzbl 0x17c(%rax,%r15,1),%ebx
   d1161:	cmp    $0x2,%bl
   d1164:	jb     d126b <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x37b>
   d116a:	mov    %bl,0x60(%rsp)
   d116e:	lea    0x60(%rsp),%rax
   d1173:	mov    %rax,0x5e8(%rsp)
   d117b:	lea    0x13f53e(%rip),%rax        # 2106c0 <core::fmt::num::imp::<impl core::fmt::Display for u8>::fmt>
   d1182:	mov    %rax,0x5f0(%rsp)
   d118a:	lea    0x7a6d17(%rip),%rax        # 877ea8 <bytes::bytes::PROMOTABLE_ODD_VTABLE+0x2ec0>
   d1191:	mov    %rax,0x200(%rsp)
   d1199:	movq   $0x1,0x208(%rsp)
   d11a5:	movq   $0x0,0x220(%rsp)
   d11b1:	lea    0x5e8(%rsp),%rax
   d11b9:	mov    %rax,0x210(%rsp)
   d11c1:	movq   $0x1,0x218(%rsp)
   d11cd:	lea    0x540(%rsp),%rdi
   d11d5:	lea    0x200(%rsp),%rsi
   d11dd:	call   77f00 <alloc::fmt::format::format_inner>
   d11e2:	movzbl 0x7b9a9f(%rip),%eax        # 88ac88 <__rust_no_alloc_shim_is_unstable>
   d11e9:	mov    $0x18,%edi
   d11ee:	call   *0x7b8a1c(%rip)        # 889c10 <malloc@GLIBC_2.2.5>
   d11f4:	test   %rax,%rax
   d11f7:	je     d6586 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5696>
   d11fd:	mov    %rax,%r14
   d1200:	mov    0x550(%rsp),%rax
   d1208:	mov    %rax,0x10(%r14)
   d120c:	movups 0x540(%rsp),%xmm0
   d1214:	movups %xmm0,(%r14)
   d1218:	lea    0x200(%rsp),%rdi
   d1220:	call   4860e0 <std::backtrace::Backtrace::capture>
   d1225:	mov    0x200(%rsp),%rax
   d122d:	movzbl 0x208(%rsp),%ebx
   d1235:	lea    0x238(%rsp),%rcx
   d123d:	movups -0x2f(%rcx),%xmm0
   d1241:	movups -0x1f(%rcx),%xmm1
   d1245:	movaps %xmm0,0xc0(%rsp)
   d124d:	movaps %xmm1,0xd0(%rsp)
   d1255:	mov    -0x10(%rcx),%rcx
   d1259:	mov    %rcx,0xdf(%rsp)
   d1261:	cmp    $0x3,%rax
   d1265:	jne    d64db <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x55eb>
   d126b:	mov    (%rsp),%rax
   d126f:	movzbl 0x17d(%rax,%r15,1),%ebp
   d1278:	lea    (%rax,%r15,1),%rdi
   d127c:	add    $0x18,%rdi
   d1280:	movq   $0x0,0xc0(%rsp)
   d128c:	movq   $0x1,0xc8(%rsp)
   d1298:	movq   $0x0,0xd0(%rsp)
   d12a4:	lea    0xc0(%rsp),%rsi
   d12ac:	lea    0x79c8b5(%rip),%rdx        # 86db68 <aws_lc_0_37_1_kem_asn1_meth+0x6a68>
   d12b3:	call   79f50 <<alloy_primitives::signature::sig::Signature as core::fmt::Display>::fmt>
   d12b8:	test   %al,%al
   d12ba:	jne    d655d <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x566d>
   d12c0:	mov    (%rsp),%r14
   d12c4:	lea    (%r14,%r15,1),%rax
   d12c8:	add    $0x60,%rax
   d12cc:	movups 0xc0(%rsp),%xmm0
   d12d4:	movaps %xmm0,0x200(%rsp)
   d12dc:	mov    0xd0(%rsp),%rcx
   d12e4:	mov    %rcx,0x210(%rsp)
   d12ec:	lea    0x120(%r14,%r15,1),%rcx
   d12f4:	lea    0x100(%r14,%r15,1),%rdx
   d12fc:	lea    0xe0(%r14,%r15,1),%rsi
   d1304:	lea    0xc0(%r14,%r15,1),%rdi
   d130c:	lea    0xa0(%r14,%r15,1),%r8
   d1314:	lea    0x80(%r14,%r15,1),%r9
   d131c:	lea    0x168(%r14,%r15,1),%r10
   d1324:	lea    0x154(%r14,%r15,1),%r11
   d132c:	mov    %r15,0x38(%rsp)
   d1331:	lea    0x140(%r14,%r15,1),%r14
   d1339:	mov    %rax,0x218(%rsp)
   d1341:	mov    %r14,0x220(%rsp)
   d1349:	mov    %r11,0x228(%rsp)
   d1351:	mov    %r10,0x230(%rsp)
   d1359:	mov    %r9,0x238(%rsp)
   d1361:	mov    %r8,0x240(%rsp)
   d1369:	mov    %rdi,0x248(%rsp)
   d1371:	mov    %rsi,0x250(%rsp)
   d1379:	mov    %rdx,0x258(%rsp)
   d1381:	mov    %rcx,0x260(%rsp)
   d1389:	mov    %bl,0x268(%rsp)
   d1390:	mov    %bpl,0x269(%rsp)
   d1398:	mov    0x130(%rsp),%r14
   d13a0:	mov    0x10(%r14),%rsi
   d13a4:	cmp    %rsi,(%r14)
   d13a7:	je     d2589 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1699>
   d13ad:	lea    0x130(%rsp),%rbx
   d13b5:	mov    0x8(%r14),%rax
   d13b9:	movb   $0x22,(%rax,%rsi,1)
   d13bd:	inc    %rsi
   d13c0:	mov    %rsi,0x10(%r14)
   d13c4:	mov    $0x5,%edx
   d13c9:	mov    %r14,%rdi
   d13cc:	lea    0x60ca06(%rip),%rsi        # 6dddd9 <encoding_rs::data::KSX1001_LOWERCASE+0x13ff9>
   d13d3:	call   1b18b0 <serde_json::ser::format_escaped_str_contents>
   d13d8:	mov    0x10(%r14),%rsi
   d13dc:	cmp    %rsi,(%r14)
   d13df:	je     d25b2 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x16c2>
   d13e5:	mov    0x8(%r14),%rax
   d13e9:	movb   $0x22,(%rax,%rsi,1)
   d13ed:	inc    %rsi
   d13f0:	mov    %rsi,0x10(%r14)
   d13f4:	mov    0x130(%rsp),%r14
   d13fc:	mov    0x10(%r14),%rsi
   d1400:	cmp    %rsi,(%r14)
   d1403:	je     d25d3 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x16e3>
   d1409:	mov    0x8(%r14),%rax
   d140d:	movb   $0x3a,(%rax,%rsi,1)
   d1411:	inc    %rsi
   d1414:	mov    %rsi,0x10(%r14)
   d1418:	mov    0x130(%rsp),%r14
   d1420:	mov    0x10(%r14),%rsi
   d1424:	cmp    %rsi,(%r14)
   d1427:	je     d25f4 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1704>
   d142d:	mov    0x8(%r14),%rax
   d1431:	movb   $0x7b,(%rax,%rsi,1)
   d1435:	inc    %rsi
   d1438:	mov    %rsi,0x10(%r14)
   d143c:	movb   $0x0,0x540(%rsp)
   d1444:	mov    %rbx,0x548(%rsp)
   d144c:	cmp    %rsi,(%r14)
   d144f:	je     d2615 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1725>
   d1455:	mov    0x8(%r14),%rax
   d1459:	movb   $0x22,(%rax,%rsi,1)
   d145d:	inc    %rsi
   d1460:	mov    %rsi,0x10(%r14)
   d1464:	mov    $0x4,%edx
   d1469:	mov    %r14,%rdi
   d146c:	lea    0x5fbe0d(%rip),%rsi        # 6cd280 <encoding_rs::data::KSX1001_LOWERCASE+0x34a0>
   d1473:	call   1b18b0 <serde_json::ser::format_escaped_str_contents>
   d1478:	mov    0x10(%r14),%rsi
   d147c:	cmp    %rsi,(%r14)
   d147f:	je     d2636 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1746>
   d1485:	mov    0x8(%r14),%rax
   d1489:	movb   $0x22,(%rax,%rsi,1)
   d148d:	inc    %rsi
   d1490:	mov    %rsi,0x10(%r14)
   d1494:	mov    0x130(%rsp),%r14
   d149c:	mov    0x10(%r14),%rsi
   d14a0:	cmp    %rsi,(%r14)
   d14a3:	je     d2657 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1767>
   d14a9:	mov    0x8(%r14),%rax
   d14ad:	movb   $0x3a,(%rax,%rsi,1)
   d14b1:	inc    %rsi
   d14b4:	mov    %rsi,0x10(%r14)
   d14b8:	mov    0x218(%rsp),%rax
   d14c0:	mov    (%rax),%rdi
   d14c3:	mov    0x10(%rax),%rcx
   d14c7:	or     0x8(%rax),%rcx
   d14cb:	or     0x18(%rax),%rcx
   d14cf:	jne    d3253 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2363>
   d14d5:	mov    0x130(%rsp),%r14
   d14dd:	lea    0xc0(%rsp),%rsi
   d14e5:	call   27f820 <<u64 as itoa::Unsigned>::fmt>
   d14ea:	mov    %rax,%r13
   d14ed:	mov    $0x14,%r15d
   d14f3:	sub    %rax,%r15
   d14f6:	mov    (%r14),%rax
   d14f9:	mov    0x10(%r14),%r12
   d14fd:	sub    %r12,%rax
   d1500:	cmp    %rax,%r15
   d1503:	ja     d2678 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1788>
   d1509:	lea    (%rsp,%r13,1),%rsi
   d150d:	add    $0xc0,%rsi
   d1514:	mov    0x8(%r14),%rdi
   d1518:	add    %r12,%rdi
   d151b:	mov    %r15,%rdx
   d151e:	call   *0x7b83d4(%rip)        # 8898f8 <memcpy@GLIBC_2.14>
   d1524:	add    %r15,%r12
   d1527:	mov    %r12,0x10(%r14)
   d152b:	mov    0x220(%rsp),%r14
   d1533:	mov    0x130(%rsp),%r15
   d153b:	mov    0x10(%r15),%rsi
   d153f:	cmp    %rsi,(%r15)
   d1542:	je     d269a <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x17aa>
   d1548:	mov    0x8(%r15),%rax
   d154c:	movb   $0x2c,(%rax,%rsi,1)
   d1550:	inc    %rsi
   d1553:	mov    %rsi,0x10(%r15)
   d1557:	mov    0x130(%rsp),%r15
   d155f:	mov    0x10(%r15),%rsi
   d1563:	cmp    %rsi,(%r15)
   d1566:	je     d26bb <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x17cb>
   d156c:	mov    0x8(%r15),%rax
   d1570:	movb   $0x22,(%rax,%rsi,1)
   d1574:	inc    %rsi
   d1577:	mov    %rsi,0x10(%r15)
   d157b:	mov    $0x5,%edx
   d1580:	mov    %r15,%rdi
   d1583:	lea    0x60c5cb(%rip),%rsi        # 6ddb55 <encoding_rs::data::KSX1001_LOWERCASE+0x13d75>
   d158a:	call   1b18b0 <serde_json::ser::format_escaped_str_contents>
   d158f:	mov    0x10(%r15),%rsi
   d1593:	cmp    %rsi,(%r15)
   d1596:	je     d26dc <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x17ec>
   d159c:	mov    0x8(%r15),%rax
   d15a0:	movb   $0x22,(%rax,%rsi,1)
   d15a4:	inc    %rsi
   d15a7:	mov    %rsi,0x10(%r15)
   d15ab:	mov    0x130(%rsp),%r15
   d15b3:	mov    0x10(%r15),%rsi
   d15b7:	cmp    %rsi,(%r15)
   d15ba:	je     d26fd <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x180d>
   d15c0:	mov    0x8(%r15),%rax
   d15c4:	movb   $0x3a,(%rax,%rsi,1)
   d15c8:	inc    %rsi
   d15cb:	mov    %rsi,0x10(%r15)
   d15cf:	mov    %r14,%rdi
   d15d2:	mov    %rbx,%rsi
   d15d5:	call   65a80 <alloy_primitives::bits::serde::<impl serde_core::ser::Serialize for alloy_primitives::bits::fixed::FixedBytes<_>>::serialize>
   d15da:	mov    0x228(%rsp),%r14
   d15e2:	mov    0x130(%rsp),%r15
   d15ea:	mov    0x10(%r15),%rsi
   d15ee:	cmp    %rsi,(%r15)
   d15f1:	je     d271e <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x182e>
   d15f7:	mov    0x8(%r15),%rax
   d15fb:	movb   $0x2c,(%rax,%rsi,1)
   d15ff:	inc    %rsi
   d1602:	mov    %rsi,0x10(%r15)
   d1606:	mov    0x130(%rsp),%r15
   d160e:	mov    0x10(%r15),%rsi
   d1612:	cmp    %rsi,(%r15)
   d1615:	je     d273f <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x184f>
   d161b:	mov    0x8(%r15),%rax
   d161f:	movb   $0x22,(%rax,%rsi,1)
   d1623:	inc    %rsi
   d1626:	mov    %rsi,0x10(%r15)
   d162a:	mov    $0x6,%edx
   d162f:	mov    %r15,%rdi
   d1632:	lea    0x665264(%rip),%rsi        # 73689d <mime::parse::TOKEN_MAP+0x11de>
   d1639:	call   1b18b0 <serde_json::ser::format_escaped_str_contents>
   d163e:	mov    0x10(%r15),%rsi
   d1642:	cmp    %rsi,(%r15)
   d1645:	je     d2760 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1870>
   d164b:	mov    0x8(%r15),%rax
   d164f:	movb   $0x22,(%rax,%rsi,1)
   d1653:	inc    %rsi
   d1656:	mov    %rsi,0x10(%r15)
   d165a:	mov    0x130(%rsp),%r15
   d1662:	mov    0x10(%r15),%rsi
   d1666:	cmp    %rsi,(%r15)
   d1669:	je     d2781 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1891>
   d166f:	mov    0x8(%r15),%rax
   d1673:	movb   $0x3a,(%rax,%rsi,1)
   d1677:	inc    %rsi
   d167a:	mov    %rsi,0x10(%r15)
   d167e:	mov    %r14,%rdi
   d1681:	mov    %rbx,%rsi
   d1684:	call   65a80 <alloy_primitives::bits::serde::<impl serde_core::ser::Serialize for alloy_primitives::bits::fixed::FixedBytes<_>>::serialize>
   d1689:	mov    0x230(%rsp),%r14
   d1691:	mov    0x130(%rsp),%r15
   d1699:	mov    0x10(%r15),%rsi
   d169d:	cmp    %rsi,(%r15)
   d16a0:	je     d27a2 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x18b2>
   d16a6:	mov    0x8(%r15),%rax
   d16aa:	movb   $0x2c,(%rax,%rsi,1)
   d16ae:	inc    %rsi
   d16b1:	mov    %rsi,0x10(%r15)
   d16b5:	mov    0x130(%rsp),%r15
   d16bd:	mov    0x10(%r15),%rsi
   d16c1:	cmp    %rsi,(%r15)
   d16c4:	je     d27c3 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x18d3>
   d16ca:	mov    0x8(%r15),%rax
   d16ce:	movb   $0x22,(%rax,%rsi,1)
   d16d2:	inc    %rsi
   d16d5:	mov    %rsi,0x10(%r15)
   d16d9:	mov    $0x5,%edx
   d16de:	mov    %r15,%rdi
   d16e1:	lea    0x60c472(%rip),%rsi        # 6ddb5a <encoding_rs::data::KSX1001_LOWERCASE+0x13d7a>
   d16e8:	call   1b18b0 <serde_json::ser::format_escaped_str_contents>
   d16ed:	mov    0x10(%r15),%rsi
   d16f1:	cmp    %rsi,(%r15)
   d16f4:	je     d27e4 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x18f4>
   d16fa:	mov    0x8(%r15),%rax
   d16fe:	movb   $0x22,(%rax,%rsi,1)
   d1702:	inc    %rsi
   d1705:	mov    %rsi,0x10(%r15)
   d1709:	mov    0x130(%rsp),%r15
   d1711:	mov    0x10(%r15),%rsi
   d1715:	cmp    %rsi,(%r15)
   d1718:	je     d2805 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1915>
   d171e:	mov    0x8(%r15),%rax
   d1722:	movb   $0x3a,(%rax,%rsi,1)
   d1726:	inc    %rsi
   d1729:	mov    %rsi,0x10(%r15)
   d172d:	mov    %r14,%rdi
   d1730:	mov    %rbx,%rsi
   d1733:	call   65a80 <alloy_primitives::bits::serde::<impl serde_core::ser::Serialize for alloy_primitives::bits::fixed::FixedBytes<_>>::serialize>
   d1738:	mov    0x130(%rsp),%r14
   d1740:	mov    0x10(%r14),%rsi
   d1744:	cmp    %rsi,(%r14)
   d1747:	je     d2826 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1936>
   d174d:	mov    0x8(%r14),%rax
   d1751:	movb   $0x2c,(%rax,%rsi,1)
   d1755:	inc    %rsi
   d1758:	mov    %rsi,0x10(%r14)
   d175c:	mov    0x130(%rsp),%r14
   d1764:	mov    0x10(%r14),%rsi
   d1768:	cmp    %rsi,(%r14)
   d176b:	je     d2847 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1957>
   d1771:	mov    0x8(%r14),%rax
   d1775:	movb   $0x22,(%rax,%rsi,1)
   d1779:	inc    %rsi
   d177c:	mov    %rsi,0x10(%r14)
   d1780:	mov    $0x7,%edx
   d1785:	mov    %r14,%rdi
   d1788:	lea    0x60c3d0(%rip),%rsi        # 6ddb5f <encoding_rs::data::KSX1001_LOWERCASE+0x13d7f>
   d178f:	call   1b18b0 <serde_json::ser::format_escaped_str_contents>
   d1794:	mov    0x10(%r14),%rsi
   d1798:	cmp    %rsi,(%r14)
   d179b:	je     d2868 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1978>
   d17a1:	mov    0x8(%r14),%rax
   d17a5:	movb   $0x22,(%rax,%rsi,1)
   d17a9:	inc    %rsi
   d17ac:	mov    %rsi,0x10(%r14)
   d17b0:	mov    0x130(%rsp),%r14
   d17b8:	mov    0x10(%r14),%rsi
   d17bc:	cmp    %rsi,(%r14)
   d17bf:	je     d2889 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1999>
   d17c5:	mov    0x8(%r14),%rax
   d17c9:	movb   $0x3a,(%rax,%rsi,1)
   d17cd:	inc    %rsi
   d17d0:	mov    %rsi,0x10(%r14)
   d17d4:	mov    %rbx,%rdi
   d17d7:	lea    0x238(%rsp),%rsi
   d17df:	call   1b21d0 <<&mut serde_json::ser::Serializer<W,F> as serde_core::ser::Serializer>::collect_str>
   d17e4:	mov    %rax,%r14
   d17e7:	test   %rax,%rax
   d17ea:	jne    d3283 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2393>
   d17f0:	mov    0x130(%rsp),%r14
   d17f8:	mov    0x10(%r14),%rsi
   d17fc:	cmp    %rsi,(%r14)
   d17ff:	je     d28aa <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x19ba>
   d1805:	mov    0x8(%r14),%rax
   d1809:	movb   $0x2c,(%rax,%rsi,1)
   d180d:	inc    %rsi
   d1810:	mov    %rsi,0x10(%r14)
   d1814:	mov    0x130(%rsp),%r14
   d181c:	mov    0x10(%r14),%rsi
   d1820:	cmp    %rsi,(%r14)
   d1823:	je     d28cb <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x19db>
   d1829:	mov    0x8(%r14),%rax
   d182d:	movb   $0x22,(%rax,%rsi,1)
   d1831:	inc    %rsi
   d1834:	mov    %rsi,0x10(%r14)
   d1838:	mov    $0xb,%edx
   d183d:	mov    %r14,%rdi
   d1840:	lea    0x60c31f(%rip),%rsi        # 6ddb66 <encoding_rs::data::KSX1001_LOWERCASE+0x13d86>
   d1847:	call   1b18b0 <serde_json::ser::format_escaped_str_contents>
   d184c:	mov    0x10(%r14),%rsi
   d1850:	cmp    %rsi,(%r14)
   d1853:	je     d28ec <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x19fc>
   d1859:	mov    0x8(%r14),%rax
   d185d:	movb   $0x22,(%rax,%rsi,1)
   d1861:	inc    %rsi
   d1864:	mov    %rsi,0x10(%r14)
   d1868:	mov    0x130(%rsp),%r14
   d1870:	mov    0x10(%r14),%rsi
   d1874:	cmp    %rsi,(%r14)
   d1877:	je     d290d <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1a1d>
   d187d:	mov    0x8(%r14),%rax
   d1881:	movb   $0x3a,(%rax,%rsi,1)
   d1885:	inc    %rsi
   d1888:	mov    %rsi,0x10(%r14)
   d188c:	mov    %rbx,%rdi
   d188f:	lea    0x240(%rsp),%rsi
   d1897:	call   1b21d0 <<&mut serde_json::ser::Serializer<W,F> as serde_core::ser::Serializer>::collect_str>
   d189c:	mov    %rax,%r14
   d189f:	test   %rax,%rax
   d18a2:	jne    d3283 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2393>
   d18a8:	mov    0x130(%rsp),%r14
   d18b0:	mov    0x10(%r14),%rsi
   d18b4:	cmp    %rsi,(%r14)
   d18b7:	je     d292e <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1a3e>
   d18bd:	mov    0x8(%r14),%rax
   d18c1:	movb   $0x2c,(%rax,%rsi,1)
   d18c5:	inc    %rsi
   d18c8:	mov    %rsi,0x10(%r14)
   d18cc:	movb   $0x2,0x541(%rsp)
   d18d4:	mov    0x130(%rsp),%r14
   d18dc:	mov    0x10(%r14),%rsi
   d18e0:	cmp    %rsi,(%r14)
   d18e3:	je     d294f <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1a5f>
   d18e9:	mov    0x8(%r14),%rax
   d18ed:	movb   $0x22,(%rax,%rsi,1)
   d18f1:	inc    %rsi
   d18f4:	mov    %rsi,0x10(%r14)
   d18f8:	mov    $0xb,%edx
   d18fd:	mov    %r14,%rdi
   d1900:	lea    0x60c26a(%rip),%rsi        # 6ddb71 <encoding_rs::data::KSX1001_LOWERCASE+0x13d91>
   d1907:	call   1b18b0 <serde_json::ser::format_escaped_str_contents>
   d190c:	mov    0x10(%r14),%rsi
   d1910:	cmp    %rsi,(%r14)
   d1913:	je     d2970 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1a80>
   d1919:	mov    0x8(%r14),%rax
   d191d:	movb   $0x22,(%rax,%rsi,1)
   d1921:	inc    %rsi
   d1924:	mov    %rsi,0x10(%r14)
   d1928:	mov    0x130(%rsp),%r14
   d1930:	mov    0x10(%r14),%rsi
   d1934:	cmp    %rsi,(%r14)
   d1937:	je     d2991 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1aa1>
   d193d:	mov    0x8(%r14),%rax
   d1941:	movb   $0x3a,(%rax,%rsi,1)
   d1945:	inc    %rsi
   d1948:	mov    %rsi,0x10(%r14)
   d194c:	mov    %rbx,%rdi
   d194f:	lea    0x248(%rsp),%rsi
   d1957:	call   1b21d0 <<&mut serde_json::ser::Serializer<W,F> as serde_core::ser::Serializer>::collect_str>
   d195c:	mov    %rax,%r14
   d195f:	test   %rax,%rax
   d1962:	jne    d3283 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2393>
   d1968:	mov    0x130(%rsp),%r14
   d1970:	mov    0x10(%r14),%rsi
   d1974:	cmp    %rsi,(%r14)
   d1977:	je     d29b2 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1ac2>
   d197d:	mov    0x8(%r14),%rax
   d1981:	movb   $0x2c,(%rax,%rsi,1)
   d1985:	inc    %rsi
   d1988:	mov    %rsi,0x10(%r14)
   d198c:	mov    0x130(%rsp),%r14
   d1994:	mov    0x10(%r14),%rsi
   d1998:	cmp    %rsi,(%r14)
   d199b:	je     d29d3 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1ae3>
   d19a1:	mov    0x8(%r14),%rax
   d19a5:	movb   $0x22,(%rax,%rsi,1)
   d19a9:	inc    %rsi
   d19ac:	mov    %rsi,0x10(%r14)
   d19b0:	mov    $0xa,%edx
   d19b5:	mov    %r14,%rdi
   d19b8:	lea    0x60c1bd(%rip),%rsi        # 6ddb7c <encoding_rs::data::KSX1001_LOWERCASE+0x13d9c>
   d19bf:	call   1b18b0 <serde_json::ser::format_escaped_str_contents>
   d19c4:	mov    0x10(%r14),%rsi
   d19c8:	cmp    %rsi,(%r14)
   d19cb:	je     d29f4 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1b04>
   d19d1:	mov    0x8(%r14),%rax
   d19d5:	movb   $0x22,(%rax,%rsi,1)
   d19d9:	inc    %rsi
   d19dc:	mov    %rsi,0x10(%r14)
   d19e0:	mov    0x130(%rsp),%r14
   d19e8:	mov    0x10(%r14),%rsi
   d19ec:	cmp    %rsi,(%r14)
   d19ef:	je     d2a15 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1b25>
   d19f5:	mov    0x8(%r14),%rax
   d19f9:	movb   $0x3a,(%rax,%rsi,1)
   d19fd:	inc    %rsi
   d1a00:	mov    %rsi,0x10(%r14)
   d1a04:	mov    %rbx,%rdi
   d1a07:	lea    0x250(%rsp),%rsi
   d1a0f:	call   1b21d0 <<&mut serde_json::ser::Serializer<W,F> as serde_core::ser::Serializer>::collect_str>
   d1a14:	mov    %rax,%r14
   d1a17:	test   %rax,%rax
   d1a1a:	jne    d3283 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2393>
   d1a20:	mov    0x130(%rsp),%r14
   d1a28:	mov    0x10(%r14),%rsi
   d1a2c:	cmp    %rsi,(%r14)
   d1a2f:	je     d2a36 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1b46>
   d1a35:	mov    0x8(%r14),%rax
   d1a39:	movb   $0x2c,(%rax,%rsi,1)
   d1a3d:	inc    %rsi
   d1a40:	mov    %rsi,0x10(%r14)
   d1a44:	mov    0x130(%rsp),%r14
   d1a4c:	mov    0x10(%r14),%rsi
   d1a50:	cmp    %rsi,(%r14)
   d1a53:	je     d2a57 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1b67>
   d1a59:	mov    0x8(%r14),%rax
   d1a5d:	movb   $0x22,(%rax,%rsi,1)
   d1a61:	inc    %rsi
   d1a64:	mov    %rsi,0x10(%r14)
   d1a68:	mov    $0x5,%edx
   d1a6d:	mov    %r14,%rdi
   d1a70:	lea    0x60c10f(%rip),%rsi        # 6ddb86 <encoding_rs::data::KSX1001_LOWERCASE+0x13da6>
   d1a77:	call   1b18b0 <serde_json::ser::format_escaped_str_contents>
   d1a7c:	mov    0x10(%r14),%rsi
   d1a80:	cmp    %rsi,(%r14)
   d1a83:	je     d2a78 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1b88>
   d1a89:	mov    0x8(%r14),%rax
   d1a8d:	movb   $0x22,(%rax,%rsi,1)
   d1a91:	inc    %rsi
   d1a94:	mov    %rsi,0x10(%r14)
   d1a98:	mov    0x130(%rsp),%r14
   d1aa0:	mov    0x10(%r14),%rsi
   d1aa4:	cmp    %rsi,(%r14)
   d1aa7:	je     d2a99 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1ba9>
   d1aad:	mov    0x8(%r14),%rax
   d1ab1:	movb   $0x3a,(%rax,%rsi,1)
   d1ab5:	inc    %rsi
   d1ab8:	mov    %rsi,0x10(%r14)
   d1abc:	mov    %rbx,%rdi
   d1abf:	lea    0x258(%rsp),%rsi
   d1ac7:	call   1b21d0 <<&mut serde_json::ser::Serializer<W,F> as serde_core::ser::Serializer>::collect_str>
   d1acc:	mov    %rax,%r14
   d1acf:	test   %rax,%rax
   d1ad2:	jne    d3283 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2393>
   d1ad8:	mov    0x130(%rsp),%r14
   d1ae0:	mov    0x10(%r14),%rsi
   d1ae4:	cmp    %rsi,(%r14)
   d1ae7:	je     d2aba <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1bca>
   d1aed:	mov    0x8(%r14),%rax
   d1af1:	movb   $0x2c,(%rax,%rsi,1)
   d1af5:	inc    %rsi
   d1af8:	mov    %rsi,0x10(%r14)
   d1afc:	mov    0x130(%rsp),%r14
   d1b04:	mov    0x10(%r14),%rsi
   d1b08:	cmp    %rsi,(%r14)
   d1b0b:	je     d2adb <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1beb>
   d1b11:	mov    0x8(%r14),%rax
   d1b15:	movb   $0x22,(%rax,%rsi,1)
   d1b19:	inc    %rsi
   d1b1c:	mov    %rsi,0x10(%r14)
   d1b20:	mov    $0xa,%edx
   d1b25:	mov    %r14,%rdi
   d1b28:	lea    0x60c05c(%rip),%rsi        # 6ddb8b <encoding_rs::data::KSX1001_LOWERCASE+0x13dab>
   d1b2f:	call   1b18b0 <serde_json::ser::format_escaped_str_contents>
   d1b34:	mov    0x10(%r14),%rsi
   d1b38:	cmp    %rsi,(%r14)
   d1b3b:	je     d2afc <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1c0c>
   d1b41:	mov    0x8(%r14),%rax
   d1b45:	movb   $0x22,(%rax,%rsi,1)
   d1b49:	inc    %rsi
   d1b4c:	mov    %rsi,0x10(%r14)
   d1b50:	mov    0x130(%rsp),%r14
   d1b58:	mov    0x10(%r14),%rsi
   d1b5c:	cmp    %rsi,(%r14)
   d1b5f:	je     d2b1d <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1c2d>
   d1b65:	mov    0x8(%r14),%rax
   d1b69:	movb   $0x3a,(%rax,%rsi,1)
   d1b6d:	inc    %rsi
   d1b70:	mov    %rsi,0x10(%r14)
   d1b74:	mov    %rbx,%rdi
   d1b77:	lea    0x260(%rsp),%rsi
   d1b7f:	call   1b21d0 <<&mut serde_json::ser::Serializer<W,F> as serde_core::ser::Serializer>::collect_str>
   d1b84:	mov    %rax,%r14
   d1b87:	test   %rax,%rax
   d1b8a:	jne    d3283 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2393>
   d1b90:	movsbq 0x268(%rsp),%r15
   d1b99:	mov    0x130(%rsp),%r14
   d1ba1:	mov    0x10(%r14),%rsi
   d1ba5:	cmp    %rsi,(%r14)
   d1ba8:	je     d2b3e <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1c4e>
   d1bae:	mov    0x8(%r14),%rax
   d1bb2:	movb   $0x2c,(%rax,%rsi,1)
   d1bb6:	inc    %rsi
   d1bb9:	mov    %rsi,0x10(%r14)
   d1bbd:	mov    0x130(%rsp),%r14
   d1bc5:	mov    0x10(%r14),%rsi
   d1bc9:	cmp    %rsi,(%r14)
   d1bcc:	je     d2b5f <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1c6f>
   d1bd2:	mov    0x8(%r14),%rax
   d1bd6:	movb   $0x22,(%rax,%rsi,1)
   d1bda:	inc    %rsi
   d1bdd:	mov    %rsi,0x10(%r14)
   d1be1:	mov    $0x4,%edx
   d1be6:	mov    %r14,%rdi
   d1be9:	lea    0x5fb694(%rip),%rsi        # 6cd284 <encoding_rs::data::KSX1001_LOWERCASE+0x34a4>
   d1bf0:	call   1b18b0 <serde_json::ser::format_escaped_str_contents>
   d1bf5:	mov    0x10(%r14),%rsi
   d1bf9:	cmp    %rsi,(%r14)
   d1bfc:	je     d2b80 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1c90>
   d1c02:	mov    0x8(%r14),%rax
   d1c06:	movb   $0x22,(%rax,%rsi,1)
   d1c0a:	inc    %rsi
   d1c0d:	mov    %rsi,0x10(%r14)
   d1c11:	mov    0x130(%rsp),%r14
   d1c19:	mov    0x10(%r14),%rsi
   d1c1d:	cmp    %rsi,(%r14)
   d1c20:	je     d2ba1 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1cb1>
   d1c26:	mov    0x8(%r14),%rax
   d1c2a:	movb   $0x3a,(%rax,%rsi,1)
   d1c2e:	inc    %rsi
   d1c31:	mov    %rsi,0x10(%r14)
   d1c35:	mov    0x130(%rsp),%r14
   d1c3d:	mov    0x10(%r14),%rsi
   d1c41:	cmp    %rsi,(%r14)
   d1c44:	je     d2bc2 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1cd2>
   d1c4a:	mov    0x8(%r14),%rax
   d1c4e:	movb   $0x22,(%rax,%rsi,1)
   d1c52:	inc    %rsi
   d1c55:	mov    %rsi,0x10(%r14)
   d1c59:	lea    0x60c1f8(%rip),%rax        # 6dde58 <encoding_rs::data::KSX1001_LOWERCASE+0x14078>
   d1c60:	movslq 0x4(%rax,%r15,4),%rsi
   d1c65:	add    %rax,%rsi
   d1c68:	lea    0x60c1f9(%rip),%rax        # 6dde68 <encoding_rs::data::KSX1001_LOWERCASE+0x14088>
   d1c6f:	mov    0x8(%rax,%r15,8),%rdx
   d1c74:	mov    %r14,%rdi
   d1c77:	call   1b18b0 <serde_json::ser::format_escaped_str_contents>
   d1c7c:	mov    0x10(%r14),%rsi
   d1c80:	cmp    %rsi,(%r14)
   d1c83:	je     d2be3 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1cf3>
   d1c89:	mov    0x8(%r14),%rax
   d1c8d:	movb   $0x22,(%rax,%rsi,1)
   d1c91:	inc    %rsi
   d1c94:	mov    %rsi,0x10(%r14)
   d1c98:	movzbl 0x269(%rsp),%r15d
   d1ca1:	mov    0x130(%rsp),%r14
   d1ca9:	mov    0x10(%r14),%rsi
   d1cad:	cmp    %rsi,(%r14)
   d1cb0:	je     d2c04 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1d14>
   d1cb6:	mov    0x8(%r14),%rax
   d1cba:	movb   $0x2c,(%rax,%rsi,1)
   d1cbe:	inc    %rsi
   d1cc1:	mov    %rsi,0x10(%r14)
   d1cc5:	movb   $0x2,0x541(%rsp)
   d1ccd:	mov    0x130(%rsp),%r14
   d1cd5:	mov    0x10(%r14),%rsi
   d1cd9:	cmp    %rsi,(%r14)
   d1cdc:	je     d2c25 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1d35>
   d1ce2:	mov    0x8(%r14),%rax
   d1ce6:	movb   $0x22,(%rax,%rsi,1)
   d1cea:	inc    %rsi
   d1ced:	mov    %rsi,0x10(%r14)
   d1cf1:	mov    $0xd,%edx
   d1cf6:	mov    %r14,%rdi
   d1cf9:	lea    0x60be95(%rip),%rsi        # 6ddb95 <encoding_rs::data::KSX1001_LOWERCASE+0x13db5>
   d1d00:	call   1b18b0 <serde_json::ser::format_escaped_str_contents>
   d1d05:	mov    0x10(%r14),%rsi
   d1d09:	cmp    %rsi,(%r14)
   d1d0c:	je     d2c46 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1d56>
   d1d12:	mov    0x8(%r14),%rax
   d1d16:	movb   $0x22,(%rax,%rsi,1)
   d1d1a:	inc    %rsi
   d1d1d:	mov    %rsi,0x10(%r14)
   d1d21:	mov    0x130(%rsp),%r14
   d1d29:	mov    0x10(%r14),%rsi
   d1d2d:	cmp    %rsi,(%r14)
   d1d30:	je     d2c67 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1d77>
   d1d36:	mov    0x8(%r14),%rax
   d1d3a:	movb   $0x3a,(%rax,%rsi,1)
   d1d3e:	inc    %rsi
   d1d41:	mov    %rsi,0x10(%r14)
   d1d45:	mov    $0x3,%ebx
   d1d4a:	mov    %r15d,%eax
   d1d4d:	cmp    $0xa,%r15b
   d1d51:	jb     d1d7d <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0xe8d>
   d1d53:	movzbl %r15b,%ecx
   d1d57:	imul   $0x147b,%ecx,%eax
   d1d5d:	shr    $0x13,%eax
   d1d60:	imul   $0xffffff9c,%eax,%edx
   d1d63:	add    %ecx,%edx
   d1d65:	lea    0x679dd4(%rip),%rcx        # 74bb40 <zmij::DIGITS2>
   d1d6c:	movzwl (%rcx,%rdx,2),%ecx
   d1d70:	mov    %cx,0xc1(%rsp)
   d1d78:	mov    $0x1,%ebx
   d1d7d:	mov    0x130(%rsp),%r14
   d1d85:	test   %r15b,%r15b
   d1d88:	je     d1d8e <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0xe9e>
   d1d8a:	test   %al,%al
   d1d8c:	je     d1d9a <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0xeaa>
   d1d8e:	or     $0x30,%al
   d1d90:	mov    %al,0xbf(%rsp,%rbx,1)
   d1d97:	dec    %rbx
   d1d9a:	mov    %rbx,%r15
   d1d9d:	xor    $0x3,%r15
   d1da1:	mov    (%r14),%rax
   d1da4:	mov    0x10(%r14),%r12
   d1da8:	sub    %r12,%rax
   d1dab:	cmp    %rax,%r15
   d1dae:	ja     d2c88 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1d98>
   d1db4:	lea    (%rsp,%rbx,1),%rsi
   d1db8:	add    $0xc0,%rsi
   d1dbf:	mov    0x8(%r14),%rdi
   d1dc3:	add    %r12,%rdi
   d1dc6:	mov    %r15,%rdx
   d1dc9:	call   *0x7b7b29(%rip)        # 8898f8 <memcpy@GLIBC_2.14>
   d1dcf:	add    %r15,%r12
   d1dd2:	mov    %r12,0x10(%r14)
   d1dd6:	mov    0x208(%rsp),%rcx
   d1dde:	mov    0x210(%rsp),%r8
   d1de6:	mov    $0x9,%edx
   d1deb:	lea    0x540(%rsp),%rdi
   d1df3:	lea    0x668f3e(%rip),%rsi        # 73ad38 <mime::parse::TOKEN_MAP+0x5679>
   d1dfa:	call   1b23a0 <serde_core::ser::SerializeMap::serialize_entry>
   d1dff:	testb  $0x1,0x540(%rsp)
   d1e07:	jne    d1e3a <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0xf4a>
   d1e09:	cmpb   $0x0,0x541(%rsp)
   d1e11:	je     d1e3a <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0xf4a>
   d1e13:	mov    0x548(%rsp),%rax
   d1e1b:	mov    (%rax),%r14
   d1e1e:	mov    0x10(%r14),%rsi
   d1e22:	cmp    %rsi,(%r14)
   d1e25:	je     d2e66 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1f76>
   d1e2b:	mov    0x8(%r14),%rax
   d1e2f:	movb   $0x7d,(%rax,%rsi,1)
   d1e33:	inc    %rsi
   d1e36:	mov    %rsi,0x10(%r14)
   d1e3a:	mov    0x130(%rsp),%r14
   d1e42:	mov    0x10(%r14),%rsi
   d1e46:	cmp    %rsi,(%r14)
   d1e49:	je     d2caa <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1dba>
   d1e4f:	mov    0x8(%r14),%rax
   d1e53:	movb   $0x2c,(%rax,%rsi,1)
   d1e57:	inc    %rsi
   d1e5a:	mov    %rsi,0x10(%r14)
   d1e5e:	mov    0x130(%rsp),%r14
   d1e66:	mov    0x10(%r14),%rsi
   d1e6a:	cmp    %rsi,(%r14)
   d1e6d:	je     d2ccb <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1ddb>
   d1e73:	mov    0x8(%r14),%rax
   d1e77:	movb   $0x22,(%rax,%rsi,1)
   d1e7b:	inc    %rsi
   d1e7e:	mov    %rsi,0x10(%r14)
   d1e82:	mov    $0x9,%edx
   d1e87:	mov    %r14,%rdi
   d1e8a:	lea    0x60bf4d(%rip),%rsi        # 6dddde <encoding_rs::data::KSX1001_LOWERCASE+0x13ffe>
   d1e91:	call   1b18b0 <serde_json::ser::format_escaped_str_contents>
   d1e96:	mov    0x10(%r14),%rsi
   d1e9a:	cmp    %rsi,(%r14)
   d1e9d:	je     d2cec <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1dfc>
   d1ea3:	mov    0x8(%r14),%rax
   d1ea7:	movb   $0x22,(%rax,%rsi,1)
   d1eab:	inc    %rsi
   d1eae:	mov    %rsi,0x10(%r14)
   d1eb2:	mov    0x130(%rsp),%r14
   d1eba:	mov    0x10(%r14),%rsi
   d1ebe:	cmp    %rsi,(%r14)
   d1ec1:	mov    0x38(%rsp),%rdx
   d1ec6:	je     d2d0d <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1e1d>
   d1ecc:	mov    0x8(%r14),%rax
   d1ed0:	movb   $0x3a,(%rax,%rsi,1)
   d1ed4:	inc    %rsi
   d1ed7:	mov    %rsi,0x10(%r14)
   d1edb:	mov    0x130(%rsp),%r14
   d1ee3:	mov    (%rsp),%rax
   d1ee7:	mov    (%rax,%rdx,1),%rax
   d1eeb:	movabs $0x8000000000000000,%rcx
   d1ef5:	xor    %rcx,%rax
   d1ef8:	cmp    $0x4,%rax
   d1efc:	mov    $0x4,%ecx
   d1f01:	cmovae %rcx,%rax
   d1f05:	lea    0x5f9954(%rip),%rcx        # 6cb860 <encoding_rs::data::KSX1001_LOWERCASE+0x1a80>
   d1f0c:	movslq (%rcx,%rax,4),%rax
   d1f10:	add    %rcx,%rax
   d1f13:	jmp    *%rax
   d1f15:	mov    0x10(%r14),%rsi
   d1f19:	cmp    %rsi,(%r14)
   d1f1c:	je     d2f90 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x20a0>
   d1f22:	mov    0x8(%r14),%rax
   d1f26:	movb   $0x22,(%rax,%rsi,1)
   d1f2a:	inc    %rsi
   d1f2d:	mov    %rsi,0x10(%r14)
   d1f31:	mov    $0x3,%r15d
   d1f37:	lea    0x60bb59(%rip),%r13        # 6dda97 <encoding_rs::data::KSX1001_LOWERCASE+0x13cb7>
   d1f3e:	jmp    d2000 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1110>
   d1f43:	mov    (%rsp),%rax
   d1f47:	mov    0x8(%rax,%rdx,1),%r13
   d1f4c:	mov    0x10(%rax,%rdx,1),%r15
   d1f51:	mov    0x10(%r14),%rsi
   d1f55:	cmp    %rsi,(%r14)
   d1f58:	je     d2f2d <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x203d>
   d1f5e:	mov    0x8(%r14),%rax
   d1f62:	movb   $0x22,(%rax,%rsi,1)
   d1f66:	inc    %rsi
   d1f69:	mov    %rsi,0x10(%r14)
   d1f6d:	jmp    d2000 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1110>
   d1f72:	mov    0x10(%r14),%rsi
   d1f76:	cmp    %rsi,(%r14)
   d1f79:	je     d2f4e <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x205e>
   d1f7f:	mov    0x8(%r14),%rax
   d1f83:	movb   $0x22,(%rax,%rsi,1)
   d1f87:	inc    %rsi
   d1f8a:	mov    %rsi,0x10(%r14)
   d1f8e:	mov    $0x3,%r15d
   d1f94:	lea    0x60bb02(%rip),%r13        # 6dda9d <encoding_rs::data::KSX1001_LOWERCASE+0x13cbd>
   d1f9b:	jmp    d2000 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1110>
   d1f9d:	mov    0x10(%r14),%rsi
   d1fa1:	cmp    %rsi,(%r14)
   d1fa4:	je     d2f6f <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x207f>
   d1faa:	mov    0x8(%r14),%rax
   d1fae:	movb   $0x22,(%rax,%rsi,1)
   d1fb2:	inc    %rsi
   d1fb5:	mov    %rsi,0x10(%r14)
   d1fb9:	mov    $0x3,%r15d
   d1fbf:	lea    0x60bada(%rip),%r13        # 6ddaa0 <encoding_rs::data::KSX1001_LOWERCASE+0x13cc0>
   d1fc6:	jmp    d2000 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1110>
   d1fc8:	mov    0x10(%r14),%rsi
   d1fcc:	cmp    %rsi,(%r14)
   d1fcf:	je     d2fb1 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x20c1>
   d1fd5:	mov    0x8(%r14),%rax
   d1fd9:	movb   $0x22,(%rax,%rsi,1)
   d1fdd:	inc    %rsi
   d1fe0:	mov    %rsi,0x10(%r14)
   d1fe4:	mov    $0x3,%r15d
   d1fea:	lea    0x60baa9(%rip),%r13        # 6dda9a <encoding_rs::data::KSX1001_LOWERCASE+0x13cba>
   d1ff1:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   d2000:	mov    %r14,%rdi
   d2003:	mov    %r13,%rsi
   d2006:	mov    %r15,%rdx
   d2009:	call   1b18b0 <serde_json::ser::format_escaped_str_contents>
   d200e:	mov    0x10(%r14),%rsi
   d2012:	cmp    %rsi,(%r14)
   d2015:	je     d2d33 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1e43>
   d201b:	mov    0x8(%r14),%rax
   d201f:	movb   $0x22,(%rax,%rsi,1)
   d2023:	inc    %rsi
   d2026:	mov    %rsi,0x10(%r14)
   d202a:	mov    0x130(%rsp),%r14
   d2032:	mov    0x10(%r14),%rsi
   d2036:	cmp    %rsi,(%r14)
   d2039:	je     d2d54 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1e64>
   d203f:	mov    0x8(%r14),%rax
   d2043:	movb   $0x2c,(%rax,%rsi,1)
   d2047:	inc    %rsi
   d204a:	mov    %rsi,0x10(%r14)
   d204e:	mov    0x130(%rsp),%r14
   d2056:	mov    0x10(%r14),%rsi
   d205a:	cmp    %rsi,(%r14)
   d205d:	je     d2d75 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1e85>
   d2063:	mov    0x8(%r14),%rax
   d2067:	movb   $0x22,(%rax,%rsi,1)
   d206b:	inc    %rsi
   d206e:	mov    %rsi,0x10(%r14)
   d2072:	mov    $0x5,%edx
   d2077:	mov    %r14,%rdi
   d207a:	lea    0x60bd66(%rip),%rsi        # 6ddde7 <encoding_rs::data::KSX1001_LOWERCASE+0x14007>
   d2081:	call   1b18b0 <serde_json::ser::format_escaped_str_contents>
   d2086:	mov    0x10(%r14),%rsi
   d208a:	cmp    %rsi,(%r14)
   d208d:	je     d2d96 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1ea6>
   d2093:	mov    0x8(%r14),%rax
   d2097:	movb   $0x22,(%rax,%rsi,1)
   d209b:	inc    %rsi
   d209e:	mov    %rsi,0x10(%r14)
   d20a2:	mov    0x130(%rsp),%r14
   d20aa:	mov    0x10(%r14),%rsi
   d20ae:	cmp    %rsi,(%r14)
   d20b1:	mov    0x38(%rsp),%rcx
   d20b6:	je     d2db7 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1ec7>
   d20bc:	mov    0x8(%r14),%rax
   d20c0:	movb   $0x3a,(%rax,%rsi,1)
   d20c4:	inc    %rsi
   d20c7:	mov    %rsi,0x10(%r14)
   d20cb:	lea    0xe4(%rsp),%rax
   d20d3:	movb   $0x0,0x8(%rax)
   d20d7:	movq   $0x0,(%rax)
   d20de:	mov    (%rsp),%rbp
   d20e2:	movzbl 0x180(%rbp,%rcx,1),%edx
   d20ea:	mov    %edx,%eax
   d20ec:	shr    $0x4,%eax
   d20ef:	lea    0x5f78ba(%rip),%rsi        # 6c99b0 <_fini+0x28a4>
   d20f6:	movzbl (%rax,%rsi,1),%eax
   d20fa:	mov    %al,0x28(%rsp)
   d20fe:	movzbl 0x181(%rbp,%rcx,1),%eax
   d2106:	mov    %rax,0x58(%rsp)
   d210b:	movzbl 0x182(%rbp,%rcx,1),%r8d
   d2114:	movzbl 0x183(%rbp,%rcx,1),%r9d
   d211d:	movzbl 0x184(%rbp,%rcx,1),%r10d
   d2126:	movzbl 0x185(%rbp,%rcx,1),%r11d
   d212f:	movzbl 0x186(%rbp,%rcx,1),%r14d
   d2138:	movzbl 0x187(%rbp,%rcx,1),%r15d
   d2141:	movzbl 0x188(%rbp,%rcx,1),%r12d
   d214a:	movzbl 0x18e(%rbp,%rcx,1),%eax
   d2152:	mov    %rax,0xa0(%rsp)
   d215a:	movzbl 0x18d(%rbp,%rcx,1),%eax
   d2162:	mov    %rax,0x1b0(%rsp)
   d216a:	movzbl 0x18c(%rbp,%rcx,1),%r13d
   d2173:	movzbl 0x18b(%rbp,%rcx,1),%ebx
   d217b:	movzbl 0x18a(%rbp,%rcx,1),%edi
   d2183:	movzbl 0x189(%rbp,%rcx,1),%eax
   d218b:	movzbl 0x18f(%rbp,%rcx,1),%ebp
   d2193:	movzbl 0x28(%rsp),%ecx
   d2198:	mov    %cl,0xc0(%rsp)
   d219f:	and    $0xf,%edx
   d21a2:	movzbl (%rdx,%rsi,1),%edx
   d21a6:	mov    %dl,0xc1(%rsp)
   d21ad:	mov    0x58(%rsp),%rcx
   d21b2:	mov    %ecx,%edx
   d21b4:	shr    $0x4,%edx
   d21b7:	movzbl (%rdx,%rsi,1),%edx
   d21bb:	mov    %dl,0xc2(%rsp)
   d21c2:	and    $0xf,%ecx
   d21c5:	movzbl (%rcx,%rsi,1),%edx
   d21c9:	mov    %dl,0xc3(%rsp)
   d21d0:	mov    %r8d,%edx
   d21d3:	shr    $0x4,%edx
   d21d6:	movzbl (%rdx,%rsi,1),%edx
   d21da:	mov    %dl,0xc4(%rsp)
   d21e1:	and    $0xf,%r8d
   d21e5:	movzbl (%r8,%rsi,1),%edx
   d21ea:	mov    %dl,0xc5(%rsp)
   d21f1:	mov    %r9d,%edx
   d21f4:	shr    $0x4,%edx
   d21f7:	movzbl (%rdx,%rsi,1),%edx
   d21fb:	mov    %dl,0xc6(%rsp)
   d2202:	and    $0xf,%r9d
   d2206:	movzbl (%r9,%rsi,1),%edx
   d220b:	mov    %dl,0xc7(%rsp)
   d2212:	mov    %r10d,%edx
   d2215:	shr    $0x4,%edx
   d2218:	movzbl (%rdx,%rsi,1),%edx
   d221c:	movb   $0x2d,0xc8(%rsp)
   d2224:	mov    %dl,0xc9(%rsp)
   d222b:	and    $0xf,%r10d
   d222f:	movzbl (%r10,%rsi,1),%edx
   d2234:	mov    %dl,0xca(%rsp)
   d223b:	mov    %r11d,%edx
   d223e:	shr    $0x4,%edx
   d2241:	movzbl (%rdx,%rsi,1),%edx
   d2245:	mov    %dl,0xcb(%rsp)
   d224c:	and    $0xf,%r11d
   d2250:	movzbl (%r11,%rsi,1),%edx
   d2255:	mov    %dl,0xcc(%rsp)
   d225c:	mov    %r14d,%edx
   d225f:	shr    $0x4,%edx
   d2262:	movzbl (%rdx,%rsi,1),%edx
   d2266:	movb   $0x2d,0xcd(%rsp)
   d226e:	mov    %dl,0xce(%rsp)
   d2275:	and    $0xf,%r14d
   d2279:	movzbl (%r14,%rsi,1),%edx
   d227e:	mov    %dl,0xcf(%rsp)
   d2285:	mov    %r15d,%edx
   d2288:	shr    $0x4,%edx
   d228b:	movzbl (%rdx,%rsi,1),%edx
   d228f:	mov    %dl,0xd0(%rsp)
   d2296:	and    $0xf,%r15d
   d229a:	movzbl (%r15,%rsi,1),%edx
   d229f:	mov    %dl,0xd1(%rsp)
   d22a6:	mov    %r12d,%edx
   d22a9:	shr    $0x4,%edx
   d22ac:	movzbl (%rdx,%rsi,1),%edx
   d22b0:	movb   $0x2d,0xd2(%rsp)
   d22b8:	mov    %dl,0xd3(%rsp)
   d22bf:	and    $0xf,%r12d
   d22c3:	movzbl (%r12,%rsi,1),%edx
   d22c8:	mov    %dl,0xd4(%rsp)
   d22cf:	mov    %eax,%edx
   d22d1:	shr    $0x4,%eax
   d22d4:	movzbl (%rax,%rsi,1),%eax
   d22d8:	mov    %al,0xd5(%rsp)
   d22df:	and    $0xf,%edx
   d22e2:	movzbl (%rdx,%rsi,1),%eax
   d22e6:	mov    %al,0xd6(%rsp)
   d22ed:	mov    %edi,%eax
   d22ef:	shr    $0x4,%edi
   d22f2:	movzbl (%rdi,%rsi,1),%ecx
   d22f6:	movb   $0x2d,0xd7(%rsp)
   d22fe:	mov    %cl,0xd8(%rsp)
   d2305:	and    $0xf,%eax
   d2308:	movzbl (%rax,%rsi,1),%eax
   d230c:	mov    %al,0xd9(%rsp)
   d2313:	mov    %ebx,%eax
   d2315:	shr    $0x4,%ebx
   d2318:	movzbl (%rbx,%rsi,1),%ecx
   d231c:	mov    %cl,0xda(%rsp)
   d2323:	and    $0xf,%eax
   d2326:	movzbl (%rax,%rsi,1),%eax
   d232a:	mov    %al,0xdb(%rsp)
   d2331:	mov    %r13d,%eax
   d2334:	shr    $0x4,%r13d
   d2338:	movzbl 0x0(%r13,%rsi,1),%ecx
   d233e:	mov    %cl,0xdc(%rsp)
   d2345:	and    $0xf,%eax
   d2348:	movzbl (%rax,%rsi,1),%eax
   d234c:	mov    %al,0xdd(%rsp)
   d2353:	mov    0x1b0(%rsp),%rcx
   d235b:	mov    %ecx,%eax
   d235d:	shr    $0x4,%ecx
   d2360:	movzbl (%rcx,%rsi,1),%ecx
   d2364:	mov    %cl,0xde(%rsp)
   d236b:	and    $0xf,%eax
   d236e:	movzbl (%rax,%rsi,1),%eax
   d2372:	mov    %al,0xdf(%rsp)
   d2379:	mov    0xa0(%rsp),%rcx
   d2381:	mov    %ecx,%eax
   d2383:	shr    $0x4,%ecx
   d2386:	movzbl (%rcx,%rsi,1),%ecx
   d238a:	mov    %cl,0xe0(%rsp)
   d2391:	and    $0xf,%eax
   d2394:	movzbl (%rax,%rsi,1),%eax
   d2398:	mov    %al,0xe1(%rsp)
   d239f:	mov    %ebp,%eax
   d23a1:	shr    $0x4,%eax
   d23a4:	movzbl (%rax,%rsi,1),%eax
   d23a8:	and    $0xf,%ebp
   d23ab:	mov    %al,0xe2(%rsp)
   d23b2:	movzbl 0x0(%rbp,%rsi,1),%eax
   d23b7:	mov    %al,0xe3(%rsp)
   d23be:	mov    0x130(%rsp),%r14
   d23c6:	mov    0x10(%r14),%rsi
   d23ca:	cmp    %rsi,(%r14)
   d23cd:	je     d2ddd <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1eed>
   d23d3:	mov    0x8(%r14),%rax
   d23d7:	movb   $0x22,(%rax,%rsi,1)
   d23db:	inc    %rsi
   d23de:	mov    %rsi,0x10(%r14)
   d23e2:	mov    $0x24,%edx
   d23e7:	mov    %r14,%rdi
   d23ea:	lea    0xc0(%rsp),%rsi
   d23f2:	call   1b18b0 <serde_json::ser::format_escaped_str_contents>
   d23f7:	mov    0x10(%r14),%rsi
   d23fb:	cmp    %rsi,(%r14)
   d23fe:	je     d2dfe <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1f0e>
   d2404:	lea    0x1(%rsi),%rax
   d2408:	mov    0x8(%r14),%rcx
   d240c:	movb   $0x22,(%rcx,%rsi,1)
   d2410:	mov    %rax,0x10(%r14)
   d2414:	cmpb   $0x2,0x88(%rsp)
   d241c:	mov    0x38(%rsp),%r15
   d2421:	je     d2522 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1632>
   d2427:	mov    0x130(%rsp),%r14
   d242f:	mov    0x10(%r14),%rsi
   d2433:	cmp    %rsi,(%r14)
   d2436:	je     d2e87 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1f97>
   d243c:	mov    0x8(%r14),%rax
   d2440:	movb   $0x2c,(%rax,%rsi,1)
   d2444:	inc    %rsi
   d2447:	mov    %rsi,0x10(%r14)
   d244b:	mov    0x130(%rsp),%r14
   d2453:	mov    0x10(%r14),%rsi
   d2457:	cmp    %rsi,(%r14)
   d245a:	je     d2ea8 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1fb8>
   d2460:	mov    0x8(%r14),%rax
   d2464:	movb   $0x22,(%rax,%rsi,1)
   d2468:	inc    %rsi
   d246b:	mov    %rsi,0x10(%r14)
   d246f:	mov    $0x8,%edx
   d2474:	mov    %r14,%rdi
   d2477:	lea    0x5f898a(%rip),%rsi        # 6cae08 <encoding_rs::data::KSX1001_LOWERCASE+0x1028>
   d247e:	call   1b18b0 <serde_json::ser::format_escaped_str_contents>
   d2483:	mov    0x10(%r14),%rsi
   d2487:	cmp    %rsi,(%r14)
   d248a:	je     d2ec9 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1fd9>
   d2490:	mov    0x8(%r14),%rax
   d2494:	movb   $0x22,(%rax,%rsi,1)
   d2498:	inc    %rsi
   d249b:	mov    %rsi,0x10(%r14)
   d249f:	mov    0x130(%rsp),%r14
   d24a7:	mov    0x10(%r14),%rsi
   d24ab:	cmp    %rsi,(%r14)
   d24ae:	je     d2eea <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1ffa>
   d24b4:	mov    0x8(%r14),%rax
   d24b8:	movb   $0x3a,(%rax,%rsi,1)
   d24bc:	inc    %rsi
   d24bf:	mov    %rsi,0x10(%r14)
   d24c3:	mov    0x130(%rsp),%r14
   d24cb:	movzbl 0x88(%rsp),%ecx
   d24d3:	test   $0x1,%cl
   d24d6:	lea    0x66f251(%rip),%r13        # 74172e <serde_json::ser::ESCAPE+0x15c>
   d24dd:	lea    0x5fae94(%rip),%rax        # 6cd378 <encoding_rs::data::KSX1001_LOWERCASE+0x3598>
   d24e4:	cmovne %rax,%r13
   d24e8:	movzbl %cl,%r15d
   d24ec:	xor    $0x5,%r15
   d24f0:	mov    (%r14),%rax
   d24f3:	mov    0x10(%r14),%r12
   d24f7:	sub    %r12,%rax
   d24fa:	cmp    %rax,%r15
   d24fd:	ja     d2f0b <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x201b>
   d2503:	mov    0x8(%r14),%rdi
   d2507:	add    %r12,%rdi
   d250a:	mov    %r13,%rsi
   d250d:	mov    %r15,%rdx
   d2510:	call   *0x7b73e2(%rip)        # 8898f8 <memcpy@GLIBC_2.14>
   d2516:	add    %r15,%r12
   d2519:	mov    %r12,0x10(%r14)
   d251d:	mov    0x38(%rsp),%r15
   d2522:	mov    0x130(%rsp),%r14
   d252a:	mov    0x10(%r14),%rsi
   d252e:	cmp    %rsi,(%r14)
   d2531:	je     d2e1f <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1f2f>
   d2537:	mov    0x8(%r14),%rax
   d253b:	movb   $0x7d,(%rax,%rsi,1)
   d253f:	inc    %rsi
   d2542:	mov    %rsi,0x10(%r14)
   d2546:	cmpq   $0x0,0x200(%rsp)
   d254f:	je     d10e0 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1f0>
   d2555:	mov    0x208(%rsp),%rdi
   d255d:	call   *0x7b75fd(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d2563:	jmp    d10e0 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1f0>
   d2568:	mov    $0x1,%edx
   d256d:	mov    $0x1,%ecx
   d2572:	mov    $0x1,%r8d
   d2578:	mov    %r14,%rdi
   d257b:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2580:	mov    0x10(%r14),%rsi
   d2584:	jmp    d1145 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x255>
   d2589:	mov    $0x1,%edx
   d258e:	mov    $0x1,%ecx
   d2593:	mov    $0x1,%r8d
   d2599:	mov    %r14,%rdi
   d259c:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d25a1:	lea    0x130(%rsp),%rbx
   d25a9:	mov    0x10(%r14),%rsi
   d25ad:	jmp    d13b5 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4c5>
   d25b2:	mov    $0x1,%edx
   d25b7:	mov    $0x1,%ecx
   d25bc:	mov    $0x1,%r8d
   d25c2:	mov    %r14,%rdi
   d25c5:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d25ca:	mov    0x10(%r14),%rsi
   d25ce:	jmp    d13e5 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4f5>
   d25d3:	mov    $0x1,%edx
   d25d8:	mov    $0x1,%ecx
   d25dd:	mov    $0x1,%r8d
   d25e3:	mov    %r14,%rdi
   d25e6:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d25eb:	mov    0x10(%r14),%rsi
   d25ef:	jmp    d1409 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x519>
   d25f4:	mov    $0x1,%edx
   d25f9:	mov    $0x1,%ecx
   d25fe:	mov    $0x1,%r8d
   d2604:	mov    %r14,%rdi
   d2607:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d260c:	mov    0x10(%r14),%rsi
   d2610:	jmp    d142d <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x53d>
   d2615:	mov    $0x1,%edx
   d261a:	mov    $0x1,%ecx
   d261f:	mov    $0x1,%r8d
   d2625:	mov    %r14,%rdi
   d2628:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d262d:	mov    0x10(%r14),%rsi
   d2631:	jmp    d1455 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x565>
   d2636:	mov    $0x1,%edx
   d263b:	mov    $0x1,%ecx
   d2640:	mov    $0x1,%r8d
   d2646:	mov    %r14,%rdi
   d2649:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d264e:	mov    0x10(%r14),%rsi
   d2652:	jmp    d1485 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x595>
   d2657:	mov    $0x1,%edx
   d265c:	mov    $0x1,%ecx
   d2661:	mov    $0x1,%r8d
   d2667:	mov    %r14,%rdi
   d266a:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d266f:	mov    0x10(%r14),%rsi
   d2673:	jmp    d14a9 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5b9>
   d2678:	mov    $0x1,%ecx
   d267d:	mov    $0x1,%r8d
   d2683:	mov    %r14,%rdi
   d2686:	mov    %r12,%rsi
   d2689:	mov    %r15,%rdx
   d268c:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2691:	mov    0x10(%r14),%r12
   d2695:	jmp    d1509 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x619>
   d269a:	mov    $0x1,%edx
   d269f:	mov    $0x1,%ecx
   d26a4:	mov    $0x1,%r8d
   d26aa:	mov    %r15,%rdi
   d26ad:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d26b2:	mov    0x10(%r15),%rsi
   d26b6:	jmp    d1548 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x658>
   d26bb:	mov    $0x1,%edx
   d26c0:	mov    $0x1,%ecx
   d26c5:	mov    $0x1,%r8d
   d26cb:	mov    %r15,%rdi
   d26ce:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d26d3:	mov    0x10(%r15),%rsi
   d26d7:	jmp    d156c <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x67c>
   d26dc:	mov    $0x1,%edx
   d26e1:	mov    $0x1,%ecx
   d26e6:	mov    $0x1,%r8d
   d26ec:	mov    %r15,%rdi
   d26ef:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d26f4:	mov    0x10(%r15),%rsi
   d26f8:	jmp    d159c <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x6ac>
   d26fd:	mov    $0x1,%edx
   d2702:	mov    $0x1,%ecx
   d2707:	mov    $0x1,%r8d
   d270d:	mov    %r15,%rdi
   d2710:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2715:	mov    0x10(%r15),%rsi
   d2719:	jmp    d15c0 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x6d0>
   d271e:	mov    $0x1,%edx
   d2723:	mov    $0x1,%ecx
   d2728:	mov    $0x1,%r8d
   d272e:	mov    %r15,%rdi
   d2731:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2736:	mov    0x10(%r15),%rsi
   d273a:	jmp    d15f7 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x707>
   d273f:	mov    $0x1,%edx
   d2744:	mov    $0x1,%ecx
   d2749:	mov    $0x1,%r8d
   d274f:	mov    %r15,%rdi
   d2752:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2757:	mov    0x10(%r15),%rsi
   d275b:	jmp    d161b <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x72b>
   d2760:	mov    $0x1,%edx
   d2765:	mov    $0x1,%ecx
   d276a:	mov    $0x1,%r8d
   d2770:	mov    %r15,%rdi
   d2773:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2778:	mov    0x10(%r15),%rsi
   d277c:	jmp    d164b <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x75b>
   d2781:	mov    $0x1,%edx
   d2786:	mov    $0x1,%ecx
   d278b:	mov    $0x1,%r8d
   d2791:	mov    %r15,%rdi
   d2794:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2799:	mov    0x10(%r15),%rsi
   d279d:	jmp    d166f <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x77f>
   d27a2:	mov    $0x1,%edx
   d27a7:	mov    $0x1,%ecx
   d27ac:	mov    $0x1,%r8d
   d27b2:	mov    %r15,%rdi
   d27b5:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d27ba:	mov    0x10(%r15),%rsi
   d27be:	jmp    d16a6 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x7b6>
   d27c3:	mov    $0x1,%edx
   d27c8:	mov    $0x1,%ecx
   d27cd:	mov    $0x1,%r8d
   d27d3:	mov    %r15,%rdi
   d27d6:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d27db:	mov    0x10(%r15),%rsi
   d27df:	jmp    d16ca <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x7da>
   d27e4:	mov    $0x1,%edx
   d27e9:	mov    $0x1,%ecx
   d27ee:	mov    $0x1,%r8d
   d27f4:	mov    %r15,%rdi
   d27f7:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d27fc:	mov    0x10(%r15),%rsi
   d2800:	jmp    d16fa <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x80a>
   d2805:	mov    $0x1,%edx
   d280a:	mov    $0x1,%ecx
   d280f:	mov    $0x1,%r8d
   d2815:	mov    %r15,%rdi
   d2818:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d281d:	mov    0x10(%r15),%rsi
   d2821:	jmp    d171e <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x82e>
   d2826:	mov    $0x1,%edx
   d282b:	mov    $0x1,%ecx
   d2830:	mov    $0x1,%r8d
   d2836:	mov    %r14,%rdi
   d2839:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d283e:	mov    0x10(%r14),%rsi
   d2842:	jmp    d174d <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x85d>
   d2847:	mov    $0x1,%edx
   d284c:	mov    $0x1,%ecx
   d2851:	mov    $0x1,%r8d
   d2857:	mov    %r14,%rdi
   d285a:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d285f:	mov    0x10(%r14),%rsi
   d2863:	jmp    d1771 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x881>
   d2868:	mov    $0x1,%edx
   d286d:	mov    $0x1,%ecx
   d2872:	mov    $0x1,%r8d
   d2878:	mov    %r14,%rdi
   d287b:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2880:	mov    0x10(%r14),%rsi
   d2884:	jmp    d17a1 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x8b1>
   d2889:	mov    $0x1,%edx
   d288e:	mov    $0x1,%ecx
   d2893:	mov    $0x1,%r8d
   d2899:	mov    %r14,%rdi
   d289c:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d28a1:	mov    0x10(%r14),%rsi
   d28a5:	jmp    d17c5 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x8d5>
   d28aa:	mov    $0x1,%edx
   d28af:	mov    $0x1,%ecx
   d28b4:	mov    $0x1,%r8d
   d28ba:	mov    %r14,%rdi
   d28bd:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d28c2:	mov    0x10(%r14),%rsi
   d28c6:	jmp    d1805 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x915>
   d28cb:	mov    $0x1,%edx
   d28d0:	mov    $0x1,%ecx
   d28d5:	mov    $0x1,%r8d
   d28db:	mov    %r14,%rdi
   d28de:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d28e3:	mov    0x10(%r14),%rsi
   d28e7:	jmp    d1829 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x939>
   d28ec:	mov    $0x1,%edx
   d28f1:	mov    $0x1,%ecx
   d28f6:	mov    $0x1,%r8d
   d28fc:	mov    %r14,%rdi
   d28ff:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2904:	mov    0x10(%r14),%rsi
   d2908:	jmp    d1859 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x969>
   d290d:	mov    $0x1,%edx
   d2912:	mov    $0x1,%ecx
   d2917:	mov    $0x1,%r8d
   d291d:	mov    %r14,%rdi
   d2920:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2925:	mov    0x10(%r14),%rsi
   d2929:	jmp    d187d <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x98d>
   d292e:	mov    $0x1,%edx
   d2933:	mov    $0x1,%ecx
   d2938:	mov    $0x1,%r8d
   d293e:	mov    %r14,%rdi
   d2941:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2946:	mov    0x10(%r14),%rsi
   d294a:	jmp    d18bd <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x9cd>
   d294f:	mov    $0x1,%edx
   d2954:	mov    $0x1,%ecx
   d2959:	mov    $0x1,%r8d
   d295f:	mov    %r14,%rdi
   d2962:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2967:	mov    0x10(%r14),%rsi
   d296b:	jmp    d18e9 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x9f9>
   d2970:	mov    $0x1,%edx
   d2975:	mov    $0x1,%ecx
   d297a:	mov    $0x1,%r8d
   d2980:	mov    %r14,%rdi
   d2983:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2988:	mov    0x10(%r14),%rsi
   d298c:	jmp    d1919 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0xa29>
   d2991:	mov    $0x1,%edx
   d2996:	mov    $0x1,%ecx
   d299b:	mov    $0x1,%r8d
   d29a1:	mov    %r14,%rdi
   d29a4:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d29a9:	mov    0x10(%r14),%rsi
   d29ad:	jmp    d193d <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0xa4d>
   d29b2:	mov    $0x1,%edx
   d29b7:	mov    $0x1,%ecx
   d29bc:	mov    $0x1,%r8d
   d29c2:	mov    %r14,%rdi
   d29c5:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d29ca:	mov    0x10(%r14),%rsi
   d29ce:	jmp    d197d <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0xa8d>
   d29d3:	mov    $0x1,%edx
   d29d8:	mov    $0x1,%ecx
   d29dd:	mov    $0x1,%r8d
   d29e3:	mov    %r14,%rdi
   d29e6:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d29eb:	mov    0x10(%r14),%rsi
   d29ef:	jmp    d19a1 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0xab1>
   d29f4:	mov    $0x1,%edx
   d29f9:	mov    $0x1,%ecx
   d29fe:	mov    $0x1,%r8d
   d2a04:	mov    %r14,%rdi
   d2a07:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2a0c:	mov    0x10(%r14),%rsi
   d2a10:	jmp    d19d1 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0xae1>
   d2a15:	mov    $0x1,%edx
   d2a1a:	mov    $0x1,%ecx
   d2a1f:	mov    $0x1,%r8d
   d2a25:	mov    %r14,%rdi
   d2a28:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2a2d:	mov    0x10(%r14),%rsi
   d2a31:	jmp    d19f5 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0xb05>
   d2a36:	mov    $0x1,%edx
   d2a3b:	mov    $0x1,%ecx
   d2a40:	mov    $0x1,%r8d
   d2a46:	mov    %r14,%rdi
   d2a49:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2a4e:	mov    0x10(%r14),%rsi
   d2a52:	jmp    d1a35 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0xb45>
   d2a57:	mov    $0x1,%edx
   d2a5c:	mov    $0x1,%ecx
   d2a61:	mov    $0x1,%r8d
   d2a67:	mov    %r14,%rdi
   d2a6a:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2a6f:	mov    0x10(%r14),%rsi
   d2a73:	jmp    d1a59 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0xb69>
   d2a78:	mov    $0x1,%edx
   d2a7d:	mov    $0x1,%ecx
   d2a82:	mov    $0x1,%r8d
   d2a88:	mov    %r14,%rdi
   d2a8b:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2a90:	mov    0x10(%r14),%rsi
   d2a94:	jmp    d1a89 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0xb99>
   d2a99:	mov    $0x1,%edx
   d2a9e:	mov    $0x1,%ecx
   d2aa3:	mov    $0x1,%r8d
   d2aa9:	mov    %r14,%rdi
   d2aac:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2ab1:	mov    0x10(%r14),%rsi
   d2ab5:	jmp    d1aad <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0xbbd>
   d2aba:	mov    $0x1,%edx
   d2abf:	mov    $0x1,%ecx
   d2ac4:	mov    $0x1,%r8d
   d2aca:	mov    %r14,%rdi
   d2acd:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2ad2:	mov    0x10(%r14),%rsi
   d2ad6:	jmp    d1aed <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0xbfd>
   d2adb:	mov    $0x1,%edx
   d2ae0:	mov    $0x1,%ecx
   d2ae5:	mov    $0x1,%r8d
   d2aeb:	mov    %r14,%rdi
   d2aee:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2af3:	mov    0x10(%r14),%rsi
   d2af7:	jmp    d1b11 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0xc21>
   d2afc:	mov    $0x1,%edx
   d2b01:	mov    $0x1,%ecx
   d2b06:	mov    $0x1,%r8d
   d2b0c:	mov    %r14,%rdi
   d2b0f:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2b14:	mov    0x10(%r14),%rsi
   d2b18:	jmp    d1b41 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0xc51>
   d2b1d:	mov    $0x1,%edx
   d2b22:	mov    $0x1,%ecx
   d2b27:	mov    $0x1,%r8d
   d2b2d:	mov    %r14,%rdi
   d2b30:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2b35:	mov    0x10(%r14),%rsi
   d2b39:	jmp    d1b65 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0xc75>
   d2b3e:	mov    $0x1,%edx
   d2b43:	mov    $0x1,%ecx
   d2b48:	mov    $0x1,%r8d
   d2b4e:	mov    %r14,%rdi
   d2b51:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2b56:	mov    0x10(%r14),%rsi
   d2b5a:	jmp    d1bae <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0xcbe>
   d2b5f:	mov    $0x1,%edx
   d2b64:	mov    $0x1,%ecx
   d2b69:	mov    $0x1,%r8d
   d2b6f:	mov    %r14,%rdi
   d2b72:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2b77:	mov    0x10(%r14),%rsi
   d2b7b:	jmp    d1bd2 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0xce2>
   d2b80:	mov    $0x1,%edx
   d2b85:	mov    $0x1,%ecx
   d2b8a:	mov    $0x1,%r8d
   d2b90:	mov    %r14,%rdi
   d2b93:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2b98:	mov    0x10(%r14),%rsi
   d2b9c:	jmp    d1c02 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0xd12>
   d2ba1:	mov    $0x1,%edx
   d2ba6:	mov    $0x1,%ecx
   d2bab:	mov    $0x1,%r8d
   d2bb1:	mov    %r14,%rdi
   d2bb4:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2bb9:	mov    0x10(%r14),%rsi
   d2bbd:	jmp    d1c26 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0xd36>
   d2bc2:	mov    $0x1,%edx
   d2bc7:	mov    $0x1,%ecx
   d2bcc:	mov    $0x1,%r8d
   d2bd2:	mov    %r14,%rdi
   d2bd5:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2bda:	mov    0x10(%r14),%rsi
   d2bde:	jmp    d1c4a <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0xd5a>
   d2be3:	mov    $0x1,%edx
   d2be8:	mov    $0x1,%ecx
   d2bed:	mov    $0x1,%r8d
   d2bf3:	mov    %r14,%rdi
   d2bf6:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2bfb:	mov    0x10(%r14),%rsi
   d2bff:	jmp    d1c89 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0xd99>
   d2c04:	mov    $0x1,%edx
   d2c09:	mov    $0x1,%ecx
   d2c0e:	mov    $0x1,%r8d
   d2c14:	mov    %r14,%rdi
   d2c17:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2c1c:	mov    0x10(%r14),%rsi
   d2c20:	jmp    d1cb6 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0xdc6>
   d2c25:	mov    $0x1,%edx
   d2c2a:	mov    $0x1,%ecx
   d2c2f:	mov    $0x1,%r8d
   d2c35:	mov    %r14,%rdi
   d2c38:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2c3d:	mov    0x10(%r14),%rsi
   d2c41:	jmp    d1ce2 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0xdf2>
   d2c46:	mov    $0x1,%edx
   d2c4b:	mov    $0x1,%ecx
   d2c50:	mov    $0x1,%r8d
   d2c56:	mov    %r14,%rdi
   d2c59:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2c5e:	mov    0x10(%r14),%rsi
   d2c62:	jmp    d1d12 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0xe22>
   d2c67:	mov    $0x1,%edx
   d2c6c:	mov    $0x1,%ecx
   d2c71:	mov    $0x1,%r8d
   d2c77:	mov    %r14,%rdi
   d2c7a:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2c7f:	mov    0x10(%r14),%rsi
   d2c83:	jmp    d1d36 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0xe46>
   d2c88:	mov    $0x1,%ecx
   d2c8d:	mov    $0x1,%r8d
   d2c93:	mov    %r14,%rdi
   d2c96:	mov    %r12,%rsi
   d2c99:	mov    %r15,%rdx
   d2c9c:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2ca1:	mov    0x10(%r14),%r12
   d2ca5:	jmp    d1db4 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0xec4>
   d2caa:	mov    $0x1,%edx
   d2caf:	mov    $0x1,%ecx
   d2cb4:	mov    $0x1,%r8d
   d2cba:	mov    %r14,%rdi
   d2cbd:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2cc2:	mov    0x10(%r14),%rsi
   d2cc6:	jmp    d1e4f <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0xf5f>
   d2ccb:	mov    $0x1,%edx
   d2cd0:	mov    $0x1,%ecx
   d2cd5:	mov    $0x1,%r8d
   d2cdb:	mov    %r14,%rdi
   d2cde:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2ce3:	mov    0x10(%r14),%rsi
   d2ce7:	jmp    d1e73 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0xf83>
   d2cec:	mov    $0x1,%edx
   d2cf1:	mov    $0x1,%ecx
   d2cf6:	mov    $0x1,%r8d
   d2cfc:	mov    %r14,%rdi
   d2cff:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2d04:	mov    0x10(%r14),%rsi
   d2d08:	jmp    d1ea3 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0xfb3>
   d2d0d:	mov    $0x1,%edx
   d2d12:	mov    $0x1,%ecx
   d2d17:	mov    $0x1,%r8d
   d2d1d:	mov    %r14,%rdi
   d2d20:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2d25:	mov    0x10(%r14),%rsi
   d2d29:	mov    0x38(%rsp),%rdx
   d2d2e:	jmp    d1ecc <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0xfdc>
   d2d33:	mov    $0x1,%edx
   d2d38:	mov    $0x1,%ecx
   d2d3d:	mov    $0x1,%r8d
   d2d43:	mov    %r14,%rdi
   d2d46:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2d4b:	mov    0x10(%r14),%rsi
   d2d4f:	jmp    d201b <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x112b>
   d2d54:	mov    $0x1,%edx
   d2d59:	mov    $0x1,%ecx
   d2d5e:	mov    $0x1,%r8d
   d2d64:	mov    %r14,%rdi
   d2d67:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2d6c:	mov    0x10(%r14),%rsi
   d2d70:	jmp    d203f <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x114f>
   d2d75:	mov    $0x1,%edx
   d2d7a:	mov    $0x1,%ecx
   d2d7f:	mov    $0x1,%r8d
   d2d85:	mov    %r14,%rdi
   d2d88:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2d8d:	mov    0x10(%r14),%rsi
   d2d91:	jmp    d2063 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1173>
   d2d96:	mov    $0x1,%edx
   d2d9b:	mov    $0x1,%ecx
   d2da0:	mov    $0x1,%r8d
   d2da6:	mov    %r14,%rdi
   d2da9:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2dae:	mov    0x10(%r14),%rsi
   d2db2:	jmp    d2093 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x11a3>
   d2db7:	mov    $0x1,%edx
   d2dbc:	mov    $0x1,%ecx
   d2dc1:	mov    $0x1,%r8d
   d2dc7:	mov    %r14,%rdi
   d2dca:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2dcf:	mov    0x10(%r14),%rsi
   d2dd3:	mov    0x38(%rsp),%rcx
   d2dd8:	jmp    d20bc <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x11cc>
   d2ddd:	mov    $0x1,%edx
   d2de2:	mov    $0x1,%ecx
   d2de7:	mov    $0x1,%r8d
   d2ded:	mov    %r14,%rdi
   d2df0:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2df5:	mov    0x10(%r14),%rsi
   d2df9:	jmp    d23d3 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x14e3>
   d2dfe:	mov    $0x1,%edx
   d2e03:	mov    $0x1,%ecx
   d2e08:	mov    $0x1,%r8d
   d2e0e:	mov    %r14,%rdi
   d2e11:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2e16:	mov    0x10(%r14),%rsi
   d2e1a:	jmp    d2404 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1514>
   d2e1f:	mov    $0x1,%edx
   d2e24:	mov    $0x1,%ecx
   d2e29:	mov    $0x1,%r8d
   d2e2f:	mov    %r14,%rdi
   d2e32:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2e37:	mov    0x10(%r14),%rsi
   d2e3b:	mov    0x38(%rsp),%r15
   d2e40:	jmp    d2537 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1647>
   d2e45:	mov    $0x1,%edx
   d2e4a:	mov    $0x1,%ecx
   d2e4f:	mov    $0x1,%r8d
   d2e55:	mov    %r14,%rdi
   d2e58:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2e5d:	mov    0x10(%r14),%rsi
   d2e61:	jmp    d110d <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x21d>
   d2e66:	mov    $0x1,%edx
   d2e6b:	mov    $0x1,%ecx
   d2e70:	mov    $0x1,%r8d
   d2e76:	mov    %r14,%rdi
   d2e79:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2e7e:	mov    0x10(%r14),%rsi
   d2e82:	jmp    d1e2b <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0xf3b>
   d2e87:	mov    $0x1,%edx
   d2e8c:	mov    $0x1,%ecx
   d2e91:	mov    $0x1,%r8d
   d2e97:	mov    %r14,%rdi
   d2e9a:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2e9f:	mov    0x10(%r14),%rsi
   d2ea3:	jmp    d243c <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x154c>
   d2ea8:	mov    $0x1,%edx
   d2ead:	mov    $0x1,%ecx
   d2eb2:	mov    $0x1,%r8d
   d2eb8:	mov    %r14,%rdi
   d2ebb:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2ec0:	mov    0x10(%r14),%rsi
   d2ec4:	jmp    d2460 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1570>
   d2ec9:	mov    $0x1,%edx
   d2ece:	mov    $0x1,%ecx
   d2ed3:	mov    $0x1,%r8d
   d2ed9:	mov    %r14,%rdi
   d2edc:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2ee1:	mov    0x10(%r14),%rsi
   d2ee5:	jmp    d2490 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x15a0>
   d2eea:	mov    $0x1,%edx
   d2eef:	mov    $0x1,%ecx
   d2ef4:	mov    $0x1,%r8d
   d2efa:	mov    %r14,%rdi
   d2efd:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2f02:	mov    0x10(%r14),%rsi
   d2f06:	jmp    d24b4 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x15c4>
   d2f0b:	mov    $0x1,%ecx
   d2f10:	mov    $0x1,%r8d
   d2f16:	mov    %r14,%rdi
   d2f19:	mov    %r12,%rsi
   d2f1c:	mov    %r15,%rdx
   d2f1f:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2f24:	mov    0x10(%r14),%r12
   d2f28:	jmp    d2503 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1613>
   d2f2d:	mov    $0x1,%edx
   d2f32:	mov    $0x1,%ecx
   d2f37:	mov    $0x1,%r8d
   d2f3d:	mov    %r14,%rdi
   d2f40:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2f45:	mov    0x10(%r14),%rsi
   d2f49:	jmp    d1f5e <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x106e>
   d2f4e:	mov    $0x1,%edx
   d2f53:	mov    $0x1,%ecx
   d2f58:	mov    $0x1,%r8d
   d2f5e:	mov    %r14,%rdi
   d2f61:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2f66:	mov    0x10(%r14),%rsi
   d2f6a:	jmp    d1f7f <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x108f>
   d2f6f:	mov    $0x1,%edx
   d2f74:	mov    $0x1,%ecx
   d2f79:	mov    $0x1,%r8d
   d2f7f:	mov    %r14,%rdi
   d2f82:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2f87:	mov    0x10(%r14),%rsi
   d2f8b:	jmp    d1faa <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x10ba>
   d2f90:	mov    $0x1,%edx
   d2f95:	mov    $0x1,%ecx
   d2f9a:	mov    $0x1,%r8d
   d2fa0:	mov    %r14,%rdi
   d2fa3:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2fa8:	mov    0x10(%r14),%rsi
   d2fac:	jmp    d1f22 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x1032>
   d2fb1:	mov    $0x1,%edx
   d2fb6:	mov    $0x1,%ecx
   d2fbb:	mov    $0x1,%r8d
   d2fc1:	mov    %r14,%rdi
   d2fc4:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d2fc9:	mov    0x10(%r14),%rsi
   d2fcd:	jmp    d1fd5 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x10e5>
   d2fd2:	lea    0x4e2(%rsi),%rbx
   d2fd9:	movzbl 0x4e2(%rsi),%eax
   d2fe0:	lea    0x150(%rsi),%rcx
   d2fe7:	mov    %rcx,0x1b0(%rsp)
   d2fef:	lea    0x5f8852(%rip),%rcx        # 6cb848 <encoding_rs::data::KSX1001_LOWERCASE+0x1a68>
   d2ff6:	movslq (%rcx,%rax,4),%rax
   d2ffa:	add    %rcx,%rax
   d2ffd:	jmp    *%rax
   d2fff:	mov    %rbx,(%rsp)
   d3003:	mov    %rbp,0x50(%rsp)
   d3008:	mov    0x8(%rsp),%r12
   d300d:	mov    0x2b8(%r12),%rbp
   d3015:	mov    0x1b0(%rsp),%r13
   d301d:	jmp    d36fd <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x280d>
   d3022:	mov    %rbx,(%rsp)
   d3026:	mov    0x8(%rsp),%r13
   d302b:	jmp    d396c <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2a7c>
   d3030:	movb   $0x5d,0x1(%r14)
   d3035:	mov    $0x2,%r12d
   d303b:	mov    $0x80,%ebx
   d3040:	lea    0x708(%rsp),%rsi
   d3048:	movups 0x5f6c21(%rip),%xmm0        # 6c9c70 <_fini+0x2b64>
   d304f:	movaps %xmm0,0x4b0(%rsp)
   d3057:	movups 0x5f6c02(%rip),%xmm0        # 6c9c60 <_fini+0x2b54>
   d305e:	movaps %xmm0,0x4a0(%rsp)
   d3066:	lea    0x200(%rsp),%rdi
   d306e:	lea    0x4a0(%rsp),%rdx
   d3076:	call   189540 <http::header::map::HeaderMap<T>::try_entry2>
   d307b:	movzbl 0x232(%rsp),%eax
   d3083:	cmp    $0x3,%al
   d3085:	je     d65b7 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x56c7>
   d308b:	mov    0x200(%rsp),%r15
   d3093:	mov    0x210(%rsp),%rdx
   d309b:	movups 0x208(%rsp),%xmm0
   d30a3:	movups 0x218(%rsp),%xmm1
   d30ab:	movaps %xmm1,0xc0(%rsp)
   d30b3:	cmp    $0x2,%al
   d30b5:	jne    d30d0 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x21e0>
   d30b7:	mov    0x28(%r15),%rsi
   d30bb:	cmp    %rsi,%rdx
   d30be:	jb     d3167 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2277>
   d30c4:	lea    0x7aa185(%rip),%rax        # 87d250 <bytes::bytes::PROMOTABLE_ODD_VTABLE+0x8268>
   d30cb:	jmp    d6684 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5794>
   d30d0:	mov    0x228(%rsp),%r8
   d30d8:	movzwl 0x230(%rsp),%ecx
   d30e0:	lea    0x798c21(%rip),%rdx        # 86bd08 <aws_lc_0_37_1_kem_asn1_meth+0x4c08>
   d30e7:	mov    %rdx,0x200(%rsp)
   d30ef:	lea    0x5f63fa(%rip),%rdx        # 6c94f0 <_fini+0x23e4>
   d30f6:	mov    %rdx,0x208(%rsp)
   d30fe:	movq   $0x10,0x210(%rsp)
   d310a:	movq   $0x0,0x218(%rsp)
   d3116:	movb   $0x0,0x220(%rsp)
   d311e:	movaps %xmm0,0x4a0(%rsp)
   d3126:	movaps 0xc0(%rsp),%xmm0
   d312e:	movaps %xmm0,0x4b0(%rsp)
   d3136:	movzbl %al,%r9d
   d313a:	lea    0x4a0(%rsp),%rsi
   d3142:	lea    0x200(%rsp),%rdx
   d314a:	mov    %r15,%rdi
   d314d:	call   1897f0 <http::header::map::HeaderMap<T>::try_insert_phase_two>
   d3152:	test   $0x1,%al
   d3154:	jne    d6671 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5781>
   d315a:	mov    0x28(%r15),%rsi
   d315e:	cmp    %rsi,%rdx
   d3161:	jae    d667d <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x578d>
   d3167:	mov    %rbx,0xc0(%rsp)
   d316f:	mov    %r14,0xc8(%rsp)
   d3177:	mov    %r12,0xd0(%rsp)
   d317f:	lea    0x200(%rsp),%rdi
   d3187:	lea    0xc0(%rsp),%rsi
   d318f:	call   1bb1e0 <<bytes::bytes::Bytes as core::convert::From<alloc::vec::Vec<u8>>>::from>
   d3194:	movups 0x200(%rsp),%xmm0
   d319c:	movups 0x210(%rsp),%xmm1
   d31a4:	movaps %xmm1,0x4b0(%rsp)
   d31ac:	movaps %xmm0,0x4a0(%rsp)
   d31b4:	cmpq   $0x0,0x6e0(%rsp)
   d31bd:	je     d3216 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2326>
   d31bf:	mov    0x6e8(%rsp),%rax
   d31c7:	test   %rax,%rax
   d31ca:	je     d31e9 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x22f9>
   d31cc:	lea    0x700(%rsp),%rdi
   d31d4:	mov    0x6f0(%rsp),%rsi
   d31dc:	mov    0x6f8(%rsp),%rdx
   d31e4:	call   *0x20(%rax)
   d31e7:	jmp    d3216 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2326>
   d31e9:	mov    0x6f0(%rsp),%r14
   d31f1:	mov    0x6f8(%rsp),%rbx
   d31f9:	mov    (%rbx),%rax
   d31fc:	test   %rax,%rax
   d31ff:	je     d3206 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2316>
   d3201:	mov    %r14,%rdi
   d3204:	call   *%rax
   d3206:	cmpq   $0x0,0x8(%rbx)
   d320b:	je     d3216 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2326>
   d320d:	mov    %r14,%rdi
   d3210:	call   *0x7b694a(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d3216:	movq   $0x1,0x6e0(%rsp)
   d3222:	movaps 0x4a0(%rsp),%xmm0
   d322a:	movaps 0x4b0(%rsp),%xmm1
   d3232:	movups %xmm0,0x6e8(%rsp)
   d323a:	movups %xmm1,0x6f8(%rsp)
   d3242:	mov    $0x1,%eax
   d3247:	mov    %rax,0x40(%rsp)
   d324c:	xor    %ebp,%ebp
   d324e:	jmp    d330f <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x241f>
   d3253:	movq   $0x100,0xc0(%rsp)
   d325f:	mov    %rdi,0xc8(%rsp)
   d3267:	movq   $0xffffffffffffffff,0xd0(%rsp)
   d3273:	lea    0xc0(%rsp),%rdi
   d327b:	call   4e3f0 <polymarket_client_sdk::clob::types::ser_salt::{{closure}}>
   d3280:	mov    %rax,%r14
   d3283:	cmpq   $0x0,0x200(%rsp)
   d328c:	je     d329c <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x23ac>
   d328e:	mov    0x208(%rsp),%rdi
   d3296:	call   *0x7b68c4(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d329c:	cmpq   $0x0,0x320(%rsp)
   d32a5:	je     d32b5 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x23c5>
   d32a7:	mov    0x328(%rsp),%rdi
   d32af:	call   *0x7b68ab(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d32b5:	movw   $0x0,0x200(%rsp)
   d32bf:	lea    0x200(%rsp),%rdi
   d32c7:	mov    %r14,%rsi
   d32ca:	call   1b12a0 <reqwest::error::Error::new>
   d32cf:	mov    %rax,%r14
   d32d2:	cmpl   $0x2,0x6e0(%rsp)
   d32da:	jne    d32eb <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x23fb>
   d32dc:	mov    0x6e8(%rsp),%rdi
   d32e4:	call   1456d0 <core::ptr::drop_in_place<reqwest::error::Error>.4971>
   d32e9:	jmp    d32f8 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2408>
   d32eb:	lea    0x6e0(%rsp),%rdi
   d32f3:	call   145e00 <core::ptr::drop_in_place<reqwest::async_impl::request::Request>.4976>
   d32f8:	movq   $0x2,0x6e0(%rsp)
   d3304:	mov    %r14,0x6e8(%rsp)
   d330c:	mov    $0x1,%bpl
   d330f:	mov    0x6e8(%rsp),%r14
   d3317:	lea    0x6f0(%rsp),%rsi
   d331f:	lea    0xb10(%rsp),%rdi
   d3327:	mov    $0xf8,%edx
   d332c:	call   *0x7b65c6(%rip)        # 8898f8 <memcpy@GLIBC_2.14>
   d3332:	mov    0x7e8(%rsp),%rdi
   d333a:	lock decq (%rdi)
   d333e:	jne    d3345 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2455>
   d3340:	call   3b0cb0 <alloc::sync::Arc<T,A>::drop_slow>
   d3345:	test   %bpl,%bpl
   d3348:	je     d3364 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2474>
   d334a:	lea    0x630(%rsp),%rdi
   d3352:	mov    %r14,%rsi
   d3355:	mov    0x8(%rsp),%rbx
   d335a:	call   29d600 <<polymarket_client_sdk::error::Error as core::convert::From<reqwest::error::Error>>::from>
   d335f:	jmp    d353f <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x264f>
   d3364:	lea    0x6e0(%rsp),%r15
   d336c:	lea    0xb10(%rsp),%rsi
   d3374:	mov    0x7b657d(%rip),%rbx        # 8898f8 <memcpy@GLIBC_2.14>
   d337b:	mov    $0xf8,%edx
   d3380:	mov    %r15,%rdi
   d3383:	call   *%rbx
   d3385:	mov    0x8(%rsp),%r13
   d338a:	movb   $0x1,0x149(%r13)
   d3392:	lea    0x40(%r13),%r12
   d3396:	mov    0x40(%rsp),%rax
   d339b:	mov    %rax,0x40(%r13)
   d339f:	mov    %r14,0x48(%r13)
   d33a3:	lea    0x50(%r13),%rdi
   d33a7:	mov    $0xf8,%edx
   d33ac:	mov    %r15,%rsi
   d33af:	call   *%rbx
   d33b1:	mov    0x20(%r13),%rax
   d33b5:	mov    %rax,0x150(%r13)
   d33bc:	mov    %r12,0x158(%r13)
   d33c3:	movb   $0x0,0x170(%r13)
   d33cb:	mov    0x50(%rsp),%rbp
   d33d0:	mov    0x8(%rsp),%rax
   d33d5:	lea    0x150(%rax),%rsi
   d33dc:	lea    0x6e0(%rsp),%rdi
   d33e4:	mov    %rsi,%r13
   d33e7:	mov    %rbp,%rdx
   d33ea:	call   d7130 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}.3909>
   d33ef:	mov    0x6e0(%rsp),%rbx
   d33f7:	cmp    $0x4,%rbx
   d33fb:	jne    d3413 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2523>
   d33fd:	mov    0x3f8(%rsp),%rax
   d3405:	movq   $0x4,(%rax)
   d340c:	mov    $0x3,%al
   d340e:	jmp    d400d <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x311d>
   d3413:	mov    0x728(%rsp),%rax
   d341b:	mov    %rax,0x6c0(%rsp)
   d3423:	movups 0x6e8(%rsp),%xmm0
   d342b:	movups 0x6f8(%rsp),%xmm1
   d3433:	movups 0x708(%rsp),%xmm2
   d343b:	movups 0x718(%rsp),%xmm3
   d3443:	movaps %xmm3,0x6b0(%rsp)
   d344b:	movaps %xmm2,0x6a0(%rsp)
   d3453:	movaps %xmm1,0x690(%rsp)
   d345b:	movaps %xmm0,0x680(%rsp)
   d3463:	movups 0x730(%rsp),%xmm0
   d346b:	movaps %xmm0,0xab0(%rsp)
   d3473:	mov    0x8(%rsp),%rax
   d3478:	movzbl 0x170(%rax),%eax
   d347f:	cmp    $0x4,%eax
   d3482:	je     d34c0 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x25d0>
   d3484:	cmp    $0x3,%eax
   d3487:	jne    d34d1 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x25e1>
   d3489:	mov    0x8(%rsp),%rax
   d348e:	cmpb   $0x3,0x8e8(%rax)
   d3495:	jne    d34d1 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x25e1>
   d3497:	mov    0x8(%rsp),%rax
   d349c:	cmpb   $0x3,0x8e1(%rax)
   d34a3:	jne    d34d1 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x25e1>
   d34a5:	mov    0x8(%rsp),%r14
   d34aa:	lea    0x180(%r14),%rdi
   d34b1:	call   b0e30 <core::ptr::drop_in_place<polymarket_client_sdk::request<polymarket_client_sdk::clob::types::response::FeeRateResponse>::{{closure}}>>
   d34b6:	movb   $0x0,0x8e0(%r14)
   d34be:	jmp    d34d1 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x25e1>
   d34c0:	mov    0x8(%rsp),%rax
   d34c5:	lea    0x178(%rax),%rdi
   d34cc:	call   81aa0 <core::ptr::drop_in_place<polymarket_client_sdk::auth::l2::create_headers<polymarket_client_sdk::auth::Normal>::{{closure}}>>
   d34d1:	cmp    $0x3,%ebx
   d34d4:	jne    d35a6 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x26b6>
   d34da:	mov    0x6c0(%rsp),%rax
   d34e2:	mov    %rax,0x670(%rsp)
   d34ea:	movaps 0x680(%rsp),%xmm0
   d34f2:	movaps 0x690(%rsp),%xmm1
   d34fa:	movaps 0x6a0(%rsp),%xmm2
   d3502:	movaps 0x6b0(%rsp),%xmm3
   d350a:	movaps %xmm3,0x660(%rsp)
   d3512:	movaps %xmm2,0x650(%rsp)
   d351a:	movaps %xmm1,0x640(%rsp)
   d3522:	movaps %xmm0,0x630(%rsp)
   d352a:	mov    0x8(%rsp),%rbx
   d352f:	movb   $0x0,0x14a(%rbx)
   d3536:	lea    0x40(%rbx),%rdi
   d353a:	call   6c260 <core::ptr::drop_in_place<reqwest::async_impl::request::Request>>
   d353f:	movb   $0x0,0x149(%rbx)
   d3546:	mov    0x38(%rbx),%rbx
   d354a:	test   %rbx,%rbx
   d354d:	je     d3fb2 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x30c2>
   d3553:	mov    0x8(%rsp),%rax
   d3558:	mov    0x30(%rax),%r14
   d355c:	movabs $0x8000000000000000,%r15
   d3566:	add    $0x8,%r14
   d356a:	add    $0x4,%r15
   d356e:	mov    0x7b65eb(%rip),%r12        # 889b60 <free@GLIBC_2.2.5>
   d3575:	jmp    d3590 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x26a0>
   d3577:	nopw   0x0(%rax,%rax,1)
   d3580:	add    $0x198,%r14
   d3587:	dec    %rbx
   d358a:	je     d3fb2 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x30c2>
   d3590:	mov    -0x8(%r14),%rax
   d3594:	cmp    %r15,%rax
   d3597:	jl     d3580 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2690>
   d3599:	test   %rax,%rax
   d359c:	je     d3580 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2690>
   d359e:	mov    (%r14),%rdi
   d35a1:	call   *%r12
   d35a4:	jmp    d3580 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2690>
   d35a6:	mov    %rbp,0x50(%rsp)
   d35ab:	movaps 0xab0(%rsp),%xmm0
   d35b3:	movups %xmm0,0x590(%rsp)
   d35bb:	movaps 0x680(%rsp),%xmm0
   d35c3:	movaps 0x690(%rsp),%xmm1
   d35cb:	movaps 0x6a0(%rsp),%xmm2
   d35d3:	movaps 0x6b0(%rsp),%xmm3
   d35db:	movups %xmm0,0x548(%rsp)
   d35e3:	movups %xmm1,0x558(%rsp)
   d35eb:	movups %xmm2,0x568(%rsp)
   d35f3:	movups %xmm3,0x578(%rsp)
   d35fb:	mov    0x6c0(%rsp),%rax
   d3603:	mov    %rax,0x588(%rsp)
   d360b:	mov    0x8(%rsp),%r12
   d3610:	movb   $0x1,0x14a(%r12)
   d3619:	mov    %rbx,0x540(%rsp)
   d3621:	mov    0x20(%r12),%rax
   d3626:	mov    $0x128,%ebp
   d362b:	add    (%rax),%rbp
   d362e:	movb   $0x0,0x149(%r12)
   d3637:	lea    0x40(%r12),%rsi
   d363c:	lea    0x6e0(%rsp),%r14
   d3644:	mov    0x7b62ad(%rip),%rbx        # 8898f8 <memcpy@GLIBC_2.14>
   d364b:	mov    $0x108,%edx
   d3650:	mov    %r14,%rdi
   d3653:	call   *%rbx
   d3655:	movb   $0x0,0x14a(%r12)
   d365e:	movups 0x540(%rsp),%xmm0
   d3666:	movups 0x550(%rsp),%xmm1
   d366e:	movups 0x560(%rsp),%xmm2
   d3676:	movups 0x570(%rsp),%xmm3
   d367e:	movups %xmm0,0x7e8(%rsp)
   d3686:	movups %xmm1,0x7f8(%rsp)
   d368e:	movups %xmm2,0x808(%rsp)
   d3696:	movups %xmm3,0x818(%rsp)
   d369e:	movups 0x580(%rsp),%xmm0
   d36a6:	movups %xmm0,0x828(%rsp)
   d36ae:	movups 0x590(%rsp),%xmm0
   d36b6:	movups %xmm0,0x838(%rsp)
   d36be:	lea    0xb10(%rsp),%r15
   d36c6:	mov    $0x168,%edx
   d36cb:	mov    %r15,%rdi
   d36ce:	mov    %r14,%rsi
   d36d1:	call   *%rbx
   d36d3:	mov    $0x168,%edx
   d36d8:	mov    %r13,%rdi
   d36db:	mov    %r15,%rsi
   d36de:	call   *%rbx
   d36e0:	mov    %rbp,0x2b8(%r12)
   d36e8:	lea    0x4e2(%r12),%rax
   d36f0:	mov    %rax,(%rsp)
   d36f4:	movb   $0x0,0x4e2(%r12)
   d36fd:	movl   $0x10000,0x4e3(%r12)
   d3709:	movb   $0x1,0x4e7(%r12)
   d3712:	lea    0x2c0(%r12),%r14
   d371a:	mov    $0x108,%edx
   d371f:	mov    %r14,%rdi
   d3722:	mov    %r13,0x1b0(%rsp)
   d372a:	mov    %r13,%rsi
   d372d:	call   *0x7b61c5(%rip)        # 8898f8 <memcpy@GLIBC_2.14>
   d3733:	movups 0x258(%r12),%xmm0
   d373c:	movups 0x268(%r12),%xmm1
   d3745:	movups 0x278(%r12),%xmm2
   d374e:	movups 0x288(%r12),%xmm3
   d3757:	movups %xmm0,0x3c8(%r12)
   d3760:	movups %xmm1,0x3d8(%r12)
   d3769:	movups %xmm2,0x3e8(%r12)
   d3772:	movups %xmm3,0x3f8(%r12)
   d377b:	movups 0x298(%r12),%xmm0
   d3784:	movups %xmm0,0x408(%r12)
   d378d:	movups 0x2a8(%r12),%xmm0
   d3796:	movups %xmm0,0x418(%r12)
   d379f:	movzbl 0x3a0(%r12),%r15d
   d37a8:	cmp    $0x9,%r15d
   d37ac:	jae    d3be9 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2cf9>
   d37b2:	mov    0x8(%rsp),%rdi
   d37b7:	mov    %r15b,0x428(%rdi)
   d37be:	mov    0x6e0(%rsp),%ecx
   d37c5:	mov    0x6e3(%rsp),%esi
   d37cc:	mov    %ecx,0x429(%rdi)
   d37d2:	mov    %esi,0x42c(%rdi)
   d37d8:	mov    %rax,0x430(%rdi)
   d37df:	mov    %rdx,0x438(%rdi)
   d37e6:	movb   $0x1,0x4e4(%rdi)
   d37ed:	add    $0x348,%rdi
   d37f4:	call   4b2740 <url::Url::path>
   d37f9:	mov    %rdx,%r15
   d37fc:	test   %rdx,%rdx
   d37ff:	js     d659a <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x56aa>
   d3805:	mov    %rax,%r13
   d3808:	test   %r15,%r15
   d380b:	je     d382e <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x293e>
   d380d:	movzbl 0x7b7474(%rip),%eax        # 88ac88 <__rust_no_alloc_shim_is_unstable>
   d3814:	mov    %r15,%rdi
   d3817:	call   *0x7b63f3(%rip)        # 889c10 <malloc@GLIBC_2.2.5>
   d381d:	test   %rax,%rax
   d3820:	je     d659e <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x56ae>
   d3826:	mov    %rax,%r12
   d3829:	mov    %r15,%rbx
   d382c:	jmp    d3836 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2946>
   d382e:	mov    $0x1,%r12d
   d3834:	xor    %ebx,%ebx
   d3836:	mov    %r12,%rdi
   d3839:	mov    %r13,%rsi
   d383c:	mov    %r15,%rdx
   d383f:	call   *0x7b60b3(%rip)        # 8898f8 <memcpy@GLIBC_2.14>
   d3845:	mov    0x8(%rsp),%r13
   d384a:	mov    %rbx,0x440(%r13)
   d3851:	mov    %r12,0x448(%r13)
   d3858:	mov    %r15,0x450(%r13)
   d385f:	movb   $0x1,0x4e3(%r13)
   d3867:	cmpl   $0x3,0x3c8(%r13)
   d386f:	je     d392c <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2a3c>
   d3875:	lea    0x3c8(%r13),%rax
   d387c:	movb   $0x0,0x4e5(%r13)
   d3884:	movups 0x50(%rax),%xmm0
   d3888:	movaps %xmm0,0x730(%rsp)
   d3890:	movups 0x40(%rax),%xmm0
   d3894:	movaps %xmm0,0x720(%rsp)
   d389c:	movups (%rax),%xmm0
   d389f:	movups 0x10(%rax),%xmm1
   d38a3:	movups 0x20(%rax),%xmm2
   d38a7:	movups 0x30(%rax),%xmm3
   d38ab:	movaps %xmm3,0x710(%rsp)
   d38b3:	movaps %xmm2,0x700(%rsp)
   d38bb:	movaps %xmm1,0x6f0(%rsp)
   d38c3:	movaps %xmm0,0x6e0(%rsp)
   d38cb:	lea    0x2e8(%r13),%r15
   d38d2:	mov    %r15,%rdi
   d38d5:	call   6bbe0 <core::ptr::drop_in_place<http::header::map::HeaderMap>>
   d38da:	movaps 0x730(%rsp),%xmm0
   d38e2:	movups %xmm0,0x50(%r15)
   d38e7:	movaps 0x720(%rsp),%xmm0
   d38ef:	movups %xmm0,0x40(%r15)
   d38f4:	movaps 0x6e0(%rsp),%xmm0
   d38fc:	movaps 0x6f0(%rsp),%xmm1
   d3904:	movaps 0x700(%rsp),%xmm2
   d390c:	movaps 0x710(%rsp),%xmm3
   d3914:	movups %xmm3,0x30(%r15)
   d3919:	movups %xmm2,0x20(%r15)
   d391e:	movups %xmm1,0x10(%r15)
   d3923:	movups %xmm0,(%r15)
   d3927:	mov    0x8(%rsp),%r13
   d392c:	movb   $0x0,0x4e7(%r13)
   d3934:	lea    0x6e0(%rsp),%r15
   d393c:	mov    $0x108,%edx
   d3941:	mov    %r15,%rdi
   d3944:	mov    %r14,%rsi
   d3947:	call   *0x7b5fab(%rip)        # 8898f8 <memcpy@GLIBC_2.14>
   d394d:	mov    0x0(%rbp),%rdi
   d3951:	mov    %r15,%rsi
   d3954:	call   34ff10 <reqwest::async_impl::client::Client::execute_request>
   d3959:	mov    %rax,0x4e8(%r13)
   d3960:	mov    %rdx,0x4f0(%r13)
   d3967:	mov    0x50(%rsp),%rbp
   d396c:	lea    0x4e8(%r13),%r14
   d3973:	lea    0x6e0(%rsp),%rdi
   d397b:	mov    %r14,%rsi
   d397e:	mov    %rbp,%rdx
   d3981:	call   354380 <<reqwest::async_impl::client::Pending as core::future::future::Future>::poll>
   d3986:	mov    0x6e0(%rsp),%r12
   d398e:	cmp    $0x4,%r12
   d3992:	jne    d39a1 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2ab1>
   d3994:	mov    $0x3,%al
   d3996:	mov    (%rsp),%rcx
   d399a:	mov    %al,(%rcx)
   d399c:	jmp    d3edc <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2fec>
   d39a1:	mov    0x6e8(%rsp),%r15
   d39a9:	movups 0x6f0(%rsp),%xmm0
   d39b1:	movaps %xmm0,0x4a0(%rsp)
   d39b9:	movups 0x700(%rsp),%xmm0
   d39c1:	movaps %xmm0,0x4b0(%rsp)
   d39c9:	movups 0x710(%rsp),%xmm0
   d39d1:	movaps %xmm0,0x4c0(%rsp)
   d39d9:	movups 0x720(%rsp),%xmm0
   d39e1:	movaps %xmm0,0x4d0(%rsp)
   d39e9:	movups 0x730(%rsp),%xmm0
   d39f1:	movaps %xmm0,0x4e0(%rsp)
   d39f9:	movups 0x740(%rsp),%xmm0
   d3a01:	movaps %xmm0,0x4f0(%rsp)
   d3a09:	movups 0x750(%rsp),%xmm0
   d3a11:	movaps %xmm0,0x500(%rsp)
   d3a19:	mov    0x760(%rsp),%rax
   d3a21:	mov    %rax,0x510(%rsp)
   d3a29:	mov    0x8(%rsp),%rax
   d3a2e:	mov    0x4e8(%rax),%rdi
   d3a35:	mov    0x4f0(%rax),%rsi
   d3a3c:	call   b1070 <core::ptr::drop_in_place<reqwest::async_impl::client::Pending>.3797>
   d3a41:	cmp    $0x3,%r12d
   d3a45:	jne    d3a5c <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2b6c>
   d3a47:	lea    0x320(%rsp),%rdi
   d3a4f:	mov    %r15,%rsi
   d3a52:	call   29d600 <<polymarket_client_sdk::error::Error as core::convert::From<reqwest::error::Error>>::from>
   d3a57:	jmp    d3df3 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2f03>
   d3a5c:	mov    0x8(%rsp),%r13
   d3a61:	movb   $0x1,0x4e6(%r13)
   d3a69:	lea    0x458(%r13),%rsi
   d3a70:	mov    %r12,0x458(%r13)
   d3a77:	mov    %r15,0x460(%r13)
   d3a7e:	movaps 0x4a0(%rsp),%xmm0
   d3a86:	movaps 0x4b0(%rsp),%xmm1
   d3a8e:	movaps 0x4c0(%rsp),%xmm2
   d3a96:	movaps 0x4d0(%rsp),%xmm3
   d3a9e:	movups %xmm0,0x468(%r13)
   d3aa6:	movups %xmm1,0x478(%r13)
   d3aae:	movups %xmm2,0x488(%r13)
   d3ab6:	movups %xmm3,0x498(%r13)
   d3abe:	movaps 0x4e0(%rsp),%xmm0
   d3ac6:	movups %xmm0,0x4a8(%r13)
   d3ace:	movaps 0x4f0(%rsp),%xmm0
   d3ad6:	movups %xmm0,0x4b8(%r13)
   d3ade:	movaps 0x500(%rsp),%xmm0
   d3ae6:	movups %xmm0,0x4c8(%r13)
   d3aee:	mov    0x510(%rsp),%rax
   d3af6:	mov    %rax,0x4d8(%r13)
   d3afd:	mov    0x4c0(%r13),%eax
   d3b04:	mov    %ax,0x4e0(%r13)
   d3b0c:	add    $0xffffff38,%eax
   d3b11:	cmp    $0x64,%ax
   d3b15:	jae    d3c10 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2d20>
   d3b1b:	movb   $0x0,0x4e6(%r13)
   d3b23:	lea    0x6e0(%rsp),%r15
   d3b2b:	mov    0x7b5dc6(%rip),%rbx        # 8898f8 <memcpy@GLIBC_2.14>
   d3b32:	mov    $0x88,%edx
   d3b37:	mov    %r15,%rdi
   d3b3a:	call   *%rbx
   d3b3c:	mov    $0x230,%edx
   d3b41:	mov    %r14,%rdi
   d3b44:	mov    %r15,%rsi
   d3b47:	call   *%rbx
   d3b49:	movb   $0x0,0x718(%r13)
   d3b51:	mov    (%rsp),%rbx
   d3b55:	mov    0x8(%rsp),%rax
   d3b5a:	lea    0x4e8(%rax),%r15
   d3b61:	lea    0x200(%rsp),%rdi
   d3b69:	mov    %r15,%rsi
   d3b6c:	mov    %rbp,%rdx
   d3b6f:	call   82580 <reqwest::async_impl::response::Response::json::{{closure}}>
   d3b74:	movzbl 0x200(%rsp),%ebp
   d3b7c:	cmp    $0x7,%bpl
   d3b80:	jne    d3b8b <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2c9b>
   d3b82:	mov    $0x5,%al
   d3b84:	mov    %al,(%rbx)
   d3b86:	jmp    d3edc <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2fec>
   d3b8b:	mov    0x201(%rsp),%eax
   d3b92:	mov    0x204(%rsp),%ecx
   d3b99:	mov    %ecx,0x313(%rsp)
   d3ba0:	mov    %eax,0x310(%rsp)
   d3ba7:	mov    0x208(%rsp),%r14
   d3baf:	movups 0x210(%rsp),%xmm0
   d3bb7:	movaps %xmm0,0xac0(%rsp)
   d3bbf:	mov    0x8(%rsp),%rax
   d3bc4:	movzbl 0x718(%rax),%eax
   d3bcb:	cmp    $0x3,%eax
   d3bce:	je     d3dc8 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2ed8>
   d3bd4:	test   %eax,%eax
   d3bd6:	jne    d3dd9 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2ee9>
   d3bdc:	mov    %r15,%rdi
   d3bdf:	call   827f0 <core::ptr::drop_in_place<reqwest::async_impl::response::Response>>
   d3be4:	jmp    d3dd9 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2ee9>
   d3be9:	cmp    $0xa,%r15d
   d3bed:	jne    d418b <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x329b>
   d3bf3:	mov    0x8(%rsp),%rax
   d3bf8:	mov    0x3a8(%rax),%rdi
   d3bff:	mov    0x3b0(%rax),%rsi
   d3c06:	call   196790 <<alloc::boxed::Box<[T],A> as core::clone::Clone>::clone>
   d3c0b:	jmp    d37b2 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x28c2>
   d3c10:	movb   $0x0,0x4e6(%r13)
   d3c18:	lea    0x6e0(%rsp),%r15
   d3c20:	mov    0x7b5cd1(%rip),%rbx        # 8898f8 <memcpy@GLIBC_2.14>
   d3c27:	mov    $0x88,%edx
   d3c2c:	mov    %r15,%rdi
   d3c2f:	call   *%rbx
   d3c31:	mov    $0x3b8,%edx
   d3c36:	mov    %r14,%rdi
   d3c39:	mov    %r15,%rsi
   d3c3c:	call   *%rbx
   d3c3e:	movb   $0x0,0x8a0(%r13)
   d3c46:	mov    (%rsp),%rbx
   d3c4a:	mov    0x8(%rsp),%rax
   d3c4f:	lea    0x4e8(%rax),%r15
   d3c56:	lea    0x200(%rsp),%rdi
   d3c5e:	mov    %r15,%rsi
   d3c61:	mov    %rbp,%rdx
   d3c64:	call   81e00 <reqwest::async_impl::response::Response::text::{{closure}}>
   d3c69:	movabs $0x8000000000000000,%r13
   d3c73:	mov    0x200(%rsp),%r12
   d3c7b:	lea    0x1(%r13),%rax
   d3c7f:	cmp    %rax,%r12
   d3c82:	jne    d3c8d <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2d9d>
   d3c84:	mov    $0x4,%al
   d3c86:	mov    %al,(%rbx)
   d3c88:	jmp    d3edc <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2fec>
   d3c8d:	mov    0x208(%rsp),%r14
   d3c95:	mov    0x210(%rsp),%rbx
   d3c9d:	mov    %r15,%rdi
   d3ca0:	call   81cc0 <core::ptr::drop_in_place<reqwest::async_impl::response::Response::text::{{closure}}>.3727>
   d3ca5:	cmp    %r13,%r12
   d3ca8:	jne    d3cbd <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2dcd>
   d3caa:	mov    %r14,%rdi
   d3cad:	call   1456d0 <core::ptr::drop_in_place<reqwest::error::Error>.4971>
   d3cb2:	mov    $0x1,%r14d
   d3cb8:	xor    %ebx,%ebx
   d3cba:	xor    %r12d,%r12d
   d3cbd:	mov    0x8(%rsp),%rdi
   d3cc2:	movzwl 0x4e0(%rdi),%eax
   d3cc9:	movb   $0x0,0x4e4(%rdi)
   d3cd0:	movzbl 0x428(%rdi),%ecx
   d3cd7:	mov    0x429(%rdi),%edx
   d3cdd:	mov    0x42c(%rdi),%esi
   d3ce3:	mov    %esi,0x714(%rsp)
   d3cea:	mov    %edx,0x711(%rsp)
   d3cf1:	movb   $0x0,0x4e3(%rdi)
   d3cf8:	movups 0x430(%rdi),%xmm0
   d3cff:	movups 0x440(%rdi),%xmm1
   d3d06:	mov    0x450(%rdi),%rdx
   d3d0d:	mov    %rdx,0x6f0(%rsp)
   d3d15:	movaps %xmm1,0x6e0(%rsp)
   d3d1d:	mov    %ax,0x728(%rsp)
   d3d25:	mov    %cl,0x710(%rsp)
   d3d2c:	movups %xmm0,0x718(%rsp)
   d3d34:	mov    %r12,0x6f8(%rsp)
   d3d3c:	mov    %r14,0x700(%rsp)
   d3d44:	mov    %rbx,0x708(%rsp)
   d3d4c:	lea    0x200(%rsp),%rdi
   d3d54:	lea    0x6e0(%rsp),%rsi
   d3d5c:	call   29ea20 <<polymarket_client_sdk::error::Error as core::convert::From<polymarket_client_sdk::error::Status>>::from>
   d3d61:	movups 0x200(%rsp),%xmm0
   d3d69:	movups 0x210(%rsp),%xmm1
   d3d71:	movups 0x220(%rsp),%xmm2
   d3d79:	movups 0x230(%rsp),%xmm3
   d3d81:	movaps %xmm0,0x320(%rsp)
   d3d89:	movaps %xmm1,0x330(%rsp)
   d3d91:	movaps %xmm2,0x340(%rsp)
   d3d99:	movaps %xmm3,0x350(%rsp)
   d3da1:	mov    0x240(%rsp),%rax
   d3da9:	mov    %rax,0x360(%rsp)
   d3db1:	mov    0x8(%rsp),%rbx
   d3db6:	movb   $0x0,0x4e6(%rbx)
   d3dbd:	cmpb   $0x0,0x4e3(%rbx)
   d3dc4:	jne    d3e08 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2f18>
   d3dc6:	jmp    d3e1f <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2f2f>
   d3dc8:	mov    0x8(%rsp),%rax
   d3dcd:	lea    0x570(%rax),%rdi
   d3dd4:	call   828e0 <core::ptr::drop_in_place<reqwest::async_impl::response::Response::bytes::{{closure}}>.3728>
   d3dd9:	cmp    $0x6,%bpl
   d3ddd:	jne    d402a <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x313a>
   d3de3:	lea    0x320(%rsp),%rdi
   d3deb:	mov    %r14,%rsi
   d3dee:	call   29d600 <<polymarket_client_sdk::error::Error as core::convert::From<reqwest::error::Error>>::from>
   d3df3:	mov    0x8(%rsp),%rbx
   d3df8:	movb   $0x0,0x4e6(%rbx)
   d3dff:	cmpb   $0x0,0x4e3(%rbx)
   d3e06:	je     d3e1f <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2f2f>
   d3e08:	cmpq   $0x0,0x440(%rbx)
   d3e10:	je     d3e1f <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2f2f>
   d3e12:	mov    0x448(%rbx),%rdi
   d3e19:	call   *0x7b5d41(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d3e1f:	movb   $0x0,0x4e3(%rbx)
   d3e26:	cmpb   $0x0,0x4e4(%rbx)
   d3e2d:	je     d3e4f <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2f5f>
   d3e2f:	cmpb   $0xa,0x428(%rbx)
   d3e36:	jb     d3e4f <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2f5f>
   d3e38:	cmpq   $0x0,0x438(%rbx)
   d3e40:	je     d3e4f <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2f5f>
   d3e42:	mov    0x430(%rbx),%rdi
   d3e49:	call   *0x7b5d11(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d3e4f:	movb   $0x0,0x4e4(%rbx)
   d3e56:	cmpl   $0x3,0x3c8(%rbx)
   d3e5d:	je     d3e74 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2f84>
   d3e5f:	cmpb   $0x1,0x4e5(%rbx)
   d3e66:	jne    d3e74 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2f84>
   d3e68:	lea    0x3c8(%rbx),%rdi
   d3e6f:	call   6bbe0 <core::ptr::drop_in_place<http::header::map::HeaderMap>>
   d3e74:	mov    0x8(%rsp),%rcx
   d3e79:	movb   $0x0,0x4e5(%rcx)
   d3e80:	movb   $0x0,0x4e7(%rcx)
   d3e87:	mov    0x320(%rsp),%rax
   d3e8f:	movups 0x328(%rsp),%xmm0
   d3e97:	movaps %xmm0,0x130(%rsp)
   d3e9f:	movups 0x338(%rsp),%xmm0
   d3ea7:	movaps %xmm0,0x140(%rsp)
   d3eaf:	movups 0x348(%rsp),%xmm0
   d3eb7:	movaps %xmm0,0x150(%rsp)
   d3ebf:	movups 0x358(%rsp),%xmm0
   d3ec7:	movaps %xmm0,0x160(%rsp)
   d3ecf:	movb   $0x1,0x4e2(%rcx)
   d3ed6:	cmp    $0x4,%rax
   d3eda:	jne    d3ef2 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3002>
   d3edc:	mov    0x3f8(%rsp),%rax
   d3ee4:	movq   $0x4,(%rax)
   d3eeb:	mov    $0x4,%al
   d3eed:	jmp    d400d <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x311d>
   d3ef2:	movaps 0x130(%rsp),%xmm0
   d3efa:	movaps 0x140(%rsp),%xmm1
   d3f02:	movaps 0x150(%rsp),%xmm2
   d3f0a:	movaps 0x160(%rsp),%xmm3
   d3f12:	movups %xmm3,0x668(%rsp)
   d3f1a:	movups %xmm2,0x658(%rsp)
   d3f22:	movups %xmm1,0x648(%rsp)
   d3f2a:	movups %xmm0,0x638(%rsp)
   d3f32:	mov    %rax,0x630(%rsp)
   d3f3a:	mov    0x1b0(%rsp),%rdi
   d3f42:	call   b0e30 <core::ptr::drop_in_place<polymarket_client_sdk::request<polymarket_client_sdk::clob::types::response::FeeRateResponse>::{{closure}}>>
   d3f47:	mov    0x8(%rsp),%rax
   d3f4c:	movb   $0x0,0x14a(%rax)
   d3f53:	movb   $0x0,0x149(%rax)
   d3f5a:	mov    0x38(%rax),%rbx
   d3f5e:	test   %rbx,%rbx
   d3f61:	je     d3fb2 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x30c2>
   d3f63:	mov    0x8(%rsp),%rax
   d3f68:	mov    0x30(%rax),%r14
   d3f6c:	movabs $0x8000000000000000,%r15
   d3f76:	add    $0x8,%r14
   d3f7a:	add    $0x4,%r15
   d3f7e:	mov    0x7b5bdb(%rip),%r12        # 889b60 <free@GLIBC_2.2.5>
   d3f85:	jmp    d3f9c <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x30ac>
   d3f87:	nopw   0x0(%rax,%rax,1)
   d3f90:	add    $0x198,%r14
   d3f97:	dec    %rbx
   d3f9a:	je     d3fb2 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x30c2>
   d3f9c:	mov    -0x8(%r14),%rax
   d3fa0:	cmp    %r15,%rax
   d3fa3:	jl     d3f90 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x30a0>
   d3fa5:	test   %rax,%rax
   d3fa8:	je     d3f90 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x30a0>
   d3faa:	mov    (%r14),%rdi
   d3fad:	call   *%r12
   d3fb0:	jmp    d3f90 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x30a0>
   d3fb2:	mov    0x8(%rsp),%rax
   d3fb7:	cmpq   $0x0,0x28(%rax)
   d3fbc:	je     d3fc8 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x30d8>
   d3fbe:	mov    0x30(%rax),%rdi
   d3fc2:	call   *0x7b5b98(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d3fc8:	mov    0x670(%rsp),%rax
   d3fd0:	mov    0x3f8(%rsp),%rcx
   d3fd8:	mov    %rax,0x40(%rcx)
   d3fdc:	movaps 0x630(%rsp),%xmm0
   d3fe4:	movaps 0x640(%rsp),%xmm1
   d3fec:	movaps 0x650(%rsp),%xmm2
   d3ff4:	movaps 0x660(%rsp),%xmm3
   d3ffc:	movups %xmm3,0x30(%rcx)
   d4000:	movups %xmm2,0x20(%rcx)
   d4004:	movups %xmm1,0x10(%rcx)
   d4008:	movups %xmm0,(%rcx)
   d400b:	mov    $0x1,%al
   d400d:	mov    0x8(%rsp),%rcx
   d4012:	mov    %al,0x148(%rcx)
   d4018:	add    $0xc78,%rsp
   d401f:	pop    %rbx
   d4020:	pop    %r12
   d4022:	pop    %r13
   d4024:	pop    %r14
   d4026:	pop    %r15
   d4028:	pop    %rbp
   d4029:	ret
   d402a:	movabs $0x8000000000000000,%r13
   d4034:	mov    0x310(%rsp),%eax
   d403b:	mov    0x313(%rsp),%ecx
   d4042:	mov    %ecx,0x444(%rsp)
   d4049:	mov    %eax,0x441(%rsp)
   d4050:	movaps 0xac0(%rsp),%xmm0
   d4058:	movups %xmm0,0x450(%rsp)
   d4060:	mov    %bpl,0x440(%rsp)
   d4068:	mov    %r14,0x448(%rsp)
   d4070:	test   %bpl,%bpl
   d4073:	je     d41bd <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x32cd>
   d4079:	movzbl 0x440(%rsp),%eax
   d4081:	mov    0x441(%rsp),%ecx
   d4088:	movzwl 0x445(%rsp),%edx
   d4090:	movzbl 0x447(%rsp),%esi
   d4098:	mov    0x448(%rsp),%rdi
   d40a0:	movups 0x450(%rsp),%xmm0
   d40a8:	movaps %xmm0,0x410(%rsp)
   d40b0:	mov    %al,0x400(%rsp)
   d40b7:	mov    %ecx,0x401(%rsp)
   d40be:	mov    %dx,0x405(%rsp)
   d40c6:	mov    %sil,0x407(%rsp)
   d40ce:	mov    %rdi,0x408(%rsp)
   d40d6:	movzbl 0x400(%rsp),%eax
   d40de:	mov    %al,0x96(%rsp)
   d40e5:	cmp    $0x4,%al
   d40e7:	jne    d65e0 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x56f0>
   d40ed:	mov    0x408(%rsp),%rax
   d40f5:	mov    0x410(%rsp),%rcx
   d40fd:	mov    0x418(%rsp),%rsi
   d4105:	mov    %rsi,%rdx
   d4108:	shl    $0x5,%rdx
   d410c:	add    %rcx,%rdx
   d410f:	mov    %rcx,0x480(%rsp)
   d4117:	mov    %rcx,0x488(%rsp)
   d411f:	mov    %rax,0x490(%rsp)
   d4127:	mov    %rdx,0x498(%rsp)
   d412f:	cmp    $0x1999,%rsi
   d4136:	mov    $0x1999,%ebx
   d413b:	cmovb  %rsi,%rbx
   d413f:	mov    %rsi,0x5b8(%rsp)
   d4147:	test   %rsi,%rsi
   d414a:	je     d4226 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3336>
   d4150:	mov    %ebx,%eax
   d4152:	shl    $0x5,%eax
   d4155:	lea    (%rax,%rax,4),%r14
   d4159:	movzbl 0x7b6b28(%rip),%eax        # 88ac88 <__rust_no_alloc_shim_is_unstable>
   d4160:	mov    %r14,%rdi
   d4163:	call   *0x7b5aa7(%rip)        # 889c10 <malloc@GLIBC_2.2.5>
   d4169:	test   %rax,%rax
   d416c:	jne    d422d <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x333d>
   d4172:	lea    0x797197(%rip),%rdx        # 86b310 <aws_lc_0_37_1_kem_asn1_meth+0x4210>
   d4179:	mov    $0x8,%edi
   d417e:	mov    %r14,%rsi
   d4181:	call   4a4d6 <alloc::raw_vec::handle_error>
   d4186:	jmp    d668f <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x579f>
   d418b:	mov    0x8(%rsp),%rdx
   d4190:	mov    0x231(%rdx),%eax
   d4196:	mov    0x234(%rdx),%ecx
   d419c:	mov    %ecx,0x6e3(%rsp)
   d41a3:	mov    %eax,0x6e0(%rsp)
   d41aa:	mov    0x3a8(%rdx),%rax
   d41b1:	mov    0x3b0(%rdx),%rdx
   d41b8:	jmp    d37b2 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x28c2>
   d41bd:	lea    0x440(%rsp),%rdi
   d41c5:	call   6b6c0 <core::ptr::drop_in_place<serde_json::value::Value>>
   d41ca:	mov    %r13,%r14
   d41cd:	jmp    d62da <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x53ea>
   d41d2:	mov    0x130(%rsp),%r14
   d41da:	mov    0x10(%r14),%rsi
   d41de:	cmp    %rsi,(%r14)
   d41e1:	je     d6604 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5714>
   d41e7:	mov    0x8(%r14),%rax
   d41eb:	movb   $0x5d,(%rax,%rsi,1)
   d41ef:	inc    %rsi
   d41f2:	mov    %rsi,0x10(%r14)
   d41f6:	mov    0x320(%rsp),%rbx
   d41fe:	mov    0x328(%rsp),%r14
   d4206:	movabs $0x8000000000000000,%rax
   d4210:	cmp    %rax,%rbx
   d4213:	je     d32b5 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x23c5>
   d4219:	mov    0x330(%rsp),%r12
   d4221:	jmp    d3040 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2150>
   d4226:	xor    %ebx,%ebx
   d4228:	mov    $0x8,%eax
   d422d:	mov    %rbx,0x2f8(%rsp)
   d4235:	mov    %rax,0x300(%rsp)
   d423d:	movq   $0x0,0x308(%rsp)
   d4249:	jmp    d427d <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x338d>
   d424b:	lea    (%r14,%r14,4),%rdi
   d424f:	shl    $0x5,%rdi
   d4253:	add    0x300(%rsp),%rdi
   d425b:	mov    $0xa0,%edx
   d4260:	lea    0x200(%rsp),%rsi
   d4268:	call   *0x7b568a(%rip)        # 8898f8 <memcpy@GLIBC_2.14>
   d426e:	inc    %r14
   d4271:	mov    %r14,0x308(%rsp)
   d4279:	mov    (%rsp),%r8
   d427d:	mov    0x488(%rsp),%rax
   d4285:	cmp    0x498(%rsp),%rax
   d428d:	je     d6121 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5231>
   d4293:	lea    0x20(%rax),%rcx
   d4297:	mov    %rcx,0x488(%rsp)
   d429f:	movzbl (%rax),%ecx
   d42a2:	cmp    $0x6,%ecx
   d42a5:	je     d6121 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5231>
   d42ab:	mov    %cl,0x2a0(%rsp)
   d42b2:	movups 0x1(%rax),%xmm0
   d42b6:	movups 0x10(%rax),%xmm1
   d42ba:	lea    0x2a1(%rsp),%rax
   d42c2:	movups %xmm1,0xf(%rax)
   d42c6:	movups %xmm0,(%rax)
   d42c9:	cmp    $0x4,%ecx
   d42cc:	je     d43b6 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x34c6>
   d42d2:	cmp    $0x5,%ecx
   d42d5:	mov    0x38(%rsp),%rdi
   d42da:	jne    d5a3d <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4b4d>
   d42e0:	mov    0x2a8(%rsp),%rax
   d42e8:	mov    0x2b0(%rsp),%rcx
   d42f0:	mov    0x2b8(%rsp),%rbx
   d42f8:	xor    %edx,%edx
   d42fa:	test   %rax,%rax
   d42fd:	mov    %rbx,%rsi
   d4300:	cmove  %rax,%rsi
   d4304:	setne  %dl
   d4307:	mov    %rdx,0xc0(%rsp)
   d430f:	movq   $0x0,0xc8(%rsp)
   d431b:	mov    %rax,0xd0(%rsp)
   d4323:	mov    %rcx,0xd8(%rsp)
   d432b:	mov    %rdx,0xe0(%rsp)
   d4333:	movq   $0x0,0xe8(%rsp)
   d433f:	mov    %rax,0xf0(%rsp)
   d4347:	mov    %rcx,0xf8(%rsp)
   d434f:	mov    %rsi,0x100(%rsp)
   d4357:	movb   $0x6,0x108(%rsp)
   d435f:	mov    %r13,0x370(%rsp)
   d4367:	lea    0x1(%r13),%r12
   d436b:	lea    0x5(%r13),%rax
   d436f:	mov    %rax,0x40(%rsp)
   d4374:	movl   $0x0,0x48(%rsp)
   d437c:	movb   $0x2,0x10(%rsp)
   d4381:	mov    0x88(%rsp),%r15
   d4389:	mov    %r13,0x28(%rsp)
   d438e:	mov    %rdi,%rax
   d4391:	mov    %r8,%rcx
   d4394:	mov    0x50(%rsp),%rdx
   d4399:	mov    0xa0(%rsp),%rsi
   d43a1:	mov    %r13,0x58(%rsp)
   d43a6:	movl   $0x0,0x98(%rsp)
   d43b1:	jmp    d4589 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3699>
   d43b6:	mov    %r8,(%rsp)
   d43ba:	mov    0x2a8(%rsp),%rax
   d43c2:	mov    0x2b0(%rsp),%r12
   d43ca:	mov    0x2b8(%rsp),%r14
   d43d2:	mov    %r14,%rcx
   d43d5:	shl    $0x5,%rcx
   d43d9:	add    %r12,%rcx
   d43dc:	mov    %r12,0xc0(%rsp)
   d43e4:	mov    %r12,0xc8(%rsp)
   d43ec:	mov    %rax,0xd0(%rsp)
   d43f4:	mov    %rcx,0xd8(%rsp)
   d43fc:	test   %r14,%r14
   d43ff:	je     d441b <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x352b>
   d4401:	lea    0x20(%r12),%rax
   d4406:	mov    %rax,0xc8(%rsp)
   d440e:	movzbl (%r12),%eax
   d4413:	cmp    $0x6,%al
   d4415:	jne    d4cb5 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3dc5>
   d441b:	xor    %edi,%edi
   d441d:	lea    0x796b84(%rip),%rsi        # 86afa8 <aws_lc_0_37_1_kem_asn1_meth+0x3ea8>
   d4424:	lea    0x799575(%rip),%rdx        # 86d9a0 <aws_lc_0_37_1_kem_asn1_meth+0x68a0>
   d442b:	call   4e160 <serde_core::de::Error::invalid_length>
   d4430:	mov    %rax,%r15
   d4433:	mov    0x190(%rsp),%r12
   d443b:	mov    0x1c8(%rsp),%rax
   d4443:	mov    %rax,0x20(%rsp)
   d4448:	mov    0x1d0(%rsp),%rax
   d4450:	mov    %rax,0x30(%rsp)
   d4455:	mov    0x1e8(%rsp),%rax
   d445d:	mov    %rax,0x1a8(%rsp)
   d4465:	mov    0x1e0(%rsp),%rax
   d446d:	mov    %rax,0x1a0(%rsp)
   d4475:	mov    0x1d8(%rsp),%rax
   d447d:	mov    %rax,0x198(%rsp)
   d4485:	mov    %r13,0x28(%rsp)
   d448a:	mov    $0x1,%r14b
   d448d:	xor    %ebx,%ebx
   d448f:	lea    0xc0(%rsp),%rdi
   d4497:	call   153080 <<alloc::vec::into_iter::IntoIter<T,A> as core::ops::drop::Drop>::drop>
   d449c:	mov    $0x1,%dl
   d449e:	xor    %eax,%eax
   d44a0:	mov    0x190(%rsp),%rcx
   d44a8:	mov    %rcx,0x2f0(%rsp)
   d44b0:	mov    %r12,0x190(%rsp)
   d44b8:	movzbl 0x2a0(%rsp),%ecx
   d44c0:	cmp    $0x4,%ecx
   d44c3:	je     d5633 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4743>
   d44c9:	cmp    $0x5,%ecx
   d44cc:	jne    d4539 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3649>
   d44ce:	test   %dl,%dl
   d44d0:	je     d567b <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x478b>
   d44d6:	mov    0x2a8(%rsp),%rcx
   d44de:	test   %rcx,%rcx
   d44e1:	je     d4d98 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3ea8>
   d44e7:	mov    0x2b0(%rsp),%rdx
   d44ef:	mov    0x2b8(%rsp),%rax
   d44f7:	movq   $0x0,0x6e8(%rsp)
   d4503:	mov    %rcx,0x6f0(%rsp)
   d450b:	mov    %rdx,0x6f8(%rsp)
   d4513:	movq   $0x0,0x708(%rsp)
   d451f:	mov    %rcx,0x710(%rsp)
   d4527:	mov    %rdx,0x718(%rsp)
   d452f:	mov    $0x1,%ecx
   d4534:	jmp    d4d9c <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3eac>
   d4539:	lea    0x2a0(%rsp),%rdi
   d4541:	call   6b6c0 <core::ptr::drop_in_place<serde_json::value::Value>>
   d4546:	jmp    d567b <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x478b>
   d454b:	mov    0x6d8(%rsp),%rax
   d4553:	mov    %rax,0x380(%rsp)
   d455b:	movups 0x6c8(%rsp),%xmm0
   d4563:	movaps %xmm0,0x370(%rsp)
   d456b:	mov    0x88(%rsp),%r15
   d4573:	mov    0x38(%rsp),%rax
   d4578:	mov    (%rsp),%rcx
   d457c:	mov    0x50(%rsp),%rdx
   d4581:	mov    0xa0(%rsp),%rsi
   d4589:	mov    %rsi,0xa0(%rsp)
   d4591:	mov    %rdx,0x50(%rsp)
   d4596:	mov    %rcx,(%rsp)
   d459a:	mov    %rax,0x38(%rsp)
   d459f:	mov    %r15,0x88(%rsp)
   d45a7:	mov    %r12,%r14
   d45aa:	lea    0x178(%rsp),%rdi
   d45b2:	lea    0xc0(%rsp),%rsi
   d45ba:	call   136990 <alloc::collections::btree::map::IntoIter<K,V,A>::dying_next>
   d45bf:	mov    0x178(%rsp),%rax
   d45c7:	test   %rax,%rax
   d45ca:	je     d4c19 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3d29>
   d45d0:	mov    0x188(%rsp),%rcx
   d45d8:	lea    (%rcx,%rcx,2),%rdx
   d45dc:	mov    0x168(%rax,%rdx,8),%rbp
   d45e4:	mov    0x170(%rax,%rdx,8),%r14
   d45ec:	mov    0x178(%rax,%rdx,8),%r15
   d45f4:	shl    $0x5,%rcx
   d45f8:	movups (%rax,%rcx,1),%xmm0
   d45fc:	movups 0x10(%rax,%rcx,1),%xmm1
   d4601:	movaps %xmm0,0x60(%rsp)
   d4606:	movaps %xmm1,0x70(%rsp)
   d460b:	cmp    %r13,%rbp
   d460e:	je     d4c19 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3d29>
   d4614:	cmpb   $0x6,0x108(%rsp)
   d461c:	je     d462b <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x373b>
   d461e:	lea    0x108(%rsp),%rdi
   d4626:	call   136cd0 <core::ptr::drop_in_place<serde_json::value::Value>.4830>
   d462b:	movaps 0x60(%rsp),%xmm0
   d4630:	movaps 0x70(%rsp),%xmm1
   d4635:	lea    0x108(%rsp),%rax
   d463d:	movups %xmm1,0x10(%rax)
   d4641:	movups %xmm0,(%rax)
   d4644:	lea    0x178(%rsp),%rdi
   d464c:	mov    %r14,%rsi
   d464f:	mov    %r15,%rdx
   d4652:	call   15ac00 <<polymarket_client_sdk::clob::types::response::_::<impl serde_core::de::Deserialize for polymarket_client_sdk::clob::types::response::PostOrderResponse>::deserialize::__FieldVisitor as serde_core::de::Visitor>::visit_str>
   d4657:	test   %rbp,%rbp
   d465a:	je     d4665 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3775>
   d465c:	mov    %r14,%rdi
   d465f:	call   *0x7b54fb(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d4665:	cmpb   $0x0,0x178(%rsp)
   d466d:	jne    d4d2a <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3e3a>
   d4673:	movzbl 0x179(%rsp),%eax
   d467b:	lea    0x5f71f2(%rip),%rcx        # 6cb874 <encoding_rs::data::KSX1001_LOWERCASE+0x1a94>
   d4682:	movslq (%rcx,%rax,4),%rax
   d4686:	add    %rcx,%rax
   d4689:	jmp    *%rax
   d468b:	lea    0x1(%r13),%r14
   d468f:	cmp    %r14,%r12
   d4692:	jne    d5a95 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4ba5>
   d4698:	movzbl 0x108(%rsp),%eax
   d46a0:	movb   $0x6,0x108(%rsp)
   d46a8:	cmp    $0x6,%al
   d46aa:	je     d533c <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x444c>
   d46b0:	mov    %al,0xaf0(%rsp)
   d46b7:	lea    0x108(%rsp),%rcx
   d46bf:	movups 0x1(%rcx),%xmm0
   d46c3:	movups 0x10(%rcx),%xmm1
   d46c7:	lea    0xaf1(%rsp),%rcx
   d46cf:	movups %xmm1,0xf(%rcx)
   d46d3:	movups %xmm0,(%rcx)
   d46d6:	test   %al,%al
   d46d8:	je     d4baf <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3cbf>
   d46de:	lea    0x60(%rsp),%rdi
   d46e3:	lea    0xaf0(%rsp),%rsi
   d46eb:	call   65550 <serde_json::value::de::<impl serde_core::de::Deserializer for serde_json::value::Value>::deserialize_string>
   d46f0:	mov    0x60(%rsp),%r12
   d46f5:	mov    0x68(%rsp),%r15
   d46fa:	cmp    %r13,%r12
   d46fd:	je     d58cf <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x49df>
   d4703:	mov    0x70(%rsp),%rax
   d4708:	mov    %rax,0x5c0(%rsp)
   d4710:	mov    0x38(%rsp),%rax
   d4715:	mov    (%rsp),%rcx
   d4719:	mov    0x50(%rsp),%rdx
   d471e:	mov    0xa0(%rsp),%rsi
   d4726:	mov    %r15,0x460(%rsp)
   d472e:	jmp    d4589 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3699>
   d4733:	lea    0x5(%r13),%rax
   d4737:	cmp    %rax,0x40(%rsp)
   d473c:	jne    d5ab1 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4bc1>
   d4742:	movzbl 0x108(%rsp),%ecx
   d474a:	movb   $0x6,0x108(%rsp)
   d4752:	cmp    $0x6,%cl
   d4755:	je     d524a <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x435a>
   d475b:	mov    %cl,0x60(%rsp)
   d475f:	lea    0x108(%rsp),%rcx
   d4767:	movups 0x1(%rcx),%xmm0
   d476b:	movups 0x10(%rcx),%xmm1
   d476f:	lea    0x61(%rsp),%rcx
   d4774:	movups %xmm1,0xf(%rcx)
   d4778:	movups %xmm0,(%rcx)
   d477b:	mov    %r12,%r14
   d477e:	mov    %rax,0x40(%rsp)
   d4783:	lea    0x178(%rsp),%rdi
   d478b:	lea    0x60(%rsp),%rsi
   d4790:	call   1b50b0 <polymarket_client_sdk::clob::types::_::<impl serde_core::de::Deserialize for polymarket_client_sdk::clob::types::OrderStatusType>::deserialize>
   d4795:	mov    0x178(%rsp),%r8
   d479d:	mov    0x180(%rsp),%rdx
   d47a5:	lea    0x5(%r13),%rdi
   d47a9:	mov    0x188(%rsp),%rsi
   d47b1:	mov    0x88(%rsp),%r15
   d47b9:	mov    0x38(%rsp),%rax
   d47be:	mov    (%rsp),%rcx
   d47c2:	mov    %r8,0x40(%rsp)
   d47c7:	cmp    %rdi,%r8
   d47ca:	jne    d4589 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3699>
   d47d0:	jmp    d588f <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x499f>
   d47d5:	cmpl   $0x0,0x48(%rsp)
   d47da:	jne    d5adb <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4beb>
   d47e0:	movzbl 0x108(%rsp),%eax
   d47e8:	movb   $0x6,0x108(%rsp)
   d47f0:	cmp    $0x6,%al
   d47f2:	je     d52ee <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x43fe>
   d47f8:	mov    %al,0x60(%rsp)
   d47fc:	lea    0x108(%rsp),%rax
   d4804:	movups 0x1(%rax),%xmm0
   d4808:	movups 0x10(%rax),%xmm1
   d480c:	lea    0x61(%rsp),%rax
   d4811:	movups %xmm1,0xf(%rax)
   d4815:	movups %xmm0,(%rax)
   d4818:	mov    %r12,%r14
   d481b:	lea    0x178(%rsp),%rdi
   d4823:	lea    0x60(%rsp),%rsi
   d4828:	call   15b830 <<<polymarket_client_sdk::clob::types::response::_::<impl serde_core::de::Deserialize for polymarket_client_sdk::clob::types::response::PostOrderResponse>::deserialize::__Visitor as serde_core::de::Visitor>::visit_map::__DeserializeWith as serde_core::de::Deserialize>::deserialize>
   d482d:	testb  $0x1,0x178(%rsp)
   d4835:	jne    d4d2a <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3e3a>
   d483b:	mov    0x17c(%rsp),%rax
   d4843:	mov    %rax,0x470(%rsp)
   d484b:	mov    0x184(%rsp),%rax
   d4853:	mov    %rax,0x468(%rsp)
   d485b:	movl   $0x1,0x48(%rsp)
   d4863:	jmp    d456b <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x367b>
   d4868:	cmp    %r13,0x28(%rsp)
   d486d:	jne    d5aa3 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4bb3>
   d4873:	movzbl 0x108(%rsp),%eax
   d487b:	movb   $0x6,0x108(%rsp)
   d4883:	cmp    $0x6,%al
   d4885:	je     d52bb <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x43cb>
   d488b:	mov    %al,0x60(%rsp)
   d488f:	lea    0x108(%rsp),%rax
   d4897:	movups 0x1(%rax),%xmm0
   d489b:	movups 0x10(%rax),%xmm1
   d489f:	lea    0x61(%rsp),%rax
   d48a4:	movups %xmm1,0xf(%rax)
   d48a8:	movups %xmm0,(%rax)
   d48ab:	mov    %r12,%r14
   d48ae:	mov    %r13,0x28(%rsp)
   d48b3:	lea    0x178(%rsp),%rdi
   d48bb:	lea    0x60(%rsp),%rsi
   d48c0:	call   65550 <serde_json::value::de::<impl serde_core::de::Deserializer for serde_json::value::Value>::deserialize_string>
   d48c5:	mov    0x178(%rsp),%r8
   d48cd:	mov    0x180(%rsp),%rax
   d48d5:	mov    0x188(%rsp),%rcx
   d48dd:	mov    0x88(%rsp),%r15
   d48e5:	mov    0x50(%rsp),%rdx
   d48ea:	mov    0xa0(%rsp),%rsi
   d48f2:	mov    %r8,0x28(%rsp)
   d48f7:	cmp    %r13,%r8
   d48fa:	jne    d4589 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3699>
   d4900:	jmp    d5837 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4947>
   d4905:	cmp    %r13,0x370(%rsp)
   d490d:	jne    d5acd <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4bdd>
   d4913:	movzbl 0x108(%rsp),%eax
   d491b:	movb   $0x6,0x108(%rsp)
   d4923:	cmp    $0x6,%al
   d4925:	je     d52a0 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x43b0>
   d492b:	mov    %al,0x60(%rsp)
   d492f:	lea    0x108(%rsp),%rax
   d4937:	movups 0x1(%rax),%xmm0
   d493b:	movups 0x10(%rax),%xmm1
   d493f:	lea    0x61(%rsp),%rax
   d4944:	movups %xmm1,0xf(%rax)
   d4948:	movups %xmm0,(%rax)
   d494b:	mov    %r12,%r14
   d494e:	lea    0x6c8(%rsp),%rdi
   d4956:	lea    0x60(%rsp),%rsi
   d495b:	call   15b2a0 <<<polymarket_client_sdk::clob::types::response::_::<impl serde_core::de::Deserialize for polymarket_client_sdk::clob::types::response::OpenOrderResponse>::deserialize::__Visitor as serde_core::de::Visitor>::visit_map::__DeserializeWith as serde_core::de::Deserialize>::deserialize>
   d4960:	cmp    %r13,0x6c8(%rsp)
   d4968:	jne    d454b <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x365b>
   d496e:	jmp    d5857 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4967>
   d4973:	cmpl   $0x0,0x98(%rsp)
   d497b:	jne    d5abf <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4bcf>
   d4981:	movzbl 0x108(%rsp),%eax
   d4989:	movb   $0x6,0x108(%rsp)
   d4991:	cmp    $0x6,%al
   d4993:	je     d527a <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x438a>
   d4999:	mov    %al,0x60(%rsp)
   d499d:	lea    0x108(%rsp),%rax
   d49a5:	movups 0x1(%rax),%xmm0
   d49a9:	movups 0x10(%rax),%xmm1
   d49ad:	lea    0x61(%rsp),%rax
   d49b2:	movups %xmm1,0xf(%rax)
   d49b6:	movups %xmm0,(%rax)
   d49b9:	mov    %r12,%r14
   d49bc:	lea    0x178(%rsp),%rdi
   d49c4:	lea    0x60(%rsp),%rsi
   d49c9:	call   15b830 <<<polymarket_client_sdk::clob::types::response::_::<impl serde_core::de::Deserialize for polymarket_client_sdk::clob::types::response::PostOrderResponse>::deserialize::__Visitor as serde_core::de::Visitor>::visit_map::__DeserializeWith as serde_core::de::Deserialize>::deserialize>
   d49ce:	testb  $0x1,0x178(%rsp)
   d49d6:	jne    d4d2a <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3e3a>
   d49dc:	mov    0x17c(%rsp),%rax
   d49e4:	mov    %rax,0x398(%rsp)
   d49ec:	mov    0x184(%rsp),%rax
   d49f4:	mov    %rax,0x390(%rsp)
   d49fc:	movl   $0x1,0x98(%rsp)
   d4a07:	jmp    d456b <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x367b>
   d4a0c:	cmpb   $0x2,0x10(%rsp)
   d4a11:	jne    d5ae9 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4bf9>
   d4a17:	movzbl 0x108(%rsp),%ebp
   d4a1f:	movb   $0x6,0x108(%rsp)
   d4a27:	cmp    $0x6,%bpl
   d4a2b:	je     d528d <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x439d>
   d4a31:	mov    %bpl,0x60(%rsp)
   d4a36:	lea    0x108(%rsp),%rax
   d4a3e:	movups 0x1(%rax),%xmm0
   d4a42:	movups 0x10(%rax),%xmm1
   d4a46:	lea    0x61(%rsp),%rax
   d4a4b:	movups %xmm1,0xf(%rax)
   d4a4f:	movups %xmm0,(%rax)
   d4a52:	cmp    $0x1,%bpl
   d4a56:	jne    d4be2 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3cf2>
   d4a5c:	movzbl 0x61(%rsp),%eax
   d4a61:	mov    %al,0x97(%rsp)
   d4a68:	mov    %r12,%r14
   d4a6b:	lea    0x60(%rsp),%rdi
   d4a70:	call   6b6c0 <core::ptr::drop_in_place<serde_json::value::Value>>
   d4a75:	mov    0x88(%rsp),%r15
   d4a7d:	mov    0x38(%rsp),%rax
   d4a82:	mov    (%rsp),%rcx
   d4a86:	mov    0x50(%rsp),%rdx
   d4a8b:	mov    0xa0(%rsp),%rsi
   d4a93:	movzbl 0x97(%rsp),%edi
   d4a9b:	mov    %dil,0x10(%rsp)
   d4aa0:	cmp    $0x1,%bpl
   d4aa4:	je     d4589 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3699>
   d4aaa:	jmp    d586f <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x497f>
   d4aaf:	cmp    %r13,0x58(%rsp)
   d4ab4:	jne    d5af7 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4c07>
   d4aba:	movzbl 0x108(%rsp),%eax
   d4ac2:	movb   $0x6,0x108(%rsp)
   d4aca:	cmp    $0x6,%al
   d4acc:	je     d5309 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4419>
   d4ad2:	mov    %al,0x60(%rsp)
   d4ad6:	lea    0x108(%rsp),%rax
   d4ade:	movups 0x1(%rax),%xmm0
   d4ae2:	movups 0x10(%rax),%xmm1
   d4ae6:	lea    0x61(%rsp),%rax
   d4aeb:	movups %xmm1,0xf(%rax)
   d4aef:	movups %xmm0,(%rax)
   d4af2:	mov    %r12,%r14
   d4af5:	mov    %r13,0x58(%rsp)
   d4afa:	lea    0xa98(%rsp),%rdi
   d4b02:	lea    0x60(%rsp),%rsi
   d4b07:	call   15bbb0 <<<polymarket_client_sdk::clob::types::response::_::<impl serde_core::de::Deserialize for polymarket_client_sdk::clob::types::response::PostOrderResponse>::deserialize::__Visitor as serde_core::de::Visitor>::visit_map::__DeserializeWith as serde_core::de::Deserialize>::deserialize>
   d4b0c:	mov    0xa98(%rsp),%rax
   d4b14:	mov    0xaa0(%rsp),%rdi
   d4b1c:	mov    %rax,0x58(%rsp)
   d4b21:	cmp    %r13,%rax
   d4b24:	je     d58af <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x49bf>
   d4b2a:	mov    0xaa8(%rsp),%rax
   d4b32:	mov    %rax,0xb0(%rsp)
   d4b3a:	mov    0x88(%rsp),%r15
   d4b42:	mov    0x38(%rsp),%rax
   d4b47:	mov    (%rsp),%rcx
   d4b4b:	mov    0x50(%rsp),%rdx
   d4b50:	mov    0xa0(%rsp),%rsi
   d4b58:	mov    %rdi,0xb8(%rsp)
   d4b60:	jmp    d4589 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3699>
   d4b65:	movzbl 0x108(%rsp),%eax
   d4b6d:	movb   $0x6,0x108(%rsp)
   d4b75:	cmp    $0x6,%al
   d4b77:	je     d522f <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x433f>
   d4b7d:	lea    0x108(%rsp),%rcx
   d4b85:	movups 0x1(%rcx),%xmm0
   d4b89:	movups 0x10(%rcx),%xmm1
   d4b8d:	lea    0x61(%rsp),%rcx
   d4b92:	movups %xmm1,0xf(%rcx)
   d4b96:	movups %xmm0,(%rcx)
   d4b99:	mov    %al,0x60(%rsp)
   d4b9d:	mov    %r12,%r14
   d4ba0:	lea    0x60(%rsp),%rdi
   d4ba5:	call   6b6c0 <core::ptr::drop_in_place<serde_json::value::Value>>
   d4baa:	jmp    d456b <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x367b>
   d4baf:	lea    0xaf0(%rsp),%rdi
   d4bb7:	call   6b6c0 <core::ptr::drop_in_place<serde_json::value::Value>>
   d4bbc:	mov    %r13,%r12
   d4bbf:	mov    0x460(%rsp),%r15
   d4bc7:	mov    0x38(%rsp),%rax
   d4bcc:	mov    (%rsp),%rcx
   d4bd0:	mov    0x50(%rsp),%rdx
   d4bd5:	mov    0xa0(%rsp),%rsi
   d4bdd:	jmp    d4589 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3699>
   d4be2:	mov    %r12,0x10(%rsp)
   d4be7:	lea    0x60(%rsp),%rdi
   d4bec:	lea    0x1e(%rsp),%rsi
   d4bf1:	lea    0x7967c0(%rip),%rdx        # 86b3b8 <aws_lc_0_37_1_kem_asn1_meth+0x42b8>
   d4bf8:	call   4a2c0 <serde_json::value::de::<impl serde_json::value::Value>::invalid_type>
   d4bfd:	mov    %rax,0x5a8(%rsp)
   d4c05:	movabs $0x8000000000000000,%r13
   d4c0f:	mov    0x10(%rsp),%r12
   d4c14:	jmp    d4a68 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3b78>
   d4c19:	lea    0x1(%r13),%rax
   d4c1d:	cmp    %rax,%r12
   d4c20:	sete   %r14b
   d4c24:	mov    %r12,%rbp
   d4c27:	cmove  %r13,%rbp
   d4c2b:	mov    0x1f8(%rsp),%rax
   d4c33:	cmovne 0x88(%rsp),%rax
   d4c3c:	mov    %rax,0x1f8(%rsp)
   d4c44:	mov    0x3a0(%rsp),%rax
   d4c4c:	cmovne 0x5c0(%rsp),%rax
   d4c55:	mov    %rax,0x3a0(%rsp)
   d4c5d:	lea    0x607724(%rip),%rdi        # 6dc388 <encoding_rs::data::KSX1001_LOWERCASE+0x125a8>
   d4c64:	testb  $0x1,0x98(%rsp)
   d4c6c:	je     d5a81 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4b91>
   d4c72:	lea    0x60771b(%rip),%rdi        # 6dc394 <encoding_rs::data::KSX1001_LOWERCASE+0x125b4>
   d4c79:	testb  $0x1,0x48(%rsp)
   d4c7e:	je     d5a81 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4b91>
   d4c84:	cmp    %r13,0x28(%rsp)
   d4c89:	jne    d4d3c <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3e4c>
   d4c8f:	mov    $0x7,%esi
   d4c94:	mov    %r13,%rbx
   d4c97:	lea    0x607702(%rip),%rdi        # 6dc3a0 <encoding_rs::data::KSX1001_LOWERCASE+0x125c0>
   d4c9e:	call   4e010 <serde_core::de::Error::missing_field>
   d4ca3:	mov    %rax,%r15
   d4ca6:	mov    $0x1,%bl
   d4ca8:	movl   $0x0,0x30(%rsp)
   d4cb0:	jmp    d4eb2 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3fc2>
   d4cb5:	mov    %al,0xad0(%rsp)
   d4cbc:	movups 0x1(%r12),%xmm0
   d4cc2:	movups 0x10(%r12),%xmm1
   d4cc8:	lea    0xad1(%rsp),%rcx
   d4cd0:	movups %xmm1,0xf(%rcx)
   d4cd4:	movups %xmm0,(%rcx)
   d4cd7:	test   %al,%al
   d4cd9:	je     d4dc6 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3ed6>
   d4cdf:	lea    0x6e0(%rsp),%rdi
   d4ce7:	lea    0xad0(%rsp),%rsi
   d4cef:	call   65550 <serde_json::value::de::<impl serde_core::de::Deserializer for serde_json::value::Value>::deserialize_string>
   d4cf4:	mov    0x6e0(%rsp),%rcx
   d4cfc:	mov    0x6e8(%rsp),%r15
   d4d04:	cmp    %r13,%rcx
   d4d07:	mov    %r15,0x1c0(%rsp)
   d4d0f:	je     d4433 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3543>
   d4d15:	mov    0x6f0(%rsp),%rax
   d4d1d:	mov    %rax,0x388(%rsp)
   d4d25:	jmp    d4dd6 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3ee6>
   d4d2a:	mov    %r12,0x10(%rsp)
   d4d2f:	mov    0x180(%rsp),%r15
   d4d37:	jmp    d5359 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4469>
   d4d3c:	mov    %rbx,0x5b0(%rsp)
   d4d44:	lea    0x5(%r13),%rbx
   d4d48:	mov    0x40(%rsp),%rax
   d4d4d:	cmp    %rbx,%rax
   d4d50:	jne    d4e34 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3f44>
   d4d56:	lea    0x60(%rsp),%rdi
   d4d5b:	call   4e660 <polymarket_client_sdk::clob::types::_::<impl serde_core::de::Deserialize for polymarket_client_sdk::clob::types::OrderStatusType>::deserialize>
   d4d60:	mov    0x60(%rsp),%rcx
   d4d65:	mov    0x68(%rsp),%r15
   d4d6a:	lea    0x5(%r13),%rax
   d4d6e:	mov    $0x1,%bl
   d4d70:	mov    %rcx,0x98(%rsp)
   d4d78:	cmp    %rax,%rcx
   d4d7b:	je     d4e99 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3fa9>
   d4d81:	mov    %r15,0x48(%rsp)
   d4d86:	mov    %rbp,0xa8(%rsp)
   d4d8e:	mov    0x70(%rsp),%rax
   d4d93:	jmp    d4e58 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3f68>
   d4d98:	xor    %ecx,%ecx
   d4d9a:	xor    %eax,%eax
   d4d9c:	mov    %rcx,0x6e0(%rsp)
   d4da4:	mov    %rcx,0x700(%rsp)
   d4dac:	mov    %rax,0x720(%rsp)
   d4db4:	lea    0x6e0(%rsp),%rdi
   d4dbc:	call   136e50 <core::ptr::drop_in_place<alloc::collections::btree::map::IntoIter<alloc::string::String,serde_json::value::Value>>>
   d4dc1:	jmp    d567b <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x478b>
   d4dc6:	lea    0xad0(%rsp),%rdi
   d4dce:	call   6b6c0 <core::ptr::drop_in_place<serde_json::value::Value>>
   d4dd3:	mov    %r13,%rcx
   d4dd6:	mov    %rcx,%rbx
   d4dd9:	cmp    $0x1,%r14
   d4ddd:	je     d4dfa <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3f0a>
   d4ddf:	lea    0x40(%r12),%rax
   d4de4:	mov    %rax,0xc8(%rsp)
   d4dec:	movzbl 0x20(%r12),%eax
   d4df2:	cmp    $0x6,%al
   d4df4:	jne    d5195 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x42a5>
   d4dfa:	mov    $0x1,%edi
   d4dff:	lea    0x7961a2(%rip),%rsi        # 86afa8 <aws_lc_0_37_1_kem_asn1_meth+0x3ea8>
   d4e06:	lea    0x798b93(%rip),%rdx        # 86d9a0 <aws_lc_0_37_1_kem_asn1_meth+0x68a0>
   d4e0d:	call   4e160 <serde_core::de::Error::invalid_length>
   d4e12:	mov    %rax,%r15
   d4e15:	shl    $1,%rbx
   d4e18:	test   %rbx,%rbx
   d4e1b:	je     d4433 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3543>
   d4e21:	mov    0x1c0(%rsp),%rdi
   d4e29:	call   *0x7b4d31(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d4e2f:	jmp    d4433 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3543>
   d4e34:	mov    %rbp,0xa8(%rsp)
   d4e3c:	xor    %ebx,%ebx
   d4e3e:	mov    %rax,0x98(%rsp)
   d4e46:	mov    0x50(%rsp),%rax
   d4e4b:	mov    %rax,0x48(%rsp)
   d4e50:	mov    0xa0(%rsp),%rax
   d4e58:	movzbl 0x10(%rsp),%ecx
   d4e5d:	cmp    $0x2,%cl
   d4e60:	jne    d4edd <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3fed>
   d4e62:	mov    $0x7,%esi
   d4e67:	lea    0x607539(%rip),%rdi        # 6dc3a7 <encoding_rs::data::KSX1001_LOWERCASE+0x125c7>
   d4e6e:	call   4e010 <serde_core::de::Error::missing_field>
   d4e73:	mov    %rax,%r15
   d4e76:	movabs $0x8000000000000005,%rax
   d4e80:	mov    0x98(%rsp),%rcx
   d4e88:	cmp    %rax,%rcx
   d4e8b:	mov    0xa8(%rsp),%rbp
   d4e93:	jge    d5216 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4326>
   d4e99:	mov    0x38(%rsp),%rdi
   d4e9e:	cmpq   $0x0,0x28(%rsp)
   d4ea4:	je     d4eac <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3fbc>
   d4ea6:	call   *0x7b4cb4(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d4eac:	mov    $0x1,%al
   d4eae:	mov    %eax,0x30(%rsp)
   d4eb2:	mov    %r12,0x10(%rsp)
   d4eb7:	shl    $1,%rbp
   d4eba:	test   %rbp,%rbp
   d4ebd:	mov    %ebx,0x20(%rsp)
   d4ec1:	mov    %r14d,%r12d
   d4ec4:	je     d536a <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x447a>
   d4eca:	mov    0x1f8(%rsp),%rdi
   d4ed2:	call   *0x7b4c88(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d4ed8:	jmp    d536a <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x447a>
   d4edd:	and    $0x1,%cl
   d4ee0:	mov    %cl,0x10(%rsp)
   d4ee4:	mov    %rax,%r8
   d4ee7:	mov    0x58(%rsp),%r15
   d4eec:	cmp    %r13,%r15
   d4eef:	mov    $0x0,%ecx
   d4ef4:	cmove  %rcx,%r15
   d4ef8:	mov    $0x1,%eax
   d4efd:	mov    0xb8(%rsp),%rbx
   d4f05:	cmove  %rax,%rbx
   d4f09:	mov    0xb0(%rsp),%rdx
   d4f11:	cmove  %rcx,%rdx
   d4f15:	mov    0x370(%rsp),%rdi
   d4f1d:	cmp    %r13,%rdi
   d4f20:	cmove  %rcx,%rdi
   d4f24:	mov    0x378(%rsp),%r14
   d4f2c:	mov    $0x8,%eax
   d4f31:	cmove  %rax,%r14
   d4f35:	mov    0x380(%rsp),%r12
   d4f3d:	cmove  %rcx,%r12
   d4f41:	mov    0xa8(%rsp),%rax
   d4f49:	mov    %rax,0x728(%rsp)
   d4f51:	mov    0x1f8(%rsp),%rbp
   d4f59:	mov    %rbp,0x730(%rsp)
   d4f61:	mov    0x3a0(%rsp),%r10
   d4f69:	mov    %r10,0x738(%rsp)
   d4f71:	mov    0x98(%rsp),%rsi
   d4f79:	mov    %rsi,0x740(%rsp)
   d4f81:	mov    0x48(%rsp),%r11
   d4f86:	mov    %r11,0x748(%rsp)
   d4f8e:	mov    %r8,0x40(%rsp)
   d4f93:	mov    %r8,0x750(%rsp)
   d4f9b:	mov    0x398(%rsp),%rax
   d4fa3:	mov    %rax,0x758(%rsp)
   d4fab:	mov    0x390(%rsp),%rax
   d4fb3:	mov    %rax,0x760(%rsp)
   d4fbb:	mov    0x470(%rsp),%r8
   d4fc3:	mov    %r8,0x768(%rsp)
   d4fcb:	mov    0x468(%rsp),%r9
   d4fd3:	mov    %r9,0x770(%rsp)
   d4fdb:	mov    0x28(%rsp),%rax
   d4fe0:	mov    %rax,0x6e0(%rsp)
   d4fe8:	mov    0x38(%rsp),%rax
   d4fed:	mov    %rax,0x6e8(%rsp)
   d4ff5:	mov    (%rsp),%rax
   d4ff9:	mov    %rax,0x6f0(%rsp)
   d5001:	mov    %r15,0x58(%rsp)
   d5006:	mov    %r15,0x6f8(%rsp)
   d500e:	mov    %rbx,0xb8(%rsp)
   d5016:	mov    %rbx,0x700(%rsp)
   d501e:	mov    %rdx,0x708(%rsp)
   d5026:	mov    %rdi,0x128(%rsp)
   d502e:	mov    %rdi,0x710(%rsp)
   d5036:	mov    %r14,0x1f0(%rsp)
   d503e:	mov    %r14,0x718(%rsp)
   d5046:	mov    %r12,0x720(%rsp)
   d504e:	movzbl 0x10(%rsp),%eax
   d5053:	mov    %al,0x778(%rsp)
   d505a:	mov    0x63(%rsp),%eax
   d505e:	lea    0x779(%rsp),%rcx
   d5066:	mov    %eax,0x3(%rcx)
   d5069:	mov    0x60(%rsp),%eax
   d506d:	mov    %eax,(%rcx)
   d506f:	cmpq   $0x0,0x100(%rsp)
   d5078:	jne    d5be5 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4cf5>
   d507e:	mov    0x60(%rsp),%eax
   d5082:	mov    0x63(%rsp),%ecx
   d5086:	mov    %ecx,0x1bb(%rsp)
   d508d:	mov    %eax,0x1b8(%rsp)
   d5094:	mov    0xa8(%rsp),%rcx
   d509c:	mov    %rcx,0x2d0(%rsp)
   d50a4:	mov    %rbp,0x2c8(%rsp)
   d50ac:	mov    %r10,0x2c0(%rsp)
   d50b4:	mov    %rsi,0x2e8(%rsp)
   d50bc:	mov    %r11,0x2e0(%rsp)
   d50c4:	mov    0x40(%rsp),%rax
   d50c9:	mov    %rax,0x2d8(%rsp)
   d50d1:	mov    %r9,0x3a8(%rsp)
   d50d9:	mov    %r8,0x3c0(%rsp)
   d50e1:	mov    0x390(%rsp),%rax
   d50e9:	mov    %rax,0x3b8(%rsp)
   d50f1:	mov    0x398(%rsp),%rax
   d50f9:	mov    %rax,0x3b0(%rsp)
   d5101:	mov    (%rsp),%rax
   d5105:	mov    %rax,0x478(%rsp)
   d510d:	mov    0x38(%rsp),%r15
   d5112:	mov    %rcx,%rbp
   d5115:	mov    %r12,0x3f0(%rsp)
   d511d:	mov    %rdx,0xb0(%rsp)
   d5125:	lea    0xc0(%rsp),%rdi
   d512d:	call   136e50 <core::ptr::drop_in_place<alloc::collections::btree::map::IntoIter<alloc::string::String,serde_json::value::Value>>>
   d5132:	cmpb   $0x6,0x108(%rsp)
   d513a:	mov    0x470(%rsp),%rax
   d5142:	mov    %rax,0x5e0(%rsp)
   d514a:	mov    0x468(%rsp),%rax
   d5152:	mov    %rax,0x5d8(%rsp)
   d515a:	mov    0x398(%rsp),%rax
   d5162:	mov    %rax,0x5d0(%rsp)
   d516a:	mov    0x390(%rsp),%rax
   d5172:	mov    %rax,0x5c8(%rsp)
   d517a:	mov    0x1f8(%rsp),%r12
   d5182:	mov    0x3a0(%rsp),%rdx
   d518a:	jne    d54fe <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x460e>
   d5190:	jmp    d552c <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x463c>
   d5195:	mov    %al,0x6e0(%rsp)
   d519c:	movups 0x21(%r12),%xmm0
   d51a2:	movups 0x30(%r12),%xmm1
   d51a8:	lea    0x779(%rsp),%rax
   d51b0:	movups %xmm1,-0x89(%rax)
   d51b7:	movups %xmm0,-0x98(%rax)
   d51be:	lea    0x60(%rsp),%rdi
   d51c3:	lea    0x6e0(%rsp),%rsi
   d51cb:	call   15b830 <<<polymarket_client_sdk::clob::types::response::_::<impl serde_core::de::Deserialize for polymarket_client_sdk::clob::types::response::PostOrderResponse>::deserialize::__Visitor as serde_core::de::Visitor>::visit_map::__DeserializeWith as serde_core::de::Deserialize>::deserialize>
   d51d0:	testb  $0x1,0x60(%rsp)
   d51d5:	je     d51e1 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x42f1>
   d51d7:	mov    0x68(%rsp),%r15
   d51dc:	jmp    d4e15 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3f25>
   d51e1:	cmp    $0x2,%r14
   d51e5:	je     d520c <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x431c>
   d51e7:	mov    0x64(%rsp),%rbp
   d51ec:	mov    0x6c(%rsp),%r15
   d51f1:	lea    0x60(%r12),%rax
   d51f6:	mov    %rax,0xc8(%rsp)
   d51fe:	movzbl 0x40(%r12),%eax
   d5204:	cmp    $0x6,%al
   d5206:	jne    d58f3 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4a03>
   d520c:	mov    $0x2,%edi
   d5211:	jmp    d4dff <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3f0f>
   d5216:	test   %rcx,%rcx
   d5219:	je     d4e99 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3fa9>
   d521f:	mov    0x48(%rsp),%rdi
   d5224:	call   *0x7b4936(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d522a:	jmp    d4e99 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3fa9>
   d522f:	mov    %r12,0x10(%rsp)
   d5234:	mov    $0x10,%esi
   d5239:	lea    0x5f4050(%rip),%rdi        # 6c9290 <_fini+0x2184>
   d5240:	call   4e5c0 <<serde_json::error::Error as serde_core::de::Error>::custom>
   d5245:	jmp    d5356 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4466>
   d524a:	mov    %r12,0x10(%rsp)
   d524f:	lea    0x5(%r13),%rax
   d5253:	mov    %rax,0x40(%rsp)
   d5258:	mov    $0x10,%esi
   d525d:	lea    0x5f402c(%rip),%rdi        # 6c9290 <_fini+0x2184>
   d5264:	call   4e5c0 <<serde_json::error::Error as serde_core::de::Error>::custom>
   d5269:	mov    %rax,%r15
   d526c:	lea    0x5(%r13),%rax
   d5270:	mov    %rax,0x40(%rsp)
   d5275:	jmp    d5359 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4469>
   d527a:	mov    $0x10,%esi
   d527f:	lea    0x5f400a(%rip),%rdi        # 6c9290 <_fini+0x2184>
   d5286:	call   4e5c0 <<serde_json::error::Error as serde_core::de::Error>::custom>
   d528b:	jmp    d52ff <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x440f>
   d528d:	mov    $0x10,%esi
   d5292:	lea    0x5f3ff7(%rip),%rdi        # 6c9290 <_fini+0x2184>
   d5299:	call   4e5c0 <<serde_json::error::Error as serde_core::de::Error>::custom>
   d529e:	jmp    d52ff <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x440f>
   d52a0:	mov    %r12,0x10(%rsp)
   d52a5:	mov    $0x10,%esi
   d52aa:	lea    0x5f3fdf(%rip),%rdi        # 6c9290 <_fini+0x2184>
   d52b1:	call   4e5c0 <<serde_json::error::Error as serde_core::de::Error>::custom>
   d52b6:	jmp    d5356 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4466>
   d52bb:	mov    %r12,0x10(%rsp)
   d52c0:	mov    $0x10,%esi
   d52c5:	mov    %r13,0x28(%rsp)
   d52ca:	lea    0x5f3fbf(%rip),%rdi        # 6c9290 <_fini+0x2184>
   d52d1:	call   4e5c0 <<serde_json::error::Error as serde_core::de::Error>::custom>
   d52d6:	mov    %rax,%r15
   d52d9:	mov    $0x1,%al
   d52db:	mov    %eax,0x20(%rsp)
   d52df:	movl   $0x0,0x30(%rsp)
   d52e7:	mov    %r13,0x28(%rsp)
   d52ec:	jmp    d5367 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4477>
   d52ee:	mov    $0x10,%esi
   d52f3:	lea    0x5f3f96(%rip),%rdi        # 6c9290 <_fini+0x2184>
   d52fa:	call   4e5c0 <<serde_json::error::Error as serde_core::de::Error>::custom>
   d52ff:	mov    %rax,%r15
   d5302:	mov    %r12,0x10(%rsp)
   d5307:	jmp    d5359 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4469>
   d5309:	mov    %r12,0x10(%rsp)
   d530e:	mov    $0x10,%esi
   d5313:	mov    %r13,0x58(%rsp)
   d5318:	lea    0x5f3f71(%rip),%rdi        # 6c9290 <_fini+0x2184>
   d531f:	call   4e5c0 <<serde_json::error::Error as serde_core::de::Error>::custom>
   d5324:	mov    %rax,%r15
   d5327:	mov    $0x1,%al
   d5329:	mov    %eax,0x20(%rsp)
   d532d:	movl   $0x0,0x30(%rsp)
   d5335:	mov    %r13,0x58(%rsp)
   d533a:	jmp    d5367 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4477>
   d533c:	lea    0x1(%r13),%rax
   d5340:	mov    %rax,0x10(%rsp)
   d5345:	mov    $0x10,%esi
   d534a:	lea    0x5f3f3f(%rip),%rdi        # 6c9290 <_fini+0x2184>
   d5351:	call   4e5c0 <<serde_json::error::Error as serde_core::de::Error>::custom>
   d5356:	mov    %rax,%r15
   d5359:	mov    $0x1,%al
   d535b:	mov    %eax,0x20(%rsp)
   d535f:	movl   $0x0,0x30(%rsp)
   d5367:	mov    $0x1,%r12b
   d536a:	mov    0x370(%rsp),%rbp
   d5372:	cmp    %r13,%rbp
   d5375:	je     d53c5 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x44d5>
   d5377:	mov    0x378(%rsp),%r14
   d537f:	mov    0x380(%rsp),%rbx
   d5387:	lea    0x8(%r14),%r13
   d538b:	jmp    d5394 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x44a4>
   d538d:	nopl   (%rax)
   d5390:	add    $0x18,%r13
   d5394:	sub    $0x1,%rbx
   d5398:	jb     d53ad <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x44bd>
   d539a:	cmpq   $0x0,-0x8(%r13)
   d539f:	je     d5390 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x44a0>
   d53a1:	mov    0x0(%r13),%rdi
   d53a5:	call   *0x7b47b5(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d53ab:	jmp    d5390 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x44a0>
   d53ad:	test   %rbp,%rbp
   d53b0:	movabs $0x8000000000000000,%r13
   d53ba:	je     d53c5 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x44d5>
   d53bc:	mov    %r14,%rdi
   d53bf:	call   *0x7b479b(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d53c5:	mov    0x58(%rsp),%rax
   d53ca:	shl    $1,%rax
   d53cd:	test   %rax,%rax
   d53d0:	mov    0x38(%rsp),%rbx
   d53d5:	je     d53e5 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x44f5>
   d53d7:	mov    0xb8(%rsp),%rdi
   d53df:	call   *0x7b477b(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d53e5:	cmpb   $0x0,0x20(%rsp)
   d53ea:	je     d5401 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4511>
   d53ec:	movabs $0x8000000000000006,%rax
   d53f6:	cmp    %rax,0x40(%rsp)
   d53fb:	jge    d581b <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x492b>
   d5401:	cmpb   $0x0,0x30(%rsp)
   d5406:	jne    d541e <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x452e>
   d5408:	mov    0x28(%rsp),%rax
   d540d:	shl    $1,%rax
   d5410:	test   %rax,%rax
   d5413:	je     d541e <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x452e>
   d5415:	mov    %rbx,%rdi
   d5418:	call   *0x7b4742(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d541e:	test   %r12b,%r12b
   d5421:	mov    0x10(%rsp),%rcx
   d5426:	je     d544a <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x455a>
   d5428:	movabs $0x8000000000000002,%rax
   d5432:	cmp    %rax,%rcx
   d5435:	jl     d544a <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x455a>
   d5437:	test   %rcx,%rcx
   d543a:	je     d544a <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x455a>
   d543c:	mov    0x88(%rsp),%rdi
   d5444:	call   *0x7b4716(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d544a:	mov    0x60(%rsp),%eax
   d544e:	mov    0x63(%rsp),%ecx
   d5452:	mov    %eax,0x1b8(%rsp)
   d5459:	mov    %ecx,0x1bb(%rsp)
   d5460:	lea    0xc0(%rsp),%rdi
   d5468:	call   136e50 <core::ptr::drop_in_place<alloc::collections::btree::map::IntoIter<alloc::string::String,serde_json::value::Value>>>
   d546d:	cmpb   $0x6,0x108(%rsp)
   d5475:	mov    0x2e8(%rsp),%rax
   d547d:	mov    %rax,0x98(%rsp)
   d5485:	mov    0x2e0(%rsp),%rax
   d548d:	mov    %rax,0x48(%rsp)
   d5492:	mov    0x2d8(%rsp),%rax
   d549a:	mov    %rax,0x40(%rsp)
   d549f:	mov    0x2d0(%rsp),%rbp
   d54a7:	mov    0x2c8(%rsp),%r12
   d54af:	mov    0x2c0(%rsp),%rdx
   d54b7:	mov    0x5d8(%rsp),%rax
   d54bf:	mov    %rax,0x3a8(%rsp)
   d54c7:	mov    0x5e0(%rsp),%rax
   d54cf:	mov    %rax,0x3c0(%rsp)
   d54d7:	mov    0x5c8(%rsp),%rax
   d54df:	mov    %rax,0x3b8(%rsp)
   d54e7:	mov    0x5d0(%rsp),%rax
   d54ef:	mov    %rax,0x3b0(%rsp)
   d54f7:	mov    %r13,0x28(%rsp)
   d54fc:	je     d552c <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x463c>
   d54fe:	mov    %r15,0x20(%rsp)
   d5503:	mov    $0x1,%bl
   d5505:	xor    %r14d,%r14d
   d5508:	lea    0x108(%rsp),%rdi
   d5510:	mov    %r13,%r15
   d5513:	mov    %rbp,%r13
   d5516:	mov    %rdx,%rbp
   d5519:	call   136cd0 <core::ptr::drop_in_place<serde_json::value::Value>.4830>
   d551e:	mov    %rbp,%rdx
   d5521:	mov    %r13,%rbp
   d5524:	mov    %r15,%r13
   d5527:	mov    0x20(%rsp),%r15
   d552c:	mov    0x2d0(%rsp),%rax
   d5534:	mov    %rax,0x2f0(%rsp)
   d553c:	mov    0x2c8(%rsp),%rax
   d5544:	mov    %rax,0x20(%rsp)
   d5549:	mov    0x2c0(%rsp),%rax
   d5551:	mov    %rax,0x30(%rsp)
   d5556:	mov    0x2e8(%rsp),%rax
   d555e:	mov    %rax,0x1a8(%rsp)
   d5566:	mov    0x2e0(%rsp),%rax
   d556e:	mov    %rax,0x1a0(%rsp)
   d5576:	mov    0x2d8(%rsp),%rax
   d557e:	mov    %rax,0x198(%rsp)
   d5586:	mov    0x98(%rsp),%rax
   d558e:	mov    %rax,0x2e8(%rsp)
   d5596:	mov    0x48(%rsp),%rax
   d559b:	mov    %rax,0x2e0(%rsp)
   d55a3:	mov    0x40(%rsp),%rax
   d55a8:	mov    %rax,0x2d8(%rsp)
   d55b0:	mov    %rbp,0x2d0(%rsp)
   d55b8:	mov    %r12,0x2c8(%rsp)
   d55c0:	mov    %rdx,0x2c0(%rsp)
   d55c8:	movzbl 0x10(%rsp),%eax
   d55cd:	mov    %al,0x1f(%rsp)
   d55d1:	mov    0x1f0(%rsp),%rax
   d55d9:	mov    %rax,0x3e8(%rsp)
   d55e1:	mov    0x128(%rsp),%rax
   d55e9:	mov    %rax,0x3e0(%rsp)
   d55f1:	mov    0xb0(%rsp),%rax
   d55f9:	mov    %rax,0x3d8(%rsp)
   d5601:	mov    0xb8(%rsp),%rax
   d5609:	mov    %rax,0x3d0(%rsp)
   d5611:	mov    0x58(%rsp),%rax
   d5616:	mov    %rax,0x3c8(%rsp)
   d561e:	mov    $0x1,%al
   d5620:	xor    %edx,%edx
   d5622:	movzbl 0x2a0(%rsp),%ecx
   d562a:	cmp    $0x4,%ecx
   d562d:	jne    d44c9 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x35d9>
   d5633:	test   %al,%al
   d5635:	je     d567b <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x478b>
   d5637:	mov    0x2b0(%rsp),%r14
   d563f:	mov    0x2b8(%rsp),%rbp
   d5647:	inc    %rbp
   d564a:	mov    %r14,%rdi
   d564d:	nopl   (%rax)
   d5650:	cmp    $0x1,%rbp
   d5654:	je     d5667 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4777>
   d5656:	lea    0x20(%rdi),%r12
   d565a:	dec    %rbp
   d565d:	call   136cd0 <core::ptr::drop_in_place<serde_json::value::Value>.4830>
   d5662:	mov    %r12,%rdi
   d5665:	jmp    d5650 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4760>
   d5667:	cmpq   $0x0,0x2a8(%rsp)
   d5670:	je     d567b <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x478b>
   d5672:	mov    %r14,%rdi
   d5675:	call   *0x7b44e5(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d567b:	mov    0x28(%rsp),%rdx
   d5680:	cmp    %r13,%rdx
   d5683:	je     d61a7 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x52b7>
   d5689:	mov    0x1b8(%rsp),%eax
   d5690:	mov    0x1bb(%rsp),%ecx
   d5697:	mov    %ecx,0x31b(%rsp)
   d569e:	mov    %eax,0x318(%rsp)
   d56a5:	lea    0x1(%r13),%rax
   d56a9:	cmp    %rax,%rdx
   d56ac:	je     d61a7 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x52b7>
   d56b2:	mov    %rdx,0x200(%rsp)
   d56ba:	mov    %r15,0x208(%rsp)
   d56c2:	mov    0x478(%rsp),%rax
   d56ca:	mov    %rax,0x210(%rsp)
   d56d2:	mov    0x3c8(%rsp),%rax
   d56da:	mov    %rax,0x218(%rsp)
   d56e2:	mov    0x3d0(%rsp),%rax
   d56ea:	mov    %rax,0x220(%rsp)
   d56f2:	mov    0x3d8(%rsp),%rax
   d56fa:	mov    %rax,0x228(%rsp)
   d5702:	mov    0x3e0(%rsp),%rax
   d570a:	mov    %rax,0x230(%rsp)
   d5712:	mov    0x3e8(%rsp),%rax
   d571a:	mov    %rax,0x238(%rsp)
   d5722:	mov    0x3f0(%rsp),%rax
   d572a:	mov    %rax,0x240(%rsp)
   d5732:	mov    0x2f0(%rsp),%rax
   d573a:	mov    %rax,0x248(%rsp)
   d5742:	mov    0x20(%rsp),%rax
   d5747:	mov    %rax,0x250(%rsp)
   d574f:	mov    0x30(%rsp),%rax
   d5754:	mov    %rax,0x258(%rsp)
   d575c:	mov    0x1a8(%rsp),%rax
   d5764:	mov    %rax,0x260(%rsp)
   d576c:	mov    0x1a0(%rsp),%rax
   d5774:	mov    %rax,0x268(%rsp)
   d577c:	mov    0x198(%rsp),%rax
   d5784:	mov    %rax,0x270(%rsp)
   d578c:	mov    0x3b0(%rsp),%rax
   d5794:	mov    %rax,0x278(%rsp)
   d579c:	mov    0x3b8(%rsp),%rax
   d57a4:	mov    %rax,0x280(%rsp)
   d57ac:	mov    0x3c0(%rsp),%rax
   d57b4:	mov    %rax,0x288(%rsp)
   d57bc:	mov    0x3a8(%rsp),%rax
   d57c4:	mov    %rax,0x290(%rsp)
   d57cc:	movzbl 0x1f(%rsp),%eax
   d57d1:	mov    %al,0x298(%rsp)
   d57d8:	mov    0x31b(%rsp),%eax
   d57df:	lea    0x299(%rsp),%rcx
   d57e7:	mov    %eax,0x3(%rcx)
   d57ea:	mov    0x318(%rsp),%eax
   d57f1:	mov    %eax,(%rcx)
   d57f3:	mov    0x308(%rsp),%r14
   d57fb:	cmp    0x2f8(%rsp),%r14
   d5803:	jne    d424b <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x335b>
   d5809:	lea    0x2f8(%rsp),%rdi
   d5811:	call   1a7f70 <alloc::raw_vec::RawVec<T,A>::grow_one>
   d5816:	jmp    d424b <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x335b>
   d581b:	cmpq   $0x0,0x40(%rsp)
   d5821:	je     d5401 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4511>
   d5827:	mov    0x50(%rsp),%rdi
   d582c:	call   *0x7b432e(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d5832:	jmp    d5401 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4511>
   d5837:	mov    %r12,0x10(%rsp)
   d583c:	movl   $0x0,0x30(%rsp)
   d5844:	mov    $0x1,%cl
   d5846:	mov    %ecx,0x20(%rsp)
   d584a:	mov    %r13,0x28(%rsp)
   d584f:	mov    %rax,%r15
   d5852:	jmp    d5367 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4477>
   d5857:	mov    %r12,0x10(%rsp)
   d585c:	mov    $0x1,%al
   d585e:	mov    %eax,0x20(%rsp)
   d5862:	mov    0x6d0(%rsp),%r15
   d586a:	jmp    d535f <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x446f>
   d586f:	mov    %r12,0x10(%rsp)
   d5874:	movl   $0x0,0x30(%rsp)
   d587c:	mov    $0x1,%al
   d587e:	mov    %eax,0x20(%rsp)
   d5882:	mov    0x5a8(%rsp),%r15
   d588a:	jmp    d5367 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4477>
   d588f:	mov    %r12,0x10(%rsp)
   d5894:	movl   $0x0,0x30(%rsp)
   d589c:	mov    $0x1,%al
   d589e:	mov    %eax,0x20(%rsp)
   d58a2:	mov    %rdi,0x40(%rsp)
   d58a7:	mov    %rdx,%r15
   d58aa:	jmp    d5367 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4477>
   d58af:	mov    %r12,0x10(%rsp)
   d58b4:	movl   $0x0,0x30(%rsp)
   d58bc:	mov    $0x1,%al
   d58be:	mov    %eax,0x20(%rsp)
   d58c2:	mov    %r13,0x58(%rsp)
   d58c7:	mov    %rdi,%r15
   d58ca:	jmp    d5367 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4477>
   d58cf:	lea    0x1(%r13),%rax
   d58d3:	mov    %rax,0x10(%rsp)
   d58d8:	mov    $0x1,%al
   d58da:	mov    %eax,0x20(%rsp)
   d58de:	movl   $0x0,0x30(%rsp)
   d58e6:	mov    %r15,0x460(%rsp)
   d58ee:	jmp    d5367 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4477>
   d58f3:	mov    %al,0x6e0(%rsp)
   d58fa:	movups 0x41(%r12),%xmm0
   d5900:	movups 0x50(%r12),%xmm1
   d5906:	lea    0x779(%rsp),%rax
   d590e:	movups %xmm1,-0x89(%rax)
   d5915:	movups %xmm0,-0x98(%rax)
   d591c:	lea    0x60(%rsp),%rdi
   d5921:	lea    0x6e0(%rsp),%rsi
   d5929:	call   15b830 <<<polymarket_client_sdk::clob::types::response::_::<impl serde_core::de::Deserialize for polymarket_client_sdk::clob::types::response::PostOrderResponse>::deserialize::__Visitor as serde_core::de::Visitor>::visit_map::__DeserializeWith as serde_core::de::Deserialize>::deserialize>
   d592e:	testb  $0x1,0x60(%rsp)
   d5933:	jne    d51d7 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x42e7>
   d5939:	cmp    $0x3,%r14
   d593d:	je     d596d <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4a7d>
   d593f:	mov    0x64(%rsp),%rax
   d5944:	mov    %rax,0x58(%rsp)
   d5949:	mov    0x6c(%rsp),%rax
   d594e:	mov    %rax,0x40(%rsp)
   d5953:	lea    0x80(%r12),%rax
   d595b:	mov    %rax,0xc8(%rsp)
   d5963:	movzbl 0x60(%r12),%eax
   d5969:	cmp    $0x6,%al
   d596b:	jne    d5977 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4a87>
   d596d:	mov    $0x3,%edi
   d5972:	jmp    d4dff <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3f0f>
   d5977:	mov    %al,0x6e0(%rsp)
   d597e:	movups 0x61(%r12),%xmm0
   d5984:	movups 0x70(%r12),%xmm1
   d598a:	lea    0x779(%rsp),%rax
   d5992:	movups %xmm1,-0x89(%rax)
   d5999:	movups %xmm0,-0x98(%rax)
   d59a0:	lea    0x60(%rsp),%rdi
   d59a5:	lea    0x6e0(%rsp),%rsi
   d59ad:	call   65550 <serde_json::value::de::<impl serde_core::de::Deserializer for serde_json::value::Value>::deserialize_string>
   d59b2:	mov    %r15,0x10(%rsp)
   d59b7:	mov    0x60(%rsp),%rcx
   d59bc:	mov    0x68(%rsp),%r15
   d59c1:	mov    %rcx,0x28(%rsp)
   d59c6:	cmp    %r13,%rcx
   d59c9:	je     d5a2e <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4b3e>
   d59cb:	cmp    $0x4,%r14
   d59cf:	je     d59ff <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4b0f>
   d59d1:	mov    0x70(%rsp),%rax
   d59d6:	mov    %rax,0x98(%rsp)
   d59de:	lea    0xa0(%r12),%rax
   d59e6:	mov    %rax,0xc8(%rsp)
   d59ee:	movzbl 0x80(%r12),%eax
   d59f7:	cmp    $0x6,%al
   d59f9:	jne    d5b12 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4c22>
   d59ff:	mov    $0x4,%edi
   d5a04:	lea    0x79559d(%rip),%rsi        # 86afa8 <aws_lc_0_37_1_kem_asn1_meth+0x3ea8>
   d5a0b:	lea    0x797f8e(%rip),%rdx        # 86d9a0 <aws_lc_0_37_1_kem_asn1_meth+0x68a0>
   d5a12:	call   4e160 <serde_core::de::Error::invalid_length>
   d5a17:	mov    %rax,%r13
   d5a1a:	cmpq   $0x0,0x28(%rsp)
   d5a20:	je     d5a2b <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4b3b>
   d5a22:	mov    %r15,%rdi
   d5a25:	call   *0x7b4135(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d5a2b:	mov    %r13,%r15
   d5a2e:	movabs $0x8000000000000000,%r13
   d5a38:	jmp    d4e15 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3f25>
   d5a3d:	mov    %r8,(%rsp)
   d5a41:	mov    $0x1,%r14b
   d5a44:	mov    $0x1,%bl
   d5a46:	lea    0x2a0(%rsp),%rdi
   d5a4e:	lea    0x1e(%rsp),%rsi
   d5a53:	lea    0x7918de(%rip),%rdx        # 867338 <aws_lc_0_37_1_kem_asn1_meth+0x238>
   d5a5a:	call   4a2c0 <serde_json::value::de::<impl serde_json::value::Value>::invalid_type>
   d5a5f:	mov    %rax,%r15
   d5a62:	mov    %r13,0x28(%rsp)
   d5a67:	mov    $0x1,%al
   d5a69:	mov    $0x1,%dl
   d5a6b:	movzbl 0x2a0(%rsp),%ecx
   d5a73:	cmp    $0x4,%ecx
   d5a76:	jne    d44c9 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x35d9>
   d5a7c:	jmp    d5633 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4743>
   d5a81:	mov    $0xc,%esi
   d5a86:	mov    0x28(%rsp),%rbx
   d5a8b:	call   4e010 <serde_core::de::Error::missing_field>
   d5a90:	jmp    d4ca3 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x3db3>
   d5a95:	mov    $0x8,%esi
   d5a9a:	lea    0x5f529f(%rip),%rdi        # 6cad40 <encoding_rs::data::KSX1001_LOWERCASE+0xf60>
   d5aa1:	jmp    d5b03 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4c13>
   d5aa3:	mov    $0x7,%esi
   d5aa8:	lea    0x6068f1(%rip),%rdi        # 6dc3a0 <encoding_rs::data::KSX1001_LOWERCASE+0x125c0>
   d5aaf:	jmp    d5b03 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4c13>
   d5ab1:	mov    $0x6,%esi
   d5ab6:	lea    0x60687f(%rip),%rdi        # 6dc33c <encoding_rs::data::KSX1001_LOWERCASE+0x1255c>
   d5abd:	jmp    d5b03 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4c13>
   d5abf:	mov    $0xc,%esi
   d5ac4:	lea    0x6068bd(%rip),%rdi        # 6dc388 <encoding_rs::data::KSX1001_LOWERCASE+0x125a8>
   d5acb:	jmp    d5b03 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4c13>
   d5acd:	mov    $0x8,%esi
   d5ad2:	lea    0x5f526f(%rip),%rdi        # 6cad48 <encoding_rs::data::KSX1001_LOWERCASE+0xf68>
   d5ad9:	jmp    d5b03 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4c13>
   d5adb:	mov    $0xc,%esi
   d5ae0:	lea    0x6068ad(%rip),%rdi        # 6dc394 <encoding_rs::data::KSX1001_LOWERCASE+0x125b4>
   d5ae7:	jmp    d5b03 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4c13>
   d5ae9:	mov    $0x7,%esi
   d5aee:	lea    0x6068b2(%rip),%rdi        # 6dc3a7 <encoding_rs::data::KSX1001_LOWERCASE+0x125c7>
   d5af5:	jmp    d5b03 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4c13>
   d5af7:	mov    $0x11,%esi
   d5afc:	lea    0x6068ab(%rip),%rdi        # 6dc3ae <encoding_rs::data::KSX1001_LOWERCASE+0x125ce>
   d5b03:	mov    %r12,0x10(%rsp)
   d5b08:	call   4e1e0 <serde_core::de::Error::duplicate_field>
   d5b0d:	jmp    d5356 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4466>
   d5b12:	mov    %al,0x6e0(%rsp)
   d5b19:	movups 0x81(%r12),%xmm0
   d5b22:	movups 0x90(%r12),%xmm1
   d5b2b:	lea    0x779(%rsp),%rax
   d5b33:	movups %xmm1,-0x89(%rax)
   d5b3a:	movups %xmm0,-0x98(%rax)
   d5b41:	lea    0x60(%rsp),%rdi
   d5b46:	lea    0x6e0(%rsp),%rsi
   d5b4e:	call   1b50b0 <polymarket_client_sdk::clob::types::_::<impl serde_core::de::Deserialize for polymarket_client_sdk::clob::types::OrderStatusType>::deserialize>
   d5b53:	mov    0x60(%rsp),%rcx
   d5b58:	mov    0x68(%rsp),%r13
   d5b5d:	movabs $0x8000000000000000,%rax
   d5b67:	add    $0x5,%rax
   d5b6b:	mov    %rcx,0x48(%rsp)
   d5b70:	cmp    %rax,%rcx
   d5b73:	je     d5a1a <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4b2a>
   d5b79:	cmp    $0x5,%r14
   d5b7d:	je     d5bad <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4cbd>
   d5b7f:	mov    0x70(%rsp),%rax
   d5b84:	mov    %rax,0xb8(%rsp)
   d5b8c:	lea    0xc0(%r12),%rax
   d5b94:	mov    %rax,0xc8(%rsp)
   d5b9c:	movzbl 0xa0(%r12),%eax
   d5ba5:	cmp    $0x6,%al
   d5ba7:	jne    d5cf9 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4e09>
   d5bad:	mov    $0x5,%edi
   d5bb2:	lea    0x7953ef(%rip),%rsi        # 86afa8 <aws_lc_0_37_1_kem_asn1_meth+0x3ea8>
   d5bb9:	lea    0x797de0(%rip),%rdx        # 86d9a0 <aws_lc_0_37_1_kem_asn1_meth+0x68a0>
   d5bc0:	call   4e160 <serde_core::de::Error::invalid_length>
   d5bc5:	mov    %rax,%r12
   d5bc8:	movabs $0x8000000000000005,%rax
   d5bd2:	cmp    %rax,0x48(%rsp)
   d5bd7:	jge    d5cdf <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4def>
   d5bdd:	mov    %r12,%r13
   d5be0:	jmp    d5a1a <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4b2a>
   d5be5:	mov    0xa8(%rsp),%r14
   d5bed:	mov    0x5b0(%rsp),%rdi
   d5bf5:	lea    0x79534c(%rip),%rsi        # 86af48 <aws_lc_0_37_1_kem_asn1_meth+0x3e48>
   d5bfc:	lea    0x797d9d(%rip),%rdx        # 86d9a0 <aws_lc_0_37_1_kem_asn1_meth+0x68a0>
   d5c03:	call   4e160 <serde_core::de::Error::invalid_length>
   d5c08:	mov    %rax,%r15
   d5c0b:	lea    0x6e0(%rsp),%rdi
   d5c13:	call   136580 <core::ptr::drop_in_place<polymarket_client_sdk::clob::types::response::PostOrderResponse>>
   d5c18:	mov    0x2f0(%rsp),%rax
   d5c20:	mov    %rax,0x2d0(%rsp)
   d5c28:	mov    0x20(%rsp),%rax
   d5c2d:	mov    %rax,0x2c8(%rsp)
   d5c35:	mov    0x30(%rsp),%rax
   d5c3a:	mov    %rax,0x2c0(%rsp)
   d5c42:	mov    0x1a8(%rsp),%rax
   d5c4a:	mov    %rax,0x2e8(%rsp)
   d5c52:	mov    0x1a0(%rsp),%rax
   d5c5a:	mov    %rax,0x2e0(%rsp)
   d5c62:	mov    0x198(%rsp),%rax
   d5c6a:	mov    %rax,0x2d8(%rsp)
   d5c72:	movzbl 0x1f(%rsp),%eax
   d5c77:	mov    %al,0x10(%rsp)
   d5c7b:	mov    0x3f0(%rsp),%r12
   d5c83:	mov    0x3e8(%rsp),%rax
   d5c8b:	mov    %rax,0x1f0(%rsp)
   d5c93:	mov    0x3e0(%rsp),%rax
   d5c9b:	mov    %rax,0x128(%rsp)
   d5ca3:	mov    0x3d8(%rsp),%rdx
   d5cab:	mov    0x3d0(%rsp),%rax
   d5cb3:	mov    %rax,0xb8(%rsp)
   d5cbb:	mov    0x3c8(%rsp),%rax
   d5cc3:	mov    %rax,0x58(%rsp)
   d5cc8:	movabs $0x8000000000000000,%r13
   d5cd2:	mov    %r13,0x28(%rsp)
   d5cd7:	mov    %r14,%rbp
   d5cda:	jmp    d5115 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4225>
   d5cdf:	cmpq   $0x0,0x48(%rsp)
   d5ce5:	je     d5bdd <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4ced>
   d5ceb:	mov    %r13,%rdi
   d5cee:	call   *0x7b3e6c(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d5cf4:	jmp    d5bdd <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4ced>
   d5cf9:	mov    %al,0x6e0(%rsp)
   d5d00:	movups 0xa1(%r12),%xmm0
   d5d09:	movups 0xb0(%r12),%xmm1
   d5d12:	lea    0x779(%rsp),%rax
   d5d1a:	movups %xmm1,-0x89(%rax)
   d5d21:	movups %xmm0,-0x98(%rax)
   d5d28:	lea    0x60(%rsp),%rdi
   d5d2d:	lea    0x6e0(%rsp),%rsi
   d5d35:	call   153760 <serde_core::de::impls::<impl serde_core::de::Deserialize for bool>::deserialize>
   d5d3a:	cmpb   $0x0,0x60(%rsp)
   d5d3f:	je     d5d4b <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4e5b>
   d5d41:	mov    0x68(%rsp),%r12
   d5d46:	jmp    d5bc8 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4cd8>
   d5d4b:	movzbl 0x61(%rsp),%eax
   d5d50:	mov    %al,0x1f0(%rsp)
   d5d57:	lea    0x6e0(%rsp),%rdi
   d5d5f:	lea    0xc0(%rsp),%rsi
   d5d67:	call   136850 <<&mut A as serde_core::de::SeqAccess>::next_element>
   d5d6c:	mov    0x6e0(%rsp),%rax
   d5d74:	mov    %rax,0xb0(%rsp)
   d5d7c:	neg    %rax
   d5d7f:	jo     d5db2 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4ec2>
   d5d81:	mov    0x6e8(%rsp),%rax
   d5d89:	mov    %rax,0x128(%rsp)
   d5d91:	movabs $0x8000000000000001,%rax
   d5d9b:	cmp    %rax,0xb0(%rsp)
   d5da3:	jne    d5dd9 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4ee9>
   d5da5:	mov    0x128(%rsp),%r12
   d5dad:	jmp    d5bc8 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4cd8>
   d5db2:	mov    $0x1,%eax
   d5db7:	mov    %rax,0x128(%rsp)
   d5dbf:	movq   $0x0,0xb0(%rsp)
   d5dcb:	movq   $0x0,0xa8(%rsp)
   d5dd7:	jmp    d5de9 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4ef9>
   d5dd9:	mov    0x6f0(%rsp),%rax
   d5de1:	mov    %rax,0xa8(%rsp)
   d5de9:	lea    0x6e0(%rsp),%rdi
   d5df1:	lea    0xc0(%rsp),%rsi
   d5df9:	call   1368f0 <<&mut A as serde_core::de::SeqAccess>::next_element>
   d5dfe:	mov    0x6e0(%rsp),%rax
   d5e06:	mov    0x6e8(%rsp),%r12
   d5e0e:	movabs $0x8000000000000000,%rcx
   d5e18:	inc    %rcx
   d5e1b:	cmp    %rcx,%rax
   d5e1e:	jne    d5e42 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4f52>
   d5e20:	cmpq   $0x0,0xb0(%rsp)
   d5e29:	je     d5bc8 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4cd8>
   d5e2f:	mov    0x128(%rsp),%rdi
   d5e37:	call   *0x7b3d23(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d5e3d:	jmp    d5bc8 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x4cd8>
   d5e42:	movabs $0x8000000000000000,%rcx
   d5e4c:	cmp    %rcx,%rax
   d5e4f:	mov    $0x0,%edx
   d5e54:	cmove  %rdx,%rax
   d5e58:	mov    $0x8,%ecx
   d5e5d:	cmove  %rcx,%r12
   d5e61:	mov    0x6f0(%rsp),%rcx
   d5e69:	cmove  %rdx,%rcx
   d5e6d:	mov    0xb0(%rsp),%rdx
   d5e75:	mov    %rdx,0x6f8(%rsp)
   d5e7d:	mov    0x128(%rsp),%rdx
   d5e85:	mov    %rdx,0x700(%rsp)
   d5e8d:	mov    0xa8(%rsp),%rdx
   d5e95:	mov    %rdx,0x708(%rsp)
   d5e9d:	mov    %rbx,0x728(%rsp)
   d5ea5:	mov    0x1c0(%rsp),%rdx
   d5ead:	mov    %rdx,0x730(%rsp)
   d5eb5:	mov    0x388(%rsp),%rdx
   d5ebd:	mov    %rdx,0x738(%rsp)
   d5ec5:	mov    0x48(%rsp),%rdx
   d5eca:	mov    %rdx,0x740(%rsp)
   d5ed2:	mov    %r13,0x748(%rsp)
   d5eda:	mov    0xb8(%rsp),%rdx
   d5ee2:	mov    %rdx,0x750(%rsp)
   d5eea:	mov    0x28(%rsp),%rdx
   d5eef:	mov    %rdx,0x6e0(%rsp)
   d5ef7:	mov    %r15,0x6e8(%rsp)
   d5eff:	mov    0x98(%rsp),%rdx
   d5f07:	mov    %rdx,0x6f0(%rsp)
   d5f0f:	mov    %rax,0x710(%rsp)
   d5f17:	mov    %r12,0x718(%rsp)
   d5f1f:	mov    %rcx,0x720(%rsp)
   d5f27:	mov    %rbp,0x758(%rsp)
   d5f2f:	mov    0x10(%rsp),%rdx
   d5f34:	mov    %rdx,0x760(%rsp)
   d5f3c:	mov    0x58(%rsp),%rdx
   d5f41:	mov    %rdx,0x768(%rsp)
   d5f49:	mov    0x40(%rsp),%rdx
   d5f4e:	mov    %rdx,0x770(%rsp)
   d5f56:	movzbl 0x1f0(%rsp),%edx
   d5f5e:	mov    %dl,0x778(%rsp)
   d5f65:	mov    0xd8(%rsp),%rdx
   d5f6d:	cmp    0xc8(%rsp),%rdx
   d5f75:	jne    d608f <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x519f>
   d5f7b:	mov    0x48(%rsp),%rdx
   d5f80:	mov    %rdx,0x1e8(%rsp)
   d5f88:	mov    %rdx,0x1a8(%rsp)
   d5f90:	mov    %r13,0x1e0(%rsp)
   d5f98:	mov    %r13,0x1a0(%rsp)
   d5fa0:	mov    0xb8(%rsp),%rdx
   d5fa8:	mov    %rdx,0x1d8(%rsp)
   d5fb0:	mov    %rdx,0x198(%rsp)
   d5fb8:	movzbl 0x1f0(%rsp),%edx
   d5fc0:	mov    %dl,0x1f(%rsp)
   d5fc4:	mov    0x40(%rsp),%rdx
   d5fc9:	mov    %rdx,0x3a8(%rsp)
   d5fd1:	mov    0x58(%rsp),%rdx
   d5fd6:	mov    %rdx,0x3c0(%rsp)
   d5fde:	mov    0x10(%rsp),%rdx
   d5fe3:	mov    %rdx,0x3b8(%rsp)
   d5feb:	mov    %rbp,0x3b0(%rsp)
   d5ff3:	mov    %rcx,0x3f0(%rsp)
   d5ffb:	mov    %r12,0x3e8(%rsp)
   d6003:	mov    %rax,0x3e0(%rsp)
   d600b:	mov    0xa8(%rsp),%rax
   d6013:	mov    %rax,0x3d8(%rsp)
   d601b:	mov    0x128(%rsp),%rax
   d6023:	mov    %rax,0x3d0(%rsp)
   d602b:	mov    0xb0(%rsp),%rax
   d6033:	mov    %rax,0x3c8(%rsp)
   d603b:	mov    0x98(%rsp),%rax
   d6043:	mov    %rax,0x478(%rsp)
   d604b:	mov    %rbx,%r12
   d604e:	mov    %rbx,0x190(%rsp)
   d6056:	mov    0x388(%rsp),%rcx
   d605e:	mov    %rcx,0x1d0(%rsp)
   d6066:	mov    0x1c0(%rsp),%rax
   d606e:	mov    %rax,0x1c8(%rsp)
   d6076:	mov    %rax,0x20(%rsp)
   d607b:	mov    %rcx,0x30(%rsp)
   d6080:	movabs $0x8000000000000000,%r13
   d608a:	jmp    d448a <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x359a>
   d608f:	mov    %r14,%rdi
   d6092:	lea    0x794e9f(%rip),%rsi        # 86af38 <aws_lc_0_37_1_kem_asn1_meth+0x3e38>
   d6099:	lea    0x797900(%rip),%rdx        # 86d9a0 <aws_lc_0_37_1_kem_asn1_meth+0x68a0>
   d60a0:	call   4e160 <serde_core::de::Error::invalid_length>
   d60a5:	mov    %rax,%r15
   d60a8:	lea    0x6e0(%rsp),%rdi
   d60b0:	call   136580 <core::ptr::drop_in_place<polymarket_client_sdk::clob::types::response::PostOrderResponse>>
   d60b5:	mov    0x2f0(%rsp),%rax
   d60bd:	mov    %rax,0x190(%rsp)
   d60c5:	mov    0x388(%rsp),%rax
   d60cd:	mov    %rax,0x1d0(%rsp)
   d60d5:	mov    0x1c0(%rsp),%rax
   d60dd:	mov    %rax,0x1c8(%rsp)
   d60e5:	mov    0x48(%rsp),%rax
   d60ea:	mov    %rax,0x1e8(%rsp)
   d60f2:	mov    %r13,0x1e0(%rsp)
   d60fa:	mov    0xb8(%rsp),%rax
   d6102:	mov    %rax,0x1d8(%rsp)
   d610a:	movabs $0x8000000000000000,%r13
   d6114:	mov    %r13,0x28(%rsp)
   d6119:	mov    %rbx,%r12
   d611c:	jmp    d448a <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x359a>
   d6121:	mov    0x2f8(%rsp),%r14
   d6129:	mov    0x300(%rsp),%r15
   d6131:	mov    0x308(%rsp),%rbx
   d6139:	cmp    %r13,%r14
   d613c:	je     d61ec <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x52fc>
   d6142:	mov    %r14,0x6e0(%rsp)
   d614a:	mov    %r15,0x6e8(%rsp)
   d6152:	mov    %rbx,0x6f0(%rsp)
   d615a:	mov    0x498(%rsp),%rax
   d6162:	cmp    0x488(%rsp),%rax
   d616a:	je     d61ec <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x52fc>
   d6170:	lea    0x794dc1(%rip),%rsi        # 86af38 <aws_lc_0_37_1_kem_asn1_meth+0x3e38>
   d6177:	lea    0x797822(%rip),%rdx        # 86d9a0 <aws_lc_0_37_1_kem_asn1_meth+0x68a0>
   d617e:	mov    0x5b8(%rsp),%rdi
   d6186:	call   4e160 <serde_core::de::Error::invalid_length>
   d618b:	mov    %rax,%r15
   d618e:	lea    0x6e0(%rsp),%rdi
   d6196:	call   136520 <core::ptr::drop_in_place<alloc::vec::Vec<polymarket_client_sdk::clob::types::response::PostOrderResponse>>.4821>
   d619b:	movabs $0x8000000000000000,%r13
   d61a5:	jmp    d61e9 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x52f9>
   d61a7:	mov    0x300(%rsp),%r14
   d61af:	mov    0x308(%rsp),%rbx
   d61b7:	mov    %r14,%r12
   d61ba:	sub    $0x1,%rbx
   d61be:	jb     d61d5 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x52e5>
   d61c0:	mov    %r12,%rdi
   d61c3:	call   136580 <core::ptr::drop_in_place<polymarket_client_sdk::clob::types::response::PostOrderResponse>>
   d61c8:	add    $0xa0,%r12
   d61cf:	sub    $0x1,%rbx
   d61d3:	jae    d61c0 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x52d0>
   d61d5:	cmpq   $0x0,0x2f8(%rsp)
   d61de:	je     d61e9 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x52f9>
   d61e0:	mov    %r14,%rdi
   d61e3:	call   *0x7b3977(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d61e9:	mov    %r13,%r14
   d61ec:	lea    0x480(%rsp),%rdi
   d61f4:	call   153080 <<alloc::vec::into_iter::IntoIter<T,A> as core::ops::drop::Drop>::drop>
   d61f9:	cmpb   $0x4,0x400(%rsp)
   d6201:	je     d6210 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5320>
   d6203:	lea    0x400(%rsp),%rdi
   d620b:	call   6b6c0 <core::ptr::drop_in_place<serde_json::value::Value>>
   d6210:	cmp    %r13,%r14
   d6213:	je     d6222 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5332>
   d6215:	lea    0x1(%r13),%rax
   d6219:	cmp    %rax,%r14
   d621c:	jne    d62da <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x53ea>
   d6222:	lea    0x5e8(%rsp),%rdi
   d622a:	mov    %r15,%rsi
   d622d:	call   29d800 <<polymarket_client_sdk::error::Error as core::convert::From<serde_json::error::Error>>::from>
   d6232:	mov    0x5e8(%rsp),%rax
   d623a:	movups 0x5f0(%rsp),%xmm0
   d6242:	movaps %xmm0,0x420(%rsp)
   d624a:	mov    0x600(%rsp),%rcx
   d6252:	mov    %rcx,0x430(%rsp)
   d625a:	cmp    $0x3,%rax
   d625e:	je     d631a <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x542a>
   d6264:	mov    0x628(%rsp),%rcx
   d626c:	mov    %rcx,0x360(%rsp)
   d6274:	movups 0x608(%rsp),%xmm0
   d627c:	movups 0x618(%rsp),%xmm1
   d6284:	movaps %xmm1,0x350(%rsp)
   d628c:	movaps %xmm0,0x340(%rsp)
   d6294:	movaps 0x420(%rsp),%xmm0
   d629c:	movups %xmm0,0x328(%rsp)
   d62a4:	mov    0x430(%rsp),%rcx
   d62ac:	mov    %rcx,0x338(%rsp)
   d62b4:	mov    %rax,0x320(%rsp)
   d62bc:	mov    0x8(%rsp),%rbx
   d62c1:	movb   $0x0,0x4e6(%rbx)
   d62c8:	cmpb   $0x0,0x4e3(%rbx)
   d62cf:	jne    d3e08 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2f18>
   d62d5:	jmp    d3e1f <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2f2f>
   d62da:	mov    %r14,0x5f0(%rsp)
   d62e2:	mov    %r15,0x5f8(%rsp)
   d62ea:	mov    %rbx,0x600(%rsp)
   d62f2:	mov    %rbx,0x430(%rsp)
   d62fa:	mov    0x5f0(%rsp),%rax
   d6302:	mov    %rax,0x420(%rsp)
   d630a:	mov    0x5f8(%rsp),%rax
   d6312:	mov    %rax,0x428(%rsp)
   d631a:	mov    0x420(%rsp),%rax
   d6322:	mov    %rax,0x520(%rsp)
   d632a:	mov    0x428(%rsp),%rax
   d6332:	mov    %rax,0x528(%rsp)
   d633a:	mov    0x430(%rsp),%rax
   d6342:	mov    %rax,0x530(%rsp)
   d634a:	cmp    %r13,0x520(%rsp)
   d6352:	jne    d641d <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x552d>
   d6358:	mov    0x8(%rsp),%rcx
   d635d:	movb   $0x0,0x4e4(%rcx)
   d6364:	mov    0x438(%rcx),%rax
   d636b:	mov    %rax,0xd0(%rsp)
   d6373:	movups 0x428(%rcx),%xmm0
   d637a:	movaps %xmm0,0xc0(%rsp)
   d6382:	movb   $0x0,0x4e3(%rcx)
   d6389:	mov    0x450(%rcx),%rax
   d6390:	mov    %rax,0x210(%rsp)
   d6398:	movups 0x440(%rcx),%xmm0
   d639f:	movaps %xmm0,0x200(%rsp)
   d63a7:	lea    0x604706(%rip),%rcx        # 6daab4 <encoding_rs::data::KSX1001_LOWERCASE+0x10cd4>
   d63ae:	lea    0x6e0(%rsp),%rdi
   d63b6:	lea    0xc0(%rsp),%rsi
   d63be:	lea    0x200(%rsp),%rdx
   d63c6:	call   66a40 <polymarket_client_sdk::error::Error::status>
   d63cb:	movups 0x6e0(%rsp),%xmm0
   d63d3:	movups 0x6f0(%rsp),%xmm1
   d63db:	movups 0x700(%rsp),%xmm2
   d63e3:	movups 0x710(%rsp),%xmm3
   d63eb:	movaps %xmm0,0x320(%rsp)
   d63f3:	movaps %xmm1,0x330(%rsp)
   d63fb:	movaps %xmm2,0x340(%rsp)
   d6403:	movaps %xmm3,0x350(%rsp)
   d640b:	mov    0x720(%rsp),%rax
   d6413:	mov    %rax,0x360(%rsp)
   d641b:	jmp    d6459 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5569>
   d641d:	mov    0x530(%rsp),%rax
   d6425:	mov    %rax,0x338(%rsp)
   d642d:	mov    0x520(%rsp),%rax
   d6435:	mov    %rax,0x328(%rsp)
   d643d:	mov    0x528(%rsp),%rax
   d6445:	mov    %rax,0x330(%rsp)
   d644d:	movq   $0x3,0x320(%rsp)
   d6459:	mov    0x8(%rsp),%rbx
   d645e:	movb   $0x0,0x4e6(%rbx)
   d6465:	cmpb   $0x0,0x4e3(%rbx)
   d646c:	je     d6485 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5595>
   d646e:	cmpq   $0x0,0x440(%rbx)
   d6476:	je     d6485 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5595>
   d6478:	mov    0x448(%rbx),%rdi
   d647f:	call   *0x7b36db(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d6485:	movb   $0x0,0x4e3(%rbx)
   d648c:	cmpb   $0x0,0x4e4(%rbx)
   d6493:	je     d64b5 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x55c5>
   d6495:	cmpb   $0xa,0x428(%rbx)
   d649c:	jb     d64b5 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x55c5>
   d649e:	cmpq   $0x0,0x438(%rbx)
   d64a6:	je     d64b5 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x55c5>
   d64a8:	mov    0x430(%rbx),%rdi
   d64af:	call   *0x7b36ab(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d64b5:	movb   $0x0,0x4e4(%rbx)
   d64bc:	cmpl   $0x3,0x3c8(%rbx)
   d64c3:	je     d3e74 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2f84>
   d64c9:	cmpb   $0x0,0x4e5(%rbx)
   d64d0:	jne    d3e68 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2f78>
   d64d6:	jmp    d3e74 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x2f84>
   d64db:	mov    %rax,0x4a0(%rsp)
   d64e3:	mov    %bl,0x4a8(%rsp)
   d64ea:	movaps 0xc0(%rsp),%xmm0
   d64f2:	movaps 0xd0(%rsp),%xmm1
   d64fa:	movups %xmm0,0x4a9(%rsp)
   d6502:	movups %xmm1,0x4b9(%rsp)
   d650a:	mov    0xdf(%rsp),%rax
   d6512:	mov    %rax,0x4c8(%rsp)
   d651a:	mov    %r14,0x4d0(%rsp)
   d6522:	lea    0x7a136f(%rip),%rax        # 877898 <bytes::bytes::PROMOTABLE_ODD_VTABLE+0x28b0>
   d6529:	mov    %rax,0x4d8(%rsp)
   d6531:	movb   $0x1,0x4e0(%rsp)
   d6539:	lea    0x4a0(%rsp),%rdi
   d6541:	call   4e250 <<serde_json::error::Error as serde_core::de::Error>::custom>
   d6546:	mov    %rax,%r14
   d6549:	cmpq   $0x0,0x320(%rsp)
   d6552:	jne    d32a7 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x23b7>
   d6558:	jmp    d32b5 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x23c5>
   d655d:	lea    0x66f699(%rip),%rdi        # 745bfd <serde_json::value::index::<impl core::ops::index::Index<I> for serde_json::value::Value>::index::NULL+0x44bd>
   d6564:	lea    0x79762d(%rip),%rcx        # 86db98 <aws_lc_0_37_1_kem_asn1_meth+0x6a98>
   d656b:	lea    0x7b0216(%rip),%r8        # 886788 <bytes::bytes_mut::SHARED_VTABLE+0x308>
   d6572:	lea    0x1e(%rsp),%rdx
   d6577:	mov    $0x37,%esi
   d657c:	call   4fba0 <core::result::unwrap_failed>
   d6581:	jmp    d668f <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x579f>
   d6586:	mov    $0x8,%edi
   d658b:	mov    $0x18,%esi
   d6590:	call   4a4ec <alloc::alloc::handle_alloc_error>
   d6595:	jmp    d668f <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x579f>
   d659a:	xor    %edi,%edi
   d659c:	jmp    d65a3 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x56b3>
   d659e:	mov    $0x1,%edi
   d65a3:	lea    0x7b18ce(%rip),%rdx        # 887e78 <bytes::bytes_mut::SHARED_VTABLE+0x19f8>
   d65aa:	mov    %r15,%rsi
   d65ad:	call   4a4d6 <alloc::raw_vec::handle_error>
   d65b2:	jmp    d668f <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x579f>
   d65b7:	lea    0x7a6dca(%rip),%r8        # 87d388 <bytes::bytes::PROMOTABLE_ODD_VTABLE+0x83a0>
   d65be:	lea    0x66f8d2(%rip),%rdi        # 745e97 <serde_json::value::index::<impl core::ops::index::Index<I> for serde_json::value::Value>::index::NULL+0x4757>
   d65c5:	lea    0x7b02b4(%rip),%rcx        # 886880 <bytes::bytes_mut::SHARED_VTABLE+0x400>
   d65cc:	lea    0x1e(%rsp),%rdx
   d65d1:	mov    $0x17,%esi
   d65d6:	call   4fba0 <core::result::unwrap_failed>
   d65db:	jmp    d668f <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x579f>
   d65e0:	lea    0x790c11(%rip),%rdx        # 8671f8 <aws_lc_0_37_1_kem_asn1_meth+0xf8>
   d65e7:	lea    0x440(%rsp),%rdi
   d65ef:	lea    0x1e(%rsp),%rsi
   d65f4:	call   4a2c0 <serde_json::value::de::<impl serde_json::value::Value>::invalid_type>
   d65f9:	mov    %rax,%r15
   d65fc:	mov    %r13,%r14
   d65ff:	jmp    d6203 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5313>
   d6604:	mov    $0x1,%edx
   d6609:	mov    $0x1,%ecx
   d660e:	mov    $0x1,%r8d
   d6614:	mov    %r14,%rdi
   d6617:	call   4df30 <alloc::raw_vec::RawVecInner<A>::reserve::do_reserve_and_handle>
   d661c:	mov    0x10(%r14),%rsi
   d6620:	jmp    d41e7 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x32f7>
   d6625:	lea    0x7917e4(%rip),%rdi        # 867e10 <aws_lc_0_37_1_kem_asn1_meth+0xd10>
   d662c:	call   4ffe0 <core::panicking::panic_const::panic_const_async_fn_resumed>
   d6631:	lea    0x7917d8(%rip),%rdi        # 867e10 <aws_lc_0_37_1_kem_asn1_meth+0xd10>
   d6638:	call   50020 <core::panicking::panic_const::panic_const_async_fn_resumed_panic>
   d663d:	lea    0x794a0c(%rip),%rdx        # 86b050 <aws_lc_0_37_1_kem_asn1_meth+0x3f50>
   d6644:	mov    $0x1,%edi
   d6649:	mov    $0x80,%esi
   d664e:	call   4a4d6 <alloc::raw_vec::handle_error>
   d6653:	jmp    d668f <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x579f>
   d6655:	lea    0x7935bc(%rip),%rdi        # 869c18 <aws_lc_0_37_1_kem_asn1_meth+0x2b18>
   d665c:	call   50020 <core::panicking::panic_const::panic_const_async_fn_resumed_panic>
   d6661:	jmp    d668f <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x579f>
   d6663:	lea    0x7935ae(%rip),%rdi        # 869c18 <aws_lc_0_37_1_kem_asn1_meth+0x2b18>
   d666a:	call   4ffe0 <core::panicking::panic_const::panic_const_async_fn_resumed>
   d666f:	jmp    d668f <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x579f>
   d6671:	lea    0x7a6bf0(%rip),%r8        # 87d268 <bytes::bytes::PROMOTABLE_ODD_VTABLE+0x8280>
   d6678:	jmp    d65be <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x56ce>
   d667d:	lea    0x7a6d34(%rip),%rax        # 87d3b8 <bytes::bytes::PROMOTABLE_ODD_VTABLE+0x83d0>
   d6684:	mov    %rdx,%rdi
   d6687:	mov    %rax,%rdx
   d668a:	call   4f6d1 <core::panicking::panic_bounds_check>
   d668f:	ud2
   d6691:	mov    %rax,(%rsp)
   d6695:	lea    0x6e0(%rsp),%rdi
   d669d:	call   136520 <core::ptr::drop_in_place<alloc::vec::Vec<polymarket_client_sdk::clob::types::response::PostOrderResponse>>.4821>
   d66a2:	jmp    d6c6d <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5d7d>
   d66a7:	mov    %rax,(%rsp)
   d66ab:	lea    0x6e0(%rsp),%rdi
   d66b3:	call   136580 <core::ptr::drop_in_place<polymarket_client_sdk::clob::types::response::PostOrderResponse>>
   d66b8:	jmp    d6960 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5a70>
   d66bd:	mov    %rax,(%rsp)
   d66c1:	cmpq   $0x0,0xb0(%rsp)
   d66ca:	je     d66e0 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x57f0>
   d66cc:	mov    0x128(%rsp),%rdi
   d66d4:	call   *0x7b3486(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d66da:	jmp    d66e0 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x57f0>
   d66dc:	mov    %rax,(%rsp)
   d66e0:	movabs $0x8000000000000005,%rax
   d66ea:	cmp    %rax,0x48(%rsp)
   d66ef:	jl     d671e <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x582e>
   d66f1:	cmpq   $0x0,0x48(%rsp)
   d66f7:	je     d671e <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x582e>
   d66f9:	mov    %r13,%rdi
   d66fc:	call   *0x7b345e(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d6702:	jmp    d671e <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x582e>
   d6704:	mov    %rax,(%rsp)
   d6708:	lea    0x6e0(%rsp),%rdi
   d6710:	call   136580 <core::ptr::drop_in_place<polymarket_client_sdk::clob::types::response::PostOrderResponse>>
   d6715:	jmp    d6c08 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5d18>
   d671a:	mov    %rax,(%rsp)
   d671e:	cmpq   $0x0,0x28(%rsp)
   d6724:	je     d6892 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x59a2>
   d672a:	mov    %r15,%rdi
   d672d:	call   *0x7b342d(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d6733:	jmp    d6892 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x59a2>
   d6738:	mov    %rax,(%rsp)
   d673c:	lea    0x60(%rsp),%rdi
   d6741:	call   6b6c0 <core::ptr::drop_in_place<serde_json::value::Value>>
   d6746:	jmp    d6abf <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5bcf>
   d674b:	call   4fdd5 <core::panicking::panic_in_cleanup>
   d6750:	mov    %r12,0x10(%rsp)
   d6755:	mov    %rax,(%rsp)
   d6759:	jmp    d6abf <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5bcf>
   d675e:	mov    %r12,0x10(%rsp)
   d6763:	mov    %ebx,%r15d
   d6766:	mov    %rax,(%rsp)
   d676a:	movabs $0x8000000000000005,%rax
   d6774:	cmp    %rax,0x98(%rsp)
   d677c:	jl     d67df <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x58ef>
   d677e:	cmpq   $0x0,0x98(%rsp)
   d6787:	je     d67df <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x58ef>
   d6789:	mov    0x48(%rsp),%rdi
   d678e:	call   *0x7b33cc(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d6794:	jmp    d67df <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x58ef>
   d6796:	mov    %rax,(%rsp)
   d679a:	mov    $0x1,%bl
   d679c:	cmpb   $0x6,0x108(%rsp)
   d67a4:	je     d6c17 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5d27>
   d67aa:	lea    0x108(%rsp),%rdi
   d67b2:	call   136cd0 <core::ptr::drop_in_place<serde_json::value::Value>.4830>
   d67b7:	jmp    d6c17 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5d27>
   d67bc:	call   4fdd5 <core::panicking::panic_in_cleanup>
   d67c1:	jmp    d6a80 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5b90>
   d67c6:	mov    %r12,0x10(%rsp)
   d67cb:	mov    %rbp,0xa8(%rsp)
   d67d3:	mov    %rax,(%rsp)
   d67d7:	mov    $0x1,%r15b
   d67da:	mov    %rbx,0x40(%rsp)
   d67df:	cmpq   $0x0,0x28(%rsp)
   d67e5:	jne    d67f4 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5904>
   d67e7:	movq   $0x0,0x28(%rsp)
   d67f0:	xor    %ebx,%ebx
   d67f2:	jmp    d6867 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5977>
   d67f4:	mov    0x38(%rsp),%rdi
   d67f9:	call   *0x7b3361(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d67ff:	xor    %ebx,%ebx
   d6801:	jmp    d6867 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5977>
   d6803:	mov    %rax,%r15
   d6806:	cmpq   $0x0,0x8(%rbx)
   d680b:	je     d68d5 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x59e5>
   d6811:	mov    %r14,%rdi
   d6814:	call   *0x7b3346(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d681a:	jmp    d68d5 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x59e5>
   d681f:	mov    %rax,(%rsp)
   d6823:	jmp    d6abf <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5bcf>
   d6828:	mov    %rax,(%rsp)
   d682c:	lea    0x520(%rsp),%rdi
   d6834:	call   d9210 <core::ptr::drop_in_place<core::option::Option<alloc::vec::Vec<polymarket_client_sdk::clob::types::response::PostOrderResponse>>>.3913>
   d6839:	jmp    d6cc6 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5dd6>
   d683e:	mov    %rax,(%rsp)
   d6842:	jmp    d6c6d <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5d7d>
   d6847:	jmp    d6d4b <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5e5b>
   d684c:	mov    %r12,0x10(%rsp)
   d6851:	mov    %rbp,0xa8(%rsp)
   d6859:	mov    %rax,(%rsp)
   d685d:	mov    $0x1,%r15b
   d6860:	mov    %rbx,0x28(%rsp)
   d6865:	mov    $0x1,%bl
   d6867:	mov    0xa8(%rsp),%rax
   d686f:	shl    $1,%rax
   d6872:	test   %rax,%rax
   d6875:	je     d6b6a <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5c7a>
   d687b:	mov    0x1f8(%rsp),%rdi
   d6883:	call   *0x7b32d7(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d6889:	jmp    d6b6a <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5c7a>
   d688e:	mov    %rax,(%rsp)
   d6892:	shl    $1,%rbx
   d6895:	test   %rbx,%rbx
   d6898:	je     d6960 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5a70>
   d689e:	mov    0x1c0(%rsp),%rdi
   d68a6:	call   *0x7b32b4(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d68ac:	jmp    d6960 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5a70>
   d68b1:	mov    %rax,(%rsp)
   d68b5:	jmp    d6c7a <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5d8a>
   d68ba:	mov    %rax,%r14
   d68bd:	jmp    d6de4 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5ef4>
   d68c2:	mov    %rax,%rbx
   d68c5:	movb   $0x0,0x8e0(%r14)
   d68cd:	jmp    d6e79 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5f89>
   d68d2:	mov    %rax,%r15
   d68d5:	lea    0x6e8(%rsp),%rax
   d68dd:	movq   $0x1,0x6e0(%rsp)
   d68e9:	movaps 0x4a0(%rsp),%xmm0
   d68f1:	movaps 0x4b0(%rsp),%xmm1
   d68f9:	movups %xmm1,0x10(%rax)
   d68fd:	movups %xmm0,(%rax)
   d6900:	jmp    d6ee5 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5ff5>
   d6905:	jmp    d698d <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5a9d>
   d690a:	mov    %rax,%r14
   d690d:	jmp    d6e1a <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5f2a>
   d6912:	jmp    d698d <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5a9d>
   d6914:	mov    %rax,(%rsp)
   d6918:	mov    $0x1,%bl
   d691a:	cmpb   $0x6,0x108(%rsp)
   d6922:	je     d6c17 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5d27>
   d6928:	lea    0x108(%rsp),%rdi
   d6930:	call   136cd0 <core::ptr::drop_in_place<serde_json::value::Value>.4830>
   d6935:	jmp    d6c17 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5d27>
   d693a:	call   4fdd5 <core::panicking::panic_in_cleanup>
   d693f:	jmp    d6ac7 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5bd7>
   d6944:	mov    %rax,(%rsp)
   d6948:	lea    0x200(%rsp),%rdi
   d6950:	call   15a830 <core::ptr::drop_in_place<polymarket_client_sdk::clob::types::response::PostOrderResponse>.5294>
   d6955:	jmp    d6c60 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5d70>
   d695a:	jmp    d698d <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5a9d>
   d695c:	mov    %rax,(%rsp)
   d6960:	lea    0xc0(%rsp),%rdi
   d6968:	call   153080 <<alloc::vec::into_iter::IntoIter<T,A> as core::ops::drop::Drop>::drop>
   d696d:	mov    $0x1,%r14b
   d6970:	xor    %ebx,%ebx
   d6972:	jmp    d6c1a <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5d2a>
   d6977:	call   4fdd5 <core::panicking::panic_in_cleanup>
   d697c:	mov    %rax,(%rsp)
   d6980:	jmp    d6c60 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5d70>
   d6985:	mov    %rax,%rbx
   d6988:	jmp    d6e79 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5f89>
   d698d:	mov    %rax,(%rsp)
   d6991:	jmp    d6cc6 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5dd6>
   d6996:	mov    %rax,%r14
   d6999:	jmp    d6e56 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5f66>
   d699e:	mov    %rax,%r15
   d69a1:	movq   $0x2,0x6e0(%rsp)
   d69ad:	mov    %r14,0x6e8(%rsp)
   d69b5:	jmp    d6ee5 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5ff5>
   d69ba:	mov    %rax,(%rsp)
   d69be:	movaps 0x730(%rsp),%xmm0
   d69c6:	movups %xmm0,0x50(%r15)
   d69cb:	movaps 0x720(%rsp),%xmm0
   d69d3:	movups %xmm0,0x40(%r15)
   d69d8:	movaps 0x6e0(%rsp),%xmm0
   d69e0:	movaps 0x6f0(%rsp),%xmm1
   d69e8:	movaps 0x700(%rsp),%xmm2
   d69f0:	movaps 0x710(%rsp),%xmm3
   d69f8:	movups %xmm3,0x30(%r15)
   d69fd:	movups %xmm2,0x20(%r15)
   d6a02:	movups %xmm1,0x10(%r15)
   d6a07:	movups %xmm0,(%r15)
   d6a0b:	jmp    d6cf4 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5e04>
   d6a10:	mov    %rax,(%rsp)
   d6a14:	jmp    d6c1a <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5d2a>
   d6a19:	mov    %rax,(%rsp)
   d6a1d:	mov    %r15,%rdi
   d6a20:	call   81cc0 <core::ptr::drop_in_place<reqwest::async_impl::response::Response::text::{{closure}}>.3727>
   d6a25:	jmp    d6cc6 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5dd6>
   d6a2a:	mov    %rax,(%rsp)
   d6a2e:	mov    %r15,%rdi
   d6a31:	call   824f0 <core::ptr::drop_in_place<reqwest::async_impl::response::Response::json<serde_json::value::Value>::{{closure}}>>
   d6a36:	jmp    d6cc6 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5dd6>
   d6a3b:	jmp    d6af2 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5c02>
   d6a40:	jmp    d6af2 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5c02>
   d6a45:	jmp    d6af2 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5c02>
   d6a4a:	mov    %rax,%r14
   d6a4d:	jmp    d6e49 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5f59>
   d6a52:	mov    %rax,(%rsp)
   d6a56:	jmp    d6cec <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5dfc>
   d6a5b:	mov    %rax,(%rsp)
   d6a5f:	jmp    d6ce7 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5df7>
   d6a64:	mov    %rax,%r15
   d6a67:	lea    0x7a0e2a(%rip),%rsi        # 877898 <bytes::bytes::PROMOTABLE_ODD_VTABLE+0x28b0>
   d6a6e:	mov    %r14,%rdi
   d6a71:	call   41f980 <core::ptr::drop_in_place<core::option::Option<alloc::boxed::Box<dyn rustls::crypto::ActiveKeyExchange>>>>
   d6a76:	jmp    d6ecc <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5fdc>
   d6a7b:	call   4fdd5 <core::panicking::panic_in_cleanup>
   d6a80:	mov    %rax,%r15
   d6a83:	jmp    d6ecc <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5fdc>
   d6a88:	mov    %r12,0x10(%rsp)
   d6a8d:	mov    %rax,(%rsp)
   d6a91:	movaps 0x60(%rsp),%xmm0
   d6a96:	movaps 0x70(%rsp),%xmm1
   d6a9b:	lea    0x108(%rsp),%rax
   d6aa3:	movups %xmm1,0x10(%rax)
   d6aa7:	movups %xmm0,(%rax)
   d6aaa:	mov    $0x1,%r15b
   d6aad:	test   %rbp,%rbp
   d6ab0:	je     d6b65 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5c75>
   d6ab6:	mov    %r14,%rdi
   d6ab9:	call   *0x7b30a1(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d6abf:	mov    $0x1,%r15b
   d6ac2:	jmp    d6b65 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5c75>
   d6ac7:	mov    %rax,%r15
   d6aca:	jmp    d6ee5 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5ff5>
   d6acf:	mov    %rax,(%rsp)
   d6ad3:	mov    0x8(%rsp),%r13
   d6ad8:	mov    0x4e8(%r13),%rdi
   d6adf:	mov    0x4f0(%r13),%rsi
   d6ae6:	call   b1070 <core::ptr::drop_in_place<reqwest::async_impl::client::Pending>.3797>
   d6aeb:	jmp    d6cec <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5dfc>
   d6af0:	jmp    d6af2 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5c02>
   d6af2:	mov    %rax,%r15
   d6af5:	jmp    d6f0d <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x601d>
   d6afa:	jmp    d6eb0 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5fc0>
   d6aff:	mov    %rax,%rbx
   d6b02:	mov    %r13,%rdi
   d6b05:	call   d70e0 <core::ptr::drop_in_place<polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<polymarket_client_sdk::auth::Normal>>::create_headers::{{closure}}>.3908>
   d6b0a:	jmp    d6e79 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5f89>
   d6b0f:	mov    %rax,(%rsp)
   d6b13:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   d6b20:	dec    %rbp
   d6b23:	je     d6b37 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5c47>
   d6b25:	lea    0x20(%r12),%rbx
   d6b2a:	mov    %r12,%rdi
   d6b2d:	call   136cd0 <core::ptr::drop_in_place<serde_json::value::Value>.4830>
   d6b32:	mov    %rbx,%r12
   d6b35:	jmp    d6b20 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5c30>
   d6b37:	cmpq   $0x0,0x2a8(%rsp)
   d6b40:	je     d6c60 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5d70>
   d6b46:	mov    %r14,%rdi
   d6b49:	call   *0x7b3011(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d6b4f:	jmp    d6c60 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5d70>
   d6b54:	call   4fdd5 <core::panicking::panic_in_cleanup>
   d6b59:	mov    %rax,(%rsp)
   d6b5d:	mov    $0x1,%r15b
   d6b60:	mov    %r14,0x10(%rsp)
   d6b65:	mov    $0x1,%bl
   d6b67:	mov    $0x1,%r14b
   d6b6a:	movabs $0x8000000000000000,%rax
   d6b74:	cmp    %rax,0x370(%rsp)
   d6b7c:	je     d6b8b <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5c9b>
   d6b7e:	lea    0x370(%rsp),%rdi
   d6b86:	call   1360b0 <core::ptr::drop_in_place<alloc::vec::Vec<alloc::string::String>>.4801>
   d6b8b:	mov    0x58(%rsp),%rax
   d6b90:	shl    $1,%rax
   d6b93:	test   %rax,%rax
   d6b96:	je     d6ba6 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5cb6>
   d6b98:	mov    0xb8(%rsp),%rdi
   d6ba0:	call   *0x7b2fba(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d6ba6:	test   %r15b,%r15b
   d6ba9:	je     d6bc0 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5cd0>
   d6bab:	movabs $0x8000000000000006,%rax
   d6bb5:	cmp    %rax,0x40(%rsp)
   d6bba:	jge    d6c9d <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5dad>
   d6bc0:	test   %bl,%bl
   d6bc2:	je     d6bdc <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5cec>
   d6bc4:	mov    0x28(%rsp),%rax
   d6bc9:	shl    $1,%rax
   d6bcc:	test   %rax,%rax
   d6bcf:	je     d6bdc <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5cec>
   d6bd1:	mov    0x38(%rsp),%rdi
   d6bd6:	call   *0x7b2f84(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d6bdc:	test   %r14b,%r14b
   d6bdf:	je     d6c08 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5d18>
   d6be1:	movabs $0x8000000000000002,%rax
   d6beb:	cmp    %rax,0x10(%rsp)
   d6bf0:	jl     d6c08 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5d18>
   d6bf2:	cmpq   $0x0,0x10(%rsp)
   d6bf8:	je     d6c08 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5d18>
   d6bfa:	mov    0x88(%rsp),%rdi
   d6c02:	call   *0x7b2f58(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d6c08:	lea    0xc0(%rsp),%rdi
   d6c10:	call   136e00 <core::ptr::drop_in_place<serde_json::value::de::MapDeserializer>>
   d6c15:	mov    $0x1,%bl
   d6c17:	xor    %r14d,%r14d
   d6c1a:	movzbl 0x2a0(%rsp),%eax
   d6c22:	cmp    $0x4,%eax
   d6c25:	je     d6c40 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5d50>
   d6c27:	cmp    $0x5,%eax
   d6c2a:	jne    d6c53 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5d63>
   d6c2c:	test   %r14b,%r14b
   d6c2f:	je     d6c60 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5d70>
   d6c31:	lea    0x2a8(%rsp),%rdi
   d6c39:	call   13a8b0 <<alloc::collections::btree::map::BTreeMap<K,V,A> as core::ops::drop::Drop>::drop>
   d6c3e:	jmp    d6c60 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5d70>
   d6c40:	test   %bl,%bl
   d6c42:	je     d6c60 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5d70>
   d6c44:	lea    0x2a8(%rsp),%rdi
   d6c4c:	call   1b1ad0 <core::ptr::drop_in_place<serde_json::value::ser::SerializeVec>>
   d6c51:	jmp    d6c60 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5d70>
   d6c53:	lea    0x2a0(%rsp),%rdi
   d6c5b:	call   6b6c0 <core::ptr::drop_in_place<serde_json::value::Value>>
   d6c60:	lea    0x2f8(%rsp),%rdi
   d6c68:	call   d7080 <core::ptr::drop_in_place<alloc::vec::Vec<polymarket_client_sdk::clob::types::response::PostOrderResponse>>.3907>
   d6c6d:	lea    0x480(%rsp),%rdi
   d6c75:	call   153080 <<alloc::vec::into_iter::IntoIter<T,A> as core::ops::drop::Drop>::drop>
   d6c7a:	cmpb   $0x4,0x400(%rsp)
   d6c82:	jne    d6cb9 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5dc9>
   d6c84:	cmpb   $0x4,0x96(%rsp)
   d6c8c:	je     d6cc6 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5dd6>
   d6c8e:	lea    0x408(%rsp),%rdi
   d6c96:	call   1b1ad0 <core::ptr::drop_in_place<serde_json::value::ser::SerializeVec>>
   d6c9b:	jmp    d6cc6 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5dd6>
   d6c9d:	cmpq   $0x0,0x40(%rsp)
   d6ca3:	je     d6bc0 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5cd0>
   d6ca9:	mov    0x50(%rsp),%rdi
   d6cae:	call   *0x7b2eac(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d6cb4:	jmp    d6bc0 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5cd0>
   d6cb9:	lea    0x400(%rsp),%rdi
   d6cc1:	call   6b6c0 <core::ptr::drop_in_place<serde_json::value::Value>>
   d6cc6:	mov    0x8(%rsp),%rax
   d6ccb:	cmpb   $0x0,0x4e6(%rax)
   d6cd2:	je     d6ce7 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5df7>
   d6cd4:	mov    0x8(%rsp),%r13
   d6cd9:	lea    0x458(%r13),%rdi
   d6ce0:	call   827f0 <core::ptr::drop_in_place<reqwest::async_impl::response::Response>>
   d6ce5:	jmp    d6cec <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5dfc>
   d6ce7:	mov    0x8(%rsp),%r13
   d6cec:	movb   $0x0,0x4e6(%r13)
   d6cf4:	mov    0x8(%rsp),%rax
   d6cf9:	cmpb   $0x0,0x4e3(%rax)
   d6d00:	je     d6d11 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5e21>
   d6d02:	mov    0x8(%rsp),%rax
   d6d07:	cmpq   $0x0,0x440(%rax)
   d6d0f:	jne    d6d1a <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5e2a>
   d6d11:	mov    (%rsp),%r14
   d6d15:	jmp    d6da0 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5eb0>
   d6d1a:	mov    0x8(%rsp),%rax
   d6d1f:	mov    0x448(%rax),%rdi
   d6d26:	call   *0x7b2e34(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d6d2c:	mov    (%rsp),%r14
   d6d30:	jmp    d6da0 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5eb0>
   d6d32:	call   4fdd5 <core::panicking::panic_in_cleanup>
   d6d37:	call   4fdd5 <core::panicking::panic_in_cleanup>
   d6d3c:	call   4fdd5 <core::panicking::panic_in_cleanup>
   d6d41:	call   4fdd5 <core::panicking::panic_in_cleanup>
   d6d46:	call   4fdd5 <core::panicking::panic_in_cleanup>
   d6d4b:	mov    %rax,%r15
   d6d4e:	cmpq   $0x0,0x200(%rsp)
   d6d57:	je     d6ecc <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5fdc>
   d6d5d:	mov    0x208(%rsp),%rdi
   d6d65:	jmp    d6ec6 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5fd6>
   d6d6a:	mov    %rax,%r15
   d6d6d:	test   %rbx,%rbx
   d6d70:	je     d6ee5 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5ff5>
   d6d76:	mov    %r14,%rdi
   d6d79:	jmp    d6edf <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5fef>
   d6d7e:	mov    %rax,%r15
   d6d81:	cmpq   $0x0,0x540(%rsp)
   d6d8a:	je     d6ecc <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5fdc>
   d6d90:	mov    0x548(%rsp),%rdi
   d6d98:	jmp    d6ec6 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5fd6>
   d6d9d:	mov    %rax,%r14
   d6da0:	mov    0x8(%rsp),%rax
   d6da5:	movb   $0x0,0x4e3(%rax)
   d6dac:	cmpb   $0x0,0x4e4(%rax)
   d6db3:	je     d6de4 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5ef4>
   d6db5:	mov    0x8(%rsp),%rax
   d6dba:	cmpb   $0xa,0x428(%rax)
   d6dc1:	jb     d6de4 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5ef4>
   d6dc3:	mov    0x8(%rsp),%rax
   d6dc8:	cmpq   $0x0,0x438(%rax)
   d6dd0:	je     d6de4 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5ef4>
   d6dd2:	mov    0x8(%rsp),%rax
   d6dd7:	mov    0x430(%rax),%rdi
   d6dde:	call   *0x7b2d7c(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d6de4:	mov    0x8(%rsp),%rax
   d6de9:	movb   $0x0,0x4e4(%rax)
   d6df0:	cmpl   $0x3,0x3c8(%rax)
   d6df7:	je     d6e1a <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5f2a>
   d6df9:	mov    0x8(%rsp),%rax
   d6dfe:	cmpb   $0x1,0x4e5(%rax)
   d6e05:	jne    d6e1a <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5f2a>
   d6e07:	mov    0x8(%rsp),%rbx
   d6e0c:	lea    0x3c8(%rbx),%rdi
   d6e13:	call   6bbe0 <core::ptr::drop_in_place<http::header::map::HeaderMap>>
   d6e18:	jmp    d6e1f <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5f2f>
   d6e1a:	mov    0x8(%rsp),%rbx
   d6e1f:	movb   $0x0,0x4e5(%rbx)
   d6e26:	cmpb   $0x0,0x4e7(%rbx)
   d6e2d:	je     d6e3b <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5f4b>
   d6e2f:	lea    0x2c0(%rbx),%rdi
   d6e36:	call   6c260 <core::ptr::drop_in_place<reqwest::async_impl::request::Request>>
   d6e3b:	movb   $0x0,0x4e7(%rbx)
   d6e42:	movb   $0x2,0x4e2(%rbx)
   d6e49:	mov    0x1b0(%rsp),%rdi
   d6e51:	call   b0e30 <core::ptr::drop_in_place<polymarket_client_sdk::request<polymarket_client_sdk::clob::types::response::FeeRateResponse>::{{closure}}>>
   d6e56:	mov    0x8(%rsp),%rax
   d6e5b:	cmpb   $0x0,0x14a(%rax)
   d6e62:	je     d6e76 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5f86>
   d6e64:	lea    0x540(%rsp),%rdi
   d6e6c:	call   6bbe0 <core::ptr::drop_in_place<http::header::map::HeaderMap>>
   d6e71:	mov    %r14,%rbx
   d6e74:	jmp    d6e79 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5f89>
   d6e76:	mov    %r14,%rbx
   d6e79:	mov    0x8(%rsp),%rax
   d6e7e:	movb   $0x0,0x14a(%rax)
   d6e85:	cmpb   $0x0,0x149(%rax)
   d6e8c:	je     d6ea1 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5fb1>
   d6e8e:	mov    0x8(%rsp),%rax
   d6e93:	lea    0x40(%rax),%rdi
   d6e97:	call   6c260 <core::ptr::drop_in_place<reqwest::async_impl::request::Request>>
   d6e9c:	mov    %rbx,%r15
   d6e9f:	jmp    d6f0d <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x601d>
   d6ea1:	mov    %rbx,%r15
   d6ea4:	jmp    d6f0d <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x601d>
   d6ea6:	call   4fdd5 <core::panicking::panic_in_cleanup>
   d6eab:	call   4fdd5 <core::panicking::panic_in_cleanup>
   d6eb0:	mov    %rax,%r15
   d6eb3:	cmpq   $0x0,0xc0(%rsp)
   d6ebc:	je     d6ecc <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5fdc>
   d6ebe:	mov    0xc8(%rsp),%rdi
   d6ec6:	call   *0x7b2c94(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d6ecc:	cmpq   $0x0,0x320(%rsp)
   d6ed5:	je     d6ee5 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x5ff5>
   d6ed7:	mov    0x328(%rsp),%rdi
   d6edf:	call   *0x7b2c7b(%rip)        # 889b60 <free@GLIBC_2.2.5>
   d6ee5:	mov    0x7e8(%rsp),%rax
   d6eed:	lock decq (%rax)
   d6ef1:	jne    d6f00 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::post_orders::{{closure}}.3905+0x6010>
   d6ef3:	mov    0x7e8(%rsp),%rdi
   d6efb:	call   3b0cb0 <alloc::sync::Arc<T,A>::drop_slow>
   d6f00:	lea    0x6e0(%rsp),%rdi
   d6f08:	call   149580 <core::ptr::drop_in_place<core::result::Result<reqwest::async_impl::request::Request,reqwest::error::Error>>.5048>
   d6f0d:	mov    0x8(%rsp),%rbx
   d6f12:	movb   $0x0,0x149(%rbx)
   d6f19:	lea    0x28(%rbx),%rdi
   d6f1d:	call   6ce70 <core::ptr::drop_in_place<alloc::vec::Vec<polymarket_client_sdk::clob::types::SignedOrder>>>
   d6f22:	movb   $0x2,0x148(%rbx)
   d6f29:	mov    %r15,%rdi
   d6f2c:	call   4a180 <_Unwind_Resume@plt>
   d6f31:	call   4fdd5 <core::panicking::panic_in_cleanup>
   d6f36:	cs nopw 0x0(%rax,%rax,1)

00000000000d6f40 <<core::option::Option<T> as core::fmt::Debug>::fmt.3906>:
   d6f40:	push   %rbp
   d6f41:	push   %r15
   d6f43:	push   %r14
   d6f45:	push   %r13
   d6f47:	push   %r12
   d6f49:	push   %rbx
   d6f4a:	sub    $0x28,%rsp
   d6f4e:	mov    %rsi,%r15
   d6f51:	xor    %eax,%eax
   d6f53:	cmp    (%rdi),%rax
   d6f56:	jno    d6f7f <<core::option::Option<T> as core::fmt::Debug>::fmt.3906+0x3f>
   d6f58:	mov    (%r15),%rdi
   d6f5b:	mov    0x8(%r15),%rax
   d6f5f:	mov    0x18(%rax),%rax
   d6f63:	lea    0x5f6472(%rip),%rsi        # 6cd3dc <encoding_rs::data::KSX1001_LOWERCASE+0x35fc>
   d6f6a:	mov    $0x4,%edx
   d6f6f:	add    $0x28,%rsp
   d6f73:	pop    %rbx
   d6f74:	pop    %r12
   d6f76:	pop    %r13
   d6f78:	pop    %r14
   d6f7a:	pop    %r15
   d6f7c:	pop    %rbp
   d6f7d:	jmp    *%rax
   d6f7f:	mov    %rdi,%r13
   d6f82:	mov    (%r15),%rbx
   d6f85:	mov    0x8(%r15),%r14
   d6f89:	mov    0x18(%r14),%r12
   d6f8d:	lea    0x5f644c(%rip),%rsi        # 6cd3e0 <encoding_rs::data::KSX1001_LOWERCASE+0x3600>
   d6f94:	mov    $0x4,%edx
   d6f99:	mov    %rbx,%rdi
   d6f9c:	call   *%r12
   d6f9f:	mov    $0x1,%bpl
   d6fa2:	test   %al,%al
   d6fa4:	je     d6fb7 <<core::option::Option<T> as core::fmt::Debug>::fmt.3906+0x77>
   d6fa6:	mov    %ebp,%eax
   d6fa8:	add    $0x28,%rsp
   d6fac:	pop    %rbx
   d6fad:	pop    %r12
   d6faf:	pop    %r13
   d6fb1:	pop    %r14
   d6fb3:	pop    %r15
   d6fb5:	pop    %rbp
   d6fb6:	ret
   d6fb7:	testb  $0x80,0x12(%r15)
   d6fbc:	jne    d6fed <<core::option::Option<T> as core::fmt::Debug>::fmt.3906+0xad>
   d6fbe:	lea    0x668276(%rip),%rsi        # 73f23b <rustls::versions::TLS13+0x11>
   d6fc5:	mov    $0x1,%edx
   d6fca:	mov    %rbx,%rdi
   d6fcd:	call   *%r12
   d6fd0:	test   %al,%al
   d6fd2:	jne    d6fa6 <<core::option::Option<T> as core::fmt::Debug>::fmt.3906+0x66>
   d6fd4:	mov    0x8(%r13),%rdi
   d6fd8:	mov    0x10(%r13),%rsi
   d6fdc:	mov    %rbx,%rdx
   d6fdf:	mov    %r14,%rcx
   d6fe2:	call   2133a0 <<str as core::fmt::Debug>::fmt>
   d6fe7:	test   %al,%al
   d6fe9:	jne    d6fa6 <<core::option::Option<T> as core::fmt::Debug>::fmt.3906+0x66>
   d6feb:	jmp    d705b <<core::option::Option<T> as core::fmt::Debug>::fmt.3906+0x11b>
   d6fed:	lea    0x60db42(%rip),%rsi        # 6e4b36 <core::num::flt2dec::strategy::grisu::CACHED_POW10+0x916>
   d6ff4:	mov    $0x2,%edx
   d6ff9:	mov    %rbx,%rdi
   d6ffc:	call   *%r12
   d6fff:	test   %al,%al
   d7001:	jne    d6fa6 <<core::option::Option<T> as core::fmt::Debug>::fmt.3906+0x66>
   d7003:	movb   $0x1,0xf(%rsp)
   d7008:	mov    %rbx,0x10(%rsp)
   d700d:	mov    %r14,0x18(%rsp)
   d7012:	lea    0xf(%rsp),%rax
   d7017:	mov    %rax,0x20(%rsp)
   d701c:	mov    0x8(%r13),%rdi
   d7020:	mov    0x10(%r13),%rsi
   d7024:	lea    0x79a735(%rip),%rcx        # 871760 <chrono::format::strftime::T_FMT_AMPM::{{nested}}+0x2c70>
   d702b:	lea    0x10(%rsp),%rdx
   d7030:	call   2133a0 <<str as core::fmt::Debug>::fmt>
   d7035:	test   %al,%al
   d7037:	jne    d6fa6 <<core::option::Option<T> as core::fmt::Debug>::fmt.3906+0x66>
   d703d:	lea    0x66a6f2(%rip),%rsi        # 741736 <serde_json::ser::ESCAPE+0x164>
   d7044:	lea    0x10(%rsp),%rdi
   d7049:	mov    $0x2,%edx
   d704e:	call   20f850 <<core::fmt::builders::PadAdapter as core::fmt::Write>::write_str>
   d7053:	test   %al,%al
   d7055:	jne    d6fa6 <<core::option::Option<T> as core::fmt::Debug>::fmt.3906+0x66>
   d705b:	lea    0x671001(%rip),%rsi        # 748063 <utf8_iter::UTF8_DATA+0x823>
   d7062:	mov    $0x1,%edx
   d7067:	mov    %rbx,%rdi
   d706a:	call   *%r12
   d706d:	mov    %eax,%ebp
   d706f:	jmp    d6fa6 <<core::option::Option<T> as core::fmt::Debug>::fmt.3906+0x66>
   d7074:	cs nopw 0x0(%rax,%rax,1)
   d707e:	xchg   %ax,%ax
