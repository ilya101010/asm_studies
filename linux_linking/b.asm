strcpy: ; (char* src, char* dest, int count)
	push ebp
	mov ebp, esp
	push ax, cx
	mov cx, [ebp+8]
	rep movsb
	pop cx, ax, ebp
	ret

shift: ; (char* state, int count)
	push ebp
	mov ebp, esp
	mov esi, [ebp+8]
	push esi, edi, ax, bx, dx
	xor ax, ax
	xor bx, bx
	xor dx, dx
	mov edi, tmp
	pushad
		mov cx, [ebp+12]
		mov dx, 0
		add esi, [ebp+12]
		dec esi
		add edi, [ebp+12]
		dec edi
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
		add esi, [ebp+12]
		dec esi
		add edi, [ebp+12]
		dec edi
		lodsb
			shl dx, 7 ; carry flag from %111 stays in stack
			or ax, dx
		stosb
	popad
	xchg esi, edi
	mov edx, [ebp+12]
	push edx
	call strcpy
	pop edx
	pop dx, bx, ax, edi, esi, ebp
	ret

tmp db 128 dup(0)