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
  ldr r0, =Dictionarypointer
  ldr r1, [r0] @ Hole den Dictionarypointer
  pushda r1
  bx lr

@------------------------------------------------------------------------------
  Wortbirne Flag_immediate|Flag_foldable_0, "[']" @ Sucht das nächste Wort im Eingabestrom
@------------------------------------------------------------------------------
  b tick @ So sah das mal aus: ['] ' immediate 0-foldable ;

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
    writeln " ' needs name !"
    b quit

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
    writeln " not found."
    b quit
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
  bne 1f
    b nicht_gefunden

1:and r1, r0, #Flag_immediate
  cmp r1, #Flag_immediate
  bne 2f
    bl callkomma
    pop {pc}

2:and r1, r0, #Flag_inline
  cmp r1, #Flag_inline
  bne 3f                             @ ( Einsprungadresse )
    bl literalkomma                  @ Einsprungadresse als Konstante einkompilieren
    movw r1, #:lower16:inlinekomma   @ Inline-Einfügung
@   movt r1, #:upper16:inlinekomma   @ Nicht nötig, da die Adresse in den untersten 64 kb liegt
    pushda r1
    bl callkomma                     @ zum Aufruf bereitlegen
    pop {pc}

3:@ Normal
    bl literalkomma
    movw r1, #:lower16:callkomma
@   movt r1, #:upper16:callkomma    @ Nicht nötig, da die Adresse in den untersten 64 kb liegt
    pushda r1
    bl callkomma
    pop {pc}
  
    

/*
;------------------------------------------------------------------------------
  Wortbirne Flag_visible_immediate, "postpone" ; Sucht das nächste Wort im Eingabestrom
                                                ; und fügt es auf besondere Weise ein.
;------------------------------------------------------------------------------
  call #token
  ; ( Pufferadresse )
  call #wortsuche
  ; ( Einsprungadresse Flags )
    tst 2(r4)
    je -  ; Benutze Fehlermeldung aus tick.

  bit #010h, @r4
  jnc +
  ; Immediate
    drop
    jmp callkomma  ; Ok.

+ bit #020h, @r4
  jnc +
  ; Inline
    drop                  ; ( Einsprungadresse )
    call #literalkomma    ; Einsprungadresse als Konstante einkompilieren
    pushda #inlinekomma   ; Inline-Einfügung
    jmp callkomma         ; zum Aufruf bereitlegen

+ ; Normal
    drop
    call #literalkomma
    pushda #callkomma
    jmp callkomma

*/


@ -----------------------------------------------------------------------------
movwkomma: @ Register r0: Konstante
           @ Register r4: Zielregister, fertig geschoben zum Verodern
@ -----------------------------------------------------------------------------
  ldr r3, =0xf2400000  @ Opcode movw r0, #0

  ldr r1, =0x0000F000  @ Bit 16 - 13
  and r2, r0, r1       @ aus der Adresse maskieren
  lsl r2, #4           @ passend schieben
  orr r3, r2           @ zum Opcode hinzufügen

  ldr r1, =0x00000800  @ Bit 12
  and r2, r0, r1       @ aus der Adresse maskieren
  lsl r2, #15          @ passend schieben
  orr r3, r2           @ zum Opcode hinzufügen

  @ Richtig:
  ldr r1, =0x00000700  @ Bit 11 - 9
  and r2, r0, r1       @ aus der Adresse maskieren
  lsl r2, #4           @ passend schieben
  orr r3, r2           @ zum Opcode hinzufügen

  @ Richtig:
  ldr r1, =0x000000FF  @ Bit 8 - 1
  and r2, r0, r1       @ aus der Adresse maskieren
  @ lsr r2, #0           @ passend schieben
  orr r3, r2           @ zum Opcode hinzufügen

  @ Zweiter Opcode ist fertig.
  @ Füge den gewünschten Register hinzu:
  orr r3, r4
  
  pushda r3
  b reversekomma @ movw

@ -----------------------------------------------------------------------------
movtkomma: @ Register r0: Konstante
           @ Register r4: Zielregister, fertig geschoben zum Verodern
@ -----------------------------------------------------------------------------
  ldr r3, =0xf2c00000  @ Opcode movt r0, #0

  ldr r1, =0xF0000000  @ Bit 32 - 29
  and r2, r0, r1       @ aus der Adresse maskieren
  lsr r2, #12           @ passend schieben
  orr r3, r2           @ zum Opcode hinzufügen

  ldr r1, =0x08000000  @ Bit 28
  and r2, r0, r1       @ aus der Adresse maskieren
  lsr r2, #1           @ passend schieben
  orr r3, r2           @ zum Opcode hinzufügen

  ldr r1, =0x07000000  @ Bit 27 - 25
  and r2, r0, r1       @ aus der Adresse maskieren
  lsr r2, #12          @ passend schieben
  orr r3, r2           @ zum Opcode hinzufügen

  ldr r1, =0x00FF0000  @ Bit 24 - 17
  and r2, r0, r1       @ aus der Adresse maskieren
  lsr r2, #16          @ passend schieben
  orr r3, r2           @ zum Opcode hinzufügen

  @ Füge den gewünschten Register hinzu:
  orr r3, r4

  pushda r3
  b reversekomma @ movt


@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "movwmovt," @ ( x Registermaske -- )
movwmovtkomma:
@ -----------------------------------------------------------------------------
  push {lr}

  popda r4 @ Hole die Registermaske
  lsl r4, #8 @ Den Register um 8 Stellen schieben

  popda r0 @ Hole die Konstante

  bl movwkomma

  ldr r1, =0xffff0000 @ High-Teil
  and r0, r1
  cmp r0, #0 @ Wenn der High-Teil Null ist, brauche ich keinen movt-Opcode mehr zu generieren.
  beq 1f

    bl movtkomma

1:pop {pc}




/*
@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "movwmovt," @ ( x Registermaske -- )
movwmovtkomma:
@ -----------------------------------------------------------------------------
  push {lr}

  popda r4 @ Hole die Registermaske
  lsl r4, #8 @ Den Register um 8 Stellen schieben

  popda r0 @ Hole die Konstante

  @ Setze daraus ein movw/movt-Paar zusammen:

  @ Dessen Bits müssen nun geschickt verwurstet werden.
  @     b4e:       f240 0000       movw    r0, #0
  @     b52:       f2c0 0000       movt    r0, #0

  ldr r3, =0xf2400000  @ Opcode movw r0, #0

  ldr r1, =0x0000F000  @ Bit 16 - 13
  and r2, r0, r1       @ aus der Adresse maskieren
  lsl r2, #4           @ passend schieben
  orr r3, r2           @ zum Opcode hinzufügen

  ldr r1, =0x00000800  @ Bit 12
  and r2, r0, r1       @ aus der Adresse maskieren
  lsl r2, #15          @ passend schieben
  orr r3, r2           @ zum Opcode hinzufügen

  @ Richtig:
  ldr r1, =0x00000700  @ Bit 11 - 9
  and r2, r0, r1       @ aus der Adresse maskieren
  lsl r2, #4           @ passend schieben
  orr r3, r2           @ zum Opcode hinzufügen

  @ Richtig:
  ldr r1, =0x000000FF  @ Bit 8 - 1
  and r2, r0, r1       @ aus der Adresse maskieren
  @ lsr r2, #0           @ passend schieben
  orr r3, r2           @ zum Opcode hinzufügen

  @ Zweiter Opcode ist fertig.
  @ Füge den gewünschten Register hinzu:
  orr r3, r4
  
  pushda r3
  bl reversekomma @ movw


  ldr r1, =0xffff0000 @ High-Teil
  and r0, r1
  cmp r0, #0 @ Wenn der High-Teil Null ist, brauche ich keinen movt-Opcode mehr zu generieren.
  beq 1f


  ldr r3, =0xf2c00000  @ Opcode movt r0, #0

  ldr r1, =0xF0000000  @ Bit 32 - 29
  and r2, r0, r1       @ aus der Adresse maskieren
  lsr r2, #12           @ passend schieben
  orr r3, r2           @ zum Opcode hinzufügen

  ldr r1, =0x08000000  @ Bit 28
  and r2, r0, r1       @ aus der Adresse maskieren
  lsr r2, #1           @ passend schieben
  orr r3, r2           @ zum Opcode hinzufügen

  ldr r1, =0x07000000  @ Bit 27 - 25
  and r2, r0, r1       @ aus der Adresse maskieren
  lsr r2, #12          @ passend schieben
  orr r3, r2           @ zum Opcode hinzufügen

  ldr r1, =0x00FF0000  @ Bit 24 - 17
  and r2, r0, r1       @ aus der Adresse maskieren
  lsr r2, #16          @ passend schieben
  orr r3, r2           @ zum Opcode hinzufügen

  @ Erster Opcode ist fertig.
  @ Füge den gewünschten Register hinzu:
  orr r3, r4

  pushda r3
  bl reversekomma @ movt

1:pop {pc}
*/


@ -----------------------------------------------------------------------------
callkommalang: @ ( Zieladresse -- ) Schreibt einen LANGEN Call-Befehl für does>
               @ Es ist wichtig, dass er immer die gleiche Länge hat.
@ -----------------------------------------------------------------------------
  @ Dies ist ein bisschen schwierig und muss nochmal gründlich optimiert werden.
  @ Schreibe einen ganz langen Sprung ins Dictionary !

  push {r0, r1, r2, r3, r4, r5, lr}
  add tos, #1 @ Ungerade Adresse für Thumb-Befehlssatz, nicht soo wichtig. Müsste das sonst auch in execute einpflegen.

  popda r0    @ Zieladresse holen
  mov r4, #0  @ Register r0 wählen
  bl movwkomma
  bl movtkomma

  pushdaconst 0x4780 @ blx r0
  bl hkomma
  pop {r0, r1, r2, r3, r4, r5, pc}    
  

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "call," @ ( addr -- )
callkomma:
@ -----------------------------------------------------------------------------
  @ Dies ist ein bisschen schwierig und muss nochmal gründlich optimiert werden.
  @ Schreibe einen ganz langen Sprung ins Dictionary !

  push {r0, r1, r2, r3, r4, lr}
  add tos, #1 @ Ungerade Adresse für Thumb-Befehlssatz, nicht soo wichtig. Müsste das sonst auch in execute einpflegen.

  pushdaconst 0 @ Register r0
  bl movwmovtkomma
  pushdaconst 0x4780 @ blx r0
  bl hkomma
  pop {r0, r1, r2, r3, r4, pc}  


@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "inline," @ ( addr -- )
inlinekomma:
@ -----------------------------------------------------------------------------
  push {lr}
  @ Übernimmt eine Routine komplett und schreibt sie ins Dictionary.
  popda r0 @ Die Adresse der Routine, die eingefügt werden soll.

  @ Es gibt drei besondere Opcodes:
  @  - push {lr} wird übersprungen
  @  - pop {pc} ist Ende
  @  - bx lr ist auch eine Endezeichen.

  mov r2, #0xb500 @ push {lr}
  mov r3, #0xbd00 @ pop {pc}
  movw r4, #0x4770 @ bx lr

1:ldrh r1, [r0] @ Hole die nächsten 16 Bits aus der Routine.
  cmp r1, r2 @ push {lr}
  beq 2f

  cmp r1, r3 @ pop {pc}
  beq 3f
  cmp r1, r4 @ bx lr
  beq 3f

  pushda r1
  bl hkomma @ Opcode einkompilieren

2:add r0, #2 @ Pointer weiterrücken
  b 1b 

3:pop {pc}

  @ An der ersten Stelle wird geprüft: Ist es eine Routine mit pop {pc} oder mit bx lr am Ende ?

/*
@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "sucheende" @ ( addr -- addr )
@ -----------------------------------------------------------------------------
  push {lr}
  popda r0
  bl suchedefinitionsende
  pushda r0
  pop {pc}
*/  

@ -----------------------------------------------------------------------------
suchedefinitionsende: @ Rückt den Pointer in r0 ans Ende einer Definition vor.
@ -----------------------------------------------------------------------------
        @ Suche wie in inline, nach pop {pc} oder bx lr.
        push {r1, r3, r4}

          mov  r3, #0xbd00 @ pop {pc}
          movw r4, #0x4770 @ bx lr

1:        ldrh r1, [r0] @ Hole die nächsten 16 Bits aus der Routine.
          add r0, #2    @ Pointer Weiterrücken

          cmp r1, r3 @ pop {pc}
          beq 2f
          cmp r1, r4 @ bx lr
          beq 2f

          b 1b

2:      pop {r1, r3, r4}
        bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "literal," @ ( x -- )
literalkomma:
@ -----------------------------------------------------------------------------
  push {r0, r1, r2, r3, r4, lr}

  @ stmdb psp!, {tos}

  pushdaconst 0xf847
  bl hkomma
  pushdaconst 0x6d04
  bl hkomma

  pushdaconst 6 @ Gleich in r6=tos legen
  bl movwmovtkomma

/*
@     dd8:       f849 8d04       str.w   r8, [r9, #-4]!
@     cf4:	 f847 6d04 	 str.w	r6, [r7, #-4]!
*/

  pop {r0, r1, r2, r3, r4, pc}  

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "ret," @ ( -- )
retkomma:
@ -----------------------------------------------------------------------------
  @ Mache das mit pop {pc}
  pushdaconst 0xbd00 @ Opcode für pop {pc} schreiben
  b hkomma

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
        @add r0, #4

        @ Link
        @add r0, #4
        add r0, #8

        ldrb r1, [r0] @ Länge des Strings holen
        add r1, #1    @ Plus 1 Byte für die Länge
        and r2, r1, #1 @ Wenn es ungerade ist, noch einen mehr:
        add r1, r2
        add r0, r1

  @ r0 enthält jetzt die Codestartadresse der aktuellen Definition.
  pushda r0
  pop {r0, r1, r2}
  bx lr



/*
schuhu: push {lr} 
        writeln "Es sitzt der Uhu auf einem Baum und macht Schuhuuuu, Schuhuuuu !"
        pop {pc}
*/


/*
  movw r4, #:lower16:schuhu+1
  movt r4, #:upper16:schuhu+1
  pushda r4

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
  sub tos, #1 @ Denn es ist normalerweise eine ungerade Adresse wegen des Thumb-Befehlssatzes.

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
  sub tos, #1 @ Einen abziehen. Diese Adresse ist schon ungerade für Thumb-2, aber callkomma fügt nochmal eine 1 dazu. 

  @ Dictionarypointer sichern
  ldr r0, =Dictionarypointer
  ldr r5, [r0] @ Alten Dictionarypointer auf jeden Fall bewahren

  bl fadenende_einsprungadresse
  popda r1     @ r1 enthält jetzt die Codestartadresse der aktuellen Definition.  
  add r1, #2   @ Am Anfang sollte das neudefinierte Wort ein push {lr} enthalten, richtig ?
  str r1, [r0] @ Dictionarypointer umbiegen

  @push {r0, r5} Werden in Callkommalamg gesichert.
  bl callkommalang @ Achtung ! Später im Flash sind hier auch "kleine" Adressen möglich, dann muss ich das movw/movt-Paar erzwingen. Keine Abkürzungen erlaubt ! Callkommalang schreibt immer das movw-movt-Paar, auch wenn es kürzer gehen könnte.
  @pop {r0, r5}

  str r5, [r0] @ Alten Dictionarypointer zurückschreiben
  
  bl smudge
  pop {pc}




/*
dodoes:
  ; The call to dodoes never returns.
  ; Instead, it compiles a call to the part after its invocation into the dictionary
  ; and exits through two call layers.

  ; Have a close look on the stacks:
  ; ( ) ( R: Return-of-defining-definition-that-called-does>  Return-of-dodoes-itself )

  push &DictionaryPointer ; Push Dictionary pointer before changing it as , is the easiest way handle writing code to flash or ram.
  ; ( ) ( R: Return-of-defining-definition-that-called-does>  Return-of-dodoes-itself Old-Dictionary-Pointer )
  ; Fetch address to where a call should be inserted:
  call #Fadenende_Einsprungadresse ; Call into does>-part should be inserted into CURRENT definition. Calculate pointer.
  ; ( Place-to-insert-call-opcode ) ( R: Return-of-defining-definition-that-called-does>  Return-of-dodoes-itself Old-Dictionary-Pointer )
  mov @r4, &DictionaryPointer ; This is the place to insert the call-opcode !
  mov 2(sp), @r4  ; Target-Address for call-opcode is return address of dodoes which points to the does>-part of defining word.  
  ; ( Call-Target-Address ) ( R: Return-of-defining-definition-that-called-does>  Return-of-dodoes-itself Old-Dictionary-Pointer )
  call #callkomma ; Write call into dictionary
  ; ( ) ( R: Return-of-defining-definition-that-called-does>  Return-of-dodoes-itself Old-Dictionary-Pointer )
  pop &DictionaryPointer ; Restore dictionary pointer.
  ; ( ) ( R: Return-of-defining-definition-that-called-does>  Return-of-dodoes-itself )
  incd sp ; Remove one return layer
  ; ( ) ( R: Return-of-defining-definition-that-called-does> )
  jmp smudge ; Render current definition visible and Return
*/


/*
;------------------------------------------------------------------------------
  Wortbirne Flag_visible_inline, "does>"
does: ; Gives freshly defined word a special action.
      ; Has to be used together with <builds !
;------------------------------------------------------------------------------
    ; At the place where does> is used, a jump to dodoes is inserted and
    ; after that a R> to put the address of the definition entering the does>-part
    ; on datastack. This is a very special implementation !

    call #dodoes
    r_from        ; This makes for the inline R> in definition of defining word !
  ret ; Very important as delimiter as does> itself is inline.

dodoes:
  ; The call to dodoes never returns.
  ; Instead, it compiles a call to the part after its invocation into the dictionary
  ; and exits through two call layers.

  ; Have a close look on the stacks:
  ; ( ) ( R: Return-of-defining-definition-that-called-does>  Return-of-dodoes-itself )

  push &DictionaryPointer ; Push Dictionary pointer before changing it as , is the easiest way handle writing code to flash or ram.
  ; ( ) ( R: Return-of-defining-definition-that-called-does>  Return-of-dodoes-itself Old-Dictionary-Pointer )
  ; Fetch address to where a call should be inserted:
  call #Fadenende_Einsprungadresse ; Call into does>-part should be inserted into CURRENT definition. Calculate pointer.
  ; ( Place-to-insert-call-opcode ) ( R: Return-of-defining-definition-that-called-does>  Return-of-dodoes-itself Old-Dictionary-Pointer )
  mov @r4, &DictionaryPointer ; This is the place to insert the call-opcode !
  mov 2(sp), @r4  ; Target-Address for call-opcode is return address of dodoes which points to the does>-part of defining word.  
  ; ( Call-Target-Address ) ( R: Return-of-defining-definition-that-called-does>  Return-of-dodoes-itself Old-Dictionary-Pointer )
  call #callkomma ; Write call into dictionary
  ; ( ) ( R: Return-of-defining-definition-that-called-does>  Return-of-dodoes-itself Old-Dictionary-Pointer )
  pop &DictionaryPointer ; Restore dictionary pointer.
  ; ( ) ( R: Return-of-defining-definition-that-called-does>  Return-of-dodoes-itself )
  incd sp ; Remove one return layer
  ; ( ) ( R: Return-of-defining-definition-that-called-does> )
  jmp smudge ; Render current definition visible and Return


;------------------------------------------------------------------------------
  Wortbirne Flag_visible_inline, "does>"
does: ; Fügt dem gerade erstellten Wort eine besondere Aufgabe hinzu.
;------------------------------------------------------------------------------
    ; An die Stelle, wo does> aufgerufen wird, wird ein Sprung in dodoes eingefügt
    ; und gleich dahinter inline ein R> um die Parameteradresse aus dem Einsprung
    ; auf den Datenstack zu legen. Dieser Teil wird nur ein einziges Mal beim
    ; Eincompilieren eines neuen Defining-Wortes angesprungen.
    call #dodoes
    r_from         ; Dies ergibt das inline >R im Wort.
  ret ; Ganz wichtig, da does> jetzt inline ist !

dodoes:
  ; Ich habe nun ein Wort vorbereitet, das alle möglichen Daten enthalten kann.
  ; Die Definition ist fertig und abgeschlossen, nur die Call-Adresse fehlt noch.

  ; Doch wohin soll das call springen ? Auf den Teil, der nach does> kommt.
  ; Den kann ich über die Rücksprungadresse finden.
  ; Da does> der Ausführung ein Ende setzt, nehme ich die Rücksprungadresse,
  ; die in das Call eingefügt wird komplett vom Stack.
  ; Das hat in etwa die Wirkung, als würde das Wort, was does> aufgerufen hat
  ; selbst ein ret ausführen.

  ; Gucke mal in den Stack:
  ; ( Rücksprung-des-Wortes-das-does>-aufgerufen-hat  Rücksprungadresse-von-does>-selbst )

  push &DictionaryPointer
  ; ( Rücksprung-des-Wortes-das-does>-aufgerufen-hat  Rücksprungadresse-von-does>-selbst AlterDictionaryPointer )
  ; Hole die Adresse, an die die Call-Adresse eingefügt werden soll:
  call #Fadenende_Einsprungadresse   ; Das aktuelle Wort soll den does>-Teil-Call bekommen. Berechne aus dem Fadenende die Einsprungstelle
  mov @r4, &DictionaryPointer ; An dieser Stelle soll der Call-Befehl eingefügt werden !
  mov 2(sp), @r4 ; Zieladresse für den Call-Befehl auf den Datenstack legen
  call #callkomma ; Call-Befehl mit Zieladresse einschreiben
  pop &DictionaryPointer
  ; ( Rücksprung-des-Wortes-das-does>-aufgerufen-hat  Rücksprungadresse-von-does>-selbst)
  incd sp ; Rücksprungadresse-von-does>-selbst vom Returnstack schmeißen
  ; ( Rücksprung-des-Wortes-das-does>-aufgerufen-hat )
  jmp smudge ; Markiere das neue Wort als Ausführbereit

  ; Das Call, dessen Adresse nachträglich eingefügt wurde, kehrt übringens nie zurück.
  ; Die Rücksprungadresse wird als Zeiger auf das Parameterfeld eines tatsächlich definierten Wortes
  ; verwendet und dort inline vom Returnstack auf den Datenstack geschoben.
  ; Das ret am Ende der Routine nach does> durchspringt ebenfalls eine Ebene.

;------------------------------------------------------------------------------
  Wortbirne Flag_visible, "<builds"
builds: ; Beginnt ein Defining-Wort.
        ; Dazu lege ich ein neues Wort an, lasse eine Lücke für den Call-Befehl
        ; Keine Strukturkennung
;------------------------------------------------------------------------------
  call #create  ; Neues Wort wird erzeugt
  pushda #4 ; Hier kommt ein Call-Befehl hinein, aber ich weiß die Adresse noch nicht.
  jmp allot ; Lasse also eine passende Lücke frei !

*/




@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "<builds"
@builds: 
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
  Wortbirne Flag_immediate, ";" @ ( -- )
@ -----------------------------------------------------------------------------
  push {lr}

  ldr r0, =Datenstacksicherung @ Prüft den Füllstand des Datenstacks.
  ldr r1, [r0]
  cmp r1, psp
  beq 1f
    writeln " Stack not balanced."
    b quit     
1: @ writeln "Stack balanced, ok"

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
  add r0, #1 @ Ungerade Adresse für Thumb-Befehlssatz
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
  pushdaconst 0x4770 @ Opcode für bx lr
  bl hkomma
  bl setze_faltbarflag
  bl smudge
  pop {pc}
