#!/bin/bash
echo ">>> rm"
rm b.o -f
rm kernel.o -f
rm boot.o -f
rm boot.bin -f
rm boot.flp -f
echo ">>> fasm"
fasm boot.asm boot.o
fasm b.asm b.o
echo ">>> gcc"
gcc -m32 -o0 -c kernel.c -o kernel.o -ffreestanding -nostdlib -lgcc -Iinclude
gcc -m32 -o0 -c idt.c -o idt.o -ffreestanding -nostdlib -lgcc -Iinclude
gcc -m32 -o0 -c system.c -o system.o -ffreestanding -nostdlib -lgcc -Iinclude
echo ">>> linker"
ld -T linker.ld -melf_i386 boot.o kernel.o b.o idt.o system.o
