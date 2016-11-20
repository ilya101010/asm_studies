fasm a.asm a.o
fasm b.asm b.o
gcc -m32 -c c.c -o c.o
ld -m elf_i386 -T linker.ld a.o b.o c.o
