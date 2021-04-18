@ -----------------------------------------------------------------------------
Wortbirne Flag_visible, "init-crc" @ ( -- )
@ -----------------------------------------------------------------------------
init_crc:
    @ Enable the CRC32 peripheral
    ldr  r0, =RCC_AHB4ENR
    ldr  r1, [r0]
    eor  r1, #RCC_AHB4ENR_CRCEN
    str  r1, [r0]

    b    reset_crc

@ -----------------------------------------------------------------------------
Wortbirne Flag_visible, "reset-crc" @ ( -- )
@ -----------------------------------------------------------------------------
reset_crc:
    @ Start a new CRC calculation
    ldr  r0, =CRC_BASE
    movs r1, #CRC_CR_RESET
    str  r1, [r0, #(CRC_CR - CRC_BASE)]

    bx   lr


@ -----------------------------------------------------------------------------
Wortbirne Flag_visible, ">crc" @ ( base length -- )
@ -----------------------------------------------------------------------------
to_crc:
    @ Length must be a multiple of four!!!

    @ Load CRC base address into r0
    ldr   r0, =CRC_BASE

    @ Pop base address into r1
    ldmia psp!, {r1}

    @ Did the length underflow?
1:  subs  r6, #4
    blo   2f

    @ Checksum the current byte and advance
    ldmia r1!, {r2}
    str   r2, [r0, #(CRC_DR - CRC_BASE)]
    b     1b
    
    @ Drop the length
2:  ldmia psp!, {r6}
    bx    lr

@ -----------------------------------------------------------------------------
Wortbirne Flag_visible, "crc@" @ ( -- crc )
@ -----------------------------------------------------------------------------
crc_at:
    @ Fetch the calculated checksum
    ldr   r0, =CRC_BASE
    stmdb psp!, {r6}
    ldr   r6, [r0, #(CRC_DR - CRC_BASE)]
    bx    lr

.ltorg
