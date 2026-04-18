
bot/bin/arbitrage_bot:     file format elf64-x86-64


Disassembly of section .text:

0000000000080430 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}>:
   80430:	push   %rbp
   80431:	push   %r15
   80433:	push   %r14
   80435:	push   %r13
   80437:	push   %r12
   80439:	push   %rbx
   8043a:	sub    $0x5d8,%rsp
   80441:	mov    %rdx,%r12
   80444:	mov    %rsi,%rbx
   80447:	mov    %rdi,%r14
   8044a:	movzbl 0x20(%rsi),%eax
   8044e:	lea    0x64a3c3(%rip),%rcx        # 6ca818 <encoding_rs::data::KSX1001_LOWERCASE+0xa38>
   80455:	movslq (%rcx,%rax,4),%rax
   80459:	add    %rcx,%rax
   8045c:	jmp    *%rax
   8045e:	mov    (%rbx),%rax
   80461:	movups (%rbx),%xmm0
   80464:	movups %xmm0,0x10(%rbx)
   80468:	mov    (%rax),%rcx
   8046b:	cmpb   $0x0,0xd8(%rcx)
   80472:	je     806e6 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x2b6>
   80478:	lea    0x28(%rbx),%rcx
   8047c:	mov    %rcx,0x10(%rsp)
   80481:	mov    %rax,0x28(%rbx)
   80485:	lea    0x798(%rbx),%rcx
   8048c:	mov    %rcx,(%rsp)
   80490:	movb   $0x0,0x798(%rbx)
   80497:	jmp    804c7 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x97>
   80499:	lea    0x798(%rbx),%rax
   804a0:	mov    %rax,(%rsp)
   804a4:	movzbl 0x798(%rbx),%eax
   804ab:	lea    0x28(%rbx),%r15
   804af:	lea    0x64a386(%rip),%rcx        # 6ca83c <encoding_rs::data::KSX1001_LOWERCASE+0xa5c>
   804b6:	movslq (%rcx,%rax,4),%rax
   804ba:	add    %rcx,%rax
   804bd:	jmp    *%rax
   804bf:	mov    %r15,0x10(%rsp)
   804c4:	mov    (%r15),%rax
   804c7:	mov    (%rax),%r15
   804ca:	add    $0x10,%r15
   804ce:	mov    %r15,0x788(%rbx)
   804d5:	lea    0x791(%rbx),%rax
   804dc:	mov    %rax,0x8(%rsp)
   804e1:	movb   $0x0,0x791(%rbx)
   804e8:	lea    0x30(%rbx),%rbp
   804ec:	movb   $0x0,0x790(%rbx)
   804f3:	movabs $0x101010101010101,%rax
   804fd:	mov    %rax,0x3a0(%rsp)
   80505:	movaps 0x648164(%rip),%xmm0        # 6c8670 <_fini+0x1564>
   8050c:	movaps %xmm0,0x390(%rsp)
   80514:	mov    %r15,0x360(%rsp)
   8051c:	lea    0x2b0d(%rip),%rax        # 83030 <<url::Url as core::fmt::Display>::fmt>
   80523:	mov    %rax,0x368(%rsp)
   8052b:	lea    0x7e9506(%rip),%rax        # 869a38 <aws_lc_0_37_1_kem_asn1_meth+0x2938>
   80532:	mov    %rax,0x210(%rsp)
   8053a:	movq   $0x2,0x218(%rsp)
   80546:	movq   $0x0,0x230(%rsp)
   80552:	lea    0x360(%rsp),%rax
   8055a:	mov    %rax,0x220(%rsp)
   80562:	movq   $0x1,0x228(%rsp)
   8056e:	lea    0x38(%rsp),%rdi
   80573:	lea    0x210(%rsp),%rsi
   8057b:	call   77f00 <alloc::fmt::format::format_inner>
   80580:	mov    %rbp,0x260(%rsp)
   80588:	mov    %r14,0x30(%rsp)
   8058d:	add    $0x118,%r15
   80594:	movups 0x38(%rsp),%xmm0
   80599:	movaps %xmm0,0x3c0(%rsp)
   805a1:	mov    0x48(%rsp),%rax
   805a6:	mov    %rax,0x3d0(%rsp)
   805ae:	mov    (%r15),%rsi
   805b1:	lea    0x100(%rsp),%rdi
   805b9:	lea    0x390(%rsp),%rdx
   805c1:	lea    0x3c0(%rsp),%rcx
   805c9:	call   148990 <reqwest::async_impl::client::Client::request>
   805ce:	mov    0x100(%rsp),%r14
   805d6:	mov    0x108(%rsp),%rbp
   805de:	lea    0x110(%rsp),%rsi
   805e6:	lea    0x268(%rsp),%rdi
   805ee:	mov    $0xf8,%edx
   805f3:	call   *0x8092ff(%rip)        # 8898f8 <memcpy@GLIBC_2.14>
   805f9:	mov    0x208(%rsp),%rax
   80601:	lock decq (%rax)
   80605:	jne    80614 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x1e4>
   80607:	mov    0x208(%rsp),%rdi
   8060f:	call   3b0cb0 <alloc::sync::Arc<T,A>::drop_slow>
   80614:	cmp    $0x2,%r14
   80618:	jne    8066d <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x23d>
   8061a:	lea    0x60(%rsp),%rdi
   8061f:	mov    %rbp,%rsi
   80622:	call   29d600 <<polymarket_client_sdk::error::Error as core::convert::From<reqwest::error::Error>>::from>
   80627:	mov    0x30(%rsp),%r14
   8062c:	jmp    8086a <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x43a>
   80631:	lea    0xd0(%rbx),%r13
   80638:	movzbl 0xd0(%rbx),%eax
   8063f:	lea    0x28(%rbx),%r15
   80643:	lea    0x64a1e2(%rip),%rcx        # 6ca82c <encoding_rs::data::KSX1001_LOWERCASE+0xa4c>
   8064a:	movslq (%rcx,%rax,4),%rax
   8064e:	add    %rcx,%rax
   80651:	jmp    *%rax
   80653:	mov    %r13,(%rsp)
   80657:	mov    %r15,0x8(%rsp)
   8065c:	mov    0x28(%rbx),%r13
   80660:	mov    0x30(%rbx),%rsi
   80664:	mov    0x38(%rbx),%r15
   80668:	jmp    80964 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x534>
   8066d:	lea    0x4e0(%rsp),%rdi
   80675:	lea    0x268(%rsp),%rsi
   8067d:	mov    0x809274(%rip),%r13        # 8898f8 <memcpy@GLIBC_2.14>
   80684:	mov    $0xf8,%edx
   80689:	call   *%r13
   8068c:	mov    %r14,0x4d0(%rsp)
   80694:	mov    %rbp,0x4d8(%rsp)
   8069c:	movb   $0x0,0x790(%rbx)
   806a3:	lea    0x4d0(%rsp),%rsi
   806ab:	mov    $0x108,%edx
   806b0:	mov    0x260(%rsp),%rbp
   806b8:	mov    %rbp,%rdi
   806bb:	call   *%r13
   806be:	movq   $0x3,0x138(%rbx)
   806c9:	mov    %r15,0x198(%rbx)
   806d0:	movb   $0x0,0x3c2(%rbx)
   806d7:	mov    0x30(%rsp),%r14
   806dc:	mov    0x10(%rsp),%r15
   806e1:	jmp    807b6 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x386>
   806e6:	lea    0x100(%rsp),%rdi
   806ee:	call   1c3770 <chrono::offset::utc::Utc::now>
   806f3:	mov    0x100(%rsp),%ecx
   806fa:	mov    0x104(%rsp),%eax
   80701:	mov    %ecx,%edi
   80703:	sar    $0xd,%edi
   80706:	lea    -0x1(%rdi),%esi
   80709:	xor    %edx,%edx
   8070b:	test   %edi,%edi
   8070d:	jg     80731 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x301>
   8070f:	mov    $0x1,%edx
   80714:	sub    %edi,%edx
   80716:	imul   $0x51eb851f,%rdx,%rdx
   8071d:	shr    $0x27,%rdx
   80721:	inc    %edx
   80723:	imul   $0x190,%edx,%edi
   80729:	add    %edi,%esi
   8072b:	imul   $0xfffdc54f,%edx,%edx
   80731:	movslq %esi,%rsi
   80734:	imul   $0x51eb851f,%rsi,%rdi
   8073b:	mov    %rdi,%r8
   8073e:	shr    $0x3f,%r8
   80742:	sar    $0x25,%rdi
   80746:	add    %r8d,%edi
   80749:	imul   $0x5b5,%esi,%esi
   8074f:	sar    $0x2,%esi
   80752:	shr    $0x4,%ecx
   80755:	and    $0x1ff,%ecx
   8075b:	add    %edx,%ecx
   8075d:	sub    %edi,%ecx
   8075f:	sar    $0x2,%edi
   80762:	add    %esi,%ecx
   80764:	add    %edi,%ecx
   80766:	add    $0xfff506c5,%ecx
   8076c:	movslq %ecx,%rcx
   8076f:	imul   $0x15180,%rcx,%r15
   80776:	add    %rax,%r15
   80779:	jmp    8092c <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x4fc>
   8077e:	lea    0x791(%rbx),%rax
   80785:	mov    %rax,0x8(%rsp)
   8078a:	movzbl 0x791(%rbx),%eax
   80791:	lea    0x30(%rbx),%rbp
   80795:	lea    0x64a0b0(%rip),%rcx        # 6ca84c <encoding_rs::data::KSX1001_LOWERCASE+0xa6c>
   8079c:	movslq (%rcx,%rax,4),%rax
   807a0:	add    %rcx,%rax
   807a3:	jmp    *%rax
   807a5:	mov    %r15,0x10(%rsp)
   807aa:	mov    0x788(%rbx),%r15
   807b1:	jmp    804ec <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0xbc>
   807b6:	lea    0x100(%rsp),%rdi
   807be:	mov    %rbp,%rsi
   807c1:	mov    %r12,%rdx
   807c4:	call   83050 <polymarket_client_sdk::request::{{closure}}>
   807c9:	cmpl   $0x4,0x100(%rsp)
   807d1:	jne    80818 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x3e8>
   807d3:	mov    0x8(%rsp),%rax
   807d8:	movb   $0x3,(%rax)
   807db:	jmp    808c6 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x496>
   807e0:	mov    0xc0(%rbx),%rsi
   807e7:	mov    0xc8(%rbx),%rax
   807ee:	lea    0x268(%rsp),%rdi
   807f6:	mov    %r12,%rdx
   807f9:	call   *0x18(%rax)
   807fc:	mov    0x268(%rsp),%r12
   80804:	cmp    $0x4,%r12
   80808:	jne    80ba8 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x778>
   8080e:	movb   $0x3,0x0(%r13)
   80813:	jmp    813dd <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0xfad>
   80818:	mov    0x140(%rsp),%rax
   80820:	mov    %rax,0xa0(%rsp)
   80828:	movups 0x100(%rsp),%xmm0
   80830:	movups 0x110(%rsp),%xmm1
   80838:	movups 0x120(%rsp),%xmm2
   80840:	movups 0x130(%rsp),%xmm3
   80848:	movaps %xmm3,0x90(%rsp)
   80850:	movaps %xmm2,0x80(%rsp)
   80858:	movaps %xmm1,0x70(%rsp)
   8085d:	movaps %xmm0,0x60(%rsp)
   80862:	mov    %rbp,%rdi
   80865:	call   81860 <core::ptr::drop_in_place<polymarket_client_sdk::request<polymarket_client_sdk::auth::Credentials>::{{closure}}>>
   8086a:	movb   $0x0,0x790(%rbx)
   80871:	mov    0x60(%rsp),%rbp
   80876:	mov    0x68(%rsp),%r15
   8087b:	movaps 0x70(%rsp),%xmm0
   80880:	movaps %xmm0,0xc0(%rsp)
   80888:	movaps 0x80(%rsp),%xmm0
   80890:	movaps %xmm0,0xd0(%rsp)
   80898:	movaps 0x90(%rsp),%xmm0
   808a0:	movaps %xmm0,0xe0(%rsp)
   808a8:	mov    0xa0(%rsp),%rax
   808b0:	mov    %rax,0xf0(%rsp)
   808b8:	mov    0x8(%rsp),%rax
   808bd:	movb   $0x1,(%rax)
   808c0:	cmp    $0x4,%rbp
   808c4:	jne    808db <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x4ab>
   808c6:	mov    (%rsp),%rax
   808ca:	movb   $0x3,(%rax)
   808cd:	movq   $0x4,(%r14)
   808d4:	mov    $0x3,%al
   808d6:	jmp    81492 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x1062>
   808db:	mov    0xf0(%rsp),%rax
   808e3:	mov    %rax,0x490(%rsp)
   808eb:	movaps 0xc0(%rsp),%xmm0
   808f3:	movaps 0xd0(%rsp),%xmm1
   808fb:	movaps 0xe0(%rsp),%xmm2
   80903:	movaps %xmm2,0x480(%rsp)
   8090b:	movaps %xmm1,0x470(%rsp)
   80913:	movaps %xmm0,0x460(%rsp)
   8091b:	mov    (%rsp),%rax
   8091f:	movb   $0x1,(%rax)
   80922:	cmp    $0x3,%rbp
   80926:	jne    80ca0 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x870>
   8092c:	mov    0x10(%rbx),%rax
   80930:	mov    0x18(%rbx),%rsi
   80934:	mov    $0xe0,%r13d
   8093a:	add    (%rax),%r13
   8093d:	lea    0x28(%rbx),%rax
   80941:	mov    %rax,0x8(%rsp)
   80946:	mov    %r13,0x28(%rbx)
   8094a:	mov    %rsi,0x30(%rbx)
   8094e:	mov    %r15,0x38(%rbx)
   80952:	lea    0xd0(%rbx),%rax
   80959:	mov    %rax,(%rsp)
   8095d:	movb   $0x0,0xd0(%rbx)
   80964:	mov    %r15,0x40(%rbx)
   80968:	lea    0x38(%rsp),%rdi
   8096d:	mov    %r15,%rdx
   80970:	call   29b250 <polymarket_client_sdk::auth::to_message>
   80975:	mov    0x40(%rsp),%r15
   8097a:	mov    0x48(%rsp),%r8
   8097f:	mov    0x0(%r13),%rsi
   80983:	mov    0x8(%r13),%rdx
   80987:	lea    0x268(%rsp),%rdi
   8098f:	mov    %r15,%rcx
   80992:	call   29b5c0 <polymarket_client_sdk::auth::hmac>
   80997:	mov    0x268(%rsp),%rbp
   8099f:	movups 0x270(%rsp),%xmm0
   809a7:	movaps %xmm0,0x240(%rsp)
   809af:	mov    0x280(%rsp),%rax
   809b7:	mov    %rax,0x250(%rsp)
   809bf:	cmp    $0x3,%rbp
   809c3:	jne    80b24 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x6f4>
   809c9:	mov    0x250(%rsp),%rax
   809d1:	mov    %rax,0x58(%rbx)
   809d5:	movaps 0x240(%rsp),%xmm0
   809dd:	movups %xmm0,0x48(%rbx)
   809e1:	cmpq   $0x0,0x38(%rsp)
   809e7:	je     809f2 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x5c2>
   809e9:	mov    %r15,%rdi
   809ec:	call   *0x80916e(%rip)        # 889b60 <free@GLIBC_2.2.5>
   809f2:	movw   $0x0,0xb8(%rbx)
   809fb:	movq   $0x2,0xa8(%rbx)
   80a06:	movq   $0x0,0xb0(%rbx)
   80a11:	movq   $0x0,0x78(%rbx)
   80a19:	movq   $0x8,0x80(%rbx)
   80a24:	xorps  %xmm0,%xmm0
   80a27:	movups %xmm0,0x88(%rbx)
   80a2e:	movq   $0x8,0x98(%rbx)
   80a39:	movq   $0x0,0xa0(%rbx)
   80a44:	movq   $0x0,0x60(%rbx)
   80a4c:	lea    0x30(%r13),%rsi
   80a50:	lea    0xa8(%rsp),%rdi
   80a58:	call   77260 <const_hex::encode_inner>
   80a5d:	mov    0xb0(%rsp),%r15
   80a65:	mov    0xb8(%rsp),%rdx
   80a6d:	test   %rdx,%rdx
   80a70:	je     80ceb <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x8bb>
   80a76:	xor    %eax,%eax
   80a78:	jmp    80a91 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x661>
   80a7a:	nopw   0x0(%rax,%rax,1)
   80a80:	cmp    $0x7f,%cl
   80a83:	je     80aa0 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x670>
   80a85:	inc    %rax
   80a88:	cmp    %rax,%rdx
   80a8b:	je     80d1a <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x8ea>
   80a91:	movzbl (%r15,%rax,1),%ecx
   80a96:	cmp    $0x1f,%cl
   80a99:	ja     80a80 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x650>
   80a9b:	cmp    $0x9,%cl
   80a9e:	je     80a85 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x655>
   80aa0:	lea    0x268(%rsp),%rdi
   80aa8:	call   4860e0 <std::backtrace::Backtrace::capture>
   80aad:	movb   $0x3,0x148(%rsp)
   80ab5:	movq   $0x1,0x138(%rsp)
   80ac1:	lea    0x7f7170(%rip),%rax        # 877c38 <bytes::bytes::PROMOTABLE_ODD_VTABLE+0x2c50>
   80ac8:	mov    %rax,0x140(%rsp)
   80ad0:	movups 0x268(%rsp),%xmm0
   80ad8:	movups 0x278(%rsp),%xmm1
   80ae0:	movups 0x288(%rsp),%xmm2
   80ae8:	movups %xmm0,0x108(%rsp)
   80af0:	movups %xmm1,0x118(%rsp)
   80af8:	movups %xmm2,0x128(%rsp)
   80b00:	movq   $0x3,0x100(%rsp)
   80b0c:	cmpq   $0x0,0xa8(%rsp)
   80b15:	mov    (%rsp),%r13
   80b19:	jne    80eb9 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0xa89>
   80b1f:	jmp    81350 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0xf20>
   80b24:	mov    0x2a8(%rsp),%rax
   80b2c:	mov    %rax,0x148(%rsp)
   80b34:	movups 0x288(%rsp),%xmm0
   80b3c:	movups 0x298(%rsp),%xmm1
   80b44:	movups %xmm1,0x138(%rsp)
   80b4c:	movups %xmm0,0x128(%rsp)
   80b54:	movaps 0x240(%rsp),%xmm0
   80b5c:	movups %xmm0,0x110(%rsp)
   80b64:	mov    0x250(%rsp),%rax
   80b6c:	mov    %rax,0x120(%rsp)
   80b74:	mov    %rbp,0x108(%rsp)
   80b7c:	movq   $0x3,0x100(%rsp)
   80b88:	cmpq   $0x0,0x38(%rsp)
   80b8e:	je     80b99 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x769>
   80b90:	mov    %r15,%rdi
   80b93:	call   *0x808fc7(%rip)        # 889b60 <free@GLIBC_2.2.5>
   80b99:	mov    $0x3,%r12d
   80b9f:	mov    (%rsp),%r13
   80ba3:	jmp    8137a <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0xf4a>
   80ba8:	mov    %r13,(%rsp)
   80bac:	mov    %r15,0x8(%rsp)
   80bb1:	mov    0x2b0(%rsp),%rax
   80bb9:	mov    %rax,0xa0(%rsp)
   80bc1:	movups 0x270(%rsp),%xmm0
   80bc9:	movups 0x280(%rsp),%xmm1
   80bd1:	movups 0x290(%rsp),%xmm2
   80bd9:	movups 0x2a0(%rsp),%xmm3
   80be1:	movaps %xmm3,0x90(%rsp)
   80be9:	movaps %xmm2,0x80(%rsp)
   80bf1:	movaps %xmm1,0x70(%rsp)
   80bf6:	movaps %xmm0,0x60(%rsp)
   80bfb:	movups 0x2b8(%rsp),%xmm0
   80c03:	movaps %xmm0,0x4c0(%rsp)
   80c0b:	mov    0xc0(%rbx),%r15
   80c12:	mov    0xc8(%rbx),%r13
   80c19:	mov    0x0(%r13),%rax
   80c1d:	test   %rax,%rax
   80c20:	je     80c27 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x7f7>
   80c22:	mov    %r15,%rdi
   80c25:	call   *%rax
   80c27:	cmpq   $0x0,0x8(%r13)
   80c2c:	je     80c37 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x807>
   80c2e:	mov    %r15,%rdi
   80c31:	call   *0x808f29(%rip)        # 889b60 <free@GLIBC_2.2.5>
   80c37:	cmp    $0x3,%r12d
   80c3b:	mov    (%rsp),%r13
   80c3f:	jne    80ef9 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0xac9>
   80c45:	mov    0xa0(%rsp),%rax
   80c4d:	mov    %rax,0x148(%rsp)
   80c55:	movaps 0x60(%rsp),%xmm0
   80c5a:	movaps 0x70(%rsp),%xmm1
   80c5f:	movaps 0x80(%rsp),%xmm2
   80c67:	movaps 0x90(%rsp),%xmm3
   80c6f:	movups %xmm3,0x138(%rsp)
   80c77:	movups %xmm2,0x128(%rsp)
   80c7f:	movups %xmm1,0x118(%rsp)
   80c87:	movups %xmm0,0x108(%rsp)
   80c8f:	movq   $0x3,0x100(%rsp)
   80c9b:	jmp    81350 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0xf20>
   80ca0:	mov    0x490(%rsp),%rax
   80ca8:	mov    %rax,0x420(%rsp)
   80cb0:	movaps 0x460(%rsp),%xmm0
   80cb8:	movaps 0x470(%rsp),%xmm1
   80cc0:	movaps 0x480(%rsp),%xmm2
   80cc8:	movaps %xmm2,0x410(%rsp)
   80cd0:	movaps %xmm1,0x400(%rsp)
   80cd8:	movaps %xmm0,0x3f0(%rsp)
   80ce0:	mov    $0x3,%r12d
   80ce6:	jmp    81445 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x1015>
   80ceb:	movq   $0x0,0x18(%rsp)
   80cf4:	movq   $0x1,0x20(%rsp)
   80cfd:	movq   $0x0,0x28(%rsp)
   80d06:	lea    0x268(%rsp),%rdi
   80d0e:	lea    0x18(%rsp),%rsi
   80d13:	call   1bb1e0 <<bytes::bytes::Bytes as core::convert::From<alloc::vec::Vec<u8>>>::from>
   80d18:	jmp    80d2a <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x8fa>
   80d1a:	lea    0x268(%rsp),%rdi
   80d22:	mov    %r15,%rsi
   80d25:	call   1bb140 <bytes::bytes::Bytes::copy_from_slice>
   80d2a:	lea    0x60(%rbx),%rsi
   80d2e:	movups 0x268(%rsp),%xmm0
   80d36:	movups 0x278(%rsp),%xmm1
   80d3e:	movaps %xmm1,0x440(%rsp)
   80d46:	movaps %xmm0,0x430(%rsp)
   80d4e:	mov    0x289(%rsp),%eax
   80d55:	mov    %eax,0x451(%rsp)
   80d5c:	mov    0x28c(%rsp),%eax
   80d63:	mov    %eax,0x454(%rsp)
   80d6a:	movb   $0x0,0x450(%rsp)
   80d72:	lea    0x659a19(%rip),%rdx        # 6da792 <encoding_rs::data::KSX1001_LOWERCASE+0x109b2>
   80d79:	lea    0x38(%rsp),%rdi
   80d7e:	lea    0x430(%rsp),%r8
   80d86:	mov    $0xc,%ecx
   80d8b:	mov    %rsi,0x30(%rsp)
   80d90:	call   18f4d0 <http::header::map::HeaderMap<T>::insert>
   80d95:	cmpb   $0x2,0x58(%rsp)
   80d9a:	je     80db3 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x983>
   80d9c:	mov    0x38(%rsp),%rax
   80da1:	mov    0x40(%rsp),%rsi
   80da6:	lea    0x50(%rsp),%rdi
   80dab:	mov    0x48(%rsp),%rdx
   80db0:	call   *0x20(%rax)
   80db3:	cmpq   $0x0,0xa8(%rsp)
   80dbc:	je     80dc7 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x997>
   80dbe:	mov    %r15,%rdi
   80dc1:	call   *0x808d99(%rip)        # 889b60 <free@GLIBC_2.2.5>
   80dc7:	lea    0x20(%r13),%rdi
   80dcb:	movq   $0x0,0x18(%rsp)
   80dd4:	movq   $0x1,0x20(%rsp)
   80ddd:	movq   $0x0,0x28(%rsp)
   80de6:	lea    0x7e6d73(%rip),%rdx        # 867b60 <aws_lc_0_37_1_kem_asn1_meth+0xa60>
   80ded:	lea    0x18(%rsp),%rsi
   80df2:	call   4bf380 <uuid::fmt::<impl core::fmt::Display for uuid::Uuid>::fmt>
   80df7:	test   %al,%al
   80df9:	jne    81572 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x1142>
   80dff:	mov    0x18(%rsp),%rbp
   80e04:	mov    0x20(%rsp),%r15
   80e09:	mov    0x28(%rsp),%rdx
   80e0e:	test   %rdx,%rdx
   80e11:	je     80ec7 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0xa97>
   80e17:	xor    %eax,%eax
   80e19:	jmp    80e31 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0xa01>
   80e1b:	nopl   0x0(%rax,%rax,1)
   80e20:	cmp    $0x7f,%cl
   80e23:	je     80e40 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0xa10>
   80e25:	inc    %rax
   80e28:	cmp    %rax,%rdx
   80e2b:	je     80fc1 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0xb91>
   80e31:	movzbl (%r15,%rax,1),%ecx
   80e36:	cmp    $0x1f,%cl
   80e39:	ja     80e20 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x9f0>
   80e3b:	cmp    $0x9,%cl
   80e3e:	je     80e25 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x9f5>
   80e40:	lea    0x268(%rsp),%rdi
   80e48:	call   4860e0 <std::backtrace::Backtrace::capture>
   80e4d:	movb   $0x3,0x148(%rsp)
   80e55:	movq   $0x1,0x138(%rsp)
   80e61:	lea    0x7f6dd0(%rip),%rax        # 877c38 <bytes::bytes::PROMOTABLE_ODD_VTABLE+0x2c50>
   80e68:	mov    %rax,0x140(%rsp)
   80e70:	movups 0x268(%rsp),%xmm0
   80e78:	movups 0x278(%rsp),%xmm1
   80e80:	movups 0x288(%rsp),%xmm2
   80e88:	movups %xmm0,0x108(%rsp)
   80e90:	movups %xmm1,0x118(%rsp)
   80e98:	movups %xmm2,0x128(%rsp)
   80ea0:	movq   $0x3,0x100(%rsp)
   80eac:	test   %rbp,%rbp
   80eaf:	mov    (%rsp),%r13
   80eb3:	je     81350 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0xf20>
   80eb9:	mov    %r15,%rdi
   80ebc:	call   *0x808c9e(%rip)        # 889b60 <free@GLIBC_2.2.5>
   80ec2:	jmp    81350 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0xf20>
   80ec7:	movq   $0x0,0x18(%rsp)
   80ed0:	movq   $0x1,0x20(%rsp)
   80ed9:	movq   $0x0,0x28(%rsp)
   80ee2:	lea    0x268(%rsp),%rdi
   80eea:	lea    0x18(%rsp),%rsi
   80eef:	call   1bb1e0 <<bytes::bytes::Bytes as core::convert::From<alloc::vec::Vec<u8>>>::from>
   80ef4:	jmp    80fd1 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0xba1>
   80ef9:	movaps 0x4c0(%rsp),%xmm0
   80f01:	movups %xmm0,0x520(%rsp)
   80f09:	mov    %r12,0x4d0(%rsp)
   80f11:	movaps 0x60(%rsp),%xmm0
   80f16:	movaps 0x70(%rsp),%xmm1
   80f1b:	movaps 0x80(%rsp),%xmm2
   80f23:	movaps 0x90(%rsp),%xmm3
   80f2b:	movups %xmm0,0x4d8(%rsp)
   80f33:	movups %xmm1,0x4e8(%rsp)
   80f3b:	movups %xmm2,0x4f8(%rsp)
   80f43:	movups %xmm3,0x508(%rsp)
   80f4b:	mov    0xa0(%rsp),%rax
   80f53:	mov    %rax,0x518(%rsp)
   80f5b:	lea    0x60(%rbx),%r15
   80f5f:	lea    0x4d0(%rsp),%rsi
   80f67:	mov    %r15,%rdi
   80f6a:	call   188320 <<http::header::map::HeaderMap<T> as core::iter::traits::collect::Extend<(core::option::Option<http::header::name::HeaderName>,T)>>::extend>
   80f6f:	movups 0x50(%r15),%xmm0
   80f74:	movaps %xmm0,0x150(%rsp)
   80f7c:	movups 0x40(%r15),%xmm0
   80f81:	movaps %xmm0,0x140(%rsp)
   80f89:	movups (%r15),%xmm0
   80f8d:	movups 0x10(%r15),%xmm1
   80f92:	movups 0x20(%r15),%xmm2
   80f97:	movups 0x30(%r15),%xmm3
   80f9c:	movaps %xmm3,0x130(%rsp)
   80fa4:	movaps %xmm2,0x120(%rsp)
   80fac:	movaps %xmm1,0x110(%rsp)
   80fb4:	movaps %xmm0,0x100(%rsp)
   80fbc:	jmp    81359 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0xf29>
   80fc1:	lea    0x268(%rsp),%rdi
   80fc9:	mov    %r15,%rsi
   80fcc:	call   1bb140 <bytes::bytes::Bytes::copy_from_slice>
   80fd1:	movups 0x268(%rsp),%xmm0
   80fd9:	movups 0x278(%rsp),%xmm1
   80fe1:	movaps %xmm1,0x370(%rsp)
   80fe9:	movaps %xmm0,0x360(%rsp)
   80ff1:	mov    0x289(%rsp),%eax
   80ff8:	mov    %eax,0x381(%rsp)
   80fff:	mov    0x28c(%rsp),%eax
   81006:	mov    %eax,0x384(%rsp)
   8100d:	movb   $0x0,0x380(%rsp)
   81015:	lea    0x6597a8(%rip),%rdx        # 6da7c4 <encoding_rs::data::KSX1001_LOWERCASE+0x109e4>
   8101c:	lea    0x38(%rsp),%rdi
   81021:	lea    0x360(%rsp),%r8
   81029:	mov    $0xc,%ecx
   8102e:	mov    0x30(%rsp),%rsi
   81033:	call   18f4d0 <http::header::map::HeaderMap<T>::insert>
   81038:	cmpb   $0x2,0x58(%rsp)
   8103d:	je     81056 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0xc26>
   8103f:	mov    0x38(%rsp),%rax
   81044:	mov    0x40(%rsp),%rsi
   81049:	lea    0x50(%rsp),%rdi
   8104e:	mov    0x48(%rsp),%rdx
   81053:	call   *0x20(%rax)
   81056:	test   %rbp,%rbp
   81059:	je     81064 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0xc34>
   8105b:	mov    %r15,%rdi
   8105e:	call   *0x808afc(%rip)        # 889b60 <free@GLIBC_2.2.5>
   81064:	mov    0x18(%r13),%rdx
   81068:	test   %rdx,%rdx
   8106b:	je     81110 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0xce0>
   81071:	mov    0x10(%r13),%rsi
   81075:	xor    %eax,%eax
   81077:	jmp    81091 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0xc61>
   81079:	nopl   0x0(%rax)
   81080:	cmp    $0x7f,%cl
   81083:	je     8109f <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0xc6f>
   81085:	inc    %rax
   81088:	cmp    %rax,%rdx
   8108b:	je     8113f <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0xd0f>
   81091:	movzbl (%rsi,%rax,1),%ecx
   81095:	cmp    $0x1f,%cl
   81098:	ja     81080 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0xc50>
   8109a:	cmp    $0x9,%cl
   8109d:	je     81085 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0xc55>
   8109f:	lea    0x268(%rsp),%rdi
   810a7:	call   4860e0 <std::backtrace::Backtrace::capture>
   810ac:	movb   $0x3,0x148(%rsp)
   810b4:	movq   $0x1,0x138(%rsp)
   810c0:	lea    0x7f6b71(%rip),%rax        # 877c38 <bytes::bytes::PROMOTABLE_ODD_VTABLE+0x2c50>
   810c7:	mov    %rax,0x140(%rsp)
   810cf:	movups 0x268(%rsp),%xmm0
   810d7:	movups 0x278(%rsp),%xmm1
   810df:	movups 0x288(%rsp),%xmm2
   810e7:	movups %xmm0,0x108(%rsp)
   810ef:	movups %xmm1,0x118(%rsp)
   810f7:	movups %xmm2,0x128(%rsp)
   810ff:	movq   $0x3,0x100(%rsp)
   8110b:	jmp    8134c <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0xf1c>
   81110:	movq   $0x0,0x18(%rsp)
   81119:	movq   $0x1,0x20(%rsp)
   81122:	movq   $0x0,0x28(%rsp)
   8112b:	lea    0x268(%rsp),%rdi
   81133:	lea    0x18(%rsp),%rsi
   81138:	call   1bb1e0 <<bytes::bytes::Bytes as core::convert::From<alloc::vec::Vec<u8>>>::from>
   8113d:	jmp    8114c <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0xd1c>
   8113f:	lea    0x268(%rsp),%rdi
   81147:	call   1bb140 <bytes::bytes::Bytes::copy_from_slice>
   8114c:	movups 0x268(%rsp),%xmm0
   81154:	movups 0x278(%rsp),%xmm1
   8115c:	movaps %xmm1,0x3a0(%rsp)
   81164:	movaps %xmm0,0x390(%rsp)
   8116c:	mov    0x289(%rsp),%eax
   81173:	mov    %eax,0x3b1(%rsp)
   8117a:	mov    0x28c(%rsp),%eax
   81181:	mov    %eax,0x3b4(%rsp)
   81188:	movb   $0x0,0x3b0(%rsp)
   81190:	lea    0x659639(%rip),%rdx        # 6da7d0 <encoding_rs::data::KSX1001_LOWERCASE+0x109f0>
   81197:	lea    0x38(%rsp),%rdi
   8119c:	lea    0x390(%rsp),%r8
   811a4:	mov    $0xf,%ecx
   811a9:	mov    0x30(%rsp),%rsi
   811ae:	call   18f4d0 <http::header::map::HeaderMap<T>::insert>
   811b3:	cmpb   $0x2,0x58(%rsp)
   811b8:	je     811d1 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0xda1>
   811ba:	mov    0x38(%rsp),%rax
   811bf:	mov    0x40(%rsp),%rsi
   811c4:	lea    0x50(%rsp),%rdi
   811c9:	mov    0x48(%rsp),%rdx
   811ce:	call   *0x20(%rax)
   811d1:	mov    0x58(%rbx),%rdx
   811d5:	test   %rdx,%rdx
   811d8:	je     81229 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0xdf9>
   811da:	mov    0x50(%rbx),%rsi
   811de:	xor    %eax,%eax
   811e0:	jmp    811fd <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0xdcd>
   811e2:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   811f0:	cmp    $0x7f,%cl
   811f3:	je     8120b <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0xddb>
   811f5:	inc    %rax
   811f8:	cmp    %rax,%rdx
   811fb:	je     81258 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0xe28>
   811fd:	movzbl (%rsi,%rax,1),%ecx
   81201:	cmp    $0x1f,%cl
   81204:	ja     811f0 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0xdc0>
   81206:	cmp    $0x9,%cl
   81209:	je     811f5 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0xdc5>
   8120b:	lea    0x108(%rsp),%rdi
   81213:	call   29d790 <<polymarket_client_sdk::error::Error as core::convert::From<http::header::value::InvalidHeaderValue>>::from>
   81218:	movq   $0x3,0x100(%rsp)
   81224:	jmp    8134c <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0xf1c>
   81229:	movq   $0x0,0x18(%rsp)
   81232:	movq   $0x1,0x20(%rsp)
   8123b:	movq   $0x0,0x28(%rsp)
   81244:	lea    0x268(%rsp),%rdi
   8124c:	lea    0x18(%rsp),%rsi
   81251:	call   1bb1e0 <<bytes::bytes::Bytes as core::convert::From<alloc::vec::Vec<u8>>>::from>
   81256:	jmp    81265 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0xe35>
   81258:	lea    0x268(%rsp),%rdi
   81260:	call   1bb140 <bytes::bytes::Bytes::copy_from_slice>
   81265:	movups 0x268(%rsp),%xmm0
   8126d:	movups 0x278(%rsp),%xmm1
   81275:	movaps %xmm1,0x3d0(%rsp)
   8127d:	movaps %xmm0,0x3c0(%rsp)
   81285:	mov    0x289(%rsp),%eax
   8128c:	mov    %eax,0x3e1(%rsp)
   81293:	mov    0x28c(%rsp),%eax
   8129a:	mov    %eax,0x3e4(%rsp)
   812a1:	movb   $0x0,0x3e0(%rsp)
   812a9:	lea    0x6594f8(%rip),%rdx        # 6da7a8 <encoding_rs::data::KSX1001_LOWERCASE+0x109c8>
   812b0:	lea    0x38(%rsp),%rdi
   812b5:	lea    0x3c0(%rsp),%r8
   812bd:	mov    $0xe,%ecx
   812c2:	mov    0x30(%rsp),%rsi
   812c7:	call   18f4d0 <http::header::map::HeaderMap<T>::insert>
   812cc:	cmpb   $0x2,0x58(%rsp)
   812d1:	je     812ea <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0xeba>
   812d3:	mov    0x38(%rsp),%rax
   812d8:	mov    0x40(%rsp),%rsi
   812dd:	lea    0x50(%rsp),%rdi
   812e2:	mov    0x48(%rsp),%rdx
   812e7:	call   *0x20(%rax)
   812ea:	mov    0x40(%rbx),%rsi
   812ee:	lea    0x18(%rsp),%rdi
   812f3:	call   83be0 <<T as alloc::string::ToString>::to_string>
   812f8:	mov    0x20(%rsp),%r15
   812fd:	mov    0x28(%rsp),%rdx
   81302:	lea    0x268(%rsp),%rdi
   8130a:	mov    %r15,%rsi
   8130d:	call   1b6350 <http::header::value::HeaderValue::try_from_generic>
   81312:	movzbl 0x288(%rsp),%eax
   8131a:	cmp    $0x2,%al
   8131c:	jne    814a7 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x1077>
   81322:	lea    0x108(%rsp),%rdi
   8132a:	call   29d790 <<polymarket_client_sdk::error::Error as core::convert::From<http::header::value::InvalidHeaderValue>>::from>
   8132f:	movq   $0x3,0x100(%rsp)
   8133b:	cmpq   $0x0,0x18(%rsp)
   81341:	je     8134c <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0xf1c>
   81343:	mov    %r15,%rdi
   81346:	call   *0x808814(%rip)        # 889b60 <free@GLIBC_2.2.5>
   8134c:	mov    (%rsp),%r13
   81350:	lea    0x60(%rbx),%rdi
   81354:	call   6bbe0 <core::ptr::drop_in_place<http::header::map::HeaderMap>>
   81359:	cmpq   $0x0,0x48(%rbx)
   8135e:	je     8136a <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0xf3a>
   81360:	mov    0x50(%rbx),%rdi
   81364:	call   *0x8087f6(%rip)        # 889b60 <free@GLIBC_2.2.5>
   8136a:	mov    0x100(%rsp),%r12
   81372:	mov    0x108(%rsp),%rbp
   8137a:	mov    0x110(%rsp),%r15
   81382:	movups 0x118(%rsp),%xmm0
   8138a:	movaps %xmm0,0xc0(%rsp)
   81392:	movups 0x128(%rsp),%xmm0
   8139a:	movaps %xmm0,0xd0(%rsp)
   813a2:	movups 0x138(%rsp),%xmm0
   813aa:	movaps %xmm0,0xe0(%rsp)
   813b2:	mov    0x148(%rsp),%rax
   813ba:	mov    %rax,0xf0(%rsp)
   813c2:	movaps 0x150(%rsp),%xmm0
   813ca:	movaps %xmm0,0x4a0(%rsp)
   813d2:	movb   $0x1,0x0(%r13)
   813d7:	cmp    $0x4,%r12
   813db:	jne    813eb <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0xfbb>
   813dd:	movq   $0x4,(%r14)
   813e4:	mov    $0x4,%al
   813e6:	jmp    81492 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x1062>
   813eb:	mov    0xf0(%rsp),%rax
   813f3:	mov    %rax,0x420(%rsp)
   813fb:	movaps 0xc0(%rsp),%xmm0
   81403:	movaps 0xd0(%rsp),%xmm1
   8140b:	movaps 0xe0(%rsp),%xmm2
   81413:	movaps %xmm2,0x410(%rsp)
   8141b:	movaps %xmm1,0x400(%rsp)
   81423:	movaps %xmm0,0x3f0(%rsp)
   8142b:	movaps 0x4a0(%rsp),%xmm0
   81433:	movaps %xmm0,0x4b0(%rsp)
   8143b:	mov    0x8(%rsp),%rdi
   81440:	call   81aa0 <core::ptr::drop_in_place<polymarket_client_sdk::auth::l2::create_headers<polymarket_client_sdk::auth::Normal>::{{closure}}>>
   81445:	mov    %r12,(%r14)
   81448:	mov    %rbp,0x8(%r14)
   8144c:	mov    %r15,0x10(%r14)
   81450:	movaps 0x3f0(%rsp),%xmm0
   81458:	movaps 0x400(%rsp),%xmm1
   81460:	movaps 0x410(%rsp),%xmm2
   81468:	movups %xmm0,0x18(%r14)
   8146d:	movups %xmm1,0x28(%r14)
   81472:	movups %xmm2,0x38(%r14)
   81477:	mov    0x420(%rsp),%rax
   8147f:	mov    %rax,0x48(%r14)
   81483:	movaps 0x4b0(%rsp),%xmm0
   8148b:	movups %xmm0,0x50(%r14)
   81490:	mov    $0x1,%al
   81492:	mov    %al,0x20(%rbx)
   81495:	add    $0x5d8,%rsp
   8149c:	pop    %rbx
   8149d:	pop    %r12
   8149f:	pop    %r13
   814a1:	pop    %r14
   814a3:	pop    %r15
   814a5:	pop    %rbp
   814a6:	ret
   814a7:	movups 0x268(%rsp),%xmm0
   814af:	movups 0x278(%rsp),%xmm1
   814b7:	movaps %xmm1,0x220(%rsp)
   814bf:	movaps %xmm0,0x210(%rsp)
   814c7:	mov    0x289(%rsp),%ecx
   814ce:	mov    %ecx,0x231(%rsp)
   814d5:	mov    0x28c(%rsp),%ecx
   814dc:	mov    %ecx,0x234(%rsp)
   814e3:	mov    %al,0x230(%rsp)
   814ea:	lea    0x6592c5(%rip),%rdx        # 6da7b6 <encoding_rs::data::KSX1001_LOWERCASE+0x109d6>
   814f1:	lea    0x38(%rsp),%rdi
   814f6:	lea    0x210(%rsp),%r8
   814fe:	mov    $0xe,%ecx
   81503:	mov    0x30(%rsp),%rsi
   81508:	call   18f4d0 <http::header::map::HeaderMap<T>::insert>
   8150d:	cmpb   $0x2,0x58(%rsp)
   81512:	je     8152b <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x10fb>
   81514:	mov    0x38(%rsp),%rax
   81519:	mov    0x40(%rsp),%rsi
   8151e:	lea    0x50(%rsp),%rdi
   81523:	mov    0x48(%rsp),%rdx
   81528:	call   *0x20(%rax)
   8152b:	cmpq   $0x0,0x18(%rsp)
   81531:	je     8153c <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x110c>
   81533:	mov    %r15,%rdi
   81536:	call   *0x808624(%rip)        # 889b60 <free@GLIBC_2.2.5>
   8153c:	add    $0x44,%r13
   81540:	mov    0x40(%rbx),%rsi
   81544:	mov    %r13,%rdi
   81547:	call   29ce80 <<polymarket_client_sdk::auth::Normal as polymarket_client_sdk::auth::Kind>::extra_headers>
   8154c:	mov    %rax,%rsi
   8154f:	mov    %rax,0xc0(%rbx)
   81556:	lea    0x7f62e3(%rip),%rax        # 877840 <bytes::bytes::PROMOTABLE_ODD_VTABLE+0x2858>
   8155d:	mov    %rax,0xc8(%rbx)
   81564:	mov    0x8(%rsp),%r15
   81569:	mov    (%rsp),%r13
   8156d:	jmp    807ee <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x3be>
   81572:	lea    0x6c4684(%rip),%rdi        # 745bfd <serde_json::value::index::<impl core::ops::index::Index<I> for serde_json::value::Value>::index::NULL+0x44bd>
   81579:	lea    0x7e6610(%rip),%rcx        # 867b90 <aws_lc_0_37_1_kem_asn1_meth+0xa90>
   81580:	lea    0x805201(%rip),%r8        # 886788 <bytes::bytes_mut::SHARED_VTABLE+0x308>
   81587:	lea    0xa8(%rsp),%rdx
   8158f:	mov    $0x37,%esi
   81594:	call   4fba0 <core::result::unwrap_failed>
   81599:	jmp    81626 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x11f6>
   8159e:	lea    0x7e8623(%rip),%rdi        # 869bc8 <aws_lc_0_37_1_kem_asn1_meth+0x2ac8>
   815a5:	call   50020 <core::panicking::panic_const::panic_const_async_fn_resumed_panic>
   815aa:	lea    0x7e8617(%rip),%rdi        # 869bc8 <aws_lc_0_37_1_kem_asn1_meth+0x2ac8>
   815b1:	call   4ffe0 <core::panicking::panic_const::panic_const_async_fn_resumed>
   815b6:	mov    %r15,0x10(%rsp)
   815bb:	lea    0x7e845e(%rip),%rdi        # 869a20 <aws_lc_0_37_1_kem_asn1_meth+0x2920>
   815c2:	call   50020 <core::panicking::panic_const::panic_const_async_fn_resumed_panic>
   815c7:	jmp    81626 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x11f6>
   815c9:	mov    %r15,0x8(%rsp)
   815ce:	lea    0x7e8433(%rip),%rdi        # 869a08 <aws_lc_0_37_1_kem_asn1_meth+0x2908>
   815d5:	call   50020 <core::panicking::panic_const::panic_const_async_fn_resumed_panic>
   815da:	jmp    81626 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x11f6>
   815dc:	mov    %r15,0x10(%rsp)
   815e1:	lea    0x7e8438(%rip),%rdi        # 869a20 <aws_lc_0_37_1_kem_asn1_meth+0x2920>
   815e8:	call   4ffe0 <core::panicking::panic_const::panic_const_async_fn_resumed>
   815ed:	jmp    81626 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x11f6>
   815ef:	mov    %r15,0x8(%rsp)
   815f4:	lea    0x7e840d(%rip),%rdi        # 869a08 <aws_lc_0_37_1_kem_asn1_meth+0x2908>
   815fb:	call   4ffe0 <core::panicking::panic_const::panic_const_async_fn_resumed>
   81600:	jmp    81626 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x11f6>
   81602:	mov    %r15,0x10(%rsp)
   81607:	lea    0x7e844a(%rip),%rdi        # 869a58 <aws_lc_0_37_1_kem_asn1_meth+0x2958>
   8160e:	call   50020 <core::panicking::panic_const::panic_const_async_fn_resumed_panic>
   81613:	jmp    81626 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x11f6>
   81615:	mov    %r15,0x10(%rsp)
   8161a:	lea    0x7e8437(%rip),%rdi        # 869a58 <aws_lc_0_37_1_kem_asn1_meth+0x2958>
   81621:	call   4ffe0 <core::panicking::panic_const::panic_const_async_fn_resumed>
   81626:	ud2
   81628:	jmp    81674 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x1244>
   8162a:	jmp    81770 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x1340>
   8162f:	jmp    81770 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x1340>
   81634:	mov    %rax,%r14
   81637:	lea    0x7f65fa(%rip),%rsi        # 877c38 <bytes::bytes::PROMOTABLE_ODD_VTABLE+0x2c50>
   8163e:	mov    $0x1,%edi
   81643:	call   41f980 <core::ptr::drop_in_place<core::option::Option<alloc::boxed::Box<dyn rustls::crypto::ActiveKeyExchange>>>>
   81648:	jmp    8181b <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x13eb>
   8164d:	call   4fdd5 <core::panicking::panic_in_cleanup>
   81652:	jmp    81770 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x1340>
   81657:	mov    %rax,%r14
   8165a:	lea    0x7f65d7(%rip),%rsi        # 877c38 <bytes::bytes::PROMOTABLE_ODD_VTABLE+0x2c50>
   81661:	mov    $0x1,%edi
   81666:	call   41f980 <core::ptr::drop_in_place<core::option::Option<alloc::boxed::Box<dyn rustls::crypto::ActiveKeyExchange>>>>
   8166b:	jmp    816d5 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x12a5>
   8166d:	call   4fdd5 <core::panicking::panic_in_cleanup>
   81672:	jmp    81674 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x1244>
   81674:	mov    %rax,%r14
   81677:	cmpq   $0x0,0x18(%rsp)
   8167d:	jne    816f3 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x12c3>
   8167f:	jmp    8181b <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x13eb>
   81684:	jmp    81770 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x1340>
   81689:	jmp    81770 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x1340>
   8168e:	jmp    81770 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x1340>
   81693:	jmp    816d2 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x12a2>
   81695:	mov    %rax,%r14
   81698:	cmpq   $0x0,0x8(%r13)
   8169d:	jne    816f3 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x12c3>
   8169f:	jmp    8181b <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x13eb>
   816a4:	mov    %rax,%r14
   816a7:	lea    0x7f658a(%rip),%rsi        # 877c38 <bytes::bytes::PROMOTABLE_ODD_VTABLE+0x2c50>
   816ae:	mov    $0x1,%edi
   816b3:	call   41f980 <core::ptr::drop_in_place<core::option::Option<alloc::boxed::Box<dyn rustls::crypto::ActiveKeyExchange>>>>
   816b8:	jmp    816e4 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x12b4>
   816ba:	call   4fdd5 <core::panicking::panic_in_cleanup>
   816bf:	jmp    81770 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x1340>
   816c4:	jmp    81770 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x1340>
   816c9:	jmp    81770 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x1340>
   816ce:	jmp    816e1 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x12b1>
   816d0:	jmp    816d2 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x12a2>
   816d2:	mov    %rax,%r14
   816d5:	test   %rbp,%rbp
   816d8:	jne    816f3 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x12c3>
   816da:	jmp    8181b <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x13eb>
   816df:	jmp    816e1 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x12b1>
   816e1:	mov    %rax,%r14
   816e4:	cmpq   $0x0,0xa8(%rsp)
   816ed:	je     8181b <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x13eb>
   816f3:	mov    %r15,%rdi
   816f6:	jmp    81815 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x13e5>
   816fb:	mov    %r15,0x10(%rsp)
   81700:	mov    %rax,%r14
   81703:	jmp    817a3 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x1373>
   81708:	mov    %rax,%r14
   8170b:	mov    0x8(%rsp),%rax
   81710:	cmpb   $0x3,(%rax)
   81713:	jne    817dd <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x13ad>
   81719:	mov    %rbp,%rdi
   8171c:	call   81860 <core::ptr::drop_in_place<polymarket_client_sdk::request<polymarket_client_sdk::auth::Credentials>::{{closure}}>>
   81721:	movb   $0x0,0x790(%rbx)
   81728:	jmp    817dd <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x13ad>
   8172d:	movb   $0x0,0x790(%rbx)
   81734:	call   4fdd5 <core::panicking::panic_in_cleanup>
   81739:	mov    %rax,%r14
   8173c:	movb   $0x2,0x20(%rbx)
   81740:	mov    %r14,%rdi
   81743:	call   4a180 <_Unwind_Resume@plt>
   81748:	mov    %r13,(%rsp)
   8174c:	mov    %r15,0x8(%rsp)
   81751:	mov    %rax,%r14
   81754:	mov    0xc0(%rbx),%rdi
   8175b:	mov    0xc8(%rbx),%rsi
   81762:	call   2e6550 <core::ptr::drop_in_place<alloc::boxed::Box<dyn hyper_util::client::legacy::connect::ExtraInner>>>
   81767:	jmp    8181b <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x13eb>
   8176c:	jmp    817cc <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x139c>
   8176e:	jmp    817cc <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x139c>
   81770:	mov    %rax,%r14
   81773:	jmp    8181b <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x13eb>
   81778:	mov    %r13,(%rsp)
   8177c:	mov    %rax,%r14
   8177f:	jmp    81824 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x13f4>
   81784:	mov    %rax,%r14
   81787:	movb   $0x2,0x20(%rbx)
   8178b:	mov    %r14,%rdi
   8178e:	call   4a180 <_Unwind_Resume@plt>
   81793:	mov    %r15,0x10(%rsp)
   81798:	mov    %rax,%r14
   8179b:	mov    %rbp,%rdi
   8179e:	call   81860 <core::ptr::drop_in_place<polymarket_client_sdk::request<polymarket_client_sdk::auth::Credentials>::{{closure}}>>
   817a3:	cmpb   $0x0,0x790(%rbx)
   817aa:	je     817cf <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x139f>
   817ac:	lea    0x4d0(%rsp),%rdi
   817b4:	call   6c260 <core::ptr::drop_in_place<reqwest::async_impl::request::Request>>
   817b9:	jmp    817cf <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x139f>
   817bb:	call   4fdd5 <core::panicking::panic_in_cleanup>
   817c0:	mov    %rax,%r14
   817c3:	jmp    8183c <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x140c>
   817c5:	mov    %rax,%r14
   817c8:	jmp    817e4 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x13b4>
   817ca:	jmp    817cc <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x139c>
   817cc:	mov    %rax,%r14
   817cf:	movb   $0x0,0x790(%rbx)
   817d6:	movb   $0x2,0x791(%rbx)
   817dd:	mov    (%rsp),%rax
   817e1:	movb   $0x2,(%rax)
   817e4:	mov    0x10(%rsp),%rdi
   817e9:	call   82ff0 <core::ptr::drop_in_place<polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<polymarket_client_sdk::auth::Normal>>::server_time::{{closure}}>>
   817ee:	jmp    81846 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x1416>
   817f0:	mov    %rax,%r14
   817f3:	cmpq   $0x0,0x38(%rsp)
   817f9:	je     81835 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x1405>
   817fb:	mov    %r15,%rdi
   817fe:	jmp    8182f <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x13ff>
   81800:	mov    %rax,%r14
   81803:	jmp    81835 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x1405>
   81805:	mov    %rax,%r14
   81808:	cmpq   $0x0,0x18(%rsp)
   8180e:	je     8181b <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x13eb>
   81810:	mov    0x20(%rsp),%rdi
   81815:	call   *0x808345(%rip)        # 889b60 <free@GLIBC_2.2.5>
   8181b:	lea    0x60(%rbx),%rdi
   8181f:	call   6bbe0 <core::ptr::drop_in_place<http::header::map::HeaderMap>>
   81824:	cmpq   $0x0,0x48(%rbx)
   81829:	je     81835 <polymarket_client_sdk::clob::client::Client<polymarket_client_sdk::auth::state::Authenticated<K>>::create_headers::{{closure}}+0x1405>
   8182b:	mov    0x50(%rbx),%rdi
   8182f:	call   *0x80832b(%rip)        # 889b60 <free@GLIBC_2.2.5>
   81835:	mov    (%rsp),%rax
   81839:	movb   $0x2,(%rax)
   8183c:	mov    0x8(%rsp),%rdi
   81841:	call   81aa0 <core::ptr::drop_in_place<polymarket_client_sdk::auth::l2::create_headers<polymarket_client_sdk::auth::Normal>::{{closure}}>>
   81846:	movb   $0x2,0x20(%rbx)
   8184a:	mov    %r14,%rdi
   8184d:	call   4a180 <_Unwind_Resume@plt>
   81852:	call   4fdd5 <core::panicking::panic_in_cleanup>
   81857:	call   4fdd5 <core::panicking::panic_in_cleanup>
   8185c:	nopl   0x0(%rax)
