#define rule 30

extern void bputs(char *state, int count);
extern void shift(char *state, int count);

void _main()
{
	char state[20] = {0};
	state[10] = 4;
	for(int i = 0; i<75; i++)
	{
		bputs(&state, 20);
		eval(&state, 20);
	}
}

void eval(char *state, int count)
{
	char news[129] = {0};
	char tmp = 0;
	for(int i = 0; i<8*count; i++)
	{
		shift(state, count);
		tmp = state[0] & 7; 
		news[0] |= ((rule >> tmp) & 1) << 2;
		shift(&news, count);
	}
	for(int i = 0; i<count; i++)
	{
		tmp = news[i];
		state[i] = tmp;
	}
}