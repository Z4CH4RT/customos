BITS 32

section .multiboot
align 8
mb2_header:
    dd 0xe85250d6
    dd 0
    dd header_end - mb2_header
    dd -(0xe85250d6 + 0 + (header_end - mb2_header))

    dw 0
    dw 0
    dd 8
header_end:

section .text
global _start
extern kernel_main

_start:
    cli
    call kernel_main

hang:
    hlt
    jmp hang
