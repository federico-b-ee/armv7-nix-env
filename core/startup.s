.global _start
.extern c_gic_init
.extern rs_putchar
.extern rs_putstr
.extern rs_UART0_init

.section .text._start
_start: 
    // Init GIC
    ldr r10, =c_gic_init
    blx r10
    // The IRQ is enabled on low, thats why bic instr is used
    //mrs r0, cpsr
    //bic r0, r0, 0x80
    //msr cpsr_c, r0

    // This instr replaces the 3instrs above
    cpsie   i          // Enable interrupts


    // Seems that the initialization is not necessary
    // Init UART
    //ldr r10, =rs_UART0_init
    //mov lr, pc
    //bx r10
    ldr r0, =msg
    ldr r10, =rs_putstr
    blx r10

    mov r0, #64
_put:
    add r0, r0, #0x1
    ldr r10, =rs_putchar
    blx r10
    b _put

    swi #90


_idle:
    wfi
    b _idle

.section .data
msg:
    .asciz "UART0:\n"
