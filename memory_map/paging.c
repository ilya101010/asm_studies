extern void cprint(char* src, int y, int color);

void demo()
{
	static char* string = "Hello World";
	for(int i = 0; i<10; i++)
	{
		cprint(string, i, 0x0a);
	}
}