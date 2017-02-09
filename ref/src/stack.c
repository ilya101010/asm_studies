#include <stdint.h>
#include <stack.h>

static uint32_t stack(stackop operation, uint32_t arg)
{
	static uint32_t list[20] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
	static unsigned char i = 0;
	uint32_t* tmp;
	switch(operation)
	{
		case PUSH:
			if(i == 20) return 0;
			list[i] = arg;
			i++;
			return arg;
		case POP:
			if(i == 0) return list[0];
			i--;
			tmp = list[i];
			list[i] = 0;
			return tmp;
		case GET:
			return list[(int)arg];
		case SET:
			list[i] = arg;
		case SIZE:
			return i;
		default:
			return 0;
	}
	return 0;
}

uint32_t stack_push(uint32_t elem)
{
	return stack(PUSH,elem);
}

uint32_t stack_pop()
{
	return stack(POP,0);
}

uint32_t stack_get(uint32_t index)
{
	return stack(GET,index);
}

uint32_t stack_set(uint32_t elem)
{
	return stack(SET,elem);
}

uint32_t stack_size()
{
	return stack(SIZE,0);
}