#!/bin/bash
fasm cellular.asm cellular.bin
dd conv=notrunc bs=512 count=1 if=cellular.bin of=cell.flp
qemu-system-x86_64 -fda cell.flp -enable-kvm -cpu host -s
