MEMORY
{
	bootloader : org = 0x7c00, len = 1k
	basic_kernel : org = 0x8000, len = 28k
}

OUTPUT_FORMAT("binary")
OUTPUT("final.img")
ENTRY(start)

SECTIONS
{
 	. = 0; /* */
	.boot : {
		FILL(0);
		boot.o(.text16);
		. = 510;
		SHORT(0xaa55);
		boot.o(.text32);
	} > bootloader

	.bkernel :
	{
		main.kernel.o(.text);
		procedures.kernel.o(.text);
		tty.kernel.o(.text);
		stack.kernel.o(.text);
		paging.kernel.o(.text);
		paging.c.kernel.o(.text);
		gdt.kernel.o(.text);
		tss.kernel.o(.text);
	} > basic_kernel
}