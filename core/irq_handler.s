.global _irq_handler

.extern c_puts
.extern c_putchar
.extern c_puts_hex

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

    pop {r7, r8}
    mov sp, r7
    msr spsr, r8
    ldmfd sp!, {r0-r12, pc}^
    subs pc, lr, #4

.section .data
msg:
    .asciz "IRQ "
