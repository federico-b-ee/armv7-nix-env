.global _start
.section .text
_start: 
    ldr r2, str1
    mrc p15, 0, r1, c0, c0, 0 // move to reg from coprocessor
    b .

str1: .word 0xAA55AA55
