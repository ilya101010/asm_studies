#!/bin/bash
echo ">>> rm"
rm b.o -f
rm kernel.o -f
rm boot.o -f
rm boot.bin -f
rm boot.flp -f
echo ">>> fasm"
fasm boot.asm boot.o
# fasm b.asm b.o
# fasm idt.asm idta.o
# fasm vga.asm vga_ca.o
# fasm idt.asm idta.o
echo ">>> gcc"
gcc -m32 -o0 -c kernel.c -o kernel.o -ffreestanding -nostdlib -lgcc -Iinclude
echo ">>> linker"
ld -T linker.ld -melf_i386 boot.o kernel.o