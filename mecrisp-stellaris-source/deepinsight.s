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

@ Enthält Routinen, die einen Einblick in das Innenleben ermöglichen.


@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "hex."
hexdot: @ ( u -- ) @ Funktioniert unabhängig vom restlichen Zahlensystem.
@ -----------------------------------------------------------------------------
        push    {r0, r1, lr}
        popda r1 @ Zahl holen
        movs    r0, #32 @ Zahl der Bits, die noch zu bearbeiten sind

1:      subs    r0, #4       @ 4 Bits weniger
        stmdb psp!, {tos}    @ Platz auf dem Stack schaffen

        lsr     tos, r1, r0   @ Schiebe den Wert passend
        ands    tos, #15      @ Eine Hex-Ziffer maskieren
        cmp     tos, #9       @ Ziffer oder Buchstabe ?
        ite     hi
          addhi   tos, #55 @ Passendes Zeichen konstruieren
          addls   tos, #48
        bl      emit
        cmp     r0, #0
        bne     1b

        pop     {r0, r1, lr}
        pushdaconst 32 @ Leerzeichen anfügen
        b emit

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, ".s"
dots: @ Malt den Stackinhalt
@ -----------------------------------------------------------------------------
        push {r0, r1, r2, r3, lr}

        write "Stack: ["

        @ Berechne den Stackfüllstand
        ldr r1, =datenstackanfang @ Anfang laden
        subs r1, psp @ und aktuellen Stackpointer abziehen

@        mov r0, r1 @ erstmal zur Probe ausgeben:
@        pushda r0
@        bl hexdot
@        write "/ 4 = "

        lsrs r1, #2 @ Durch 4 teilen

        mov r0, r1 @ erstmal zur Probe ausgeben:
        pushda r0
        bl hexdot

        write "] "

        @ r1 enthält die Zahl der enthaltenen Elemente.
        cmp r1, #0 @ Bei einem leeren Stack ist nichts auszugeben.
        beq 2f

        ldr r2, =datenstackanfang - 4 @ Anfang laden, wo ich beginne:

1:      @ Hole das Stackelement !
        ldr r0, [r2]
        pushda r0
        bl hexdot

        subs r2, #4
        subs r1, #1
        bne 1b

2:      @ TOS zeigen
        write " TOS: "
        pushda tos
        bl hexdot

        writeln " >"
        pop {r0, r1, r2, r3, pc}


@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "dump" @ ( addr -- ) 
  @ Malt den Speicherinhalt beginnend ab der angegebenen Adresse
@ -----------------------------------------------------------------------------
  push {lr}
  popda r0 @ Adresse holen
  mov r1, #32 @ Zahl der Speicherstellen holen

  writeln " dump>"
1: @ Schleife
  pushda r0
  bl hexdot
  write ": "
  ldrh r2, [r0]
  pushda r2
  bl hexdot
  writeln " >"
  adds r0, #2
  subs r1, #1
  bne 1b

  pop {pc}


@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "words"
words: @ Malt den Dictionaryinhalt
@ -----------------------------------------------------------------------------
  push {lr}
  writeln "words"

  bl dictionarystart
  popda r0

1:   @ Ist an der Stelle der Flags und der Namenslänge $FFFF ? Dann ist der Faden abgelaufen.
     @ Prüfe hier die Namenslänge als Kriterium
     adds r0, #8 @ 4 Bytes Flags 4 Bytes Link
     ldrb r1, [r0] @ Hole Namenslänge
     cmp r1, #0xFF
     beq 2f
     subs r0, #8

        @ Adresse:
        write "Address: "
        pushda r0
        bl hexdot

        @ Flagfeld
        ldrh r1, [r0]
        adds r0, #2
        write "Flags: "
        pushda r1
        bl hexdot

        @ Link
        write "Link: "
        ldr r2, [r0]
        adds r0, #4
        pushda r2
        bl hexdot

        @ Name
        @write "Name: "
        pushda r0 @ Adresse des Namensstrings
        @bl type

        bl skipstring

        @ Einsprungadresse
        write "Code: "
        pushda r0
        bl hexdot

        write "Name: "
        bl type

        pushdaconst 10 @ writeln " :-)"
        bl emit

        @ Link prüfen:
        cmp r2, #-1    @ Ungesetzter Link bedeutet Ende erreicht
        beq 2f

        @ Link folgen
        mov r0, r2
        b 1b      

2:      pop {pc}
