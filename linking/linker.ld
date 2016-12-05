OUTPUT_FORMAT("binary")
OUTPUT("final")
ENTRY(start)
phys = 0x7C00;


SECTIONS
{
 	. = 0;
	.boot : {
		FILL(0);
		boot.o(.text16);
		. = 510;
		SHORT(0xaa55);
		boot.o(.text32);
	}
	.text32 : {
		. = 512;
		FILL(0);
		boot.o(.text32);
		kernel.o(.text)
	}
}