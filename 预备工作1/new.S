	.text
	.file	"try.c"
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2               # -- Begin function main
.LCPI0_0:
	.long	3212836864              # float -1
	.text
	.globl	main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$80, %rsp
	movl	$40, %edi
	callq	malloc
	movq	%rax, -16(%rbp)
	movl	$0, -4(%rbp)
.LBB0_1:                                # =>This Inner Loop Header: Depth=1
	cmpl	$10, -4(%rbp)
	jge	.LBB0_6
# %bb.2:                                #   in Loop: Header=BB0_1 Depth=1
	cvtsi2ssl	-4(%rbp), %xmm0
	movslq	-4(%rbp), %rax
	movss	%xmm0, -64(%rbp,%rax,4)
	movl	$10, %eax
	subl	-4(%rbp), %eax
	cvtsi2ss	%eax, %xmm0
	movq	-16(%rbp), %rax
	movslq	-4(%rbp), %rcx
	movss	%xmm0, (%rax,%rcx,4)
	movslq	-4(%rbp), %rax
	movss	-64(%rbp,%rax,4), %xmm0 # xmm0 = mem[0],zero,zero,zero
	movq	-16(%rbp), %rax
	movslq	-4(%rbp), %rcx
	ucomiss	(%rax,%rcx,4), %xmm0
	jne	.LBB0_4
	jp	.LBB0_4
# %bb.3:                                #   in Loop: Header=BB0_1 Depth=1
	movss	.LCPI0_0(%rip), %xmm0   # xmm0 = mem[0],zero,zero,zero
	movslq	-4(%rbp), %rax
	movss	%xmm0, -64(%rbp,%rax,4)
	movq	-16(%rbp), %rax
	movslq	-4(%rbp), %rcx
	movss	%xmm0, (%rax,%rcx,4)
.LBB0_4:                                #   in Loop: Header=BB0_1 Depth=1
	jmp	.LBB0_5
.LBB0_5:                                #   in Loop: Header=BB0_1 Depth=1
	movl	-4(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -4(%rbp)
	jmp	.LBB0_1
.LBB0_6:
	xorl	%eax, %eax
	addq	$80, %rsp
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.ident	"clang version 10.0.0-4ubuntu1 "
	.section	".note.GNU-stack","",@progbits
