
.test

		.globl main

		## Uma tentativa de fazer
		## A = B + 3C
		## A = 2A

main:
		sw		$t0, 4				  # int c
		sw		$t1, 5				  # int b
		muli	$t0, $t0, 3			  # c = c * 3
		add		$t1, $t0, $t1		  # b = b + c
		muli	$t1, $t1, 2			  # a = 2 a

