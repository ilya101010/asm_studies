extern void bputs(char *state, int count);
extern void shift(char *state, int count);

void eval(char* state)
{
	char test[12] = {0,0xf0,0,0,0,0,0,0,0,0xff,0,0};
	for(int i = 0; i<50; i++)
	{
		bputs(&test, 12);
		shift(&test, 12);
	}
}