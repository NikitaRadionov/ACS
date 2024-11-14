.include "macrolib.asm"
.global main

.text
main:
	read_double(fs1)		# читаем double с клавиатуры
	check_accuracy(fs1)		# проверяем корректность входных данных
	half_division_wrapper(fs1)	# исполняем основной алгоритм
	print_double(fa0)		# печатаем ответ
	exit()
