Use16
org     0x7C00

; calling convention - cdecl

macro push [arg] { push arg }
macro pop [arg] { pop arg }
macro ops ; al
{
	mov ah, 0x0E
	mov bl, 0x07
	int 0x10
} 

start:
	cli		     ; disabling interrupts
	mov     ax, cs	  ; segment registers' init
	mov     ds, ax
	mov     es, ax
	mov     ss, ax
	mov     sp, 0x7C00      ; stack backwards => ok
	
	push msg
	call k_puts
	pop si

	jmp     $	       ; infinite loop
; >>>>>>>>>> Util

k_puts:
	mov si, [esp+2]
	push ax, bx
	bk0:
	lodsb
	test al, al
	jz .end_str
	ops
	jmp bk0
	.end_str:
	pop bx, ax
	ret

; >>>>>>>>>> vars; null-terminated strings

msg db 'Hello cdecl World', 0


; >>>>>>>>>> boot sector stuff
times 510-($-$$) db 0
	db 0x55, 0xaa