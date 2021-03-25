@
@    Mecrisp-Stellaris - A native code Forth implementation for ARM-Cortex M microcontrollers
@    Copyright (C) 2013  Matthias Koch
@
@    This program is free software: you can redistribute it and/or modify
@    it under the terms of the GNU General Public License as published by
@    the Free Software Foundation, either version 3 of the License, or
@    (at your option) any later version.
@
@    This program is distributed in the hope that it will be useful,
@    but WITHOUT ANY WARRANTY; without even the implied warranty of
@    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
@    GNU General Public License for more details.
@
@    You should have received a copy of the GNU General Public License
@    along with this program.  If not, see <http://www.gnu.org/licenses/>.
@

@ -----------------------------------------------------------------------------
@ Interruptvektortabelle
@ -----------------------------------------------------------------------------

.equ addresszero, . @ This is needed to circumvent address relocation issues.

.word   returnstackanfang  @ 00: Stack top address
.word   Reset+1            @ 01: Reset Vector  +1 wegen des Thumb-Einsprunges

@ Gemeinsame Interruptvektortabelle: Common interrupt vector table:

.word nullhandler+1   @ 02: The NMI handler
.word nullhandler+1   @ 03: The hard fault handler
.word 0               @ 04: The MPU fault handler
.word 0               @ 05: Reserved
.word 0               @ 06: Reserved
.word 0               @ 07: Reserved
.word 0               @ 08: Reserved
.word 0               @ 09: Reserved
.word 0               @ 10: Reserved
.word nullhandler+1   @ 11: SVCall handler
.word 0               @ 12: Reserved
.word 0               @ 13: Reserved
.word nullhandler+1   @ 14: The PendSV handler
.word irq_vektor_systick+1   @ 15: The SysTick handler

@ Bis hierhin ist die Interruptvektortabelle bei allen ARM Cortex M0 Chips gleich.
@ Danach geht es mit den Besonderheiten eines jeden Chips los.

@ Special interrupt handlers for this particular chip:
@ To be filled in here later...





@  VECTORS (rx)      : ORIGIN = 0x0,         LENGTH = 0x00c0
@  FLASHCFG (rx)     : ORIGIN = 0x00000400,  LENGTH = 0x00000010
@  FLASH (rx)        : ORIGIN = 0x00000410,  LENGTH = 128K - 0x410
@  RAM  (rwx)        : ORIGIN = 0x1FFFF000,  LENGTH = 16K


@ Flash configuration field (loaded into flash memory at 0x400)
.org 0x400, 0xFFFFFFFF @ Advance to Flash Configuration Field (FCF)
.org 0x410, 0xFFFFFFFF @ Fill this field with FF to have Reset Pin enabled.

@ Start for real code !

@ -----------------------------------------------------------------------------
nullhandler:
  push {lr} 
  writeln "Unhandled Interrupt !"
  pop {pc}
@ -----------------------------------------------------------------------------
