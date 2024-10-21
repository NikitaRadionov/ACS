
# ������ �����

.macro run_test_case(%n, %input_array, %output_array, %expected_array)
	push(s1)
	lw s1, %n
	print_str("Input   : ")
	print_array_wrapper(s1, %input_array)
	print_newline()
	init_array_by_indices(s1, %output_array)
	sort_result_array_wrapper(s1, %input_array, %output_array)
	print_str("Output  : ")
	print_array_wrapper(s1, %output_array)
	print_newline()
	print_str("Expected: ")
	print_array_wrapper(s1, %expected_array)
	print_newline()
	print_newline()
	pop(s1)
.end_macro


# ������� ����������� �����-������ � ��������� ���������:

.macro read_array_wrapper(%array)
	la a0, %array 		# �������� ������ ������������ ����� � �������� a0
	jal read_array		# �������� ������������ �����
.end_macro

.macro sort_result_array_wrapper(%n, %input_array, %result_array)
	mv a0, %n 		# �������� ������������ ���������� ���������� ��������� ������� � �������� a0
	la a1, %input_array 	# �������� ������������ ���������� �������� ������ � �������� a1
	la a2, %result_array 	# �������� ������������ ���������� ������, � ������� ����� ���������, � �������� a2
	jal sort_result_array 	# �������� ������������ ����������
.end_macro

.macro print_array_wrapper(%n, %array)
	la a0, %array		# �������� ������������ ������ ������ � �������� a0
	mv a1, %n		# �������� ������������ ������ ���������� ��������� ������� � �������� a1
	jal print_array		# �������� ������������ ������
.end_macro


# ����� ��� ������������ ����������:

# ����������� ��������� ������� �� ��� i-�� �������
.macro move_to_i_index(%i, %array)
	mv t0, %array
	mv t1, %i
	li t2, 4
	mul t1, t1, t2
	add t0, t0, t1
	mv a0, t0
.end_macro

# ��������� i-�� �������� �������� �������
.macro get_el_by_index(%i, %array)
	move_to_i_index(%i, %array)
	mv t0, a0
	lw a0, (t0)	
.end_macro

# ��������� i-�� � j-�� ��������� �������. �������� a[b[i]] > a[b[j]]
.macro compare_i_and_j(%i, %j)
	lw t5, 4(sp) # a
	lw t6, (sp) # b
	get_el_by_index(%i, t6)
	get_el_by_index(a0, t5)
	mv t3, a0 # a[b[i]]
	get_el_by_index(%j, t6)
	get_el_by_index(a0, t5)
	mv t4, a0 # a[b[j]]
	slt a0, t4, t3 # ���������� 1 ���� a[b[i]] > a[b[j]]
.end_macro

# �������� ������� i-�� � j-�� �������� �������.
.macro swap_i_and_j(%i, %j)
	lw t6, (sp)
	get_el_by_index(%i, t6)
	mv t4, a0 # b[i]
	get_el_by_index(%j, t6)
	mv t5, a0 # b[j]
	
	move_to_i_index(%i, t6)
	
	sw t5, (a0) # b[i] = b[j]
	
	move_to_i_index(%j, t6)
	
	sw t4, (a0) # b[j] = b[i]
.end_macro


.macro init_array_by_indices(%n, %array)
	push(t0)
	push(t1)
	la t0, %array
	li t1, 0
init_array_while:
	beq t1, %n, end_init_array_while
	sw t1, (t0)
	addi t1, t1, 1
	addi t0, t0, 4
	j init_array_while
end_init_array_while:
	pop(t1)
	pop(t0)
.end_macro

# �������� ������� �������

.macro check_n_value(%n)
	mv t1, %n
	li t3, 1
	li t4, 10
	
	blt t1, t3, size_error 		# ���� n < 1, �� ������
	bgt t1, t4, size_error 		# ���� n > 10, �� ������
	j continue
size_error:
	print_str("Invalid array size. Size must be between 1 and 10\n")
	exit()
continue:
.end_macro

.macro print_int(%x)
	push(a0)
	li a7, 1
	mv a0, %x
	ecall
	pop(a0)
.end_macro

.macro print_int_newline(%x)
	print_int(%x)
	print_newline()
.end_macro

.macro print_int_space(%x)
	print_int(%x)
	print_space()
.end_macro

.macro read_int(%x)
	push(a0)
	li a7, 5
	ecall
	mv %x, a0
	pop(a0)
.end_macro

.macro read_int_a0
	li a7, 5
	ecall
.end_macro

.macro print_str (%x)
.data
	str: .asciz %x
.text
	push(a0)
	li a7, 4
	la a0, str
	ecall
	pop(a0)
.end_macro

.macro print_char(%x)
	push(a0)
	li a7, 11
	li a0, %x
	ecall
	pop(a0)
.end_macro

.macro print_space()
	print_char(' ')
.end_macro

.macro print_newline()
	print_char('\n')
.end_macro

.macro exit()
    li a7, 10
    ecall
.end_macro

# ���������� ��������� �������� �� �����
.macro push(%x)
	addi	sp, sp, -4
	sw	%x, (sp)
.end_macro

# ������������ �������� � ������� ����� � �������
.macro pop(%x)
	lw	%x, (sp)
	addi	sp, sp, 4
.end_macro
