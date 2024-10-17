.data
	message: .asciz "! = "
.text
.main:
	mv a0, zero # n
	li a1, 1 # n!
	jal max_fact
	li a7, 1
	ecall
	
	li a7, 4
	la a0, message
	ecall
	
	li a7, 1
	mv a0, a1
	ecall
	
	li a7, 10
	ecall

max_fact:
	addi sp, sp, -4
	sw ra, (sp)
max_fact_while:
	mv t0, a0
	mv t1, a1
	mv t2, t1
	addi t0, t0, 1 # n -> n + 1
	mul t1, t1, t0 # n! -> (n + 1)!
	div t2, t1, a1 # (n + 1)! / n!
	bne t2, t0, max_fact_end_while
	mv a0, t0
	mv a1, t1
	j max_fact_while
max_fact_end_while:
	lw ra, (sp)
	addi sp, sp, 4
	ret
