
bot/bin/arbitrage_bot:     file format elf64-x86-64


Disassembly of section .text:

000000000029b5c0 <polymarket_client_sdk::auth::hmac>:
  29b5c0:	push   %rbp
  29b5c1:	push   %r15
  29b5c3:	push   %r14
  29b5c5:	push   %r13
  29b5c7:	push   %r12
  29b5c9:	push   %rbx
  29b5ca:	sub    $0x2e8,%rsp
  29b5d1:	mov    %rdx,%rax
  29b5d4:	shr    $0x2,%rax
  29b5d8:	xor    %r13d,%r13d
  29b5db:	mov    %rdx,%rbx
  29b5de:	and    $0x3,%rbx
  29b5e2:	setne  %r13b
  29b5e6:	add    %rax,%r13
  29b5e9:	lea    0x0(,%r13,2),%rax
  29b5f1:	add    %r13,%rax
  29b5f4:	mov    %rax,0x10(%rsp)
  29b5f9:	test   %rax,%rax
  29b5fc:	js     29cc08 <polymarket_client_sdk::auth::hmac+0x1648>
  29b602:	mov    %rcx,%r14
  29b605:	mov    %rsi,%rbp
  29b608:	mov    %r8,0x158(%rsp)
  29b610:	test   %r13,%r13
  29b613:	mov    %rdi,0xf8(%rsp)
  29b61b:	je     29b655 <polymarket_client_sdk::auth::hmac+0x95>
  29b61d:	movzbl 0x5ef664(%rip),%eax        # 88ac88 <__rust_no_alloc_shim_is_unstable>
  29b624:	mov    $0x1,%r12d
  29b62a:	mov    $0x1,%esi
  29b62f:	mov    0x10(%rsp),%rdi
  29b634:	mov    %rdx,%r15
  29b637:	call   *0x5ee1db(%rip)        # 889818 <calloc@GLIBC_2.2.5>
  29b63d:	mov    %r15,%rdx
  29b640:	mov    %rax,0x8(%rsp)
  29b645:	test   %rax,%rax
  29b648:	je     29cc0b <polymarket_client_sdk::auth::hmac+0x164b>
  29b64e:	cmp    $0x1,%ebx
  29b651:	je     29b664 <polymarket_client_sdk::auth::hmac+0xa4>
  29b653:	jmp    29b683 <polymarket_client_sdk::auth::hmac+0xc3>
  29b655:	mov    $0x1,%eax
  29b65a:	mov    %rax,0x8(%rsp)
  29b65f:	cmp    $0x1,%ebx
  29b662:	jne    29b683 <polymarket_client_sdk::auth::hmac+0xc3>
  29b664:	movzbl -0x1(%rbp,%rdx,1),%r15d
  29b66a:	cmp    $0x3d,%r15
  29b66e:	je     29b683 <polymarket_client_sdk::auth::hmac+0xc3>
  29b670:	lea    0x49b051(%rip),%rax        # 7366c8 <mime::parse::TOKEN_MAP+0x1009>
  29b677:	cmpb   $0xff,0x43(%r15,%rax,1)
  29b67d:	je     29bcc9 <polymarket_client_sdk::auth::hmac+0x709>
  29b683:	xor    %r12d,%r12d
  29b686:	mov    %rdx,%rax
  29b689:	sub    %rbx,%rax
  29b68c:	cmovae %rax,%r12
  29b690:	test   %rbx,%rbx
  29b693:	mov    %r14,0x150(%rsp)
  29b69b:	jne    29b6a7 <polymarket_client_sdk::auth::hmac+0xe7>
  29b69d:	xor    %eax,%eax
  29b69f:	sub    $0x4,%r12
  29b6a3:	cmovb  %rax,%r12
  29b6a7:	mov    %r12,%rax
  29b6aa:	shr    $0x2,%rax
  29b6ae:	mov    %rax,0x28(%rsp)
  29b6b3:	cmp    %rax,%r13
  29b6b6:	jb     29cc1f <polymarket_client_sdk::auth::hmac+0x165f>
  29b6bc:	mov    %r12,%r8
  29b6bf:	and    $0xffffffffffffffe0,%r8
  29b6c3:	cmp    %rdx,%r8
  29b6c6:	ja     29ca03 <polymarket_client_sdk::auth::hmac+0x1443>
  29b6cc:	mov    %rdx,0x18(%rsp)
  29b6d1:	test   %r8,%r8
  29b6d4:	je     29bb70 <polymarket_client_sdk::auth::hmac+0x5b0>
  29b6da:	mov    %r13,%r9
  29b6dd:	shr    $0x3,%r9
  29b6e1:	lea    (%r9,%r9,2),%rax
  29b6e5:	lea    0x18(,%rax,8),%rax
  29b6ed:	mov    %rax,0x140(%rsp)
  29b6f5:	xor    %esi,%esi
  29b6f7:	lea    0x49afca(%rip),%r10        # 7366c8 <mime::parse::TOKEN_MAP+0x1009>
  29b6fe:	mov    0x8(%rsp),%r11
  29b703:	xor    %r14d,%r14d
  29b706:	mov    %r12,0x148(%rsp)
  29b70e:	mov    %r9,0x20(%rsp)
  29b713:	cmp    %r14,%r9
  29b716:	je     29ca0f <polymarket_client_sdk::auth::hmac+0x144f>
  29b71c:	movzbl 0x0(%rbp,%rsi,1),%r15d
  29b722:	movzbl 0x43(%r15,%r10,1),%edi
  29b728:	cmp    $0xff,%rdi
  29b72f:	je     29be0a <polymarket_client_sdk::auth::hmac+0x84a>
  29b735:	movzbl 0x1(%rbp,%rsi,1),%r15d
  29b73b:	movzbl 0x43(%r15,%r10,1),%ebx
  29b741:	cmp    $0xff,%rbx
  29b748:	je     29be21 <polymarket_client_sdk::auth::hmac+0x861>
  29b74e:	mov    %r14,(%rsp)
  29b752:	movzbl 0x2(%rbp,%rsi,1),%r15d
  29b758:	movzbl 0x43(%r15,%r10,1),%r14d
  29b75e:	cmp    $0xff,%r14
  29b765:	je     29be3b <polymarket_client_sdk::auth::hmac+0x87b>
  29b76b:	movzbl 0x3(%rbp,%rsi,1),%r15d
  29b771:	movzbl 0x43(%r15,%r10,1),%ecx
  29b777:	cmp    $0xff,%rcx
  29b77e:	je     29be5a <polymarket_client_sdk::auth::hmac+0x89a>
  29b784:	movzbl 0x4(%rbp,%rsi,1),%r15d
  29b78a:	movzbl 0x43(%r15,%r10,1),%edx
  29b790:	cmp    $0xff,%rdx
  29b797:	je     29be79 <polymarket_client_sdk::auth::hmac+0x8b9>
  29b79d:	movzbl 0x5(%rbp,%rsi,1),%r15d
  29b7a3:	movzbl 0x43(%r15,%r10,1),%r9d
  29b7a9:	cmp    $0xff,%r9
  29b7b0:	je     29be98 <polymarket_client_sdk::auth::hmac+0x8d8>
  29b7b6:	movzbl 0x6(%rbp,%rsi,1),%r15d
  29b7bc:	movzbl 0x43(%r15,%r10,1),%eax
  29b7c2:	cmp    $0xff,%rax
  29b7c8:	je     29beb7 <polymarket_client_sdk::auth::hmac+0x8f7>
  29b7ce:	movzbl 0x7(%rbp,%rsi,1),%r15d
  29b7d4:	movzbl 0x43(%r15,%r10,1),%r12d
  29b7da:	cmp    $0xff,%r12
  29b7e1:	je     29bed6 <polymarket_client_sdk::auth::hmac+0x916>
  29b7e7:	shl    $0x3a,%rdi
  29b7eb:	shl    $0x34,%rbx
  29b7ef:	or     %rdi,%rbx
  29b7f2:	shl    $0x2e,%r14
  29b7f6:	shl    $0x28,%rcx
  29b7fa:	or     %r14,%rcx
  29b7fd:	or     %rbx,%rcx
  29b800:	shl    $0x22,%rdx
  29b804:	shl    $0x1c,%r9
  29b808:	or     %rdx,%r9
  29b80b:	shl    $0x16,%eax
  29b80e:	or     %r9,%rax
  29b811:	or     %rcx,%rax
  29b814:	shl    $0x10,%r12d
  29b818:	or     %rax,%r12
  29b81b:	bswap  %r12
  29b81e:	mov    %r12d,(%r11)
  29b821:	shr    $0x20,%r12
  29b825:	mov    %r12w,0x4(%r11)
  29b82a:	movzbl 0x8(%rbp,%rsi,1),%r15d
  29b830:	movzbl 0x43(%r15,%r10,1),%ebx
  29b836:	cmp    $0xff,%rbx
  29b83d:	je     29bef5 <polymarket_client_sdk::auth::hmac+0x935>
  29b843:	movzbl 0x9(%rbp,%rsi,1),%r15d
  29b849:	movzbl 0x43(%r15,%r10,1),%ecx
  29b84f:	cmp    $0xff,%rcx
  29b856:	je     29beff <polymarket_client_sdk::auth::hmac+0x93f>
  29b85c:	movzbl 0xa(%rbp,%rsi,1),%r15d
  29b862:	movzbl 0x43(%r15,%r10,1),%r14d
  29b868:	cmp    $0xff,%r14
  29b86f:	je     29bf09 <polymarket_client_sdk::auth::hmac+0x949>
  29b875:	movzbl 0xb(%rbp,%rsi,1),%r15d
  29b87b:	movzbl 0x43(%r15,%r10,1),%edi
  29b881:	cmp    $0xff,%rdi
  29b888:	je     29bf13 <polymarket_client_sdk::auth::hmac+0x953>
  29b88e:	movzbl 0xc(%rbp,%rsi,1),%r15d
  29b894:	movzbl 0x43(%r15,%r10,1),%edx
  29b89a:	cmp    $0xff,%rdx
  29b8a1:	je     29bf1d <polymarket_client_sdk::auth::hmac+0x95d>
  29b8a7:	movzbl 0xd(%rbp,%rsi,1),%r15d
  29b8ad:	movzbl 0x43(%r15,%r10,1),%r12d
  29b8b3:	cmp    $0xff,%r12
  29b8ba:	je     29bf27 <polymarket_client_sdk::auth::hmac+0x967>
  29b8c0:	movzbl 0xe(%rbp,%rsi,1),%r15d
  29b8c6:	movzbl 0x43(%r15,%r10,1),%r9d
  29b8cc:	cmp    $0xff,%r9
  29b8d3:	je     29bf31 <polymarket_client_sdk::auth::hmac+0x971>
  29b8d9:	movzbl 0xf(%rbp,%rsi,1),%r15d
  29b8df:	movzbl 0x43(%r15,%r10,1),%eax
  29b8e5:	cmp    $0xff,%rax
  29b8eb:	je     29bf3b <polymarket_client_sdk::auth::hmac+0x97b>
  29b8f1:	shl    $0x3a,%rbx
  29b8f5:	shl    $0x34,%rcx
  29b8f9:	or     %rbx,%rcx
  29b8fc:	shl    $0x2e,%r14
  29b900:	shl    $0x28,%rdi
  29b904:	or     %r14,%rdi
  29b907:	or     %rcx,%rdi
  29b90a:	shl    $0x22,%rdx
  29b90e:	shl    $0x1c,%r12
  29b912:	or     %rdx,%r12
  29b915:	shl    $0x16,%r9d
  29b919:	or     %r12,%r9
  29b91c:	or     %rdi,%r9
  29b91f:	shl    $0x10,%eax
  29b922:	or     %r9,%rax
  29b925:	bswap  %rax
  29b928:	mov    %eax,0x6(%r11)
  29b92c:	shr    $0x20,%rax
  29b930:	mov    %ax,0xa(%r11)
  29b935:	movzbl 0x10(%rbp,%rsi,1),%r15d
  29b93b:	movzbl 0x43(%r15,%r10,1),%ebx
  29b941:	cmp    $0xff,%rbx
  29b948:	je     29bf42 <polymarket_client_sdk::auth::hmac+0x982>
  29b94e:	movzbl 0x11(%rbp,%rsi,1),%r15d
  29b954:	movzbl 0x43(%r15,%r10,1),%ecx
  29b95a:	cmp    $0xff,%rcx
  29b961:	je     29bf5a <polymarket_client_sdk::auth::hmac+0x99a>
  29b967:	movzbl 0x12(%rbp,%rsi,1),%r15d
  29b96d:	movzbl 0x43(%r15,%r10,1),%r14d
  29b973:	cmp    $0xff,%r14
  29b97a:	je     29bf61 <polymarket_client_sdk::auth::hmac+0x9a1>
  29b980:	movzbl 0x13(%rbp,%rsi,1),%r15d
  29b986:	movzbl 0x43(%r15,%r10,1),%edi
  29b98c:	cmp    $0xff,%rdi
  29b993:	je     29bf68 <polymarket_client_sdk::auth::hmac+0x9a8>
  29b999:	movzbl 0x14(%rbp,%rsi,1),%r15d
  29b99f:	movzbl 0x43(%r15,%r10,1),%edx
  29b9a5:	cmp    $0xff,%rdx
  29b9ac:	je     29bf6f <polymarket_client_sdk::auth::hmac+0x9af>
  29b9b2:	movzbl 0x15(%rbp,%rsi,1),%r15d
  29b9b8:	movzbl 0x43(%r15,%r10,1),%r12d
  29b9be:	cmp    $0xff,%r12
  29b9c5:	je     29bf76 <polymarket_client_sdk::auth::hmac+0x9b6>
  29b9cb:	movzbl 0x16(%rbp,%rsi,1),%r15d
  29b9d1:	movzbl 0x43(%r15,%r10,1),%r9d
  29b9d7:	cmp    $0xff,%r9
  29b9de:	je     29bf7d <polymarket_client_sdk::auth::hmac+0x9bd>
  29b9e4:	movzbl 0x17(%rbp,%rsi,1),%r15d
  29b9ea:	movzbl 0x43(%r15,%r10,1),%eax
  29b9f0:	cmp    $0xff,%rax
  29b9f6:	je     29bf84 <polymarket_client_sdk::auth::hmac+0x9c4>
  29b9fc:	shl    $0x3a,%rbx
  29ba00:	shl    $0x34,%rcx
  29ba04:	or     %rbx,%rcx
  29ba07:	shl    $0x2e,%r14
  29ba0b:	shl    $0x28,%rdi
  29ba0f:	or     %r14,%rdi
  29ba12:	or     %rcx,%rdi
  29ba15:	shl    $0x22,%rdx
  29ba19:	shl    $0x1c,%r12
  29ba1d:	or     %rdx,%r12
  29ba20:	shl    $0x16,%r9d
  29ba24:	or     %r12,%r9
  29ba27:	or     %rdi,%r9
  29ba2a:	shl    $0x10,%eax
  29ba2d:	or     %r9,%rax
  29ba30:	bswap  %rax
  29ba33:	mov    %eax,0xc(%r11)
  29ba37:	shr    $0x20,%rax
  29ba3b:	mov    %ax,0x10(%r11)
  29ba40:	movzbl 0x18(%rbp,%rsi,1),%r15d
  29ba46:	movzbl 0x43(%r15,%r10,1),%ebx
  29ba4c:	cmp    $0xff,%rbx
  29ba53:	je     29bf8b <polymarket_client_sdk::auth::hmac+0x9cb>
  29ba59:	movzbl 0x19(%rbp,%rsi,1),%r15d
  29ba5f:	movzbl 0x43(%r15,%r10,1),%ecx
  29ba65:	cmp    $0xff,%rcx
  29ba6c:	je     29bf92 <polymarket_client_sdk::auth::hmac+0x9d2>
  29ba72:	movzbl 0x1a(%rbp,%rsi,1),%r15d
  29ba78:	movzbl 0x43(%r15,%r10,1),%r14d
  29ba7e:	cmp    $0xff,%r14
  29ba85:	je     29bf99 <polymarket_client_sdk::auth::hmac+0x9d9>
  29ba8b:	movzbl 0x1b(%rbp,%rsi,1),%r15d
  29ba91:	movzbl 0x43(%r15,%r10,1),%edi
  29ba97:	cmp    $0xff,%rdi
  29ba9e:	je     29bfa0 <polymarket_client_sdk::auth::hmac+0x9e0>
  29baa4:	movzbl 0x1c(%rbp,%rsi,1),%r15d
  29baaa:	movzbl 0x43(%r15,%r10,1),%edx
  29bab0:	cmp    $0xff,%rdx
  29bab7:	je     29bfa7 <polymarket_client_sdk::auth::hmac+0x9e7>
  29babd:	movzbl 0x1d(%rbp,%rsi,1),%r15d
  29bac3:	movzbl 0x43(%r15,%r10,1),%r12d
  29bac9:	cmp    $0xff,%r12
  29bad0:	je     29bfae <polymarket_client_sdk::auth::hmac+0x9ee>
  29bad6:	movzbl 0x1e(%rbp,%rsi,1),%r15d
  29badc:	movzbl 0x43(%r15,%r10,1),%r9d
  29bae2:	cmp    $0xff,%r9
  29bae9:	je     29bfb5 <polymarket_client_sdk::auth::hmac+0x9f5>
  29baef:	movzbl 0x1f(%rbp,%rsi,1),%r15d
  29baf5:	movzbl 0x43(%r15,%r10,1),%eax
  29bafb:	cmp    $0xff,%rax
  29bb01:	je     29bfbc <polymarket_client_sdk::auth::hmac+0x9fc>
  29bb07:	shl    $0x3a,%rbx
  29bb0b:	shl    $0x34,%rcx
  29bb0f:	or     %rbx,%rcx
  29bb12:	shl    $0x2e,%r14
  29bb16:	shl    $0x28,%rdi
  29bb1a:	or     %r14,%rdi
  29bb1d:	or     %rcx,%rdi
  29bb20:	shl    $0x22,%rdx
  29bb24:	shl    $0x1c,%r12
  29bb28:	or     %rdx,%r12
  29bb2b:	shl    $0x16,%r9d
  29bb2f:	or     %r12,%r9
  29bb32:	or     %rdi,%r9
  29bb35:	shl    $0x10,%eax
  29bb38:	or     %r9,%rax
  29bb3b:	bswap  %rax
  29bb3e:	mov    %eax,0x12(%r11)
  29bb42:	shr    $0x20,%rax
  29bb46:	mov    %ax,0x16(%r11)
  29bb4b:	add    $0x20,%rsi
  29bb4f:	add    $0x18,%r11
  29bb53:	mov    (%rsp),%r14
  29bb57:	inc    %r14
  29bb5a:	cmp    %rsi,%r8
  29bb5d:	mov    0x148(%rsp),%r12
  29bb65:	mov    0x20(%rsp),%r9
  29bb6a:	jne    29b713 <polymarket_client_sdk::auth::hmac+0x153>
  29bb70:	mov    %r8,%rcx
  29bb73:	shr    $0x2,%rcx
  29bb77:	lea    (%rcx,%rcx,2),%rax
  29bb7b:	mov    0x28(%rsp),%rdx
  29bb80:	lea    (%rdx,%rdx,2),%rsi
  29bb84:	cmp    %rcx,%rdx
  29bb87:	jb     29caab <polymarket_client_sdk::auth::hmac+0x14eb>
  29bb8d:	mov    0x18(%rsp),%rdx
  29bb92:	cmp    %r12,%rdx
  29bb95:	jb     29cabf <polymarket_client_sdk::auth::hmac+0x14ff>
  29bb9b:	mov    %rsi,0x20(%rsp)
  29bba0:	mov    %r12,%rsi
  29bba3:	test   $0x1c,%r12b
  29bba7:	mov    %r13,(%rsp)
  29bbab:	je     29bc9a <polymarket_client_sdk::auth::hmac+0x6da>
  29bbb1:	mov    0x20(%rsp),%rcx
  29bbb6:	sub    %rax,%rcx
  29bbb9:	add    0x8(%rsp),%rax
  29bbbe:	lea    (%r8,%rbp,1),%r10
  29bbc2:	mov    0x28(%rsp),%r11
  29bbc7:	and    $0x7,%r11d
  29bbcb:	shl    $0x2,%r11d
  29bbcf:	neg    %r11
  29bbd2:	mov    $0x3,%edi
  29bbd7:	xor    %r12d,%r12d
  29bbda:	lea    0x49aae7(%rip),%rbx        # 7366c8 <mime::parse::TOKEN_MAP+0x1009>
  29bbe1:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  29bbf0:	cmp    %rcx,%rdi
  29bbf3:	ja     29c464 <polymarket_client_sdk::auth::hmac+0xea4>
  29bbf9:	movzbl (%r10,%r12,4),%r15d
  29bbfe:	movzbl 0x43(%r15,%rbx,1),%r9d
  29bc04:	cmp    $0xff,%r9d
  29bc0b:	je     29bcff <polymarket_client_sdk::auth::hmac+0x73f>
  29bc11:	movzbl 0x1(%r10,%r12,4),%r15d
  29bc17:	movzbl 0x43(%r15,%rbx,1),%edx
  29bc1d:	cmp    $0xff,%edx
  29bc23:	je     29bd16 <polymarket_client_sdk::auth::hmac+0x756>
  29bc29:	movzbl 0x2(%r10,%r12,4),%r15d
  29bc2f:	movzbl 0x43(%r15,%rbx,1),%r13d
  29bc35:	cmp    $0xff,%r13d
  29bc3c:	je     29bd30 <polymarket_client_sdk::auth::hmac+0x770>
  29bc42:	movzbl 0x3(%r10,%r12,4),%r15d
  29bc48:	movzbl 0x43(%r15,%rbx,1),%r14d
  29bc4e:	cmp    $0xff,%r14d
  29bc55:	je     29bdeb <polymarket_client_sdk::auth::hmac+0x82b>
  29bc5b:	shl    $0x1a,%r9d
  29bc5f:	shl    $0x14,%edx
  29bc62:	or     %r9d,%edx
  29bc65:	shl    $0xe,%r13d
  29bc69:	shl    $0x8,%r14d
  29bc6d:	or     %r13d,%r14d
  29bc70:	or     %edx,%r14d
  29bc73:	bswap  %r14d
  29bc76:	mov    %r14w,-0x3(%rax,%rdi,1)
  29bc7c:	shr    $0x10,%r14d
  29bc80:	mov    %r14b,-0x1(%rax,%rdi,1)
  29bc85:	add    $0x3,%rdi
  29bc89:	inc    %r12
  29bc8c:	add    $0x4,%r11
  29bc90:	mov    (%rsp),%r13
  29bc94:	jne    29bbf0 <polymarket_client_sdk::auth::hmac+0x630>
  29bc9a:	mov    0x18(%rsp),%rdi
  29bc9f:	mov    %rdi,%r11
  29bca2:	mov    %rsi,%r9
  29bca5:	sub    %rsi,%r11
  29bca8:	jne    29bce2 <polymarket_client_sdk::auth::hmac+0x722>
  29bcaa:	xor    %eax,%eax
  29bcac:	xor    %r15d,%r15d
  29bcaf:	xor    %r14d,%r14d
  29bcb2:	test   %rdi,%rdi
  29bcb5:	je     29c071 <polymarket_client_sdk::auth::hmac+0xab1>
  29bcbb:	add    %r9,%r14
  29bcbe:	mov    $0x1,%r15d
  29bcc4:	jmp    29bfda <polymarket_client_sdk::auth::hmac+0xa1a>
  29bcc9:	dec    %rdx
  29bccc:	shl    $0x8,%r15d
  29bcd0:	mov    %rdx,%r14
  29bcd3:	cmp    $0x4,%r15b
  29bcd7:	jne    29bfda <polymarket_client_sdk::auth::hmac+0xa1a>
  29bcdd:	jmp    29cc1f <polymarket_client_sdk::auth::hmac+0x165f>
  29bce2:	movzbl 0x0(%rbp,%r9,1),%r15d
  29bce8:	cmp    $0x3d,%r15
  29bcec:	jne    29bd3d <polymarket_client_sdk::auth::hmac+0x77d>
  29bcee:	xor    %r14d,%r14d
  29bcf1:	add    %r9,%r14
  29bcf4:	mov    $0x3d00,%r15d
  29bcfa:	jmp    29bfda <polymarket_client_sdk::auth::hmac+0xa1a>
  29bcff:	lea    (%r8,%r12,4),%r14
  29bd03:	shl    $0x8,%r15d
  29bd07:	cmp    $0x4,%r15b
  29bd0b:	jne    29bfda <polymarket_client_sdk::auth::hmac+0xa1a>
  29bd11:	jmp    29cc1f <polymarket_client_sdk::auth::hmac+0x165f>
  29bd16:	lea    (%r8,%r12,4),%r14
  29bd1a:	inc    %r14
  29bd1d:	shl    $0x8,%r15d
  29bd21:	cmp    $0x4,%r15b
  29bd25:	jne    29bfda <polymarket_client_sdk::auth::hmac+0xa1a>
  29bd2b:	jmp    29cc1f <polymarket_client_sdk::auth::hmac+0x165f>
  29bd30:	lea    (%r8,%r12,4),%r14
  29bd34:	add    $0x2,%r14
  29bd38:	jmp    29bdf3 <polymarket_client_sdk::auth::hmac+0x833>
  29bd3d:	lea    0x49a984(%rip),%r10        # 7366c8 <mime::parse::TOKEN_MAP+0x1009>
  29bd44:	movzbl 0x43(%r15,%r10,1),%eax
  29bd4a:	cmp    $0xff,%al
  29bd4c:	je     29bf49 <polymarket_client_sdk::auth::hmac+0x989>
  29bd52:	lea    (%rdi,%rbp,1),%rcx
  29bd56:	lea    (%r9,%rbp,1),%rdx
  29bd5a:	inc    %rdx
  29bd5d:	cmp    %rcx,%rdx
  29bd60:	je     29c062 <polymarket_client_sdk::auth::hmac+0xaa2>
  29bd66:	add    %r9,%rbp
  29bd69:	movzbl 0x1(%rbp),%r15d
  29bd6e:	mov    $0x1,%r14d
  29bd74:	cmp    $0x3d,%r15
  29bd78:	je     29bcf1 <polymarket_client_sdk::auth::hmac+0x731>
  29bd7e:	movzbl 0x43(%r15,%r10,1),%r12d
  29bd84:	cmp    $0xff,%r12b
  29bd88:	je     29c109 <polymarket_client_sdk::auth::hmac+0xb49>
  29bd8e:	lea    0x2(%rbp),%rdi
  29bd92:	mov    $0x2,%r14d
  29bd98:	cmp    %rcx,%rdi
  29bd9b:	je     29c3ce <polymarket_client_sdk::auth::hmac+0xe0e>
  29bda1:	lea    0x3(%rbp),%rdx
  29bda5:	movzbl 0x2(%rbp),%r8d
  29bdaa:	cmp    $0x3d,%r8
  29bdae:	jne    29c3d6 <polymarket_client_sdk::auth::hmac+0xe16>
  29bdb4:	mov    %rcx,%r10
  29bdb7:	sub    %rdi,%r10
  29bdba:	cmp    %rcx,%rdx
  29bdbd:	je     29c077 <polymarket_client_sdk::auth::hmac+0xab7>
  29bdc3:	mov    $0x3,%ecx
  29bdc8:	xor    %ebx,%ebx
  29bdca:	cmpb   $0x3d,0x0(%rbp,%rcx,1)
  29bdcf:	jne    29ca39 <polymarket_client_sdk::auth::hmac+0x1479>
  29bdd5:	test   %rcx,%rcx
  29bdd8:	je     29bcee <polymarket_client_sdk::auth::hmac+0x72e>
  29bdde:	inc    %rcx
  29bde1:	cmp    %rcx,%r11
  29bde4:	jne    29bdca <polymarket_client_sdk::auth::hmac+0x80a>
  29bde6:	jmp    29c079 <polymarket_client_sdk::auth::hmac+0xab9>
  29bdeb:	lea    (%r8,%r12,4),%r14
  29bdef:	add    $0x3,%r14
  29bdf3:	mov    (%rsp),%r13
  29bdf7:	shl    $0x8,%r15d
  29bdfb:	cmp    $0x4,%r15b
  29bdff:	jne    29bfda <polymarket_client_sdk::auth::hmac+0xa1a>
  29be05:	jmp    29cc1f <polymarket_client_sdk::auth::hmac+0x165f>
  29be0a:	shl    $0x5,%r14
  29be0e:	shl    $0x8,%r15d
  29be12:	cmp    $0x4,%r15b
  29be16:	jne    29bfda <polymarket_client_sdk::auth::hmac+0xa1a>
  29be1c:	jmp    29cc1f <polymarket_client_sdk::auth::hmac+0x165f>
  29be21:	shl    $0x5,%r14
  29be25:	inc    %r14
  29be28:	shl    $0x8,%r15d
  29be2c:	cmp    $0x4,%r15b
  29be30:	jne    29bfda <polymarket_client_sdk::auth::hmac+0xa1a>
  29be36:	jmp    29cc1f <polymarket_client_sdk::auth::hmac+0x165f>
  29be3b:	mov    (%rsp),%r14
  29be3f:	shl    $0x5,%r14
  29be43:	or     $0x2,%r14
  29be47:	shl    $0x8,%r15d
  29be4b:	cmp    $0x4,%r15b
  29be4f:	jne    29bfda <polymarket_client_sdk::auth::hmac+0xa1a>
  29be55:	jmp    29cc1f <polymarket_client_sdk::auth::hmac+0x165f>
  29be5a:	mov    (%rsp),%r14
  29be5e:	shl    $0x5,%r14
  29be62:	or     $0x3,%r14
  29be66:	shl    $0x8,%r15d
  29be6a:	cmp    $0x4,%r15b
  29be6e:	jne    29bfda <polymarket_client_sdk::auth::hmac+0xa1a>
  29be74:	jmp    29cc1f <polymarket_client_sdk::auth::hmac+0x165f>
  29be79:	mov    (%rsp),%r14
  29be7d:	shl    $0x5,%r14
  29be81:	or     $0x4,%r14
  29be85:	shl    $0x8,%r15d
  29be89:	cmp    $0x4,%r15b
  29be8d:	jne    29bfda <polymarket_client_sdk::auth::hmac+0xa1a>
  29be93:	jmp    29cc1f <polymarket_client_sdk::auth::hmac+0x165f>
  29be98:	mov    (%rsp),%r14
  29be9c:	shl    $0x5,%r14
  29bea0:	or     $0x5,%r14
  29bea4:	shl    $0x8,%r15d
  29bea8:	cmp    $0x4,%r15b
  29beac:	jne    29bfda <polymarket_client_sdk::auth::hmac+0xa1a>
  29beb2:	jmp    29cc1f <polymarket_client_sdk::auth::hmac+0x165f>
  29beb7:	mov    (%rsp),%r14
  29bebb:	shl    $0x5,%r14
  29bebf:	or     $0x6,%r14
  29bec3:	shl    $0x8,%r15d
  29bec7:	cmp    $0x4,%r15b
  29becb:	jne    29bfda <polymarket_client_sdk::auth::hmac+0xa1a>
  29bed1:	jmp    29cc1f <polymarket_client_sdk::auth::hmac+0x165f>
  29bed6:	mov    (%rsp),%r14
  29beda:	shl    $0x5,%r14
  29bede:	or     $0x7,%r14
  29bee2:	shl    $0x8,%r15d
  29bee6:	cmp    $0x4,%r15b
  29beea:	jne    29bfda <polymarket_client_sdk::auth::hmac+0xa1a>
  29bef0:	jmp    29cc1f <polymarket_client_sdk::auth::hmac+0x165f>
  29bef5:	mov    $0x8,%eax
  29befa:	jmp    29bfc1 <polymarket_client_sdk::auth::hmac+0xa01>
  29beff:	mov    $0x9,%eax
  29bf04:	jmp    29bfc1 <polymarket_client_sdk::auth::hmac+0xa01>
  29bf09:	mov    $0xa,%eax
  29bf0e:	jmp    29bfc1 <polymarket_client_sdk::auth::hmac+0xa01>
  29bf13:	mov    $0xb,%eax
  29bf18:	jmp    29bfc1 <polymarket_client_sdk::auth::hmac+0xa01>
  29bf1d:	mov    $0xc,%eax
  29bf22:	jmp    29bfc1 <polymarket_client_sdk::auth::hmac+0xa01>
  29bf27:	mov    $0xd,%eax
  29bf2c:	jmp    29bfc1 <polymarket_client_sdk::auth::hmac+0xa01>
  29bf31:	mov    $0xe,%eax
  29bf36:	jmp    29bfc1 <polymarket_client_sdk::auth::hmac+0xa01>
  29bf3b:	mov    $0xf,%eax
  29bf40:	jmp    29bfc1 <polymarket_client_sdk::auth::hmac+0xa01>
  29bf42:	mov    $0x10,%eax
  29bf47:	jmp    29bfc1 <polymarket_client_sdk::auth::hmac+0xa01>
  29bf49:	xor    %edi,%edi
  29bf4b:	add    %r9,%rdi
  29bf4e:	shl    $0x8,%r15d
  29bf52:	mov    %rdi,%r14
  29bf55:	jmp    29c0e0 <polymarket_client_sdk::auth::hmac+0xb20>
  29bf5a:	mov    $0x11,%eax
  29bf5f:	jmp    29bfc1 <polymarket_client_sdk::auth::hmac+0xa01>
  29bf61:	mov    $0x12,%eax
  29bf66:	jmp    29bfc1 <polymarket_client_sdk::auth::hmac+0xa01>
  29bf68:	mov    $0x13,%eax
  29bf6d:	jmp    29bfc1 <polymarket_client_sdk::auth::hmac+0xa01>
  29bf6f:	mov    $0x14,%eax
  29bf74:	jmp    29bfc1 <polymarket_client_sdk::auth::hmac+0xa01>
  29bf76:	mov    $0x15,%eax
  29bf7b:	jmp    29bfc1 <polymarket_client_sdk::auth::hmac+0xa01>
  29bf7d:	mov    $0x16,%eax
  29bf82:	jmp    29bfc1 <polymarket_client_sdk::auth::hmac+0xa01>
  29bf84:	mov    $0x17,%eax
  29bf89:	jmp    29bfc1 <polymarket_client_sdk::auth::hmac+0xa01>
  29bf8b:	mov    $0x18,%eax
  29bf90:	jmp    29bfc1 <polymarket_client_sdk::auth::hmac+0xa01>
  29bf92:	mov    $0x19,%eax
  29bf97:	jmp    29bfc1 <polymarket_client_sdk::auth::hmac+0xa01>
  29bf99:	mov    $0x1a,%eax
  29bf9e:	jmp    29bfc1 <polymarket_client_sdk::auth::hmac+0xa01>
  29bfa0:	mov    $0x1b,%eax
  29bfa5:	jmp    29bfc1 <polymarket_client_sdk::auth::hmac+0xa01>
  29bfa7:	mov    $0x1c,%eax
  29bfac:	jmp    29bfc1 <polymarket_client_sdk::auth::hmac+0xa01>
  29bfae:	mov    $0x1d,%eax
  29bfb3:	jmp    29bfc1 <polymarket_client_sdk::auth::hmac+0xa01>
  29bfb5:	mov    $0x1e,%eax
  29bfba:	jmp    29bfc1 <polymarket_client_sdk::auth::hmac+0xa01>
  29bfbc:	mov    $0x1f,%eax
  29bfc1:	mov    (%rsp),%r14
  29bfc5:	shl    $0x5,%r14
  29bfc9:	or     %rax,%r14
  29bfcc:	shl    $0x8,%r15d
  29bfd0:	cmp    $0x4,%r15b
  29bfd4:	je     29cc1f <polymarket_client_sdk::auth::hmac+0x165f>
  29bfda:	test   %r13,%r13
  29bfdd:	je     29bfea <polymarket_client_sdk::auth::hmac+0xa2a>
  29bfdf:	mov    0x8(%rsp),%rdi
  29bfe4:	call   *0x5edb76(%rip)        # 889b60 <free@GLIBC_2.2.5>
  29bfea:	movzbl 0x5eec97(%rip),%eax        # 88ac88 <__rust_no_alloc_shim_is_unstable>
  29bff1:	mov    $0x10,%edi
  29bff6:	call   *0x5edc14(%rip)        # 889c10 <malloc@GLIBC_2.2.5>
  29bffc:	test   %rax,%rax
  29bfff:	je     29c9f4 <polymarket_client_sdk::auth::hmac+0x1434>
  29c005:	mov    %rax,%rbx
  29c008:	mov    %r15,(%rax)
  29c00b:	mov    %r14,0x8(%rax)
  29c00f:	lea    0x30(%rsp),%rdi
  29c014:	call   4860e0 <std::backtrace::Backtrace::capture>
  29c019:	mov    0xf8(%rsp),%rcx
  29c021:	movb   $0x3,0x40(%rcx)
  29c025:	mov    %rbx,0x30(%rcx)
  29c029:	lea    0x5dba48(%rip),%rax        # 877a78 <bytes::bytes::PROMOTABLE_ODD_VTABLE+0x2a90>
  29c030:	mov    %rax,0x38(%rcx)
  29c034:	movdqu 0x30(%rsp),%xmm0
  29c03a:	movups 0x40(%rsp),%xmm1
  29c03f:	movups 0x50(%rsp),%xmm2
  29c044:	movdqu %xmm0,(%rcx)
  29c048:	movups %xmm1,0x10(%rcx)
  29c04c:	movups %xmm2,0x20(%rcx)
  29c050:	add    $0x2e8,%rsp
  29c057:	pop    %rbx
  29c058:	pop    %r12
  29c05a:	pop    %r13
  29c05c:	pop    %r14
  29c05e:	pop    %r15
  29c060:	pop    %rbp
  29c061:	ret
  29c062:	mov    $0x1,%r14d
  29c068:	test   %rdi,%rdi
  29c06b:	jne    29bcbb <polymarket_client_sdk::auth::hmac+0x6fb>
  29c071:	xor    %r10d,%r10d
  29c074:	xor    %r12d,%r12d
  29c077:	xor    %ebx,%ebx
  29c079:	xor    %r13d,%r13d
  29c07c:	add    %r14d,%r10d
  29c07f:	test   $0x3,%r10b
  29c083:	je     29c094 <polymarket_client_sdk::auth::hmac+0xad4>
  29c085:	mov    $0x3,%r15d
  29c08b:	mov    (%rsp),%r13
  29c08f:	jmp    29bfda <polymarket_client_sdk::auth::hmac+0xa1a>
  29c094:	lea    (%r14,%r14,1),%ecx
  29c098:	lea    (%rcx,%rcx,2),%rdi
  29c09c:	movzbl %al,%eax
  29c09f:	shl    $0x1a,%eax
  29c0a2:	movzbl %r12b,%edx
  29c0a6:	shl    $0x14,%edx
  29c0a9:	or     %eax,%edx
  29c0ab:	movzbl %bl,%ecx
  29c0ae:	shl    $0xe,%ecx
  29c0b1:	movzbl %r13b,%eax
  29c0b5:	shl    $0x8,%eax
  29c0b8:	or     %ecx,%eax
  29c0ba:	mov    %eax,%r8d
  29c0bd:	or     %edx,%r8d
  29c0c0:	mov    %edi,%ecx
  29c0c2:	and    $0x18,%cl
  29c0c5:	mov    %r8d,%ebx
  29c0c8:	shl    %cl,%ebx
  29c0ca:	test   %ebx,%ebx
  29c0cc:	je     29c0f3 <polymarket_client_sdk::auth::hmac+0xb33>
  29c0ce:	add    %r9,%r14
  29c0d1:	dec    %r14
  29c0d4:	movzbl %r15b,%r15d
  29c0d8:	shl    $0x8,%r15d
  29c0dc:	or     $0x2,%r15
  29c0e0:	mov    (%rsp),%r13
  29c0e4:	cmp    $0x4,%r15b
  29c0e8:	jne    29bfda <polymarket_client_sdk::auth::hmac+0xa1a>
  29c0ee:	jmp    29cc1f <polymarket_client_sdk::auth::hmac+0x165f>
  29c0f3:	cmp    $0x2,%r14d
  29c0f7:	mov    (%rsp),%r13
  29c0fb:	jae    29c113 <polymarket_client_sdk::auth::hmac+0xb53>
  29c0fd:	mov    0x10(%rsp),%rbx
  29c102:	mov    0x20(%rsp),%rcx
  29c107:	jmp    29c17d <polymarket_client_sdk::auth::hmac+0xbbd>
  29c109:	mov    $0x1,%edi
  29c10e:	jmp    29bf4b <polymarket_client_sdk::auth::hmac+0x98b>
  29c113:	cmp    %r13,0x28(%rsp)
  29c118:	mov    0x20(%rsp),%rsi
  29c11d:	jae    29cc1f <polymarket_client_sdk::auth::hmac+0x165f>
  29c123:	shr    $0x18,%edx
  29c126:	mov    0x8(%rsp),%rcx
  29c12b:	mov    %dl,(%rcx,%rsi,1)
  29c12e:	lea    0x1(%rsi),%rcx
  29c132:	cmp    $0x2,%r14d
  29c136:	je     29c178 <polymarket_client_sdk::auth::hmac+0xbb8>
  29c138:	cmp    0x10(%rsp),%rcx
  29c13d:	jae    29cc1f <polymarket_client_sdk::auth::hmac+0x165f>
  29c143:	shr    $0x10,%r8d
  29c147:	mov    0x8(%rsp),%rcx
  29c14c:	mov    %r8b,0x1(%rcx,%rsi,1)
  29c151:	lea    0x2(%rsi),%rcx
  29c155:	and    $0xfffffff8,%edi
  29c158:	cmp    $0x10,%edi
  29c15b:	je     29c178 <polymarket_client_sdk::auth::hmac+0xbb8>
  29c15d:	cmp    0x10(%rsp),%rcx
  29c162:	jae    29cc1f <polymarket_client_sdk::auth::hmac+0x165f>
  29c168:	mov    0x8(%rsp),%rcx
  29c16d:	mov    %ah,0x2(%rcx,%rsi,1)
  29c171:	add    $0x3,%rsi
  29c175:	mov    %rsi,%rcx
  29c178:	mov    0x10(%rsp),%rbx
  29c17d:	cmp    %rbx,%rcx
  29c180:	cmovb  %rcx,%rbx
  29c184:	pxor   %xmm0,%xmm0
  29c188:	movdqa %xmm0,0x130(%rsp)
  29c191:	movdqa %xmm0,0x120(%rsp)
  29c19a:	movdqa %xmm0,0x110(%rsp)
  29c1a3:	movdqa %xmm0,0x100(%rsp)
  29c1ac:	cmp    $0x41,%rbx
  29c1b0:	mov    0x150(%rsp),%r14
  29c1b8:	jae    29c1d5 <polymarket_client_sdk::auth::hmac+0xc15>
  29c1ba:	lea    0x100(%rsp),%rdi
  29c1c2:	mov    0x8(%rsp),%rsi
  29c1c7:	mov    %rbx,%rdx
  29c1ca:	call   *0x5ed728(%rip)        # 8898f8 <memcpy@GLIBC_2.14>
  29c1d0:	jmp    29c4fd <polymarket_client_sdk::auth::hmac+0xf3d>
  29c1d5:	movdqu %xmm0,0x238(%rsp)
  29c1de:	movdqu %xmm0,0x228(%rsp)
  29c1e7:	movdqu %xmm0,0x218(%rsp)
  29c1f0:	movdqu %xmm0,0x208(%rsp)
  29c1f9:	movb   $0x0,0x248(%rsp)
  29c201:	movups 0x42ddf8(%rip),%xmm0        # 6ca000 <encoding_rs::data::KSX1001_LOWERCASE+0x220>
  29c208:	movaps %xmm0,0x1e0(%rsp)
  29c210:	movdqu 0x42ddf8(%rip),%xmm0        # 6ca010 <encoding_rs::data::KSX1001_LOWERCASE+0x230>
  29c218:	movdqa %xmm0,0x1f0(%rsp)
  29c221:	mov    %rbx,%rdx
  29c224:	shr    $0x6,%rdx
  29c228:	mov    %rdx,0x200(%rsp)
  29c230:	lea    0x1e0(%rsp),%rdi
  29c238:	mov    0x8(%rsp),%rsi
  29c23d:	call   451c40 <sha2::sha256::compress256>
  29c242:	mov    %r14,%r12
  29c245:	lea    0x208(%rsp),%rdi
  29c24d:	movabs $0x7fffffffffffffc0,%rsi
  29c257:	and    %rbx,%rsi
  29c25a:	add    0x8(%rsp),%rsi
  29c25f:	and    $0x3f,%ebx
  29c262:	mov    %rbx,%rdx
  29c265:	call   *0x5ed68d(%rip)        # 8898f8 <memcpy@GLIBC_2.14>
  29c26b:	mov    %bl,0x248(%rsp)
  29c272:	mov    0x240(%rsp),%rax
  29c27a:	mov    %rax,0x90(%rsp)
  29c282:	movzbl 0x248(%rsp),%eax
  29c28a:	mov    %al,0x98(%rsp)
  29c291:	mov    0x249(%rsp),%eax
  29c298:	mov    %eax,0x99(%rsp)
  29c29f:	movzwl 0x24d(%rsp),%eax
  29c2a7:	mov    %ax,0x9d(%rsp)
  29c2af:	movzbl 0x24f(%rsp),%eax
  29c2b7:	mov    %al,0x9f(%rsp)
  29c2be:	movdqa 0x1e0(%rsp),%xmm0
  29c2c7:	movaps 0x1f0(%rsp),%xmm1
  29c2cf:	movaps 0x200(%rsp),%xmm2
  29c2d7:	movaps 0x210(%rsp),%xmm3
  29c2df:	movaps %xmm2,0x50(%rsp)
  29c2e4:	movaps 0x230(%rsp),%xmm2
  29c2ec:	movaps %xmm2,0x80(%rsp)
  29c2f4:	movaps 0x220(%rsp),%xmm2
  29c2fc:	movaps %xmm2,0x70(%rsp)
  29c301:	movaps %xmm3,0x60(%rsp)
  29c306:	movaps %xmm1,0x40(%rsp)
  29c30b:	movdqa %xmm0,0x30(%rsp)
  29c311:	lea    0x58(%rsp),%r15
  29c316:	movzbl 0x98(%rsp),%r14d
  29c31f:	mov    0x50(%rsp),%rax
  29c324:	shl    $0x9,%rax
  29c328:	lea    0x0(,%r14,8),%ebx
  29c330:	or     %rax,%rbx
  29c333:	bswap  %rbx
  29c336:	movb   $0x80,0x58(%rsp,%r14,1)
  29c33c:	cmp    $0x3f,%r14d
  29c340:	je     29c36a <polymarket_client_sdk::auth::hmac+0xdaa>
  29c342:	lea    (%rsp,%r14,1),%rdi
  29c346:	add    $0x58,%rdi
  29c34a:	inc    %rdi
  29c34d:	mov    %r14,%rdx
  29c350:	xor    $0x3f,%rdx
  29c354:	xor    %esi,%esi
  29c356:	call   *0x5ed41c(%rip)        # 889778 <memset@GLIBC_2.2.5>
  29c35c:	xor    $0x38,%r14d
  29c360:	cmp    $0x7,%r14d
  29c364:	ja     29c476 <polymarket_client_sdk::auth::hmac+0xeb6>
  29c36a:	lea    0x30(%rsp),%rdi
  29c36f:	mov    $0x1,%edx
  29c374:	mov    %r15,%rsi
  29c377:	call   451c40 <sha2::sha256::compress256>
  29c37c:	mov    %r12,%r14
  29c37f:	pxor   %xmm0,%xmm0
  29c383:	movdqa %xmm0,0x180(%rsp)
  29c38c:	movdqa %xmm0,0x170(%rsp)
  29c395:	movdqa %xmm0,0x160(%rsp)
  29c39e:	movq   $0x0,0x190(%rsp)
  29c3aa:	mov    %rbx,0x198(%rsp)
  29c3b2:	lea    0x30(%rsp),%rdi
  29c3b7:	lea    0x160(%rsp),%rsi
  29c3bf:	mov    $0x1,%edx
  29c3c4:	call   451c40 <sha2::sha256::compress256>
  29c3c9:	jmp    29c493 <polymarket_client_sdk::auth::hmac+0xed3>
  29c3ce:	xor    %r10d,%r10d
  29c3d1:	jmp    29c077 <polymarket_client_sdk::auth::hmac+0xab7>
  29c3d6:	movzbl 0x43(%r8,%r10,1),%ebx
  29c3dc:	cmp    $0xff,%bl
  29c3df:	je     29c9e7 <polymarket_client_sdk::auth::hmac+0x1427>
  29c3e5:	cmp    %rcx,%rdx
  29c3e8:	je     29ca28 <polymarket_client_sdk::auth::hmac+0x1468>
  29c3ee:	lea    0x4(%rbp),%rdi
  29c3f2:	movzbl 0x3(%rbp),%r14d
  29c3f7:	cmp    $0x3d,%r14b
  29c3fb:	jne    29ca4f <polymarket_client_sdk::auth::hmac+0x148f>
  29c401:	mov    %r10,%r15
  29c404:	mov    %rcx,%r10
  29c407:	sub    %rdx,%r10
  29c40a:	cmp    %rcx,%rdi
  29c40d:	je     29cadc <polymarket_client_sdk::auth::hmac+0x151c>
  29c413:	mov    %ebx,0x18(%rsp)
  29c417:	mov    $0x4,%edi
  29c41c:	mov    $0x3,%ebx
  29c421:	xor    %r13d,%r13d
  29c424:	lea    0x1(%rdi),%rdx
  29c428:	movzbl 0x0(%rbp,%rdi,1),%r14d
  29c42e:	cmp    $0x3d,%r14b
  29c432:	jne    29caf5 <polymarket_client_sdk::auth::hmac+0x1535>
  29c438:	cmp    $0x2,%rdi
  29c43c:	jb     29cb61 <polymarket_client_sdk::auth::hmac+0x15a1>
  29c442:	cmp    $0x3,%rdi
  29c446:	cmove  %rdi,%rbx
  29c44a:	mov    $0x3,%r14d
  29c450:	mov    %rdx,%rdi
  29c453:	cmp    %rdx,%r11
  29c456:	jne    29c424 <polymarket_client_sdk::auth::hmac+0xe64>
  29c458:	mov    %r8d,%r15d
  29c45b:	mov    0x18(%rsp),%ebx
  29c45f:	jmp    29c07c <polymarket_client_sdk::auth::hmac+0xabc>
  29c464:	mov    %rdi,%r8
  29c467:	mov    %rcx,%rdx
  29c46a:	lea    0x5d1cb7(%rip),%rax        # 86e128 <aws_lc_0_37_1_kem_asn1_meth+0x7028>
  29c471:	jmp    29cac9 <polymarket_client_sdk::auth::hmac+0x1509>
  29c476:	mov    %rbx,0x90(%rsp)
  29c47e:	lea    0x30(%rsp),%rdi
  29c483:	mov    $0x1,%edx
  29c488:	mov    %r15,%rsi
  29c48b:	call   451c40 <sha2::sha256::compress256>
  29c490:	mov    %r12,%r14
  29c493:	pxor   %xmm0,%xmm0
  29c497:	movdqa 0x30(%rsp),%xmm1
  29c49d:	movdqa 0x40(%rsp),%xmm2
  29c4a3:	movdqa %xmm1,%xmm3
  29c4a7:	punpckhbw %xmm0,%xmm3
  29c4ab:	pshuflw $0x1b,%xmm3,%xmm3
  29c4b0:	pshufhw $0x1b,%xmm3,%xmm3
  29c4b5:	punpcklbw %xmm0,%xmm1
  29c4b9:	pshuflw $0x1b,%xmm1,%xmm1
  29c4be:	pshufhw $0x1b,%xmm1,%xmm1
  29c4c3:	packuswb %xmm3,%xmm1
  29c4c7:	movdqa %xmm2,%xmm3
  29c4cb:	punpckhbw %xmm0,%xmm3
  29c4cf:	pshuflw $0x1b,%xmm3,%xmm3
  29c4d4:	pshufhw $0x1b,%xmm3,%xmm3
  29c4d9:	punpcklbw %xmm0,%xmm2
  29c4dd:	pshuflw $0x1b,%xmm2,%xmm0
  29c4e2:	pshufhw $0x1b,%xmm0,%xmm0
  29c4e7:	packuswb %xmm3,%xmm0
  29c4eb:	movdqa %xmm1,0x100(%rsp)
  29c4f4:	movdqa %xmm0,0x110(%rsp)
  29c4fd:	movaps 0x100(%rsp),%xmm0
  29c505:	movaps 0x110(%rsp),%xmm1
  29c50d:	movaps 0x120(%rsp),%xmm2
  29c515:	movaps 0x130(%rsp),%xmm3
  29c51d:	movaps %xmm3,0x60(%rsp)
  29c522:	movaps %xmm2,0x50(%rsp)
  29c527:	movaps %xmm1,0x40(%rsp)
  29c52c:	movaps %xmm0,0x30(%rsp)
  29c531:	movaps 0x42c218(%rip),%xmm4        # 6c8750 <_fini+0x1644>
  29c538:	xorps  %xmm4,%xmm0
  29c53b:	xorps  %xmm4,%xmm1
  29c53e:	movaps %xmm0,0x30(%rsp)
  29c543:	movaps %xmm1,0x40(%rsp)
  29c548:	xorps  %xmm4,%xmm2
  29c54b:	xorps  %xmm4,%xmm3
  29c54e:	movaps %xmm2,0x50(%rsp)
  29c553:	movaps %xmm3,0x60(%rsp)
  29c558:	movups 0x42dab1(%rip),%xmm0        # 6ca010 <encoding_rs::data::KSX1001_LOWERCASE+0x230>
  29c55f:	movaps %xmm0,0x110(%rsp)
  29c567:	movdqu 0x42da91(%rip),%xmm0        # 6ca000 <encoding_rs::data::KSX1001_LOWERCASE+0x220>
  29c56f:	movdqa %xmm0,0x100(%rsp)
  29c578:	movq   $0x1,0x120(%rsp)
  29c584:	lea    0x100(%rsp),%rdi
  29c58c:	lea    0x30(%rsp),%rsi
  29c591:	mov    $0x1,%edx
  29c596:	call   451c40 <sha2::sha256::compress256>
  29c59b:	movaps 0x42c7ce(%rip),%xmm0        # 6c8d70 <_fini+0x1c64>
  29c5a2:	movaps 0x30(%rsp),%xmm1
  29c5a7:	xorps  %xmm0,%xmm1
  29c5aa:	movaps 0x40(%rsp),%xmm2
  29c5af:	xorps  %xmm0,%xmm2
  29c5b2:	movaps %xmm1,0x30(%rsp)
  29c5b7:	movaps %xmm2,0x40(%rsp)
  29c5bc:	movaps 0x50(%rsp),%xmm1
  29c5c1:	xorps  %xmm0,%xmm1
  29c5c4:	xorps  0x60(%rsp),%xmm0
  29c5c9:	movaps %xmm1,0x50(%rsp)
  29c5ce:	movaps %xmm0,0x60(%rsp)
  29c5d3:	movups 0x42da36(%rip),%xmm0        # 6ca010 <encoding_rs::data::KSX1001_LOWERCASE+0x230>
  29c5da:	movaps %xmm0,0x1f0(%rsp)
  29c5e2:	movdqu 0x42da16(%rip),%xmm0        # 6ca000 <encoding_rs::data::KSX1001_LOWERCASE+0x220>
  29c5ea:	movdqa %xmm0,0x1e0(%rsp)
  29c5f3:	movq   $0x1,0x200(%rsp)
  29c5ff:	lea    0x1e0(%rsp),%rdi
  29c607:	lea    0x30(%rsp),%rsi
  29c60c:	mov    $0x1,%edx
  29c611:	call   451c40 <sha2::sha256::compress256>
  29c616:	mov    0x120(%rsp),%rax
  29c61e:	mov    %rax,0x1d0(%rsp)
  29c626:	movaps 0x100(%rsp),%xmm0
  29c62e:	movaps 0x110(%rsp),%xmm1
  29c636:	movaps %xmm1,0x1c0(%rsp)
  29c63e:	movaps %xmm0,0x1b0(%rsp)
  29c646:	movaps 0x1e0(%rsp),%xmm2
  29c64e:	movaps 0x1f0(%rsp),%xmm3
  29c656:	movups %xmm2,0x188(%rsp)
  29c65e:	movups %xmm3,0x198(%rsp)
  29c666:	mov    0x200(%rsp),%rcx
  29c66e:	mov    %rcx,0x1a8(%rsp)
  29c676:	movaps %xmm0,0x160(%rsp)
  29c67e:	movaps %xmm1,0x170(%rsp)
  29c686:	mov    %rax,0x180(%rsp)
  29c68e:	xorps  %xmm0,%xmm0
  29c691:	movups %xmm0,0xd8(%rsp)
  29c699:	movups %xmm0,0xc8(%rsp)
  29c6a1:	movups %xmm0,0xb8(%rsp)
  29c6a9:	movups %xmm0,0xa8(%rsp)
  29c6b1:	movb   $0x0,0xe8(%rsp)
  29c6b9:	mov    0x1d0(%rsp),%rax
  29c6c1:	mov    %rax,0xa0(%rsp)
  29c6c9:	movaps 0x1c0(%rsp),%xmm0
  29c6d1:	movaps %xmm0,0x90(%rsp)
  29c6d9:	movaps 0x1b0(%rsp),%xmm0
  29c6e1:	movaps %xmm0,0x80(%rsp)
  29c6e9:	mov    0x1a0(%rsp),%rax
  29c6f1:	mov    %rax,0x70(%rsp)
  29c6f6:	mov    0x1a8(%rsp),%rax
  29c6fe:	mov    %rax,0x78(%rsp)
  29c703:	movdqa 0x160(%rsp),%xmm0
  29c70c:	movaps 0x170(%rsp),%xmm1
  29c714:	movaps 0x180(%rsp),%xmm2
  29c71c:	movaps 0x190(%rsp),%xmm3
  29c724:	movaps %xmm3,0x60(%rsp)
  29c729:	movaps %xmm2,0x50(%rsp)
  29c72e:	movaps %xmm1,0x40(%rsp)
  29c733:	movdqa %xmm0,0x30(%rsp)
  29c739:	lea    0x1e0(%rsp),%rdi
  29c741:	lea    0x30(%rsp),%rsi
  29c746:	mov    $0xc0,%edx
  29c74b:	call   *0x5ed1a7(%rip)        # 8898f8 <memcpy@GLIBC_2.14>
  29c751:	lea    0x258(%rsp),%rbx
  29c759:	movzbl 0x298(%rsp),%r15d
  29c762:	mov    $0x40,%ebp
  29c767:	sub    %r15,%rbp
  29c76a:	mov    0x158(%rsp),%rdx
  29c772:	mov    %rdx,%r13
  29c775:	sub    %rbp,%r13
  29c778:	jae    29c791 <polymarket_client_sdk::auth::hmac+0x11d1>
  29c77a:	add    %r15,%rbx
  29c77d:	mov    %rbx,%rdi
  29c780:	mov    %r14,%rsi
  29c783:	mov    %rdx,%r13
  29c786:	call   *0x5ed16c(%rip)        # 8898f8 <memcpy@GLIBC_2.14>
  29c78c:	add    %r15,%r13
  29c78f:	jmp    29c80f <polymarket_client_sdk::auth::hmac+0x124f>
  29c791:	test   %r15,%r15
  29c794:	je     29c7ca <polymarket_client_sdk::auth::hmac+0x120a>
  29c796:	add    %rbx,%r15
  29c799:	mov    %r15,%rdi
  29c79c:	mov    %r14,%rsi
  29c79f:	mov    %rbp,%rdx
  29c7a2:	call   *0x5ed150(%rip)        # 8898f8 <memcpy@GLIBC_2.14>
  29c7a8:	incq   0x200(%rsp)
  29c7b0:	lea    0x1e0(%rsp),%rdi
  29c7b8:	mov    $0x1,%edx
  29c7bd:	mov    %rbx,%rsi
  29c7c0:	call   451c40 <sha2::sha256::compress256>
  29c7c5:	add    %rbp,%r14
  29c7c8:	jmp    29c7cd <polymarket_client_sdk::auth::hmac+0x120d>
  29c7ca:	mov    %rdx,%r13
  29c7cd:	cmp    $0x40,%r13
  29c7d1:	jb     29c7f2 <polymarket_client_sdk::auth::hmac+0x1232>
  29c7d3:	mov    %r13,%rdx
  29c7d6:	shr    $0x6,%rdx
  29c7da:	add    %rdx,0x200(%rsp)
  29c7e2:	lea    0x1e0(%rsp),%rdi
  29c7ea:	mov    %r14,%rsi
  29c7ed:	call   451c40 <sha2::sha256::compress256>
  29c7f2:	mov    %r13,%rax
  29c7f5:	and    $0xffffffffffffffc0,%rax
  29c7f9:	and    $0x3f,%r13d
  29c7fd:	add    %rax,%r14
  29c800:	mov    %rbx,%rdi
  29c803:	mov    %r14,%rsi
  29c806:	mov    %r13,%rdx
  29c809:	call   *0x5ed0e9(%rip)        # 8898f8 <memcpy@GLIBC_2.14>
  29c80f:	mov    %r13b,0x298(%rsp)
  29c817:	lea    0x30(%rsp),%r12
  29c81c:	lea    0x1e0(%rsp),%rsi
  29c824:	mov    $0xc0,%edx
  29c829:	mov    %r12,%rdi
  29c82c:	call   *0x5ed0c6(%rip)        # 8898f8 <memcpy@GLIBC_2.14>
  29c832:	pxor   %xmm0,%xmm0
  29c836:	movdqa %xmm0,0x2b0(%rsp)
  29c83f:	movdqa %xmm0,0x2a0(%rsp)
  29c848:	lea    0xa8(%rsp),%r15
  29c850:	movdqa %xmm0,0x110(%rsp)
  29c859:	movdqa %xmm0,0x100(%rsp)
  29c862:	lea    0x100(%rsp),%rdx
  29c86a:	mov    %r12,%rdi
  29c86d:	mov    %r15,%rsi
  29c870:	call   29cd60 <<digest::core_api::ct_variable::CtVariableCoreWrapper<T,OutSize,O> as digest::core_api::FixedOutputCore>::finalize_fixed_core>
  29c875:	mov    0x78(%rsp),%rax
  29c87a:	mov    %rax,0x180(%rsp)
  29c882:	movups 0x58(%rsp),%xmm0
  29c887:	movups 0x68(%rsp),%xmm1
  29c88c:	movaps %xmm1,0x170(%rsp)
  29c894:	movaps %xmm0,0x160(%rsp)
  29c89c:	movdqa 0x100(%rsp),%xmm0
  29c8a5:	movaps 0x110(%rsp),%xmm1
  29c8ad:	movups %xmm1,0x10(%r15)
  29c8b2:	movdqu %xmm0,(%r15)
  29c8b7:	movb   $0x20,0xe8(%rsp)
  29c8bf:	lea    0x160(%rsp),%rdi
  29c8c7:	lea    0x2a0(%rsp),%rdx
  29c8cf:	mov    %r15,%rsi
  29c8d2:	call   29cd60 <<digest::core_api::ct_variable::CtVariableCoreWrapper<T,OutSize,O> as digest::core_api::FixedOutputCore>::finalize_fixed_core>
  29c8d7:	movdqa 0x2a0(%rsp),%xmm0
  29c8e0:	movaps 0x2b0(%rsp),%xmm1
  29c8e8:	movdqa %xmm0,0x2c0(%rsp)
  29c8f1:	movaps %xmm1,0x2d0(%rsp)
  29c8f9:	movzbl 0x5ee388(%rip),%eax        # 88ac88 <__rust_no_alloc_shim_is_unstable>
  29c900:	mov    $0x2c,%edi
  29c905:	mov    $0x1,%esi
  29c90a:	call   *0x5ecf08(%rip)        # 889818 <calloc@GLIBC_2.2.5>
  29c910:	test   %rax,%rax
  29c913:	je     29cc9d <polymarket_client_sdk::auth::hmac+0x16dd>
  29c919:	mov    %rax,%r15
  29c91c:	lea    0x499da5(%rip),%rdi        # 7366c8 <mime::parse::TOKEN_MAP+0x1009>
  29c923:	lea    0x2c0(%rsp),%rsi
  29c92b:	mov    $0x20,%edx
  29c930:	mov    $0x2c,%r8d
  29c936:	mov    %rax,%rcx
  29c939:	mov    (%rsp),%rbx
  29c93d:	call   1b9fb0 <<base64::engine::general_purpose::GeneralPurpose as base64::engine::Engine>::internal_encode>
  29c942:	cmp    $0x2c,%rax
  29c946:	ja     29cbef <polymarket_client_sdk::auth::hmac+0x162f>
  29c94c:	mov    %eax,%ecx
  29c94e:	neg    %ecx
  29c950:	and    $0x3,%ecx
  29c953:	je     29c98e <polymarket_client_sdk::auth::hmac+0x13ce>
  29c955:	cmp    $0x2c,%rax
  29c959:	je     29cc84 <polymarket_client_sdk::auth::hmac+0x16c4>
  29c95f:	movb   $0x3d,(%r15,%rax,1)
  29c964:	cmp    $0x1,%ecx
  29c967:	je     29c98e <polymarket_client_sdk::auth::hmac+0x13ce>
  29c969:	cmp    $0x2b,%rax
  29c96d:	je     29cc84 <polymarket_client_sdk::auth::hmac+0x16c4>
  29c973:	movb   $0x3d,0x1(%r15,%rax,1)
  29c979:	cmp    $0x2,%ecx
  29c97c:	je     29c98e <polymarket_client_sdk::auth::hmac+0x13ce>
  29c97e:	cmp    $0x2a,%rax
  29c982:	je     29cc84 <polymarket_client_sdk::auth::hmac+0x16c4>
  29c988:	movb   $0x3d,0x2(%r15,%rax,1)
  29c98e:	lea    0x30(%rsp),%rdi
  29c993:	mov    $0x2c,%edx
  29c998:	mov    %r15,%rsi
  29c99b:	call   20f4d0 <core::str::converts::from_utf8>
  29c9a0:	cmpl   $0x1,0x30(%rsp)
  29c9a5:	je     29ccb5 <polymarket_client_sdk::auth::hmac+0x16f5>
  29c9ab:	mov    0xf8(%rsp),%rax
  29c9b3:	movq   $0x2c,0x8(%rax)
  29c9bb:	mov    %r15,0x10(%rax)
  29c9bf:	movq   $0x2c,0x18(%rax)
  29c9c7:	movq   $0x3,(%rax)
  29c9ce:	test   %rbx,%rbx
  29c9d1:	je     29c050 <polymarket_client_sdk::auth::hmac+0xa90>
  29c9d7:	mov    0x8(%rsp),%rdi
  29c9dc:	call   *0x5ed17e(%rip)        # 889b60 <free@GLIBC_2.2.5>
  29c9e2:	jmp    29c050 <polymarket_client_sdk::auth::hmac+0xa90>
  29c9e7:	mov    $0x2,%edi
  29c9ec:	mov    %r8,%r15
  29c9ef:	jmp    29bf4b <polymarket_client_sdk::auth::hmac+0x98b>
  29c9f4:	mov    $0x8,%edi
  29c9f9:	mov    $0x10,%esi
  29c9fe:	call   4a4ec <alloc::alloc::handle_alloc_error>
  29ca03:	lea    0x5d16d6(%rip),%rax        # 86e0e0 <aws_lc_0_37_1_kem_asn1_meth+0x6fe0>
  29ca0a:	jmp    29cac9 <polymarket_client_sdk::auth::hmac+0x1509>
  29ca0f:	mov    0x140(%rsp),%r8
  29ca17:	mov    0x10(%rsp),%rdx
  29ca1c:	lea    0x5d171d(%rip),%rax        # 86e140 <aws_lc_0_37_1_kem_asn1_meth+0x7040>
  29ca23:	jmp    29cac9 <polymarket_client_sdk::auth::hmac+0x1509>
  29ca28:	mov    $0x3,%r14d
  29ca2e:	xor    %r10d,%r10d
  29ca31:	mov    %r8d,%r15d
  29ca34:	jmp    29c079 <polymarket_client_sdk::auth::hmac+0xab9>
  29ca39:	mov    $0x2,%ebx
  29ca3e:	add    %r9,%rbx
  29ca41:	mov    $0x3d00,%r15d
  29ca47:	mov    %rbx,%r14
  29ca4a:	jmp    29bfda <polymarket_client_sdk::auth::hmac+0xa1a>
  29ca4f:	mov    %rdi,%rbp
  29ca52:	mov    $0x3,%edi
  29ca57:	mov    $0x4,%r11d
  29ca5d:	movzbl %r14b,%r15d
  29ca61:	movzbl 0x43(%r15,%r10,1),%r13d
  29ca67:	cmp    $0xff,%r13b
  29ca6b:	je     29bf4b <polymarket_client_sdk::auth::hmac+0x98b>
  29ca71:	mov    %r14d,%r15d
  29ca74:	mov    $0x4,%r14d
  29ca7a:	cmp    %rcx,%rbp
  29ca7d:	je     29caed <polymarket_client_sdk::auth::hmac+0x152d>
  29ca7f:	movzbl 0x0(%rbp),%r8d
  29ca84:	cmp    $0x3d,%r8b
  29ca88:	jne    29cb2f <polymarket_client_sdk::auth::hmac+0x156f>
  29ca8e:	mov    %ebx,0x18(%rsp)
  29ca92:	cmp    $0x2,%r11
  29ca96:	jae    29cb6d <polymarket_client_sdk::auth::hmac+0x15ad>
  29ca9c:	mov    (%rsp),%r13
  29caa0:	mov    %rsi,%r9
  29caa3:	mov    %r11,%r14
  29caa6:	jmp    29bcf1 <polymarket_client_sdk::auth::hmac+0x731>
  29caab:	lea    0x5d1646(%rip),%rdx        # 86e0f8 <aws_lc_0_37_1_kem_asn1_meth+0x6ff8>
  29cab2:	mov    %rax,%rdi
  29cab5:	call   4fa40 <core::slice::index::slice_index_order_fail>
  29caba:	jmp    29ccfc <polymarket_client_sdk::auth::hmac+0x173c>
  29cabf:	lea    0x5d164a(%rip),%rax        # 86e110 <aws_lc_0_37_1_kem_asn1_meth+0x7010>
  29cac6:	mov    %r12,%r8
  29cac9:	mov    %r8,%rdi
  29cacc:	mov    %rdx,%rsi
  29cacf:	mov    %rax,%rdx
  29cad2:	call   4f7d0 <core::slice::index::slice_end_index_len_fail>
  29cad7:	jmp    29ccfc <polymarket_client_sdk::auth::hmac+0x173c>
  29cadc:	mov    $0x3,%r14d
  29cae2:	xor    %r13d,%r13d
  29cae5:	mov    %r8d,%r15d
  29cae8:	jmp    29c07c <polymarket_client_sdk::auth::hmac+0xabc>
  29caed:	xor    %r10d,%r10d
  29caf0:	jmp    29c07c <polymarket_client_sdk::auth::hmac+0xabc>
  29caf5:	mov    %rdx,%r11
  29caf8:	mov    %rdi,%rdx
  29cafb:	add    $0xfffffffffffffffd,%rdx
  29caff:	mov    (%rsp),%r13
  29cb03:	jne    29ca3e <polymarket_client_sdk::auth::hmac+0x147e>
  29cb09:	mov    %r15,%r10
  29cb0c:	add    %rdi,%rbp
  29cb0f:	inc    %rbp
  29cb12:	mov    0x18(%rsp),%ebx
  29cb16:	movzbl %r14b,%r15d
  29cb1a:	movzbl 0x43(%r15,%r10,1),%r13d
  29cb20:	cmp    $0xff,%r13b
  29cb24:	jne    29ca71 <polymarket_client_sdk::auth::hmac+0x14b1>
  29cb2a:	jmp    29bf4b <polymarket_client_sdk::auth::hmac+0x98b>
  29cb2f:	mov    %r11,%rdi
  29cb32:	movzbl %r8b,%r15d
  29cb36:	cmpb   $0xff,0x43(%r15,%r10,1)
  29cb3c:	je     29bf4b <polymarket_client_sdk::auth::hmac+0x98b>
  29cb42:	lea    0x5d14f7(%rip),%rdx        # 86e040 <aws_lc_0_37_1_kem_asn1_meth+0x6f40>
  29cb49:	mov    $0x4,%edi
  29cb4e:	mov    $0x4,%esi
  29cb53:	mov    (%rsp),%r13
  29cb57:	call   4f6d1 <core::panicking::panic_bounds_check>
  29cb5c:	jmp    29ccfc <polymarket_client_sdk::auth::hmac+0x173c>
  29cb61:	xor    %r14d,%r14d
  29cb64:	mov    (%rsp),%r13
  29cb68:	jmp    29bcf1 <polymarket_client_sdk::auth::hmac+0x731>
  29cb6d:	mov    %rcx,%r10
  29cb70:	sub    %rbp,%r10
  29cb73:	lea    0x1(%rbp),%rdx
  29cb77:	cmp    %rcx,%rdx
  29cb7a:	je     29cbb5 <polymarket_client_sdk::auth::hmac+0x15f5>
  29cb7c:	mov    $0x1,%edx
  29cb81:	mov    %r11,%rbx
  29cb84:	mov    %rbp,%r8
  29cb87:	lea    (%r11,%rdx,1),%rdi
  29cb8b:	movzbl (%r8,%rdx,1),%r8d
  29cb90:	cmp    $0x3d,%r8b
  29cb94:	jne    29cbc1 <polymarket_client_sdk::auth::hmac+0x1601>
  29cb96:	cmp    $0x2,%rdi
  29cb9a:	jb     29cbdd <polymarket_client_sdk::auth::hmac+0x161d>
  29cb9c:	test   %rdx,%rdx
  29cb9f:	cmove  %rdi,%rbx
  29cba3:	mov    %rbp,%r8
  29cba6:	lea    (%rdx,%rbp,1),%rdi
  29cbaa:	inc    %rdi
  29cbad:	inc    %rdx
  29cbb0:	cmp    %rcx,%rdi
  29cbb3:	jne    29cb87 <polymarket_client_sdk::auth::hmac+0x15c7>
  29cbb5:	mov    %rsi,%r9
  29cbb8:	mov    0x18(%rsp),%ebx
  29cbbc:	jmp    29c07c <polymarket_client_sdk::auth::hmac+0xabc>
  29cbc1:	test   %rdx,%rdx
  29cbc4:	mov    (%rsp),%r13
  29cbc8:	mov    %rsi,%r9
  29cbcb:	lea    0x499af6(%rip),%r10        # 7366c8 <mime::parse::TOKEN_MAP+0x1009>
  29cbd2:	jne    29ca3e <polymarket_client_sdk::auth::hmac+0x147e>
  29cbd8:	jmp    29cb32 <polymarket_client_sdk::auth::hmac+0x1572>
  29cbdd:	mov    %r11,%r14
  29cbe0:	add    %rdx,%r14
  29cbe3:	mov    (%rsp),%r13
  29cbe7:	mov    %rsi,%r9
  29cbea:	jmp    29bcf1 <polymarket_client_sdk::auth::hmac+0x731>
  29cbef:	lea    0x5e0822(%rip),%rdx        # 87d418 <bytes::bytes::PROMOTABLE_ODD_VTABLE+0x8430>
  29cbf6:	mov    $0x2c,%esi
  29cbfb:	mov    %rax,%rdi
  29cbfe:	call   4f750 <core::slice::index::slice_start_index_len_fail>
  29cc03:	jmp    29ccfc <polymarket_client_sdk::auth::hmac+0x173c>
  29cc08:	xor    %r12d,%r12d
  29cc0b:	lea    0x5db1ae(%rip),%rdx        # 877dc0 <bytes::bytes::PROMOTABLE_ODD_VTABLE+0x2dd8>
  29cc12:	mov    %r12,%rdi
  29cc15:	mov    0x10(%rsp),%rsi
  29cc1a:	call   4a4d6 <alloc::raw_vec::handle_error>
  29cc1f:	lea    0x5db1b2(%rip),%rax        # 877dd8 <bytes::bytes::PROMOTABLE_ODD_VTABLE+0x2df0>
  29cc26:	mov    %rax,0x1e0(%rsp)
  29cc2e:	lea    -0x626f5(%rip),%rax        # 23a540 <<&T as core::fmt::Display>::fmt>
  29cc35:	mov    %rax,0x1e8(%rsp)
  29cc3d:	lea    0x5db1a4(%rip),%rax        # 877de8 <bytes::bytes::PROMOTABLE_ODD_VTABLE+0x2e00>
  29cc44:	mov    %rax,0x30(%rsp)
  29cc49:	movq   $0x1,0x38(%rsp)
  29cc52:	movq   $0x0,0x50(%rsp)
  29cc5b:	lea    0x1e0(%rsp),%rax
  29cc63:	mov    %rax,0x40(%rsp)
  29cc68:	movq   $0x1,0x48(%rsp)
  29cc71:	lea    0x5db180(%rip),%rsi        # 877df8 <bytes::bytes::PROMOTABLE_ODD_VTABLE+0x2e10>
  29cc78:	lea    0x30(%rsp),%rdi
  29cc7d:	call   4f730 <core::panicking::panic_fmt>
  29cc82:	jmp    29ccfc <polymarket_client_sdk::auth::hmac+0x173c>
  29cc84:	mov    $0x2c,%edi
  29cc89:	sub    %rax,%rdi
  29cc8c:	lea    0x5d13c5(%rip),%rdx        # 86e058 <aws_lc_0_37_1_kem_asn1_meth+0x6f58>
  29cc93:	mov    %rdi,%rsi
  29cc96:	call   4f6d1 <core::panicking::panic_bounds_check>
  29cc9b:	jmp    29ccfc <polymarket_client_sdk::auth::hmac+0x173c>
  29cc9d:	lea    0x5db16c(%rip),%rdx        # 877e10 <bytes::bytes::PROMOTABLE_ODD_VTABLE+0x2e28>
  29cca4:	mov    $0x1,%edi
  29cca9:	mov    $0x2c,%esi
  29ccae:	call   4a4d6 <alloc::raw_vec::handle_error>
  29ccb3:	jmp    29ccfc <polymarket_client_sdk::auth::hmac+0x173c>
  29ccb5:	movdqu 0x38(%rsp),%xmm0
  29ccbb:	movq   $0x2c,0x30(%rsp)
  29ccc4:	mov    %r15,0x38(%rsp)
  29ccc9:	movq   $0x2c,0x40(%rsp)
  29ccd2:	movdqu %xmm0,0x48(%rsp)
  29ccd8:	lea    0x499ed5(%rip),%rdi        # 736bb4 <mime::parse::TOKEN_MAP+0x14f5>
  29ccdf:	lea    0x5db0ba(%rip),%rcx        # 877da0 <bytes::bytes::PROMOTABLE_ODD_VTABLE+0x2db8>
  29cce6:	lea    0x5db13b(%rip),%r8        # 877e28 <bytes::bytes::PROMOTABLE_ODD_VTABLE+0x2e40>
  29cced:	lea    0x30(%rsp),%rdx
  29ccf2:	mov    $0xc,%esi
  29ccf7:	call   4fba0 <core::result::unwrap_failed>
  29ccfc:	ud2
  29ccfe:	mov    %rax,%r14
  29cd01:	cmpq   $0x0,0x30(%rsp)
  29cd07:	je     29cd3a <polymarket_client_sdk::auth::hmac+0x177a>
  29cd09:	mov    0x38(%rsp),%rdi
  29cd0e:	jmp    29cd34 <polymarket_client_sdk::auth::hmac+0x1774>
  29cd10:	mov    %rax,%r14
  29cd13:	jmp    29cd3a <polymarket_client_sdk::auth::hmac+0x177a>
  29cd15:	mov    %rax,%r14
  29cd18:	lea    0x5dad59(%rip),%rsi        # 877a78 <bytes::bytes::PROMOTABLE_ODD_VTABLE+0x2a90>
  29cd1f:	mov    %rbx,%rdi
  29cd22:	call   41f980 <core::ptr::drop_in_place<core::option::Option<alloc::boxed::Box<dyn rustls::crypto::ActiveKeyExchange>>>>
  29cd27:	jmp    29cd56 <polymarket_client_sdk::auth::hmac+0x1796>
  29cd29:	call   4fdd5 <core::panicking::panic_in_cleanup>
  29cd2e:	mov    %rax,%r14
  29cd31:	mov    %r15,%rdi
  29cd34:	call   *0x5ece26(%rip)        # 889b60 <free@GLIBC_2.2.5>
  29cd3a:	cmpq   $0x0,(%rsp)
  29cd3f:	jne    29cd4b <polymarket_client_sdk::auth::hmac+0x178b>
  29cd41:	jmp    29cd56 <polymarket_client_sdk::auth::hmac+0x1796>
  29cd43:	mov    %rax,%r14
  29cd46:	test   %r13,%r13
  29cd49:	je     29cd56 <polymarket_client_sdk::auth::hmac+0x1796>
  29cd4b:	mov    0x8(%rsp),%rdi
  29cd50:	call   *0x5ece0a(%rip)        # 889b60 <free@GLIBC_2.2.5>
  29cd56:	mov    %r14,%rdi
  29cd59:	call   4a180 <_Unwind_Resume@plt>
  29cd5e:	xchg   %ax,%ax
