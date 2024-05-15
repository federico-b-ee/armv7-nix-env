OUTPUT_FORMAT("elf32-littlearm")
OUTPUT_ARCH(arm)
ENTRY(_vector_table)

_PUBLIC_RAM_INIT = 0x70010000;
_PUBLIC_STACK_INIT = 0x70020000;

MEMORY {
    PUBLIC_RAM : ORIGIN = _PUBLIC_RAM_INIT, LENGTH = 4K     /* 7001_0000 .. 7001_0FFF */
    PUBLIC_STACK : ORIGIN = _PUBLIC_STACK_INIT, LENGTH = 4K /* 7002_0000 .. 7002_0FFF */
}

/* It starts from the bottom and grows upwards */
__sp = ORIGIN(PUBLIC_STACK) + LENGTH(PUBLIC_STACK);
/* __length_vector_table = SIZEOF(.vector_table) */

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
}
