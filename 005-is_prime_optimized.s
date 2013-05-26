# is_prime_optimized.s
# Tells if a number is prime on a more optimized way
# (without checking on even numbers and going untill the half of the number in question)

	.data
num:	.word	743711				# This is the number we'll test to see
						# if it's prime.
						# It will be located by the label `num`
	.text
main:

	lw	$a0, num
	jal	is_prime			# Send the number to the procedure!

	add	$a0, $zero, $v0			# Send the result as an argument to...
	li	$v0, 1				# ...print integer onscreen
	syscall

	li	$v0, 10				# exit the program
	syscall	

## Tells if an unsigned number is prime (optimized version)
# $a0	The number to check if it's prime
# $v0	1 if the number is prime, 0 if it's not
#
# This version's optimized because it only checks
# division by 2 and the rest of the not even numbers
# until the square root of the number.
#
# Internal use of registers:
# $s0: number of bits
# $s1: counter
# $s2: tmp
# $s3:
# $s4: copy of $a0
is_prime:
	addi	$sp, $sp, -24				# We'll save 6 numbers on the stack
	sw	$ra, 20($sp)				# to make this procedure safe
	sw	$s0, 16($sp)				# to use on a large-scale basis
	sw	$s1, 12($sp)				# (or inside other procedures)
	sw	$s2, 8($sp)				
	sw	$s3, 4($sp)
	sw	$s4, 0($sp)
	
	addu	$s0, $zero, $zero			# int r = sqrt(num)
	
	addu	$s4, $zero, $a0				# Also, saving previous $a0
	
	jal	no_of_bits				# Get the number of bits to represent
							# the first argument ($a0)
	sra	$s0, $v0, 1				# Divide it by 2								
	addiu	$s1, $zero, 2				# int count = 2

							# First things first:
							# let's test if the number is even.
							# If it is, let's just get the hell outta
							# here
	addiu	$s2, $zero, 2				# Dividing by 2...								
	divu	$s4, $s1					
	mfhi	$s2					# c = (num % x)
	sltiu	$s2, $s2, 1				
	bne	$s2, $zero, is_prime_end_not_prime	# if (c != 0)
	addu	$v0, $zero, $zero			# then exit
							# else continue
				
is_prime_test:
	addu	$a0, $zero, $s1				# Let's get the number of bits necessary
	jal	no_of_bits				# to represent the current counter
	
	sltu	$s2, $v0, $s0				# If it's more than the half of the argument
	beq	$s2, $zero, is_prime_end_is_prime	# then exit! It's prime!
	
is_prime_loop:		
	divu	$s4, $s1					
	mfhi	$s2					# c = (num % x)
	sltiu	$s2, $s2, 1				
	bne	$s2, $zero, is_prime_end_not_prime	# if (c == 0)
	addu	$v0, $zero, $zero			# then exit!
							# else...
	addiu	$s1, $s1, 2				# count += 2
	j	is_prime_test				# continue the loop	
																																																						
is_prime_end_is_prime:	
	lw	$s4, 0($sp)				
	lw	$s3, 4($sp)				# preparing to quit...
	lw	$s2, 8($sp)
	lw	$s1, 12($sp)
	lw	$s0, 16($sp)
	lw	$ra, 20($sp)	
	addi	$sp, $sp, 20				# We've loaded 5 numbers from the stack...		

	addiu	$v0, $zero, 1				# Else, it's prime!
	jr	$ra					# return 1

is_prime_end_not_prime:							
	lw	$s4, 0($sp)				
	lw	$s3, 4($sp)				# preparing to quit...
	lw	$s2, 8($sp)
	lw	$s1, 12($sp)
	lw	$s0, 16($sp)
	lw	$ra, 20($sp)
	addi	$sp, $sp, 20				# We've loaded 5 numbers from the stack...		
	
	jr	$ra					# return 0

## Returns the number of bits necessary to represent an unsigned number.
# $a0	The unsigned number we'll calculate
# $v0	The ammount
no_of_bits:
	add	$t0, $zero, $zero
	
no_of_bits_test:
	beq	$a0, $zero, no_of_bits_end
	srl	$a0, $a0, 1
	addi	$t0, $t0, 1
	j	no_of_bits_test
	
no_of_bits_end:	
	add	$v0, $zero, $t0
	jr	$ra
