#define DEBUG
#ifdef DEBUG
	#define mbp asm("xchgw %bx, %bx")
#else
	#define mbp
#endif

#define _black 0
#define _blue 1
#define _green 2
#define _cyan 3
#define _red 4
#define _magenta 5
#define _brown 6
#define _gray 7
#define _dgray 8
#define _lblue 9
#define _lgreen 0xA
#define _lcyan 0xB
#define _lred 0xC
#define _lmagenta 0xD
#define _yellow 0xE
#define _white 0xF
#define _COLOR(fg, bg) 0 | (fg | (bg * 0x10))

#include <system.h>

void write_string( int color, char* string )
{
    volatile char *video = (volatile char*)0xB8000;
    while( *string != 0 )
    {
    	string++;
        *video++ = *string;
        *video++ = color;
    }
}

void print_hex(int color, int a)
{
	volatile char *video = (volatile char*)0xB8000;
	int t = a;
	char h[16] = {'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};
	char *r = "        ";
	int i = 0;
	while(t != 0)
	{
		i++;
		*r++ = h[t&0xF];
		t >>= 4;
	}
	*r--;
	for(; i >= 0; i--)
	{
		*video++ = *r--;
		*video++ = color;
	}
}

void k_main()
{
	idt_install();
	char* string = "Kernel boot started\0";
	mbp;
	print_hex(_COLOR(_red,_black),&(*string));
}
