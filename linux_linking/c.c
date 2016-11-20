extern void bputs(char *state, int count);
extern void shift(char *state);

void eval(char* state)
{
	char test[10] = {0xf0,0,0,0,0,0,0,0,0,0xff};
	for(int i = 0; i<20; i++)
	{
		bputs(&test, 10);
		shift(&test);
	}
}