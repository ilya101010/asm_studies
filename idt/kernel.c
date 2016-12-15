#include <system.h>

void k_main()
{
	idt_install();
	while(1)
	{
		fill_rect(10,10,50,50,10);
		fill_rect(10,10,50,50,20);
	}
}