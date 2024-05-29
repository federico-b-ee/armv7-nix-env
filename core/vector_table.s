.extern _reset_handler
.extern _undefined_handler
.extern _swi_handler
.extern _prefetch_handler
.extern _abort_handler
//      _reserved
.extern _irq_handler

.global _vector_table
.global _vector_table_end

.section .vector_table, "ax"
_vector_table:
    ldr pc, reset_handler
    ldr pc, undefined_handler
    ldr pc, swi_handler
    ldr pc, prefetch_handler
    ldr pc, abort_handler
    ldr pc, reset_handler // reserved
    ldr pc, irq_handler
_vector_table_end:

reset_handler:         .word _reset_handler
undefined_handler:     .word _undefined_handler
swi_handler:           .word _swi_handler
prefetch_handler:      .word _prefetch_handler
reserved:              .word _reset_handler
abort_handler:         .word _abort_handler
irq_handler:           .word _irq_handler
