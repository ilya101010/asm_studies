#include <stdint.h>
#include <stdlib.h>
#include <stddef.h>

#define p_entry(addr, f) (addr << 12) | f

#define DEBUG
#define mbp
#ifdef DEBUG
	#define mbp asm("xchgw %bx, %bx")
#endif

#define PD PD_a
#define PDE(i) PD+4*i
#define PT(i) PD+0x1000+0x1000*i
#define PTE(n, i) PT(n)+4*i

#define pg_P 1
#define pg_R 2
#define pg_U 4

extern void print(char* src, int y, uint8_t color);
extern void hex_f(int n, char *s);
extern void fill_zeros(void* dst, size_t size);
extern void enable_paging(void* dst);

typedef struct mmap_entry
{
	int base_low;
	int base_high;
	int length_low;
	int length_high;
	int type;
} mmap_entry;

typedef enum stackop {PUSH,POP,GET,SET,SIZE} stackop;

void* PD_a;

// Happy the man, and happy he alone
// He who can call today his own,
// He who, secure within, can say:
// Tomorrow do thy worst, for I have lived today
mmap_entry* stack(stackop operation, mmap_entry* arg)
{
	static mmap_entry* list[20] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
	static unsigned char i = 0;
	mmap_entry* tmp;
	switch(operation)
	{
		case PUSH:
			list[i] = arg;
			i++;
			return arg;
		case POP:
			if(i == 0) return list[0];
			i--;
			tmp = list[i];
			list[i] = 0;
			return tmp;
		case GET:
			return list[(int)arg];
		case SET:
			list[i] = arg;
		case SIZE:
			return i;
		default:
			return 0;
	}
	return 0;
}

// \xC9 - ╔ \xCB - ╦ \xCD - ═ \xBB - ╗
//
// \xBA - ║ \xCC - ╠ \xCE - ╬ \xB9 - ╣
//
// \xC8 = ╚ \xBC - ╝ \xCA - ╩

void demo()
{
	static char* strs[] = {	"\xC9\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCB\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCB\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xBB",
							"\xBA  Type  \xBA  Base address  \xBA     Length     \xBA           ",
							"\xCC\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCE\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCE\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xB9",
							"\xC8\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCA\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCA\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xCD\xBC",
							"Available memory pages: 00000000"};
	for(int i = 0; i<3; i++)
		print(strs[i],i,0x0F);
	volatile mmap_entry* region = (volatile mmap_entry*)(0xA000);
	int i = 0;
	int R = 0;
	
	while(region->type != 0)
	{
		if(region->type == 1)
			stack(PUSH,region);
		*region++;
	}

	for(i = 0; i < stack(SIZE,0); i++)
	{
		region = stack(GET,i);
		hex_f(region->type,strs[1]+1);
		hex_f(region->base_high,strs[1]+10);
		hex_f(region->base_low,strs[1]+18);
		hex_f(region->length_high,strs[1]+27);
		hex_f(region->length_low,strs[1]+35);
		print(strs[1],i+3,0x0F);
	}

	paging_init();
	mbp;
	print(strs[3],i+3,0x0F);
	hex_f(stack(SIZE,0),strs[4]+24);
	print(strs[4],10,0x0F);

	while(1);
}

void paging_init()
{
	mmap_entry region;
	char* bingo = "BINGO! 00000000";
	int length, dlt;
	for(int i = 1; i < stack(SIZE,0); i++) // not the first region - generally used by bootloader, GDT, IDT - no need for mess in there
	{
		region = *(stack(GET,i));
		/*
		dlt = 0;
		if((region.base_low & 0xfff) != 0) region.base_low += 0x1000;
		dlt = region.base_low - (region.base_low & 0xfffff000);
		region.base_low &= 0xfffff000;
		region.length_low -= dlt;
		length = region.length_low;*/
		if(region.length_low > 0x1000+0x1000*1024)
		{
			hex_f(region.length_low,bingo+7);
			print(bingo,20,0x0f);
			PD = region.base_low; // I hope VERY much, that it takes place in low 32 bits...
			break; // now, region
		}
	}

	char* hurray = "PAGING!               ";
	hex_f(PD,hurray+8);
	print(hurray,17, 0xF);

	// first - PD
	fill_zeros(PD,0x1000+0x1000*1024);
	int pt = 0, pte = 0;
	// page dir
	volatile int* e = (volatile int*)PD;
	for(int i = 0; i<1024; i++)
	{
		*e = PD+0x1000*(i+1);
		*e |= pg_P | pg_U;
		*e++;
	}
	// page tables

	int R = 0;
	region = *stack(GET,R);

	/*
	int reg_in = region.base_low & 0xfffff000 + (((region.base_low & 0xfffff000) != region.base_low) ? 0x1000 : 0);
	reg_in |= pg_P | pg_U;
	hex_f(region.length_low,bingo+7);
	print(bingo,10+R,0x0f);
	*/;

	static char* test = "TEST :  00000000";
	hex_f(stack(SIZE,0),test+8);
	print(test,17,0x0f);

	for(int i = 0; i<1024*1024; i++)
	{	

		*e = region.base_low;

		*e |= pg_P | pg_U | pg_R;
		if(region.length_low < 0x1000)
		{
			*e = 0;
			break;
		}
		region.length_low-=0x1000;
		region.base_low+=0x1000;
		
		hex_f(stack(SIZE,0),test+8);
		print(test,23,0x0a);

		if((region.length_low < 0x1000) && R < stack(SIZE,0))
		{
			mbp;
			R++;
			region = *stack(GET,R);	
			hex_f(region.length_low,bingo+7);
			print(bingo,10+R,0x0f);
		}

		*e++;
	}

	// we'd better fix 0xB8000
	e = PD+0x1000+4*0xB8;
	*e = 0xB8000;
	*e |= pg_P | pg_U | pg_R;

	mbp;
	enable_paging(PD);
	mbp;
}