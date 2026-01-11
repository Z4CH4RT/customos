BITS 32
GLOBAL _start
EXTERN long_mode_start

section .multiboot
align 8
mb2_header:
    dd 0xe85250d6
    dd 0
    dd header_end - mb2_header
    dd -(0xe85250d6 + (header_end - mb2_header))
    dw 0
    dw 0
    dd 8
header_end:

section .text
_start:
    cli
    call long_mode_start
.hang:
    hlt
    jmp .hang
