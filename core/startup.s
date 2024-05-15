.global _start
.global __sp

.section .text._start
_start: 
    ldr sp, =__sp
    mov r0, #0x20
    mov r1, #0x10
    add r2, r1, r0 
    b .
