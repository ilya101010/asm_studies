//#define DEBUG
#ifdef DEBUG
	#define mbp asm("xchgw %bx, %bx")
#else
	#define mbp
#endif

#define s_height 200
#define s_width 300

void fill_rect(int X, int Y, int w, int h, int color)
{
	volatile char *video = (volatile char*)(0xA0000);
	for(int y = Y; y<Y+h; y++)
		for(int x = X; x<X+w; x++)
		{
			video = (volatile char*)(0xA0000+320*y+x);
			*video = color;
		}
}

void k_main()
{
	idt_install();
	while(1)
	{
		fill_rect(10,10,50,50,10);
		fill_rect(10,10,50,50,20);
	}
}