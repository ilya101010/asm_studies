OUTPUT_FORMAT("binary")
OUTPUT("final.img")
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
	. = 2047;
	.text32 : {
		BYTE(0);
	}
}