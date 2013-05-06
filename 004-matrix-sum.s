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
	la	$a1, MAT
	lw	$a2, size
	jal	mat_sum
		
	li	$v0, 10
	syscall

## Sums two matrixes $a0 and $a1, with size $a3, while printing the resulting matrix.
# $a0, $a1	Address of matrix's first word	
# $a2		Matrixes' size
mat_sum:	
	add	$t0, $zero, $zero			# i = 0
	la	$t2, 0($a0)
	
mat_sum_while1:
	add	$t7, $zero, $zero
	slt	$t7, $t0, $a2
	beq	$t7, $zero, mat_sum_end

	add	$t1, $zero, $zero			# j = 0

mat_sum_while2:		
	add	$t7, $zero, $zero
	slt	$t7, $t1, $a2
	beq	$t7, $zero, mat_sum_end_line

	mul	$t7, $t0, $a2
	add	$t7, $t7, $t1				# c = i * n + j
	sll	$t7, $t7, 2				# address format

	add	$t6, $t7, $t2				# d = `matrix_1`[c]
	add	$t5, $t7, $a1				# e = `matrix_2`[c]
	add	$a0, $t5, $t6				# print (d + e)	
	li	$v0, 1
	syscall
						
	addi	$t1, $t1, 1				# j++
	li	$v0, 4					# printf("\t")
	la	$a0, tab
				
	addi	$t1, $t1, 1
	
mat_sum_end_line:
	
	addi	$t0, $t0, 1				# i++
	li	$v0, 4					# printf("\n")
	la	$a0, endl
	syscall
	
	j	mat_sum_while1
	
mat_sum_end:	
	li	$v0, 4					# printf("\n")
	la	$a0, endl
	syscall
	
	jr	$ra					
		