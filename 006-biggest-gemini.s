# Prints the biggest gemini that can be represented
# on an unsigned 32-bit register.
#
# If you're still unsure about gemini prime numbers, check
# out the other files around there

	.data
str1:	.asciiz	"P[i + 2] = "
str2:	.asciiz	"P[i]     = "
newl:	.asciiz "\n"
str3:	.asciiz	", "
str4:	.asciiz	")\n"

	.text
	addiu	$s5, $zero, -1			# Getting the biggest unsigned number possible
main:
	addu	$a0, $zero, $s5			# is it prime?
	jal	is_prime
	bne	$v0, $zero, found_first_biggest	# Yes, it is!
	
not_found_biggest:				# No, it isn't
	addiu	$s5, $s5, -1			# Let's decrement it and
	j	main				# try again
		
found_first_biggest:				# Ok, `num` is prime
	addiu	$a0, $s5, -2			# but is (`num` - 2) prime?
	jal	is_prime
	beq	$v0, $zero, not_found_biggest	# Nope! Try again!

found_second_biggest:				# YES! We found them both!						
	li	$v0, 4				# Printing introductory string
	la	$a0, str1
	syscall

	li	$v0, 36				# Print unsigned (`num` + 2)
	add	$a0, $zero, $s5
	syscall

	li	$v0, 4				# continue to print string
	la	$a0, newl
	syscall
		
		
	li	$v0, 4				# Printing another introductory string
	la	$a0, str2
	syscall

	li	$v0, 36				# Print unsigned `num`
	addi	$a0, $s5, -2
	syscall

	li	$v0, 4				# Continue to print string
	la	$a0, newl
	syscall
		
	li	$v0, 10				# exit
	syscall	

## Returns the first element of the n pair of gemini prime numbers
# $a0	The number of pairs to look for
pg:		
	addi	$s0, $zero, 1				# int gemini count (how many gemini primes we've considered)
	addi	$s1, $zero, 1				# int current gemini (always a gemini prime)
	add	$s2, $zero, $s1				# int current number (can be any number - prime or not)

pg_test:
	addi	$t7, $a0, 1
	slt	$t7, $s0, $t7				# if `gemini_count` is less or equal than `number_of_pairs_to_look_for`
	bne	$t7, $zero, pg_while			# Then go to the loop, because we need some more
	add	$v0, $zero, $s1				# else	
	jr	$ra						# return `current gemini`, we're done here.
					
pg_while:							# while (`number` is not prime...)
	addi	$sp, $sp, -8				
	sw	$a0, 4($sp)				# Saving `number_of_pairs_to_look_for` on the stack
	sw	$ra, 0($sp)				# along with the return address
	
pg_while_begin:	
	add	$a0, $zero, $s2			# if `number` is prime
	jal	is_prime
	bne	$v0, $zero, pg_while_end		# Then get out
	addi $s2, $s2, 1				# else, `number`++
	j	pg_while_begin				# And go back to the loop
	
pg_while_end:						# Here, `number` surely is prime	
	addi	$t7, $s2, 2				# `number` + 2
	add	$a0, $zero, $t7				# is it prime?
	jal	is_prime
	bne	$v0, $zero, pg_found_gemini	# Yes, it is!
	j	pg_didnt_find_gemini		# No, it isn't!

pg_found_gemini:					# Since we found it,
	addi	$s0, $s0, 1				# let's increase the counter for gemini primes,
	add	$s1, $zero, $s2			# and assign the current `number` to the `current_geminy`.

pg_didnt_find_gemini:				# ...let's just test the next number, then...
	
pg_go_back_to_test:					# Wether we found it or not, we should
	addi $s2, $s2, 1				# increase the current `number`,
	lw	$a0, 4($sp)				# and get the previous $a0 from the stack,
	lw	$ra, 0($sp)				# along with the return address,
	addi	$sp, $sp, 8				# storing it where it belongs.
	j pg_test						# Let's see if the loop's over								

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
