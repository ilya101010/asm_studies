format ELF

org     0x7C00

DEBUG = 0

macro push [arg] { push arg }
macro pop [arg] { pop arg }
macro mbp
{
	if DEBUG=1
		xchg bx, bx
	end if
}
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
	mov al, 0x01    ; Read one sector only (512 bytes per sector)
	mov ch, 0x00    ; Track 0
	mov cl, 0x02    ; Sector 2
	mov dh, 0x00    ; Head 0
	mov dl, 0x00    ; Drive 0 (Floppy 1)
	mov bx, cs
	mov es, bx   ; Segment 0x2000
	mov bx, 0x7e00      ;  again remember segments bust be loaded from non immediate data
	int 13h

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
	dd  entry_pm ; offset
	dw  sel_code32 ; selector

GDTTable:   ;таблица GDT
; zero seg
d_zero:		db  0,0,0,0,0,0,0,0     
; 32 bit code seg
d_code32:	db  0ffh,0ffh,0,0,0,10011010b,11001111b,0
; video
d_video:	db	0ffh, 07fh, 0x00, 80h, 0bh, 10010010b, 01000000b, 0x00

GDTSize     =   $-GDTTable

GDTR:               ;загружаемое значение регистра GDTR
g_size:     dw  GDTSize-1   ;размер таблицы GDT
g_base:     dd  GDTTable           ;адрес таблицы GDT

; >>>> 32bit code

section '.text32' executable align 10h

org     0x7E00
use32               ; 32 bit

public entry_pm
extrn k_main

align   10h         ;код должен выравниваться по границе 16 байт
entry_pm:
	; >>> setting up all the basic stuff
	cli		     ; disabling interrupts
	mov     eax, cs	  ; segment registers' init
	;mov     ds, eax
	;mov     es, eax
	;mov     ss, eax
	mov     esp, 0x7C00      ; stack backwards => ok

	mbp
	; >>> demo message
	mov  eax, sel_video	      ;начало видеопамяти в видеорежиме 0x3
	mov  es, ax
	mov  esi, msg
	mov  ah, 7
	xor  edi, edi
	.loop:			     ;цикл вывода сообщения
	lodsb			    ;считываем очередной символ строки
	test al, al		    ;если встретили 0
	jz   .exit		    ;прекращаем вывод
	stosw
	jmp  .loop
	.exit:
	msg:
	db  'Booting to k_main...', 0
	; >>>Booting to k_main...
	call k_main
	jmp  $ ; wow! 




; >>>> GDT

; селекторы дескрипторов (RPL=0, TI=0)
sel_zero    =   0000000b
sel_code32  =   0001000b
sel_video  	=   0010000b

align   10h         ;выравнивание таблицы по границе 16 байт

	; Here goes C flat binary?

; >>> boot sector signature
;finish:
;times 0x1FE-finish+start db 0
;db	 0x55, 0xAA ; ñèãíàòóðà çàãðóçî÷íîãî ñåêòîðà