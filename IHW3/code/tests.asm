.include "macrolib.asm"
.eqv    TEXT_SIZE 512								# Размер буфера для текста
.data
	input_file_name1:		.asciz "tests/in/test1.txt"		 # Обычный тест 
	input_file_name2:		.asciz "tests/in/test2.txt"		 # тест на считывание до 10 КБ
	input_file_name3:		.asciz "tests/in/test3doesnotexist.txt"  # Файл с невалидным именем
	input_file_name4:		.asciz "tests/in/test4.txt"		 # пустой файл
	input_file_name5:		.asciz "tests/in/test5.txt"		 # файл больше 10КБ
	
	output_file_name1:		.asciz "tests/out/output1.txt"
	output_file_name2:		.asciz "tests/out/output2.txt"
	output_file_name3:		.asciz "tests/out/output3.txt"
	output_file_name4:		.asciz "tests/out/output4.txt"
	output_file_name5:		.asciz "tests/out/output5.txt"
	
	answer1:	.asciz "Correct bracket sequence\n"
	answer2:	.asciz "Incorrect bracket sequence\n"
	answer3:	.asciz "Incorrect file name"
	answer4:	.asciz "Correct bracket sequence\n"
	answer5:	.asciz "Incorrect bracket sequence\n"
.text
	run_test_case(input_file_name1, output_file_name1, answer1)
	run_test_case(input_file_name2, output_file_name2, answer2)
	run_test_case(input_file_name3, output_file_name3, answer3)
	run_test_case(input_file_name4, output_file_name4, answer4)
	run_test_case(input_file_name5, output_file_name5, answer5)
	exit()
