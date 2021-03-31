@ Copyright (c) 2021 Jan Bramkmap, Matthias Koch
@ 
@ Permission is hereby granted, free of charge, to any person obtaining a copy
@ of this software and associated documentation files (the "Software"), to deal
@ in the Software without restriction, including without limitation the rights
@ to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
@ copies of the Software, and to permit persons to whom the Software is
@ furnished to do so, subject to the following conditions:
@ 
@ The above copyright notice and this permission notice shall be included in all
@ copies or substantial portions of the Software.
@ 
@ THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
@ IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
@ FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
@ AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
@ LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
@ OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
@ SOFTWARE.

@ Schreiben und Löschen des SPI Flash für den STM32H750.

.equ FLASH_ACR_2WS, (0b10 << Flash_ACR_WRHIGHFREQ_Shift) | (0b0010 << Flash_ACR_LATENCY_Shift)

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "flash-400MHz" @ ( -- )
@ -----------------------------------------------------------------------------
@ The STM32H750's internal flash needs two wait states when clocked for 400MHz
flash_400mhz:

    @ Configure the flash for 400MHz (2 wait states)
    ldr  r0, =Flash_ACR
    movs r1, #FLASH_ACR_2WS
    str  r1, [r0]

    bx   lr

@ Each of the status registers 1-3 has its own read command
.equ SPI_READ_SR1, 0x05
.equ SPI_READ_SR2, 0x35
.equ SPI_READ_SR3, 0x15

@ -----------------------------------------------------------------------------
Wortbirne Flag_visible|Flag_foldable_0, "spi-read-sr1" @ ( -- cmd )
@ -----------------------------------------------------------------------------
spi_read_reg1:

    @ Push the read status register 1 command on the stack
    stmdb psp!, {tos}
    mov   tos, #SPI_READ_SR1

    bx    lr

@ -----------------------------------------------------------------------------
Wortbirne Flag_visible|Flag_foldable_0, "spi-read-sr2" @ ( -- cmd )
@ -----------------------------------------------------------------------------
spi_read_reg2:

    @ Push the read status register 2 command on the stack
    stmdb psp!, {tos}
    mov   tos, #SPI_READ_SR2

    bx    lr

@ -----------------------------------------------------------------------------
Wortbirne Flag_visible|Flag_foldable_0, "spi-read-sr3" @ ( -- cmd )
@ -----------------------------------------------------------------------------
spi_read_reg3:

    @ Push the read status register 3 command on the stack
    stmdb psp!, {tos}
    mov   tos, #SPI_READ_SR3

    bx    lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "init-spi" @ ( -- )
@ -----------------------------------------------------------------------------
init_spi:
    @ Enable GPIOA clock
    ldr  r0, =RCC_AHB4ENR
    ldr  r2, [r0]
    orr  r2, #RCC_AHB4ENR_GPIOAEN
    str  r2, [r0]

    @ Enable SPI1 clock
    ldr  r1, =RCC_APB2ENR
    ldr  r2, [r1] 
    orr  r2, #RCC_APB2ENR_SPI1EN
    str  r2, [r1]

    @ Load GPIOA base
    ldr  r0, =GPIOA_BASE

    @ Select PA4-PA7 alternate function AF5
    ldr  r2, [r0, #AFRL]
    movt r2, #0x5555
    str  r2, [r0, #AFRL]

    @ Drive PA4-PA7 as hard as possible
    ldr  r2, [r0, #OSPEEDR]
    orr  r2, #0xff<<8
    str  r2, [r0, #OSPEEDR]

    @ Enable PA4 pullup
    ldr  r2, [r0, #PUPDR]
    orr  r2, #0b01<<8
    str  r2, [r0, #PUPDR]

    @ Put PA4-PA7 into alternative function mode
    ldr  r2, [r0, #MODER]
    bic  r2, #0x55<<8
    str  r2, [r0, #MODER]

    @ Load SPI1 base address
    ldr  r1, =SPI1_BASE

    @ Configure SPI baud rate (200MHz/32)
    ldr  r2, =(0b100 << SPI1_CFG1_MBR_Shift) | (0b00111 << SPI1_CFG1_CRCSIZE_Shift) | (0b00111 << SPI1_CFG1_DSIZE_Shift)
    str  r2, [r1, #(SPI1_CFG1 - SPI1_BASE)]
    
    @ Configure SPI as master
    ldr  r2, =(SPI1_CFG2_AFCNTR | SPI1_CFG2_SSOE | SPI1_CFG2_MASTER|(0b0001 << SPI1_CFG2_MSSI_Shift))
    str  r2, [r1, #(SPI1_CFG2 - SPI1_BASE)]

    @ Enable SPI
    movs r2, #SPI1_CR1_SPE
    str  r2, [r1, #(SPI1_CR1 - SPI1_BASE)]

    bx   lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "jedec-id" @ ( -- id )
@ -----------------------------------------------------------------------------
@ Query the SPI flash chip for its manufacturer, type and capacity
jedec_id:

    @ Load SPI1 base addresss
    ldr   r0, =SPI1_BASE

    @ Push the 0x9f command (repeated four times)
    stmdb psp!, {tos}
    mov   tos, #0x9f9f9f9f
    
    @ Disable SPI
    movs  r1, #0
    str   r1, [r0, #(SPI1_CR1 - SPI1_BASE)]

    @ Set length
    movs  r1, #4
    str   r1, [r0, #(SPI1_CR2 - SPI1_BASE)]
    
    @ Clear TXTFC and EOT
    movs r1, #(SPI1_IFCR_TXTFC | SPI1_IFCR_EOTC)
    str  r1, [r0, #(SPI1_IFCR - SPI1_BASE)]
    
    @ Enable SPI
    movs r1, #SPI1_CR1_SPE
    str  r1, [r0, #(SPI1_CR1 - SPI1_BASE)]

    @ Start the transfer. The SPI flash autoincrements the read address.
    movw r1, #(SPI1_CR1_CSTART | SPI1_CR1_SPE)
    str  r1, [r0, #(SPI1_CR1 - SPI1_BASE)]
    
    @ Enqueue the JEDEC ID command (0x9f) and three repeptitions as dummies
    str  tos, [r0, #(SPI1_TXDR - SPI1_BASE)]
    
    @ According to the JEDEC standard for SPI compatible memories from 2203
    @ the SPI flash responds to 0x9f with three bytes:
    @   * manufacturer ID (0xEF for Winbond)
    @   * memory type
    @   * capacity
1:  ldr  r1, [r0, #(SPI1_SR - SPI1_BASE)]
    tst  r1, #SPI1_SR_RXWNE
    beq  1b
    ldr  tos, [r0, #(SPI1_RXDR - SPI1_BASE)]

    @ Convert to host endianness and mask the dummy byte
    rev  tos, tos
    bic  tos, #0xff000000

    bx   lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, ">jedec-size" @ ( id -- size )
@ -----------------------------------------------------------------------------
to_jedec_size:

    @ Decode the JEDEC id into the flash capacity in bytes
    movs r0, #1
    and  tos, #0xff
    lsl  tos, r0, tos

    bx   lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "spi-status@" @ ( reg -- byte )
@ -----------------------------------------------------------------------------
spi_status_read:
    @ Load SPI1 base addresss
    ldr   r0, =SPI1_BASE

    @ Reuse the read command as dummy
    bfi   tos, tos, #8, #8
    
    @ Disable SPI
    movs  r1, #0
    str   r1, [r0, #(SPI1_CR1 - SPI1_BASE)]

    @ Set length
    movs  r1, #2
    str   r1, [r0, #(SPI1_CR2 - SPI1_BASE)]
    
    @ Clear TXTFC and EOT
    movs r1, #(SPI1_IFCR_TXTFC | SPI1_IFCR_EOTC)
    str  r1, [r0, #(SPI1_IFCR - SPI1_BASE)]
    
    @ Enable SPI
    movs r1, #SPI1_CR1_SPE
    str  r1, [r0, #(SPI1_CR1 - SPI1_BASE)]

    @ Start the transfer. The SPI flash autoincrements the read address.
    movw r1, #(SPI1_CR1_CSTART | SPI1_CR1_SPE)
    str  r1, [r0, #(SPI1_CR1 - SPI1_BASE)]
    
    @ Enqueue the read status register command (twice, once as dummy)
    strh tos, [r0, #(SPI1_TXDR - SPI1_BASE)]
    
    @ Wait until both bytes are in Rx FIFO
1:  ldr  r1, [r0, #(SPI1_SR - SPI1_BASE)]
    tst  r1, #(2 << SPI1_SR_RXPLVL_Shift)
    beq  1b
    ldrh tos, [r0, #(SPI1_RXDR - SPI1_BASE)]

    @ Keep only the second byte
    lsrs tos, #8

    bx   lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "spi-c@" @ ( addr -- byte )
@ -----------------------------------------------------------------------------
@ Reads a single byte from SPI flash

    @ Load SPI1 base addresss
    ldr  r0, =SPI1_BASE

    @ Merge the 24 bit address and 0x03 (read) into a 32 bit big endian command 
    bic  tos, #0xff000000
    add  tos, #0x03000000
    rev  tos, tos
    
    @ Disable SPI
    movs r1, #0
    str  r1, [r0, #(SPI1_CR1 - SPI1_BASE)]

    @ Set length
    movs r1, #5
    str  r1, [r0, #(SPI1_CR2 - SPI1_BASE)]
    
    @ Clear TXTFC and EOT
    movs r1, #(SPI1_IFCR_TXTFC | SPI1_IFCR_EOTC)
    str  r1, [r0, #(SPI1_IFCR - SPI1_BASE)]
    
    @ Enable SPI
    movs r1, #SPI1_CR1_SPE
    str  r1, [r0, #(SPI1_CR1 - SPI1_BASE)]

    @ Start the transfer. The SPI flash autoincrements the read address.
    movw r1, #(SPI1_CR1_CSTART | SPI1_CR1_SPE)
    str  r1, [r0, #(SPI1_CR1 - SPI1_BASE)]
    
    @ Enqueue the read command and address twice (once as command and once as dummy).
    str  tos, [r0, #(SPI1_TXDR - SPI1_BASE)]
    strb tos, [r0, #(SPI1_TXDR - SPI1_BASE)]
    
    @ The SPI flash doesn't reply anything useful to the command
    @ and address bytes. Ignore those four bytes as soon as they're available.
    @ The RXWNE flag is set if the Rx FIFO contains at least 4 bytes.
1:  ldr  r1, [r0, #(SPI1_SR - SPI1_BASE)]
    tst  r1, #SPI1_SR_RXWNE
    beq  1b
    ldr  r1, [r0, #(SPI1_RXDR - SPI1_BASE)]

    @ Wait for the four data bytes to consume from the Rx FIFO
2:  ldr  r1, [r0, #(SPI1_SR - SPI1_BASE)]
    tst  r1, #(1 << SPI1_SR_RXPLVL_Shift)
    beq  2b
    ldr  tos, [r0, #(SPI1_RXDR - SPI1_BASE)]
    
    bx   lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "spi-@" @ ( addr -- cell )
@ -----------------------------------------------------------------------------
@ Reads four byte from SPI flash

    @ Load SPI1 base addresss
    ldr  r0, =SPI1_BASE

    @ Merge the 24 bit address and 0x03 (read) into a 32 bit big endian command 
    bic  tos, #0xff000000
    add  tos, #0x03000000
    rev  tos, tos
    
    @ Disable SPI
    movs r1, #0
    str  r1, [r0, #(SPI1_CR1 - SPI1_BASE)]

    @ Set length
    movs r1, #8
    str  r1, [r0, #(SPI1_CR2 - SPI1_BASE)]
    
    @ Clear TXTFC and EOT
    movs r1, #(SPI1_IFCR_TXTFC | SPI1_IFCR_EOTC)
    str  r1, [r0, #(SPI1_IFCR - SPI1_BASE)]
    
    @ Enable SPI
    movs r1, #SPI1_CR1_SPE
    str  r1, [r0, #(SPI1_CR1 - SPI1_BASE)]

    @ Start the transfer. The SPI flash autoincrements the read address.
    movw r1, #(SPI1_CR1_CSTART | SPI1_CR1_SPE)
    str  r1, [r0, #(SPI1_CR1 - SPI1_BASE)]
    
    @ Enqueue the read command and address twice (once as command and once as dummy).
    str  tos, [r0, #(SPI1_TXDR - SPI1_BASE)]
    str  tos, [r0, #(SPI1_TXDR - SPI1_BASE)]
    
    @ The SPI flash doesn't reply anything useful to the command
    @ and address bytes. Ignore those four bytes as soon as they're available.
    @ The RXWNE flag is set if the Rx FIFO contains at least 4 bytes.
1:  ldr  r1, [r0, #(SPI1_SR - SPI1_BASE)]
    tst  r1, #SPI1_SR_RXWNE
    beq  1b
    ldr  r1, [r0, #(SPI1_RXDR - SPI1_BASE)]

    @ Wait for the four data bytes to consume from the Rx FIFO
2:  ldr  r1, [r0, #(SPI1_SR - SPI1_BASE)]
    tst  r1, #SPI1_SR_RXWNE
    beq  2b
    ldr  tos, [r0, #(SPI1_RXDR - SPI1_BASE)]
    
    bx   lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "spi-read" @ ( spi-addr ram-addr length -- )
@ -----------------------------------------------------------------------------
@ Read from SPI flash in a single transfer
spi_read:
    @ Load SPI1 base addresss
    ldr  r0, =SPI1_BASE

    @ Load spi-addr and ram-addr
    ldm  psp!, {r1, r2}
    
    @ Merge the 24 bit address and 0x03 (read) into a 32 bit big endian command 
    bic  r2, #0xff000000
    add  r2, #0x03000000
    rev  r2, r2
    
    @ Disable SPI
    movs r3, #0
    str  r3, [r0, #(SPI1_CR1 - SPI1_BASE)]

    @ Set length
    adds tos, #4
    str  tos, [r0, #(SPI1_CR2 - SPI1_BASE)]
    subs tos, #4

    @ Clear TXTFC and EOT
    movs r3, #(SPI1_IFCR_TXTFC | SPI1_IFCR_EOTC)
    str  r3, [r0, #(SPI1_IFCR - SPI1_BASE)]
    
    @ Enable SPI
    movs r3, #SPI1_CR1_SPE
    str  r3, [r0, #(SPI1_CR1 - SPI1_BASE)]

    @ Start the transfer. The SPI flash autoincrements the read address.
    movw r3, #(SPI1_CR1_CSTART | SPI1_CR1_SPE)
    str  r3, [r0, #(SPI1_CR1 - SPI1_BASE)]

    @ Send the read command
    str  r2, [r0, #(SPI1_TXDR - SPI1_BASE)]

    @ The SPI flash doesn't reply anything useful to the command
    @ and address bytes. Ignore those four bytes as soon as they're available.
    @ The RXWNE flag is set if the Rx FIFO contains at least 4 bytes.
1:  ldr  r3, [r0, #(SPI1_SR - SPI1_BASE)]
    tst  r3, #SPI1_SR_RXWNE
    beq  1b
    ldr  r3, [r0, #(SPI1_RXDR - SPI1_BASE)]
    
    @ Maintain separate transmit and receive counters
    movs r2, tos

    @ Load SPI1 status register (lower half)
2:  ldrh r3, [r0, #(SPI1_SR - SPI1_BASE)]

    @ Have we transmitted enough dummy bytes?
    cmp  r2, #0
    beq  3f

    @ Is transmit FIFO full?
    tst  r3, #SPI1_SR_TXP
    beq  3f

    @ Enqueue a dummy byte
    strb r0, [r0, #(SPI1_TXDR - SPI1_BASE)]
    subs r2, #1

3:  @ Is the Rx FIFO empty?
    lsrs r3, #SPI1_SR_RXPLVL_Shift
    beq  2b
    
    @ Dequeue and store a data byte
    ldrb r3, [r0, #(SPI1_RXDR - SPI1_BASE)]
    strb r3, [r1]
    adds r1, #1
    subs r6, #1
    bne  2b
    
    @ Drop and return
    ldm  psp!, {tos}
    bx   lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "spi-move" @ ( spi-addr ram-addr length -- )
@ -----------------------------------------------------------------------------
spi_move:
    @ The SPI peripherals contain a 16 bit transfer counter (TSIZE in CR2).
    @ This counter limits us to 2^15 - 1 bytes per transfer including the
    @ read command and address.

    push  {lr}                  @ Registers:                                        Stack (r6 = top of stack):
                                
    @ Duplicate all arguments
    movs  r0, r6                @ r0 = len,                               r6 = len  ( spi ram len )
    ldmia psp!, {r1, r2}        @ r0 = len, r1 = ram, r2 = spi,           r6 = len  ( len )
    stmdb psp!, {r0, r1, r2}    @ r0 = len, r1 = ram, r2 = spi,           r6 = len  ( spi ram len len )
    stmdb psp!, {r1, r2}        @ r0 = len, r1 = ram, r2 = spi,           r6 = len  ( spi ram len spi ram len )

    @ Load the maximum payload size per read operation.
    @ The four bytes for the command and address have to be substracted from the 0xffff transfer size limit
    movw  r3, #0xfffb           @ r0 = len, r1 = ram, r2 = spi, r3 = max, r6 = len  ( spi ram len spi ram len )
    
    @ Limit the payload size
1:  cmp   r6, r3                @ r0 = len, r1 = ram, r2 = spi, r3 = max, r6 = len  ( spi ram len spi ram len )
    it    hs                    @ r0 = len, r1 = ram, r2 = spi, r3 = max, r6 = len  ( spi ram len spi ram len )
    movhs r6, r3                @ r0 = len, r1 = ram, r2 = spi, r3 = max, r6 = len  ( spi ram len spi ram len )

    @ Read the as much as possible per transfer from the flash
    bl    spi_read              @                                         r6 = len  ( spi ram len )
    
    @ Advance the posititions and decrease the remaining length
    @ The call to spi_read has invalidated r0-r3.
    movw  r3, #0xfffb           @                               r3 = max, r6 = len  ( spi ram len )
    ldmia psp!, {r1, r2}        @           r1 = ram, r2 = spi, r3 = max, r6 = len  ( len )
    adds  r1, r3                @           r1 = ram, r2 = spi, r3 = max, r6 = len  ( len )
    adds  r2, r3                @           r1 = ram, r2 = spi, r3 = max, r6 = len  ( len )
    subs  r6, r3                @           r1 = ram, r2 = spi, r3 = max, r6 = len  ( len )

    @ We're done if the length underflowed
    blo   2f                    @           r1 = ram, r2 = spi, r3 = max, r6 = len  ( len )

    @ Duplicate the arguments
    movs  r0, r6                @ r0 = len, r1 = ram, r2 = spi, r3 = max, r6 = len  ( len )
    stmdb psp!, {r0, r1, r2}    @ r0 = len, r1 = ram, r2 = spi, r3 = max, r6 = len  ( spi ram len len )
    stmdb psp!, {r1, r2}        @ r0 = len, r1 = ram, r2 = spi, r3 = max, r6 = len  ( spi ram len spi ram len )
    b     1b                    @
    
    @ Drop the length
2:  ldmia psp!, {r6}            @                                                   ( )
    pop   {pc}                  @


@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "hflash!" @ ( x Addr -- )
@ -----------------------------------------------------------------------------
h_flashkomma:
@ Write two bytes to the flash

    push  {lr}
    
    bl    write_enable

    @ Load SPI1 base addresss
    ldr   r0, =SPI1_BASE

    @ Store the data to SRAM
    mov   r2, tos
    ldmia psp!, {r3, tos}
    strh  r3, [r2]
    @rev16 r3, r3

    @ Merge the 24 bit address and 0x02 (program page) command into a 32 bit big endian command 
    bic   r2, #0xff000000
    add   r2, #0x02000000
    rev   r2, r2
    
    @ Disable SPI
    movs  r1, #0
    str   r1, [r0, #(SPI1_CR1 - SPI1_BASE)]

    @ Set length
    movs  r1, #6
    str   r1, [r0, #(SPI1_CR2 - SPI1_BASE)]
    
    @ Clear TXTFC and EOT
    movs  r1, #(SPI1_IFCR_TXTFC | SPI1_IFCR_EOTC)
    str   r1, [r0, #(SPI1_IFCR - SPI1_BASE)]
    
    @ Enable SPI
    movs  r1, #SPI1_CR1_SPE
    str   r1, [r0, #(SPI1_CR1 - SPI1_BASE)]

    @ Start the transfer. The SPI flash autoincrements the read address.
    movw  r1, #(SPI1_CR1_CSTART | SPI1_CR1_SPE)
    str   r1, [r0, #(SPI1_CR1 - SPI1_BASE)]
    
    @ Enqueue the program command and address and data
    str   r2, [r0, #(SPI1_TXDR - SPI1_BASE)]
    strh  r3, [r0, #(SPI1_TXDR - SPI1_BASE)]
    
    @ The SPI flash doesn't reply anything useful to the commandw
    @ and address bytes. Ignore those four bytes as soon as they're available.
    @ The RXWNE flag is set if the Rx FIFO contains at least 4 bytes.
1:  ldr   r1, [r0, #(SPI1_SR - SPI1_BASE)]
    tst   r1, #SPI1_SR_RXWNE
    beq   1b
    ldr   r1, [r0, #(SPI1_RXDR - SPI1_BASE)]

    @ Wait for the two dummy bytes to consume from the Rx FIFO
2:  ldr   r1, [r0, #(SPI1_SR - SPI1_BASE)]
    tst   r1, #(2 << SPI1_SR_RXPLVL_Shift)
    beq   2b
    ldr   r1, [r0, #(SPI1_RXDR - SPI1_BASE)]

    pop  {lr}
    b    spi_wait
@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "cflash!" @ ( x Addr -- )
  @ Schreibt ein einzelnes Byte in den Flash.
c_flashkomma:
@ -----------------------------------------------------------------------------
@ Write a single byte to the flash

    push  {lr}
    
    bl    write_enable

    @ Load SPI1 base addresss
    ldr   r0, =SPI1_BASE

    @ Store the data to SRAM
    mov   r2, tos
    ldmia psp!, {r3, tos}
    strb  r3, [r2]

    @ Merge the 24 bit address and 0x02 (program page) command into a 32 bit big endian command 
    bic   r2, #0xff000000
    add   r2, #0x02000000
    rev   r2, r2
    
    @ Disable SPI
    movs  r1, #0
    str   r1, [r0, #(SPI1_CR1 - SPI1_BASE)]

    @ Set length
    movs  r1, #5
    str   r1, [r0, #(SPI1_CR2 - SPI1_BASE)]
    
    @ Clear TXTFC and EOT
    movs  r1, #(SPI1_IFCR_TXTFC | SPI1_IFCR_EOTC)
    str   r1, [r0, #(SPI1_IFCR - SPI1_BASE)]
    
    @ Enable SPI
    movs  r1, #SPI1_CR1_SPE
    str   r1, [r0, #(SPI1_CR1 - SPI1_BASE)]

    @ Start the transfer. The SPI flash autoincrements the read address.
    movw  r1, #(SPI1_CR1_CSTART | SPI1_CR1_SPE)
    str   r1, [r0, #(SPI1_CR1 - SPI1_BASE)]
    
    @ Enqueue the program command and address and data
    str   r2, [r0, #(SPI1_TXDR - SPI1_BASE)]
    strb  r3, [r0, #(SPI1_TXDR - SPI1_BASE)]
    
    @ The SPI flash doesn't reply anything useful to the commandw
    @ and address bytes. Ignore those four bytes as soon as they're available.
    @ The RXWNE flag is set if the Rx FIFO contains at least 4 bytes.
1:  ldr   r1, [r0, #(SPI1_SR - SPI1_BASE)]
    tst   r1, #SPI1_SR_RXWNE
    beq   1b
    ldr   r1, [r0, #(SPI1_RXDR - SPI1_BASE)]

    @ Wait for the single dummy byte to consume from the Rx FIFO
2:  ldr   r1, [r0, #(SPI1_SR - SPI1_BASE)]
    tst   r1, #(1 << SPI1_SR_RXPLVL_Shift)
    beq   2b
    ldr   r1, [r0, #(SPI1_RXDR - SPI1_BASE)]

    pop  {lr}
    b    spi_wait

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "write-enable" @ ( -- )
@ -----------------------------------------------------------------------------
write_enable:
    @ Load SPI1 base addresss
    ldr   r0, =SPI1_BASE

    @ Disable SPI
    movs  r1, #0
    str   r1, [r0, #(SPI1_CR1 - SPI1_BASE)]

    @ Set length
    movs  r1, #1
    str   r1, [r0, #(SPI1_CR2 - SPI1_BASE)]
    
    @ Clear TXTFC and EOT
    movs r1, #(SPI1_IFCR_TXTFC | SPI1_IFCR_EOTC)
    str  r1, [r0, #(SPI1_IFCR - SPI1_BASE)]
    
    @ Enable SPI
    movs r1, #SPI1_CR1_SPE
    str  r1, [r0, #(SPI1_CR1 - SPI1_BASE)]

    @ Start the transfer. The SPI flash autoincrements the read address.
    movw r1, #(SPI1_CR1_CSTART | SPI1_CR1_SPE)
    str  r1, [r0, #(SPI1_CR1 - SPI1_BASE)]
    
    @ Enqueue the write enable command
    movs r1, 0x06
    strb r1, [r0, #(SPI1_TXDR - SPI1_BASE)]
    
    @ Wait until the transfer completed
1:  ldr  r1, [r0, #(SPI1_SR - SPI1_BASE)]
    tst  r1, #(1 << SPI1_SR_RXPLVL_Shift)
    beq  1b
    ldrb r1, [r0, #(SPI1_RXDR - SPI1_BASE)]

    bx   lr


@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "spi-wait" @ ( -- )
@ -----------------------------------------------------------------------------
spi_wait:

    push {tos, lr}
    
1:  movs  tos, #SPI_READ_SR1
    bl    spi_status_read
    tst   tos, #1
    bne   1b

    pop  {tos, pc}
    

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "erase-4k" @ ( addr -- )
@ -----------------------------------------------------------------------------
    mov r3, #0x20 @ Opcode to erase 4kiB
    b   erase

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "erase-32k" @ ( addr -- )
@ -----------------------------------------------------------------------------
    mov r3, #0x52 @ Opcode to erase 32kiB
    b   erase

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "erase-64k" @ ( addr -- )
@ -----------------------------------------------------------------------------
    mov r3, #0xd8 @ Opcode to erase 64kiB

erase:
    push  {lr}
    
    @ We have to set the write enable latch to erase the flash
    bl    write_enable

    @ Load SPI1 base addresss
    ldr   r0, =SPI1_BASE

    @ Merge the 24 bit address and 0x03 (read) into a 32 bit big endian command 
    bic   tos, #0xff000000
    rev   tos, tos
    adds  tos, r3
    
    @ Disable SPI
    movs  r1, #0
    str   r1, [r0, #(SPI1_CR1 - SPI1_BASE)]

    @ Set length
    movs  r1, #4
    str   r1, [r0, #(SPI1_CR2 - SPI1_BASE)]
    
    @ Clear TXTFC and EOT
    movs  r1, #(SPI1_IFCR_TXTFC | SPI1_IFCR_EOTC)
    str   r1, [r0, #(SPI1_IFCR - SPI1_BASE)]
    
    @ Enable SPI
    movs  r1, #SPI1_CR1_SPE
    str   r1, [r0, #(SPI1_CR1 - SPI1_BASE)]

    @ Start the transfer. The SPI flash autoincrements the read address.
    movw  r1, #(SPI1_CR1_CSTART | SPI1_CR1_SPE)
    str   r1, [r0, #(SPI1_CR1 - SPI1_BASE)]
    
    @ Enqueue the erase command and address
    str   tos, [r0, #(SPI1_TXDR - SPI1_BASE)]
    
    @ The SPI flash doesn't reply anything useful to the command
    @ and address bytes. Ignore those four bytes as soon as they're available.
    @ The RXWNE flag is set if the Rx FIFO contains at least 4 bytes.
1:  ldr   r1, [r0, #(SPI1_SR - SPI1_BASE)]
    tst   r1, #SPI1_SR_RXWNE
    beq   1b
    ldr   r1, [r0, #(SPI1_RXDR - SPI1_BASE)]

    ldmia psp!, {tos}
    pop   {lr}

    b     spi_wait

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "erase-chip" @ ( -- )
@ -----------------------------------------------------------------------------
@ The chip erase command doesn't take an address parameter.
erase_chip:

    push {lr}

    @ Enable writes
    bl   write_enable

    @ Load SPI1 base addresss
    ldr   r0, =SPI1_BASE

    @ Disable SPI
    movs  r1, #0
    str   r1, [r0, #(SPI1_CR1 - SPI1_BASE)]

    @ Set length
    movs  r1, #1
    str   r1, [r0, #(SPI1_CR2 - SPI1_BASE)]
    
    @ Clear TXTFC and EOT
    movs r1, #(SPI1_IFCR_TXTFC | SPI1_IFCR_EOTC)
    str  r1, [r0, #(SPI1_IFCR - SPI1_BASE)]
    
    @ Enable SPI
    movs r1, #SPI1_CR1_SPE
    str  r1, [r0, #(SPI1_CR1 - SPI1_BASE)]

    @ Start the transfer. The SPI flash autoincrements the read address.
    movw r1, #(SPI1_CR1_CSTART | SPI1_CR1_SPE)
    str  r1, [r0, #(SPI1_CR1 - SPI1_BASE)]
    
    @ Enqueue the erase chip command
    movs r1, 0xc7
    strb r1, [r0, #(SPI1_TXDR - SPI1_BASE)]
    
    @ Wait until the transfer completed
1:  ldr  r1, [r0, #(SPI1_SR - SPI1_BASE)]
    tst  r1, #(1 << SPI1_SR_RXPLVL_Shift)
    beq  1b
    ldrb r1, [r0, #(SPI1_RXDR - SPI1_BASE)]

    bl   spi_wait

    pop  {pc}

.ltorg @ Flush constant pool
