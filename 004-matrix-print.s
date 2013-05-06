# Does operations on martrixes
# `mat` means
#    1, 2, 3
#    4, 5, 6
#    7, 8, 9
# `MAT` means
#    9, 8, 7
#    6, 5, 4
#    3, 2, 1

	.data
mat:	.word	1, 2, 3, 4, 5, 6, 7, 8, 9
MAT:	.word	9, 8, 7, 6, 5, 4, 3, 2, 1
size:	.word	3

endl:	.asciiz	"\n"
tab:	.asciiz	"\t"

	.text
main:
	la	$a0, mat
	lw	$a1, size
	jal	mat_print
	
	li	$v0, 10
	syscall
			
## Pretty-prints a matrix into standard output
# $a0	Address of matrix's first word
# $a1	Matrix's size
mat_print:			
	add	$t3, $zero, $a0
	add	$t0, $zero, $zero			# i = 0

mat_print_while1:	
	add	$t7, $zero, $zero
	slt	$t7, $t0, $a1				# if (i < `size`) continue
	beq	$t7, $zero, mat_print_end	# if not, we've finished printing the whole matrix
	
	add	$t1, $zero, $zero			# j = 0
	
mat_print_while2:
	add	$t6, $zero, $zero
	slt	$t6, $t1, $a1				# if (j < `size`) continue
	beq	$t6, $zero, mat_print_end_line	# if not, we've finished printing the current line

	mul	$t5, $t0, $a1				# c = i * `size`
	add	$t5, $t5, $t1				# c += j
	sll	$t4, $t5, 2				# (converting j to address size)
	add	$t5, $t4, $t3				# c = `matrix [i * size + j]
	li	$v0, 1
	lw	$a0, 0($t5)				# printf("%d", c)
	syscall
	
	li	$v0, 4
	la	$a0, tab					# printf("\t")
	syscall
	
	addi	$t1, $t1, 1				# j++
	j	mat_print_while2

mat_print_end_line:					# printf("\n")
	li	$v0, 4
	la	$a0, endl
	syscall
	
	addi	$t0, $t0, 1				# i++
	j	mat_print_while1		
			
mat_print_end:						# goodbye!
	jr	$ra
