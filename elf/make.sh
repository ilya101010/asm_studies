#!/bin/bash
echo ">>> fasm"
fasm boot.asm boot.o
echo ">>> linking bootloader"
ld -T linker.ld -melf_i386 boot.o
# kernel elf
echo ">>> kernel elf"
nasm kernel.asm -o kernel.o -f elf32 -w+all
ld kernel.o -o kernel.bin -melf_i386
echo "appending kernel.bin to final.img"
dd if=kernel.bin of=final.img bs=1G oflag=append conv=notrunc
