format elf

section '.text' executable

use32

macro SC addr
{
	dd addr
}

SYSCALL_NUMBER = 1

sys_routine:
	cmp eax, SYSCALL_NUMBER
	jg .end
	call dword [syscalls+eax*4]
	.end:
	sysexit

syscalls: 
	SC SC_print

extrn tty_print
SC_print: ; esi - char* src
	pushad
		call tty_print
	popad
	ret