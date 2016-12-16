#define DEBUG
#ifdef DEBUG
	#define mbp asm("xchgw %bx, %bx")
#else
	#define mbp
#endif

#include <system.h>

void k_main()
{
	idt_install();
	for(int x = 0; x<320; x+=8)
		for(int y = 0; y<200; y+=8)
			printc(x,y,(x | y) % 256);
	/*while(1)
	{
		fill_rect(10,10,50,50,10);
		fill_rect(10,10,50,50,20);
	}*/
	int i = 0;
	mbp;
	i = 1/i;
}