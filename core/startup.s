.global _start
.global __sp

.section .text._start
_start: 
    // store _vector_table at address 0x0000_0000
    ldr     r0, =_vector_table
    mov     r1, #0x0
    ldmia   r0!, {r2-r8}
    stmia   r1!, {r2-r8}

    ldr sp, =__sp
    mov r0, #0x20
    mov r1, #0x10
    add r2, r1, r0 
    b .
