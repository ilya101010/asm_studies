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

//#include <system.h>

void k_main()
{
	mbp;
	volatile char *video = (volatile char*)0xB8000;
	*video++ = 'a';	*video++ = _COLOR(_black,_white);
	*video++ = 'a';	*video++ = _COLOR(_black,_white);
	*video++ = 'a';	*video++ = _COLOR(_black,_white);
	*video++ = 'a';	*video++ = _COLOR(_black,_white);
	*video++ = 'a';	*video++ = _COLOR(_black,_white);
}
