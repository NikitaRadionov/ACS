.include "macrolib.asm"
.global read_array
.text
# Чтение массива с клавиатуры
read_array:
	push(ra)	 		# Сохраняем адрес возврата на стек
	push(a0)	 		# Локальная переменная. Массив
	
	print_str("Enter the array size (from 1 to 10): ")
	
	read_int(t1) 			# считываем размер массива n

	check_n_value(t1)		# Проверяем что размер массива находится в диапазоне от 1 до 10
		
	lw t0, (sp)
	
	mv t2, t1			# Устанавливаем начальное значение счетчика t = n

input_while: # while t > 0: считать число с клавиатуры
	beqz t2, end_input_while
	addi t2, t2, -1			# t -= 1
	
	read_int_a0			# Читаем число с клавиатуры в регистр a0
	
	sw a0, (t0)			# Кладем считанное значение в массив
	addi t0, t0, 4			# Сдвигаемся на одну ячейку массива
	j input_while

end_input_while:
	print_str("--------------------\n")
	addi sp, sp, 4 			# забываем локальную переменную
	mv a0, t1 			# возвращаем размер массива из подпрограммы
	pop(ra)				# возвращаем адрес возврата со стека
	ret