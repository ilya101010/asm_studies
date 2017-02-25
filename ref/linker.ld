/* MEMORY
{
	bootloader : org = 0x7c00, len = 1k
	basic_kernel : org = 0x8000, len = 5k
} */

OUTPUT_FORMAT("binary")
OUTPUT("final.img")
ENTRY(start)

SECTIONS
{
 	/* . = 0; */
	.boot 0x7c00: {
		FILL(0);
		boot.o(.text16);
		. = 510;
		SHORT(0xaa55);
		boot.o(.text32);
		. = 1023;
		BYTE(0x90);
	} /*> bootloader*/

	.bkernel 0x8000:
	{
		main.kernel.o(.text);
		procedures.kernel.o(.text);
		msr.kernel.o(.text);
		memory.kernel.o(.text);
		memtab.kernel.o(.text);
		tty.kernel.o(.text);
		stack.kernel.o(.text);
		paging.kernel.o(.text);
		paging.c.kernel.o(.text);
		gdt.kernel.o(.text);
		tss.kernel.o(.text);
		FILL(0x90);
		. = 1024*4; 
		BYTE(0x90);
	} /* > basic_kernel */

	
}
