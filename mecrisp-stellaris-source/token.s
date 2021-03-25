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

@ Token und Parse zum Zerlegen des Eingabepuffers

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "token" @ ( -- Addr )
token:
@ -----------------------------------------------------------------------------
  mov r0, #32 @ Leerzeichen
  pushda r0
  b parse

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "parse" @ ( c -- Addr )
parse:
@ -----------------------------------------------------------------------------
  push {lr}
  @ Mal ein ganz anderer Ansatz:
  @ Der Eingabepuffer bleibt die ganze Zeit unverändert.
  @ Pufferstand gibt einfach einen Offset in den Eingabepuffer, der zeigt, wie viele Zeichen schon verbraucht worden sind.
  @ Zu Beginn ist der Pufferstand 0.
  @ Sind alle Zeichen verbraucht, ist der Pufferstand gleich der Länge des Eingabepuffers.

  @ Kopiere die Zeichen in den Tokenpuffer.

  ldr r0, =Eingabepuffer @ Pointer auf den Eingabepuffer
  ldrb r1, [r0]          @ Länge des Eingabepuffers

  ldr r2, =Pufferstand
  ldrb r2, [r2]          @ Aktuellen Pufferstand

  ldr r3, =Tokenpuffer   @ Pointer für den Sammelpuffer
  mov r4, #0             @ Zahl der aktuell gesammelten Zeichen

  @ TOS                  @ Gesuchtes Trennzeichen

@  write "Parse: "
@  pushda r2
@  bl hexdot
@  writeln " ist der Pufferstand"

  @ Beginne beim Pufferstand:
  add r0, r2 @ Aktuellen Pufferstand zum Pointer hinzuaddieren



  @ Speziell for Token, falls das Trennzeichen das Leerzeichen ist:
  cmp tos, #32
  bne 2f
  @ Führende Leerzeichen abtrennen.

4:  cmp r1, r2 @ Ist noch etwas da ?
    beq 3f

    @ Hole ein Zeichen.  
    add r0, #1 @ Eingabepufferzeiger um ein Zeichen weiterrücken.
    add r2, #1 @ Pufferstand um ein Zeichen weiterschieben
@    writeln "Hole vorab"
    @ Hole an der Stelle ein Zeichen und entscheide, was damit zu tun ist.
    ldrb r5, [r0]
    cmp r5, tos @ Ist es das Leerzeichen ?
    beq 4b @ Führende Leerzeichen nicht Sammeln.
    b 5f   @ Ist es etwas anderes, dann beginne zu Sammeln.




2: @ Sammelschleife.

  @ Erster Schritt: Ist noch etwas zum Sammeln da ?
  cmp r1, r2
  beq 3f

  @ Zweiter Schritt: Hole ein Zeichen.  
  add r0, #1 @ Eingabepufferzeiger um ein Zeichen weiterrücken.
  add r2, #1 @ Pufferstand um ein Zeichen weiterschieben
@  writeln "Hole"
  @ Hole an der Stelle ein Zeichen und entscheide, was damit zu tun ist.
  ldrb r5, [r0]
  cmp r5, tos    @ Wenn das Trennzeichen erreicht ist, höre auf.
  beq 3f

5: @ Wenn es mir gefällt, nimm es in den Tokenpuffer auf.
  add r3, #1 @ Pointer weiterschieben
  add r4, #1 @ Zahl der gesammelten Zeichen weiterschieben
  strb r5, [r3]
@  writeln "Sammele"
  b 2b @ Sammelschleife


3: @ Fertig, entweder nichts mehr da, oder Trennzeichen gefunden.
  ldr r0, =Pufferstand
  strb r2, [r0]         @ Aktuellen Pufferstand vermerken.

  ldr r3, =Tokenpuffer @ Zahl der gesammelten Zeichen vermerken
  strb r4, [r3]

  mov tos, r3 @ Tokenpufferadresse zurückgeben

  pop {lr}
  bx lr
 
