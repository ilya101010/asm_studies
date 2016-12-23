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

	.text :	{
		. = 512;
		FILL(0);
		boot.o(.text32);
		*(.text)
	}
	.rodata : {
		*(.rodata)
	}

	/* Read-write data (initialized) */
	.data : {
		*(.data)
	}

	/* Read-write data (uninitialized) and stack */
	.bss : {
		*(COMMON)
		*(.bss)
	}
}