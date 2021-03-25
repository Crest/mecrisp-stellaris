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
    subs r1, #2
    ldrh r2, [r1]
    ldr r3, =0xFFFF
    cmp r2, r3
    bne 1f
      @ writeln "Füge in Smudge eine Enderkennungs-Null ein."
      pushdaconst 0
      bl hkomma
1:  @ Okay, Ende gut, alles gut.

    @ Brenne die gesammelten Flags:
    ldr r0, =FlashFlags
    ldr r0, [r0]
    pushda r0
    
    ldr r1, =Fadenende
    ldr r1, [r1]  

    @ Dictionary-Pointer verbiegen:
      @ Dictionarypointer sichern
      ldr r2, =Dictionarypointer
      ldr r3, [r2] @ Alten Dictionarypointer auf jeden Fall bewahren

      str r1, [r2] @ Dictionarypointer umbiegen
      bl hkomma     @ Flags einfügen
      str r3, [r2] @ Dictionarypointer wieder zurücksetzen.

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
  orrs r1, tos  @ Flashflags beginnt von create aus immer mit "Sichtbar" = 0.
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

  ldrh r1, [r0] @ Flags des zuletzt definierten Wortes holen
  movw r3, 0xFFFF
  cmp r1, r3
  ite eq
    moveq r1, r2 @ Direkt setzen, falls an der Stelle noch -1 steht
    orrne r1, r2 @ Hinzuverodern, falls schon Flags da sind

  strh r1, [r0]
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
  subs r1, #4  @ Ram voll ?
  str r1, [r0]

  @ Stelle Initialisieren:
  str tos, [r1]

  @ Code schreiben:
  pushda r1
  bl literalkomma    @ Adresse im Ram immer mit movt --> 12 Bytes
  pushdaconstw 0x4770 @ Opcode für bx lr --> 2 Bytes
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
  adds tos, #14 @ Länge der Befehle

  bl literalkomma    @ Adresse im Ram immer mit movt --> 12 Bytes
  pushdaconstw 0x4770 @ Opcode für bx lr --> 2 Bytes
  bl hkomma
  bl komma @ Variable initialisieren oder den Initialisierungswert brennen

  bl setze_faltbarflag
  bl smudge
  pop {pc}

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "align," @ ( -- ) 
alignkomma: @ Macht den Dictionarypointer gerade
@ -----------------------------------------------------------------------------
  ldr r0, =Dictionarypointer
  ldr r1, [r0] @ Hole den Dictionarypointer

  ands r1, #1
  beq 1f

  pushdaconst 0
  b.n ckomma

1: @ Fertig.
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "c," @ ( x -- ) 
ckomma: @ Fügt 8 Bits an das Dictionary an.
@ -----------------------------------------------------------------------------
  push {lr} @ Wird intern nur von string, benutzt.
  ldr r0, =Dictionarypointer
  ldr r1, [r0] @ Hole den Dictionarypointer

  ldr r2, =Backlinkgrenze
  cmp r1, r2
  bhs.n ckomma_ram @ Befinde mich im Ram. Schalte um !

  @ ckomma für Flash:
  pushda r1 @ Adresse auch auf den Stack
  bl c_flashkomma
  b.n ckomma_fertig

ckomma_ram:
  popda r2 @ Inhalt holen
  strb r2, [r1] @ Schreibe das Halbword in das Dictionary

ckomma_fertig:
  pushdaconst 1
  bl allot
  pop {pc}

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "h," @ ( x -- ) 
hkomma: @ Fügt 16 Bits an das Dictionary an.
@ -----------------------------------------------------------------------------
  push {r0, r1, r2, r3, lr}
  ldr r0, =Dictionarypointer
  ldr r1, [r0] @ Hole den Dictionarypointer

  ldr r2, =Backlinkgrenze
  cmp r1, r2
  bhs hkomma_ram @ Befinde mich im Ram. Schalte um !

  @ hkomma für Flash:
  pushda r1 @ Adresse auch auf den Stack
  bl h_flashkomma

  b.n hkomma_fertig

hkomma_ram:
  popda r2 @ Inhalt holen
  strh r2, [r1] @ Schreibe das Halbword in das Dictionary

hkomma_fertig:
  pushdaconst 2
  bl allot

  pop {r0, r1, r2, r3, pc}


@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "," @ ( x -- ) 
komma: @ Fügt 32 Bits an das Dictionary an, in zwei Stücken, damit es nicht auf 4 gerade sein muss.
@ -----------------------------------------------------------------------------
  push {lr}
  dup
  bl hkomma @ Low-Teil zuerst - Little Endian ! Außerdem stimmen so die Linkfelder.

  lsrs tos, #16 @ High-Teil danach
  bl hkomma
  pop {pc}


@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "><," @ ( x -- ) 
reversekomma: @ Fügt 32 Bits an das Dictionary an, in zwei Stücken, damit es nicht auf 4 gerade sein muss.
@ -----------------------------------------------------------------------------
  push {lr}
  dup
  lsrs tos, #16 @ High-Teil danach
  bl hkomma

  bl hkomma @ Low-Teil zuerst - Little Endian ! Außerdem stimmen so die Linkfelder.
  pop {pc}



@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "string," @ ( addr -- ) 
stringkomma: @ Fügt ein String an das Dictionary an
@ -----------------------------------------------------------------------------
   push {r0, r1, r2, lr}
   @ Schreibt einen String in 16-Bit-Happen ins Dictionary

   popda r0      @ Hole die Stringadresse
   ldrb r1, [r0] @ Hole die auszugebende Länge in r2
   adds r1, #1   @ Ein Byte mehr ausgeben, das Längenbyte zählt mit

   @ Gib nun ab der Adresse r0 so viele Bytes aus, wie in r1 registriert sind.
1: @ Zuerst in Zweierblöcken voranschreiten:
   cmp r1, #2
   blo 2f

   ldrh r2, [r0] @ Zwei Bytes holen
   pushda r2     @   und ins Dictionary schreiben
   bl hkomma

   adds r0, #2 @ Pointer weiterrücken
   subs r1, #2 @ Zwei Zeichen weniger
   beq 3f      @ Null erreicht ? Fertig !
   b 1b

2: @ Ein Zeichen übrig:
   ldrb r2, [r0] @ Ein Byte holen, der Rest des Registers wird automatisch ausgenullt
   pushda r2     @ Little Endian sei Dank :-)
   bl hkomma

3: @ Fertig !
   pop {r0, r1, r2, pc}

@------------------------------------------------------------------------------
  Wortbirne Flag_visible, "allot" @ Erhöht den Dictionaryzeiger, schafft Platz !
allot:  @ Überprüft auch gleich, ob ich mich noch im Ram befinde.
        @ Ansonsten verweigtert Allot seinen Dienst.
@------------------------------------------------------------------------------
  ldr r0, =Dictionarypointer
  ldr r1, [r0]

  ldr r2, =Backlinkgrenze
  cmp r1, r2
  bhs.n allot_ram @ Befinde mich im Ram. Schalte um !

  @ Allot-Flash:
  popda r2    @ Gewünschte Länge
  adds r1, r2  @ Pointer vorrücken

  ldr r2, =FlashDictionaryEnde
 
  cmp r1, r2
  blo.n allot_ok
    Fehler_Quit "Flash full"

  @ Allot-Ram:
allot_ram:
  popda r2    @ Gewünschte Länge
  adds r1, r2  @ Pointer vorrücken

@ ldr r2, =RamDictionaryEnde
  ldr r2, =VariablenPointer  @ Am Ende des RAMs liegen die Variablen. Diese sind die Ram-Voll-Grenze...
  ldr r2, [r2]

  cmp r1, r2
  blo.n allot_ok
    Fehler_Quit "Ram full"

allot_ok: @ Alles paletti, es ist noch Platz da !
  str r1, [r0]
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "compiletoram"
@ -----------------------------------------------------------------------------
  @ Prüfe, ob der Dictionarypointer im Ram oder im Flash ist:
  ldr r0, =Dictionarypointer
  ldr r0, [r0]

  ldr r1, =Backlinkgrenze
  cmp r0, r1
  blo.n Zweitpointertausch @ Befinde mich im Flash. Schalte um !
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "compiletoflash"
@ -----------------------------------------------------------------------------
  @ Prüfe, ob der Dictionarypointer im Ram oder im Flash ist:
  ldr r0, =Dictionarypointer
  ldr r0, [r0]

  ldr r1, =Backlinkgrenze
  cmp r0, r1
  bhs.n Zweitpointertausch @ Befinde mich im Ram. Schalte um !
  bx lr


Zweitpointertausch:
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
   push {lr} 
   writeln " Variables collide with dictionary"
   pop {lr}
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
    Fehler_Quit " Create needs name !"

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
  movs r1, #Flag_visible
  str r1, [r0]  @ Flags vorbereiten

  pushdaconst 6 @ Lücke für die Flags und Link lassen
  bl allot
  
  swap
  bl stringkomma @ Den Namen einfügen
  @ ( Neue-Linkadresse )

  @ Jetzt den aktuellen Link an die passende Stelle im letzten Wort einfügen,
  @ falls dort FFFF FFFF steht:

  ldr r0, =Fadenende @ Hole das aktuelle Fadenende
  ldr r1, [r0]

  adds r1, #2 @ Flag-Feld überspringen

  ldr r2, [r1] @ Inhalt des Link-Feldes holen
  cmp r2, #-1  @ Ist der Link ungesetzt ?
  bne 1f

  @ Neuen Link einfügen: Im Prinzip str tos, [r1] über Komma.
    @writeln "Link einfügen"
    @ Dictionary-Pointer verbiegen:
      @ Dictionarypointer sichern
      ldr r2, =Dictionarypointer
      ldr r3, [r2] @ Alten Dictionarypointer auf jeden Fall bewahren
      str r1, [r2] @ Dictionarypointer umbiegen
      dup @ ( Neue-Linkadresse Neue-Linkadresse )
      bl komma     @ Link einfügen
      str r3, [r2] @ Dictionarypointer wieder zurücksetzen.



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
  movs tos, #Flag_invisible
  bl hkomma

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
  push {r1, r2}
    @ String überlesen und Pointer gerade machen
    ldrb r1, [r0] @ Länge des Strings holen
    adds r1, #1    @ Plus 1 Byte für die Länge
    ands r2, r1, #1 @ Wenn es ungerade ist, noch einen mehr:
    adds r1, r2
    adds r0, r1  
  pop {r1, r2}
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

  movs r3, #0   @ Noch keinen Treffer
  movs r4, #0   @ Und noch keine Trefferflags


1:   @ Ist an der Stelle der Flags und der Namenslänge $FFFF ? Dann ist der Faden abgelaufen.
     @ Prüfe hier die Namenslänge als Kriterium
     adds r0, #8 @ 4 Bytes Flags 4 Bytes Link
     ldrb r1, [r0] @ Hole Namenslänge
     cmp r1, #0xFF
     beq 3f        @ Fadenende erreicht
     subs r0, #8


        @ Adresse in r0 zeigt auf:
        @   --> Flagfeld
        ldrh r1, [r0]  @ Aktuelle Flags lesen
        adds r0, #2

        movw r2, #0xFFFF
        cmp r1, r2       @ Flag_invisible ? Überspringen !
          @   --> Link
          ldr r2, [r0]  @ Aktuellen Link lesen, verändert Flags nicht !
        beq 2f        

        adds r0, #4 @ Link überspringen

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
