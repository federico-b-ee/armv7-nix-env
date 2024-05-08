.extern suma

.global _start
.section .text
_start: 
    ldr sp, =__sp
    // vector_table
    b .
