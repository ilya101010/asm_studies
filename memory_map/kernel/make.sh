#!/bin/bash
echo ">> kernel > main.asm"
fasm main.asm kernel.o
echo ">> kernel > linking"
ld -T linker.ld -melf_i386 kernel.o