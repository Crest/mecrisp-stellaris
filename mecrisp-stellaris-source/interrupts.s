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
  Wortbirne Flag_visible, "eint" @ ( -- ) Aktiviert Interrupts
@ ----------------------------------------------------------------------------- 
  cpsie i @ Interrupt-Handler
 @ cpsie f @ Fehler-Handler
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "dint" @ ( -- ) Deaktiviert Interrupts
@ ----------------------------------------------------------------------------- 
  cpsid i @ Interrupt-Handler
 @ cpsid f @ Fehler-Handler
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "nop" @ ( -- ) Handler für unbenutzte Interrupts
nop_vektor:
@ ----------------------------------------------------------------------------- 
  bx lr


@------------------------------------------------------------------------------
  Wortbirne Flag_visible|Flag_variable, "irq-systick" @ ( -- addr )
  CoreVariable irq_hook_systick
@------------------------------------------------------------------------------  
  ldr r0, =irq_hook_systick
  pushda r0
  bx lr
  .word nop_vektor  @ Startwert für unbelegte Interrupts

irq_vektor_systick:
  push {r4, r5, r6, r7, lr} @ Alles Wesentliche sichern.
    ldr r0, =irq_hook_systick
    ldr r0, [r0]
    pushda r0
    bl execute
  pop  {r4, r5, r6, r7, lr} @ Alles Wesentliche zurückholen.
  bx lr

/*
  Zu den Registern, die gesichert werden müssen:
  r0  Wird von IRQ-Einsprung gesichert
  r1  Wird von IRQ-Einsprung gesichert
  r2  Wird von IRQ-Einsprung gesichert
  r3  Wird von IRQ-Einsprung gesichert

  r4    Unbedingt noch sichern
  r5    Unbedingt noch sichern
  r6  TOS - müsste eigentlich von sich aus funktionieren
  r7  PSP - müsste eigentlich von sich aus funktionieren

  r8  Unbenutzt
  r9  Unbenutzt
  r10 Schleifenindex, wird vor Benutzung gesichert
  r11 Schleifenlimit, wird vor Benutzung gesichert
  r12 Unbenutzt, wird von IRQ-Einsprung gesichert

  r13 = sp
  r14 = lr
  r15 = pc
*/
