OUTPUT_FORMAT("binary")
OUTPUT("final")
ENTRY(start)
phys = 0x7C00;


SECTIONS
{
  . = 0;
  .text : {
  	boot.o(.text16)
  	boot.o(.text32)
  }
  . = 510;
  .sign : {
  	SHORT(0x55aa);
  }
}