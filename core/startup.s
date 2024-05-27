.global _start

.section .text._start
_start: 
    mov r0, #0x20
    mov r1, #0x10
    add r2, r1, r0 
    b .
