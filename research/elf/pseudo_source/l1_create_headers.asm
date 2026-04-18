
bot/bin/arbitrage_bot:     file format elf64-x86-64


Disassembly of section .text:

00000000000abb70 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}>:
   abb70:	push   %rbp
   abb71:	push   %r15
   abb73:	push   %r14
   abb75:	push   %r13
   abb77:	push   %r12
   abb79:	push   %rbx
   abb7a:	sub    $0x5f8,%rsp
   abb81:	mov    %rsi,%rbx
   abb84:	mov    %rdi,0xb0(%rsp)
   abb8c:	movzbl 0x30(%rsi),%eax
   abb90:	lea    0x61f869(%rip),%rcx        # 6cb400 <encoding_rs::data::KSX1001_LOWERCASE+0x1620>
   abb97:	movslq (%rcx,%rax,4),%rax
   abb9b:	add    %rcx,%rax
   abb9e:	mov    %rdx,0xb8(%rsp)
   abba6:	jmp    *%rax
   abba8:	mov    (%rbx),%rax
   abbab:	mov    0x8(%rbx),%r12
   abbaf:	mov    0x10(%rbx),%rcx
   abbb3:	mov    %rcx,0x18(%rbx)
   abbb7:	mov    %rax,0x20(%rbx)
   abbbb:	mov    (%rcx),%r15
   abbbe:	mov    0x8(%rcx),%rbp
   abbc2:	movzbl 0x7df0bf(%rip),%eax        # 88ac88 <__rust_no_alloc_shim_is_unstable>
   abbc9:	mov    $0x36,%edi
   abbce:	call   *0x7de03c(%rip)        # 889c10 <malloc@GLIBC_2.2.5>
   abbd4:	test   %rax,%rax
   abbd7:	je     acf91 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x1421>
   abbdd:	mov    %rax,%r14
   abbe0:	movups 0x62ec71(%rip),%xmm0        # 6da858 <encoding_rs::data::KSX1001_LOWERCASE+0x10a78>
   abbe7:	movups %xmm0,0x20(%rax)
   abbeb:	movups 0x62ec56(%rip),%xmm0        # 6da848 <encoding_rs::data::KSX1001_LOWERCASE+0x10a68>
   abbf2:	movups %xmm0,0x10(%rax)
   abbf6:	movups 0x62ec3b(%rip),%xmm0        # 6da838 <encoding_rs::data::KSX1001_LOWERCASE+0x10a58>
   abbfd:	movups %xmm0,(%rax)
   abc00:	movabs $0x72656e6769732065,%rax
   abc0a:	mov    %rax,0x2e(%r14)
   abc0e:	movzbl 0x7df073(%rip),%eax        # 88ac88 <__rust_no_alloc_shim_is_unstable>
   abc15:	mov    $0x18,%edi
   abc1a:	call   *0x7ddff0(%rip)        # 889c10 <malloc@GLIBC_2.2.5>
   abc20:	test   %rax,%rax
   abc23:	je     acee4 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x1374>
   abc29:	mov    %rax,%r13
   abc2c:	movq   $0x36,(%rax)
   abc33:	mov    %r14,0x8(%rax)
   abc37:	movq   $0x36,0x10(%rax)
   abc3f:	lea    0x4f0(%rsp),%rdi
   abc47:	call   4860e0 <std::backtrace::Backtrace::capture>
   abc4c:	movb   $0x1,0x1f0(%rsp)
   abc54:	mov    %r13,0x1e0(%rsp)
   abc5c:	lea    0x7cbc35(%rip),%rax        # 877898 <bytes::bytes::PROMOTABLE_ODD_VTABLE+0x28b0>
   abc63:	mov    %rax,0x1e8(%rsp)
   abc6b:	movups 0x4f0(%rsp),%xmm0
   abc73:	movups 0x500(%rsp),%xmm1
   abc7b:	movups 0x510(%rsp),%xmm2
   abc83:	movaps %xmm0,0x1b0(%rsp)
   abc8b:	movaps %xmm1,0x1c0(%rsp)
   abc93:	movaps %xmm2,0x1d0(%rsp)
   abc9b:	test   %r15,%r15
   abc9e:	je     abd41 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x1d1>
   abca4:	lea    0x1b0(%rsp),%rdi
   abcac:	call   6be60 <core::ptr::drop_in_place<polymarket_client_sdk::error::Error>>
   abcb1:	jmp    abdab <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x23b>
   abcb6:	lea    0x799(%rbx),%r12
   abcbd:	movzbl 0x799(%rbx),%eax
   abcc4:	lea    0x38(%rbx),%r14
   abcc8:	lea    0x61f755(%rip),%rcx        # 6cb424 <encoding_rs::data::KSX1001_LOWERCASE+0x1644>
   abccf:	movslq (%rcx,%rax,4),%rax
   abcd3:	add    %rcx,%rax
   abcd6:	jmp    *%rax
   abcd8:	mov    %r12,0x8(%rsp)
   abcdd:	mov    0x790(%rbx),%r12
   abce4:	jmp    abddc <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x26c>
   abce9:	lea    0x194(%rbx),%rax
   abcf0:	mov    %rax,0x8(%rsp)
   abcf5:	movzbl 0x194(%rbx),%eax
   abcfc:	lea    0x38(%rbx),%rcx
   abd00:	mov    %rcx,0xa8(%rsp)
   abd08:	lea    0x61f705(%rip),%rcx        # 6cb414 <encoding_rs::data::KSX1001_LOWERCASE+0x1634>
   abd0f:	movslq (%rcx,%rax,4),%rax
   abd13:	add    %rcx,%rax
   abd16:	jmp    *%rax
   abd18:	mov    0x40(%rbx),%rax
   abd1c:	mov    0x48(%rbx),%r14
   abd20:	mov    0x50(%rbx),%rbp
   abd24:	movq   0x38(%rbx),%xmm0
   abd29:	jmp    ac1be <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x64e>
   abd2e:	mov    0x180(%rbx),%rsi
   abd35:	mov    0x188(%rbx),%rax
   abd3c:	jmp    ac428 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x8b8>
   abd41:	mov    0x1b0(%rsp),%r13
   abd49:	mov    0x1b8(%rsp),%rbp
   abd51:	movaps 0x1c0(%rsp),%xmm0
   abd59:	movaps %xmm0,0x350(%rsp)
   abd61:	movaps 0x1d0(%rsp),%xmm0
   abd69:	movaps %xmm0,0x360(%rsp)
   abd71:	mov    0x1e0(%rsp),%rax
   abd79:	mov    %rax,0x370(%rsp)
   abd81:	mov    0x1e8(%rsp),%rax
   abd89:	mov    %rax,0x378(%rsp)
   abd91:	mov    0x1f0(%rsp),%rax
   abd99:	mov    %rax,0x380(%rsp)
   abda1:	cmp    $0x3,%r13
   abda5:	jne    ac6b2 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xb42>
   abdab:	mov    %rbp,0x28(%rbx)
   abdaf:	cmpb   $0x0,0xc8(%r12)
   abdb8:	je     ac0eb <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x57b>
   abdbe:	mov    %r12,0x790(%rbx)
   abdc5:	lea    0x799(%rbx),%rax
   abdcc:	mov    %rax,0x8(%rsp)
   abdd1:	movb   $0x0,0x799(%rbx)
   abdd8:	lea    0x38(%rbx),%r14
   abddc:	movb   $0x0,0x798(%rbx)
   abde3:	movabs $0x101010101010101,%rax
   abded:	mov    %rax,0x300(%rsp)
   abdf5:	movaps 0x61c874(%rip),%xmm0        # 6c8670 <_fini+0x1564>
   abdfc:	movaps %xmm0,0x2f0(%rsp)
   abe04:	mov    %r12,0x2c0(%rsp)
   abe0c:	lea    -0x28de3(%rip),%rax        # 83030 <<url::Url as core::fmt::Display>::fmt>
   abe13:	mov    %rax,0x2c8(%rsp)
   abe1b:	lea    0x7bdc16(%rip),%rax        # 869a38 <aws_lc_0_37_1_kem_asn1_meth+0x2938>
   abe22:	mov    %rax,0x40(%rsp)
   abe27:	movq   $0x2,0x48(%rsp)
   abe30:	movq   $0x0,0x60(%rsp)
   abe39:	lea    0x2c0(%rsp),%rax
   abe41:	mov    %rax,0x50(%rsp)
   abe46:	movq   $0x1,0x58(%rsp)
   abe4f:	lea    0x320(%rsp),%rdi
   abe57:	lea    0x40(%rsp),%rsi
   abe5c:	call   77f00 <alloc::fmt::format::format_inner>
   abe61:	add    $0xd0,%r12
   abe68:	movups 0x320(%rsp),%xmm0
   abe70:	movaps %xmm0,0x70(%rsp)
   abe75:	mov    0x330(%rsp),%rax
   abe7d:	mov    %rax,0x80(%rsp)
   abe85:	mov    (%r12),%rsi
   abe89:	lea    0x1b0(%rsp),%rdi
   abe91:	lea    0x2f0(%rsp),%rdx
   abe99:	lea    0x70(%rsp),%rcx
   abe9e:	call   148990 <reqwest::async_impl::client::Client::request>
   abea3:	mov    0x1b0(%rsp),%rbp
   abeab:	mov    0x1b8(%rsp),%r13
   abeb3:	lea    0x1c0(%rsp),%rsi
   abebb:	lea    0x4f0(%rsp),%rdi
   abec3:	mov    $0xf8,%edx
   abec8:	call   *0x7dda2a(%rip)        # 8898f8 <memcpy@GLIBC_2.14>
   abece:	mov    0x2b8(%rsp),%rax
   abed6:	lock decq (%rax)
   abeda:	jne    abee9 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x379>
   abedc:	mov    0x2b8(%rsp),%rdi
   abee4:	call   3b0cb0 <alloc::sync::Arc<T,A>::drop_slow>
   abee9:	cmp    $0x2,%rbp
   abeed:	jne    abf09 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x399>
   abeef:	lea    0x120(%rsp),%rdi
   abef7:	mov    %r13,%rsi
   abefa:	call   29d600 <<polymarket_client_sdk::error::Error as core::convert::From<reqwest::error::Error>>::from>
   abeff:	mov    0x8(%rsp),%r12
   abf04:	jmp    abff4 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x484>
   abf09:	lea    0x360(%rsp),%rdi
   abf11:	lea    0x4f0(%rsp),%rsi
   abf19:	mov    0x7dd9d8(%rip),%r15        # 8898f8 <memcpy@GLIBC_2.14>
   abf20:	mov    $0xf8,%edx
   abf25:	call   *%r15
   abf28:	mov    %rbp,0x350(%rsp)
   abf30:	mov    %r13,0x358(%rsp)
   abf38:	movb   $0x0,0x798(%rbx)
   abf3f:	lea    0x350(%rsp),%rsi
   abf47:	mov    $0x108,%edx
   abf4c:	mov    %r14,%rdi
   abf4f:	call   *%r15
   abf52:	movq   $0x3,0x140(%rbx)
   abf5d:	mov    %r12,0x1a0(%rbx)
   abf64:	movb   $0x0,0x3ca(%rbx)
   abf6b:	mov    0xb8(%rsp),%rdx
   abf73:	mov    0x8(%rsp),%r12
   abf78:	lea    0x1b0(%rsp),%rdi
   abf80:	mov    %r14,%rsi
   abf83:	call   83050 <polymarket_client_sdk::request::{{closure}}>
   abf88:	cmpl   $0x4,0x1b0(%rsp)
   abf90:	jne    abf9c <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x42c>
   abf92:	movb   $0x3,(%r12)
   abf97:	jmp    ac056 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x4e6>
   abf9c:	mov    0x1f0(%rsp),%rax
   abfa4:	mov    %rax,0x160(%rsp)
   abfac:	movups 0x1b0(%rsp),%xmm0
   abfb4:	movups 0x1c0(%rsp),%xmm1
   abfbc:	movups 0x1d0(%rsp),%xmm2
   abfc4:	movups 0x1e0(%rsp),%xmm3
   abfcc:	movaps %xmm3,0x150(%rsp)
   abfd4:	movaps %xmm2,0x140(%rsp)
   abfdc:	movaps %xmm1,0x130(%rsp)
   abfe4:	movaps %xmm0,0x120(%rsp)
   abfec:	mov    %r14,%rdi
   abfef:	call   81860 <core::ptr::drop_in_place<polymarket_client_sdk::request<polymarket_client_sdk::auth::Credentials>::{{closure}}>>
   abff4:	movb   $0x0,0x798(%rbx)
   abffb:	mov    0x120(%rsp),%r13
   ac003:	mov    0x128(%rsp),%rbp
   ac00b:	movaps 0x130(%rsp),%xmm0
   ac013:	movaps %xmm0,0x170(%rsp)
   ac01b:	movaps 0x140(%rsp),%xmm0
   ac023:	movaps %xmm0,0x180(%rsp)
   ac02b:	movaps 0x150(%rsp),%xmm0
   ac033:	movaps %xmm0,0x190(%rsp)
   ac03b:	mov    0x160(%rsp),%rax
   ac043:	mov    %rax,0x1a0(%rsp)
   ac04b:	movb   $0x1,(%r12)
   ac050:	cmp    $0x4,%r13
   ac054:	jne    ac06c <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x4fc>
   ac056:	mov    0xb0(%rsp),%rax
   ac05e:	movq   $0x4,(%rax)
   ac065:	mov    $0x3,%al
   ac067:	jmp    acc11 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x10a1>
   ac06c:	mov    0x1a0(%rsp),%rax
   ac074:	mov    %rax,0x4c0(%rsp)
   ac07c:	movaps 0x170(%rsp),%xmm0
   ac084:	movaps 0x180(%rsp),%xmm1
   ac08c:	movaps 0x190(%rsp),%xmm2
   ac094:	movaps %xmm2,0x4b0(%rsp)
   ac09c:	movaps %xmm1,0x4a0(%rsp)
   ac0a4:	movaps %xmm0,0x490(%rsp)
   ac0ac:	cmp    $0x3,%r13
   ac0b0:	je     ac17e <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x60e>
   ac0b6:	mov    0x4c0(%rsp),%rax
   ac0be:	mov    %rax,0x110(%rsp)
   ac0c6:	movaps 0x490(%rsp),%xmm0
   ac0ce:	movaps 0x4a0(%rsp),%xmm1
   ac0d6:	movaps 0x4b0(%rsp),%xmm2
   ac0de:	movaps %xmm2,0x100(%rsp)
   ac0e6:	jmp    ac6f2 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xb82>
   ac0eb:	lea    0x1b0(%rsp),%rdi
   ac0f3:	call   1c3770 <chrono::offset::utc::Utc::now>
   ac0f8:	mov    0x1b0(%rsp),%ecx
   ac0ff:	mov    0x1b4(%rsp),%eax
   ac106:	mov    %ecx,%edi
   ac108:	sar    $0xd,%edi
   ac10b:	lea    -0x1(%rdi),%esi
   ac10e:	xor    %edx,%edx
   ac110:	test   %edi,%edi
   ac112:	jg     ac136 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x5c6>
   ac114:	mov    $0x1,%edx
   ac119:	sub    %edi,%edx
   ac11b:	imul   $0x51eb851f,%rdx,%rdx
   ac122:	shr    $0x27,%rdx
   ac126:	inc    %edx
   ac128:	imul   $0x190,%edx,%edi
   ac12e:	add    %edi,%esi
   ac130:	imul   $0xfffdc54f,%edx,%edx
   ac136:	movslq %esi,%rsi
   ac139:	imul   $0x51eb851f,%rsi,%rdi
   ac140:	mov    %rdi,%r8
   ac143:	shr    $0x3f,%r8
   ac147:	sar    $0x25,%rdi
   ac14b:	add    %r8d,%edi
   ac14e:	imul   $0x5b5,%esi,%esi
   ac154:	sar    $0x2,%esi
   ac157:	shr    $0x4,%ecx
   ac15a:	and    $0x1ff,%ecx
   ac160:	add    %edx,%ecx
   ac162:	sub    %edi,%ecx
   ac164:	sar    $0x2,%edi
   ac167:	add    %esi,%ecx
   ac169:	add    %edi,%ecx
   ac16b:	add    $0xfff506c5,%ecx
   ac171:	movslq %ecx,%rcx
   ac174:	imul   $0x15180,%rcx,%rbp
   ac17b:	add    %rax,%rbp
   ac17e:	mov    0x18(%rbx),%rax
   ac182:	mov    0x20(%rbx),%rcx
   ac186:	mov    0x28(%rbx),%r14
   ac18a:	lea    0x38(%rbx),%rdx
   ac18e:	mov    %rdx,0xa8(%rsp)
   ac196:	movq   %rcx,%xmm0
   ac19b:	mov    %rcx,0x38(%rbx)
   ac19f:	mov    %rax,0x40(%rbx)
   ac1a3:	mov    %r14,0x48(%rbx)
   ac1a7:	mov    %rbp,0x50(%rbx)
   ac1ab:	lea    0x194(%rbx),%rcx
   ac1b2:	mov    %rcx,0x8(%rsp)
   ac1b7:	movb   $0x0,0x194(%rbx)
   ac1be:	mov    %rax,0x58(%rbx)
   ac1c2:	mov    %rbp,0x60(%rbx)
   ac1c6:	movd   %xmm0,%ecx
   ac1ca:	and    $0x1,%ecx
   ac1cd:	pshufd $0x55,%xmm0,%xmm0
   ac1d2:	movd   %xmm0,%edx
   ac1d6:	cmove  %ecx,%edx
   ac1d9:	mov    %edx,0x190(%rbx)
   ac1df:	mov    0x98(%rax),%ecx
   ac1e5:	mov    %ecx,0x50(%rsp)
   ac1e9:	movups 0x88(%rax),%xmm0
   ac1f0:	movaps %xmm0,0x40(%rsp)
   ac1f5:	movq   $0x0,0x4f0(%rsp)
   ac201:	movq   $0x1,0x4f8(%rsp)
   ac20d:	movq   $0x0,0x500(%rsp)
   ac219:	mov    $0xe0000020,%eax
   ac21e:	mov    %rax,0x360(%rsp)
   ac226:	lea    0x4f0(%rsp),%rax
   ac22e:	mov    %rax,0x350(%rsp)
   ac236:	lea    0x7bb923(%rip),%rax        # 867b60 <aws_lc_0_37_1_kem_asn1_meth+0xa60>
   ac23d:	mov    %rbp,%rdi
   ac240:	neg    %rdi
   ac243:	cmovs  %rbp,%rdi
   ac247:	mov    %rax,0x358(%rsp)
   ac24f:	xor    %esi,%esi
   ac251:	test   %rbp,%rbp
   ac254:	setns  %sil
   ac258:	lea    0x350(%rsp),%rdx
   ac260:	call   20c4d0 <core::fmt::num::imp::<impl u64>::_fmt>
   ac265:	test   %al,%al
   ac267:	jne    ace90 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x1320>
   ac26d:	mov    %r14,0x1a8(%rsp)
   ac275:	mov    0x4f0(%rsp),%r12
   ac27d:	mov    0x4f8(%rsp),%r13
   ac285:	mov    0x500(%rsp),%rbp
   ac28d:	mov    0x190(%rbx),%r14d
   ac294:	movzbl 0x7de9ed(%rip),%eax        # 88ac88 <__rust_no_alloc_shim_is_unstable>
   ac29b:	mov    $0x34,%r15d
   ac2a1:	mov    $0x34,%edi
   ac2a6:	call   *0x7dd964(%rip)        # 889c10 <malloc@GLIBC_2.2.5>
   ac2ac:	mov    $0x1,%edi
   ac2b1:	test   %rax,%rax
   ac2b4:	cmovne %r15,%rdi
   ac2b8:	cmove  %r15,%rax
   ac2bc:	je     acebc <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x134c>
   ac2c2:	movups 0x62e4a6(%rip),%xmm0        # 6da76f <encoding_rs::data::KSX1001_LOWERCASE+0x1098f>
   ac2c9:	movups %xmm0,0x20(%rax)
   ac2cd:	movups 0x62e48b(%rip),%xmm0        # 6da75f <encoding_rs::data::KSX1001_LOWERCASE+0x1097f>
   ac2d4:	movups %xmm0,0x10(%rax)
   ac2d8:	movups 0x62e470(%rip),%xmm0        # 6da74f <encoding_rs::data::KSX1001_LOWERCASE+0x1096f>
   ac2df:	movups %xmm0,(%rax)
   ac2e2:	movl   $0x74656c6c,0x30(%rax)
   ac2e9:	lea    0x68(%rbx),%rsi
   ac2ed:	movaps 0x40(%rsp),%xmm0
   ac2f2:	movups %xmm0,0xb8(%rbx)
   ac2f9:	mov    0x50(%rsp),%ecx
   ac2fd:	mov    %ecx,0xc8(%rbx)
   ac303:	mov    %r12,0x68(%rbx)
   ac307:	mov    %r13,0x70(%rbx)
   ac30b:	mov    %rbp,0x78(%rbx)
   ac30f:	mov    %r14,0x98(%rbx)
   ac316:	xorps  %xmm0,%xmm0
   ac319:	movups %xmm0,0xa0(%rbx)
   ac320:	movq   $0x0,0xb0(%rbx)
   ac32b:	mov    %rdi,0x80(%rbx)
   ac332:	mov    %rax,0x88(%rbx)
   ac339:	movq   $0x34,0x90(%rbx)
   ac344:	lea    0xd0(%rbx),%rdx
   ac34b:	movabs $0x8000000000000000,%rax
   ac355:	mov    %rax,0xf8(%rbx)
   ac35c:	lea    0x62e420(%rip),%rcx        # 6da783 <encoding_rs::data::KSX1001_LOWERCASE+0x109a3>
   ac363:	mov    %rcx,0x100(%rbx)
   ac36a:	movq   $0xe,0x108(%rbx)
   ac375:	mov    %rax,0x110(%rbx)
   ac37c:	lea    0x62e40e(%rip),%rax        # 6da791 <encoding_rs::data::KSX1001_LOWERCASE+0x109b1>
   ac383:	mov    %rax,0x118(%rbx)
   ac38a:	movq   $0x1,0x120(%rbx)
   ac395:	movq   $0x1,0xd0(%rbx)
   ac3a0:	mov    0x1a8(%rsp),%rax
   ac3a8:	mov    %rax,0xd8(%rbx)
   ac3af:	movups %xmm0,0xe0(%rbx)
   ac3b6:	movq   $0x0,0xf0(%rbx)
   ac3c1:	movb   $0x0,0x128(%rbx)
   ac3c8:	movb   $0x0,0x13d(%rbx)
   ac3cf:	lea    0x160(%rbx),%r13
   ac3d6:	mov    %r13,%rdi
   ac3d9:	call   1b3850 <alloy_sol_types::types::struct::SolStruct::eip712_signing_hash>
   ac3de:	mov    0x58(%rbx),%r14
   ac3e2:	movzbl 0x7de89f(%rip),%eax        # 88ac88 <__rust_no_alloc_shim_is_unstable>
   ac3e9:	mov    $0x18,%edi
   ac3ee:	call   *0x7dd81c(%rip)        # 889c10 <malloc@GLIBC_2.2.5>
   ac3f4:	test   %rax,%rax
   ac3f7:	mov    0xb8(%rsp),%rdx
   ac3ff:	je     aced0 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x1360>
   ac405:	mov    %rax,%rsi
   ac408:	mov    %r14,(%rax)
   ac40b:	mov    %r13,0x8(%rax)
   ac40f:	movb   $0x0,0x10(%rax)
   ac413:	mov    %rax,0x180(%rbx)
   ac41a:	lea    0x7bb7af(%rip),%rax        # 867bd0 <aws_lc_0_37_1_kem_asn1_meth+0xad0>
   ac421:	mov    %rax,0x188(%rbx)
   ac428:	lea    0x350(%rsp),%rdi
   ac430:	call   *0x18(%rax)
   ac433:	movzbl 0x390(%rsp),%ebp
   ac43b:	cmp    $0x3,%bpl
   ac43f:	jne    ac44e <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x8de>
   ac441:	mov    0x8(%rsp),%rax
   ac446:	movb   $0x3,(%rax)
   ac449:	jmp    acb41 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xfd1>
   ac44e:	movups 0x350(%rsp),%xmm0
   ac456:	movups 0x360(%rsp),%xmm1
   ac45e:	movups 0x370(%rsp),%xmm2
   ac466:	movups 0x380(%rsp),%xmm3
   ac46e:	movaps %xmm3,0x150(%rsp)
   ac476:	movaps %xmm2,0x140(%rsp)
   ac47e:	movaps %xmm1,0x130(%rsp)
   ac486:	movaps %xmm0,0x120(%rsp)
   ac48e:	mov    0x391(%rsp),%eax
   ac495:	mov    %eax,0xa0(%rsp)
   ac49c:	mov    0x394(%rsp),%eax
   ac4a3:	mov    %eax,0xa3(%rsp)
   ac4aa:	mov    0x180(%rbx),%r12
   ac4b1:	mov    0x188(%rbx),%r14
   ac4b8:	mov    (%r14),%rax
   ac4bb:	test   %rax,%rax
   ac4be:	je     ac4c5 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x955>
   ac4c0:	mov    %r12,%rdi
   ac4c3:	call   *%rax
   ac4c5:	cmpq   $0x0,0x8(%r14)
   ac4ca:	je     ac4d5 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x965>
   ac4cc:	mov    %r12,%rdi
   ac4cf:	call   *0x7dd68b(%rip)        # 889b60 <free@GLIBC_2.2.5>
   ac4d5:	cmp    $0x2,%bpl
   ac4d9:	jne    ac501 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x991>
   ac4db:	lea    0x1b8(%rsp),%rdi
   ac4e3:	lea    0x120(%rsp),%rsi
   ac4eb:	call   29d8b0 <<polymarket_client_sdk::error::Error as core::convert::From<alloy_signer::error::Error>>::from>
   ac4f0:	movq   $0x3,0x1b0(%rsp)
   ac4fc:	jmp    aca55 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xee5>
   ac501:	mov    0xa0(%rsp),%eax
   ac508:	mov    0xa3(%rsp),%ecx
   ac50f:	mov    %ecx,0x534(%rsp)
   ac516:	mov    %eax,0x531(%rsp)
   ac51d:	movaps 0x120(%rsp),%xmm0
   ac525:	movaps 0x130(%rsp),%xmm1
   ac52d:	movaps 0x140(%rsp),%xmm2
   ac535:	movaps 0x150(%rsp),%xmm3
   ac53d:	movaps %xmm0,0x4f0(%rsp)
   ac545:	movaps %xmm1,0x500(%rsp)
   ac54d:	movaps %xmm2,0x510(%rsp)
   ac555:	movaps %xmm3,0x520(%rsp)
   ac55d:	mov    %bpl,0x530(%rsp)
   ac565:	movw   $0x0,0x3a8(%rsp)
   ac56f:	movq   $0x2,0x398(%rsp)
   ac57b:	movq   $0x0,0x3a0(%rsp)
   ac587:	movq   $0x0,0x368(%rsp)
   ac593:	movq   $0x8,0x370(%rsp)
   ac59f:	xorps  %xmm0,%xmm0
   ac5a2:	movups %xmm0,0x378(%rsp)
   ac5aa:	movq   $0x8,0x388(%rsp)
   ac5b6:	movq   $0x0,0x390(%rsp)
   ac5c2:	movq   $0x0,0x350(%rsp)
   ac5ce:	mov    0x58(%rbx),%rax
   ac5d2:	mov    0x98(%rax),%ecx
   ac5d8:	mov    %ecx,0xd0(%rsp)
   ac5df:	movups 0x88(%rax),%xmm0
   ac5e6:	movaps %xmm0,0xc0(%rsp)
   ac5ee:	lea    0x28(%rsp),%r12
   ac5f3:	lea    0xc0(%rsp),%rsi
   ac5fb:	mov    %r12,%rdi
   ac5fe:	call   77260 <const_hex::encode_inner>
   ac603:	mov    0x30(%rsp),%r13
   ac608:	mov    0x38(%rsp),%rdx
   ac60d:	test   %rdx,%rdx
   ac610:	je     ac70d <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xb9d>
   ac616:	xor    %eax,%eax
   ac618:	jmp    ac631 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xac1>
   ac61a:	nopw   0x0(%rax,%rax,1)
   ac620:	cmp    $0x7f,%cl
   ac623:	je     ac641 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xad1>
   ac625:	inc    %rax
   ac628:	cmp    %rax,%rdx
   ac62b:	je     ac739 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xbc9>
   ac631:	movzbl 0x0(%r13,%rax,1),%ecx
   ac637:	cmp    $0x1f,%cl
   ac63a:	ja     ac620 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xab0>
   ac63c:	cmp    $0x9,%cl
   ac63f:	je     ac625 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xab5>
   ac641:	lea    0x40(%rsp),%rdi
   ac646:	call   4860e0 <std::backtrace::Backtrace::capture>
   ac64b:	movb   $0x3,0x1f8(%rsp)
   ac653:	movq   $0x1,0x1e8(%rsp)
   ac65f:	lea    0x7cb5d2(%rip),%rax        # 877c38 <bytes::bytes::PROMOTABLE_ODD_VTABLE+0x2c50>
   ac666:	mov    %rax,0x1f0(%rsp)
   ac66e:	movups 0x40(%rsp),%xmm0
   ac673:	movups 0x50(%rsp),%xmm1
   ac678:	movups 0x60(%rsp),%xmm2
   ac67d:	movups %xmm0,0x1b8(%rsp)
   ac685:	movups %xmm1,0x1c8(%rsp)
   ac68d:	movups %xmm2,0x1d8(%rsp)
   ac695:	movq   $0x3,0x1b0(%rsp)
   ac6a1:	cmpq   $0x0,0x28(%rsp)
   ac6a7:	jne    aca3f <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xecf>
   ac6ad:	jmp    aca48 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xed8>
   ac6b2:	mov    0x380(%rsp),%rax
   ac6ba:	mov    %rax,0x110(%rsp)
   ac6c2:	movaps 0x350(%rsp),%xmm0
   ac6ca:	movaps 0x360(%rsp),%xmm1
   ac6d2:	mov    0x370(%rsp),%rax
   ac6da:	mov    %rax,0x100(%rsp)
   ac6e2:	mov    0x378(%rsp),%rax
   ac6ea:	mov    %rax,0x108(%rsp)
   ac6f2:	movaps %xmm1,0xf0(%rsp)
   ac6fa:	movaps %xmm0,0xe0(%rsp)
   ac702:	mov    $0x3,%r15d
   ac708:	jmp    acbb4 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x1044>
   ac70d:	movq   $0x0,0x10(%rsp)
   ac716:	movq   $0x1,0x18(%rsp)
   ac71f:	movq   $0x0,0x20(%rsp)
   ac728:	lea    0x40(%rsp),%rdi
   ac72d:	lea    0x10(%rsp),%rsi
   ac732:	call   1bb1e0 <<bytes::bytes::Bytes as core::convert::From<alloc::vec::Vec<u8>>>::from>
   ac737:	jmp    ac746 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xbd6>
   ac739:	lea    0x40(%rsp),%rdi
   ac73e:	mov    %r13,%rsi
   ac741:	call   1bb140 <bytes::bytes::Bytes::copy_from_slice>
   ac746:	movups 0x40(%rsp),%xmm0
   ac74b:	movups 0x50(%rsp),%xmm1
   ac750:	movaps %xmm1,0x470(%rsp)
   ac758:	movaps %xmm0,0x460(%rsp)
   ac760:	mov    0x61(%rsp),%eax
   ac764:	mov    %eax,0x481(%rsp)
   ac76b:	mov    0x64(%rsp),%eax
   ac76f:	mov    %eax,0x484(%rsp)
   ac776:	movb   $0x0,0x480(%rsp)
   ac77e:	lea    0x62e00d(%rip),%rdx        # 6da792 <encoding_rs::data::KSX1001_LOWERCASE+0x109b2>
   ac785:	lea    0x70(%rsp),%rdi
   ac78a:	lea    0x350(%rsp),%rsi
   ac792:	lea    0x460(%rsp),%r8
   ac79a:	mov    $0xc,%ecx
   ac79f:	call   18f4d0 <http::header::map::HeaderMap<T>::insert>
   ac7a4:	cmpb   $0x2,0x90(%rsp)
   ac7ac:	je     ac7cb <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xc5b>
   ac7ae:	mov    0x70(%rsp),%rax
   ac7b3:	mov    0x78(%rsp),%rsi
   ac7b8:	lea    0x88(%rsp),%rdi
   ac7c0:	mov    0x80(%rsp),%rdx
   ac7c8:	call   *0x20(%rax)
   ac7cb:	cmpq   $0x0,0x28(%rsp)
   ac7d1:	je     ac7dc <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xc6c>
   ac7d3:	mov    %r13,%rdi
   ac7d6:	call   *0x7dd384(%rip)        # 889b60 <free@GLIBC_2.2.5>
   ac7dc:	movq   $0x0,0x28(%rsp)
   ac7e5:	movq   $0x1,0x30(%rsp)
   ac7ee:	movq   $0x0,0x38(%rsp)
   ac7f7:	mov    $0xe0000020,%eax
   ac7fc:	mov    %rax,0x20(%rsp)
   ac801:	mov    %r12,0x10(%rsp)
   ac806:	lea    0x7bb353(%rip),%rax        # 867b60 <aws_lc_0_37_1_kem_asn1_meth+0xa60>
   ac80d:	mov    %rax,0x18(%rsp)
   ac812:	mov    0x190(%rbx),%edi
   ac818:	lea    0x10(%rsp),%rdx
   ac81d:	mov    $0x1,%esi
   ac822:	call   20e750 <core::fmt::num::imp::<impl u32>::_fmt>
   ac827:	test   %al,%al
   ac829:	jne    acef8 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x1388>
   ac82f:	mov    0x28(%rsp),%r15
   ac834:	mov    0x30(%rsp),%r13
   ac839:	mov    0x38(%rsp),%rdx
   ac83e:	test   %rdx,%rdx
   ac841:	je     ac8ca <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xd5a>
   ac847:	xor    %eax,%eax
   ac849:	jmp    ac861 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xcf1>
   ac84b:	nopl   0x0(%rax,%rax,1)
   ac850:	cmp    $0x7f,%cl
   ac853:	je     ac871 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xd01>
   ac855:	inc    %rax
   ac858:	cmp    %rax,%rdx
   ac85b:	je     ac8f6 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xd86>
   ac861:	movzbl 0x0(%r13,%rax,1),%ecx
   ac867:	cmp    $0x1f,%cl
   ac86a:	ja     ac850 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xce0>
   ac86c:	cmp    $0x9,%cl
   ac86f:	je     ac855 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xce5>
   ac871:	lea    0x40(%rsp),%rdi
   ac876:	call   4860e0 <std::backtrace::Backtrace::capture>
   ac87b:	movb   $0x3,0x1f8(%rsp)
   ac883:	movq   $0x1,0x1e8(%rsp)
   ac88f:	lea    0x7cb3a2(%rip),%rax        # 877c38 <bytes::bytes::PROMOTABLE_ODD_VTABLE+0x2c50>
   ac896:	mov    %rax,0x1f0(%rsp)
   ac89e:	movups 0x40(%rsp),%xmm0
   ac8a3:	movups 0x50(%rsp),%xmm1
   ac8a8:	movups 0x60(%rsp),%xmm2
   ac8ad:	movups %xmm0,0x1b8(%rsp)
   ac8b5:	movups %xmm1,0x1c8(%rsp)
   ac8bd:	movups %xmm2,0x1d8(%rsp)
   ac8c5:	jmp    aca2e <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xebe>
   ac8ca:	movq   $0x0,0x10(%rsp)
   ac8d3:	movq   $0x1,0x18(%rsp)
   ac8dc:	movq   $0x0,0x20(%rsp)
   ac8e5:	lea    0x40(%rsp),%rdi
   ac8ea:	lea    0x10(%rsp),%rsi
   ac8ef:	call   1bb1e0 <<bytes::bytes::Bytes as core::convert::From<alloc::vec::Vec<u8>>>::from>
   ac8f4:	jmp    ac903 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xd93>
   ac8f6:	lea    0x40(%rsp),%rdi
   ac8fb:	mov    %r13,%rsi
   ac8fe:	call   1bb140 <bytes::bytes::Bytes::copy_from_slice>
   ac903:	movups 0x40(%rsp),%xmm0
   ac908:	movups 0x50(%rsp),%xmm1
   ac90d:	movaps %xmm1,0x2d0(%rsp)
   ac915:	movaps %xmm0,0x2c0(%rsp)
   ac91d:	mov    0x61(%rsp),%eax
   ac921:	mov    %eax,0x2e1(%rsp)
   ac928:	mov    0x64(%rsp),%eax
   ac92c:	mov    %eax,0x2e4(%rsp)
   ac933:	movb   $0x0,0x2e0(%rsp)
   ac93b:	lea    0x62de5c(%rip),%rdx        # 6da79e <encoding_rs::data::KSX1001_LOWERCASE+0x109be>
   ac942:	lea    0x70(%rsp),%rdi
   ac947:	lea    0x350(%rsp),%rsi
   ac94f:	lea    0x2c0(%rsp),%r8
   ac957:	mov    $0xa,%ecx
   ac95c:	call   18f4d0 <http::header::map::HeaderMap<T>::insert>
   ac961:	cmpb   $0x2,0x90(%rsp)
   ac969:	je     ac988 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xe18>
   ac96b:	mov    0x70(%rsp),%rax
   ac970:	mov    0x78(%rsp),%rsi
   ac975:	lea    0x88(%rsp),%rdi
   ac97d:	mov    0x80(%rsp),%rdx
   ac985:	call   *0x20(%rax)
   ac988:	test   %r15,%r15
   ac98b:	je     ac996 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xe26>
   ac98d:	mov    %r13,%rdi
   ac990:	call   *0x7dd1ca(%rip)        # 889b60 <free@GLIBC_2.2.5>
   ac996:	movq   $0x0,0x10(%rsp)
   ac99f:	movq   $0x1,0x18(%rsp)
   ac9a8:	movq   $0x0,0x20(%rsp)
   ac9b1:	lea    0x7bb1a8(%rip),%rbp        # 867b60 <aws_lc_0_37_1_kem_asn1_meth+0xa60>
   ac9b8:	lea    0x4f0(%rsp),%rdi
   ac9c0:	lea    0x10(%rsp),%rsi
   ac9c5:	mov    %rbp,%rdx
   ac9c8:	call   79f50 <<alloy_primitives::signature::sig::Signature as core::fmt::Display>::fmt>
   ac9cd:	test   %al,%al
   ac9cf:	jne    acf24 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x13b4>
   ac9d5:	mov    0x10(%rsp),%r15
   ac9da:	mov    0x18(%rsp),%r13
   ac9df:	mov    0x20(%rsp),%rdx
   ac9e4:	test   %rdx,%rdx
   ac9e7:	je     acc26 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x10b6>
   ac9ed:	xor    %eax,%eax
   ac9ef:	jmp    aca11 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xea1>
   ac9f1:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   aca00:	cmp    $0x7f,%cl
   aca03:	je     aca21 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xeb1>
   aca05:	inc    %rax
   aca08:	cmp    %rax,%rdx
   aca0b:	je     acc52 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x10e2>
   aca11:	movzbl 0x0(%r13,%rax,1),%ecx
   aca17:	cmp    $0x1f,%cl
   aca1a:	ja     aca00 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xe90>
   aca1c:	cmp    $0x9,%cl
   aca1f:	je     aca05 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xe95>
   aca21:	lea    0x1b8(%rsp),%rdi
   aca29:	call   29d790 <<polymarket_client_sdk::error::Error as core::convert::From<http::header::value::InvalidHeaderValue>>::from>
   aca2e:	movq   $0x3,0x1b0(%rsp)
   aca3a:	test   %r15,%r15
   aca3d:	je     aca48 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xed8>
   aca3f:	mov    %r13,%rdi
   aca42:	call   *0x7dd118(%rip)        # 889b60 <free@GLIBC_2.2.5>
   aca48:	lea    0x350(%rsp),%rdi
   aca50:	call   6bbe0 <core::ptr::drop_in_place<http::header::map::HeaderMap>>
   aca55:	movabs $0x8000000000000000,%r14
   aca5f:	mov    0xf8(%rbx),%rax
   aca66:	lea    0x2(%r14),%rcx
   aca6a:	cmp    %rcx,%rax
   aca6d:	jl     aca81 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xf11>
   aca6f:	test   %rax,%rax
   aca72:	je     aca81 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xf11>
   aca74:	mov    0x100(%rbx),%rdi
   aca7b:	call   *0x7dd0df(%rip)        # 889b60 <free@GLIBC_2.2.5>
   aca81:	mov    0x110(%rbx),%rax
   aca88:	add    $0x2,%r14
   aca8c:	cmp    %r14,%rax
   aca8f:	jl     acaa3 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xf33>
   aca91:	test   %rax,%rax
   aca94:	je     acaa3 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xf33>
   aca96:	mov    0x118(%rbx),%rdi
   aca9d:	call   *0x7dd0bd(%rip)        # 889b60 <free@GLIBC_2.2.5>
   acaa3:	cmpq   $0x0,0x68(%rbx)
   acaa8:	je     acab4 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xf44>
   acaaa:	mov    0x70(%rbx),%rdi
   acaae:	call   *0x7dd0ac(%rip)        # 889b60 <free@GLIBC_2.2.5>
   acab4:	cmpq   $0x0,0x80(%rbx)
   acabc:	je     acacb <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xf5b>
   acabe:	mov    0x88(%rbx),%rdi
   acac5:	call   *0x7dd095(%rip)        # 889b60 <free@GLIBC_2.2.5>
   acacb:	mov    0x1b0(%rsp),%r15
   acad3:	mov    0x1b8(%rsp),%r13
   acadb:	mov    0x1c0(%rsp),%rbp
   acae3:	movups 0x1c8(%rsp),%xmm0
   acaeb:	movaps %xmm0,0x170(%rsp)
   acaf3:	movups 0x1d8(%rsp),%xmm0
   acafb:	movaps %xmm0,0x180(%rsp)
   acb03:	movups 0x1e8(%rsp),%xmm0
   acb0b:	movaps %xmm0,0x190(%rsp)
   acb13:	mov    0x1f8(%rsp),%rax
   acb1b:	mov    %rax,0x1a0(%rsp)
   acb23:	movaps 0x200(%rsp),%xmm0
   acb2b:	movaps %xmm0,0x4d0(%rsp)
   acb33:	mov    0x8(%rsp),%rax
   acb38:	movb   $0x1,(%rax)
   acb3b:	cmp    $0x4,%r15
   acb3f:	jne    acb57 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xfe7>
   acb41:	mov    0xb0(%rsp),%rax
   acb49:	movq   $0x4,(%rax)
   acb50:	mov    $0x4,%al
   acb52:	jmp    acc11 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x10a1>
   acb57:	mov    0x1a0(%rsp),%rax
   acb5f:	mov    %rax,0x110(%rsp)
   acb67:	movaps 0x170(%rsp),%xmm0
   acb6f:	movaps 0x180(%rsp),%xmm1
   acb77:	movaps 0x190(%rsp),%xmm2
   acb7f:	movaps %xmm2,0x100(%rsp)
   acb87:	movaps %xmm1,0xf0(%rsp)
   acb8f:	movaps %xmm0,0xe0(%rsp)
   acb97:	movaps 0x4d0(%rsp),%xmm0
   acb9f:	movaps %xmm0,0x4e0(%rsp)
   acba7:	mov    0xa8(%rsp),%rdi
   acbaf:	call   ad240 <core::ptr::drop_in_place<polymarket_client_sdk::auth::l1::create_headers<alloy_signer_local::LocalSigner<ecdsa::signing::SigningKey<k256::Secp256k1>>>::{{closure}}>>
   acbb4:	mov    0xb0(%rsp),%rdx
   acbbc:	mov    %r15,(%rdx)
   acbbf:	mov    %r13,0x8(%rdx)
   acbc3:	mov    %rbp,0x10(%rdx)
   acbc7:	movaps 0xe0(%rsp),%xmm0
   acbcf:	movaps 0xf0(%rsp),%xmm1
   acbd7:	mov    0x100(%rsp),%rax
   acbdf:	mov    0x108(%rsp),%rcx
   acbe7:	movups %xmm0,0x18(%rdx)
   acbeb:	movups %xmm1,0x28(%rdx)
   acbef:	mov    %rax,0x38(%rdx)
   acbf3:	mov    %rcx,0x40(%rdx)
   acbf7:	mov    0x110(%rsp),%rax
   acbff:	mov    %rax,0x48(%rdx)
   acc03:	movaps 0x4e0(%rsp),%xmm0
   acc0b:	movups %xmm0,0x50(%rdx)
   acc0f:	mov    $0x1,%al
   acc11:	mov    %al,0x30(%rbx)
   acc14:	add    $0x5f8,%rsp
   acc1b:	pop    %rbx
   acc1c:	pop    %r12
   acc1e:	pop    %r13
   acc20:	pop    %r14
   acc22:	pop    %r15
   acc24:	pop    %rbp
   acc25:	ret
   acc26:	movq   $0x0,0x10(%rsp)
   acc2f:	movq   $0x1,0x18(%rsp)
   acc38:	movq   $0x0,0x20(%rsp)
   acc41:	lea    0x40(%rsp),%rdi
   acc46:	lea    0x10(%rsp),%rsi
   acc4b:	call   1bb1e0 <<bytes::bytes::Bytes as core::convert::From<alloc::vec::Vec<u8>>>::from>
   acc50:	jmp    acc5f <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x10ef>
   acc52:	lea    0x40(%rsp),%rdi
   acc57:	mov    %r13,%rsi
   acc5a:	call   1bb140 <bytes::bytes::Bytes::copy_from_slice>
   acc5f:	movups 0x40(%rsp),%xmm0
   acc64:	movups 0x50(%rsp),%xmm1
   acc69:	movaps %xmm1,0x300(%rsp)
   acc71:	movaps %xmm0,0x2f0(%rsp)
   acc79:	mov    0x61(%rsp),%eax
   acc7d:	mov    %eax,0x311(%rsp)
   acc84:	mov    0x64(%rsp),%eax
   acc88:	mov    %eax,0x314(%rsp)
   acc8f:	movb   $0x0,0x310(%rsp)
   acc97:	lea    0x62db0a(%rip),%rdx        # 6da7a8 <encoding_rs::data::KSX1001_LOWERCASE+0x109c8>
   acc9e:	lea    0x70(%rsp),%rdi
   acca3:	lea    0x350(%rsp),%rsi
   accab:	lea    0x2f0(%rsp),%r8
   accb3:	mov    $0xe,%ecx
   accb8:	call   18f4d0 <http::header::map::HeaderMap<T>::insert>
   accbd:	cmpb   $0x2,0x90(%rsp)
   accc5:	je     acce4 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x1174>
   accc7:	mov    0x70(%rsp),%rax
   acccc:	mov    0x78(%rsp),%rsi
   accd1:	lea    0x88(%rsp),%rdi
   accd9:	mov    0x80(%rsp),%rdx
   acce1:	call   *0x20(%rax)
   acce4:	test   %r15,%r15
   acce7:	je     accf2 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x1182>
   acce9:	mov    %r13,%rdi
   accec:	call   *0x7dce6e(%rip)        # 889b60 <free@GLIBC_2.2.5>
   accf2:	movq   $0x0,0x28(%rsp)
   accfb:	movq   $0x1,0x30(%rsp)
   acd04:	movq   $0x0,0x38(%rsp)
   acd0d:	mov    $0xe0000020,%eax
   acd12:	mov    %rax,0x20(%rsp)
   acd17:	mov    %r12,0x10(%rsp)
   acd1c:	mov    %rbp,0x18(%rsp)
   acd21:	mov    0x60(%rbx),%rax
   acd25:	mov    %rax,%rdi
   acd28:	neg    %rdi
   acd2b:	cmovs  %rax,%rdi
   acd2f:	xor    %esi,%esi
   acd31:	test   %rax,%rax
   acd34:	setns  %sil
   acd38:	lea    0x10(%rsp),%rdx
   acd3d:	call   20c4d0 <core::fmt::num::imp::<impl u64>::_fmt>
   acd42:	test   %al,%al
   acd44:	jne    acf50 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x13e0>
   acd4a:	mov    0x28(%rsp),%r15
   acd4f:	mov    0x30(%rsp),%r12
   acd54:	mov    0x38(%rsp),%rdx
   acd59:	lea    0x40(%rsp),%rdi
   acd5e:	mov    %r12,%rsi
   acd61:	call   1b6350 <http::header::value::HeaderValue::try_from_generic>
   acd66:	movzbl 0x60(%rsp),%eax
   acd6b:	cmp    $0x2,%al
   acd6d:	jne    acd99 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x1229>
   acd6f:	lea    0x1b8(%rsp),%rdi
   acd77:	call   29d790 <<polymarket_client_sdk::error::Error as core::convert::From<http::header::value::InvalidHeaderValue>>::from>
   acd7c:	movq   $0x3,0x1b0(%rsp)
   acd88:	test   %r15,%r15
   acd8b:	je     aca48 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xed8>
   acd91:	mov    %r12,%rdi
   acd94:	jmp    aca42 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xed2>
   acd99:	movups 0x40(%rsp),%xmm0
   acd9e:	movups 0x50(%rsp),%xmm1
   acda3:	movaps %xmm1,0x330(%rsp)
   acdab:	movaps %xmm0,0x320(%rsp)
   acdb3:	mov    0x61(%rsp),%ecx
   acdb7:	mov    %ecx,0x341(%rsp)
   acdbe:	mov    0x64(%rsp),%ecx
   acdc2:	mov    %ecx,0x344(%rsp)
   acdc9:	mov    %al,0x340(%rsp)
   acdd0:	lea    0x62d9df(%rip),%rdx        # 6da7b6 <encoding_rs::data::KSX1001_LOWERCASE+0x109d6>
   acdd7:	lea    0x70(%rsp),%rdi
   acddc:	lea    0x350(%rsp),%rsi
   acde4:	lea    0x320(%rsp),%r8
   acdec:	mov    $0xe,%ecx
   acdf1:	call   18f4d0 <http::header::map::HeaderMap<T>::insert>
   acdf6:	cmpb   $0x2,0x90(%rsp)
   acdfe:	je     ace1d <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x12ad>
   ace00:	mov    0x70(%rsp),%rax
   ace05:	mov    0x78(%rsp),%rsi
   ace0a:	lea    0x88(%rsp),%rdi
   ace12:	mov    0x80(%rsp),%rdx
   ace1a:	call   *0x20(%rax)
   ace1d:	test   %r15,%r15
   ace20:	je     ace2b <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x12bb>
   ace22:	mov    %r12,%rdi
   ace25:	call   *0x7dcd35(%rip)        # 889b60 <free@GLIBC_2.2.5>
   ace2b:	movups 0x350(%rsp),%xmm0
   ace33:	movups 0x360(%rsp),%xmm1
   ace3b:	movups 0x370(%rsp),%xmm2
   ace43:	movups 0x380(%rsp),%xmm3
   ace4b:	movaps %xmm0,0x1b0(%rsp)
   ace53:	movaps %xmm1,0x1c0(%rsp)
   ace5b:	movaps %xmm2,0x1d0(%rsp)
   ace63:	movaps %xmm3,0x1e0(%rsp)
   ace6b:	movups 0x390(%rsp),%xmm0
   ace73:	movaps %xmm0,0x1f0(%rsp)
   ace7b:	movups 0x3a0(%rsp),%xmm0
   ace83:	movaps %xmm0,0x200(%rsp)
   ace8b:	jmp    aca55 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0xee5>
   ace90:	lea    0x698d66(%rip),%rdi        # 745bfd <serde_json::value::index::<impl core::ops::index::Index<I> for serde_json::value::Value>::index::NULL+0x44bd>
   ace97:	lea    0x7bacf2(%rip),%rcx        # 867b90 <aws_lc_0_37_1_kem_asn1_meth+0xa90>
   ace9e:	lea    0x7d98e3(%rip),%r8        # 886788 <bytes::bytes_mut::SHARED_VTABLE+0x308>
   acea5:	lea    0xc0(%rsp),%rdx
   acead:	mov    $0x37,%esi
   aceb2:	call   4fba0 <core::result::unwrap_failed>
   aceb7:	jmp    acfdf <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x146f>
   acebc:	lea    0x7dafb5(%rip),%rdx        # 887e78 <bytes::bytes_mut::SHARED_VTABLE+0x19f8>
   acec3:	mov    %rax,%rsi
   acec6:	call   4a4d6 <alloc::raw_vec::handle_error>
   acecb:	jmp    acfdf <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x146f>
   aced0:	mov    $0x8,%edi
   aced5:	mov    $0x18,%esi
   aceda:	call   4a4ec <alloc::alloc::handle_alloc_error>
   acedf:	jmp    acfdf <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x146f>
   acee4:	mov    $0x8,%edi
   acee9:	mov    $0x18,%esi
   aceee:	call   4a4ec <alloc::alloc::handle_alloc_error>
   acef3:	jmp    acfdf <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x146f>
   acef8:	lea    0x698cfe(%rip),%rdi        # 745bfd <serde_json::value::index::<impl core::ops::index::Index<I> for serde_json::value::Value>::index::NULL+0x44bd>
   aceff:	lea    0x7bac8a(%rip),%rcx        # 867b90 <aws_lc_0_37_1_kem_asn1_meth+0xa90>
   acf06:	lea    0x7d987b(%rip),%r8        # 886788 <bytes::bytes_mut::SHARED_VTABLE+0x308>
   acf0d:	lea    0xc0(%rsp),%rdx
   acf15:	mov    $0x37,%esi
   acf1a:	call   4fba0 <core::result::unwrap_failed>
   acf1f:	jmp    acfdf <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x146f>
   acf24:	lea    0x698cd2(%rip),%rdi        # 745bfd <serde_json::value::index::<impl core::ops::index::Index<I> for serde_json::value::Value>::index::NULL+0x44bd>
   acf2b:	lea    0x7bac5e(%rip),%rcx        # 867b90 <aws_lc_0_37_1_kem_asn1_meth+0xa90>
   acf32:	lea    0x7d984f(%rip),%r8        # 886788 <bytes::bytes_mut::SHARED_VTABLE+0x308>
   acf39:	lea    0xc0(%rsp),%rdx
   acf41:	mov    $0x37,%esi
   acf46:	call   4fba0 <core::result::unwrap_failed>
   acf4b:	jmp    acfdf <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x146f>
   acf50:	lea    0x698ca6(%rip),%rdi        # 745bfd <serde_json::value::index::<impl core::ops::index::Index<I> for serde_json::value::Value>::index::NULL+0x44bd>
   acf57:	lea    0x7bac32(%rip),%rcx        # 867b90 <aws_lc_0_37_1_kem_asn1_meth+0xa90>
   acf5e:	lea    0x7d9823(%rip),%r8        # 886788 <bytes::bytes_mut::SHARED_VTABLE+0x308>
   acf65:	lea    0xc0(%rsp),%rdx
   acf6d:	mov    $0x37,%esi
   acf72:	call   4fba0 <core::result::unwrap_failed>
   acf77:	jmp    acfdf <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x146f>
   acf79:	lea    0x7bcba8(%rip),%rdi        # 869b28 <aws_lc_0_37_1_kem_asn1_meth+0x2a28>
   acf80:	call   50020 <core::panicking::panic_const::panic_const_async_fn_resumed_panic>
   acf85:	lea    0x7bcb9c(%rip),%rdi        # 869b28 <aws_lc_0_37_1_kem_asn1_meth+0x2a28>
   acf8c:	call   4ffe0 <core::panicking::panic_const::panic_const_async_fn_resumed>
   acf91:	lea    0x7daee0(%rip),%rdx        # 887e78 <bytes::bytes_mut::SHARED_VTABLE+0x19f8>
   acf98:	mov    $0x1,%edi
   acf9d:	mov    $0x36,%esi
   acfa2:	call   4a4d6 <alloc::raw_vec::handle_error>
   acfa7:	jmp    acfdf <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x146f>
   acfa9:	lea    0x7bca40(%rip),%rdi        # 8699f0 <aws_lc_0_37_1_kem_asn1_meth+0x28f0>
   acfb0:	call   50020 <core::panicking::panic_const::panic_const_async_fn_resumed_panic>
   acfb5:	jmp    acfdf <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x146f>
   acfb7:	lea    0x7bca9a(%rip),%rdi        # 869a58 <aws_lc_0_37_1_kem_asn1_meth+0x2958>
   acfbe:	call   50020 <core::panicking::panic_const::panic_const_async_fn_resumed_panic>
   acfc3:	jmp    acfdf <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x146f>
   acfc5:	lea    0x7bca24(%rip),%rdi        # 8699f0 <aws_lc_0_37_1_kem_asn1_meth+0x28f0>
   acfcc:	call   4ffe0 <core::panicking::panic_const::panic_const_async_fn_resumed>
   acfd1:	jmp    acfdf <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x146f>
   acfd3:	lea    0x7bca7e(%rip),%rdi        # 869a58 <aws_lc_0_37_1_kem_asn1_meth+0x2958>
   acfda:	call   4ffe0 <core::panicking::panic_const::panic_const_async_fn_resumed>
   acfdf:	ud2
   acfe1:	jmp    ad01f <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x14af>
   acfe3:	jmp    ad03b <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x14cb>
   acfe5:	mov    %rax,%rbp
   acfe8:	lea    0x7cac49(%rip),%rsi        # 877c38 <bytes::bytes::PROMOTABLE_ODD_VTABLE+0x2c50>
   acfef:	mov    $0x1,%edi
   acff4:	call   41f980 <core::ptr::drop_in_place<core::option::Option<alloc::boxed::Box<dyn rustls::crypto::ActiveKeyExchange>>>>
   acff9:	jmp    ad03e <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x14ce>
   acffb:	call   4fdd5 <core::panicking::panic_in_cleanup>
   ad000:	jmp    ad03b <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x14cb>
   ad002:	mov    %rax,%rbp
   ad005:	lea    0x7cac2c(%rip),%rsi        # 877c38 <bytes::bytes::PROMOTABLE_ODD_VTABLE+0x2c50>
   ad00c:	mov    $0x1,%edi
   ad011:	call   41f980 <core::ptr::drop_in_place<core::option::Option<alloc::boxed::Box<dyn rustls::crypto::ActiveKeyExchange>>>>
   ad016:	jmp    ad04d <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x14dd>
   ad018:	call   4fdd5 <core::panicking::panic_in_cleanup>
   ad01d:	jmp    ad01f <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x14af>
   ad01f:	mov    %rax,%rbp
   ad022:	test   %r15,%r15
   ad025:	je     ad1a9 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x1639>
   ad02b:	mov    %r12,%rdi
   ad02e:	jmp    ad1a3 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x1633>
   ad033:	jmp    ad03b <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x14cb>
   ad035:	jmp    ad04a <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x14da>
   ad037:	jmp    ad03b <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x14cb>
   ad039:	jmp    ad03b <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x14cb>
   ad03b:	mov    %rax,%rbp
   ad03e:	test   %r15,%r15
   ad041:	jne    ad059 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x14e9>
   ad043:	jmp    ad1a9 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x1639>
   ad048:	jmp    ad04a <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x14da>
   ad04a:	mov    %rax,%rbp
   ad04d:	cmpq   $0x0,0x28(%rsp)
   ad053:	je     ad1a9 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x1639>
   ad059:	mov    %r13,%rdi
   ad05c:	jmp    ad1a3 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x1633>
   ad061:	jmp    ad1d5 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x1665>
   ad066:	mov    %rax,%rbp
   ad069:	movb   $0x2,0x30(%rbx)
   ad06d:	mov    %rbp,%rdi
   ad070:	call   4a180 <_Unwind_Resume@plt>
   ad075:	mov    %rax,%rbp
   ad078:	movb   $0x2,0x30(%rbx)
   ad07c:	mov    %rbp,%rdi
   ad07f:	call   4a180 <_Unwind_Resume@plt>
   ad084:	mov    %rax,%rbp
   ad087:	jmp    ad1a9 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x1639>
   ad08c:	jmp    ad1d5 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x1665>
   ad091:	jmp    ad0b8 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x1548>
   ad093:	jmp    ad0b8 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x1548>
   ad095:	mov    %rax,%rbp
   ad098:	jmp    ad0e0 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x1570>
   ad09a:	mov    %rax,%rbp
   ad09d:	cmpq   $0x0,0x8(%r14)
   ad0a2:	je     ad1d8 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x1668>
   ad0a8:	mov    %r12,%rdi
   ad0ab:	call   *0x7dcaaf(%rip)        # 889b60 <free@GLIBC_2.2.5>
   ad0b1:	jmp    ad1d8 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x1668>
   ad0b6:	jmp    ad0b8 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x1548>
   ad0b8:	mov    %rax,%rbp
   ad0bb:	movb   $0x0,0x798(%rbx)
   ad0c2:	movb   $0x2,0x799(%rbx)
   ad0c9:	movb   $0x2,0x30(%rbx)
   ad0cd:	mov    %rbp,%rdi
   ad0d0:	call   4a180 <_Unwind_Resume@plt>
   ad0d5:	mov    %rax,%rbp
   ad0d8:	mov    %r14,%rdi
   ad0db:	call   81860 <core::ptr::drop_in_place<polymarket_client_sdk::request<polymarket_client_sdk::auth::Credentials>::{{closure}}>>
   ad0e0:	cmpb   $0x0,0x798(%rbx)
   ad0e7:	je     ad0bb <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x154b>
   ad0e9:	lea    0x350(%rsp),%rdi
   ad0f1:	call   6c260 <core::ptr::drop_in_place<reqwest::async_impl::request::Request>>
   ad0f6:	jmp    ad0bb <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x154b>
   ad0f8:	call   4fdd5 <core::panicking::panic_in_cleanup>
   ad0fd:	mov    %rax,%rbp
   ad100:	lea    0x7ca791(%rip),%rsi        # 877898 <bytes::bytes::PROMOTABLE_ODD_VTABLE+0x28b0>
   ad107:	mov    %r13,%rdi
   ad10a:	call   41f980 <core::ptr::drop_in_place<core::option::Option<alloc::boxed::Box<dyn rustls::crypto::ActiveKeyExchange>>>>
   ad10f:	jmp    ad22d <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x16bd>
   ad114:	call   4fdd5 <core::panicking::panic_in_cleanup>
   ad119:	mov    %rax,%rbp
   ad11c:	cmpb   $0x3,(%r12)
   ad121:	jne    ad22d <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x16bd>
   ad127:	mov    %r14,%rdi
   ad12a:	call   81860 <core::ptr::drop_in_place<polymarket_client_sdk::request<polymarket_client_sdk::auth::Credentials>::{{closure}}>>
   ad12f:	movb   $0x0,0x798(%rbx)
   ad136:	movb   $0x2,0x30(%rbx)
   ad13a:	mov    %rbp,%rdi
   ad13d:	call   4a180 <_Unwind_Resume@plt>
   ad142:	movb   $0x0,0x798(%rbx)
   ad149:	call   4fdd5 <core::panicking::panic_in_cleanup>
   ad14e:	mov    %rax,%rbp
   ad151:	jmp    ad220 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x16b0>
   ad156:	jmp    ad1d5 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x1665>
   ad158:	mov    %rax,%rbp
   ad15b:	movb   $0x2,0x30(%rbx)
   ad15f:	mov    %rbp,%rdi
   ad162:	call   4a180 <_Unwind_Resume@plt>
   ad167:	mov    %rax,%rbp
   ad16a:	mov    0x180(%rbx),%rdi
   ad171:	mov    0x188(%rbx),%rsi
   ad178:	call   2e6550 <core::ptr::drop_in_place<alloc::boxed::Box<dyn hyper_util::client::legacy::connect::ExtraInner>>>
   ad17d:	jmp    ad1d8 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x1668>
   ad17f:	jmp    ad193 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x1623>
   ad181:	mov    %rax,%rbp
   ad184:	cmpq   $0x0,0x10(%rsp)
   ad18a:	je     ad1a9 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x1639>
   ad18c:	mov    0x18(%rsp),%rdi
   ad191:	jmp    ad1a3 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x1633>
   ad193:	mov    %rax,%rbp
   ad196:	cmpq   $0x0,0x28(%rsp)
   ad19c:	je     ad1a9 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x1639>
   ad19e:	mov    0x30(%rsp),%rdi
   ad1a3:	call   *0x7dc9b7(%rip)        # 889b60 <free@GLIBC_2.2.5>
   ad1a9:	lea    0x350(%rsp),%rdi
   ad1b1:	call   6bbe0 <core::ptr::drop_in_place<http::header::map::HeaderMap>>
   ad1b6:	jmp    ad1d8 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x1668>
   ad1b8:	call   4fdd5 <core::panicking::panic_in_cleanup>
   ad1bd:	mov    %rax,%rbp
   ad1c0:	mov    %r14,%rdi
   ad1c3:	call   *0x7dc997(%rip)        # 889b60 <free@GLIBC_2.2.5>
   ad1c9:	movb   $0x2,0x30(%rbx)
   ad1cd:	mov    %rbp,%rdi
   ad1d0:	call   4a180 <_Unwind_Resume@plt>
   ad1d5:	mov    %rax,%rbp
   ad1d8:	lea    0xd0(%rbx),%rdi
   ad1df:	call   6c200 <core::ptr::drop_in_place<alloy_sol_types::eip712::Eip712Domain>>
   ad1e4:	lea    0x68(%rbx),%rdi
   ad1e8:	call   ae850 <core::ptr::drop_in_place<arbitrage_bot::auth::ClobAuth>>
   ad1ed:	jmp    ad218 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x16a8>
   ad1ef:	mov    %rax,%rbp
   ad1f2:	test   %r12,%r12
   ad1f5:	je     ad218 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x16a8>
   ad1f7:	mov    %r13,%rdi
   ad1fa:	jmp    ad212 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x16a2>
   ad1fc:	mov    %rax,%rbp
   ad1ff:	cmpq   $0x0,0x4f0(%rsp)
   ad208:	je     ad218 <polymarket_client_sdk::clob::client::ClientInner<polymarket_client_sdk::auth::state::Unauthenticated>::create_headers::{{closure}}+0x16a8>
   ad20a:	mov    0x4f8(%rsp),%rdi
   ad212:	call   *0x7dc948(%rip)        # 889b60 <free@GLIBC_2.2.5>
   ad218:	mov    0x8(%rsp),%rax
   ad21d:	movb   $0x2,(%rax)
   ad220:	mov    0xa8(%rsp),%rdi
   ad228:	call   ad240 <core::ptr::drop_in_place<polymarket_client_sdk::auth::l1::create_headers<alloy_signer_local::LocalSigner<ecdsa::signing::SigningKey<k256::Secp256k1>>>::{{closure}}>>
   ad22d:	movb   $0x2,0x30(%rbx)
   ad231:	mov    %rbp,%rdi
   ad234:	call   4a180 <_Unwind_Resume@plt>
   ad239:	call   4fdd5 <core::panicking::panic_in_cleanup>
   ad23e:	xchg   %ax,%ax
