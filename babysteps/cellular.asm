Use16
org     0x7C00

rule = 101

start:
	cli		     ; disabling interrupts
	mov     ax, cs	  ; segment registers' init
	mov     ds, ax
	mov     es, ax
	mov     ss, ax
	mov     sp, 0x7C00      ; stack backwards => ok
       
	mov     ax, 0xB800
	mov     gs, ax	  ; Использовал для вывода текста прямой доступ к видеопамяти
	mov cx, 24
	call    clrscr
	lp0:
		mov si, state
		call k_puts
		call eval
	loop lp0
	jmp     $	       ; infinite loop

eval:
	mov si, newstate
	call clr_str
	mov si, tmp
	call clr_str
	pusha
		mov cx, 80
		tl:
			; first - getting the newstate of a BIT in state
			mov si, state
			lodsb
			and al, 7
			push cx
			mov cl, al
			mov dl, rule ; rule
			shr dl, cl
			pop cx
			and dl, 1
			; second - managing change in newstate
			mov si, newstate
			mov di, newstate
			lodsb
				test dl, dl
				jz pal0
				jnz pal1
				bk1:
			stosb
			; third - iteration management
			mov si, state
			call shift_string
			mov si, newstate
			call shift_string

		loop tl
	popa
	mov si, newstate
	mov di, state
	call strcpy

	ret

shift_string: ; works! RIGHT direction! include si
	pusha
	mov di, tmp
	pushad
		mov cx, 5
		mov dx, 0
		add si, 8
		add di, 8
		push 0
		in4:
			lodsw
			sub si, 4
			
			shr ax, 1

			pop dx
			pushf
				shl dx, 15 ; carry flag from %111 stays in stack
				or ax, dx
			popf
			
			jc push1
			jnc push0
			back1:
			
			stosw
			sub di, 4
		loop in4
		
		add si, 2
		add di, 2

		mov si, tmp
		mov di, tmp
		add si, 8
		add di, 8
		pop dx
		lodsw
		pushf
			shl dx, 15 ; carry flag from %111 stays in stack
			or ax, dx
		popf
		stosw
	popad
	xchg si, di
	call strcpy
	popa
	ret

; >>>>>>>>>> Util

put_hash:
	push ax
	mov al, 0x23
	mov ah, 0x0E
	int 0x10
	pop ax
	ret

put_space:
	push ax
	mov al, 0x20
	mov ah, 0x0E
	int 0x10
	pop ax
	ret

ps:
	call put_space
	jmp back0

ph:
	call put_hash
	jmp back0

strcpy: ; just for 80 bits
	push ax
	push cx
	mov cx, 5
	rep movsw
	pop cx
	pop ax
	ret

push1:
	push 1
	jmp back1

push0:
	push 0
	jmp back1

clr_str:
	pusha
		mov cx, 5
		mov di, si
		clrl:
		lodsw
			mov ax, 0
		stosw
		loop clrl
	popa
	ret

pal0:
	pushf
		and al, 253
	popf
	jmp bk1

pal1:
	pushf
		or al, 2
	popf
	jmp bk1

clrscr:
	pusha
	mov dx, 0 ; set cursor to top left-most corner of screen
	mov bh, 0 ; page
	mov ah, 0x2 ; ah = 2 => set cursor
	int 0x10 ; moving cursor
	mov cx, 2000 ; print 2000 = 80*45 chars
	mov bh, 0
	mov bl, 0xF0 ; gray bg/white fg
	mov al, 0x20 ; blank char
	mov ah, 0x9
	int 0x10
	popa
	ret

k_puts: ; important: we _are_ outputing bits from the smallest => biggest
	pusha
	mov cx, 10
	in1: ; 10 bytes
		mov dl, 1; mask
		lodsb ; 8 bits => AL
		in2: ; passing through bits
			test al, dl
			jz ps
			jnz ph
			back0:
			shl dl, 1
		jnc in2 ; carry != 1 => NOT overflow in dl => NOT finish (8 bits in dl)
	loop in1
	popa
	ret


; >>>>>>>>>> vars in memory
state   dw 0, 0x0,0x1,0,0x0000 ; 2 hex symbols => 8 binary states
newstate dw 5 dup(0)
tmp dw 5 dup(0)

; >>>>>>>>>> boot sector stuff
times 510-($-$$) db 0
	db 0x55, 0xaa