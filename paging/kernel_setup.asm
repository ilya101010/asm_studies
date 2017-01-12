format ELF

include 'macro.inc'
include 'paging.inc'

public kernel_setup

section '.text' executable ; align 1000h
Use32

kernel_setup:
	jmp $

section '.data' align 1000h
; here lie all the data structures
times 4 dd 0
_kernel_pd:
	times 0x1000 dd 0
_kernel_pt:
	times 0x1000 dd 0
_kernel_low_pt:
	times 0x1000 dd 0

; http://wiki.osdev.org/User:Mduft/HigherHalf_Kernel_with_32-bit_Paging#Welcome