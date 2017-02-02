#include <stdint.h>
#include <stdlib.h>
#include <stddef.h>

#define p_entry(addr, f) (addr << 12) | f

extern void print(char* src, int y, uint8_t color);
extern void hex_f(int n, char *s);
extern void fill_zeros(void* dst, size_t size);

typedef struct mmap_entry
{
	int base_low;
	int base_high;
	int length_low;
	int length_high;
	int type;
} mmap_entry;

typedef enum stackop {PUSH,POP,GET,SET,SIZE} stackop;

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
			if(i == 0) return 0;
			tmp = list[i];
			list[i] = 0;
			i--;
			return 0xa000;
		case GET:
			return list[i];
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
		if(region -> type == 1)
			stack(PUSH,region);
		hex_f(region->type,strs[1]+1);
		hex_f(region->base_high,strs[1]+10);
		hex_f(region->base_low,strs[1]+18);
		hex_f(region->length_high,strs[1]+27);
		hex_f(region->length_low,strs[1]+35);
		if(region->type == 1) hex_f((region->length_low)/0x1000,strs[1]+45), R += (region->length_low)/0x1000; // 32 bit!
		else hex_f(0,strs[1]+45);
		print(strs[1],i+3,0x0F);
		*region++; // is actually +20 bytes (!)
		i++;
	}
	print(strs[3],i+3,0x0F);
	hex_f(stack(SIZE,0),strs[4]+24);
	print(strs[4],i+4,0x0F);
}

void paging_init()
{
	fill_zeros(0xA000,1024*0x1000);
}