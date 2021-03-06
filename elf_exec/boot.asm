format ELF

include 'macro.inc'
include 'paging.inc'

; >>>> 16bit code

section '.text16' executable
Use16

org 0x7c00 ; why?! loop problems

public start
start:
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
	; memory map
memory_map:
	xor ebx, ebx
	xor bp, bp
	mov edx, 534D4150h
	mov eax, 0xe820
	mov edi, 0xA000-20
	.lp:
		add edi, 20
		mov ecx, 20
		mov edx, 534D4150h
		mov eax, 0xe820
		int 15h
		test ebx, ebx
	jnz .lp

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

section '.text32' executable align 100h
; org     0x7E00
use32               ;32-битный код!!!

public entry_pm
extrn kernel_setup

align   10h         ;код должен выравниваться по границе 16 байт
include 'procedures.inc'
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
	ccall itoah, 0xdead, addr+1
	ccall print, addr+1, 0, green

memory_map_out:
	mov ebp, 1
	mov esi, 0xA000
	mov ecx, 20 ; why? don't ask questions like this
	.lp3:
	push ebp, ecx
		virtual at esi
			.base_low dd ?
			.base_high dd ?
			.len_low dd ?
			.len_high dd ?
			.type dd ?
		end virtual
		jmp memory_map_out_r
		.back:
		mov eax, [.type]
		test eax, eax
		jz .exit
	popr ebp, ecx
	inc ebp
	jmp .lp3
	.exit:
end:
	jmp $

memory_map_out_r:
	virtual at esi
		.base_low dd ?
		.base_high dd ?
		.len_low dd ?
		.len_high dd ?
		.type dd ?
	end virtual
	mov eax,[.base_high]
	ccall hex_f, eax, map_s+4
	mov eax,[.base_low]
	ccall hex_f, eax, map_s+12
	mov eax,[.len_high]
	ccall hex_f, eax, map_s+26
	mov eax,[.len_low]
	ccall hex_f, eax, map_s+34
	mov eax,[.type]
	ccall hex_f, eax, map_s+48
	ccall print, map_s, ebp, green
	inc ebp
	add esi, 20
	jmp memory_map_out.back

; >>>> Data
	
string db "hello world",0
map_s db "A : 0000000000000000, L = 0000000000000000, T = 00000000",0
addr: times 20 db 0
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