#include <stdint.h>
#include <stdlib.h>
#include <stddef.h>

#include <tty.h>
#include <debug.h>
#include <stack.h>
#include <paging.h>
#include <gdt.h>

#define p_entry(addr, f) (addr << 12) | f

void* PD_a;

// Happy the man, and happy he alone
// He who can call today his own,
// He who, secure within, can say:
// Tomorrow do thy worst, for I have lived today

// \xC9 - ╔ \xCB - ╦ \xCD - ═ \xBB - ╗
//
// \xBA - ║ \xCC - ╠ \xCE - ╬ \xB9 - ╣
//
// \xC8 = ╚ \xBC - ╝ \xCA - ╩

size_t p_init();

void kernel_start()
{
	tty_init();
	static char* strs[] = {	"\xC9\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCB\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCB\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xBB",
							"\xBA  Type  \xBA  Base address  \xBA     Length     \xBA           ",
							"\xCC\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCE\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCE\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xB9",
							"\xC8\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCA\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCA\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xBC",
							"Available memory size: 00000000",
							"0000000000000000"};
	for(int i = 0; i<3; i++)
		tty_print(strs[i]);
	
	size_t memory_size = p_init();

	mmap_entry *region;
	for(int i = 0; i < stack_size(); i++)
	{
		region = stack_get(i);
		hex_f(region->type,strs[1]+1);
		hex_f(region->base_high,strs[1]+10);
		hex_f(region->base_low,strs[1]+18);
		hex_f(region->length_high,strs[1]+27);
		hex_f(region->length_low,strs[1]+35);
		tty_print(strs[1]);
	}
	tty_print(strs[3]);
	hex_f(memory_size, strs[4]+23);
	tty_print(strs[4]);
	initGDTR();
	gdt_set_gate(3,0xB8000,0x2a,0x92,0x40);
	//initGDTR();
	gdt_flush(8);
}

size_t p_init()
{
	get_available_memory();
	init_PD();
	size_t res = map_available_memory();
	map_page(0xB8000,0xB8000,pg_P | pg_U);
	// TODO: bios
	init_paging();
	return res;
}