#define DEBUG
#ifdef DEBUG
	#define mbp asm("xchgw %bx, %bx")
#else
	#define mbp
#endif

#include <system.h>

extern char* ca;
void k_main()
{
	char A[] = {
		0b00000000,
		0b00000000,
		0b00111000,
		0b01000100,
		0b01111100,
		0b01000100,
		0b01000100,
		0b00000000,
	};
	idt_install();

	//int i = 0;
	for(int i = 0; i<100; i++)
	{
		printc(A,0,0,10);
	}
	/*while(1)
	{
		fill_rect(10,10,50,50,10);
		fill_rect(10,10,50,50,20);
	}*/
}