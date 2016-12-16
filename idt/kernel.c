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
}