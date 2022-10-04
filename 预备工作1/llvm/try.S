	.arch armv7-a
	.eabi_attribute 28, 1
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 6
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.file	"try.c"
	.text
	.align	1
	.global	main
	.arch armv7-a
	.syntax unified
	.thumb
	.thumb_func
	.fpu vfpv3-d16
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 56
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #56
	add	r7, sp, #0
	ldr	r2, .L7
.LPIC0:
	add	r2, pc
	ldr	r3, .L7+4
	ldr	r3, [r2, r3]
	ldr	r3, [r3]
	str	r3, [r7, #52]
	
	mov	r3,#0
	movs	r0, #40
	bl	malloc(PLT)
	mov	r3, r0
	str	r3, [r7, #8]

	movs	r3, #0
	str	r3, [r7, #4]
	b	.for

.else:
.add_i:
	ldr	r3, [r7, #4]
	adds	r3, r3, #1
	str	r3, [r7, #4]
.for:
	ldr	r3, [r7, #4]
	cmp	#10, r3
	blt	.exit_for

	ldr	r3, [r7, #4]
	vmov	s15, r3	@ int
	vcvt.f32.s32	s15, s15
	ldr	r3, [r7, #4] # i
	lsls	r3, r3, #2
	add	r2, r7, #56
	add	r3, r3, r2
	subs	r3, r3, #44
	vstr.32	s15, [r3]
	
	ldr	r3, [r7, #4]
	rsb	r1, r3, #10
	ldr	r3, [r7, #4]
	lsls	r3, r3, #2
	ldr	r2, [r7, #8] # p
	add	r3, r3, r2
	
	vmov	s15, r1	@ int
	vcvt.f32.s32	s15, s15
	vstr.32	s15, [r3]
	
	ldr	r3, [r7, #4]
	lsls	r3, r3, #2
	add	r2, r7, #56
	add	r3, r3, r2
	subs	r3, r3, #44
	vldr.32	s14, [r3]
	
	ldr	r3, [r7, #4]
	lsls	r3, r3, #2
	ldr	r2, [r7, #8]
	add	r3, r3, r2
	vldr.32	s15, [r3]
	
	vcmp.f32	s14, s15
	vmrs	APSR_nzcv, FPSCR
	bne	.else
	
.if:
	ldr	r3, [r7, #4]
	lsls	r3, r3, #2
	add	r2, r7, #56
	add	r3, r3, r2
	subs	r3, r3, #44
	mov	r2, #0
	movt	r2, 49024
	str	r2, [r3]	@ float
	
	ldr	r3, [r7, #4]
	lsls	r3, r3, #2
	ldr	r2, [r7, #8]
	add	r3, r3, r2
	mov	r2, #0
	movt	r2, 49024
	str	r2, [r3]	@ float
	
	b .add_i
	
.exit_for:
	movs	r3, #0
	ldr	r1, .L7+8
.LPIC1:
	add	r1, pc
	ldr	r2, .L7+4
	ldr	r2, [r1, r2]
	ldr	r1, [r2]
	ldr	r2, [r7, #52]
	eors	r1, r2, r1
	mov	r2, #0
	beq	.L6
	bl	__stack_chk_fail(PLT)
.L6:
	mov	r0, r3
	adds	r7, r7, #56
	mov	sp, r7
	@ sp needed
	pop	{r7, pc}
.L8:
	.align	2
.L7:
	.word	_GLOBAL_OFFSET_TABLE_-(.LPIC0+4)
	.word	__stack_chk_guard(GOT)
	.word	_GLOBAL_OFFSET_TABLE_-(.LPIC1+4)
	.size	main, .-main
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0"
	.section	.note.GNU-stack,"",%progbits
