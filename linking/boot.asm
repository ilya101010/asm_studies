format ELF

org     0x7C00

macro push [arg] { push arg }
macro pop [arg] { pop arg }
macro mbp
{
	xchg bx, bx
}
; >>>> 16bit code

section '.text16' executable
Use16


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

	; Вычислить и записать в дескриптор адрес 32-битного кода 
	mov eax,ebx     ;восстанавливаем линейный адрес
	add eax,entry_pm   ;теперь в EAX линейный адрес сегмента кода
	add eax, 0x7c00
	mov edi,d_code32+2   ;пишем базу в дескриптор
	add edi, 0x7c00
	stosw           ;биты 0..15
	shr eax,16
	stosb           ;биты 16..23
	add di,2        ;последние биты в конце дескриптора
	shr ax,8
	stosb           ;биты 24..31

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
	dd  0 ; offset
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
use32               ;32-битный код!!!


public entry_pm
align   10h         ;код должен выравниваться по границе 16 байт
entry_pm:
	jmp k_main

k_main:
	pm_entry:
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
		jmp  $			    ;зависаем

		msg:
		db  'Booting to C file...', 0



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