OUTPUT_FORMAT("elf32-littlearm")
OUTPUT_ARCH(arm)
ENTRY(_start)

_PUBLIC_RAM_INIT = 0x70010000;
_PUBLIC_STACK_INIT = 0x70020000;

MEMORY
{
    public_ram : org = _PUBLIC_RAM_INIT, len = 4K
    public_stack : org = _PUBLIC_STACK_INIT, len = 4K
}


SECTIONS
{
    . = _PUBLIC_RAM_INIT;
    .text : {
        *(.text*)
    } > public_ram

    .data : {
        *(.data*)
    } > public_ram

    .bss : {
        . = ALIGN(4);
        __bss_start__ = .;
        *(.bss*)
        __bss_end__ = .;
    } > public_ram
}
