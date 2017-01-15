#!/bin/bash
nasm -w+all -f elf32 -o test.o test.asm
ld test.o -o test.out -melf_i386
