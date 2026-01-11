BITS 32
GLOBAL long_mode_start
EXTERN kernel_main

section .multiboot
align 8
mb2_header:
    dd 0xE85250D6
    dd 0
    dd header_end - mb2_header
    dd -(0xE85250D6 + 0 + (header_end - mb2_header))
    dw 0
    dw 0
    dd 8
header_end:


section .rodata
align 8
gdt64:
    dq 0x0000000000000000
    dq 0x00AF9A000000FFFF
    dq 0x00AF92000000FFFF
gdt64_desc:
    dw gdt64_desc - gdt64 - 1
    dq gdt64

section .bss
align 4096
pml4:   resq 512
pdpt:   resq 512
pd:     resq 512

align 16
stack_bottom:
    resb 32768
stack_top:

section .text

long_mode_start:
    cli

    lgdt [gdt64_desc]

    xor eax, eax
    mov edi, pml4
    mov ecx, 512*3
    rep stosd

    mov eax, pdpt
    or eax, 0x03
    mov [pml4], eax

    mov eax, pd
    or eax, 0x03
    mov [pdpt], eax

    mov eax, 0x83
    mov [pd], eax

    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax

    mov eax, pml4
    mov cr3, eax

    mov ecx, 0xC0000080
    rdmsr
    or eax, 1 << 8
    wrmsr

    mov eax, cr0
    or eax, 1 << 31
    mov cr0, eax

    jmp 0x08:long_mode_entry


[BITS 64]
long_mode_entry:
    mov rsp, stack_top              
    call kernel_main                
.halt:
    hlt
    jmp .halt
