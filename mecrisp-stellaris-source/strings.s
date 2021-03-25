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

@ Routinen, um mit Strings umzugehen, die aus einem Längenbyte und den folgenden Zeichen bestehen.

.macro lowercase Register @ Ein Zeichen in einem Register wird auf Lowercase umgestellt.
  @    Hex Dec  Hex Dec
  @ A  41  65   61  97  a
  @ Z  5A  90   7A  122 z
  cmp \Register, #0x41
  blo 9f
  cmp \Register, #0x5B
  it lo
  addlo \Register, #0x20
9:  
.endm

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "compare"
compare: @ ( str1 str2 -- f ) Vergleicht zwei Strings
@ -----------------------------------------------------------------------------
        push    {r0, r1, r2, r3, r4}

        popda r0
        popda r1

        ldrb    r2, [r0]          @ Hole das Längenbyte des ersten  Strings
        ldrb    r3, [r1]          @ Hole das Längenbyte des zweiten Strings
  @ writeln "Längenbyte vergleichen"
        cmp     r2, r3            @ Sind sie gleich lang ?
        bne     2f                @ Wenn nicht, sind die Strings ungleich.
  @ writeln "Länge ok"
        @ Länge größer als Null, vergleiche also Byte für Byte.
1:      adds r0, #1                @ Zeiger weiterrücken
        adds r1, #1

        ldrb r3, [r0]             @ Hole ein Zeichen aus dem ersten String
        ldrb r4, [r1]             @ Hole ein Zeichen aus dem zweiten String

  @ Beide Zeichen in Kleinbuchstaben verwandeln.

  lowercase r3
  lowercase r4


  @ writeln "Zeichen vergleichen"
        cmp     r3, r4            @ Sind die Zeichen gleich ?
        bne     2f                @ Wenn nicht, sind die Strings ungleich.

        subs r2, #1                @ Ein Zeichen weniger
        cmp r2, #0                @ Sind noch Zeichen übrig ?
        bne 1b

  @ writeln "Gleich !"
        movs r0, #-1
        pushda r0
        pop     {r0, r1, r2, r3, r4}
        bx lr

2: @ writeln "Ungleich !"
        mov r0, #0
        pushda r0
        pop     {r0, r1, r2, r3, r4}
        bx lr


/*
  ifdef spezialstrings
;------------------------------------------------------------------------------
  Wortbirne Flag_immediate_compileonly, "s\i" ; Dies ist s" und gibt einen Stringpointer zurück.
;------------------------------------------------------------------------------
  push #sgaensefuesschen
  jmp gaensefuesschendetektor

sgaensefuesschen:
  ; Returnstack: ( Stringanfangsadresse-im-Rücksprung )

  ; Adresse des Strings ist in der Rücksprungadresse enthalten.
  pushda @sp ; Lege die Stringadresse für spätere Verwendung bereit.
  ; call #schreibestringmitlaenge ; Das ist der einzige Unterschied zu dotgaensefuesschen.
  jmp dotgaensefuesschen_inneneinsprung

  endif

;------------------------------------------------------------------------------
  Wortbirne Flag_immediate_compileonly, ".\i" ; Dies ist ." und das write von Forth.
;------------------------------------------------------------------------------
  push #dotgaensefuesschen

gaensefuesschendetektor:
  r_from
  call #callkomma

  pushda #34
  call #parse
  br #kommastring

  ; Benutzung:
  ; call #dotgaensefuesschen
  ; .byte Länge, Buchstaben [, 0 um Adresse gerade zu machen]

dotgaensefuesschen:
  ; Returnstack: ( Stringanfangsadresse-im-Rücksprung )

  ; Adresse des Strings ist in der Rücksprungadresse enthalten.
  pushda @sp
  call #schreibestringmitlaenge

dotgaensefuesschen_inneneinsprung:

  pushda @sp+ ; Adresse vom Returnstack auf den Datenstack legen
  call #stringueberlesen ; Rücksprungadresse auf den Befehl nach dem String setzen.
  mov @r4+, pc ; Ret über den Datenstack
*/

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "cr" @ Zeilenumbruch
@ -----------------------------------------------------------------------------
  pushdaconst 10
  b emit

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "bl" @ Leerzeichen-code
@ -----------------------------------------------------------------------------
  pushdaconst 32
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "space" @ Leerzeichen-code
@ -----------------------------------------------------------------------------
  pushdaconst 32
  b emit

@------------------------------------------------------------------------------
  Wortbirne Flag_immediate+Flag_foldable_0, "[char]" @ ( -- )
  @ Holt ein Zeichen aus dem Eingabestrom und fügt es als Literal ein.
@------------------------------------------------------------------------------
  b holechar

@------------------------------------------------------------------------------
  Wortbirne Flag_visible, "char" @ Holt ein Zeichen aus dem Eingabestrom
holechar: @ ( -- Zeichen )
@------------------------------------------------------------------------------
  push {lr}
  bl token    @ Gibt Stringadresse zurück
  adds tos, #1 @ Pointer um eine Stelle auf das erste Zeichen im String weiterschieben.
  ldrb tos, [tos] @ Zeichen an der Stelle holen
  pop {pc}

@ -----------------------------------------------------------------------------
  Wortbirne Flag_immediate|Flag_foldable_0, "(" @ Der Kommentar
@ -----------------------------------------------------------------------------
  push {lr}
  pushdaconst 41 @ Die Klammer )
  bl parse
  drop
  pop {pc}

@ -----------------------------------------------------------------------------
  Wortbirne Flag_immediate|Flag_foldable_0, "\\" @ Der lange Kommentar
@ -----------------------------------------------------------------------------
  push {lr}
  pushdaconst 0 @ Gibt es nicht - immer bis zum Zeilenende
  bl parse
  drop
  pop {pc}

@ -----------------------------------------------------------------------------
  Wortbirne Flag_immediate, ".\"" @ Fügt eine Meldung ein
@ -----------------------------------------------------------------------------
  push {lr}

  ldr r0, =dotgaensefuesschen
  pushda r0
  bl callkomma

  pushdaconst 34 @ Das Gänsefüßchen
  bl parse
    @dup
    @write "Parse lieferte: >"
    @bl type
    @writeln "<"
  bl stringkomma

  pop {pc}

@ -----------------------------------------------------------------------------
  Wortbirne Flag_immediate, "s\"" @ Fügt einen String ein
@ -----------------------------------------------------------------------------
  push {lr}

  ldr r0, =dotfuesschen
  pushda r0
  bl callkomma

  pushdaconst 34 @ Das Gänsefüßchen
  bl parse
    @dup
    @write "Parse lieferte: >"
    @bl type
    @writeln "<"
  bl stringkomma

  pop {pc}

@ -----------------------------------------------------------------------------
dotgaensefuesschen: @ Gibt den inline folgenden String aus und überspringt ihn
@ -----------------------------------------------------------------------------
  @ In lr ist nun die Stringadresse.
@  sub lr, #1
@  pushda lr @ Die Stringanfangsadresse für type - PC ist ungerade im Thumb-Modus !
  

  @ Muss den String überspringen.
  push {r2, r3, r4}

  mov r2, lr
  subs r2, #1
  pushda r2
        ldrb r3, [r2] @ Länge des Strings holen
        adds r3, #1    @ Plus 1 Byte für die Länge
        ands r4, r3, #1 @ Wenn es ungerade ist, noch einen mehr:
        adds r3, r4
        adds lr, r3

  pop {r2, r3, r4}
  b type

@ -----------------------------------------------------------------------------
dotfuesschen: @ Legt den inline folgenden String auf den Stack und überspringt ihn
@ -----------------------------------------------------------------------------
  @ In lr ist nun die Stringadresse.
@  sub lr, #1
@  pushda lr @ Die Stringanfangsadresse für type - PC ist ungerade im Thumb-Modus !
  

  @ Muss den String überspringen.
  push {r2, r3, r4}

  mov r2, lr
  subs r2, #1
  pushda r2
        ldrb r3, [r2] @ Länge des Strings holen
        adds r3, #1    @ Plus 1 Byte für die Länge
        ands r4, r3, #1 @ Wenn es ungerade ist, noch einen mehr:
        adds r3, r4
        adds lr, r3

  pop {r2, r3, r4}
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "type"
type: @ ( str -- ) Gibt einen String aus
@ -----------------------------------------------------------------------------
        push    {r0, r1, r3, lr}
        popda r0

        mov     r3, r0
        @ r3 enthält die Stringadresse.
        @ Hole die auszugebende Länge in r1
        ldrb    r1, [r3]

        @ Wenn nichts da ist, bin ich fertig.
        cmp     r1, #0
        beq     2f

        @ Es ist etwas zum Tippen da !
1:      adds     r3, #1   @ Adresse um eins erhöhen
        ldrb    r0, [r3] @ Zeichen holen
        pushda r0
        bl emit     @ Zeichen senden

        subs    r1, #1   @ Ein Zeichen weniger
        bne     1b

2:      pop     {r0, r1, r3, pc}
