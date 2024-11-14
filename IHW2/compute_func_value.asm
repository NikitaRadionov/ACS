.include "macrolib.asm"
.global compute_func_value
.text
compute_func_value:
# В подпрограмму в fa0 передается точка x, в которой будет вычисленно значение функции 
# f(x) = 2x^4 - 6x^3 + 3x^2 - 2x + 1 = (((2x - 6)x + 3)x - 2)x + 1

	push(ra)			# Сохраняем адрес возврата на стек
	push_double(fs1)
	push_double(fs2)
	push_double(fs3)
	push_double(fs4)
	
	li s1, 1
	li s2, 2
	li s3, 3
	li s4, 6
	fcvt.d.w fs1, s1
	fcvt.d.w fs2, s2
	fcvt.d.w fs3, s3
	fcvt.d.w fs4, s4
	
	fmsub.d fs4, fs2, fa0, fs4 	# 2x - 6
	fmadd.d fs4, fs4, fa0, fs3	# (2x - 6)x + 3
	fmsub.d fs4, fs4, fa0, fs2	# ((2x - 6)x + 3)x - 2
	fmadd.d fs4, fs4, fa0, fs1	# (((2x - 6)x + 3)x - 2)x + 1
	fmv.d fa0, fs4			# Возвращаем вычисленное значение из подпрограммы
	
	pop_double(fs4)
	pop_double(fs3)
	pop_double(fs2)
	pop_double(fs1)
	pop(ra)				# Восстанавливаем адрес возврата со стека
	ret
