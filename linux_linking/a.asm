format ELF
public _start
public bputs
extrn _main

macro push [arg] { push arg }
macro pop [arg] { pop arg }
macro global [symbol]
{
	local isextrn,isglobal
	if defined symbol & ~ defined isextrn
	public symbol
	else if used symbol & defined isglobal
	extrn symbol
	isextrn = 1
	end if
	isglobal = 1
}

section '.text' executable

; extrn k_main

_start:
	call _main
	;call bputs
	
	mov eax,1		; System call 'exit'
	xor ebx,ebx		; Exitcode: 0 ('xor ebx,ebx' saves time; 'mov ebx, 0' would be slower)
	int 0x80

put_hash:
	push ebp, eax, edi
	mov ebp, esp
	mov eax, '#'
	mov edi, symb
	stosb

	mov eax,4             ; System call 'write'
	mov ebx,1             ; 'stdout'
	mov ecx,symb           ; Address of message
	mov edx,2      ; Length  of message
	int 0x80              ; All system calls are done via this interrupt
	pop edi, eax, ebp
	ret

put_space:
	pusha
	mov ebp, esp
	mov eax, ' '
	mov edi, symb
	stosb

	mov eax,4             ; System call 'write'
	mov ebx,1             ; 'stdout'
	mov ecx,symb           ; Address of message
	mov edx,2      ; Length  of message
	int 0x80              ; All system calls are done via this interrupt
	popa
	ret

bputs: ; important: we _are_ outputing bits from the smallest => biggest
	push ebp
	mov ebp, esp
	pusha
	mov esi, [ebp+8]
	; >>> formating stare_str
	mov cx, [ebp+12]
	mov esi, [ebp+8]
	mov edi, state_str
	in1: ; 10 bytes
		mov dl, 1; mask
		lodsb ; 8 bits => AL
		in2: ; passing through bits
			test al, dl
			jnz hash
			push eax
				mov al, '.'
				stosb
			pop eax
			jmp pend
			hash:
			push eax
				mov al, '#'
				stosb
			pop eax
			pend:
			shl dl, 1
		jnc in2 ; carry != 1 => NOT overflow in dl => NOT finish (8 bits in dl)
	loop in1
	; >>> adding /n
	mov al, 0xA
	stosb
	; >>> actual write
	mov eax,4			; System call 'write'
	mov ebx,1			; 'stdout'
	mov ecx,state_str	; Address of message
	mov edx, [ebp+12]
	shl edx, 3
	inc edx
	int 0x80			; All system calls are done via this interrupt
	popa
	pop ebp
	ret

section  '.bss' writable

symb db 48
state_str db 1025 dup(48) 