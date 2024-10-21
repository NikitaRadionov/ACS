.include "macrolib.asm"
.global sort_result_array
.text
sort_result_array:
	push(ra)	# ��������� ����� �������� �� ����
	push(s1)	# ��������� �������� �� s1 �� ����
	push(s2)	# ��������� �������� �� s2 �� ����
	push(a0) 	# ��������� ����������. � ��� ��������� ���������� ��������� � �������
	push(a1) 	# ��������� ����������. � ��� ��������� ������ A
	push(a2)	# ��������� ����������. � ��� ��������� ������ B

	li s1, 0 	# i
for_i_loop:
	lw t0, 8(sp)
	beq s1, t0, end_for_i_loop	# ���� i ������ n, �� ������� �� �������� �����
	addi s2, s1, 1 			# j = i + 1
for_j_loop:
	lw t0, 8(sp)
	beq s2, t0, end_for_j_loop	# ���� j ������ n, �� ������� �� ����������� �����
	compare_i_and_j(s1, s2) 	# ��������� i-�� � j-�� ��������� �������. � a0 ���������
	beqz a0, end_compare		
	swap_i_and_j(s1, s2) 		# ������ ������� i-�� � j-�� �������� �������
end_compare:
	addi s2, s2, 1 			# j += 1
	j for_j_loop
end_for_j_loop:
	addi s1, s1, 1 			# i += 1
	j for_i_loop
end_for_i_loop:
	addi sp, sp, 12 # �������� ��� ��������� ����������
	pop(s2) 	# ���������� �������� s2 �� ����� � s2
	pop(s1)		# ���������� �������� s1 �� ����� � s1
	pop(ra)		# ��������������� ����� �������� �� �����
	ret
