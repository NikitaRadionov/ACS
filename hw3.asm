.data
	tests_or_input: .asciz "Введите 0 чтобы запустить тесты, 1 чтобы запустить программу: "
	input_dividend: .asciz "Введите делимое: "
	input_divisor: .asciz "Введите делитель: "
	output_quotient: .asciz "Частное: "
	output_remainder: .asciz "Остаток: "
	zero_division_error: .asciz "Ошибка: произошла попытка деления на ноль"
	endl: .asciz "\n"
	tests_sep:	.asciz "\nTEST "
	
	i:	.word 1
	
	test_dividend_1: .word 26
	test_dividend_2: .word -26
	test_divisor_1:	.word 3
	test_divisor_2:	.word -3
	test_divisor_0:	.word 0

.text
	li a7, 4
	la a0, tests_or_input
	ecall
	
	li a7, 5
	ecall
	
	mv t0, a0
	
	beqz t0, tests
	
	li a7, 4
	la a0, input_dividend
	ecall
	
	li a7, 5
	ecall
	
	mv t0, a0
	
	li a7, 4
	la a0, input_divisor
	ecall
	
	li a7, 5
	ecall
	
	mv t1, a0
	li t6, -1
	j algo

tests:
	la t6 i
	lw t6 0(t6)
test1:
	la t0 test_dividend_1
	lw t0 0(t0)
	la t1 test_divisor_0
	lw t1 0(t1)
	
	li a7 4
	la a0 tests_sep
	ecall
	mv a0 t6
	li a7 1
	ecall
	
	li a7 4
	la a0 endl
	ecall
	
	li a7 4
	la a0 input_dividend
	ecall
	li a7 1
	mv a0 t0
	ecall
	
	li a7 4
	la a0 endl
	ecall

	li a7 4
	la a0 input_divisor
	ecall
	li a7 1
	mv a0 t1
	ecall

	li a7 4
	la a0 endl
	ecall
	j algo
test2:
	la t0 test_dividend_1
	lw t0 0(t0)
	la t1 test_divisor_1
	lw t1 0(t1)
	
	li a7 4
	la a0 tests_sep
	ecall
	mv a0 t6
	li a7 1
	ecall
	
	li a7 4
	la a0 endl
	ecall
	
	li a7 4
	la a0 input_dividend
	ecall
	li a7 1
	mv a0 t0
	ecall
	
	li a7 4
	la a0 endl
	ecall

	li a7 4
	la a0 input_divisor
	ecall
	li a7 1
	mv a0 t1
	ecall

	li a7 4
	la a0 endl
	ecall
	j algo
test3:
	la t0 test_dividend_1
	lw t0 0(t0)
	la t1 test_divisor_2
	lw t1 0(t1)
	
	li a7 4
	la a0 tests_sep
	ecall
	mv a0 t6
	li a7 1
	ecall
	
	li a7 4
	la a0 endl
	ecall
	
	li a7 4
	la a0 input_dividend
	ecall
	li a7 1
	mv a0 t0
	ecall
	
	li a7 4
	la a0 endl
	ecall

	li a7 4
	la a0 input_divisor
	ecall
	li a7 1
	mv a0 t1
	ecall

	li a7 4
	la a0 endl
	ecall
	j algo
test4:
	la t0 test_dividend_2
	lw t0 0(t0)
	la t1 test_divisor_1
	lw t1 0(t1)
	
	li a7 4
	la a0 tests_sep
	ecall
	mv a0 t6
	li a7 1
	ecall
	
	li a7 4
	la a0 endl
	ecall
	
	li a7 4
	la a0 input_dividend
	ecall
	li a7 1
	mv a0 t0
	ecall
	
	li a7 4
	la a0 endl
	ecall

	li a7 4
	la a0 input_divisor
	ecall
	li a7 1
	mv a0 t1
	ecall

	li a7 4
	la a0 endl
	ecall
	j algo
test5:
	la t0 test_dividend_2
	lw t0 0(t0)
	la t1 test_divisor_2
	lw t1 0(t1)
	
	li a7 4
	la a0 tests_sep
	ecall
	mv a0 t6
	li a7 1
	ecall
	
	li a7 4
	la a0 endl
	ecall
	
	li a7 4
	la a0 input_dividend
	ecall
	li a7 1
	mv a0 t0
	ecall
	
	li a7 4
	la a0 endl
	ecall

	li a7 4
	la a0 input_divisor
	ecall
	li a7 1
	mv a0 t1
	ecall

	li a7 4
	la a0 endl
	ecall
	j algo

algo:
	beqz t1, zero_division_handler
	
	slti t2, t0, 0
	
	xor t3, t1, t0
	slti t3, t3, 0
	
	bltz t0, neg_dividend
	j continue_1

neg_dividend:
	neg t0 t0

continue_1:
	bltz t1, neg_divisor
	j continue_2

neg_divisor:
	neg t1 t1

continue_2:
	li t4, 0
	mv t5, t0

division_loop:
	blt t5 t1 quotient_sign
	sub t5 t5 t1
	addi t4 t4 1
	j division_loop

quotient_sign:
	beqz t3 remainder_sign
	neg t4 t4

remainder_sign:
	beqz t2 print_result
	neg t5 t5
 

print_result:
	li a7 4
	la a0 output_quotient
	ecall
	mv a0 t4
	li a7 1
	ecall
	
	li a7 4
	la a0 endl
	ecall
 
	li a7 4
	la a0 output_remainder
	ecall
	mv a0 t5
	li a7 1
	ecall
	bltz t6, exit
	j testing_cycle

zero_division_handler:
	la a0, zero_division_error
	li a7, 4
	ecall
	bltz t6, exit

testing_cycle:
	addi t6 t6 1
	li t0 1
	beq t6 t0 test1
	li t0 2
	beq t6 t0 test2
	li t0 3
	beq t6 t0 test3
	li t0 4
	beq t6 t0 test4
	li t0 5
	beq t6 t0 test5
exit:
	li a7 10
	ecall
	
