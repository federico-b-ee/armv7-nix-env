.global _irq_handler
.section .text._irq_handler

# Following:
# - https://developer.arm.com/documentation/den0013/d/Interrupt-Handling/External-interrupt-requests/Simplistic-interrupt-handling
# - https://developer.arm.com/documentation/den0013/d/Exception-Handling/Exception-priorities/The-return-instruction
_irq_handler:
    push {r0-r3, ip, lr}
    # bl clear_irq
    # bl c_irq_handler
    pop {r0-r3, ip, lr}
    subs pc, lr, #4
