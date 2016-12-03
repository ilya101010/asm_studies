#!/bin/bash
echo ">>> rm"
rm boot.o
rm boot.bin -f
rm boot.flp -f
echo ">>> fasm"
fasm boot.asm boot.o
echo ">>> linker"
ld -T linker.ld -melf_i386 boot.o
echo ">>> qemu"
# qemu-system-x86_64 -fda final -enable-kvm -cpu host -s
