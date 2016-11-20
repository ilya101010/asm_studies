extern void bputs(char *state, int count);
extern void shift(char *state, int count);

void eval(char* state)
{
	char test[10] = {0,0xf0,0,0,0,0,0,0,0,0xff};
	for(int i = 0; i<50; i++)
	{
		bputs(&test, 10);
		shift(&test, 10);
	}
}