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

@ Interpreter und Optimierungen

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "interpret" @ ( -- )
interpret:
@ -----------------------------------------------------------------------------
  push {r4, r5, lr}

1:@ Bleibe solange in der Schleife, wie token noch etwas zurückliefert.


  @ Probe des Datenstackpointers.

  ldr r0, =datenstackanfang   @ Stacks fangen oben an und wachsen nach unten.
  cmp psp, r0                 @ Wenn die Adresse kleiner oder gleich der Anfangsadresse ist, ist alles okay.
  bls 2f
    Fehler_Quit_n "Stack underflow"

2:ldr r0, =datenstackende     @ Solange der Stackzeiger oberhalb des Endes liegt, ist alles okay.
  cmp psp, r0
  bhs 3f
    Fehler_Quit_N "Stack overflow"

3: @ Alles ok.

  bl token
  @ Prüfe, ob der String leer ist
  popda r0        @ Stringadresse holen
  ldrb r1, [r0]   @ Länge des Strings holen
  cmp r1, #0
  bne 2f
    pop {r4, r5, lr}
    bx lr

2:@ String aus Token angekommen.
  @ ( -- )

  @ Registerkarte:
  @  r0: Stringadresse des Tokens

  @ Konstantenfaltungszeiger setzen, falls er das noch nicht ist.
  ldr r4, =konstantenfaltungszeiger
  ldr r5, [r4]
  cmp r5, #0
  bne 3f
    @ Konstantenfaltungszeiger setzen.
    @ writeln "Konstantenfaltungszeiger setzen"
    mov r5, psp
    str r5, [r4]
3:

  @ Registerkarte:
  @  r0: Stringadresse des Tokens
  @  r4: Adresse des Konstantenfaltungszeigers
  @  r5: Konstantenfaltungszeiger


  @ ( -- )
  pushda r0 @ Stringadresse bereitlegen
  bl find @ Probe, ob es sich um ein Wort aus dem Dictionary handelt:
  @ ( Addr Flags )
  popda r1 @ Flags
  popda r2 @ Addr
  @ ( -- )

  @ Registerkarte:
  @  r0: Stringadresse des Tokens
  @  r1: Flags
  @  r2: Einsprungadresse
  @  r4: Adresse des Konstantenfaltungszeigers
  @  r5: Konstantenfaltungszeiger

  cmp r2, #0
  bne 4f
    @ Nicht gefunden. Ein Fall für Number.
    @ writeln "number"
    pushda r0
    bl number
    popda r2 @ Flag von Number holen
    cmp r2, #0
    bne 1b   @ Zahl gefunden, alles gut. Interpretschleife fortsetzen.

    @ Number mochte das Token auch nicht.
    pushda r0
    bl type
    Fehler_Quit_n " not found."

4:@ Token im Dictionary gefunden.
  @ ( -- )
  ldr r3, =state
  ldr r3, [r3]
  cmp r3, #-1
  beq 5f
    @ writeln "Ausführen"
    @ Im Ausführzustand.
    movs r5, #0   @ Konstantenfaltungszeiger löschen
    str r5, [r4]

    ands r3, r1, #Flag_immediate_compileonly
    cmp r3, #Flag_immediate_compileonly
    bne.n .ausfuehren

      pushda r0
      bl type
      Fehler_Quit_n " is compile-only."

.ausfuehren:
    pushda r2    @ Adresse zum Ausführen
    bl execute
    bl 1b @ Interpretschleife fortsetzen.

  @ Registerkarte:
  @  r0: Stringadresse des Tokens, wird ab hier nicht mehr benötigt.  Wird danach für die Zahl der benötigten Konstanten für die Faltung genutzt.
  @  r1: Flags
  @  r3: Temporärer Register, ab hier: Konstantenfüllstand
  @  r2: Einsprungadresse
  @  r4: Adresse des Konstantenfaltungszeigers.
  @  r5: Konstantenfaltungszeiger

5:@ Im Kompilierzustand.

    @ Prüfe das Ramallot-Flag, das automatisch 0-faltbar bedeutet:
    movs r0, #Flag_ramallot
    ands r0, r1 @ Flagfeld auf Faltbarkeit hin prüfen
    cmp r0, #Flag_ramallot
    beq.n .interpret_faltoptimierung

    @ Bestimme die Anzahl der zur Faltung bereitliegenden Konstanten:

    subs r3, r5, psp @ Konstantenfüllstandszeiger - Aktuellen Stackpointer
    lsrs r3, #2      @ Durch 4 teilen

    @write "Konstantenschreiben-Füllstand: "
    @pushda r3  @ erstmal zur Probe ausgeben:
    @bl hexdot
    @writeln " Elemente."

    @ Prüfe die Faltbarkeit des aktuellen Tokens:
    
    movs r0, #Flag_foldable
    ands r0, r1 @ Flagfeld auf Faltbarkeit hin prüfen
    cmp r0, #Flag_foldable
    bne.n .konstantenschleife

      @writeln "Ist faltbar"
      @ Prüfe, ob genug Konstanten da sind:
      movs r0, #0x0F
      ands r0, r1 @ Zahl der benötigten Konstanten maskieren

    @write "Benötigt "
    @pushda r0  @ erstmal zur Probe ausgeben:
    @bl hexdot
    @writeln " Elemente."

      cmp r3, r0
      blo.n .konstantenschleife

.interpret_faltoptimierung:
       @ writeln "Genug Konstanten. Falte !"
        pushda r2 @ Einsprungadresse bereitlegen
        bl execute @ Durch Ausführung falten
        b 1b @ Interpretschleife weitermachen


.konstantenschleife:
    cmp r3, #0 @ Null Konstanten liegen bereit ?
    beq 7f     @ Dann ist nichts zu tun.

.konstanteninnenschleife:

    @ Schleife über r5 :-)
    subs r3, #1 @ Weil Pick das oberste Element mit Null addressiert.
    pushda r3
    ldr tos, [psp, tos, lsl #2] @ pick
    bl literalkomma
    @ writeln "Konstante geschrieben"
   
    cmp r3, #0
    bne.n .konstanteninnenschleife
   
    @ Die geschriebenen Konstanten herunterwerfen.
    subs r5, #4   @ TOS wurde beim drauflegen der Konstanten gesichert.
    mov psp, r5  @ Pointer zurückholen
    drop         @ Das alte TOS aus seinem Platz auf dem Stack zurückholen.

7:
  @ Ist eine Konstante da, schreibe sie !
  

  movs r5, #0   @ Konstantenfaltungszeiger löschen
  str r5, [r4]

  @ writeln "Kompilieren"

  pushda r2 @ Adresse zum klassischen Bearbeiten.

  ands r2, r1, #Flag_immediate
  cmp r2, #Flag_immediate
  bne 6f
    @ writeln "Immediate"
    @ Es ist immediate. Immer ausführen.
    bl execute @ Ausführen.
    b 1b @ Zurück in die Interpret-Schleife.        

6:ands r2, r1, #Flag_inline
  cmp r2, #Flag_inline
  bne 7f
  
  @ writeln "inline,"
  bl inlinekomma @ Klassisch einkompilieren
  b 1b @ Zurück in die Interpret-Schleife

7:@ writeln "call,"
  bl callkomma @ Klassisch einkompilieren
  b 1b @ Zurück in die Interpret-Schleife

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "quit" @ ( -- )
quit:
@ -----------------------------------------------------------------------------
  @ Endlosschleife - muss LR nicht sichern.
  @ Stacks zurücksetzen
  ldr sp, =returnstackanfang
  ldr psp, =datenstackanfang

  @ Base und State setzen

  ldr r0, =base
  movs r1, #10
  str r1, [r0]

  ldr r0, =state
  movs r1, #0
  str r1, [r0]

  ldr r0, =konstantenfaltungszeiger
  movs r1, #0
  str r1, [r0]

quit_innenschleife:
  bl query
  bl interpret
  writeln " ok."
  b.n quit_innenschleife

@------------------------------------------------------------------------------
@  Wortbirne Flag_visible, "start"
@------------------------------------------------------------------------------
@  b Reset_mit_Inhalt @ Alter Inhalt vom Flash-Dictionary bleibt erhalten :-)
