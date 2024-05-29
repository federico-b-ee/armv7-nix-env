.global _start

.section .text._start
_start: 
    // Init GIC
    ldr r10, =__gic_init
    mov lr, pc
    bx r10
    // The IRQ is enabled on low, thats why bic instr is used
    //mrs r0, cpsr
    //bic r0, r0, 0x80
    //msr cpsr_c, r0

    // This instr replaces the 3instrs above
    cpsie   i          // Enable interrupts

    swi #90

    mov r0, #0x20
    mov r1, #0x10
    add r2, r1, r0 
_idle:
    wfi
    b _idle
