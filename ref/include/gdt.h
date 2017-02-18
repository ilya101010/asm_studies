#ifndef GDT_H
#define GDT_H

#define SEG(i) (i << 3)
#define TSS_SEG 3

void gdt_flush(int num);
void initGDTR();
void gdt_set_gate(int num, unsigned long base, unsigned long limit, unsigned char access, unsigned char gran);

#endif