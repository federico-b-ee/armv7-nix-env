.global _reset_handler
.extern _start
.section .text._reset_handler
_reset_handler:
    b _start
