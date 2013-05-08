# Multiplies a matrix by a scalar
# In this case, we'll multiply this matrix:
#
#  1 2
#  3 4
#  5 6
#
# By a scalar, say, 3

	.data
scalar:	.word	3	
mat:	.word	1, 2, 3, 4, 5, 6
lines:	.word	3
cols:	.word	2
tab:	.asciiz	"\t"
endl:	.asciiz	"\n"

	.text
main:
	addi	$s0, $zero, 13		# Setting $s0 just to be sure my function doesnt
					# override it
					
	lw	$a0, scalar
	la	$a1, mat				
	lw	$a2, lines
	lw	$a3, cols
	jal	mul_mat_scalar
	
	
	li	$v0, 10			# exit
	syscall

## Multiplies a matrix by a scalar
# $a0 scalar
# $a1 matrix
# $a2 n_lines
# $a3 n_cols
mul_mat_scalar:				
	addi	$sp, $sp, -4		
	sw	$s0, 0($sp)		# saving previous $s0
	move	$s0, $a0		# $s0 = $a0
	
	add	$t0, $zero, $zero	# i = 0
	
mul_mat_scalar_test1:
	seq	$t7, $t0, $a2			# if (i == n_lines)
	bne	$t7, $zero, mul_mat_scalar_end1	# then exit
						# else continue
	add	$t1, $zero, $zero		# j = 0
	
mul_mat_scalar_test2:
	seq	$t7, $t1, $a3			# if (j == n_cols)
	bne	$t7, $zero, mul_mat_scalar_end2 # then go to the next line
						# else, keep going
						
	mul	$t7, $a3, $t0			# b = lines * i
	add	$t7, $t7, $t1			# b += j					
	sll	$t7, $t7, 2			# b *= 4 (converting to word address)	
	add	$t7, $t7, $a1			# b = matrix[b]
						# (or b = matrix[i * lines + j])
						# (of b = matrix[i][j])
	lw	$t6, 0($t7)					
	mul	$t7, $t6, $s0			# Finally, matrix[i][j] * num					


	li	$v0, 1				# Will print integer
	add	$a0, $zero, $t7			# printf($t7)
	syscall
	
	li	$v0, 4				# Will print string
	la	$a0, tab			# printf("\t")
	syscall		
	
	addi	$t1, $t1, 1			# j++
	j	mul_mat_scalar_test2
						
mul_mat_scalar_end2:
	li	$v0, 4				# Will print string
	la	$a0, endl			# printf("\n")
	syscall
	
	addi	$t0, $t0, 1			# i++	
	j	mul_mat_scalar_test1		# Finished this line, lets go to the next!
								
mul_mat_scalar_end1:
	lw	$s0, 0($sp)			
	addi	$sp, $sp, 4			# restore previous $s0
	jr	$ra				# return	
							
										
																