extern void print(char* src, int y, int color);
extern void hex_f(int n, char *s);

void demo()
{
	static char* string = "";
	for(int i = 0; i<25; i++)
	{
		hex_f(i,string);
		print(string, i, 0x0a);
	}
}