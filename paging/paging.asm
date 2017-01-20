format ELF

include 'macro.inc'
include 'procedures.inc'

section '.text' executable
use32

pde = 0x10000

; [pde, pde+0x1000] - PDE 1
; [pde+0x1000+1+(i-1)]

setup_pages:

setup_table: ; eax - # of table in PD, bh - flags, edx - address
.pd_entry_setup:
	

	ret	

setup:
	ccall fill_zeroes, pde, 0x1000
