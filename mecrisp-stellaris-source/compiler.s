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

@ Die Routinen, die nötig sind, um neue Definitionen zu kompilieren.


@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "here" @ ( -- addr ) 
here: @ Gibt den Dictionarypointer zurück
@ -----------------------------------------------------------------------------
  stmdb psp!, {tos}    @ Platz auf dem Datenstack schaffen 
  ldr tos, =Dictionarypointer
  ldr tos, [tos] @ Hole den Dictionarypointer
  bx lr

@------------------------------------------------------------------------------
  Wortbirne Flag_immediate|Flag_foldable_0, "[']" @ Sucht das nächste Wort im Eingabestrom
@------------------------------------------------------------------------------
  b.n tick @ So sah das mal aus: ['] ' immediate 0-foldable ;

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "'"
tick: @ Nimmt das nächste Token aus dem Puffer,
        @ erstellt einen neuen Kopf im Dictionary und verlinkt ihn.
@ -----------------------------------------------------------------------------
  push {lr}
  bl token @ Hole den Namen der neuen Definition.
  @ ( Tokenadresse )

  @ Überprüfe, ob der Token leer ist.
  @ Das passiert, wenn der Eingabepuffer nach create leer ist.

  popda r0
  ldrb r1, [r0]
  cmp r1, #0
  bne 1f

    @ Token ist leer. Brauche Stacks nicht zu putzen.
    Fehler_Quit " ' needs name !"

1:@ Tokenname ist okay.
  @ Prüfe, ob er schon existiert.
  pushda r0
  bl find
  @ ( Einsprungadresse Flags )
  drop @ Benötige die Flags hier nicht. Möchte doch nur schauen, ob es das Wort schon gibt.
  @ ( Einsprungadresse )  
  cmp tos, #0
  bne 2f
nicht_gefunden:
    ldr r0, =Tokenpuffer
    pushda r0
    bl type
    Fehler_Quit " not found."

2:@ Gefunden, alles gut
  pop {pc}

@ : pif postpone if immediate ;  : ja? pif ." Ja" else ." Nein" then ;
@------------------------------------------------------------------------------
  Wortbirne Flag_immediate, "postpone" @ Sucht das nächste Wort im Eingabestrom
                                       @ und fügt es auf besondere Weise ein.
@------------------------------------------------------------------------------
  push {lr}

  bl token
  @ ( Pufferadresse )
  bl find
  @ ( Einsprungadresse Flags )
  popda r0 @ Flags holen

  @ ( Einsprungadresse )  
  cmp tos, #0
  beq.n nicht_gefunden

1:and r1, r0, #Flag_immediate
  cmp r1, #Flag_immediate
  beq 4f

2:and r1, r0, #Flag_inline
  cmp r1, #Flag_inline
  bne 3f                             @ ( Einsprungadresse )
    bl literalkomma                  @ Einsprungadresse als Konstante einkompilieren
    stmdb psp!, {tos}
    movw tos, #:lower16:inlinekomma  @ Inline-Einfügung
    @ movt tos, #:upper16:inlinekomma   @ Nicht nötig, da die Adresse in den untersten 64 kb liegt
    b 4f                             @ zum Aufruf bereitlegen
    
3:@ Normal
    bl literalkomma
    stmdb psp!, {tos}
    movw tos, #:lower16:callkomma
    @ movt tos, #:upper16:callkomma    @ Nicht nötig, da die Adresse in den untersten 64 kb liegt
4:  pop {lr}
    b.n callkomma

@ -----------------------------------------------------------------------------
movwkomma: @ Register r0: Konstante
           @ Register r3: Zielregister, fertig geschoben zum Verodern
@ -----------------------------------------------------------------------------
  stmdb psp!, {tos}    @ Platz auf dem Datenstack schaffen 
  ldr tos, =0xf2400000 @ Opcode movw r0, #0

  ldr r1, =0x0000F000  @ Bit 16 - 13
  and r2, r0, r1       @ aus der Adresse maskieren
  lsl r2, #4           @ passend schieben
  orr tos, r2          @ zum Opcode hinzufügen

  ldr r1, =0x00000800  @ Bit 12
  and r2, r0, r1       @ aus der Adresse maskieren
  lsl r2, #15          @ passend schieben
  orr tos, r2          @ zum Opcode hinzufügen

  ldr r1, =0x00000700  @ Bit 11 - 9
  and r2, r0, r1       @ aus der Adresse maskieren
  lsl r2, #4           @ passend schieben
  orr tos, r2          @ zum Opcode hinzufügen

  ldr r1, =0x000000FF  @ Bit 8 - 1
  and r2, r0, r1       @ aus der Adresse maskieren
  @ lsr r2, #0         @ passend schieben
  orr tos, r2          @ zum Opcode hinzufügen

  @ Füge den gewünschten Register hinzu:
  orr tos, r3
  
  b.n reversekomma @ movw

@ -----------------------------------------------------------------------------
movtkomma: @ Register r0: Konstante
           @ Register r3: Zielregister, fertig geschoben zum Verodern
@ -----------------------------------------------------------------------------
  stmdb psp!, {tos}    @ Platz auf dem Datenstack schaffen
  ldr tos, =0xf2c00000 @ Opcode movt r0, #0

  ldr r1, =0xF0000000  @ Bit 32 - 29
  and r2, r0, r1       @ aus der Adresse maskieren
  lsr r2, #12          @ passend schieben
  orr tos, r2          @ zum Opcode hinzufügen

  ldr r1, =0x08000000  @ Bit 28
  and r2, r0, r1       @ aus der Adresse maskieren
  lsr r2, #1           @ passend schieben
  orr tos, r2          @ zum Opcode hinzufügen

  ldr r1, =0x07000000  @ Bit 27 - 25
  and r2, r0, r1       @ aus der Adresse maskieren
  lsr r2, #12          @ passend schieben
  orr tos, r2          @ zum Opcode hinzufügen

  ldr r1, =0x00FF0000  @ Bit 24 - 17
  and r2, r0, r1       @ aus der Adresse maskieren
  lsr r2, #16          @ passend schieben
  orr tos, r2          @ zum Opcode hinzufügen

  @ Füge den gewünschten Register hinzu:
  orr tos, r3

  b.n reversekomma @ movt


@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "movwmovt," @ ( x Registermaske -- )
movwmovtkomma:
@ -----------------------------------------------------------------------------
  push {r0, r1, r2, r3, lr}

  popda r3    @ Hole die Registermaske
  lsls r3, #8 @ Den Register um 8 Stellen schieben
  popda r0    @ Hole die Konstante

  bl movwkomma

  ldr r1, =0xffff0000 @ High-Teil
  ands r0, r1
  cmp r0, #0 @ Wenn der High-Teil Null ist, brauche ich keinen movt-Opcode mehr zu generieren.
  beq 1f

    bl movtkomma @ Bei Bedarf einfügen

1:pop {r0, r1, r2, r3, pc}


@ -----------------------------------------------------------------------------
callkommalang: @ ( Zieladresse -- ) Schreibt einen LANGEN Call-Befehl für does>
               @ Es ist wichtig, dass er immer die gleiche Länge hat.
@ -----------------------------------------------------------------------------
  @ Dies ist ein bisschen schwierig und muss nochmal gründlich optimiert werden.
  @ Schreibe einen ganz langen Sprung ins Dictionary !
  @ Wichtig für <builds does> wo die Lückengröße vorher festliegen muss.

  push {r0, r1, r2, r3, lr}
  adds tos, #1 @ Ungerade Adresse für Thumb-Befehlssatz

  popda r0     @ Zieladresse holen
  movs r3, #0  @ Register r0 wählen
  bl movwkomma
  bl movtkomma

  b.n callkommakurz_intern

@ -----------------------------------------------------------------------------
callkommakurz: @ ( Zieladresse -- )
               @ Schreibt einen Call-Befehl je nach Bedarf.
               @ Wird benötigt, wenn die Distanz für einen BL-Opcode zu groß ist.
@ ----------------------------------------------------------------------------
  @ Dies ist ein bisschen schwierig und muss nochmal gründlich optimiert werden.
  @ Gedanke: Für kurze Call-Distanzen die BL-Opcodes benutzen.

  push {r0, r1, r2, r3, lr}
  adds tos, #1 @ Ungerade Adresse für Thumb-Befehlssatz

  pushdaconst 0 @ Register r0
  bl movwmovtkomma

callkommakurz_intern:
  pushdaconst 0x4780 @ blx r0
  bl hkomma
  pop {r0, r1, r2, r3, pc}  


@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "call," @ ( Zieladresse -- )
callkomma:  @ Versucht einen möglichst kurzen Aufruf einzukompilieren. 
            @ Je nachdem: bl ...                            (4 Bytes)
            @             movw r0, ...              blx r0  (6 Bytes)
            @             movw r0, ... movt r0, ... blx r0 (10 Bytes) 
@ ----------------------------------------------------------------------------

  push {r0, r1, r2, r3, lr}
  mov r3, tos @ Behalte Sprungziel auf dem Stack
  @ ( Zieladresse )

  bl here
  popda r0 @ Adresse-der-Opcodelücke
  
  subs r3, r0     @ Differenz aus Lücken-Adresse und Sprungziel bilden
  subs r3, #4     @ Da der aktuelle Befehl noch läuft und es komischerweise andere Offsets beim ARM gibt.



  @ 22 Bits für die Sprungweite mit Vorzeichen - 
  @ also habe ich 21 freie Bits, das oberste muss mit dem restlichen Vorzeichen übereinstimmen. 

  ldr r1, =0xFFC00001   @ 21 Bits frei
  ands r1, r3
  cmp r1, #0  @ Wenn dies Null ergibt, positive Distanz ok.
  beq 1f

  ldr r2, =0xFFC00000
  cmp r1, r2
  beq 1f      @ Wenn es gleich ist: Negative Distanz ok.
    @ writeln "Normaler movw/movt-Aufruf"
    pop {r0, r1, r2, r3, lr}
    b.n callkommakurz
1:



  @ ( Zieladresse )
  drop
  @ ( -- )
  @ BL: S | imm10 || imm11
  @ Also 22 Bits, wovon das oberste das Vorzeichen sein soll.

  @write "BL-Opcode, Distanz "
  @  pushda r3
  @  bl hexdot
  @writeln " ok"

  @ r3 enthält die Distanz:

  lsrs r3, #1            @ Bottom bit ignored
    ldr r0, =0xF000F800  @ Opcode-Template

    ldr r1, =0x7FF       @ Bottom 11 bits of immediate
    ands r1, r3
    orrs r0, r1

  lsrs r3, #11

    ldr r1, =0x3FF       @ 10 more bits shifted to second half
    ands r1, r3
    lsls r1, #16
    orrs r0, r1

  lsrs r3, #10         

    ands r1, r3, #1      @ Next bit, treated as sign, shifted into bit 26.
    lsls r1, #26
    orrs r0, r1

  @ Opcode fertig in r0
  pushda r0
  bl reversekomma

  pop {r0, r1, r2, r3, pc}


@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "inline," @ ( addr -- )
inlinekomma:
@ -----------------------------------------------------------------------------
  push {lr}
  @ Übernimmt eine Routine komplett und schreibt sie ins Dictionary.
  @ TOS enthält Adresse der Routine, die eingefügt werden soll.

  @ Es gibt drei besondere Opcodes:
  @  - push {lr} wird übersprungen
  @  - pop {pc} ist Ende
  @  - bx lr ist auch eine Endezeichen.

  movs r1, #0xb500 @ push {lr}
  movs r2, #0xbd00 @ pop {pc}
  movw r3, #0x4770 @ bx lr

1:ldrh r0, [tos] @ Hole die nächsten 16 Bits aus der Routine.
  cmp r0, r1 @ push {lr}
  beq 2f
  cmp r0, r2 @ pop {pc}
  beq 3f
  cmp r0, r3 @ bx lr
  beq 3f

  pushda r0
  bl hkomma @ Opcode einkompilieren

2:adds tos, #2 @ Pointer weiterrücken
  b 1b 

3:drop
  pop {pc}

@ An der ersten Stelle wird geprüft: Ist es eine Routine mit pop {pc} oder mit bx lr am Ende ?
@ -----------------------------------------------------------------------------
suchedefinitionsende: @ Rückt den Pointer in r0 ans Ende einer Definition vor.
@ -----------------------------------------------------------------------------
        @ Suche wie in inline, nach pop {pc} oder bx lr.
        push {r1, r2, r3}

          mov  r2, #0xbd00 @ pop {pc}
          movw r3, #0x4770 @ bx lr

1:        ldrh r1, [r0]  @ Hole die nächsten 16 Bits aus der Routine.
          adds r0, #2    @ Pointer Weiterrücken

          cmp r1, r2  @ pop {pc}
          beq 2f
          cmp r1, r3  @ bx lr
          bne 1b

2:      pop {r1, r2, r3}
        bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "literal," @ ( x -- )
literalkomma: @ Nur r3 muss erhalten bleiben
@ -----------------------------------------------------------------------------
  push {lr}

  pushdaconstw 0xf847  @ stmdb psp!, {tos}
  bl hkomma
  pushdaconstw 0x6d04
  bl hkomma

  @ Neuigkeit: Generiere movs-Opcode für sehr kleine Konstanten :-)
  cmp tos, #0xFF
  bhi 1f
    @ Gewünschte Konstante passt in 8 Bits. 
    orrs tos, #0x2600 @ movs r6, #imm8 mit Zero-Extend
    bl hkomma
    pop {pc}
1:

  pushdaconst 6 @ Gleich in r6=tos legen
  bl movwmovtkomma

  pop {pc}  

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "ret," @ ( -- )
retkomma:
@ -----------------------------------------------------------------------------
  @ Mache das mit pop {pc}
  pushdaconst 0xbd00 @ Opcode für pop {pc} schreiben
  b.n hkomma

@  : fac ( n -- n! )   1 swap  1 max  1+ 2 ?do i * loop ;
@  : fac-rec ( acc n -- n! ) dup dup 1 = swap 0 = or if drop else dup 1 - rot rot * swap recurse then ; : facre ( n -- n! ) 1 swap fac-rec ;

@------------------------------------------------------------------------------
  Wortbirne Flag_immediate_compileonly, "recurse" @ Für Rekursion. Führt das gerade frische Wort aus.
@------------------------------------------------------------------------------
  push {lr}
  bl fadenende_einsprungadresse
  bl callkomma
  pop {pc}

@------------------------------------------------------------------------------
fadenende_einsprungadresse: @ Kleines Helferlein spart Platz
@------------------------------------------------------------------------------
  push {r0, r1, r2}
  ldr r0, =Fadenende
  ldr r0, [r0]

  @ --> Codestartadresse, analog zur Routine in words

        @ Flagfeld
        @adds r0, #2

        @ Link
        @adds r0, #4
        adds r0, #6

        ldrb r1, [r0] @ Länge des Strings holen
        adds r1, #1    @ Plus 1 Byte für die Länge
        ands r2, r1, #1 @ Wenn es ungerade ist, noch einen mehr:
        adds r1, r2
        adds r0, r1

  @ r0 enthält jetzt die Codestartadresse der aktuellen Definition.
  pushda r0
  pop {r0, r1, r2}
  bx lr



/*
schuhu: push {lr} 
        writeln "Es sitzt der Uhu auf einem Baum und macht Schuhuuuu, Schuhuuuu !"
        pop {pc}

: c <builds $12345678 , does> . ." does>-Teil " ;  c uhu ' uhu dump
: con <builds h, does> h@ ;  42 con antwort    antwort .
*/
  


@------------------------------------------------------------------------------
  Wortbirne Flag_inline, "does>"
does: @ Gives freshly defined word a special action.
      @ Has to be used together with <builds !
@------------------------------------------------------------------------------
    @ At the place where does> is used, a jump to dodoes is inserted and
    @ after that a R> to put the address of the definition entering the does>-part
    @ on datastack. This is a very special implementation !

  @ Universeller Sprung zu dodoes:
  @ Davor ist in dem Wort, wo does> eingefügt wird schon ein push {lr} gewesen.
  movw r0, #:lower16:dodoes+1
  @  movt r0, #:upper16:dodoes+1   Dieser Teil ist Null, da dodoes weit am Anfang des Flashs sitzt.
  blx r0 @ Den Aufruf mit absoluter Adresse einkompilieren


    @ r_from        ; This makes for the inline R> in definition of defining word !
    @ Die Adresse ist hier nicht auf dem Stack, sondern in LR. LR ist sowas wie "TOS" des Returnstacks.
  pushda lr
  subs tos, #1 @ Denn es ist normalerweise eine ungerade Adresse wegen des Thumb-Befehlssatzes.

  @ Am Ende des Wortes wird ein pop {pc} stehen, und das kommt prima hin.
  bx lr @ Very important as delimiter as does> itself is inline.

dodoes:
  @ Hier komme ich an. Die Adresse des Teils, der als Zieladresse für den Call-Befehl genutzt werden soll, befindet sich in LR.

  @ The call to dodoes never returns.
  @ Instead, it compiles a call to the part after its invocation into the dictionary
  @ and exits through two call layers.  

  @ Momentaner Zustand von Stacks und LR:
  @    ( -- )
  @ R: ( Rücksprung-des-Wortes-das-does>-enthält )
  @ LR Adresse von dem, was auf den does>-Teil folgt

  @ Muss einen Call-BL-Befehl an die Stelle, die in LR steht einbauen.

  @ Präpariere die Einsprungadresse, die via callkomma eingefügt werden muss.
  pushda lr   @ Brauche den Link danach nicht mehr, weil ich über die in dem Wort das does> enthält gesicherte Adresse rückspringe
  subs tos, #1 @ Einen abziehen. Diese Adresse ist schon ungerade für Thumb-2, aber callkomma fügt nochmal eine 1 dazu. 

  bl fadenende_einsprungadresse

    @ Dictionary-Pointer verbiegen:
      @ Dictionarypointer sichern
      ldr r2, =Dictionarypointer
      ldr r3, [r2] @ Alten Dictionarypointer auf jeden Fall bewahren

  popda r1     @ r1 enthält jetzt die Codestartadresse der aktuellen Definition.  
  adds r1, #2  @ Am Anfang sollte das neudefinierte Wort ein push {lr} enthalten, richtig ?

      str r1, [r2] @ Dictionarypointer umbiegen
  bl callkommalang @ Aufruf einfügen
      str r3, [r2] @ Dictionarypointer wieder zurücksetzen.

  bl smudge
  pop {pc}


@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "<builds"
        @ Beginnt ein Defining-Wort.
        @ Dazu lege ich ein neues Wort an, lasse eine Lücke für den Call-Befehl
        @ Keine Strukturkennung
@ -----------------------------------------------------------------------------
  push {lr}
  bl create       @ Neues Wort wird erzeugt

  pushdaconst 0xb500 @ Opcode für push {lr} schreiben
  bl hkomma

  pushdaconst 10  @ Hier kommt ein Call-Befehl hinein, aber ich weiß die Adresse noch nicht.
  bl allot        @ Lasse also eine passende Lücke frei !
  pop {pc}

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_0, "state" @ ( -- addr )
@ -----------------------------------------------------------------------------
  ldr r0, =state
  pushda r0
  bx lr

@------------------------------------------------------------------------------
  Wortbirne Flag_visible, "]" @ In den Compile-Modus übergehen
@ -----------------------------------------------------------------------------
  ldr r0, =state
  mov r1, #-1 @ true-Flag in State legen
  str r1, [r0] 
  bx lr

@------------------------------------------------------------------------------
  Wortbirne Flag_immediate, "[" @ In den Execute-Modus übergehen
@ -----------------------------------------------------------------------------
  ldr r0, =state
  mov r1, #0 @ false-Flag in State legen.
  str r1, [r0]
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, ":" @ ( -- )
@ -----------------------------------------------------------------------------
  push {lr}

  ldr r0, =Datenstacksicherung @ Setzt den Füllstand des Datenstacks zur Probe.
  str psp, [r0]

  bl create

  pushdaconst 0xb500 @ Opcode für push {lr} schreiben
  bl hkomma

  ldr r0, =state
  mov r1, #-1
  str r1, [r0]

  pop {pc}

@ -----------------------------------------------------------------------------
  Wortbirne Flag_immediate_compileonly, ";" @ ( -- )
@ -----------------------------------------------------------------------------
  push {lr}

  ldr r0, =Datenstacksicherung @ Prüft den Füllstand des Datenstacks.
  ldr r1, [r0]
  cmp r1, psp
  beq 1f
    Fehler_Quit " Stack not balanced."
1: @ Stack balanced, ok

  pushdaconst 0xbd00 @ Opcode für pop {pc} schreiben
  bl hkomma

  bl smudge

  ldr r0, =state
  mov r1, #0 @ false-Flag in State legen.
  str r1, [r0]

  pop {pc}

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "execute"
execute:
@ -----------------------------------------------------------------------------
  popda r0
  adds r0, #1 @ Ungerade Adresse für Thumb-Befehlssatz
  mov pc, r0 

@ -----------------------------------------------------------------------------
  Wortbirne Flag_immediate, "immediate" @ ( -- )
@ -----------------------------------------------------------------------------
  pushdaconst Flag_immediate
  b setflags

@ -----------------------------------------------------------------------------
  Wortbirne Flag_immediate, "inline" @ ( -- )
@ -----------------------------------------------------------------------------
  pushdaconst Flag_inline
  b setflags

@ -----------------------------------------------------------------------------
  Wortbirne Flag_immediate, "compileonly" @ ( -- )
@ -----------------------------------------------------------------------------
  pushdaconst Flag_immediate_compileonly
  b setflags

@ -----------------------------------------------------------------------------
  Wortbirne Flag_immediate, "0-foldable" @ ( -- )
setze_faltbarflag:
@ -----------------------------------------------------------------------------
  pushdaconst Flag_foldable_0
  b setflags

@ -----------------------------------------------------------------------------
  Wortbirne Flag_immediate, "1-foldable" @ ( -- )
@ -----------------------------------------------------------------------------
  pushdaconst Flag_foldable_1
  b setflags

@ -----------------------------------------------------------------------------
  Wortbirne Flag_immediate, "2-foldable" @ ( -- )
@ -----------------------------------------------------------------------------
  pushdaconst Flag_foldable_2
  b setflags

@ -----------------------------------------------------------------------------
  Wortbirne Flag_immediate, "3-foldable" @ ( -- )
@ -----------------------------------------------------------------------------
  pushdaconst Flag_foldable_3
  b setflags

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "constant" @ ( n -- )
@ -----------------------------------------------------------------------------
  push {lr}
  bl create
  bl literalkomma
  pushdaconstw 0x4770 @ Opcode für bx lr
  bl hkomma
  bl setze_faltbarflag
  bl smudge
  pop {pc}
