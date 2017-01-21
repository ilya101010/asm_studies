format ELF

include 'macro.inc'
include 'procedures.inc'

section '.text' executable
use32

public init_paging

pd_add = 0xA000
pd_size = 4
pd_num = 1024

; [pde, pde+0x1000] - PDE 1
; [pde+0x1000+1+(i-1)]

init_paging:
	mbp
.clean:
	ccall fill_zeros, PD, 0x1000
	ccall fill_zeros, PT, 2*0x1000
.pd_set:
	mov edi, PD
	mov ecx, 1024
	.lp1:
		mov eax, PT
		and eax, 0xFFFFF000 ; align
		or eax, 000000000011b
		stosd
	loop .lp1
.pe_set:
	mov edi, PT
	mov ecx, 1024
	mbp
	.lp2:
		mov eax, 0x8000
		and eax, 0xFFFFF000 ; align
		or eax, 000000000011b
		stosd
	loop .lp2
	mov edi, PT+4*0xB8
	mov eax, 0xB8000
	and eax, 0xFFFFF000 ; align
	or eax, 000000000011b
	stosd
	mbp
.enable:
	mov eax, PD
	mov cr3, eax
	mov eax, cr0
	or eax, 0x80000000
	mov cr0, eax

	mbp

	ccall print, paging, 2, 0x0a

	jmp $

paging: db "paging!",0

set_address: ; esi - address of entry, eax - first 12 bits - flags

setup_table: ; eax - # of table in PD, bh - flags, edx - address
.pd_entry_setup:
	
	ret	

setup:
	ccall fill_zeros, PD, 0x1000

PD = pd_add
PT = pd_add+pd_num*pd_size
