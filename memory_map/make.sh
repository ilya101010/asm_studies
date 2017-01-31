#!/bin/bash
echo ">>> fasm"
fasm boot.asm boot.o
fasm kernel_setup.asm kernel_setup.o
fasm procedures.asm procedures.o
fasm paging.asm paging.o
gcc -m32 -o0 -c paging.c -o paging.c.o -ffreestanding -nostdlib -lgcc
echo ">>> linking"
ld -T linker.ld -melf_i386
wc -c final.img