.eqv READ_ONLY	0	# Открыть для чтения
.eqv WRITE_ONLY	1	# Открыть для записи
.eqv APPEND	9	# Открыть для добавления
.macro open_for_test(%file_name, %opt)
    	li   	a7 1024     			# Системный вызов открытия файла
    	la      a0 %file_name   		# Имя открываемого файла
    	li   	a1 %opt        			# Открыть для чтения (флаг = 0)
    	ecall             			# Дескриптор файла в a0 или -1)
    	li	s1, -1				# Проверка на корректное открытие
    	beq	a0, s1, er_name			# Ошибка открытия файла
    	close(a0)
    	li	a0, 1
    	j final_open
er_name:
    	li	a0, 0
final_open:
.end_macro

.macro run_test_case(%input_file_name, %output_file_name, %answer)
.data
	error_filename: .asciz "Incorrect file name"
	error_bigfile: .asciz "Input file is too big"
	test_answer:	.space	40
.text
	open_for_test(%input_file_name, READ_ONLY)
	beqz	a0, error_filename_case
	read_file_heap_wrapper(%input_file_name, 512)
	beqz	a0, big_file_case
	algorithm_wrapper(a0)
	prepear_answer(test_answer)
	mv	s11, a0
	write_file_wrapper(%output_file_name, test_answer, s11)
	
	strcmp(test_answer, %answer)
	beqz a0, correct_case
	j incorrect_case
big_file_case:
	strcmp(error_bigfile, %answer)
	beqz a0, correct_case
	j incorrect_case
error_filename_case:
	strcmp(error_filename, %answer)
	beqz a0, correct_case
	j incorrect_case
correct_case:
	print_str("Test passed\n")
	j final_test_case
incorrect_case:
	print_str("Test failed\n")
final_test_case:

.end_macro

.macro check_file_size(%desc)
	mv	t1, %desc
	beqz	t1, check_failed
	j end_check
check_failed:
	print_str("Input file is too big")
	exit()
end_check:
.end_macro

.macro strcmp(%str1, %str2)
	la	a0, %str1
	la	a1, %str2
loop_strcmp:
    	lb      t0 (a0)     		# Загрузка символа из 1-й строки для сравнения
    	lb      t1 (a1)     		# Загрузка символа из 2-й строки для сравнения
    	beqz    t0 end_strcmp      	# Конец строки 1
    	beqz    t1 end_strcmp      	# Конец строки 2
    	bne     t0 t1 end_strcmp   	# Выход по неравенству
    	addi    a0 a0 1     		# Адрес символа в строке 1 увеличивается на 1
    	addi    a1 a1 1     		# Адрес символа в строке 2 увеличивается на 1
    	j       loop_strcmp
end_strcmp:
    	sub     a0 t0 t1    		# Получение разности между символами
# Нв выход в регистре a0 ответ: 0 если равны, иначе 1
.end_macro

.eqv	CHOICE_SIZE 3
.macro print_answer_console_dialog(%message, %answer, %error)
.data
	dialog_message: .asciz %message
	choice_buffer:	.space CHOICE_SIZE
	y:		.asciz "Y"
.text
get_str_choice:
	la a0, dialog_message
	la a1, choice_buffer
	li a2, CHOICE_SIZE
	li a7, 54
	ecall

	bnez a1, not_correct_choice
	j correct_choice
not_correct_choice:
	message_dialog(%error, 0)
	j get_str_choice
correct_choice:
    	li	t4, '\n'
    	la	t5, choice_buffer
choice_loop:
    	lb	t6, (t5)
    	beq 	t4, t6, choice_replace
    	addi 	t5, t5, 1
    	b	choice_loop
choice_replace:
    	sb	zero, (t5)
    	strcmp(y, choice_buffer)
    	beqz	a0, print_answer
    	j	choice_end
print_answer:
	la a0 %answer
	li a7 4
	ecall
choice_end:

.end_macro

.macro read_filename_dialog(%message, %file_name_buffer, %size, %error, %default)
.data
	dialog_message: .asciz %message
	default_name:	.asciz %default
.text
get_str:
	la a0, dialog_message
	la a1, %file_name_buffer
	li a2, %size
	li a7, 54
	ecall

	li t1, -4
	beqz a1, correct_dialog
	beq a1, t1, not_correct_dialog
	j default_dialog_value	
not_correct_dialog:
	message_dialog(%error, 0)
	j get_str

correct_dialog:
    	li	t4, '\n'
    	la	t5, %file_name_buffer
    	mv  	t3, t5		# Сохранение начала буфера для проверки на пустую строку
read_filename_dialog_loop:
    	lb	t6, (t5)
    	beq 	t4, t6, read_filename_dialog_replace
    	addi 	t5, t5, 1
    	b	read_filename_dialog_loop
read_filename_dialog_replace:
	beq 	t3, t5, default_dialog_value	# Установка имени введенного файла
    	sb	zero, (t5)
    	j	final_read_filename_dialog
default_dialog_value:
	strcpy(%file_name_buffer, default_name)
final_read_filename_dialog:
.end_macro

.macro message_dialog(%message, %type)
.data
	error_message: .asciz %message
.text
	la a0 error_message
	li a1 %type
	li a7 55
	ecall
.end_macro

.macro print_int(%x)
	push(a0)
	li a7, 1
	mv a0, %x
	ecall
	pop(a0)
.end_macro

.macro prepear_answer(%answer)
.data
	positive_answer:	.asciz	"Correct bracket sequence\n"
	negative_answer:	.asciz	"Incorrect bracket sequence\n"
.text
	beqz 	a0, prepear_negative_answer
	la	t0, positive_answer
	j continue_prepear_answer
prepear_negative_answer:
	la 	t0, negative_answer
continue_prepear_answer:
	la	t1, %answer
    	li	t4, '\n'
    	li	t5, 0
store_symbol_loop:
    	lb	t3, (t0)
    	sb	t3, (t1)
    	beq 	t4, t3, final_prepear_answer
    	addi 	t0, t0, 1
    	addi	t1, t1, 1
    	addi	t5, t5, 1
    	b	store_symbol_loop
final_prepear_answer:
	la	t1, %answer
	write_ending_zero(t1, t5)
	mv	a0, t5	
.end_macro

.macro open(%file_name, %opt)
    	li   	a7 1024     			# Системный вызов открытия файла
    	mv      a0 %file_name   		# Имя открываемого файла
    	li   	a1 %opt        			# Открыть для чтения (флаг = 0)
    	ecall             			# Дескриптор файла в a0 или -1)
    	li	s1, -1				# Проверка на корректное открытие
    	beq	a0, s1, er_name			# Ошибка открытия файла
    	j final_open
er_name:
    	print_str("Incorrect file name\n")	# Сообщение об ошибочном имени файла
    	exit()
final_open:
.end_macro


.macro read(%file_descriptor, %strbuf, %size)
    	li   a7, 63       		# Системный вызов для чтения из файла
    	mv   a0, %file_descriptor       # Дескриптор файла
    	la   a1, %strbuf   		# Адрес буфера для читаемого текста
    	li   a2, %size 			# Размер читаемой порции
    	ecall             		# Чтение
.end_macro

.macro write(%file_descriptor, %strbuf, %size)
   	li   	a7, 64       			# system call for write to file
   	mv   	a0, %file_descriptor       	# file descriptor
    	mv   	a1, %strbuf  			# address of buffer from which to write
    	mv   	a2, %size       		# hardcoded buffer length
    	ecall             			# write to file
.end_macro


.macro allocate(%size)
    	li a7, 9
    	mv a0, %size	# Размер блока памяти
    	ecall
.end_macro


.macro read_file_heap_wrapper(%file_name, %TEXT_SIZE)
	la a0, %file_name
	li a1, %TEXT_SIZE
	jal read_file_heap
.end_macro


# Чтение информации из открытого файла,
# когда адрес буфера в регистре
.macro read_addr_reg(%file_descriptor, %reg, %size)
    	li   	a7, 63       			# Системный вызов для чтения из файла
    	mv   	a0, %file_descriptor      	# Дескриптор файла
    	mv   	a1, %reg   			# Адрес буфера для читаемого текста из регистра
    	mv   	a2, %size 			# Размер читаемой порции
    	ecall             			# Чтение
	li	s1, -1				# Проверка на корректное открытие
    	beq	a0, s1, er_read			# Ошибка чтения
    	j	final_read_addr_reg
er_read:
    	# Сообщение об ошибочном чтении
    	print_str("Incorrect read operation\n")
    	exit()
final_read_addr_reg:
.end_macro

.macro close(%file_descriptor)
    	li   a7, 57       			# Системный вызов закрытия файла
    	mv   a0, %file_descriptor  		# Дескриптор файла
    	ecall             			# Закрытие файла
.end_macro

.macro write_ending_zero(%text_buffer, %size)
    	# Установка нуля в конце прочитанной строки
    	mv	t0, %text_buffer	 	# Адрес начала буфера
    	add 	t0, t0, %size			# Адрес последнего прочитанного символа
    	addi 	t0, t0, 1			# Место для нуля
    	sb	zero, (t0)			# Запись нуля в конец текста
.end_macro


.macro algorithm_wrapper(%strbuf)
	mv a0, %strbuf
	jal algorithm
.end_macro


.macro read_filename(%file_name_buffer, %message, %default)
.data
	default_name: .asciz %default     		# Имя файла по умолчанию
.text
	print_str(%message)
	la	a0, %file_name_buffer
	li      a1, NAME_SIZE
	li      a7, 8
	ecall
	
    	li	t4, '\n'
    	la	t5, %file_name_buffer
    	mv  	t3, t5		# Сохранение начала буфера для проверки на пустую строку
read_filename_loop:
    	lb	t6, (t5)
    	beq 	t4, t6, read_filename_replace
    	addi 	t5, t5, 1
    	b	read_filename_loop
read_filename_replace:
	beq 	t3, t5, default_value	# Установка имени введенного файла
    	sb	zero, (t5)
    	j	final_read_filename
default_value:
	strcpy(%file_name_buffer, default_name)
final_read_filename:
	
.end_macro

.macro strcpy(%dest, %src)
.text
	la t0, %dest
	la t1, %src
	
loop_strcpy:
	
	lb	t2, (t1)
	sb	t2, (t0)
	
	beqz	t2, end_strcpy
	
	addi	t0, t0, 1
	addi	t1, t1, 1
	
	j	loop_strcpy
	
end_strcpy:
.end_macro

.macro read_file_wrapper(%file_name, %strbuf, %TEXT_SIZE)
	la a0, %file_name
	la a1, %strbuf
	li a2, %TEXT_SIZE
	jal read_file
.end_macro

.macro write_file_wrapper(%file_name, %answer, %size)
	la a0, %file_name
	la a1, %answer
	mv a2, %size
	jal write_file
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
