	.global	main
main:
	push	{r7}
	sub	sp, sp, #20
	mov	r7, sp
	movs	r3, #0
	str	r3, [r7, #4]
	movs	r3, #1
	str	r3, [r7, #8]
	movs	r3, #1
	str	r3, [r7, #12]
.while:
	ldr	r2, [r7, #12]
	ldr	r3, [r7, #16]
	cmp	r3, r2
	blt	.exit_while
	ldr	r3, [r7, #8]
	str	r3, [r7, #20]
	ldr	r2, [r7, #8]
	ldr	r3, [r7, #4]
	add	r3, r3, r2
	str	r3, [r7, #8]
	ldr	r3, [r7, #20]
	str	r3, [r7, #4]
	ldr	r3, [r7, #12]
	adds	r3, r3, #1
	str	r3, [r7, #12]
.exit_while:
	movs	r3, #0
	mov	r0, r3
	adds	r7, r7, #20
	adds	sp, sp, #20
