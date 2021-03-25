@
@    Mecrisp - A native code Forth implementation for MSP430 microcontrollers
@    Copyright (C) 2011  Matthias Koch
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

@ Initialisiert die Pointer und Flash-Variablen nach dem Neustart.
@ Wird direkt eingefügt und nur einmal beim Start benutzt,
@ deshalb werden Register hier nicht gesichert. 

  @ Suche nun im Flash nach Anfang und Ende.
  
  @ Registerbelegung:
  @ r0 Adresshangelzeiger
  @ r1 Aktuelle Flags
  @ r2 Aktueller Link

  @ r3 Für dies und das

  @ r4 SucheFadenende...

  @ r5 Belegtes Ram.

  ldr r0, =CoreDictionaryAnfang   @ Hier fängt es an.

  ldr r5, =RamDictionaryEnde @ mov #nRamDictionaryEnde, r12 ; Fürs Abzählen des Variablenplatzes

  @ Zwei Möglichkeiten: Vorwärtslink ist $FFFF --> Ende gefunden
  @ Oder Vorwärtslink gesetzt, aber an der Stelle der Namenslänge liegt $FFFF. Dann ist das Ende auch da.
  @ Diese Variante tritt auf, wenn nichts hinzugetan wurde, denn im festen Teil ist der Vorwärtslink
  @ immer gesetzt und zeigt auf den Anfang des Schreib/Löschbaren Teils.

SucheFlashPointer_Hangelschleife:

  @write "Hangelschleife-Anfang "
  @pushda r0
  @bl hexdot

  mov r4, r0 @ Es könnte das Fadenende sein !
  @ Hier ist r0 direkt auf das Flagfeld gerichtet.

  @ Adresse in r0 zeigt auf:
  @   --> Flagfeld
  ldr r1, [r0]  @ Aktuelle Flags lesen
  add r0, #4

  @   --> Link
  ldr r2, [r0]  @ Aktuellen Link lesen
  add r0, #4

  @   --> Namen
  @ Prüfe für die Rambelegung die Flags der aktuellen Definition:

  cmp r1, #-1   @ Flag_invisible ? Überspringen !
  beq Sucheflashpointer_Speicherbelegung_fertig
    @ Dies Wort ist sichtbar. Prüfe, ob es Ram-Speicher anfordert und belegt.
  @  write " Sichtbar: Prüfe die Speicherbelegung"
    tst r1, #Flag_ramallot
    beq Sucheflashpointer_Speicherbelegung_fertig @ Benötigt doch kein RAM.
      writeln "Speicher gewünscht !"
      @ Die Flags werden später nicht mehr gebraucht.
      and r1, #0x0F @ Das unterste Nibble maskieren

        @ Bei Null Bytes brauche ich nichts zu kopieren, den Fall erkennt move.
        lsl r1, #2 @ Mit vier malnehmen
        sub r5, r1 @ Ramvariablenpointer wandern lassen

        @ Den neu geschaffenen Platz initialisieren !
        @ r0 zeigt gerade auf das Namensfeld und wird danach nicht mehr benötigt.
        @ r1 enthält die Zahl der noch zu verschiebenden Bytes
        @ r3 ist frei für uns.
        @ r5 die Startadresse des Ram-Bereiches, der geschrieben werden soll.
        
        @ Muss zuerst schaffen, das Ende der aktuellen Definition zu finden.
        bl skipstring
        @ r0 zeigt nun an den Codebeginn des aktuellen Wortes.
        bl suchedefinitionsende
        @ r0 ist nun an der Stelle, wo die Initialisierungsdaten liegen.
        @ Kopiere die gewünschte Zahl von r1 Bytes von [r0] an [r5]
        pushda r0 @ Quelle
        pushda r5 @ Ziel
        pushda r1 @ Anzahl an Bytes
        bl move

Sucheflashpointer_Speicherbelegung_fertig:
  @ Speicherbelegung und -initialisierung abgeschlossen.
  @ Prüfe den Link
  cmp r2, #-1 @ Ungesetzter Link bedeutet Ende erreicht
  beq SucheFlashPointer_Fadenende_gefunden

 @ writeln " Folge dem Link, er ist gesetzt"

  @ Dem Link folgen
  mov r0, r2

  @ Prüfe, ob die Namenslänge an der Stelle etwas anderes als $FF ist:
  add r2, #8 @ Flags und Link überlegen
  ldrb r2, [r2]
  cmp r2, #0xFF @ Ist an der Stelle der Namenslänge $FF ? Dann ist das Fadenende erreicht.
  beq SucheFlashPointer_Fadenende_gefunden
  
 @ write " Namenslänge nicht $FF, weiterhangeln"
  
  @ Okay, der Faden ist noch nicht am Ende. Es könnte allerdings das letzte Wort sein.
  

  b SucheFlashPointer_Hangelschleife

SucheFlashPointer_Fadenende_gefunden:
  ldr r0, =ZweitFadenende
  str r4, [r0] @ Das Fadenende für den Flash setzen.

  write "Fadenende im Flash: "
  pushda r4
  bl hexdot
  writeln " gefunden."


  ldr r0, =VariablenPointer
  str r5, [r0]

  write "Stand des Variablenpointers: "
  pushda r5
  bl hexdot
  writeln " gefunden."


  @ Mache mich auf die Suche nach dem Dictionarypointer im Flash:
  @ Suche jetzt gleich noch den DictionaryPointer.


  ldr r0, =FlashDictionaryEnde
  ldr r1, =FlashDictionaryAnfang
  ldr r2, =0xffff

  @ Gehe Rückwärts, bis ich aus dem $FFFF-Freigebiet in Daten komme.
1:cmp r0, r1 @  Wenn ich am Anfang angelangt bin, ist das der DictionaryPointer.
  beq 2f

  sub r0, #2
  ldrh r3, [r0]
  cmp r3, r2 @ 0xFFFF
  beq 1b @ Wenn es nicht gleich ist, habe ich eine Füllung gefunden.

  add r0, #2

2:@ Dictionarypointer gefunden.
  ldr r1, =ZweitDictionaryPointer
  str r0, [r1]

  write "Dictionarypointer im Flash: "
  pushda r0
  bl hexdot
  writeln " gefunden."

