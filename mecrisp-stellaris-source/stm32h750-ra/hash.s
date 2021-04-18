@ -----------------------------------------------------------------------------
Wortbirne Flag_visible, "init-hash" @ ( -- )
@ -----------------------------------------------------------------------------
init_hash:
    @ Enable the CRC32 peripheral
    ldr  r0, =RCC_AHB2ENR
    ldr  r1, [r0]
    eor  r1, #RCC_AHB2ENR_HASHEN
    str  r1, [r0]

    bx   lr


@ -----------------------------------------------------------------------------
Wortbirne Flag_visible, "hash_cr" @ ( -- a-addr )
@ -----------------------------------------------------------------------------
    dup
    ldr tos, =HASH_CR
    bx  lr

.ltorg
