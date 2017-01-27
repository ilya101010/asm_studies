OUTPUT("kernel.elf")
ENTRY(_start)

phys = 0x8400;

MEMORY
{
	rom	(rwx): ORIGIN = phys, LENGTH = 256K
	ram : org = 0x40000000, LE = 4M;
}

SECTIONS
{
	.text {
		*(.text);
	} > rom
}

MEMORY
{
    ram    (rwx) : ORIGIN = 0x20000000, LENGTH = 20k
    rom    (rx)  : ORIGIN = 0x00000000, LENGTH = 128K
}
SECTIONS
{
    .  = phys;           /* From 0x00000000 */
    .text : 
    {
        *(.text.*)      /* Program code */
        *(.text)        /* Program code */
        *(.rodata)      /* Read only data */
    } >rom

    .  = 0x20000000;    /* From 0x20000000 */      
    .data : 
    {
        *(.data)        /* Data memory */
    } >ram AT > rom

    .bss : 
    {
        *(.bss)         /* Zero-filled run time allocate data memory */
    } >ram AT > rom
}  