	.file	"main.c"
	.text
	.section	.rodata
.LC0:
	.string	"%d"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax //%eax清零
	movl	$0, -24(%rbp) //-24(%rbp)存变量a
	movl	$1, -20(%rbp) //-20(%rbp)存变量b
	movl	$1, -16(%rbp) //-16(%rbp)存变量i

	//scanf
	leaq	-28(%rbp), %rax //-28(%rbp)存放变量n
	movq	%rax, %rsi
	leaq	.LC0(%rip), %rdi
	movl	$0, %eax
	call	__isoc99_scanf@PLT 
	movl	-24(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC0(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT //printf
	movl	-20(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC0(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT //printf
	jmp	.L2 //从.L2开始while循环
.L3:
	//两步完成t=b
	movl	-20(%rbp), %eax //取b 存入%eax
	movl	%eax, -12(%rbp) //将%eax中的值(b)存入-12(%rbp) -12(%rbp)代表变量t
	//三步完成b=a+b
	movl	-24(%rbp), %eax
	addl	%eax, -20(%rbp)
	movl	-20(%rbp), %eax
	//printf
	movl	%eax, %esi
	leaq	.LC0(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	//两步完成a=t
	movl	-12(%rbp), %eax
	movl	%eax, -24(%rbp) 
	//i=i+1
	addl	$1, -16(%rbp)
.L2:
	//.L3顺序执行到此结束 判断循环条件

	//两步判断循环条件 i<n
	movl	-28(%rbp), %eax
	cmpl	%eax, -16(%rbp)
	//进入while循环体 跳转.L3
	jl	.L3
	movl	$0, %eax
	movq	-8(%rbp), %rdx
	xorq	%fs:40, %rdx
	je	.L5
	call	__stack_chk_fail@PLT
.L5:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
