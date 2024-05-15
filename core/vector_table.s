.extern _reset_handler
.extern _undefined_handler
.extern _swi_handler
.extern _prefetch_handler
.extern _abort_handler
//.extern _reserved
.extern _irq_handler

.global _vector_table
.section .vector_table, "ax"
_vector_table:
    ldr pc, _reset_handler
    ldr pc, _undefined_handler
    ldr pc, _swi_handler
    ldr pc, _prefetch_handler
    ldr pc, _abort_handler
    ldr pc, _reset_handler
    ldr pc, _irq_handler

_reset_handler:         .word _reset_handler
_undefined_handler:     .word _undefined_handler
_swi_handler:           .word _swi_handler
_prefetch_handler:      .word _prefetch_handler
_abort_handler:         .word _abort_handler
_irq_handler:           .word _irq_handler
