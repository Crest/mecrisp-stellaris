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

@ Besondere Teile des Compilers, die mit der Dictionarystruktur im Flash zu tun haben.


@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "smudge" @ ( -- )
smudge:
@ -----------------------------------------------------------------------------
  ldr r0, =Dictionarypointer
  ldr r1, [r0]

  ldr r2, =Backlinkgrenze
  cmp r1, r2
  bhs smudge_ram @ Befinde mich im Ram. Schalte um !

  @ -----------------------------------------------------------------------------
  @ Smudge für Flash

    @ Prüfe, ob am Ende des Wortes ein $FFFF steht. Das darf nicht sein !
    @ Es würde als freie Stelle erkannt und später überschrieben werden.
    @ Deshalb wird in diesem Fall hier am Ende eine 0 ans Dictionary angehängt.

    push {lr}

    @ r1 enthält den DictionaryPointer.
    sub r1, #2
    ldrh r2, [r1]
    ldr r3, =0xFFFF
    cmp r2, r3
    bne 1f
      writeln "Füge in Smudge eine Enderkennungs-Null ein."
      pushdaconst 0
      bl ckomma
1:  @ Okay, Ende gut, alles gut.

    @ Brenne die gesammelten Flags:
    @writeln "Smudge-Flash"
    ldr r0, =FlashFlags
    ldr r0, [r0]
    pushda r0
    
    ldr r1, =Fadenende
    ldr r1, [r1]  

    @ Dictionary-Pointer verbiegen:
      @ Dictionarypointer sichern
      ldr r4, =Dictionarypointer
      ldr r5, [r4] @ Alten Dictionarypointer auf jeden Fall bewahren

      str r1, [r4] @ Dictionarypointer umbiegen
  
      push {r4, r5, lr}
      bl komma          @ Befehl einfügen. Muss ich später auf Komma umbiegen.
      pop {r4, r5, lr}

      str r5, [r4] @ Dictionarypointer wieder zurücksetzen.

    pop {pc}

  @ -----------------------------------------------------------------------------
  @ Smudge für RAM
smudge_ram:
  @writeln "Smudge-RAM"
  pushdaconst Flag_visible
  b setflags

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "setflags" @ ( x -- )
setflags:
@ -----------------------------------------------------------------------------
  push {lr}

  ldr r0, =Dictionarypointer
  ldr r1, [r0]

  ldr r2, =Backlinkgrenze
  cmp r1, r2
  bhs setflags_ram @ Befinde mich im Ram. Schalte um !

  @ -----------------------------------------------------------------------------
  @ Setflags für Flash
  ldr r0, =FlashFlags
  ldr r1, [r0]
  orr r1, tos  @ Flashflags beginnt von create aus immer mit "Sichtbar" = 0.
  str r1, [r0]
  drop
  pop {pc}

  @ -----------------------------------------------------------------------------
  @ Setflags für RAM
setflags_ram:

  @ Eigentlich ganz einfach im Ram:
  popda r2
  @ Hole die Flags des aktuellen Wortes
  ldr r0, =Fadenende
  ldr r0, [r0]

  ldr r1, [r0] @ Flags des zuletzt definierten Wortes holen
  cmp r1, #-1
  ite eq
    moveq r1, r2 @ Direkt setzen, falls an der Stelle noch -1 steht
    orrne r1, r2 @ Hinzuverodern, falls schon Flags da sind

  str r1, [r0]
  pop {pc}

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "variable" @ ( n -- )
@ -----------------------------------------------------------------------------
  push {lr}
  bl create

  ldr r0, =Dictionarypointer
  ldr r1, [r0]

  ldr r2, =Backlinkgrenze
  cmp r1, r2
  bhs variable_ram @ Befinde mich im Ram. Schalte um !

  @ -----------------------------------------------------------------------------
  @ Variable Flash
  
  @ Variablenpointer erniedrigen und zurückschreiben
  @ Stelle initialisieren
  @ Code für diese Stelle schreiben


      @ Eine echte Flash-Variable entsteht so, dass Platz im Ram angefordert wird.
      @ Prüfe hier, ob genug Ram da ist !? 

  @ Variablenpointer erniedrigen und zurückschreiben
  ldr r0, =VariablenPointer
  ldr r1, [r0]
  sub r1, #4  @ Ram voll ?
  str r1, [r0]

  @ Stelle Initialisieren:
  str tos, [r1]

  @ Code schreiben:
  pushda r1
  bl literalkomma    @ Adresse im Ram immer mit movt --> 12 Bytes
  pushdaconst 0x4770 @ Opcode für bx lr --> 2 Bytes
  bl hkomma
  bl komma @ Initialisierungswert brennen

  pushdaconst Flag_ramallot|1
  bl setflags
  bl smudge
  pop {pc}


  @ -----------------------------------------------------------------------------
  @ Variable RAM
variable_ram:

  @ Hole den Dictionarypointer.
  bl here
  add tos, #14 @ Länge der Befehle

  bl literalkomma    @ Adresse im Ram immer mit movt --> 12 Bytes
  pushdaconst 0x4770 @ Opcode für bx lr --> 2 Bytes
  bl hkomma
  bl komma @ Variable initialisieren oder den Initialisierungswert brennen

  bl setze_faltbarflag
  bl smudge
  pop {pc}

 
/*
@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "c," @ ( x -- ) 
ckomma: @ Fügt 8 Bits an das Dictionary an.
@ -----------------------------------------------------------------------------
  push {r0, r1, r2, lr}
  ldr r0, =Dictionarypointer
  ldr r1, [r0] @ Hole den Dictionarypointer

  popda r2
  strb r2, [r1] @ Schreibe das Halbword in das Dictionary

  pushdaconst 1
  bl allot

  pop {r0, r1, r2, pc}

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "h," @ ( x -- ) 
hkomma: @ Fügt 16 Bits an das Dictionary an.
@ -----------------------------------------------------------------------------
  push {r0, r1, r2, lr}
  ldr r0, =Dictionarypointer
  ldr r1, [r0] @ Hole den Dictionarypointer

  popda r2
  strh r2, [r1] @ Schreibe das Halbword in das Dictionary

  pushdaconst 2
  bl allot

  pop {r0, r1, r2, pc}
*/


@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "c," @ ( x -- ) 
ckomma: @ Fügt 8 Bits an das Dictionary an.
@ -----------------------------------------------------------------------------

 @ push {lr}
 @ write "ckomma: " @ Mal gucken, was hier ankommt.
 @ bl dots
 @ pop {lr}


  push {r0, r1, r2, r3, r4, r5, lr}
  ldr r0, =Dictionarypointer
  ldr r1, [r0] @ Hole den Dictionarypointer

  ldr r2, =Backlinkgrenze
  cmp r1, r2
  bhs ckomma_ram @ Befinde mich im Ram. Schalte um !

  @ ckomma für Flash:
  pushda r1 @ Adresse auch auf den Stack
  bl c_flashkomma

  pushdaconst 1
  bl allot

  pop {r0, r1, r2, r3, r4, r5, pc}


ckomma_ram:
  popda r2 @ Inhalt holen
  strb r2, [r1] @ Schreibe das Halbword in das Dictionary

  pushdaconst 1
  bl allot

  pop {r0, r1, r2, r3, r4, r5, pc}




@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "h," @ ( x -- ) 
hkomma: @ Fügt 16 Bits an das Dictionary an.
@ -----------------------------------------------------------------------------
  push {r0, r1, r2, r3, r4, r5, lr}
  ldr r0, =Dictionarypointer
  ldr r1, [r0] @ Hole den Dictionarypointer

  ldr r2, =Backlinkgrenze
  cmp r1, r2
  bhs hkomma_ram @ Befinde mich im Ram. Schalte um !

  @ hkomma für Flash:
  pushda r1 @ Adresse auch auf den Stack
  bl h_flashkomma

  pushdaconst 2
  bl allot

  pop {r0, r1, r2, r3, r4, r5, pc}


hkomma_ram:
  popda r2 @ Inhalt holen
  strh r2, [r1] @ Schreibe das Halbword in das Dictionary

  pushdaconst 2
  bl allot

  pop {r0, r1, r2, r3, r4, r5, pc}



/*
@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "," @ ( x -- ) 
komma: @ Fügt 32 Bits an das Dictionary an.
@ -----------------------------------------------------------------------------
  ldr r0, =Dictionarypointer
  ldr r1, [r0] @ Hole den Dictionarypointer

  popda r2
  str r2, [r1] @ Schreibe das Halbword in das Dictionary

  add r1, #4 @ Erhöhe den Dictionarypointer
  str r1, [r0] @ und schreibe ihn zurück

  bx lr
*/

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "," @ ( x -- ) 
komma: @ Fügt 32 Bits an das Dictionary an, in zwei Stücken, damit es nicht auf 4 gerade sein muss.
@ -----------------------------------------------------------------------------
  push {r0, r1, r2, lr}

  dup
  ldr r0, =0xffff @ Low-Teil zuerst - Little Endian ! Außerdem stimmen so die Linkfelder.
  and r0, tos
  bl hkomma

  ldr r0, =0xffff0000 @ High-Teil danach
  and r0, tos
  lsr tos, #16
  bl hkomma

  pop {r0, r1, r2, pc}


@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "><," @ ( x -- ) 
reversekomma: @ Fügt 32 Bits an das Dictionary an, in zwei Stücken, damit es nicht auf 4 gerade sein muss.
@ -----------------------------------------------------------------------------
  push {r0, r1, r2, lr}

  dup
  ldr r0, =0xffff0000 @ High-Teil danach
  and r0, tos
  lsr tos, #16
  bl hkomma

  ldr r0, =0xffff @ Low-Teil zuerst - Little Endian ! Außerdem stimmen so die Linkfelder.
  and r0, tos
  bl hkomma

  pop {r0, r1, r2, pc}

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "align," @ ( -- ) 
alignkomma: @ Macht den Dictionarypointer gerade
@ -----------------------------------------------------------------------------
  ldr r0, =Dictionarypointer
  ldr r1, [r0] @ Hole den Dictionarypointer

  ands r1, #1
  beq 1f

  pushdaconst 0
  b ckomma

1: @ Fertig.
  bx lr

/* Wird nicht benötigt, da die ARM-Cortex-Chips auch an nicht-ausgerichteten Adressen lesen und schreiben können.
@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "align4," @ ( -- ) 
align4komma: @ Macht den Dictionarypointer auf vier gerade
@ -----------------------------------------------------------------------------
  push {lr}
  bl alignkomma @ Schonmal gerade machen
  pop {lr}

  ldr r0, =Dictionarypointer
  ldr r1, [r0] @ Hole den Dictionarypointer

  ands r1, #2
  beq 1f
    @writeln "align4, arbeitet"
    pushdaconst 0
    b hkomma

1: @ Fertig.
  bx lr

*/

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "string," @ ( addr -- ) 
stringkomma: @ Fügt ein String an das Dictionary an
@ -----------------------------------------------------------------------------
        @ Wie type, nur ins Dictionary.
        push    {r0, r1, r3, lr}
        popda r0

        mov     r3, r0
        @ r3 enthält die Stringadresse.
        @ Hole die auszugebende Länge in r1
        ldrb    r1, [r3]

          push {r0, r1, r3}
          pushda r1
          bl ckomma @ Stringlänge schreiben
          pop {r0, r1, r3}

        @ Wenn nichts da ist, bin ich fertig.
        cmp     r1, #0
        beq     2f

        @ Es ist etwas zum Tippen da !
1:      add     r3, #1   @ Adresse um eins erhöhen
        ldrb    r0, [r3] @ Zeichen holen
        pushda r0
          push {r0, r1, r3}
          bl ckomma     @ Zeichen einfügen
          pop {r0, r1, r3}
        subs    r1, #1   @ Ein Zeichen weniger
        bne     1b

2:      bl alignkomma @ Dictionarypointer wieder gerade machen
        pop     {r0, r1, r3, pc}

@------------------------------------------------------------------------------
  Wortbirne Flag_visible, "allot" @ Erhöht den Dictionaryzeiger, schafft Platz !
allot:  @ Überprüft auch gleich, ob ich mich noch im Ram befinde.
        @ Ansonsten verweigtert Allot seinen Dienst.
@------------------------------------------------------------------------------
  ldr r0, =Dictionarypointer
  ldr r1, [r0]

  ldr r2, =Backlinkgrenze
  cmp r1, r2
  bhs allot_ram @ Befinde mich im Ram. Schalte um !

  @ Allot-Flash:
  popda r2    @ Gewünschte Länge
  add r1, r2  @ Pointer vorrücken

  ldr r2, =FlashDictionaryEnde
 
  cmp r1, r2
  blo allot_ok
    writeln "Flash full"
    b quit


  @ Allot-Ram:
allot_ram:
  popda r2    @ Gewünschte Länge
  add r1, r2  @ Pointer vorrücken

@ ldr r2, =RamDictionaryEnde
  ldr r2, =VariablenPointer  @ Am Ende des RAMs liegen die Variablen. Diese sind die Ram-Voll-Grenze...
  ldr r2, [r2]

  cmp r1, r2
  blo allot_ok
    writeln "Ram full"
    b quit

allot_ok: @ Alles paletti, es ist noch Platz da !
  str r1, [r0]
  bx lr

/*
;------------------------------------------------------------------------------
  Wortbirne Flag_visible, "allot" ; Erhöht den Dictionaryzeiger, schafft Platz !
allot:  ; Überprüft auch gleich, ob ich mich noch im Ram befinde.
        ; Ansonsten verweigtert Allot seinen Dienst.
;------------------------------------------------------------------------------
  push r10
  mov &DictionaryPointer, r10
  add @r4+, r10

  ifdef flashdictionaryeinbinden

  cmp #nBacklinkgrenze, &DictionaryPointer
  jhs +

  ifdef ramverwaltungeinbinden
    cmp &VariablenPointer, r10
  else
    cmp #nRamDictionaryEnde, r10
  endif
  jlo ++  ; Solange der DictionaryPointer innerhalb des RAMs ist, ist alles okay.
          ; Oder außerhalb des Variablenbereichs
  writeln " Ram full"
  pop r10
  jmp quit

+ cmp #nFlashDictionaryEnde, r10
  jlo +  ; Solange der DictionaryPointer innerhalb des RAMs ist, ist alles okay.
  writeln " Flash full"
  pop r10
  jmp quit

  else

  cmp #nRamDictionaryEnde, r10
  jlo +  ; Solange der DictionaryPointer innerhalb des RAMs ist, ist alles okay.
  writeln " Ram full"
  pop r10
  jmp quit

  endif

+ mov r10, &DictionaryPointer
  pop r10
  ret
*/

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "compiletoram"
@ -----------------------------------------------------------------------------
  @ Prüfe, ob der Dictionarypointer im Ram oder im Flash ist:
  ldr r0, =Dictionarypointer
  ldr r0, [r0]

  ldr r1, =Backlinkgrenze
  cmp r0, r1
  blo Zweitpointertausch @ Befinde mich im Flash. Schalte um !
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "compiletoflash"
@ -----------------------------------------------------------------------------
  @ Prüfe, ob der Dictionarypointer im Ram oder im Flash ist:
  ldr r0, =Dictionarypointer
  ldr r0, [r0]

  ldr r1, =Backlinkgrenze
  cmp r0, r1
  bhs Zweitpointertausch @ Befinde mich im Ram. Schalte um !
  bx lr


Zweitpointertausch:
  @writeln "Zweitpointertausch"
  @ Hier fehlt noch eine Probe, ob ich nicht schon im Ram bin !

  ldr r0, =Fadenende
  ldr r1, =ZweitFadenende
  ldr r2, [r0]
  ldr r3, [r1]
  str r2, [r1]
  str r3, [r0]

  ldr r0, =Dictionarypointer
  ldr r1, =ZweitDictionaryPointer
  ldr r2, [r0]
  ldr r3, [r1]
  str r2, [r1]
  str r3, [r0]

  @ In R3 ist nun der aktuelle DictionaryPointer.
  @ Der muss immer unterhalb des VariablenPointers sein !

  ldr r0, =VariablenPointer
  ldr r0, [r0]
  cmp r3, r0
  blo 1f 
   writeln " Variables collide with dictionary"
1:bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "create"
create: @ Nimmt das nächste Token aus dem Puffer,
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
    writeln " Create needs name !"
    b quit

1:@ Tokenname ist okay.
  @ Prüfe, ob er schon existiert.
  pushda r0
  dup
  @ ( Tokenadresse Tokenadresse )
  bl find
  @ ( Tokenadresse Einsprungadresse Flags )
  drop @ Benötige die Flags hier nicht. Möchte doch nur schauen, ob es das Wort schon gibt.
  @ ( Tokenadresse Einsprungadresse )  
    
  @ Prüfe, ob die Suche erfolgreich gewesen ist.
  popda r0
  @ ( Tokenadresse )
  cmp r0, #0
  beq 2f
    write "Redefine "
    dup     @ ( Tokenadresse Tokenadresse )
    bl type @ Den neuen Tokennamen nochmal ausgeben
    writeln "."

2:@ ( Tokenadresse )

  bl alignkomma @ Auf zwei gerade machen
  bl here @ Das wird die neue Linkadresse

  @ ( Tokenadresse Neue-Linkadresse )


  @ Prüfe, ob der Dictionarypointer im Ram oder im Flash ist:
  ldr r0, =Dictionarypointer
  ldr r0, [r0]

  ldr r1, =Backlinkgrenze
  cmp r0, r1
  bhs create_ram @ Befinde mich im Ram. Schalte um !

  @ -----------------------------------------------------------------------------
  @ Create für Flash
  @ ( Tokenadresse Neue-Linkadresse )
  @writeln "Create-Flash"

  ldr r0, =FlashFlags
  mov r1, #Flag_visible
  str r1, [r0]  @ Flags vorbereiten

  pushdaconst 4 @ Lücke für die Flags lassen
  bl allot

  @ Link:
  pushdaconst 4 @ Lücke für den Link lassen
  bl allot  
  
  swap
  bl stringkomma @ Den Namen einfügen
  @ ( Neue-Linkadresse )

  @ Jetzt den aktuellen Link an die passende Stelle im letzten Wort einfügen,
  @ falls dort FFFF FFFF steht:

  ldr r0, =Fadenende @ Hole das aktuelle Fadenende
  ldr r1, [r0]

  add r1, #4 @ Flag-Feld überspringen

  ldr r2, [r1] @ Inhalt des Flag-Feldes holen
  cmp r2, #-1  @ Ist der Link ungesetzt ?
  bne 1f

  @ Neuen Link einfügen: Im Prinzip str tos, [r1] über Komma.
    @writeln "Link einfügen"
    @ Dictionary-Pointer verbiegen:
      @ Dictionarypointer sichern
      ldr r4, =Dictionarypointer
      ldr r5, [r4] @ Alten Dictionarypointer auf jeden Fall bewahren

      str r1, [r4] @ Dictionarypointer umbiegen
  
      push {r0, r4, r5, lr}
      dup @ ( Neue-Linkadresse Neue-Linkadresse )
      bl komma          @ Befehl einfügen. Muss ich später auf Komma umbiegen.
      pop {r0, r4, r5, lr}

      str r5, [r4] @ Dictionarypointer wieder zurücksetzen.

1:@ Backlink fertig gesetzt.
  @ Fadenende aktualisieren:
  str tos, [r0] @ Neues-Fadenende in die Fadenende-Variable legen
  drop
  @ Fertig :-)
  pop {pc}


  @ -----------------------------------------------------------------------------
  @ Create fürs RAM
create_ram:
  @ ( Tokenadresse Neue-Linkadresse )
  @writeln "Create-RAM"
  @ Flags setzen
  @ pushdaconst Flag_invisible
  stmdb psp!, {tos}
  mov tos, #Flag_invisible
  bl komma

  @ ( Tokenadresse Neue-Linkadresse )

  @ Link setzen
  ldr r0, =Fadenende
  ldr r1, [r0]
  pushda r1     @ Das alte Fadenende hinein
  bl komma

  @ Das Fadenende aktualisieren
  ldr r0, =Fadenende
  popda r1
  str r1, [r0]
  @ ( Tokenadresse )
  @ Den Namen schreiben
  bl stringkomma

  @ Fertig :-)
  pop {pc}


/*
;------------------------------------------------------------------------------
  Wortbirne Flag_visible, "create"
create: ; Nimmt das nächste Token aus dem Puffer,
        ; erstellt einen neuen Kopf im Dictionary und verlinkt ihn.
;------------------------------------------------------------------------------
  push r10

  call #token  ; Hole den Namen der neuen Definition.
  ; ( Tokenadresse )

  ; Überprüfe, ob der Token leer ist.
  ; Das passiert, wenn der Eingabepuffer nach create leer ist.

  mov   @r4, r10
  mov.b @r10, r10
  tst r10
  jne +

    ; Token ist leer. Brauche Stacks nicht zu putzen.
    writeln " Create needs name !"
    jmp quit

+ ; Tokenname ist okay.
  ; Prüfe, ob er schon existiert.

  ; ( Tokenadresse )
  dup
  ; ( Tokenadresse Tokenadresse )
  call #wortsuche
  ; ( Tokenadresse Einsprungadresse Flags )
  drop ; Benötige die Flags hier nicht. Möchte doch nur schauen, ob es das Wort schon gibt.
  ; ( Tokenadresse Einsprungadresse )
  popda r10
  ; ( Tokenadresse )
  tst r10 ; Prüfe, ob die Suche erfolgreich gewesen ist.
  je +

    write "Redefine "
    dup          ; ( Tokenadresse Tokenadresse )
    call #schreibestringmitlaenge   ; Den neuen Tokennamen nochmal ausgeben
    writeln "."

+ ; ( Tokenadresse )

  call #kommagrade ; Damit ein ungerader Dictionarypointer kein Chaos mehr verursacht.
  push &DictionaryPointer

  pushda #Flag_invisible  ; $FF
  call #ckomma            ; Im Flash wird NIE $FF geschrieben - und im RAM ist das kein Problem.

  ifdef flashdictionaryeinbinden
    mov #Flag_visible, &FlashFlags   ; Für Flash
  endif

  ; Stattdessen ist der String schon im Stack.
  call #kommastring

  ifdef flashdictionaryeinbinden ; Hier wird entschieden, ob Links oder Backlinks geschrieben werden.

  cmp #nBacklinkgrenze, &DictionaryPointer
  jhs +
    ; Für RAM - Links
    pushda &FadenEnde
    call #komma
    jmp ++

+   ; Für Flash - Backlinks

  ; Hier wird nun der Backlink gesetzt/vorbereitet.
  call #zwei_allot ; 2 Bytes Platz für den Backlink einplanen.

  ; Backlink im letzten Wort in die Lücke setzen:
  ; Dies ist eine Berechnung der Adresse des Backlinkfeldes des letzten Wortes.
    call #Fadenende_Einsprungadresse   ; Aus dem letzten Fadenende bestimme ich durch Überlesen des Namens und der Links die Einsprungadresse
    popda r10                ; die hole ich mir wieder
    decd r10                 ; und weiß, dass 2 Bytes davor der Backlink liegt.
    cmp #0FFFFh, @r10        ; Ist der Backlink ungesetzt ?
    jne +                    ; Wenn ja,
      pushdadouble @sp, r10    ; so wird das aktuelle Fadenende, das eben erschaffen wurde dort eingesetzt.
      call #flashstore         ; ehemals mov @sp, @r10
+

  else ; Falls nur ins Ram kompiliert wird
    pushda &FadenEnde
    call #komma
  endif

  pop &FadenEnde ; Der vorhin gesicherte Dictionarypointer ist das neue Fadenende.

  pop r10
  ret
*/

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "Dictionarystart"
dictionarystart: @ ( -- Startadresse des aktuellen Dictionaryfadens )
                 @ Da dies je nach Ram oder Flash unterschiedlich ist...
                 @ Einmal so ausgelagert.
@ -----------------------------------------------------------------------------

  @ Prüfe, ob der Dictionarypointer im Ram oder im Flash ist:
  ldr r0, =Dictionarypointer
  ldr r0, [r0]

  ldr r3, =Fadenende @ Schonmal vorsorglich holen
  ldr r3, [r3]

  ldr r1, =Backlinkgrenze
  cmp r0, r1

  ite lo
    ldrlo r2, =CoreDictionaryAnfang @ Befinde mich im Flash mit Backlinks. Muss beim CoreDictionary anfangen:
    movhs r2, r3                    @ Oberhalb der Backlinkgrenze bin ich im Ram, kann mit dem Fadenende beginnen.

  pushda r2
  bx lr

@ -----------------------------------------------------------------------------
skipstring: @ Überspringt einen String, dessen Adresse in r0 liegt.
@ -----------------------------------------------------------------------------
  push {r3, r4}
    @ String überlesen und Pointer gerade machen
    ldrb r3, [r0] @ Länge des Strings holen
    add r3, #1    @ Plus 1 Byte für die Länge
    and r4, r3, #1 @ Wenn es ungerade ist, noch einen mehr:
    add r3, r4
    add r0, r3  
  pop {r3, r4}
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "find"
find: @ ( str -- Code-Adresse Flags )
@ -----------------------------------------------------------------------------
  push {r0, r1, r2, r3, r4, r5, lr}
        
  @ r0  Hangelpointer
  @ r1  Flags
  @ r2  Aktuellen Link

  @ r3  Zieladresse
  @ r4  Zielflags

  @ r5  Adresse des zu suchenden Strings

  popda r5 @ Zu suchenden String holen

  bl dictionarystart
  popda r0

  mov r3, #0   @ Noch keinen Treffer
  mov r4, #0   @ Und noch keine Trefferflags


1:   @ Ist an der Stelle der Flags und der Namenslänge $FFFF ? Dann ist der Faden abgelaufen.
     @ Prüfe hier die Namenslänge als Kriterium
     add r0, #8 @ 4 Bytes Flags 4 Bytes Link
     ldrb r1, [r0] @ Hole Namenslänge
     cmp r1, #0xFF
     beq 3f        @ Fadenende erreicht
     sub r0, #8


        @ Adresse in r0 zeigt auf:
        @   --> Flagfeld
        ldr r1, [r0]  @ Aktuelle Flags lesen
        add r0, #4

        @   --> Link
        ldr r2, [r0]  @ Aktuellen Link lesen
        add r0, #4

        cmp r1, #-1   @ Flag_invisible ? Überspringen !
        beq 2f

          @ --> Name
          pushda r0
          pushda r5
          bl compare

          cmp tos, #-1 @ Flag vom Vergleich prüfen
          drop
          bne 2f
                
            @ Gefunden !
            @ String überlesen und Pointer gerade machen
            bl skipstring

            mov r3, r0 @ Codestartadresse
            mov r4, r1 @ Flags
            @ writeln "Gefunden"
            @ Prüfe, ob ich mich im Flash oder im Ram befinde.
            @ r0 wird jetzt nicht mehr gebraucht:
            ldr r0, =Backlinkgrenze
            cmp r3, r0
            bhs 3f @ Im Ram beim ersten Treffer ausspringen. 
            @ Im Flash wird weitergesucht, ob es noch eine neuere Definition mit dem Namen gibt.

2:      @ Weiterhangeln

        @ Link prüfen:
        cmp r2, #-1
        beq 3f        @ Link=0xFFFFFFFF bedeutet: Fadenende erreicht.

        @ Link folgen
        mov r0, r2
        b 1b      


3:@ Durchgehangelt. Habe ich etwas gefunden ?
  @ Zieladresse gesetzt, also nicht Null bedeutet: Etwas gefunden !
  pushda r3  @ Zieladresse    oder 0, falls nichts gefunden
  pushda r4  @ Zielflags      oder 0  --> @ ( 0 0 - Nicht gefunden )

  pop {r0, r1, r2, r3, r4, r5, pc}
