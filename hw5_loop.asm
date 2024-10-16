.text
.main:
	jal max_fact
	li a7, 1
	ecall
	li a7, 10
	ecall

max_fact:
	addi sp, sp, -4
	sw ra, (sp)
	mv t0, zero
	li t1, 1
max_fact_while:
	mv t2, t1
	addi t0, t0, 1
	mul t1, t2, t0
	div t3, t1, t2
	bne t3, t0, max_fact_end_while
	j max_fact_while
max_fact_end_while:
	mv a0, t2
	lw ra, (sp)
	addi sp, sp, 4
	ret

