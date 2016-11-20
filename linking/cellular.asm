pm_entry:
	mov  eax, sel_video	      ;начало видеопамяти в видеорежиме 0x3
	mov  es, ax
	mov  esi, msg
	mov  ah, 7
	xor  edi, edi
	.loop:			     ;цикл вывода сообщения
	lodsb			    ;считываем очередной символ строки
	test al, al		    ;если встретили 0
	jz   .exit		    ;прекращаем вывод
	stosw
	jmp  .loop
	.exit:
	jmp  $			    ;зависаем

msg:
db  'A quick brown fox jumps over the lazy dog 1234567890!@#$%^&*()_+-=', 0