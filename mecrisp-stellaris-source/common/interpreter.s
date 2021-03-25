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
@ Interpreter and optimisations

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "interpret" @ ( -- )
interpret:
@ -----------------------------------------------------------------------------
  push {r4, r5, lr}

1:@ Bleibe solange in der Schleife, wie token noch etwas zurückliefert.
  @ Stay in loop as long token can fetch something from input buffer.

  @ Probe des Datenstackpointers.
  @ Check pointer for datastack.

  ldr r0, =datenstackanfang   @ Stacks fangen oben an und wachsen nach unten.
  cmp psp, r0                 @ Wenn die Adresse kleiner oder gleich der Anfangsadresse ist, ist alles okay.
  bls 2f
    Fehler_Quit_n "Stack underflow"

2:ldr r0, =datenstackende     @ Solange der Stackzeiger oberhalb des Endes liegt, ist alles okay.
  cmp psp, r0
  bhs 3f
    Fehler_Quit_N "Stack overflow"

3: @ Alles ok.  Stacks are fine.

  bl token
  @ Prüfe, ob der String leer ist  Check if token is empty - that designates an empty input buffer.
  popda r0        @ Stringadresse holen
  ldrb r1, [r0]   @ Länge des Strings holen
  cmp r1, #0
  bne 2f
    pop {r4, r5, pc}

@ -----------------------------------------------------------------------------
2:@ String aus Token angekommen.  We have a string to interpret.
  @ ( -- )

  @ Registerkarte:
  @  r0: Stringadresse des Tokens  Address of string

  @ Konstantenfaltungszeiger setzen, falls er das noch nicht ist.
  @ Set Constant-Folding-Pointer
  ldr r4, =konstantenfaltungszeiger
  ldr r5, [r4]
  cmp r5, #0
  bne 3f
    @ Konstantenfaltungszeiger setzen.
    @ If not set yet, set it now.
    movs r5, psp
    str r5, [r4]
3:

  @ Registerkarte:
  @  r0: Stringadresse des Tokens               Address of string
  @  r4: Adresse des Konstantenfaltungszeigers  Address of constant folding pointer
  @  r5: Konstantenfaltungszeiger               Constant folding pointer


  @ ( -- )
  pushda r0 @ Stringadresse bereitlegen  Put string address on datastack
  bl find @ Probe, ob es sich um ein Wort aus dem Dictionary handelt:  Attemp to find token in dictionary.
  @ ( Addr Flags )
  popda r1 @ Flags
  popda r2 @ Addr
  @ ( -- )

  @ Registerkarte:
  @  r0: Stringadresse des Tokens               Address of string
  @  r1: Flags                                  Flags
  @  r2: Einsprungadresse                       Code entry point
  @  r4: Adresse des Konstantenfaltungszeigers  Address of constant folding pointer
  @  r5: Konstantenfaltungszeiger               Constant folding pointer

  cmp r2, #0
  bne 4f
    @ Nicht gefunden. Ein Fall für Number.
    @ Entry-Address is zero if not found ! Note that Flags have very special meanings in Mecrisp !
    pushda r0
    bl number

  @ Number gives back ( 0 ) or ( x 1 ).
  @ Zero means: Not recognized.
  @ Note that literals actually are not written/compiled here.
  @ They are simply placed on stack and constant folding takes care of them later.

    popda r2   @ Flag von Number holen
    cmp r2, #0 @ Did number recognize the string ?
    bne 1b     @ Zahl gefunden, alles gut. Interpretschleife fortsetzen.  Finished.

    @ Number mochte das Token auch nicht.
    pushda r0
    bl type
    Fehler_Quit_n " not found."

@ -----------------------------------------------------------------------------
4:@ Token im Dictionary gefunden. Found token in dictionary. Decide what to do.
  @ ( -- )
  ldr r3, =state
  ldr r3, [r3]
  cmp r3, #0
  bne 5f
    @ Im Ausführzustand.  Execute.
    movs r5, #0   @ Konstantenfaltungszeiger löschen  Clear constant folding pointer
    str r5, [r4]  @ Do not collect literals for folding in execute mode. They simply stay on stack.

    .ifdef m0core
    movs r3, #Flag_immediate_compileonly
    ands r3, r1
    .else
    ands r3, r1, #Flag_immediate_compileonly
    .endif
    cmp r3, #Flag_immediate_compileonly
    bne.n .ausfuehren

      pushda r0
      bl type
      Fehler_Quit_n " is compile-only."

.ausfuehren:
    pushda r2    @ Adresse zum Ausführen   Code entry point
    bl execute   @                         Execute it
    bl 1b @ Interpretschleife fortsetzen.  Finished.

  @ Registerkarte:
  @  r0: Stringadresse des Tokens, wird ab hier nicht mehr benötigt.  
  @      Wird danach für die Zahl der benötigten Konstanten für die Faltung genutzt.
  @      From now on, this is number of constants that would be needed for folding this definition
  @  r1: Flags
  @  r3: Temporärer Register, ab hier: Konstantenfüllstand  Constant fill gauge of Datastack
  @  r2: Einsprungadresse                        Code entry point
  @  r4: Adresse des Konstantenfaltungszeigers.  Address of constant folding pointer
  @  r5: Konstantenfaltungszeiger                Constant folding pointer

@ -----------------------------------------------------------------------------
5:@ Im Kompilierzustand.  In compile state.

    @ Prüfe das Ramallot-Flag, das automatisch 0-faltbar bedeutet:
    @ Ramallot-Words always are 0-foldable !
    @ Check this first, as Ramallot is set together with foldability,
    @ but the meaning of the lower 4 bits is different.

    movs r0, #Flag_ramallot
    ands r0, r1 @ Flagfeld auf Faltbarkeit hin prüfen
    cmp r0, #Flag_ramallot
    beq.n .interpret_faltoptimierung

    @ Bestimme die Anzahl der zur Faltung bereitliegenden Konstanten:
    @ Calculate number of folding constants available.

    subs r3, r5, psp @ Konstantenfüllstandszeiger - Aktuellen Stackpointer
    lsrs r3, #2      @ Durch 4 teilen  Divide by 4 to get number of stack elements.
    @ Number of folding constants now available in r3.

    @ Prüfe die Faltbarkeit des aktuellen Tokens:
    @ Check for foldability.
    
    movs r0, #Flag_foldable
    ands r0, r1 @ Flagfeld auf Faltbarkeit hin prüfen
    cmp r0, #Flag_foldable
    bne.n .konstantenschleife

      @ Prüfe, ob genug Konstanten da sind:
      @ How many constants are necessary to fold this word ?
      movs r0, #0x0F
      ands r0, r1 @ Zahl der benötigten Konstanten maskieren

      cmp r3, r0
      blo.n .konstantenschleife

.interpret_faltoptimierung:
        @ Do folding by running the definition. 
        @ Note that Constant-Folding-Pointer is already set to keep track of results calculated.
        pushda r2 @ Einsprungadresse bereitlegen  Code entry point
        bl execute @ Durch Ausführung falten      Fold by executing
        b 1b @ Interpretschleife weitermachen     Finished.

    @ No optimizations possible. Compile the normal way.
    @ Write all folding constants left into dictionary.

.konstantenschleife:
    cmp r3, #0 @ Null Konstanten liegen bereit ? Zero constants available ?
    beq 7f     @ Dann ist nichts zu tun.         Nothing to write.

.konstanteninnenschleife:
    @ Schleife über r5 :-)
    @ Loop for writing all folding constants left.
    subs r3, #1 @ Weil Pick das oberste Element mit Null addressiert.

    .ifdef m0core
    pushdatos
    lsls tos, r3, #2
    ldr tos, [psp, tos]    
    .else
    pushda r3
    ldr tos, [psp, tos, lsl #2] @ pick
    .endif

    bl literalkomma
   
    cmp r3, #0
    bne.n .konstanteninnenschleife
   
    @ Die geschriebenen Konstanten herunterwerfen.
    @ Drop constants written.
    subs r5, #4  @ TOS wurde beim drauflegen der Konstanten gesichert.
    movs psp, r5  @ Pointer zurückholen
    drop         @ Das alte TOS aus seinem Platz auf dem Stack zurückholen.

7:movs r5, #0   @ Konstantenfaltungszeiger löschen  Clear constant folding pointer.
  str r5, [r4]

@ -----------------------------------------------------------------------------
  @ Classic compilation.
  pushda r2 @ Adresse zum klassischen Bearbeiten. Put code entry point on datastack.

  .ifdef m0core
  movs r2, #Flag_immediate
  ands r2, r1
  .else
  ands r2, r1, #Flag_immediate
  .endif

  cmp r2, #Flag_immediate
  bne 6f
    @ Es ist immediate. Immer ausführen. Always execute immediate definitions.
    bl execute @ Ausführen.
    b 1b @ Zurück in die Interpret-Schleife.  Finished.

6:
  .ifdef m0core
  movs r2, #Flag_inline
  ands r2, r1
  .else
  ands r2, r1, #Flag_inline
  .endif
  cmp r2, #Flag_inline
  bne 7f
  
  bl inlinekomma @ Direkt einfügen.        Inline the code
  b 1b @ Zurück in die Interpret-Schleife  Finished.

7:bl callkomma @ Klassisch einkompilieren  Simply compile a BL or Call.
  b 1b @ Zurück in die Interpret-Schleife  Finished.

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "quit" @ ( -- )
quit:
@ -----------------------------------------------------------------------------
  @ Endlosschleife - muss LR nicht sichern.  No need for saving LR as this is an endless loop.
  @ Stacks zurücksetzen
  @ Clear stacks and tidy up.
  .ifdef m0core
  ldr r0, =returnstackanfang
  mov sp, r0
  .else
  ldr sp, =returnstackanfang
  .endif

  ldr psp, =datenstackanfang

   @ Clear 16-Bit Flash write emulation value-and-location collection table
  .ifdef emulated16bitflashwrites
   bl sammeltabelleleeren
  .endif

  @ Base und State setzen

  ldr r0, =base
  movs r1, #10   @ Base decimal
  str r1, [r0]

  ldr r0, =state
  movs r1, #0    @ Execute mode
  str r1, [r0]

  ldr r0, =konstantenfaltungszeiger
  movs r1, #0    @ Clear constant folding pointer
  str r1, [r0]

quit_innenschleife:  @ Main loop of Forth system.
  bl query
  bl interpret
  writeln " ok."
  b.n quit_innenschleife
