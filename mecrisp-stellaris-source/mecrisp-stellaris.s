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
.fpu softvfp

.thumb
	
.text   /* Hier beginnt das Vergnügen mit der Stackadresse und der Einsprungadresse */


.macro literal register, zahl
  movw \register, #\zahl & 0x0000FFFF
  movt \register, (\zahl & 0xFFFF0000)>>16
.endm

.macro write Meldung
  push {lr}
  bl dotgaensefuesschen	
	.byte 9f - 8f         @ Compute length of name field.
8:	.ascii "\Meldung"
9:	.p2align 1
  pop {lr}
.endm

.macro writeln Meldung
  push {lr}
  bl dotgaensefuesschen 
        .byte 9f - 8f         @ Compute length of name field.
8:      .ascii "\Meldung\n"
9:      .p2align 1
  pop {lr}
.endm

@ -----------------------------------------------------------------------------
@ Interruptvektortabelle
.include "vectors.s"
@ -----------------------------------------------------------------------------


@ Zweiter Versuch, den Datenstack zu implementieren, mit TOS im Register.
@ Achtung: Diese Register sind recht fest eingebaut, nicht versuche, diese auszustauschen.
tos .req r6
psp .req r7

w .req r0
x .req r1
y .req r2

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



.set CoreVariablenPointer, RamDictionaryEnde
.macro CoreVariable, Name @  Benutze den Mechanismus, um initialisierte Variablen zu erhalten.
  .set CoreVariablenPointer, CoreVariablenPointer - 4
  .equ \Name, CoreVariablenPointer
.endm


@.set Latest, 0xFFFFFFFF  @ Zeiger auf das letzte definierte Wort

.set Latest, FlashDictionaryAnfang @ Zeiger auf das letzte definierte Wort
.set Neu,    0xFFFFFFFF            @ Variable für aktuellen Zeiger, am Anfang ungesetzt

@ Defines a Forth word.  Because Forth allows names to contain any
@ non-whitespace character, this macro takes both an assembly-safe label and
@ the "real name" as a string.

.macro Wortbirne Flags, Name
	.p2align 1        @ Auf gerade Adressen ausrichten
        .set Neu, .
        .word \Flags      @ Flags setzen, diesmal 4 Bytes ! Wir haben Platz und Ideen :-)
        .word Latest      @ Link einfügen
        .set Latest, Neu
	.byte 8f - 7f     @ Länge des Namensfeldes berechnen
7:	.ascii "\Name"    @ Namen anfügen
8:	.p2align 1        @ 1 Bit 0 - Wieder gerade machen
.endm

@ Zuerst die Teile, die keine Aufrufe untereinander haben:
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
  .include "compiler-flash.s"

  .ltorg

  .include "controlstructures.s"
  .include "doloop.s"
  .include "case.s"
  .ltorg @ Mal wieder Konstanten schreiben
  .include "token.s"
  .include "numberstrings.s"
  .include "interpreter.s"
  .include "interrupts.s"

.equ CoreDictionaryAnfang, Latest

@ -----------------------------------------------------------------------------
Reset:  @ Einsprung zu Beginn
@ -----------------------------------------------------------------------------
        @ Ram zu Beginn mit -1 füllen, um das Flashdictionary emuliert im Ram großzuziehen.

        ldr r0, =0x20000000
        ldr r1, =0x20008000
        movs r2, #-1
1:      strh r2, [r0]
        adds r0, #2
        cmp r0, r1
        bne 1b

        @ Initialisierungen der Hardware, habe noch keinen Datenstack dafür
        @ bl    gpio_init
        bl      uart_init


Reset_mit_Inhalt:
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

       @ bl words

        @ Vorbereitungen für die Flash-Pointer
        .include "catchflashpointers.s"

  writeln "Mecrisp-Stellaris by Matthias Koch"

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
          b quit_innenschleife
1:      b quit

init_name: .byte 4, 105, 110, 105, 116, 0 @ "init"


.ltorg


@ -----------------------------------------------------------------------------
@ Ram-Speicherkarte
@ -----------------------------------------------------------------------------
        
@ Konstanten
.equ maximaleeingabe,    250
.equ Zahlenpufferlaenge, 60

.equ datenstackende,    0x20000200
.equ datenstackanfang,  0x20000300
@    returnstackende wird nicht geprüft
.equ returnstackanfang, 0x20000400


.equ Kernschutzadresse, 0x00004000 @ Darunter wird niemals etwas geschrieben !

.equ FlashDictionaryAnfang, 0x00004000 @ 16 kb für den Kern reserviert...
.equ FlashDictionaryEnde,   0x00040000 @ 240 kb Platz für das Flash-Dictionary frei


.equ Backlinkgrenze, 0x20000000 @ Ab dem Ram-Start.

.equ RamDictionaryAnfang, 0x20000500 @ 1,25 kb Platz lassen für die Variablen, Puffer und Stacks
.equ RamDictionaryEnde,   0x20008000


@.equ RamDictionaryAnfang, 0x20000500
@.equ RamDictionaryEnde,   0x20004000

@.equ FlashDictionaryAnfang, 0x20005000
@.equ FlashDictionaryEnde,   0x20006000

@.equ FlashDictionaryAnfang, 0x20002000
@.equ FlashDictionaryEnde,   0x20004000

@.equ Backlinkgrenze, 0x20005000 @ Ab dem Ram-Start.

@.equ RamDictionaryAnfang, 0x20005000
@.equ RamDictionaryEnde,   0x20006000

@.equ FlashDictionaryAnfang, 0x00003000 @ 12 kb für den Kern reserviert...
@.equ FlashDicrionaryEnde,   0x00003400 @  1 kb Platz für das Flash-Dictionary frei


@ Speicherstellen
@ .org 0x20000000

@ Variablen des Kerns von $2000:0000 bis $2000:003F --> 64 Bytes

.equ Pufferstand,         0x20000000
.equ Dictionarypointer,   0x20000004
.equ Fadenende,           0x20000008
.equ state,               0x2000000C
.equ base,                0x20000010
.equ konstantenfaltungszeiger, 0x20000014
.equ leavepointer,        0x20000018
.equ Datenstacksicherung, 0x2000001C

@ Variablen für das Flashdictionary

.equ ZweitDictionaryPointer, 0x20000020
.equ ZweitFadenende,         0x20000024
.equ FlashFlags,             0x20000028
.equ VariablenPointer,       0x2000002C




@ Zahlenpuffer folgt gleich darauf
.equ Zahlenpuffer,  0x20000040        @ Reserviere mal großzügig 64 Bytes RAM für den Zahlenpuffer

@ Soweit die inneren "Kleinigkeiten". Habe noch 128 Bytes Luft für dies und das, was vielleicht noch dazukommt.

@ Die großen Sachen folgen ab $2000:0080 und bekommen jeweils 256 Bytes.
@ Lass nochmal ein bisschen Platz für komplizierte Fälle !

@ Eingabepuffer von $2000:0100 bis $2000:0200
.equ Eingabepuffer, 0x20000100
@ Datenstack    von $2000:0200 bis $2000:0300
@ Returnstack   von $2000:0300 bis $2000:0400
@ Tokenpuffer   von $2000:0400 bis $2000:0500
.equ Tokenpuffer,   0x20000400
