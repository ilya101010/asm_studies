format ELF

section '.text' executable

macro SC addr
{
	dd addr
	SYSCALL_NUMBER = SYSCALL_NUMBER + 1
}

SYSCALL_NUMBER = 0
sys_routine:
	cmp eax, SYSCALL_NUMBER
	jg .end
	jmp dword [syscalls+eax*4]
	.end:
	sysexit

syscalls:
	SC SC_print

SC_print:
	mov word [0xB8000], 0xffff
	ret