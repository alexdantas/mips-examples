        ## Yay, my first MIPS Assembly program!
        ## It simply sums 2 variables onto a third.

        .text                   # Next commands are interpreted as text

        .globl main             # Sets label main: as global

main:
		addi	$t0, $zero, 3   # a = 3
		addi    $t1, $zero, 2   # b = 2

        add		$t2, $t0, $t1   # c = a + b

        jr		$ra             # Return to caller

