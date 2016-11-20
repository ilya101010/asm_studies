Use16
org     0x7C00

; calling convention - cdecl

macro push [arg] { push arg }
macro pop [arg] { pop arg }

start:
    ; setting real mode
    cli          ; disabling interrupts
    mov     ax, cs    ; segment registers' init
    mov     ds, ax
    mov     es, ax
    mov     ss, ax
    mov     sp, 0x7C00      ; stack backwards => ok
    
    ; managing gdt


    jmp     $          ; infinite loop

; >>>>>>>>>> boot sector stuff
times 510-($-$$) db 0
    db 0x55, 0xaa



GDTTable:   ;таблица GDT
; нулевой дескриптор
d_zero:     db  0,0,0,0,0,0,0,0     
; сегмент 32-битного кода (4 гигабайт)
d_code32:   db  0ffh,0ffh,0,0,0,10011010b,11001111b,0 
; сегмент 16-битного кода (4 гигабайт)
d_code16:   db  0ffh,0ffh,0,0,0,10011010b,10001111b,0

GDTSize     =   $-GDTTable

GDTR:               ;загружаемое значение регистра GDTR
g_size:     dw  GDTSize-1   ;размер таблицы GDT
g_base:     dd  0           ;адрес таблицы GDT
