OUTPUT_FORMAT("elf32-littlearm")
OUTPUT_ARCH(arm)
ENTRY(_vector_table)

_PUBLIC_RAM_INIT        = 0x70010000;
_STACK_INIT             = 0x70020000;

_SYS_STACK_SIZE         = 8K;
_ABT_STACK_SIZE         = 1K;
_SVC_STACK_SIZE         = 2K;
_IRQ_STACK_SIZE         = 1K;
_UND_STACK_SIZE         = 1K;

_TOTAL_STACK_SIZE       = _ABT_STACK_SIZE + _SVC_STACK_SIZE + _IRQ_STACK_SIZE + _UND_STACK_SIZE + _SYS_STACK_SIZE;

MEMORY {
    PUBLIC_RAM : ORIGIN = _PUBLIC_RAM_INIT, LENGTH = 4K     /* 7001_0000 .. 7001_0FFF */
    PUBLIC_STACK : ORIGIN = _STACK_INIT, LENGTH = _TOTAL_STACK_SIZE /* 7002_0000 .. 7002_33FF = 13K */
}

/* It starts from the bottom and grows upwards */
__sp = ORIGIN(PUBLIC_STACK) + LENGTH(PUBLIC_STACK);

SECTIONS {
    .text : {
        . = ALIGN(4);
        KEEP (*(.vector_table))
        *(.text*)
    } > PUBLIC_RAM

    .data : {
        *(.data*)
    } > PUBLIC_RAM

    .bss : {
        . = ALIGN(4);
        __bss_start__ = .;
        *(.bss*)
        __bss_end__ = .;
    } > PUBLIC_RAM

    /* 16-byte alignment is sometimes used to ensure compatibility
    with SIMD (Single Instruction, Multiple Data) instructions,
    such as those found in ARM NEON or Intel SSE/AVX,
    which often require 16-byte alignment for their data.*/
    .stack (NOLOAD) : {
        . = ALIGN(16);
        _stack_end = .;

        _sys_stack_end = .;
        . += _SYS_STACK_SIZE;
        . = ALIGN(16);
        __sys_sp = .;

        _irq_stack_end = .;
        . += _IRQ_STACK_SIZE;
        . = ALIGN(16);
        __irq_sp = .;

        _svc_stack_end = .;
        . += _SVC_STACK_SIZE;
        . = ALIGN(16);
        __svc_sp = .;

        _abt_stack_end = .;
        . += _ABT_STACK_SIZE;
        . = ALIGN(16);
        __abt_sp = .;

        _und_stack_end = .;
        . += _UND_STACK_SIZE;
        . = ALIGN(16);
        __und_sp = .;

        __stack_start = .;
    } > PUBLIC_STACK
}
