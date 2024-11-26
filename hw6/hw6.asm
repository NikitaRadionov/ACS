.include "macrolib.asm"
.global main
.eqv	SIZE 1026
.data
	src:	.space SIZE
	dest:	.space SIZE
.text
main:
	manual()
	
#	TESTS:
test1:
	print_newline()
	print_str("TEST 1")
	run_test("Hello World")
test2:
	print_newline()
	print_str("TEST 2")
	run_test("Lorem ipsum dolor sit amet, consectetuer adipiscing elit")
test3:
	print_newline()
	print_str("TEST 3")
	run_test("Aenean commodo ligula eget dolor")
	exit()
