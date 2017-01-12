#!/bin/bash
echo ">>> fasm"
fasm boot.asm boot.o
echo ">>> linking bootloader"
ld -T linker.ld -melf_i386 boot.o
wc -c final.img
# kernel elf
echo ">>> kernel elf"
(cd kernel && ./make.sh)
echo "appending kernel.o to final.img"
dd if=./kernel/kernel.bin of=final.img bs=1G oflag=append conv=notrunc