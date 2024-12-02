.include "macrolib.asm"
.global algorithm

.text
algorithm:
# В a0 передается адрес буфера strbuf с текстом
	push(ra)
	li 	t0, 0
	mv 	t1, a0
	li	t2, '('
	li	t3, ')'
algorithm_loop:
    	lb	t4, (t1)
    	beqz 	t4, end_algorithm_loop
    	beq	t4, t2, open_bracket
    	j	elif
open_bracket:
	addi	t0, t0, 1
	j 	endif
elif:
	beq	t4, t3, close_bracket
	j	endif
close_bracket:
	addi	t0, t0, -1
endif:
	bltz	t0, negative_answer
    	addi 	t1, t1, 1
    	j	algorithm_loop
    
end_algorithm_loop:    	
    	beqz	t0, positive_answer
    	j	negative_answer
positive_answer:
	li	a0, 1
	j end_algorithm
negative_answer:
	li	a0, 0
end_algorithm:
	pop(ra)
	ret
