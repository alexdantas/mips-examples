# is_prime.s
# Tells if a number is prime

	.data
num:	.word	3				# This is the number we'll test to see
							# if it's prime.
							# It will be located by the label `num`
	.text
main:

	lw	$a0, num
	jal	is_prime				# Send the number to the procedure!

	add	$a0, $zero, $v0		# Send the result as an argument to...
	li	$v0, 1				# ...print integer onscreen
	syscall

	li	$v0, 10				# exit the program
	syscall	

## Tells if a number is prime
# $a0	The number to check if it's prime
# $v0	1 if the number is prime, 0 if it's not
is_prime:
	addi	$t0, $zero, 2				# int x = 2
	
is_prime_test:
	slt	$t1, $t0, $a0				# if (x > num)
	bne	$t1, $zero, is_prime_loop		
	addi	$v0, $zero, 1				# It's prime!
	jr	$ra						# return 1

is_prime_loop:						# else
	div	$a0, $t0					
	mfhi	$t3						# c = (num % x)
	slti	$t4, $t3, 1				
	beq	$t4, $zero, is_prime_loop_continue	# if (c == 0)
	add	$v0, $zero, $zero				# its not a prime
	jr	$ra							# return 0

is_prime_loop_continue:		
	addi $t0, $t0, 1				# x++
	j	is_prime_test				# continue the loop
