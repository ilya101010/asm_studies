format ELF

include 'macro.inc'
include 'paging.inc'

public kernel_setup

section '.text' executable
Use32

kernel_setup:
	jmp $