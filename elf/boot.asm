format ELF

include 'macro.inc'
include 'elf.inc'
; include 'proc32.inc' - these macros are SICK and TIRED of your damn EMAILS!

; >>>> 16bit code

section '.text16' executable
Use16


public start
start:
	org     0x7C00
	mbp

	cli		     ; disabling interrupts
	mov     ax, cs	  ; segment registers' init
	mov     ds, ax
	mov     es, ax
	mov     ss, ax
	mov     sp, 0x7C00      ; stack backwards => ok

	shl eax,4       ;умножаем на 16
	mov ebx,eax     ;копируем в регистр EBX
	; why?!

	push dx, bx, ax, cx
	mov dx, 0 ; set cursor to top left-most corner of screen
	mov bh, 0 ; page
	mov ah, 0x2 ; ah = 2 => set cursor
	int 0x10 ; moving cursor
	mov cx, 2000 ; print 2000 = 80*45 chars
	mov bh, 0
	mov ah, 0x9
	int 0x10
	pop cx, ax, bx, dx

	mbp
	; loading entry_pm to RAM
	mov ah, 0x02    ; Read Disk Sectors
	mov al, 0x10    ; Read one sector only (512 bytes per sector)
	mov ch, 0x00    ; Track 0
	mov cl, 0x02    ; Sector 2
	mov dh, 0x00    ; Head 0
	mov dl, 0x00    ; Drive 0 (Floppy 1)
	mov bx, cs
	mov es, bx   ; Segment 0x2000
	mov bx, 0x7e00      ;  again remember segments bust be loaded from non immediate data
	int 13h

	mbp

	; loading GDT
	lgdt    fword   [GDTR]

	; disable NMI
	in  al,70h
	or  al,80h
	out 70h,al

	; enable a20
	in  al,92h
	or  al,2
	out 92h,al
	
	; get into PM
	mov eax,cr0
	or  al,1     
	mov cr0,eax
	
	; O32 jmp far
	db  66h ; O32
	db  0eah ; JMP FAR
	dd  0x7E00 ; offset
	dw  sel_code32 ; selector

GDTTable:   ;таблица GDT
; zero seg
d_zero:		db  0,0,0,0,0,0,0,0     
; 32 bit code seg
d_code32:	db  0ffh,0ffh,0,0,0,10011010b,11001111b,0
; data
d_data:		db	0ffh, 0ffh, 0x00, 0, 0, 10010010b, 11001111b, 0x00

GDTSize     =   $-GDTTable

GDTR:               ;загружаемое значение регистра GDTR
g_size:     dw  GDTSize-1   ;размер таблицы GDT
g_base:     dd  GDTTable           ;адрес таблицы GDT

; >>>> 32bit code

section '.text32' executable align 10h
; org     0x7E00
use32               ;32-битный код!!!

public entry_pm

align   10h         ;код должен выравниваться по границе 16 байт0
entry_pm:
	; >>> setting up all the basic stuff
	cli		     ; disabling interrupts
	; cs already defined
	
	mov ax, sel_data
	mov ss, ax
	mov     esp, 0x7C00

	mov ax, sel_data
	mov ds, ax
	mov es, ax
	
	mbp
	elf_mag_c: ; checking elf magic number
		ccall elf_check_file, elf_load
		xor eax, 0
		push 0
		jnz .ok
		.error:
			pop eax
			ccall print, elf_mag_error+0x7C00, eax, red
			inc eax
			push eax
			jmp .end
		.ok:
			pop eax
			ccall print, elf_mag_ok+0x7C00, eax, green
			inc eax
			push eax
		.end:
	error_end:
		pop eax
		pushad
		ccall print, error_str+0x7c00, eax, red
		popad
		mbp
		jmp $

; >>>> Procedures (optional cdecl or nodecl)
; # output
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



; # ELF (see: http://wiki.osdev.org/ELF_Tutorial)
; bool elf_check_file(*hdr)
elf_check_file:
	push ebp
	mov ebp, esp
	mov eax, [ebp+8]
	.E ehdr eax
	mov eax, [.E.e_ident.ei_mag]
	mov ebx, 464c457fh ; magic number
	xor eax, ebx
	jnz .error
	.ok:
	mov eax, 1
	jmp .exit
	.error:
	mov eax, 0
	.exit:
	pop ebp
	ret


; elf_check_supported()

; >>>> errors
elf_mag_ok: db "ELF magic number - OK", 0
elf_mag_error: db "ELF magic number - ERROR", 0
elf_e_type_ok: db "ELF e_type - relocatable - OK",0
elf_symtab_ok: db "ELF symtable - OK", 0
error_str: db "ERROR! entering infinite loop",0 
; elf_mag: db 0x7f, 'E', 'L', 'F' ; ELF magic number

; >>>> Const

; >>> addresses (x86 elf)
elf_load = 0x8000
; >> elf_header
elf_type_off = 0x10
elf_shoff_off = 0x20
elf_shentsize_off = 0x2E
elf_shnum_off = 0x30
elf_shstrndx_off = 0x32


; >>> селекторы дескрипторов (RPL=0, TI=0)
sel_zero    =   0000000b
sel_code32  =   0001000b
sel_data  	=   0010000b

; >>> colors
green = 0x0A
red = 0x04

	; Here goes C flat binary?

; >>> boot sector signature
;finish:
;times 0x1FE-finish+start db 0
;db	 0x55, 0xAA ; ñèãíàòóðà çàãðóçî÷íîãî ñåêòîðà