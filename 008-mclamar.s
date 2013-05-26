# Computes McLamar(n)
#
# McLamar is a series of numbers defined by my college teacher,
# Mr. Lamar.
#
# It's defined as follows:
#
# McLamar(n) = McLamar(n - 1)  - McLamar(n - 2)/4
# McLamar(0) = 0
# McLamar(1) = 1

	.data
	
# This is the index we'll calculate McLamar from
num:	.word	10

	.text
main:

	lw	$a0, num
	jal	mclamar

	li	$v0, 2		# Will print float
	
	mtc1	$zero, $f6	# float zero = 0
	cvt.s.w	$f6, $f6	
	
	add.s	$f12, $f6, $f30	# printing McLamar's return
	syscall
	
	li	$v0, 10		# exit
	syscall

## Computes McLamar(n)
# $a0	Integer index to calculate
# $f30	Floating-point result
#
# Internal use
# $t0	Temporary stuff
# $f0	A
# $f2	B
# $f4	Temporary float stuff
# $f6   Use it as a float $zero
mclamar:
	beq	$a0, $zero, mclamar_return_zero
	slti	$t0, $a0, 2
	bne	$t0, $zero, mclamar_return_one
	j	mclamar_main

mclamar_return_zero:
	add	$t0, $zero, $zero
	j	mclamar_return
	
mclamar_return_one:
	addi	$t0, $zero, 1
	j	mclamar_return
	
mclamar_return:
	mtc1	$t0, $f30
	cvt.s.w	$f30, $f30
	jr	$ra
	
mclamar_main:
	mtc1	$zero, $f6			# float zero = 0
	cvt.s.w	$f6, $f6	

	addi	$sp, $sp, -72
	sw	$ra, 0($sp)
	sw	$a0, 4($sp)
	swc1	$f0, 8($sp)
	swc1	$f2, 40($sp)

	addi	$a0, $a0, -1
	jal	mclamar
	add.s	$f0, $f6, $f30
	
	lw	$a0, 4($sp)
	addi	$a0, $a0, -2
	jal	mclamar
	add.s	$f2, $f6, $f30
	
	addi	$t0, $zero, 4
	mtc1	$t0, $f4
	cvt.s.w	$f4, $f4
	div.s	$f2, $f2, $f4
	
	sub.s	$f0, $f0, $f2
	add.s	$f30, $f6, $f0

	lw	$ra, 0($sp)
	lw	$a0, 4($sp)
	lwc1	$f0, 8($sp)
	lwc1	$f2, 40($sp)		
	addi	$sp, $sp, 72
	jr	$ra
