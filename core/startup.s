.global _start
.extern c_gic_init
.extern c_timer_init
.extern c_puts
.extern c_putsln
.extern c_predefined_tasks_init
.extern c_sched_run

.section .text._start
_start: 
    // Init GIC
    ldr r10, =c_gic_init
    blx r10

    // Init TIMER
    ldr r10, =c_timer_init
    blx r10

    // The IRQ is enabled on low, thats why bic instr is used
    //mrs r0, cpsr
    //bic r0, r0, 0x80
    //msr cpsr_c, r0

    // This instr replaces the 3instrs above
    cpsie   i          // Enable interrupts


    // Seems that the initialization is not necessary
    // Init UART
    //ldr r10, =UART0_init
    //mov lr, pc
    //bx r10
    ldr r0, =init_msg
    ldr r10, =c_puts
    blx r10

    // Add tasks
    ldr r10, =c_predefined_tasks_init
    blx r10

    // Run scheduler
    ldr r10, =c_sched_run
    blx r10

// Should never reach here
_idle:
    wfi
    b _idle

.section .data
init_msg:
    .asciz "ARMv7 init, using UART0:\n"
