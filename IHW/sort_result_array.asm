.include "macrolib.asm"
.global sort_result_array
.text
sort_result_array:
	push(ra)	# Сохраняем адрес возврата на стек
	push(s1)	# Сохраняем значение из s1 на стек
	push(s2)	# Сохраняем значение из s2 на стек
	push(a0) 	# Локальная переменная. В ней находится количество элементов в массиве
	push(a1) 	# Локальная переменная. В ней находится массив A
	push(a2)	# Локальная переменная. В ней находится массив B

	li s1, 0 	# i
for_i_loop:
	lw t0, 8(sp)
	beq s1, t0, end_for_i_loop	# Если i достиг n, то выходим из внешнего цикла
	addi s2, s1, 1 			# j = i + 1
for_j_loop:
	lw t0, 8(sp)
	beq s2, t0, end_for_j_loop	# Если j достиг n, то выходим из внутреннего цикла
	compare_i_and_j(s1, s2) 	# Сравнение i-го и j-го элементов массива. В a0 заносится
	beqz a0, end_compare		
	swap_i_and_j(s1, s2) 		# Меняем местами i-ый и j-ый элементы массива
end_compare:
	addi s2, s2, 1 			# j += 1
	j for_j_loop
end_for_j_loop:
	addi s1, s1, 1 			# i += 1
	j for_i_loop
end_for_i_loop:
	addi sp, sp, 12 # забываем три локальных переменных
	pop(s2) 	# Возвращаем значение s2 со стека в s2
	pop(s1)		# Возвращаем значение s1 со стека в s1
	pop(ra)		# Восстанавливаем адрес возврата со стека
	ret
