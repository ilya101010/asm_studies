#include <tss.h>
#include <gdt.h>
#include <stddef.h>
#include <debug.h>


#define MAIN_TSS 0
#define SS0 0x10
#define ESP0 0

static tss_entry TSS[2];

extern void fill_zeros(void* dst, size_t size);
extern void setTR(uint16_t segment);

void setup_tss()
{
	// GDT setup
	initGDTR();
	gdt_set_gate(TSS_SEG,&TSS[MAIN_TSS],sizeof(tss_entry), 0xE9, 0x40);
	gdt_flush(TSS_SEG+1);
	mbp;
	// Managing TSS
	fill_zeros(&TSS[MAIN_TSS],sizeof(tss_entry));
	TSS[MAIN_TSS].ss0 = SS0;
	TSS[MAIN_TSS].cs = 0x8;
	TSS[MAIN_TSS].es = 0x10;
	TSS[MAIN_TSS].fs = 0x10;
	TSS[MAIN_TSS].gs = 0x10;
	TSS[MAIN_TSS].iomap_base = 0;
	mbp;
	setTR(SEG(TSS_SEG));
}