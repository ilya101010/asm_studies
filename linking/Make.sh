#!/bin/bash
fasm boot.asm boot.bin
ld linker.ld -o os.bin
dd conv=notrunc bs=512 count=1 if=os.bin of=boot.flp
qemu-system-x86_64 -fda boot.flp -enable-kvm -cpu host -s
