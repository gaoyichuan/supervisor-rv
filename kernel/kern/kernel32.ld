ENTRY(START)
OUTPUT(kernel.elf)
OUTPUT_ARCH("riscv:rv32")
OUTPUT_FORMAT("elf32-littleriscv")

PROVIDE(KERNEL_STACK_INIT = 0x80800000);
SECTIONS
{
    /* Read-only memory */
    /* kernel code: 0x80000000 - 0x80007FFF */
    /* utest: 0x80008000 - 0x8000BFFF */
    /* kernel rodata: 0x8000C000 - 0x8000FFFF */

    /* Read-Write memory */
    /* user rw data: 0x40000000 - 0x400EFFFF */
    /* kernel rw data: 0x400F0000 - 0x400FFFFF */
    . = 0x400F0000;
    .bss : {
        _sbss = .;         /* define a global symbol at bss start */
        *(.bss.uregs)
        *(.bss)
        . = ALIGN(4);
        _ebss = .;         /* define a global symbol at bss end */
    }
    
    . = 0x8000C000;
    .rodata : {
        *(.rodata)
    }
    PROVIDE(uregs_sp = uregs + (2 - 1) * 4);
    PROVIDE(uregs_fp = uregs + (8 - 1) * 4);
    . = 0x80000000;
    .text : {
        KEEP (*(.text.init))
        *(.text)
        . = ALIGN(0x8000); /* "fixed" utest address */
        *(.text.utest)
    }
    . = ALIGN(32);
}