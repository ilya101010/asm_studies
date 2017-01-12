; basic procedures for IO and other life stuff

format ELF

include 'macro.inc'

section '.text' executable
Use32


demo_cdecl: 
	push ebp
	mov ebp, esp
	; [ebp+8] - first arg
	; [ebp+12] - second arg
	; ...
	; [ebp+4*(i+1)] - i-th arg
	pop ebp
	ret

; # output
public write
; write(src, x, y, color) // null-terminated string
write:
	push ebp
	mov ebp, esp
	push esi, edi, eax
	mov esi, [ebp+8]
	mov ah, [ebp+20]
	mov edi, [ebp+16]
	imul edi, 160
	add edi, 0xB8000
	add edi, [ebp+12]
	add edi, [ebp+12]
	.loop:		     ;цикл вывода сообщения
	lodsb			    ;считываем очередной символ строки
	test al, al		    ;если встретили 0
	jz   .exit		    ;прекращаем вывод
	stosw
	jmp  .loop
	.exit:
	pop eax, edi, esi
	pop ebp
	ret

public print
; print(src,y,color) // null-terminated string
print:
	push ebp
	mov ebp, esp
	pusha
	mov esi, [ebp+8]
	mov edi, [ebp+12]
	mov eax, [ebp+16]
	ccall write, esi, 0, edi, eax
	popa
	pop ebp
	ret

public itoa
; itoa(int n, char* s) // dec
itoa:
	push ebp
	mov ebp, esp
	mov eax, [ebp+8]
	mov edi, [ebp+12]
	;pushad
	;	ccall fill_zeros, edi, 20
	;popad
	mov ecx, 0
	test eax, eax
	jns .pos
	neg eax
	push 0
	jmp .loop
	.pos:
	push 1
	.loop:
		mov ebx, 10
		idiv ebx
		push eax
			xor eax, eax
			mov al, '0'
			add eax, edx
			stosb
			inc ecx
		pop eax
		xor eax, 0
	jnz .loop
	pop ebx
	xor ebx, 0
	jnz .reversing
	mov al, '-'
	stosb
	inc ecx
	.reversing: ; cx contains number of symbs
	mbp
	shr cx, 1
	test cx, cx
	jz .end
	dec edi
	mov esi, [ebp+12] ; left end of str
	; edi contains right end of str
	xor eax, eax
	xor ebx, ebx
	.loop1:
		mov al, [esi]
		mov bl, [edi]
		xchg al, bl
		mov [esi], al
		mov [edi], bl
		inc esi
		dec edi
	loop .loop1
	.end:
	pop ebp
	ret

public itoah
; itoah(int n, char* s) // hex
itoah:
	push ebp
	mov ebp, esp
	mov eax, [ebp+8]
	mov edi, [ebp+12]
	mov ecx, 0
	;pushad
	;	ccall fill_zeros, edi, 20
	;popad
	test eax, eax
	jns .pos
	neg eax
	push 0
	jmp .loop
	.pos:
	push 1
	.loop:
		mov edx, eax
		and edx, 0xF
		shr eax, 4
		push eax
			xor eax, eax
			mov al, [.symb+0x7c00+edx]
			stosb
			inc ecx
		pop eax
		xor eax, 0
	jnz .loop
	pop ebx
	xor ebx, 0
	mov ax, 'x0'
	stosw
	add ecx, 2
	jnz .reversing
	mov al, '-'
	stosb
	inc ecx
	.reversing: ; cx contains number of symbs
	mbp
	shr cx, 1
	dec edi
	mov esi, [ebp+12] ; left end of str
	; edi contains right end of str
	xor eax, eax
	xor ebx, ebx
	.loop1:
		mov al, [esi]
		mov bl, [edi]
		xchg al, bl
		mov [esi], al
		mov [edi], bl
		inc esi
		dec edi
	loop .loop1
	pop ebp
	ret
	.symb: db '0123456789ABCDEF'

public fill_zeros
; fill_zeros(char*s, int n)
fill_zeros:
	push ebp
	mov ebp, esp
	mov edi, [ebp+8]
	mov al, 0
	xor ecx, ecx
	mov cx, [ebp+12]
	rep stosb
	pop ebp
	ret