# Gemini prime numbers saved on a file
# A prime number is considered `gemini` if the next prime number
# is him plus two.
# In other words:
# 	Gemini(x) if (isPrime(y) and (y == (x + 2)))
#
# This program saves all gemini numbers from 1 to n into a file
	.data
num:	.word	100
file:	.asciiz	"gemini.txt"
str1:	.asciiz	"Gemini("
str2:	.asciiz	") = \t"
str3:	.asciiz	"\t"
str4:	.asciiz	"\n"

	.text
main:				# Loop until all the geminis we want were printed on the file
	li	$v0, 13		# Here, we open the file for writing
	la	$a0, file	# with the filename.
	li	$a1, 1		# The file mode (0: read, 1: write)
	li	$a2, 0
	syscall
	
	move	$s4, $v0			# Saving the file descriptor
	
	addi	$s7, $zero, 1			# i = 1
	lw	$s6, num			# a = `ammount of geminis to look for`
	
test:	slt	$s5, $s7, $s6			# if (i < a) continue
	beq	$s5, $zero, exit		# else, finish executing
	
	li	$v0, 15				# fwrite(
	move	$a0, $s4			# FILE* fp,
	la	$a1, str1			# str1,
	li	$a2, 28				# strlen(str1)
	syscall					# )

	li	$v0, 1				# print number the user typed
	add	$a0, $zero, $s7
	syscall

	li	$v0, 4				# continue to print string
	la	$a0, str2
	syscall
		
	add	$a0, $zero, $s7			# Here's where we actually calculate the gemini
	jal	pg

	add	$t1, $zero, $v0			# save the result and
	add	$a0, $zero, $t1			# send it as an argument to...	
	li	$v0, 1				# ...print integer onscreen
	syscall

	li	$v0, 4				# continue to print string
	la	$a0, str3
	syscall

	addi	$a0, $t1, 2			# print result gemini + 2
	li	$v0, 1	
	syscall

	li	$v0, 4				# finish to print string
	la	$a0, str4
	syscall

	addi	$s7, $s7, 1			# i++
	j	test
		
exit:	
	li	$v0, 16				# fclose(FILE)
	move	$a0, $s4
	syscall
	
	li	$v0, 10				# exit
	syscall	

## Returns the first element of the n pair of gemini prime numbers
# $a0	The number of pairs to look for
pg:		
	addi	$s0, $zero, 1			# int gemini count (how many gemini primes we've considered)
	addi	$s1, $zero, 1			# int current gemini (always a gemini prime)
	add	$s2, $zero, $s1			# int current number (can be any number - prime or not)

pg_test:
	addi	$t7, $a0, 1
	slt	$t7, $s0, $t7			# if `gemini_count` is less or equal than `number_of_pairs_to_look_for`
	bne	$t7, $zero, pg_while		# Then go to the loop, because we need some more
	add	$v0, $zero, $s1			# else	
	jr	$ra				# return `current gemini`, we're done here.
					
pg_while:					# while (`number` is not prime...)
	addi	$sp, $sp, -8				
	sw	$a0, 4($sp)			# Saving `number_of_pairs_to_look_for` on the stack
	sw	$ra, 0($sp)			# along with the return address
	
pg_while_begin:	
	add	$a0, $zero, $s2			# if `number` is prime
	jal	is_prime
	bne	$v0, $zero, pg_while_end	# Then get out
	addi $s2, $s2, 1			# else, `number`++
	j	pg_while_begin			# And go back to the loop
	
pg_while_end:					# Here, `number` surely is prime	
	addi	$t7, $s2, 2			# `number` + 2
	add	$a0, $zero, $t7			# is it prime?
	jal	is_prime
	bne	$v0, $zero, pg_found_gemini	# Yes, it is!
	j	pg_didnt_find_gemini		# No, it isn't!

pg_found_gemini:				# Since we found it,
	addi	$s0, $s0, 1			# let's increase the counter for gemini primes,
	add	$s1, $zero, $s2			# and assign the current `number` to the `current_geminy`.

pg_didnt_find_gemini:				# ...let's just test the next number, then...
	
pg_go_back_to_test:				# Wether we found it or not, we should
	addi $s2, $s2, 1			# increase the current `number`,
	lw	$a0, 4($sp)			# and get the previous $a0 from the stack,
	lw	$ra, 0($sp)			# along with the return address,
	addi	$sp, $sp, 8			# storing it where it belongs.
	j pg_test				# Let's see if the loop's over								

## Tells if a number is prime
# $a0	The number to check if it's prime
# $v0	1 if the number is prime, 0 if it's not
is_prime:
	addi	$t0, $zero, 2				# int x = 2
	
is_prime_test:
	slt	$t1, $t0, $a0				# if (x > num)
	bne	$t1, $zero, is_prime_loop		
	addi	$v0, $zero, 1				# It's prime!
	jr	$ra					# return 1

is_prime_loop:						# else
	div	$a0, $t0					
	mfhi	$t3					# c = (num % x)
	slti	$t4, $t3, 1				
	beq	$t4, $zero, is_prime_loop_continue	# if (c == 0)
	add	$v0, $zero, $zero			# its not a prime
	jr	$ra					# return 0

is_prime_loop_continue:		
	addi $t0, $t0, 1				# x++
	j	is_prime_test				# continue the loop
