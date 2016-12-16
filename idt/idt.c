// source: Bran's kernel tutorial

#include "system.h"

#define sel_code 0x4

/* Defines an IDT entry */
struct idt_entry
{
	unsigned short base_lo; // offset bits 0..15
	unsigned short sel; // segment selector
	unsigned char always0; // set to 0
	unsigned char flags;
	unsigned short base_hi; // offset bits 16..31
} __attribute__((packed));

struct idt_ptr
{
	unsigned short limit;
	unsigned int base;
} __attribute__((packed));

// 0 => unhandled
struct idt_entry idt[256];
struct idt_ptr idtp;

// boot.asm; does lidt
extern void idt_load(struct idt_ptr *p);

void idt_set_gate(unsigned char num, unsigned long base, unsigned short sel, unsigned char flags)
{
	idt[num].base_lo = (base & 0xFFFF);
	idt[num].base_hi = (base >> 16) & 0xFFFF;
	idt[num].sel = sel;
	idt[num].always0 = 0;
	idt[num].flags = flags;
}

/* Installs the IDT */
void idt_install()
{
	/* Sets the special IDT pointer up, just like in 'gdt.c' */
	idtp.limit = (sizeof (struct idt_entry) * 256) - 1;
	idtp.base = &idt;

	/* Clear out the entire IDT, initializing it to zeros */
	memset(&idt, 0, sizeof(struct idt_entry) * 256);

	/* Add any new ISRs to the IDT here using idt_set_gate */

	/* Points the processor's internal register to the new IDT */
	idt_load(&idtp);
}

// TODO: http://www.osdever.net/bkerndev/Docs/isrs.htm