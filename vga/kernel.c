//#define DEBUG
#ifdef DEBUG
	#define mbp asm("xchgw %bx, %bx")
#else
	#define mbp
#endif

#define rule 30

#define s_height 200
#define s_width 300

extern void shift(char *state, int count);

void put_line(char* state, int count, int color_0, int color_1, int y);
void eval(char *state, int count);

void k_main()
{
	char state[40] = {0};
	state[20]=1;
	for(int i = 0; i<200; i++)
	{
		mbp;
		put_line(state,40,i,0,i);
		eval(state,40);
	}
}

void put_line(char* state, int count, int color_0, int color_1, int y)
{
	volatile char *video = (volatile char*)(0xA0000+320*y);
	for(int i = 0; i<count; i++)
	{
		for(int j = 0; j<8; j++)
		{
			*video++ = ((state[i] >> j) & 1) ? color_1 : color_0;
		}
	}
}

void eval(char *state, int count)
{
	char news[40] = {0};
	char tmp = 0;
	for(int i = 0; i<8*count; i++)
	{
		shift(state, count);
		tmp = state[0] & 7; 
		news[0] |= ((rule >> tmp) & 1) << 2;
		shift(news, count);
	}
	for(int i = 0; i<count; i++)
	{
		tmp = news[i];
		state[i] = tmp;
	}
}