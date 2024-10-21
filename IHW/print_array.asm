.include "macrolib.asm"
.global print_array
.text
print_array:
	push(ra) 				# ��������� ����� �������� �� ����
	mv t0, a0 				# ������
	mv t1, a1 				# �������, ����� ���� ���������� n ���
print_array_loop:
	beqz t1, print_array_loop_end 		# ���������� � 0, ����� ������� ����� �� �����
	lw t2, (t0) 				# �������� a[i]
	print_int_space(t2)			# ������� a[i] �� �����
	addi t1, t1, -1				# ��������� �������� ��������
	addi t0, t0, 4				# �������� ����� �� ��������� ������ �������
	j print_array_loop
print_array_loop_end:
	pop(ra) 				# ���������� ����� �������� �� �����
	ret
