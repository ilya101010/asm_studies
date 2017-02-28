#include <stdint.h>
#include <stdlib.h>
#include <stddef.h>

#include <tty.h>
#include <debug.h>
#include <stack.h>
#include <paging.h>
#include <gdt.h>
#include <tss.h>
#include <memtab.h>
//#include <msr.h>

#define p_entry(addr, f) (addr << 12) | f

extern void sys_enter();
extern void sys_write(char* src);

void* PD_a;

extern void msr_get(uint32_t num, uint32_t* low, uint32_t *high);
extern void msr_set(uint32_t num, uint32_t low, uint32_t high);

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

#define SYSR_LADDR 0xC0000000

void kernel_start()
{
	tty_init();
	size_t memory_size = p_init();
	uint32_t l, h;
	mem_setup();
	msr_set(0x174,0x0,SEG(1));
	msr_set(0x175,0x0,0x7c00);
	msr_set(0x176,0x0,0xC0000000);
	enable_tss(5);
	char* out = "sys_write demo";
	mbp;
	sys_write(out);
	sys_write(out);
}

size_t p_init()
{
	get_available_memory();
	init_PD();
	size_t res = map_available_memory();
	map_page(0xB8000,0xB8000,pg_P | pg_U);
	map_page(SYSR_LADDR,0xA000,pg_P | pg_U);
	// TODO: bios
	init_paging();
	return res;
}