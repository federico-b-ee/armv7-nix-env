.extern sum

.global _start
.section .text
_start: 
    ldr sp, =__sp
    mov r0, #37
    mov r1, #3
    bl sum
    b .
