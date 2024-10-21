.include "macrolib.asm"
.global print_array
.text
print_array:
	push(ra) 				# сохраняем адрес возврата на стек
	mv t0, a0 				# массив
	mv t1, a1 				# счетчик, чтобы цикл выполнился n раз
print_array_loop:
	beqz t1, print_array_loop_end 		# сравниваем с 0, чтобы вовремя выйти из цикла
	lw t2, (t0) 				# Получаем a[i]
	print_int_space(t2)			# Выводим a[i] на экран
	addi t1, t1, -1				# Уменьшаем значение счетчика
	addi t0, t0, 4				# Сдвигаем адрес на следующую ячейку массива
	j print_array_loop
print_array_loop_end:
	pop(ra) 				# возвращаем адрес возврата со стека
	ret
