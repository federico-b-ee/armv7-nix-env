.global _start
.extern c_gic_init
.extern rs_putchar
.extern rs_putstr
.extern rs_UART0_init
.extern rs_putnumber

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
    ldr r0, =init_msg
    ldr r10, =rs_putstr
    blx r10

    mov r5, #0
_idle:
    //wfi
    ldr r0, =idle_msg
    ldr r10, =rs_putstr
    blx r10

    mov r0, r5
    ldr r10, =rs_putnumber
    blx r10

    mov r0, #'\n'
    ldr r10, =rs_putchar
    blx r10

    // Max value 0 to (2^24)-1 (a 24-bit value) in an ARM instruction
    svc #0x37
    add r5, r5, #1
    b _idle

.section .data
init_msg:
    .asciz "ARMv7 init, using UART0:\n"

idle_msg:
    .asciz "Idle "
