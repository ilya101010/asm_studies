format ELF

public shift

macro push [arg] { push arg }
macro pop [arg] { pop arg }

strcpy: ; just for 80 bits
	push ax
	push cx
	mov cx, 5
	rep movsw
	pop cx
	pop ax
	ret

shift: ; (char* state)
	push ebp
	mov ebp, esp
	mov esi, [ebp+8]
	push esi, edi, ax, bx, dx
	xor ax, ax
	xor bx, bx
	xor dx, dx
	mov edi, tmp
	pushad
		mov cx, 10
		mov dx, 0
		add esi, 9
		add edi, 9
		; dx - previous CF
		xor dx, dx
		std
		in4:
			lodsb
			
			mov bx, ax

			shr ax, 1

			; bx <- first bit of ax
			and bx, 1

			shl dx, 7 ; carry flag from %111 stays in stack
			or ax, dx
			
			mov dx, bx
			
			stosb
		loop in4
		cld

		mov esi, tmp
		mov edi, tmp
		add esi, 9
		add edi, 9
		lodsb
			shl dx, 7 ; carry flag from %111 stays in stack
			or ax, dx
		stosb
	popad
	xchg esi, edi
	call strcpy
	pop dx, bx, ax, edi, esi, ebp
	ret

tmp db 128 dup(0)