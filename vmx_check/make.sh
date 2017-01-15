#!/bin/bash
echo ">>> fasm"
fasm boot.asm boot.o
echo ">>> linking bootloader"
ld -T linker.ld -melf_i386 boot.o
# kernel elf
echo ">>> kernel elf"
nasm kernel.asm -o kernel.o -f elf32 -w+all
echo "appending kernel.o to final.img"
dd if=kernel.o of=final.img bs=1G oflag=append conv=notrunc
