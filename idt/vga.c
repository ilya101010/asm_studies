#define vga_height 200
#define vga_width 320

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

void printc(int X, int Y, char color)
{
	char A[] = {
		0b00000000,
		0b00011000,
		0b00111100,
		0b01100110,
		0b01111110,
		0b01100110,
		0b01100110,
		0b00000000,
	};
	volatile char *video = (volatile char*)(0xA0000+vga_width*Y+X);
	for(int y = 0; y<8; y++)
	{
		for (int x = 0; x < 8; x++)
		{
			video++;
			if((A[y] >> x) & 1)
				*video = color;
		}
		video += vga_width-8;
	}
}