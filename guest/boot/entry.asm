bits 64

extern guest_main
global _start

section .text

_start:
    ; call guest_main
    jmp $