format ELF

include 'macro.inc'
include 'paging.inc'
include 'procedures.inc'

public kernel_setup
extrn init_paging

section '.text' executable ; align 1000h
Use32

kernel_setup:
	ccall print, string, 1, 0x0a
	jmp init_paging
	jmp $
	dd 0x42,0x42,0x42

string: db "kernel_setup",0
; http://wiki.osdev.org/User:Mduft/HigherHalf_Kernel_with_32-bit_Paging#Welcome