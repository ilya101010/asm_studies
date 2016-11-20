#!/bin/bash
fasm boot.asm boot.bin
dd conv=notrunc bs=512 count=1 if=boot.bin of=boot.flp
qemu-system-x86_64 -fda boot.flp -enable-kvm -cpu host -s
