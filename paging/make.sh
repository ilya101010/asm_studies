#!/bin/bash
echo ">>> fasm"
fasm boot.asm boot.o
fasm kernel_setup.asm kernel_setup.o
fasm procedures.asm procedures.o
fasm paging.asm paging.o
echo ">>> linking bootloader"
ld -T linker.ld -melf_i386 boot.o procedures.o
wc -c final.img