# ----------------------------------------------------------------------------------------
# Writes "Hello, World" to the console using only system calls. Runs on 64-bit Linux only.
# To assemble and run:
#
#     gcc -c hello.s && ld hello.o && ./a.out
#
# or
#
#     gcc -nostdlib hello.s && ./a.out
# ----------------------------------------------------------------------------------------

        .global _start
        .data
message: .ascii  "Hello, world\n"
        .text
_start:
        # write(1, message, 13)
        mov     $1, %eax                # system call 1 is write
        mov     $1, %edi                # file handle 1 is stdout
        mov     $message, %esi          # address of string to output
        mov     $13, %edx               # number of bytes
        syscall                         # invoke operating system to do the write

        # exit(0)
        mov     $60, %eax               # system call 60 is exit
        xor     %edi, %edi              # we want return code 0
        syscall                         # invoke operating system to exit