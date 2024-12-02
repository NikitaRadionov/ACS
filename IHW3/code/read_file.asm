.include "macrolib.asm"
.global read_file
.text
read_file:
# В a0 лежит имя открываемого файла
# В a1 лежит адрес буфера для читаемого текста
# В a2 лежит максимальный размер текста файла
	push(ra)
	push(s1)
	push(s2)
	push(s3)
	push(s4)
	push(s5)
	push(s10)
	mv	s3, a0
	mv	s4, a1
	mv 	s5, a2

	open(s3, READ_ONLY)
    	mv   	s10, a0       	# Сохранение дескриптора файла
    	read_addr_reg(s10, s4, s5)
    	mv   	s2, a0       	# Сохранение длины текста
	close(s10)
	write_ending_zero(s4, s2)
	pop(s10)
    	pop(s5)
    	pop(s4)
    	pop(s3)
	pop(s2)
	pop(s1)
	pop(ra)
	ret
