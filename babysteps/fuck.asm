Use16
org     0x7C00
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
		call shift_string
	loop lp0
	jmp     $	       ; И уходим в бесконечный цикл

iterate:
	mov si, state
	call eval ; magic; si = refferals; di = output
	mov si, newstate
	call clr_str

	ret

eval: ; the idea is to pass one byte through all of the string => 78 iterations (check: 0M000000, where M is the magic)
	pusha
		mov si, state
		call shift_string
		mov si, tmp
		call clr_str
		mov di, newstate
		mov si, state
		call strcpy
	popa

	ret

magic:
	pusha
		lodsb
		and al, 7 ; first 3 bits
		mov cl, al
		mov dl, 126 ; example rule
		shl dl, cl
		and dl, 1
		test dl, dl
		jz pal0
		jnz pal1
		bk1:
		stosb
	popa
	ret

shift_string: ; RIGHT direction! include si
	push di
	push si
	mov di, tmp
	pushad
		mov cx, 10
		mov dx, 0
		add si, 10
		add di, 10
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
		
		pop dx ; bit from first word
		add si, 8
		add di, 8
		lodsw
		shl dx, 15
		test dx, dx
		or ax, dx
		stosw
	popad
	xchg si, di
	call strcpy
	pop si
	pop di
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
	pusha
	mov cx, 5
	rep movsw
	popa
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
	jmp back1

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
state   dw 0x3, 0,0,0,0x8000 ; 2 hex symbols => 8 binary states
newstate dw 0,0,0,0,0 ; place to copy; how to dup?!
tmp dw 0,0,0,0,0 ; place to copy; how to dup?!
rule db 126

; >>>>>>>>>> boot sector stuff
times 510-($-$$) db 0
	db 0x55, 0xaa