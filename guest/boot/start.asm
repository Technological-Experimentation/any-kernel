bits 64

extern guest_main
global _start

section .text

_start:
    mov rdi, rsp
    call guest_main
    jmp $