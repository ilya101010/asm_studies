format ELF

include 'macro.inc'
include 'procedures.inc'

section '.text' executable
use32

public enable_paging

pd_add = 0xB000
pd_size = 4
pd_num = 1024

; [pde, pde+0x1000] - PDE 1
; [pde+0x1000+1+(i-1)]

enable_paging:;(void * PD) ; ret, cause low memory mapped onto itself
	push ebp
	mov ebp, esp
	mov eax, [ebp+8]
	mov cr3, eax
	mov eax, cr0
	or eax, 0x80000000
	mov cr0, eax
	pop ebp
	ret