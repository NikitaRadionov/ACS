.include "macrolib.asm"
.global read_array
.text
# ������ ������� � ����������
read_array:
	push(ra)	 		# ��������� ����� �������� �� ����
	push(a0)	 		# ��������� ����������. ������
	
	print_str("Enter the array size (from 1 to 10): ")
	
	read_int(t1) 			# ��������� ������ ������� n

	check_n_value(t1)		# ��������� ��� ������ ������� ��������� � ��������� �� 1 �� 10
		
	lw t0, (sp)
	
	mv t2, t1			# ������������� ��������� �������� �������� t = n

input_while: # while t > 0: ������� ����� � ����������
	beqz t2, end_input_while
	addi t2, t2, -1			# t -= 1
	
	read_int_a0			# ������ ����� � ���������� � ������� a0
	
	sw a0, (t0)			# ������ ��������� �������� � ������
	addi t0, t0, 4			# ���������� �� ���� ������ �������
	j input_while

end_input_while:
	print_str("--------------------\n")
	addi sp, sp, 4 			# �������� ��������� ����������
	mv a0, t1 			# ���������� ������ ������� �� ������������
	pop(ra)				# ���������� ����� �������� �� �����
	ret