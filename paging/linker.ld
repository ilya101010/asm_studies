MEMORY
{
	bootloader : org = 0x7C00, len = 1k
	basic_kernel : org = 0x8000, len = 8k

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
		procedures.o(.text);
		paging.o(.text)
	} > basic_kernel

	/* 0x10000 - start of paging structures */
}