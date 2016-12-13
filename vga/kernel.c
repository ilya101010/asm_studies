#define DEBUG
#ifdef DEBUG
	#define mbp asm("xchgw %bx, %bx")
#endif

void k_main()
{

	volatile char *video = (volatile char*)(0xA0000);
	for(int y = 0; y<200; y++)
	{
		for(int x = 0; x<320; x++)
		{
			mbp;
			*video++=(x % 256);
		}
	}
}

void write_string(int colour, char *string, int y)
{
	volatile char *video = (volatile char*)(0xA0000+160*y);
	while(*string != 0)
	{
		*video++ = *string++;
		*video++ = colour;
	}
}