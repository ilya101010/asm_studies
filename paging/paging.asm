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
	ccall fill_zeros, PD, 0x1000
	ccall fill_zeros, PT, 16*0x1000
	ret

setup_pages:

setup_table: ; eax - # of table in PD, bh - flags, edx - address
.pd_entry_setup:
	
	ret	

setup:
	ccall fill_zeros, PD, 0x1000

PD = pd_add
PT = pd_add+pd_num*pd_size
