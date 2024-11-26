.macro manual()
	print_str("Input src string: ")
	read_string(src, SIZE)
	strcpy_wrapper(dest, src)
	print_str("Result: ")
	print_result(dest)
.end_macro

.macro run_test(%test_src)
.data
	str_src: .asciz %test_src
.text
	print_newline()
	print_str("Input src string: ")
	li a7, 4
	la a0, str_src
	ecall
	strcpy_wrapper(dest, str_src)
	print_newline()
	print_str("Result: ")
	print_result(dest)
	print_newline()
.end_macro


.macro strcpy_wrapper(%dest, %src)
	la	a0, %dest
	la	a1, %src
	jal strcpy
.end_macro

.macro print_str (%x)
.data
	str: .asciz %x
.text
	li a7, 4
	la a0, str
	ecall
.end_macro

.macro read_string(%src, %SIZE)
	la	a0, src
	li	a1, SIZE
	li	a7, 8
	ecall
.end_macro

.macro print_result(%dst)
	la	a0, %dst
	li	a7, 4
	ecall
.end_macro

.macro print_char(%x)
	li a7, 11
	li a0, %x
	ecall
.end_macro

.macro print_newline()
	print_char('\n')
.end_macro

.macro exit()
    	li a7, 10
    	ecall
.end_macro
