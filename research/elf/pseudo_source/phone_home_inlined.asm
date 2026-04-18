
bot/bin/arbitrage_bot:     file format elf64-x86-64


Disassembly of section .text:

0000000000091f80 <arbitrage_bot::trading::client::TradingClient::new::{{closure}}+0x26d0>:
   91f80:	and    $0x10,%al
   91f82:	mov    (%rsp),%r12
   91f86:	mov    0x18(%rsp),%r15
   91f8b:	lea    0x960(%rsp),%rdi
   91f93:	call   486750 <std::env::vars>
   91f98:	movdqu 0x960(%rsp),%xmm0
   91fa1:	movdqu 0x970(%rsp),%xmm1
   91faa:	movdqa %xmm1,0x4c0(%rsp)
   91fb3:	movdqa %xmm0,0x4b0(%rsp)
   91fbc:	lea    0x4b0(%rsp),%rsi
   91fc4:	mov    %r13,%rdi
   91fc7:	call   137cb0 <<std::collections::hash::map::HashMap<K,V,S> as core::iter::traits::collect::FromIterator<(K,V)>>::from_iter>
   91fcc:	mov    %r15,0x18(%rsp)
   91fd1:	lea    0x4b0(%rsp),%rdi
   91fd9:	call   34f880 <reqwest::async_impl::client::Client::builder>
   91fde:	movq   $0x5,0x7f0(%rsp)
   91fea:	movl   $0x0,0x7f8(%rsp)
   91ff5:	lea    0x960(%rsp),%r15
   91ffd:	lea    0x4b0(%rsp),%rsi
   92005:	mov    $0x3f8,%edx
   9200a:	mov    %r15,%rdi
   9200d:	call   *0x7f78e5(%rip)        # 8898f8 <memcpy@GLIBC_2.14>
   92013:	mov    %r15,%rdi
   92016:	call   347cb0 <reqwest::async_impl::client::ClientBuilder::build>
   9201b:	mov    %rax,0x438(%rbx)
   92022:	mov    %rdx,0x440(%rbx)
   92029:	test   $0x1,%al
   9202b:	je     9204c <arbitrage_bot::trading::client::TradingClient::new::{{closure}}+0x279c>
   9202d:	test   %rax,%rax
   92030:	jne    921c0 <arbitrage_bot::trading::client::TradingClient::new::{{closure}}+0x2910>
   92036:	lock decq (%rdx)
   9203a:	jne    92226 <arbitrage_bot::trading::client::TradingClient::new::{{closure}}+0x2976>
   92040:	lea    0x440(%rbx),%rax
   92047:	jmp    9221e <arbitrage_bot::trading::client::TradingClient::new::{{closure}}+0x296e>
   9204c:	mov    %rdx,0x448(%rbx)
   92053:	lea    0x6489af(%rip),%rax        # 6daa09 <encoding_rs::data::KSX1001_LOWERCASE+0x10c29>
   9205a:	lea    0x4b0(%rsp),%rdi
   92062:	mov    %rdx,%rsi
   92065:	mov    %rax,%rdx
   92068:	mov    %r12,(%rsp)
   9206c:	mov    %r13,0x30(%rsp)
   92071:	call   148700 <reqwest::async_impl::client::Client::post>
   92076:	lea    0x960(%rsp),%rdi
   9207e:	lea    0x4b0(%rsp),%rsi
   92086:	mov    %r13,%rdx
   92089:	call   148d10 <reqwest::async_impl::request::RequestBuilder::json>
   9208e:	mov    %rbp,%r13
   92091:	cmpl   $0x2,0x960(%rsp)
   92099:	jne    920b3 <arbitrage_bot::trading::client::TradingClient::new::{{closure}}+0x2803>
   9209b:	mov    0x968(%rsp),%rbp
   920a3:	mov    0xa68(%rsp),%r12
   920ab:	mov    $0x1,%r15d
   920b1:	jmp    920d1 <arbitrage_bot::trading::client::TradingClient::new::{{closure}}+0x2821>
   920b3:	mov    0xa68(%rsp),%r12
   920bb:	lea    0x960(%rsp),%rsi
   920c3:	mov    %r12,%rdi
   920c6:	call   34ff10 <reqwest::async_impl::client::Client::execute_request>
   920cb:	mov    %rax,%r15
   920ce:	rex.W
   920cf:	.byte 0x89
