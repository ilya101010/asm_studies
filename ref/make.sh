#!/bin/bash
echo ">>> init"
mkdir -p obj
rm obj/*
echo ">>> fasm"
fasm src/boot.asm obj/boot.o
fasm src/procedures.asm obj/procedures.o
fasm src/paging.asm obj/paging.o
echo ">>> gcc"
gcc -m32 -o0 -c src/kernel.c -o obj/kernel.o -Iinclude -ffreestanding -nostdlib -lgcc -w
gcc -m32 -o0 -c src/tty.c -o obj/tty.o -Iinclude -ffreestanding -nostdlib -lgcc -w
gcc -m32 -o0 -c src/stack.c -o obj/stack.o -Iinclude -ffreestanding -nostdlib -lgcc -w
gcc -m32 -o0 -c src/paging.c -o obj/paging.c.o -Iinclude -ffreestanding -nostdlib -lgcc -w
echo ">>> linking"
$(cp linker.ld obj; cd obj; ld -T linker.ld -melf_i386)
if [ -f obj/final.img ]; then
	mv obj/final.img .
fi
echo ">>> final.img size"
wc -c final.img