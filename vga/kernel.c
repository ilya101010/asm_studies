//#define DEBUG
#ifdef DEBUG
	#define mbp asm("xchgw %bx, %bx")
#else
	#define mbp
#endif

void fill_rect(int x, int y, int w, int h, int color);

void k_main()
{
	for(int i = 0; i<32;i++)
		fill_rect(10*i,0,10,10,i);
}

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