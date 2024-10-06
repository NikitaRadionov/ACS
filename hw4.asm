.data
	input_size: .asciz "������� ������ ������� (�� 1 �� 10): "
	wrong_size: .asciz "������ ������������ ������ �������. ������ ������ ���� �� 1 �� 10"
	items_count: .asciz "�������������� ���������: "
	summa: .asciz "�����: "
	even_count: .asciz "���������� ������ ��������� � �������: "
	odd_count: .asciz "���������� �������� ��������� � �������: "
	sep: .asciz "--------------------\n"
.align 2
	array: .space 40
	arrend: 
.text
	# ���� ������� �������
	li a7, 4
	la a0, input_size
	ecall
	
	li a7, 5
	ecall
	mv t1, a0

	li t3, 1
	li t4, 10
	
	blt t1, t3, size_error
	bgt t1, t4, size_error
		
	la t0, array
	mv t2, t1
	li s3, 0
	li s4, 0
while_1:
	beqz t2, end_while_1
	addi t2, t2, -1
	li a7, 5
	ecall
	
	li s1, 2
	div s2, a0, s1
	mul s2, s2, s1
	beq s2, a0, even_element
	j odd_element
even_element:
	addi s3, s3, 1
	j countinue_while_1
odd_element:
	addi s4, s4, 1
	
countinue_while_1:
	sw a0, (t0)
	addi t0, t0, 4
	j while_1
end_while_1:
	mv t2, t1
	li a7, 4
	la a0, sep
	ecall
	la t0, array
	li t3, 0
while_2:
	beqz t2, output
	
	lw t4, (t0)
	mv t5, t3
	add t3, t3, t4
	
	# ���� ����� t4 � t5 ����������, �� t6 > 0
	xor t6, t4, t5
	
	# ���� t5 � t4 �������������, � t3 �������������, �� ������������
	# ���� t5 � t4 �������������, � t3 �������������, �� ������������
	bltz t3, t3_less_zero
	bgtz t3, t3_greate_zero
	j countinue_while_2
t3_less_zero:
	bgtz t6, check_t5_t4_1
	j countinue_while_2
	
t3_greate_zero:
	bgtz t6, check_t5_t4_2
	j countinue_while_2

check_t5_t4_1:
	bgtz t5, overflow
	j countinue_while_2

check_t5_t4_2:
	bltz t5, overflow
	j countinue_while_2

countinue_while_2:
	addi t2, t2, -1
	addi t0, t0, 4
	
	j while_2

overflow:
	# ���������� ��������� t1 - t2
	# ������ ����� t5
	neg t2, t2
	add t1, t1, t2
	mv t3, t5

output:
	li a7, 4
	la a0, items_count
	ecall
	
	li a7, 1
	mv a0, t1
	ecall
	
	li a7, 11
	li a0, 10
	ecall
	
	li a7, 4
	la a0, summa
	ecall
	
	li a7, 1
	mv a0, t3
	ecall
	
	# ������� �� ����� ������
	li a7, 11
	li a0, 10
	ecall
	
	# ����� ���������� ������
	li a7, 4
	la a0, even_count
	ecall
	
	li a7, 1
	mv a0, s3
	ecall
	
	# ������� �� ����� ������
	li a7, 11
	li a0, 10
	ecall
	
	# ����� ���������� ��������
	li a7, 4
	la a0, odd_count
	ecall
	
	li a7, 1
	mv a0, s4
	ecall
	j exit

size_error:
	li a7, 4
	la a0, wrong_size
	ecall
	j exit
exit:
	li a7, 10
	ecall