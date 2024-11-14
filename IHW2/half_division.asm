.include "macrolib.asm"
.global half_division
.text
half_division:
# В подпрограмму в fa0 передается значение точности e.
	push(ra)			# Сохраняем адрес возврата на стек
	li t0, 0
	li t1, 1
	fmv.d ft6, fa0			# e
	fcvt.d.w ft0, t0 		# l = 0.0
	fcvt.d.w ft1, t1		# r = 1.0
	
while_division:
	fsub.d ft2, ft1, ft0		# r - l
	fgt.d t3, ft2, ft6		# r - l > e ?
	beqz t3, end_while_division
	fadd.d ft2, ft1, ft0		# r + l
	li t4, 2
	fcvt.d.w ft4, t4
	fdiv.d ft4, ft2, ft4		# c = (r + l) / 2
	compute_func_value_wrapper(ft4) # f(c)
	fmv.d ft3, fa0
	compute_func_value_wrapper(ft0) # f(l)
	fmv.d ft2, fa0
	fmul.d ft3, ft2, ft3		# f(l) * f(c)
	li t2, 0
	fcvt.d.w ft2, t2
	fgt.d t3, ft2, ft3		# f(l) * f(c) < 0
	beqz t3, false_comparsion
	fmv.d ft1, ft4			# r = c
	j end_comparsion
false_comparsion:
	fmv.d ft0, ft4			# l = c
end_comparsion:
	j while_division
end_while_division:
	fadd.d ft2, ft1, ft0		# r + l
	li t4, 2
	fcvt.d.w ft4, t4
	fdiv.d ft3, ft2, ft4		# c = (r + l) / 2
	fmv.d fa0, ft3			# возвращаем c
	pop(ra)				# Восстанавливаем адрес возврата со стека
	ret
