#include <stdint.h>
#include <stdlib.h>
#include <stddef.h>

#include <tty.h>
#include <debug.h>
#include <stack.h>
#include <paging.h>

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
							"Available memory size: 00000000"};
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



// void paging_init()
// {
// 	mmap_entry region;
// 	char* bingo = "BINGO! 00000000";
// 	int length, dlt;
// 	for(int i = 1; i < stack_size(); i++) // not the first region - generally used by bootloader, GDT, IDT - no need for mess in there
// 	{
// 		region = *((mmap_entry *)stack_get(i));
// 		if(region.length_low > 0x1000+0x1000*1024)
// 		{
// 			hex_f(region.length_low,bingo+7);
// 			print(bingo,20,0x0f);
// 			PD = region.base_low; // I hope VERY much, that it takes place in low 32 bits...
// 			break; // now, region
// 		}
// 	}

// 	char* hurray = "PAGING!";
// 	hex_f(PD,hurray+8);
// 	print(hurray,17, 0xF);

// 	// first - PD
// 	fill_zeros(PD,0x1000+0x1000*1024);
// 	int pt = 0, pte = 0;
// 	// page dir
// 	volatile int* e = (volatile int*)PD;
// 	for(int i = 0; i<1024; i++)
// 	{
// 		*e = PD+0x1000*(i+1);
// 		*e |= pg_P | pg_U;
// 		*e++;
// 	}
// 	// page tables

// 	int R = 0;
// 	region = *((mmap_entry *)stack_get(R));

	
// 	int reg_in = region.base_low & 0xfffff000 + (((region.base_low & 0xfffff000) != region.base_low) ? 0x1000 : 0);
// 	reg_in |= pg_P | pg_U;
// 	hex_f(region.length_low,bingo+7);
// 	print(bingo,10+R,0x0f);
// 	;

// 	static char* test = "TEST :  00000000";
// 	hex_f(stack_size(),test+8);
// 	print(test,17,0x0f);

// 	for(int i = 0; i<1024*1024; i++)
// 	{	

// 		*e = region.base_low;

// 		*e |= pg_P | pg_U | pg_R;
// 		if(region.length_low < 0x1000)
// 		{
// 			*e = 0;
// 			continue;
// 		}
// 		region.length_low-=0x1000;
// 		region.base_low+=0x1000;
	
// 		hex_f(stack_size(),test+8);
// 		print(test,23,0x0a);

// 		if((region.length_low < 0x1000) && R < stack_size())
// 		{
// 			mbp;
// 			R++;
// 			region = *((mmap_entry *)stack_get(R));	
// 			hex_f(region.length_low,bingo+7);
// 			print(bingo,10+R,0x0f);
// 		}

// 		*e++;
// 	}

// 	// we'd better fix 0xB8000
// 	e = PD+0x1000+4*0xB8;
// 	*e = 0xB8000;
// 	*e |= pg_P | pg_U | pg_R;

// 	mbp;
// 	enable_paging(PD);
// 	mbp;
// }