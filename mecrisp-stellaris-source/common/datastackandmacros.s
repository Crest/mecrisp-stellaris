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
@ Registerdefinitionen
@ -----------------------------------------------------------------------------

@ Helferlein-Register
w .req r0
x .req r1
y .req r2

@ Datenstack mit TOS im Register.
@ Achtung: Diese Register sind recht fest eingebaut, nicht versuche, diese auszustauschen.
tos .req r6
psp .req r7

@ -----------------------------------------------------------------------------
@ Datenstack-Makros
@ -----------------------------------------------------------------------------

.macro pushdaconst zahl
  stmdb psp!, {tos}
  movs tos, #\zahl
.endm

.macro pushdaconstw zahl
  stmdb psp!, {tos}
  movw tos, #\zahl
.endm

.macro pushda register
  stmdb psp!, {tos}
  mov tos, \register
.endm

.macro popda register
  mov \register, tos
  ldm psp!, {tos}
.endm

.macro drop
  ldm psp!, {tos}
.endm

.macro dup
  stmdb psp!, {tos}
.endm

.macro swap
  ldr x, [psp]   @ Load X from the stack, no SP change.
  str tos, [psp] @ Replace it with TOS.
  mov tos, x     @ And vice versa.
.endm

.macro to_r
  push {tos}
  ldm psp!, {tos} @ drop
.endm

.macro r_from
  stmdb psp!, {tos}
  pop {tos}
.endm

@ -----------------------------------------------------------------------------
@ Flagdefinitionen
@ -----------------------------------------------------------------------------

.equ Flag_invisible,  0xFFFFFFFF

.equ Flag_visible,    0x00000000
.equ Flag_immediate,  0x00000010
.equ Flag_inline,     0x00000020
.equ Flag_immediate_compileonly, 0x30 @ Immediate + Inline

.equ Flag_ramallot,   0x00000080
.equ Flag_variable,   Flag_ramallot|1

.equ Flag_foldable,   0x00000040
.equ Flag_foldable_0, 0x00000040
.equ Flag_foldable_1, 0x00000041
.equ Flag_foldable_2, 0x00000042
.equ Flag_foldable_3, 0x00000043
.equ Flag_foldable_4, 0x00000044
.equ Flag_foldable_5, 0x00000045
.equ Flag_foldable_6, 0x00000046
.equ Flag_foldable_7, 0x00000047

@ -----------------------------------------------------------------------------
@ Makros zum Bauen des Dictionary
@ -----------------------------------------------------------------------------

@ Für initialisierte Variablen am Ende des RAM-Dictionary
.macro CoreVariable, Name @  Benutze den Mechanismus, um initialisierte Variablen zu erhalten.
  .set CoreVariablenPointer, CoreVariablenPointer - 4
  .equ \Name, CoreVariablenPointer
.endm

@ Für uninitialisierte Variablen am Anfang des RAMs
@ Makro für die gemütliche Speicherreservierung
.macro ramallot Name, Menge         @ Für Variablen und Puffer zu Beginn des Rams, die im Kern verwendet werden sollen.
  .equ \Name, rampointer            @ Uninitialisiert.
  .set rampointer, rampointer + \Menge
.endm

@ Pointer und Makros zum Aufbau des Dictionaries

.macro Wortbirne Flags, Name
	.p2align 1        @ Auf gerade Adressen ausrichten
        .set Neu, .
        .hword \Flags     @ Flags setzen, diesmal 2 Bytes ! Wir haben Platz und Ideen :-)
        .word Latest      @ Link einfügen
        .set Latest, Neu
	.byte 8f - 7f     @ Länge des Namensfeldes berechnen
7:	.ascii "\Name"    @ Namen anfügen
8:	.p2align 1        @ 1 Bit 0 - Wieder gerade machen
.endm
