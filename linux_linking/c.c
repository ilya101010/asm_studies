void eval(char* state)
{
	for(int i = 0; i<10; i++)
		state[i] = ~state[i];
}