
main_x86.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <main>:
   0:	f3 0f 1e fa          	endbr64 
   4:	55                   	push   %rbp
   5:	48 89 e5             	mov    %rsp,%rbp
   8:	48 83 ec 20          	sub    $0x20,%rsp
   c:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
  13:	00 00 
  15:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  19:	31 c0                	xor    %eax,%eax
  1b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
  22:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%rbp)
  29:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%rbp)
  30:	48 8d 45 e4          	lea    -0x1c(%rbp),%rax
  34:	48 89 c6             	mov    %rax,%rsi
  37:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 3e <main+0x3e>
  3e:	b8 00 00 00 00       	mov    $0x0,%eax
  43:	e8 00 00 00 00       	callq  48 <main+0x48>
  48:	8b 45 e8             	mov    -0x18(%rbp),%eax
  4b:	89 c6                	mov    %eax,%esi
  4d:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 54 <main+0x54>
  54:	b8 00 00 00 00       	mov    $0x0,%eax
  59:	e8 00 00 00 00       	callq  5e <main+0x5e>
  5e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  61:	89 c6                	mov    %eax,%esi
  63:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 6a <main+0x6a>
  6a:	b8 00 00 00 00       	mov    $0x0,%eax
  6f:	e8 00 00 00 00       	callq  74 <main+0x74>
  74:	eb 2c                	jmp    a2 <main+0xa2>
  76:	8b 45 ec             	mov    -0x14(%rbp),%eax
  79:	89 45 f4             	mov    %eax,-0xc(%rbp)
  7c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  7f:	01 45 ec             	add    %eax,-0x14(%rbp)
  82:	8b 45 ec             	mov    -0x14(%rbp),%eax
  85:	89 c6                	mov    %eax,%esi
  87:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 8e <main+0x8e>
  8e:	b8 00 00 00 00       	mov    $0x0,%eax
  93:	e8 00 00 00 00       	callq  98 <main+0x98>
  98:	8b 45 f4             	mov    -0xc(%rbp),%eax
  9b:	89 45 e8             	mov    %eax,-0x18(%rbp)
  9e:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  a2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  a5:	39 45 f0             	cmp    %eax,-0x10(%rbp)
  a8:	7c cc                	jl     76 <main+0x76>
  aa:	b8 00 00 00 00       	mov    $0x0,%eax
  af:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  b3:	64 48 33 14 25 28 00 	xor    %fs:0x28,%rdx
  ba:	00 00 
  bc:	74 05                	je     c3 <main+0xc3>
  be:	e8 00 00 00 00       	callq  c3 <main+0xc3>
  c3:	c9                   	leaveq 
  c4:	c3                   	retq   
