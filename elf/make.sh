#!/bin/bash
echo ">>> fasm"
fasm boot.asm boot.o
fasm kernel.asm kernel.bin
echo ">>> linker"
ld -T linker.ld -melf_i386 boot.o kernel.o
dd if=kernel.bin of=final bs=1G oflag=append conv=notrunc