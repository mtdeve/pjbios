;extern firmware_main

global init

section .text.init
bits 16
init:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
 
    o32 lgdt [cs:gdt_descriptor]

    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp 0x08:protected_mode_entry

bits 32
protected_mode_entry:

    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov esp, 0x90000

    ; call firmware_main

.hang:
    hlt
    jmp .hang

align 8
gdt_start:
    dq 0
    dq 0xFF409AFF0000FFFF
    dq 0x00CF92000000FFFF
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd 0xFFFF0000 + gdt_start

section .reset_vector
bits 16
    jmp init