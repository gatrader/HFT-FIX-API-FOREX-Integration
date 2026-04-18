
bot/bin/arbitrage_bot:     file format elf64-x86-64


Disassembly of section .text:

000000000029b250 <polymarket_client_sdk::auth::to_message>:
  29b250:	push   %rbp
  29b251:	push   %r15
  29b253:	push   %r14
  29b255:	push   %r13
  29b257:	push   %r12
  29b259:	push   %rbx
  29b25a:	sub    $0xa8,%rsp
  29b261:	mov    %rsi,%r14
  29b264:	mov    %rdi,%rbx
  29b267:	mov    %rdx,0x18(%rsp)
  29b26c:	lea    0xe0(%rsi),%rax
  29b273:	mov    %rax,0x20(%rsp)
  29b278:	mov    $0x1,%r12d
  29b27e:	cmpl   $0x1,(%rsi)
  29b281:	jne    29b2f6 <polymarket_client_sdk::auth::to_message+0xa6>
  29b283:	cmpq   $0x0,0x8(%r14)
  29b288:	je     29b2f6 <polymarket_client_sdk::auth::to_message+0xa6>
  29b28a:	mov    0x10(%r14),%rsi
  29b28e:	mov    0x18(%r14),%rdx
  29b292:	lea    0x28(%rsp),%rdi
  29b297:	call   77cc0 <alloc::string::String::from_utf8_lossy>
  29b29c:	mov    0x30(%rsp),%r15
  29b2a1:	mov    0x38(%rsp),%r13
  29b2a6:	test   %r13,%r13
  29b2a9:	js     29b550 <polymarket_client_sdk::auth::to_message+0x300>
  29b2af:	movabs $0x7fffffffffffffe0,%rbp
  29b2b9:	je     29b2fd <polymarket_client_sdk::auth::to_message+0xad>
  29b2bb:	movzbl 0x5ef9c6(%rip),%eax        # 88ac88 <__rust_no_alloc_shim_is_unstable>
  29b2c2:	mov    %r13,%rdi
  29b2c5:	call   *0x5ee945(%rip)        # 889c10 <malloc@GLIBC_2.2.5>
  29b2cb:	test   %rax,%rax
  29b2ce:	je     29b554 <polymarket_client_sdk::auth::to_message+0x304>
  29b2d4:	mov    %rax,%r12
  29b2d7:	cmp    $0x8,%r13
  29b2db:	setb   %al
  29b2de:	mov    %r12,%rcx
  29b2e1:	sub    %r15,%rcx
  29b2e4:	cmp    $0x20,%rcx
  29b2e8:	setb   %cl
  29b2eb:	or     %al,%cl
  29b2ed:	je     29b30b <polymarket_client_sdk::auth::to_message+0xbb>
  29b2ef:	xor    %eax,%eax
  29b2f1:	jmp    29b3e2 <polymarket_client_sdk::auth::to_message+0x192>
  29b2f6:	xor    %eax,%eax
  29b2f8:	jmp    29b465 <polymarket_client_sdk::auth::to_message+0x215>
  29b2fd:	mov    $0x1,%r12d
  29b303:	xor    %r13d,%r13d
  29b306:	jmp    29b439 <polymarket_client_sdk::auth::to_message+0x1e9>
  29b30b:	cmp    $0x20,%r13
  29b30f:	jae    29b315 <polymarket_client_sdk::auth::to_message+0xc5>
  29b311:	xor    %eax,%eax
  29b313:	jmp    29b392 <polymarket_client_sdk::auth::to_message+0x142>
  29b315:	mov    %r13,%rax
  29b318:	and    %rbp,%rax
  29b31b:	xor    %ecx,%ecx
  29b31d:	movdqa 0x42da0b(%rip),%xmm0        # 6c8d30 <_fini+0x1c24>
  29b325:	movdqa 0x42da13(%rip),%xmm1        # 6c8d40 <_fini+0x1c34>
  29b32d:	nopl   (%rax)
  29b330:	movdqu (%r15,%rcx,1),%xmm2
  29b336:	movdqu 0x10(%r15,%rcx,1),%xmm3
  29b33d:	movdqa %xmm2,%xmm4
  29b341:	pcmpeqb %xmm0,%xmm4
  29b345:	movdqa %xmm3,%xmm5
  29b349:	pcmpeqb %xmm0,%xmm5
  29b34d:	movdqa %xmm4,%xmm6
  29b351:	pandn  %xmm2,%xmm6
  29b355:	pand   %xmm1,%xmm4
  29b359:	por    %xmm6,%xmm4
  29b35d:	movdqa %xmm5,%xmm2
  29b361:	pandn  %xmm3,%xmm2
  29b365:	pand   %xmm1,%xmm5
  29b369:	por    %xmm2,%xmm5
  29b36d:	movdqu %xmm4,(%r12,%rcx,1)
  29b373:	movdqu %xmm5,0x10(%r12,%rcx,1)
  29b37a:	add    $0x20,%rcx
  29b37e:	cmp    %rcx,%rax
  29b381:	jne    29b330 <polymarket_client_sdk::auth::to_message+0xe0>
  29b383:	cmp    %rax,%r13
  29b386:	je     29b439 <polymarket_client_sdk::auth::to_message+0x1e9>
  29b38c:	test   $0x18,%r13b
  29b390:	je     29b3e2 <polymarket_client_sdk::auth::to_message+0x192>
  29b392:	mov    %rax,%rcx
  29b395:	lea    0x18(%rbp),%rax
  29b399:	and    %r13,%rax
  29b39c:	movdqa 0x42d9ac(%rip),%xmm0        # 6c8d50 <_fini+0x1c44>
  29b3a4:	movdqa 0x42d9b4(%rip),%xmm1        # 6c8d60 <_fini+0x1c54>
  29b3ac:	nopl   0x0(%rax)
  29b3b0:	movq   (%r15,%rcx,1),%xmm2
  29b3b6:	movdqa %xmm2,%xmm3
  29b3ba:	pcmpeqb %xmm0,%xmm3
  29b3be:	movdqa %xmm3,%xmm4
  29b3c2:	pandn  %xmm2,%xmm4
  29b3c6:	pand   %xmm1,%xmm3
  29b3ca:	por    %xmm4,%xmm3
  29b3ce:	movq   %xmm3,(%r12,%rcx,1)
  29b3d4:	add    $0x8,%rcx
  29b3d8:	cmp    %rcx,%rax
  29b3db:	jne    29b3b0 <polymarket_client_sdk::auth::to_message+0x160>
  29b3dd:	cmp    %rax,%r13
  29b3e0:	je     29b439 <polymarket_client_sdk::auth::to_message+0x1e9>
  29b3e2:	mov    %rax,%rcx
  29b3e5:	or     $0x1,%rcx
  29b3e9:	test   $0x1,%r13b
  29b3ed:	je     29b406 <polymarket_client_sdk::auth::to_message+0x1b6>
  29b3ef:	movzbl (%r15,%rax,1),%edx
  29b3f4:	cmp    $0x27,%dl
  29b3f7:	mov    $0x22,%esi
  29b3fc:	cmovne %edx,%esi
  29b3ff:	mov    %sil,(%r12,%rax,1)
  29b403:	mov    %rcx,%rax
  29b406:	cmp    %rcx,%r13
  29b409:	je     29b439 <polymarket_client_sdk::auth::to_message+0x1e9>
  29b40b:	mov    $0x22,%ecx
  29b410:	movzbl (%r15,%rax,1),%edx
  29b415:	cmp    $0x27,%dl
  29b418:	cmove  %ecx,%edx
  29b41b:	mov    %dl,(%r12,%rax,1)
  29b41f:	movzbl 0x1(%r15,%rax,1),%edx
  29b425:	cmp    $0x27,%dl
  29b428:	cmove  %ecx,%edx
  29b42b:	mov    %dl,0x1(%r12,%rax,1)
  29b430:	add    $0x2,%rax
  29b434:	cmp    %rax,%r13
  29b437:	jne    29b410 <polymarket_client_sdk::auth::to_message+0x1c0>
  29b439:	mov    0x28(%rsp),%rax
  29b43e:	shl    $1,%rax
  29b441:	test   %rax,%rax
  29b444:	je     29b44f <polymarket_client_sdk::auth::to_message+0x1ff>
  29b446:	mov    %r15,%rdi
  29b449:	call   *0x5ee711(%rip)        # 889b60 <free@GLIBC_2.2.5>
  29b44f:	add    $0x20,%rbp
  29b453:	xor    %eax,%eax
  29b455:	cmp    %rbp,%r13
  29b458:	cmovne %r13,%rax
  29b45c:	mov    $0x1,%ecx
  29b461:	cmove  %rcx,%r12
  29b465:	mov    %rax,(%rsp)
  29b469:	mov    %r12,0x8(%rsp)
  29b46e:	mov    %rax,0x10(%rsp)
  29b473:	add    $0x88,%r14
  29b47a:	mov    %r14,%rdi
  29b47d:	call   4b2740 <url::Url::path>
  29b482:	mov    %rax,0x68(%rsp)
  29b487:	mov    %rdx,0x70(%rsp)
  29b48c:	lea    0x18(%rsp),%rax
  29b491:	mov    %rax,0x28(%rsp)
  29b496:	lea    -0x831ed(%rip),%rax        # 2182b0 <core::fmt::num::imp::<impl core::fmt::Display for i64>::fmt>
  29b49d:	mov    %rax,0x30(%rsp)
  29b4a2:	lea    0x20(%rsp),%rax
  29b4a7:	mov    %rax,0x38(%rsp)
  29b4ac:	lea    0x7a7d(%rip),%rax        # 2a2f30 <<&T as core::fmt::Display>::fmt>
  29b4b3:	mov    %rax,0x40(%rsp)
  29b4b8:	lea    0x68(%rsp),%rax
  29b4bd:	mov    %rax,0x48(%rsp)
  29b4c2:	lea    -0x60f89(%rip),%rax        # 23a540 <<&T as core::fmt::Display>::fmt>
  29b4c9:	mov    %rax,0x50(%rsp)
  29b4ce:	mov    %rsp,%rax
  29b4d1:	mov    %rax,0x58(%rsp)
  29b4d6:	lea    0xc3(%rip),%rax        # 29b5a0 <<alloc::string::String as core::fmt::Display>::fmt.12357>
  29b4dd:	mov    %rax,0x60(%rsp)
  29b4e2:	lea    0x49b19f(%rip),%rax        # 736688 <mime::parse::TOKEN_MAP+0xfc9>
  29b4e9:	mov    %rax,0x78(%rsp)
  29b4ee:	movq   $0x4,0x80(%rsp)
  29b4fa:	movq   $0x0,0x98(%rsp)
  29b506:	lea    0x28(%rsp),%rax
  29b50b:	mov    %rax,0x88(%rsp)
  29b513:	movq   $0x4,0x90(%rsp)
  29b51f:	lea    0x78(%rsp),%rsi
  29b524:	mov    %rbx,%rdi
  29b527:	call   77f00 <alloc::fmt::format::format_inner>
  29b52c:	cmpq   $0x0,(%rsp)
  29b531:	je     29b53e <polymarket_client_sdk::auth::to_message+0x2ee>
  29b533:	mov    0x8(%rsp),%rdi
  29b538:	call   *0x5ee622(%rip)        # 889b60 <free@GLIBC_2.2.5>
  29b53e:	add    $0xa8,%rsp
  29b545:	pop    %rbx
  29b546:	pop    %r12
  29b548:	pop    %r13
  29b54a:	pop    %r14
  29b54c:	pop    %r15
  29b54e:	pop    %rbp
  29b54f:	ret
  29b550:	xor    %edi,%edi
  29b552:	jmp    29b559 <polymarket_client_sdk::auth::to_message+0x309>
  29b554:	mov    $0x1,%edi
  29b559:	lea    0x5eca30(%rip),%rdx        # 887f90 <bytes::bytes_mut::SHARED_VTABLE+0x1b10>
  29b560:	mov    %r13,%rsi
  29b563:	call   4a4d6 <alloc::raw_vec::handle_error>
  29b568:	ud2
  29b56a:	mov    %rax,%rbx
  29b56d:	mov    0x28(%rsp),%rax
  29b572:	shl    $1,%rax
  29b575:	test   %rax,%rax
  29b578:	je     29b594 <polymarket_client_sdk::auth::to_message+0x344>
  29b57a:	mov    %r15,%rdi
  29b57d:	jmp    29b58e <polymarket_client_sdk::auth::to_message+0x33e>
  29b57f:	mov    %rax,%rbx
  29b582:	cmpq   $0x0,(%rsp)
  29b587:	je     29b594 <polymarket_client_sdk::auth::to_message+0x344>
  29b589:	mov    0x8(%rsp),%rdi
  29b58e:	call   *0x5ee5cc(%rip)        # 889b60 <free@GLIBC_2.2.5>
  29b594:	mov    %rbx,%rdi
  29b597:	call   4a180 <_Unwind_Resume@plt>
  29b59c:	nopl   0x0(%rax)
