#include <tty.h>
#include <vga.h>

#define VGA_WIDTH 80
#define VGA_HEIGHT 25
#define VGA_BUFFER 0xB8000

static size_t tty_row;
static size_t tty_color;

extern void write(char* src, int x, int y, uint8_t color);
extern void print(char* src, int y, uint8_t color);
extern void fill_zeros(void* dst, size_t size);

void tty_init()
{
	tty_row = 0;
	tty_color = vga_entry_color(VC_LIGHT_GREY,VC_BLACK);
}

void tty_setcolor(uint8_t color)
{
	tty_color = color;
}

void tty_print(char* src)
{
	fill_zeros(VGA_BUFFER+VGA_WIDTH*2*tty_row,VGA_WIDTH);
	print(src, tty_row, tty_color);
	tty_row = (tty_row+1)%VGA_HEIGHT;
}