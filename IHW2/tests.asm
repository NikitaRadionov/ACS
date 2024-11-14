.include "macrolib.asm"
.data
	e1: .double 0.00000001
	e2: .double 0.0001
	e3: .double 0.001
	e4: .double 0.01
	e5: .double 0.000000001
	
	answer1: .double 0.5472415275871754
	answer2: .double 0.547271728515625
	answer3: .double 0.54736328125
	answer4: .double -1.0 		# любое double отрицательное число означает что ожидается ошибка
	answer5: .double -1.0		# любое double отрицательное число означает что ожидается ошибка

.text
	run_test_case(e1, answer1)
	run_test_case(e2, answer2)
	run_test_case(e3, answer3)
	run_test_case(e4, answer4)
	run_test_case(e5, answer5)
	exit()
