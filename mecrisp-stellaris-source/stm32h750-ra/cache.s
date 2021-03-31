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

.equ CCR     , 0xE000ED14   @ RW Privileged Implementation Defined Configuration and Control Register
.equ CCR_IC  , 1<<17        @ Enables L1 instruction cache, has to be invalidated first
.equ CCR_DC  , 1<<16        @ Enables L1 data cache, hast to be invalidated first

.equ CLIDR   , 0xE000ED78 @ RO Privileged 0x09000003 Cache level ID register
.equ CTR     , 0xE000ED7C @ RO Privileged 0x8303C003 Cache type register on page 218
.equ CCSIDR  , 0xE000ED80 @ RO Privileged Unknown Cache size ID register on page 219
.equ CSSELR  , 0xE000ED84 @ RW Privileged Unknown Cache size selection register on page 220

.equ ICIALLU , 0xE000EF50 @ WO Privileged Unknown Instruction cache invalidate all to the Point of Unification (PoU)(1)
.equ ICIMVAU , 0xE000EF58 @ WO Privileged Unknown Instruction cache invalidate by address to the PoU(1)
.equ DCIMVAC , 0xE000EF5C @ WO Privileged Unknown Data cache invalidate by address to the Point of Coherency (PoC)(2)
.equ DCISW   , 0xE000EF60 @ WO Privileged Unknown Data cache invalidate by set/way
.equ DCCMVAU , 0xE000EF64 @ WO Privileged Unknown Data cache by address to the PoU(1)
.equ DCCMVAC , 0xE000EF68 @ WO Privileged Unknown Data cache clean by address to the PoC(2)
.equ DCCSW   , 0xE000EF6C @ WO Privileged Unknown Data cache clean by set/way
.equ DCCIMVAC, 0xE000EF70 @ WO Privileged Unknown Data cache clean and invalidate by address to the PoC(2)
.equ DCCISW  , 0xE000EF74 @ WO Privileged Unknown Data cache clean and invalidate by set/way

enable_caches:
    push {lr}
    @ The Cortex M7 core in the STM32H750 uses a harvard cache architecture.
    @ The caches are enabled by bits 16 and 17 of the Configuration and
    @ Control Register [1].
    @
    @ On reset the cache content is unpredicatable. We have to invalidate the
    @ caches before turning them on [2].
    @
    
    ldr  r3, =CCR       @ Read the configuration and control register
    ldr  r0, [r3]       @
    tst  r0, #CCR_DC    @ Skip over the data cache if 
    bne  2f             @ if it's already enabled

    @ The STM32H750 has a 16kiB data cache organized as follows [3]:
    @   * 4 way associative
    @   * 128 sets
    @   * 32 byte cache lines
    @ 
    @ The data cache is invalidated by invalidating all cache sets. The cache sets are
    @ addressed by cache way and set number inside the cache way in the Data cache
    @ invalidate by set/way register (DCISW). Writes to DCISW register invalidate the
    @ addressed cache set [4].
    @
    @ A downward counter is used to loop over all data cache sets.
    @ The counter must have a width of log2(associativity) + log2(sets) = 2 + 7 = 9 bits
    @ The upper two bits address the cache way. The lower seven the cache set in the way.
    @ On each iteration the counter is expanded required format and written to the DCISW register.
    @
    @ The layout of the DCISW register is [4]:
    @   * [31:30] : way (one of the four sets)
    @   * [13:5]  : set (only the lower 7 bits are populated in by a 4way 16kiB cache with 32B lines)j
    @   * rest    : reserved

    ldr  r0, =DCISW     @ Load the address of the data cache invalidate by set/way register
    movw r1, #(1<<9)-1  @ Use a 9 bit down counter

1:  lsrs r2, r1, 7      @ Extract the upper two counter bits
    lsls r2, #30        @ into the cache way field.
    bfi  r2, r1, #5, #7 @ Insert the lower 7 bits into the set field.
    str  r2, [r0]       @ Invalidate the addressed caches set.
    subs r1, #1         @ Decrement the counter
    bne  1b             @ Repeat until all sets have been invalidated
    dsb                 @ Wait for all memory accesses to complete
    isb                     
    
    ldr  r0, [r3]       @ Enable the data cache
    orr  r0, #CCR_DC    
    str  r0, [r3]
    dsb                 @ Your friendly memory barrier
    isb

2:  tst  r0, #CCR_IC    @ If the instruction cache is already enabled
    bne  3f             @ we're done.

    @ The STM32H750 has a 16kiB instruction cache organized as follows [3]:
    @   * 2 way associative
    @   * 256 sets
    @   * 32 byte cache lines
    @
    @ Invalidating the instruction cache is a lot simpler. Writing to the
    @ Instruction cache invalidate all to the Point of Unification (sic!)
    @ register (ICIALLU) invalidates the whole instruction cache [5].
    
    ldr  r2, =ICIALLU   @ Load the ICIALLU register address and invalidate
    str  r0, [r2]       @ the instruction cache by just writing to it.
    dsb                 @ Wait for it.
    isb
    
    orr  r0, #CCR_IC    @ Enable the instruction cache
    str  r0, [r3]
    dsb
    isb

    @ References:
    @
    @ [1] : Arm® Cortex®-M7 Devices
    @       Generic User Guide
    @       Section 4.3.7 Configuration and Control Register, page 251
    @       URL: https://static.docs.arm.com/dui0646/c/DUI0646C_cortex_m7_dgug.pdf
    @
    @ [2] : Arm® Cortex®-M7 Devices
    @       Generic User Guide
    @       Section 4.8.5 Initializing and enabling the L1 cache, page 294
    @       URL: https://static.docs.arm.com/dui0646/c/DUI0646C_cortex_m7_dgug.pdf
    @
    @ [3] : Arm® Cortex®-M7 Devices
    @       Generic User Guide
    @       Section 4.5.3 Cache Size ID Register, page 271, table 4-43
    @       URL: https://static.docs.arm.com/dui0646/c/DUI0646C_cortex_m7_dgug.pdf
    @
    @ [4] : Arm® Cortex®-M7 Devices
    @       Generic User Guide
    @       Section 4.8.3 Data cache operations by set-way, page 293
    @       URL: https://static.docs.arm.com/dui0646/c/DUI0646C_cortex_m7_dgug.pdf
    @
    @ [5] : Arm® Cortex®-M7 Devices
    @       Generic User Guide
    @       Section 4.8.1 Full instruction cache operation, page 292
    @       URL: https://static.docs.arm.com/dui0646/c/DUI0646C_cortex_m7_dgug.pdf

3:  pop  {pc}


@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "dcache-clean" @ ( addr -- )
@ -----------------------------------------------------------------------------
dcache_clean:
    @ Clean a (potentially) dirty cache line by writing it back to memory.
    @
    @ The STM32H750 lacks cache coherence instead it offers these options:
    @ 
    @   * Leave the cache disabled
    @   * Control cacheability with the MPU
    @   * Put the cache into write through mode
    @   * Explicitly clean the cache
    @
    @ According to the STM32H750 errata sheet write through caching of the AXI
    @ SRAM can lead to data corruption.

    ldr  r0, =DCCMVAC    
    str  tos, [r0]
    dsb
    drop 
    bx   lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "dcache-invalidate" @ ( addr -- )
@ -----------------------------------------------------------------------------
dcache_invalidate:
    @ Invalitate a cache line without writing it back to memory
    @
    @ The STM32H750 lacks cache coherence instead it offers these options:
    @
    @   * Leave the cache disabled (sucks)
    @   * Control cacheability with the MPU
    @   * Explicitly invalidate the cache
    @
    @ Write through caching doesn't help with loads from cached memory
    @ instead the any potentially cached lines have to be invalidated
    @ without writing them back to memory

    ldr  r0, =DCIMVAC
    str  tos, [r0]
    dsb
    drop 
    bx   lr
