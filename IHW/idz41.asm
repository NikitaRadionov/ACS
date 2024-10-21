.include "macrolib.asm"
.global main
.data
.align 2
	A_array: .space 40
	A_arrend:
.align 2
	B_array: .space 40
	B_arrend:
.text
main:
	read_array_wrapper(A_array) # читаем исходный массив с клавиатуры
	mv s1, a0
	init_array_by_indices(s1, B_array) # инициализируем массив B индексами
	sort_result_array_wrapper(s1, A_array, B_array) #  Сортируем массив B 
	print_array_wrapper(s1, B_array) # печатаем результат на экран
	exit()
