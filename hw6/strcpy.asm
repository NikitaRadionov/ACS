.include "macrolib.asm"
.global strcpy
.text
# char * strcpy( char * destptr, const char * srcptr );
strcpy:
# В a0 передается destptr
# В a1 передается srcptr

	add t0, a0, zero
	add t1, a1, zero
	
loop_strcpy:
	
	lb	t2, (t1)
	sb	t2, (t0)
	
	beqz	t2, end_strcpy
	
	addi	t0, t0, 1
	addi	t1, t1, 1
	
	j	loop_strcpy
	
end_strcpy:
	ret
