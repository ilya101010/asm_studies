format ELF
use32

extrn fault_handler
;extrn _irq_handler


public isr0
public isr1
public isr2
public isr3
public isr4
public isr5
public isr6
public isr7
public isr8
public isr9
public isr10
public isr11
public isr12
public isr13
public isr14
public isr15
public isr16
public isr17
public isr18
public isr19
public isr20
public isr21
public isr22
public isr23
public isr24
public isr25
public isr26
public isr27
public isr28
public isr29
public isr30
public isr31

;  0: Divide By Zero Exception
isr0:
    cli
    push 0
    push 0
    jmp isr_common_stub

;  1: Debug Exception
isr1:
    cli
    push 0
    push 1
    jmp isr_common_stub

;  2: Non Maskable Interrupt Exception
isr2:
    cli
    push 0
    push 2
    jmp isr_common_stub

;  3: Int 3 Exception
isr3:
    cli
    push 0
    push 3
    jmp isr_common_stub

;  4: INTO Exception
isr4:
    cli
    push 0
    push 4
    jmp isr_common_stub

;  5: Out of Bounds Exception
isr5:
    cli
    push 0
    push 5
    jmp isr_common_stub

;  6: Invalid Opcode Exception
isr6:
    cli
    push 0
    push 6
    jmp isr_common_stub

;  7: Coprocessor Not Available Exception
isr7:
    cli
    push 0
    push 7
    jmp isr_common_stub

;  8: Double Fault Exception (With Error Code!)
isr8:
    cli
    push 8
    jmp isr_common_stub

;  9: Coprocessor Segment Overrun Exception
isr9:
    cli
    push 0
    push 9
    jmp isr_common_stub

; 10: Bad TSS Exception (With Error Code!)
isr10:
    cli
    push 10
    jmp isr_common_stub

; 11: Segment Not Present Exception (With Error Code!)
isr11:
    cli
    push 11
    jmp isr_common_stub

; 12: Stack Fault Exception (With Error Code!)
isr12:
    cli
    push 12
    jmp isr_common_stub

; 13: General Protection Fault Exception (With Error Code!)
isr13:
    cli
    push 13
    jmp isr_common_stub

; 14: Page Fault Exception (With Error Code!)
isr14:
    cli
    push 14
    jmp isr_common_stub

; 15: Reserved Exception
isr15:
    cli
    push 0
    push 15
    jmp isr_common_stub

; 16: Floating Point Exception
isr16:
    cli
    push 0
    push 16
    jmp isr_common_stub

; 17: Alignment Check Exception
isr17:
    cli
    push 0
    push 17
    jmp isr_common_stub

; 18: Machine Check Exception
isr18:
    cli
    push 0
    push 18
    jmp isr_common_stub

; 19: Reserved
isr19:
    cli
    push 0
    push 19
    jmp isr_common_stub

; 20: Reserved
isr20:
    cli
    push 0
    push 20
    jmp isr_common_stub

; 21: Reserved
isr21:
    cli
    push 0
    push 21
    jmp isr_common_stub

; 22: Reserved
isr22:
    cli
    push 0
    push 22
    jmp isr_common_stub

; 23: Reserved
isr23:
    cli
    push 0
    push 23
    jmp isr_common_stub

; 24: Reserved
isr24:
    cli
    push 0
    push 24
    jmp isr_common_stub

; 25: Reserved
isr25:
    cli
    push 0
    push 25
    jmp isr_common_stub

; 26: Reserved
isr26:
    cli
    push 0
    push 26
    jmp isr_common_stub

; 27: Reserved
isr27:
    cli
    push 0
    push 27
    jmp isr_common_stub

; 28: Reserved
isr28:
    cli
    push 0
    push 28
    jmp isr_common_stub

; 29: Reserved
isr29:
    cli
    push 0
    push 29
    jmp isr_common_stub

; 30: Reserved
isr30:
    cli
    push 0
    push 30
    jmp isr_common_stub

; 31: Reserved
isr31:
    cli
    push 0
    push 31
    jmp isr_common_stub

; This is our common ISR stub. It saves the processor state, sets
; up for kernel mode segments, calls the C-level fault handler,
; and finally restores the stack frame.
isr_common_stub:
    pusha
    push ds
    push es
    push fs
    push gs
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov eax, esp
    call fault_handler
    pop eax
    pop gs
    pop fs
    pop es
    pop ds
    popa
    add esp, 8
    iret

public _irq0
public _irq1
public _irq2
public _irq3
public _irq4
public _irq5
public _irq6
public _irq7
public _irq8
public _irq9
public _irq10
public _irq11
public _irq12
public _irq13
public _irq14
public _irq15

; 32: IRQ0
_irq0:
    cli
    push 0
    push 32
    jmp irq_common_stub

; 33: IRQ1
_irq1:
    cli
    push 0
    push 33
    jmp irq_common_stub

; 34: IRQ2
_irq2:
    cli
    push 0
    push 34
    jmp irq_common_stub

; 35: IRQ3
_irq3:
    cli
    push 0
    push 35
    jmp irq_common_stub

; 36: IRQ4
_irq4:
    cli
    push 0
    push 36
    jmp irq_common_stub

; 37: IRQ5
_irq5:
    cli
    push 0
    push 37
    jmp irq_common_stub

; 38: IRQ6
_irq6:
    cli
    push 0
    push 38
    jmp irq_common_stub

; 39: IRQ7
_irq7:
    cli
    push 0
    push 39
    jmp irq_common_stub

; 40: IRQ8
_irq8:
    cli
    push 0
    push 40
    jmp irq_common_stub

; 41: IRQ9
_irq9:
    cli
    push 0
    push 41
    jmp irq_common_stub

; 42: IRQ10
_irq10:
    cli
    push 0
    push 42
    jmp irq_common_stub

; 43: IRQ11
_irq11:
    cli
    push 0
    push 43
    jmp irq_common_stub

; 44: IRQ12
_irq12:
    cli
    push 0
    push 44
    jmp irq_common_stub

; 45: IRQ13
_irq13:
    cli
    push 0
    push 45
    jmp irq_common_stub

; 46: IRQ14
_irq14:
    cli
    push 0
    push 46
    jmp irq_common_stub

; 47: IRQ15
_irq15:
    cli
    push 0
    push 47
    jmp irq_common_stub


irq_common_stub:
    pusha
    push ds
    push es
    push fs
    push gs

    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov eax, esp

    push eax
    ;mov eax, _irq_handler
    ;call eax
    pop eax

    pop gs
    pop fs
    pop es
    pop ds
    popa
    add esp, 8
    iret