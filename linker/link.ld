ENTRY(init)

MEMORY
{
    rom (rwx) : ORIGIN = 0x00000000, LENGTH = 64K
}

SECTIONS
{
    . = ORIGIN(rom);

    .text : {
        *(.text.init)
        *(.text)
    } > rom

    .rodata : { *(.rodata*) } > rom
    .data   : { *(.data*) }   > rom
    .bss    : { *(.bss*) }    > rom

    .reset_vector 0xFFF0 : {
        *(.reset_vector)
    } > rom

    /DISCARD/ : { *(.comment) *(.eh_frame) *(.note.*) }
}