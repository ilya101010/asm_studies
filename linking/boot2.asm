Use16
org     0x7C00
start:
	cli		     ; disabling interrupts
	mov     ax, cs	  ; segment registers' init
	mov     ds, ax
	mov     es, ax
	mov     ss, ax
	mov     sp, 0x7C00      ; stack backwards => ok

	; очистить экран
	mov ax, 0x0003
	int 0x10
	 
	;открыть A20
	in  al, 0x92
	or  al, 2
	out 0x92, al
	 
	;Загрузить адрес и размер GDT в GDTR
	lgdt  [gdt_desc]

	;Запретить немаскируемые прерывания
	in  al, 0x70
	or  al, 0x80
	out 0x70, al
	 
	;Переключиться в защищенный режим
	mov  eax, cr0
	or   al, 1
	mov  cr0, eax

	jmp 08h:pm_entry



;32-битная адресация
use32
;Точка входа в защищенный режим
pm_entry: ; yay!
	mov ax, 08h
mov ds, ax
mov ss, ax
mov esp, 090000h
	mov [0xb8000], 0x07690748
	jmp $
 
msg:
  db  'Hello World!', 0



gdt: ; Address for the GDT
gdt_null: ; Null Segment
		dq 0
gdt_code: ; Code segment, read/execute, nonconforming
		dw 0FFFFh
		dw 0
		db 0
		db 10011010b
		db 11001111b
		db 0
gdt_data: ; Data segment, read/write, expand down
		dw 0FFFFh
		dw 0
		db 0
		db 10010010b
		db 11001111b
		db 0
gdt_end: ; Used to calculate the size of the GDT



gdt_desc:                       ; The GDT descriptor
		dw gdt_end - gdt - 1    ; Limit (size)
		dd gdt                  ; Address of the GDT

; >>>>>>>>>> boot sector stuff
times 510-($-$$) db 0
	db 0x55, 0xaa