Flash, ADC, UART, RAM, and section placement
ENTRY(Reset_Handler)
MEMORY
{
FLASH (rx) : ORIGIN = 0x00000000, LENGTH = 256K
ADC (rw) : ORIGIN = 0x20000000, LENGTH = 0x100
UART (rw) : ORIGIN = 0x20000100, LENGTH = 0x100
RAM (rwx) : ORIGIN = 0x20000200, LENGTH = 0x3E00
}
_estack = 0x20004000;
SECTIONS
{
.isr_vector :
{
. = ALIGN(4);
KEEP(*(.isr_vector))
. = ALIGN(4);
} > FLASH
.text :
{
. = ALIGN(4);
*(.text*)
*(.rodata*)
. = ALIGN(4);
_etext = .;
} > FLASH
.data : AT(_etext)
{
. = ALIGN(4);
_sdata = .;
*(.data*)
. = ALIGN(4);
_edata = .;
} > RAM
_sidata = LOADADDR(.data);
.sensor_buffer (NOLOAD) :
{
KEEP(*(.sensor_buffer))
} > ADC
.uart_buffer (NOLOAD) :
{
KEEP(*(.uart_buffer))
} > UART
.bss (NOLOAD) :
{
. = ALIGN(4);
_sbss = .;
*(.bss*)
*(COMMON)
. = ALIGN(4);
_ebss = .;
} > RAM
/DISCARD/ :
{
*(.comment*)
*(.ARM.attributes*)
}
}
ASSERT(_ebss <= _estack, "RAM overflow: static sections exceed RAM")
