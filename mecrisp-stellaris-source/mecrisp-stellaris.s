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

.syntax unified
.cpu cortex-m4
.thumb

@ -----------------------------------------------------------------------------
@ Meldungen
@ -----------------------------------------------------------------------------

.macro write Meldung
  bl dotgaensefuesschen	
	.byte 9f - 8f         @ Compute length of name field.
8:	.ascii "\Meldung"
9:	.p2align 1
.endm

.macro writeln Meldung
  bl dotgaensefuesschen 
        .byte 9f - 8f         @ Compute length of name field.
8:      .ascii "\Meldung\n"
9:      .p2align 1
.endm

.macro Fehler_Quit Meldung
  bl dotgaensefuesschen 
        .byte 9f - 8f         @ Compute length of name field.
8:      .ascii "\Meldung\n"
9:      .p2align 1
  b quit
.endm

.macro Fehler_Quit_n Meldung
  bl dotgaensefuesschen 
        .byte 9f - 8f         @ Compute length of name field.
8:      .ascii "\Meldung\n"
9:      .p2align 1
  b.n quit
.endm

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

@ Für initialisierte Variablen
.set CoreVariablenPointer, RamDictionaryEnde
.macro CoreVariable, Name @  Benutze den Mechanismus, um initialisierte Variablen zu erhalten.
  .set CoreVariablenPointer, CoreVariablenPointer - 4
  .equ \Name, CoreVariablenPointer
.endm

@ Pointer und Makros zum Aufbau des Dictionaries
.set Latest, FlashDictionaryAnfang @ Zeiger auf das letzte definierte Wort
.set Neu,    0xFFFFFFFF            @ Variable für aktuellen Zeiger, am Anfang ungesetzt

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

@ -----------------------------------------------------------------------------
@ Anfang im Flash
@ Interruptvektortabelle ganz zu Beginn
@ -----------------------------------------------------------------------------
.text    @ Hier beginnt das Vergnügen mit der Stackadresse und der Einsprungadresse
.include "vectors.s"

@ -----------------------------------------------------------------------------
@ Alle anderen Teile von Mecrisp-Stellaris
@ -----------------------------------------------------------------------------
  .include "stackjugglers.s" 
  .include "logic.s"
  .include "comparisions.s"
  .include "memory.s"
  .include "flash.s"
  .include "calculations.s"
  .ltorg @ Mal wieder Konstanten schreiben
  .include "terminal.s"
  .include "query.s"
  .include "strings.s"
  .include "deepinsight.s"
  .ltorg @ Mal wieder Konstanten schreiben
  .include "compiler.s"
  .ltorg @ Mal wieder Konstanten schreiben
  .include "compiler-flash.s"
  .ltorg @ Mal wieder Konstanten schreiben
  .include "controlstructures.s"
  .ltorg @ Mal wieder Konstanten schreiben
  .include "doloop.s"
  .include "case.s"
  .include "token.s"
  .ltorg @ Mal wieder Konstanten schreiben
  .include "numberstrings.s"
  .include "interpreter.s"
  .include "interrupts.s"

.equ CoreDictionaryAnfang, Latest @ Dictionary-Einsprungpunkt setzen

@ -----------------------------------------------------------------------------
Reset: @ Einsprung zu Beginn
@ -----------------------------------------------------------------------------
   @ Ram zu Beginn mit -1 füllen, um Fehler leichter finden zu können

   ldr r0, =RamAnfang
   ldr r1, =RamEnde
   movs r2, #-1
1: strh r2, [r0]
   adds r0, #2
   cmp r0, r1
   bne 1b

   @ Initialisierungen der Hardware, habe und brauche noch keinen Datenstack dafür
   bl uart_init

   @ Stackpointer ist schon auf 0x20008000 gesetzt.
   @ Setze den Datenstackpointer:
   ldr psp, =datenstackanfang

   @ TOS setzen, um Pufferunterläufe gut erkennen zu können
   ldr tos, =0xAFFEBEEF

   @ Dictionarypointer ins RAM setzen
   ldr r0, =Dictionarypointer
   ldr r1, =RamDictionaryAnfang
   str r1, [r0]

   @ Fadenende fürs RAM vorbereiten
   ldr r0, =Fadenende
   ldr r1, =CoreDictionaryAnfang
   str r1, [r0]

   @ Vorbereitungen für die Flash-Pointer
   .include "catchflashpointers.s"

   writeln "Mecrisp-Stellaris 0.5 by Matthias Koch"

   @ Genauso wie in quit. Hier nochmal, damit quit nicht nach dem Init-Einsprung nochmal tätig wird.
   ldr r0, =base
   movs r1, #10
   str r1, [r0]

   ldr r0, =state
   movs r1, #0
   str r1, [r0]

   ldr r0, =konstantenfaltungszeiger
   movs r1, #0
   str r1, [r0]


   ldr r0, =init_name
   pushda r0
   bl find
   drop @ Flags brauche ich nicht
   cmp tos, #0
   beq 1f
     @ Gefunden !
     bl execute
     b.n quit_innenschleife
1:
   drop @ Die 0-Adresse von find. Wird hier heruntergeworfen, damit der Startwert AFFEBEEF erhalten bleibt !
   b.n quit

init_name: .byte 4, 105, 110, 105, 116, 0 @ "init"

.ltorg @ Ein letztes Mal Konstanten schreiben

@ -----------------------------------------------------------------------------
@ Speicherkarte für Flash und RAM
@ -----------------------------------------------------------------------------

@ Konstanten für die Größe des Ram-Speichers

.equ RamAnfang, 0x20000000
.equ RamEnde,   0x20008000 @ Für 32 kb Ram.

@ Konstanten für die Größe und Aufteilung des Flash-Speichers

.equ Kernschutzadresse,     0x00004000 @ Darunter wird niemals etwas geschrieben !
.equ FlashDictionaryAnfang, 0x00004000 @ 16 kb für den Kern reserviert...
.equ FlashDictionaryEnde,   0x00040000 @ 240 kb Platz für das Flash-Dictionary frei
.equ Backlinkgrenze,        RamAnfang  @ Ab dem Ram-Start.

@ Makro für die gemütliche Speicherreservierung
@ Speicherstellen beginnen am Anfang des Rams
.set rampointer, RamAnfang          @ Ram-Anfang setzen
.macro ramallot Name, Menge         @ Für Variablen und Puffer zu Beginn des Rams, die im Kern verwendet werden sollen.
  .equ \Name, rampointer            @ Uninitialisiert.
  .set rampointer, rampointer + \Menge
.endm

@ Variablen des Kerns

ramallot Pufferstand, 4
ramallot Dictionarypointer, 4
ramallot Fadenende, 4
ramallot state, 4
ramallot base, 4
ramallot konstantenfaltungszeiger, 4
ramallot leavepointer, 4
ramallot Datenstacksicherung, 4

@ Variablen für das Flashdictionary

ramallot ZweitDictionaryPointer, 4
ramallot ZweitFadenende, 4
ramallot FlashFlags, 4
ramallot VariablenPointer, 4

@ Jetzt kommen Puffer und Stacks:

@ Idee für die Speicherbelegung: 12*4 + 64 + 200 + 256 + 256 + 200 = 1024 Bytes

.equ Zahlenpufferlaenge, 63 @ Zahlenpufferlänge+1 sollte durch 4 teilbar sein !
ramallot Zahlenpuffer, Zahlenpufferlaenge+1 @ Reserviere mal großzügig 64 Bytes RAM für den Zahlenpuffer

.equ maximaleeingabe,    199 @ Eingabepufferlänge+1 sollte durch 4 teilbar sein !
ramallot Eingabepuffer, maximaleeingabe+1 @ Länge des Pufferinhaltes + 1 Längenbyte !

ramallot datenstackende, 256
ramallot datenstackanfang, 0

ramallot returnstackende, 256
ramallot returnstackanfang, 0

ramallot Tokenpuffer, maximaleeingabe+1

.equ RamDictionaryAnfang, rampointer @ Ende der Puffer und Variablen ist Anfang des Ram-Dictionary.
.equ RamDictionaryEnde,   RamEnde    @ Das Ende vom Dictionary ist auch das Ende vom gesamten Ram
