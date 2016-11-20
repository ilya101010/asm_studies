Use16
org     0x7C00
start:
        cli                     ; disabling interrupts
        mov     ax, cs          ; segment registers' init
        mov     ds, ax
        mov     es, ax
        mov     ss, ax
        mov     sp, 0x7C00      ; stack backwards => ok
       
        mov     ax, 0xB800
        mov     gs, ax          ; Использовал для вывода текста прямой доступ к видеопамяти
       
        mov     si, msg
        call    clrscr
        call    k_puts
       
        hlt                     ; Останавливаем процессор
       
        jmp     $               ; И уходим в бесконечный цикл

clrscr:
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
        ret
        

k_puts:
        lodsb
        test    al, al ; if al = 0?
        jz      .end_str
        mov     ah, 0x0E
        ; mov     bl, 0xAA                ; Серый на черном
        int     0x10
       
        jmp     k_puts

output:
        
 
.end_str:
ret

state   db 0x00, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00 ; 2 hex symbols => 8 binary states
msg     db 'abcdefghijklmnopqrstwxyz; 1234567890; YAY!', 0x0d, 0x0a, 0
 
times 510-($-$$) db 0
        db 0x55, 0xaa