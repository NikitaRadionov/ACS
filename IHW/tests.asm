.include "macrolib.asm"
.data
	n1: .word 1
	n2: .word 10
	n3: .word 5
	n4: .word 6
	n5: .word 5
	n6: .word 4
	n7: .word 8
	n8: .word 5
	n9: .word 6
	n10: .word 6
	n11: .word -1
	n12: .word 11
.align 2
	A_array: .word 2
	A_arrend:
.align 2
	B_array: .word 1,2,3,4,5,6,7,8,9,10
	B_arrend:
.align 2
	C_array: .word 5,4,3,2,1
	C_arrend:
.align 2
	D_array: .word 4,2,3,7,1,5
	D_arrend:
.align 2
	E_array: .word 3,3,3,3,3
	E_arrend:
.align 2
	F_array: .word -1,-3,-2,0
	F_arrend:
 .align 2
	G_array: .word 22,-10,5,30,14,-2,9,18
	G_arrend:
 .align 2
	H_array: .word -5,12,0,7,-3
	H_arrend:
 .align 2
	K_array: .word 3,7,1,5,9,2
	K_arrend:
 .align 2
	L_array: .word 4,-2,8,6,11,0
	L_arrend:
.align 2
	A_array_answer: .word 0
	A_answer_arrend:
.align 2
	B_array_answer: .word 0,1,2,3,4,5,6,7,8,9
	B_answer_arrend:
.align 2
	C_array_answer: .word 4,3,2,1,0
	C_answer_arrend:
.align 2
	D_array_answer: .word 4,1,2,0,5,3
	D_answer_arrend:
.align 2
	E_array_answer: .word 0,1,2,3,4
	E_answer_arrend:
.align 2
	F_array_answer: .word 1,2,0,3
	F_answer_arrend:
 .align 2
	G_array_answer: .word 1,5,2,6,4,7,0,3
	G_answer_arrend:
 .align 2
	H_array_answer: .word 0,4,2,3,1
	H_answer_arrend:
 .align 2
	K_array_answer: .word 2,5,0,3,1,4
	K_answer_arrend:
 .align 2
	L_array_answer: .word 1,5,0,3,2,4
	L_answer_arrend:
.align 2
	R_array: .space 40
	R_arrend:
.align 2
	Errror: .space 40
	Errror_arrend:
.text
	run_test_case(n1, A_array, R_array, A_array_answer)
	run_test_case(n2, B_array, R_array, B_array_answer)
	run_test_case(n3, C_array, R_array, C_array_answer)
	run_test_case(n4, D_array, R_array, D_array_answer)
	run_test_case(n5, E_array, R_array, E_array_answer)
	run_test_case(n6, F_array, R_array, F_array_answer)
	run_test_case(n7, G_array, R_array, G_array_answer)
	run_test_case(n8, H_array, R_array, H_array_answer)
	run_test_case(n9, K_array, R_array, K_array_answer)
	run_test_case(n10, L_array, R_array, L_array_answer)
	run_test_case(n11, L_array, R_array, Errror)
	run_test_case(n12, L_array, R_array, Errror)
	exit()
