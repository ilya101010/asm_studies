format ELF executable 3
entry start
 
;================== code =====================
segment readable executable
;=============================================
 
start:
 
        mov     eax,4             ; System call 'write'
        mov     ebx,1             ; 'stdout'
        mov     ecx,msg           ; Address of message
        mov     edx,msg_size      ; Length  of message
        int     0x80              ; All system calls are done via this interrupt
 
        mov     eax,1             ; System call 'exit'
        xor     ebx,ebx           ; Exitcode: 0 ('xor ebx,ebx' saves time; 'mov ebx, 0' would be slower)
        int     0x80
 
;================== data =====================
segment readable writeable
;=============================================
 
msg db 'Hello world!',0xA
msg_size = $-msg