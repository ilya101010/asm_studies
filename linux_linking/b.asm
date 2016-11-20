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
	mov edi, tmp
	pushad
		mov cx, 5
		mov dx, 0
		add esi, 8
		add edi, 8
		; dx - previous CF
		xor dx, dx
		std
		in4:
			lodsw
			
			mov bx, ax

			shr ax, 1

			; bx <- first bit of ax
			and bx, 1

			shl dx, 15 ; carry flag from %111 stays in stack
			or ax, dx
			
			mov dx, bx
			
			stosw
		loop in4
		cld

		mov esi, tmp
		mov edi, tmp
		add esi, 8
		add edi, 8
		lodsw
			shl dx, 15 ; carry flag from %111 stays in stack
			or ax, dx
		stosw
	popad
	xchg esi, edi
	call strcpy
	pop dx, bx, ax, edi, esi, ebp
	ret

tmp db 128 dup(0)