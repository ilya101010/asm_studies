#define mbp asm("xchgw %bx, %bx")

#define black 0
#define blue 1
#define green 2
#define cyan 3
#define red 4
#define magenta 5
#define brown 6
#define lgray 7
#define dgray 8
#define lblue 9
#define lgreen 0xA
#define lcyan 0xB
#define lred 0xC
#define lmagenta 0xD
#define yellow 0xE
#define white 0xF
#define COLOR(fg, bg) fg & bg << 4 

void write_string(int i, int colour, char *string);

void WriteCharacter(unsigned char c, unsigned char forecolour, unsigned char backcolour, int x, int y)
{
     char attrib = (backcolour << 4) | (forecolour & 0x0F);
     volatile char * where;
     where = (volatile char *)0xB8000 + (y * 80 + x) ;
     *where = c | (attrib << 8);
}

void k_main()
{
	char* string = "hello world";
	mbp;
	WriteCharacter('a',red,white,0,0);
	a:
	goto a;
}

void write_string(int i, int colour, char *string)
{
	volatile char *video = (volatile char*)(0xB8000+i*2);
	while(*string != 0)
	{
		*video++=*string;
		*video++=colour;
	}
}