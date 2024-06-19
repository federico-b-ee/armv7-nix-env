.global _irq_handler
.section .text._irq_handler

# Following:
# - https://developer.arm.com/documentation/den0013/d/Interrupt-Handling/External-interrupt-requests/Simplistic-interrupt-handling
# - https://developer.arm.com/documentation/den0013/d/Exception-Handling/Exception-priorities/The-return-instruction
_irq_handler:
    sub lr, lr, #4
    stmfd sp!, {r0-r12, lr}
    mov r7, sp
    mrs r8, spsr
    push {r7, r8}

    mov r0, sp
    bl c_irq_handler
    mov r5, r0

    ldr r0, =msg
    ldr r10, =rs_putstr
    blx r10
    // Get the output of c_irq_handler
    mov r0, r5
    ldr r10, =rs_putnumber
    blx r10

    mov r0, #'\n'
    ldr r10, =rs_putchar
    blx r10

    pop {r7, r8}
    mov sp, r7
    msr spsr, r8
    ldmfd sp!, {r0-r12, pc}^
    subs pc, lr, #4

.section .data
msg:
    .asciz "IRQ "
