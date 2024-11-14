
# Запуск теста

.macro run_test_case(%e, %answer)
	fld fs1, %e, s1
	fld fs2, %answer, s2
	check_accuracy_bool(fs1)
	bgtz a0, error_case
	
	half_division_wrapper(fs1)
	fmv.d fs3, fa0
	
	fge.d t3, fs3, fs2
	fge.d t4, fs2, fs3
	
	add t0, t3, t4
	addi t0, t0, -2
	
	bnez t0, wrong_answer_first
	print_str("Test passed : e = ")
	print_double(fs1)
	print_str("; output = ")
	print_double(fs3)
	print_str("; answer = ")
	print_double(fs2)
	print_newline()
	j final_run_test_case
wrong_answer_first:
	print_str("Test failed : e = ")
	print_double(fs1)
	print_str("; output = ")
	print_double(fs3)
	print_str("; answer = ")
	print_double(fs2)
	print_newline()
	j final_run_test_case
error_case:
	li t0, 0
	fcvt.d.w ft0, t0
	fge.d t1, fs2, ft0
	bnez t1, wrong_answer_second
	print_str("Test passed : e = ")
	print_double(fs1)
	print_str("; output = Incorrect accuracy;")
	print_str(" answer = Incorrect accuracy;")
	print_newline()
	j final_run_test_case
wrong_answer_second:
	print_str("Test failed : e = ")
	print_double(fs1)
	print_str("; output = Incorrect accuracy;")
	print_str(" answer = Incorrect answer. Please fix test data;")
	print_newline()
final_run_test_case:
.end_macro


# Макро для вызова подпрограммы основного алгоритма:
.macro half_division_wrapper(%e)
	fmv.d fa0, %e			# передаем подпрограмме половинного деления значение точности
	jal half_division		# вызываем подпрограмму основного алгоритма
.end_macro


# Макро для вызова подпрограммы расчета значения функции в точке:
.macro compute_func_value_wrapper(%x)
	fmv.d fa0, %x			# передаем подпрограмме расчета значения функции точку
	jal compute_func_value		# вызываем подпрограмму рассчета значения
.end_macro

.macro check_accuracy_bool(%x)
 .data
	a: .double 0.00000001
	b: .double 0.001
.text
	fld ft1, a, t1
	fld ft2, b, t2
	fgt.d t1, ft1, %x
	fgt.d t2, %x, ft2
	add a0, t1, t2
.end_macro


# Проверка входных данных.

.macro check_accuracy(%x)
	check_accuracy_bool(%x)
	bgtz a0, accuracy_error
	j end_check_accuracy
accuracy_error:
	print_str("Incorrect accuracy. The accuracy should be between 0.00000001 and 0.001\n")
	exit()
end_check_accuracy:
.end_macro

.macro read_double(%x)
	li a7, 7
	ecall
	fmv.d %x, fa0
.end_macro

.macro print_double(%x)
	li a7, 3
	fmv.d fa0, %x
	ecall
.end_macro

.macro print_str(%x)
.data
	str: .asciz %x
.text
	push(a0)
	li a7, 4
	la a0, str
	ecall
	pop(a0)
.end_macro

.macro print_char(%x)
	push(a0)
	li a7, 11
	li a0, %x
	ecall
	pop(a0)
.end_macro

.macro print_space()
	print_char(' ')
.end_macro

.macro print_newline()
	print_char('\n')
.end_macro

.macro exit()
    li a7, 10
    ecall
.end_macro

# Сохранение заданного регистра на стеке
.macro push(%x)
	addi	sp, sp, -4
	sw	%x, (sp)
.end_macro

# Выталкивание значения с вершины стека в регистр
.macro pop(%x)
	lw	%x, (sp)
	addi	sp, sp, 4
.end_macro

.macro push_double(%x)
	addi	sp, sp, -8
	fsd	%x, (sp)
.end_macro

.macro pop_double(%x)
	fld	%x, (sp)
	addi	sp, sp, 8
.end_macro
