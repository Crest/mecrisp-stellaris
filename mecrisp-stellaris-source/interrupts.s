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

@ Routinen für die Interrupthandler, die zur Laufzeit neu gesetzt werden können.

@ -----------------------------------------------------------------------------
  Wortbirne Flag_inline, "eint" @ ( -- ) Aktiviert Interrupts
@ ----------------------------------------------------------------------------- 
  cpsie i @ Interrupt-Handler
 @ cpsie f @ Fehler-Handler
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_inline, "dint" @ ( -- ) Deaktiviert Interrupts
@ ----------------------------------------------------------------------------- 
  cpsid i @ Interrupt-Handler
 @ cpsid f @ Fehler-Handler
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "nop" @ ( -- ) Handler für unbenutzte Interrupts
nop_vektor:
@ ----------------------------------------------------------------------------- 
  bx lr


.macro interrupt Name

@------------------------------------------------------------------------------
  Wortbirne Flag_visible|Flag_variable, "irq-\Name" @ ( -- addr )
  CoreVariable irq_hook_\Name
@------------------------------------------------------------------------------  
  stmdb psp!, {tos}
  ldr tos, =irq_hook_\Name
  bx lr
  .word nop_vektor  @ Startwert für unbelegte Interrupts

irq_vektor_\Name:
  ldr r0, =irq_hook_\Name
  ldr r0, [r0]
  adds r0, #1 @ Ungerade Adresse für Thumb-Befehlssatz
  mov pc, r0  @ Angesprungene Routine kehrt von selbst zurück...

.endm

@------------------------------------------------------------------------------
@ Alle Interrupthandler funktionieren gleich und werden komfortabel mit einem Makro erzeugt:
@------------------------------------------------------------------------------
interrupt systick
interrupt porta
interrupt portb
interrupt portc
interrupt portd
interrupt porte
interrupt portf
interrupt adc0seq0
interrupt adc0seq1
interrupt adc0seq2
interrupt adc0seq3
interrupt timer0a
interrupt timer0b
interrupt timer1a
interrupt timer1b
interrupt timer2a
interrupt timer2b
@------------------------------------------------------------------------------

/*
  Zu den Registern, die gesichert werden müssen:
  r 0  Wird von IRQ-Einsprung gesichert
  r 1  Wird von IRQ-Einsprung gesichert
  r 2  Wird von IRQ-Einsprung gesichert
  r 3  Wird von IRQ-Einsprung gesichert

  r 4    Schleifenindex und Arbeitsregister, wird vor Benutzung gesichert
  r 5    Schleifenlimit und Arbeitsregister, wird vor Benutzung gesichert
  r 6  TOS - müsste eigentlich von sich aus funktionieren
  r 7  PSP - müsste eigentlich von sich aus funktionieren

  r 8  Unbenutzt
  r 9  Unbenutzt
  r 10 Unbenutzt
  r 11 Unbenutzt
  r 12 Unbenutzt, wird von IRQ-Einsprung gesichert

  r 13 = sp
  r 14 = lr
  r 15 = pc
*/
