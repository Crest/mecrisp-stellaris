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

@ Speicherzugriffe aller Art
@ Wie beim MSP430 gewohnt nun auch interruptsicher :-)

@------------------------------------------------------------------------------
  Wortbirne Flag_visible, "move"
move:  @ ( Quelladdr Zieladdr Byteanzahl -- )
       @ Kopiert einen Datensatz an eine neue Stelle.
       @ Kann noch nicht vorwärts und rückwärts kopieren, und so können sich die Speicherbereiche nicht überlappen.
       @ Nur für internen Gebrauch bestimmt, bis alles geklärt ist.
@------------------------------------------------------------------------------
  push {r0, r1, r2, r3, lr}

  popda r2 @ Count
  popda r1 @ Zieladresse
  popda r0 @ Quelladresse

  cmp r2, #0      @ Prüfe, ob die Anzahl der zu kopierenden Bytes Null ist.
  beq.n move_fertig @ Wenn ja, bin ich fertig.


  cmp r1, r0      @ Quelle und Ziel vergleichen
  beq.n move_fertig @ Sind sie gleich, bin ich fertig.

/*
  blo move_vorwaerts @ Mindestens ein Byte ist noch zu kopieren. 

  @------------------------------------------------------------------------------
  @ Move-Rückwärts  Wenn die Quelladresse kleiner ist als die Zieladresse
  writeln "Quelle<Ziel"

  add r0, r2
  add r1, r2

1:ldrb r3, [r0] @ Von der Quelladresse an die Zieladresse kopieren
  strb r3, [r1]
  pushda r3
  writeln " rück"
  sub  r0, #1  @ Quelladresse erniedrigen
  sub  r1, #1  @  Zieladresse erniedrigen
  subs r2, #1  @ Zahl der noch zu kopierenden Bytes erniedrigen
  bne 1b       @ Sind noch welche übrig ?

  b move_fertig

  @------------------------------------------------------------------------------
  @ Move-Vorwärts  Wenn die Quelladresse größer ist als die Zieladresse
move_vorwaerts:
  writeln "Quelle>Ziel"

*/

2:ldrb r3, [r0] @ Von der Quelladresse an die Zieladresse kopieren
  strb r3, [r1]
  adds  r0, #1  @ Quelladresse erhöhen
  adds  r1, #1  @  Zieladresse erhöhen
  subs r2, #1  @ Zahl der noch zu kopierenden Bytes erniedrigen
  bne 2b       @ Sind noch welche übrig ?

move_fertig:
  pop {r0, r1, r2, r3, pc}

@ 

/*

: create> <builds does> ;  create> Puffer 1 c, 2 c, 3 c, 4 c, 5 c,  puffer dump   puffer 1 +  puffer 2 + 2 move   puffer dump
: create> <builds does> ;  create> Puffer 1 c, 2 c, 3 c, 4 c, 5 c,  puffer dump   puffer 1 +  puffer     2 move   puffer dump

*/

@ -----------------------------------------------------------------------------
  Wortbirne Flag_inline, "@" @ ( 32-addr -- x )
                              @ Loads the cell at 'addr'.
@ -----------------------------------------------------------------------------
  ldr tos, [tos]
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_inline, "!" @ ( x 32-addr -- )
@ Given a value 'x' and a cell-aligned address 'addr', stores 'x' to memory at 'addr', consuming both.
@ -----------------------------------------------------------------------------
  ldm psp!, {w, x} @ X is the new TOS after the store completes.
  str w, [tos]     @ Popping both saves a cycle.
  mov tos, x
  bx lr


@ -----------------------------------------------------------------------------
@  Wortbirne Flag_visible, "+!" @ ( x 32-addr -- )
@                               @ Adds 'x' to the memory cell at 'addr'.
@ -----------------------------------------------------------------------------
@  ldm psp!, {w, x} @ X is the new TOS after the store completes.
@  ldr y, [tos]       @ Load the current cell value
@  adds y, w            @ Do the add
@  str y, [tos]       @ Store it back
@  mov tos, x
@  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "+!" @ ( x 32-addr -- )
                               @ Adds 'x' to the memory cell at 'addr'.
@ -----------------------------------------------------------------------------
  ldm psp!, {w, x} @ X is the new TOS after the store completes.

1:  ldrex y, [tos]       @ Load the current cell value
    adds y, w            @ Do the add
    strex r3, y, [tos]   @ Store it back
    cmp r3, #0
    bne 1b

  mov tos, x
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_inline, "h@" @ ( 16-addr -- x )
                              @ Loads the half-word at 'addr'.
@ -----------------------------------------------------------------------------
  ldrh tos, [tos]
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_inline, "h!" @ ( x 16-addr -- )
@ Given a value 'x' and an 16-bit-aligned address 'addr', stores 'x' to memory at 'addr', consuming both.
@ -----------------------------------------------------------------------------
  ldm psp!, {w, x} @ X is the new TOS after the store completes.
  strh w, [tos]     @ Popping both saves a cycle.
  mov tos, x
  bx lr

@ -----------------------------------------------------------------------------
@  Wortbirne Flag_visible, "h+!" @ ( x 16-addr -- )
@                               @ Adds 'x' to the memory cell at 'addr'.
@ -----------------------------------------------------------------------------
@  ldm psp!, {w, x} @ X is the new TOS after the store completes.
@  ldrh y, [tos]       @ Load the current cell value
@  adds y, w            @ Do the add
@  strh y, [tos]       @ Store it back
@  mov tos, x
@  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "h+!" @ ( x 16-addr -- )
                               @ Adds 'x' to the memory cell at 'addr'.
@ -----------------------------------------------------------------------------
  ldm psp!, {w, x} @ X is the new TOS after the store completes.

1:  ldrexh y, [tos]       @ Load the current cell value
    adds y, w            @ Do the add
    strexh r3, y, [tos]   @ Store it back
    cmp r3, #0
    bne 1b

  mov tos, x
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_inline, "c@" @ ( 8-addr -- x )
                              @ Loads the byte at 'addr'.
@ -----------------------------------------------------------------------------
  ldrb tos, [tos]
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_inline, "c!" @ ( x 8-addr -- )
@ Given a value 'x' and an 8-bit-aligned address 'addr', stores 'x' to memory at 'addr', consuming both.
@ -----------------------------------------------------------------------------
  ldm psp!, {w, x} @ X is the new TOS after the store completes.
  strb w, [tos]     @ Popping both saves a cycle.
  mov tos, x
  bx lr

@ -----------------------------------------------------------------------------
@  Wortbirne Flag_visible, "c+!" @ ( x 8-addr -- )
@                               @ Adds 'x' to the memory cell at 'addr'.
@ -----------------------------------------------------------------------------
@  ldm psp!, {w, x} @ X is the new TOS after the store completes.
@  ldrb y, [tos]       @ Load the current cell value
@  adds y, w            @ Do the add
@  strb y, [tos]       @ Store it back
@  mov tos, x
@  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "c+!" @ ( x 8-addr -- )
                               @ Adds 'x' to the memory cell at 'addr'.
@ -----------------------------------------------------------------------------
  ldm psp!, {w, x} @ X is the new TOS after the store completes.

1:  ldrexb y, [tos]       @ Load the current cell value
    adds y, w            @ Do the add
    strexb r3, y, [tos]   @ Store it back
    cmp r3, #0
    bne 1b

  mov tos, x
  bx lr

/*
@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "bis!" @ ( x 32-addr -- )
  @ Setzt die Bits in der Speicherstelle
@ -----------------------------------------------------------------------------
  ldm psp!, {w, x} @ X is the new TOS after the store completes.
  ldr y, [tos] @ Alten Inhalt laden
  orrs y, w     @ Hinzuverodern
  str y, [tos] @ Zurückschreiben
  mov tos, x
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "bic!" @ ( x 32-addr -- )
  @ Löscht die Bits in der Speicherstelle
@ -----------------------------------------------------------------------------
  ldm psp!, {w, x} @ X is the new TOS after the store completes.
  ldr y, [tos] @ Alten Inhalt laden
  bics y, w     @ Bits löschen
  str y, [tos] @ Zurückschreiben
  mov tos, x
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "xor!" @ ( x 32-addr -- )
  @ Wechselt die Bits in der Speicherstelle
@ -----------------------------------------------------------------------------
  ldm psp!, {w, x} @ X is the new TOS after the store completes.
  ldr y, [tos] @ Alten Inhalt laden
  eors y, w     @ Bits umkehren
  str y, [tos] @ Zurückschreiben
  mov tos, x
  bx lr
*/

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "bis!" @ ( x 32-addr -- )
  @ Setzt die Bits in der Speicherstelle
@ -----------------------------------------------------------------------------
  ldm psp!, {w, x} @ X is the new TOS after the store completes.

1:  ldrex y, [tos]       @ Load the current cell value
    orrs y, w            @ Set Bits
    strex r3, y, [tos]   @ Store it back
    cmp r3, #0
    bne 1b

  mov tos, x
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "bic!" @ ( x 32-addr -- )
  @ Löscht die Bits in der Speicherstelle
@ -----------------------------------------------------------------------------
  ldm psp!, {w, x} @ X is the new TOS after the store completes.

1:  ldrex y, [tos]       @ Load the current cell value
    bics y, w            @ Clear Bits
    strex r3, y, [tos]   @ Store it back
    cmp r3, #0
    bne 1b

  mov tos, x
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "xor!" @ ( x 32-addr -- )
  @ Wechselt die Bits in der Speicherstelle
@ -----------------------------------------------------------------------------
  ldm psp!, {w, x} @ X is the new TOS after the store completes.

1:  ldrex y, [tos]       @ Load the current cell value
    eors y, w            @ Toggle Bits
    strex r3, y, [tos]   @ Store it back
    cmp r3, #0
    bne 1b

  mov tos, x
  bx lr


@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible|Flag_inline, "bit@" @ ( x 32-addr -- )
  @ Prüft, ob Bits in der Speicherstelle gesetzt sind
@ -----------------------------------------------------------------------------
/*
  ldm psp!, {x} @ Bitmaske holen
  ldr y, [tos]  @ Speicherinhalt holen
  ands x, y      @ Bleibt nach AND etwas über ?
  ite eq
  moveq tos, #0
  movne tos, #-1
  bx lr
*/


  ldm psp!, {w}  @ Bitmaske holen
  ldr tos, [tos] @ Speicherinhalt holen
  ands tos, w    @ Bleibt nach AND etwas über ?
  it ne
  movne tos, #-1 @ Bleibt etwas über, mache ein ordentliches true-Flag daraus.
  bx lr


/*
@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "hbis!" @ ( x 16-addr -- )
  @ Setzt die Bits in der Speicherstelle
@ -----------------------------------------------------------------------------
  ldm psp!, {w, x} @ X is the new TOS after the store completes.
  ldrh y, [tos] @ Alten Inhalt laden
  orrs y, w     @ Hinzuverodern
  strh y, [tos] @ Zurückschreiben
  mov tos, x
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "hbic!" @ ( x 16-addr -- )
  @ Setzt die Bits in der Speicherstelle
@ -----------------------------------------------------------------------------
  ldm psp!, {w, x} @ X is the new TOS after the store completes.
  ldrh y, [tos] @ Alten Inhalt laden
  bics y, w     @ Hinzuverodern
  strh y, [tos] @ Zurückschreiben
  mov tos, x
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "hxor!" @ ( x 16-addr -- )
  @ Setzt die Bits in der Speicherstelle
@ -----------------------------------------------------------------------------
  ldm psp!, {w, x} @ X is the new TOS after the store completes.
  ldrh y, [tos] @ Alten Inhalt laden
  eors y, w     @ Hinzuverodern
  strh y, [tos] @ Zurückschreiben
  mov tos, x
  bx lr
*/

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "hbis!" @ ( x 16-addr -- )
  @ Setzt die Bits in der Speicherstelle
@ -----------------------------------------------------------------------------
  ldm psp!, {w, x} @ X is the new TOS after the store completes.

1:  ldrexh y, [tos]       @ Load the current cell value
    orrs y, w            @ Set Bits
    strexh r3, y, [tos]   @ Store it back
    cmp r3, #0
    bne 1b

  mov tos, x
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "hbic!" @ ( x 16-addr -- )
  @ Löscht die Bits in der Speicherstelle
@ -----------------------------------------------------------------------------
  ldm psp!, {w, x} @ X is the new TOS after the store completes.

1:  ldrexh y, [tos]       @ Load the current cell value
    bics y, w            @ Clear Bits
    strexh r3, y, [tos]   @ Store it back
    cmp r3, #0
    bne 1b

  mov tos, x
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "hxor!" @ ( x 16-addr -- )
  @ Wechselt die Bits in der Speicherstelle
@ -----------------------------------------------------------------------------
  ldm psp!, {w, x} @ X is the new TOS after the store completes.

1:  ldrexh y, [tos]       @ Load the current cell value
    eors y, w            @ Toggle Bits
    strexh r3, y, [tos]   @ Store it back
    cmp r3, #0
    bne 1b

  mov tos, x
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible|Flag_inline, "hbit@" @ ( x 16-addr -- )
  @ Prüft, ob Bits in der Speicherstelle gesetzt sind
@ -----------------------------------------------------------------------------
/*
  ldm psp!, {x} @ Bitmaske holen
  ldrh y, [tos]  @ Speicherinhalt holen
  ands x, y      @ Bleibt nach AND etwas über ?
  ite eq
  moveq tos, #0
  movne tos, #-1
  bx lr
*/

  ldm psp!, {w}  @ Bitmaske holen
  ldrh tos, [tos] @ Speicherinhalt holen
  ands tos, w    @ Bleibt nach AND etwas über ?
  it ne
  movne tos, #-1 @ Bleibt etwas über, mache ein ordentliches true-Flag daraus.
  bx lr

/*
@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "cbis!" @ ( x 8-addr -- )
  @ Setzt die Bits in der Speicherstelle
@ -----------------------------------------------------------------------------
  ldm psp!, {w, x} @ X is the new TOS after the store completes.
  ldrb y, [tos] @ Alten Inhalt laden
  orrs y, w     @ Hinzuverodern
  strb y, [tos] @ Zurückschreiben
  mov tos, x
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "cbic!" @ ( x 8-addr -- )
  @ Setzt die Bits in der Speicherstelle
@ -----------------------------------------------------------------------------
  ldm psp!, {w, x} @ X is the new TOS after the store completes.
  ldrb y, [tos] @ Alten Inhalt laden
  bics y, w     @ Hinzuverodern
  strb y, [tos] @ Zurückschreiben
  mov tos, x
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "cxor!" @ ( x 8-addr -- )
  @ Setzt die Bits in der Speicherstelle
@ -----------------------------------------------------------------------------
  ldm psp!, {w, x} @ X is the new TOS after the store completes.
  ldrb y, [tos] @ Alten Inhalt laden
  eors y, w     @ Hinzuverodern
  strb y, [tos] @ Zurückschreiben
  mov tos, x
  bx lr
*/

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "cbis!" @ ( x 8-addr -- )
  @ Setzt die Bits in der Speicherstelle
@ -----------------------------------------------------------------------------
  ldm psp!, {w, x} @ X is the new TOS after the store completes.

1:  ldrexb y, [tos]       @ Load the current cell value
    orrs y, w            @ Set Bits
    strexb r3, y, [tos]   @ Store it back
    cmp r3, #0
    bne 1b

  mov tos, x
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "cbic!" @ ( x 8-addr -- )
  @ Löscht die Bits in der Speicherstelle
@ -----------------------------------------------------------------------------
  ldm psp!, {w, x} @ X is the new TOS after the store completes.

1:  ldrexb y, [tos]       @ Load the current cell value
    bics y, w            @ Clear Bits
    strexb r3, y, [tos]   @ Store it back
    cmp r3, #0
    bne 1b

  mov tos, x
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "cxor!" @ ( x 8-addr -- )
  @ Wechselt die Bits in der Speicherstelle
@ -----------------------------------------------------------------------------
  ldm psp!, {w, x} @ X is the new TOS after the store completes.

1:  ldrexb y, [tos]       @ Load the current cell value
    eors y, w            @ Toggle Bits
    strexb r3, y, [tos]   @ Store it back
    cmp r3, #0
    bne 1b

  mov tos, x
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible|Flag_inline, "cbit@" @ ( x 8-addr -- )
  @ Prüft, ob Bits in der Speicherstelle gesetzt sind
@ -----------------------------------------------------------------------------
/*
  ldm psp!, {x} @ Bitmaske holen
  ldrb y, [tos]  @ Speicherinhalt holen
  ands x, y      @ Bleibt nach AND etwas über ?
  ite eq
  moveq tos, #0
  movne tos, #-1
  bx lr
*/

  ldm psp!, {w}  @ Bitmaske holen
  ldrb tos, [tos] @ Speicherinhalt holen
  ands tos, w    @ Bleibt nach AND etwas über ?
  it ne
  movne tos, #-1 @ Bleibt etwas über, mache ein ordentliches true-Flag daraus.
  bx lr
