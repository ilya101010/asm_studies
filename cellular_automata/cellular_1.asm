Use16
org     0x7C00

macro push [arg] { push arg }
macro pop [arg] { pop arg }

rule = 30

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

; --------------------------------------------------------------

eval:
	mov si, newstate
	call clr_str
	mov si, tmp
	call clr_str
	push cx, ax, dx
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
				jnz let
				and al, 253
				jmp bk1
				let:
				or al, 2
				bk1:
			stosb
			; third - iteration management
			mov si, state
			call shift_string
			mov si, newstate
			call shift_string

		loop tl
	pop dx, ax, cx
	mov si, newstate
	mov di, state
	call strcpy

	ret

; --------------------------------------------------------------

shift_string: ; works! RIGHT direction! include si
	push si, di, ax, bx, dx
	mov di, tmp
	pushad
		mov cx, 5
		mov dx, 0
		add si, 8
		add di, 8
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
		add si, 2
		add di, 2

		mov si, tmp
		mov di, tmp
		add si, 8
		add di, 8
		lodsw
			shl dx, 15 ; carry flag from %111 stays in stack
			or ax, dx
		stosw
	popad
	xchg si, di
	call strcpy
	pop dx, bx, ax, di, si
	ret

; >>>>>>>>>> Util

put_hash:
	push ax
	mov al, 0x23
	mov ah, 0x0E
	int 0x10
	pop ax
	ret

; --------------------------------------------------------------

put_space:
	push ax
	mov al, 0x20
	mov ah, 0x0E
	int 0x10
	pop ax
	ret

; --------------------------------------------------------------

strcpy: ; just for 80 bits
	push ax, cx
	mov cx, 5
	rep movsw
	pop cx, ax
	ret

; --------------------------------------------------------------

clr_str:
	push cx, ax, di, si
		mov cx, 5
		mov di, si
		clrl:
		lodsw
			mov ax, 0
		stosw
		loop clrl
	pop si, di, ax, cx
	ret

; --------------------------------------------------------------

clrscr:
	push dx, bx, ax, cx
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
	pop cx, ax, bx, dx
	ret

; --------------------------------------------------------------

k_puts: ; important: we _are_ outputing bits from the smallest => biggest
	push cx,dx,ax
	mov cx, 10
	in1: ; 10 bytes
		mov dl, 1; mask
		lodsb ; 8 bits => AL
		in2: ; passing through bits
			test al, dl
			jnz hash
			call put_space
			jmp pend
			hash:
			call put_hash
			pend:
			shl dl, 1
		jnc in2 ; carry != 1 => NOT overflow in dl => NOT finish (8 bits in dl)
	loop in1
	pop ax,dx,cx
	ret


; >>>>>>>>>> vars in memory
state   dw 0, 0x0,0x1,0,0x0000 ; 2 hex symbols => 8 binary states
newstate dw 5 dup(0)
tmp dw 5 dup(0)

; >>>>>>>>>> boot sector stuff
times 510-($-$$) db 0
	db 0x55, 0xaa