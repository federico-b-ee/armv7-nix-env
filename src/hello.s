.text
.global _start

_start: 
    mov r0, #37
    mov r1, #10
    add r3, r0, r1 
    b _start
