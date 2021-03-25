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
        push    {r0, r1, r2, r3, r4, r5, lr}
        popda r0
        mov     r5, r0
        movs    r4, #32
1:
        subs    r4, r4, #4
        lsr     r3, r5, r4
        and     r1, r3, #15
        cmp     r1, #9
        ite     hi
        addhi   r0, r1, #55
        addls   r0, r1, #48
        pushda  r0
        bl      emit
        cmp     r4, #0
        bne     1b

        movs    r0, #32 @ Leerzeichen anfügen
        pushda  r0
        pop     {r0, r1, r2, r3, r4, r5, lr}
        b       emit

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, ".s"
dots: @ Malt den Stackinhalt
@ -----------------------------------------------------------------------------
        push {r0, r1, r2, r3, lr}

        write "Stack: ["

        @ Berechne den Stackfüllstand
        ldr r1, =datenstackanfang @ Anfang laden
        sub r1, psp @ und aktuellen Stackpointer abziehen

        mov r0, r1 @ erstmal zur Probe ausgeben:
        pushda r0
        bl hexdot

        write "/ 4 = "

        lsr r1, r1, #2 @ Durch 4 teilen

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

        sub r2, #4
        sub r1, #1
        cmp r1, #0
        bne 1b

2:      @ TOS zeigen
        write " TOS: "
        pushda tos
        bl hexdot

        writeln " >"
        pop {r0, r1, r2, r3, pc}


@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "dump" @ ( addr -- ) 
dump: @ Malt den Speicherinhalt beginnend ab der angegebenen Adresse
@ -----------------------------------------------------------------------------
  push {r0, r1, r2, lr}
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
  add r0, #2
  subs r1, #1
  bne 1b

  pop {r0, r1, r2, pc}

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "words"
words: @ Malt den Dictionaryinhalt
@ -----------------------------------------------------------------------------
        push {r0, r1, r2, r3, r4, lr}
        writeln "words"

  bl dictionarystart
  popda r0


1:   @ Ist an der Stelle der Flags und der Namenslänge $FFFF ? Dann ist der Faden abgelaufen.
     @ Prüfe hier die Namenslänge als Kriterium
     add r0, #8 @ 4 Bytes Flags 4 Bytes Link
     ldrb r1, [r0] @ Hole Namenslänge
     cmp r1, #0xFF
     beq 2f
     sub r0, #8

        @ Adresse:
        write "Address: "
        pushda r0
        bl hexdot

        @ Flagfeld
        ldr r1, [r0]
        add r0, #4
        write "Flags: "
        pushda r1
        bl hexdot

        @ Link
        write "Link: "
        ldr r2, [r0]
        add r0, #4
        pushda r2
        bl hexdot

        @ Name
        @write "Name: "
        pushda r0
        @bl type

        ldrb r3, [r0] @ Länge des Strings holen
        add r3, #1    @ Plus 1 Byte für die Länge
        and r4, r3, #1 @ Wenn es ungerade ist, noch einen mehr:
        add r3, r4
        add r0, r3

        @ Einsprungadresse
        write "Code: "
        pushda r0
        bl hexdot

        write "Name: "
        bl type

        pushdaconst 10
        bl emit
        @writeln " :-)"

        @ Link prüfen:
        cmp r2, #-1    @ Ungesetzter Link bedeutet Ende erreicht
        beq 2f

        @ Link folgen
        mov r0, r2
        b 1b      

2:      pop {r0, r1, r2, r3, r4, pc}
 
