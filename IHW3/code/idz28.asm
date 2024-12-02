.include "macrolib.asm"

.global main
.eqv    TEXT_SIZE 512								# Размер буфера для текста
.eqv    NAME_SIZE 256								# Размер буфера для имени файла
.eqv	ANSWER_SIZE 40								# Размер буфера для ответа
.data
	input_file_name:      	.space	NAME_SIZE				# Имя читаемого файла
	output_file_name:	.space 	NAME_SIZE				# Имя выходного файла
	answer:			.space	ANSWER_SIZE
.text
main:
	read_filename_dialog("Input file path: ", input_file_name, NAME_SIZE, "Incorrect input. Please Try Again", "input.txt")
	read_file_heap_wrapper(input_file_name, TEXT_SIZE)					# чтение текста из файла в кучу
	algorithm_wrapper(a0)									# выполнение основного алгоритма
	prepear_answer(answer)
	mv	s11, a0
	read_filename_dialog("Output file path: ", output_file_name, NAME_SIZE, "Incorrect input. Please Try Again", "output.txt")
	write_file_wrapper(output_file_name, answer, s11)
	print_answer_console_dialog("Do you want to print result on console ? yes (Y) or no (N)", answer, "Incorrect input. Please Try Again")
    	exit()
