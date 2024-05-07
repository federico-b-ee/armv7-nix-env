.extern suma

.global _start
.section .text
_start: 
    ldr sp, =__sp
    mov r4, #0x20
    mov r5, #0x10
    add r6, r5, r4
    mov r0, #0x20
    mov r1, #0x10
    bl suma
    b .
