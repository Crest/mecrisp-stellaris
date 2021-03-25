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

@ Sprünge, Helferlein und Kontrollstrukturen

@------------------------------------------------------------------------------
  Wortbirne Flag_visible, "cjump," @ Fügt einen bedingten Sprung ein.
cjumpgenerator: @ ( Adresse-der-Opcodelücke Sprungziel Bitmaske -- )
@------------------------------------------------------------------------------ 
  popda r2 @ Bitmaske
  popda r1 @ Sprungziel
  popda r0 @ Adresse-der-Opcodelücke
  
  sub r3, r1, r0 @ Differenz aus Lücken-Adresse und Sprungziel bilden
  subs r3, #4     @ Da der aktuelle Befehl noch läuft und es komischerweise andere Offsets beim ARM gibt.

  @ 8 Bits für die Sprungweiter mit Vorzeichen - 
  @ also habe ich 7 freie Bits, das oberste muss mit dem restlichen Vorzeichen übereinstimmen. 


  ldr r4, =0xFFFFFF01   @ 7 Bits frei
  ands r4, r3
  cmp r4, #0  @ Wenn dies Null ergibt, positive Distanz ok.
  beq 1f

  ldr r5, =0xFFFFFF00
  cmp r4, r5
  beq 1f  @ Wenn es gleich ist: Negative Distanz ok.
    @ Ansonsten ist die Sprungdistanz einfach zu groß.
    writeln "Jump too far"
    b quit

1:


  asrs r3, #1 @ Schieben, da die Sprünge immer auf geraden Adressen beginnen und enden.
  mov r4, #0xFF @ Genau 8 Bits Sprungmaske.
  ands r3, r4    @ Ausschnitt anwenden

  orrs r3, r2    @ Sprungbedingung und den Rest des Opcodes hinzufügen




sprungbefehl_einfuegen:

  @ Dictionarypointer sichern
  ldr r4, =Dictionarypointer
  ldr r5, [r4] @ Alten Dictionarypointer auf jeden Fall bewahren

  str r0, [r4] @ Dictionarypointer umbiegen
  
  push {r4, r5, lr}
  pushda r3
  bl hkomma          @ Befehl einfügen. Muss ich später auf Komma umbiegen.
  pop {r4, r5, lr}

  str r5, [r4] @ Dictionarypointer wieder zurücksetzen.

  bx lr

@------------------------------------------------------------------------------
  Wortbirne Flag_visible, "jump," @ Fügt einen unbedingten Sprung ein.
jumpgenerator: @ ( Adresse-der-Opcodelücke Sprungziel -- )
@------------------------------------------------------------------------------ 
  popda r1 @ Sprungziel
  popda r0 @ Adresse-der-Opcodelücke
  
  sub r3, r1, r0 @ Differenz aus Lücken-Adresse und Sprungziel bilden
  subs r3, #4     @ Da der aktuelle Befehl noch läuft und es komischerweise andere Offsets beim ARM gibt.

  @ 11 Bits für die Sprungweiter mit Vorzeichen - 
  @ also habe ich 10 freie Bits, das oberste muss mit dem restlichen Vorzeichen übereinstimmen. 


  ldr r4, =0xFFFFF801  @ 10 Bits frei
  ands r4, r3
  cmp r4, #0  @ Wenn dies Null ergibt, positive Distanz ok.
  beq 1f

  ldr r5, =0xFFFFF800
  cmp r4, r5
  beq 1f  @ Wenn es gleich ist: Negative Distanz ok.
    @ Ansonsten ist die Sprungdistanz einfach zu groß.
    writeln "Jump too far"
    b quit

1:

  asrs r3, #1 @ Schieben, da die Sprünge immer auf geraden Adressen beginnen und enden.
  ldr r4, =0x7FF @ Genau 11 Bits Sprungmaske.
  ands r3, r4     @ Ausschnitt anwenden

  orrs r3, 0xE000  @ Rest des Opcodes hinzufügen

  b sprungbefehl_einfuegen

@  strh r3, [r0]   @ Befehl einfügen. Muss ich später auf Komma umbiegen.
@  bx lr



@------------------------------------------------------------------------------
@ Verschiedene Sprünge, die von den Kontrollstrukturen gebracht werden.
@------------------------------------------------------------------------------

/*
branch_r:     @ ( -- Sprungziel ) "branch<--"  ; Einleitung bedingter und unbedingter Rückwärtssprung
    b here

r_branch_jnz:
    push #02000h
    jmp +

r_nullbranch: ; ( Sprungziel -- ) "<--0branch" ; Abschluss bedingter Rückwärtssprung
    call #nullprobekomma
    push #0010010000000000b ; Opcode für einen bedingten Sprung jz
    jmp +

r_branch:     ; ( Sprungziel -- ) "<--branch" ; Abschluss unbedingter Rückwärtssprung
    push #0011110000000000b ; Opcode für einen unbedingten Sprung jmp
+   call #branch_v ; pushdadouble &DictionaryPointer, #2
                   ; call #allot
    call #swap_sprung ; swap
    r_from
    jmp jumpgenerator

nullbranch_v: ; ( -- Adresse-für-Sprungbefehl ) "0branch-->" ; Einleitung bedingter Vorwärtssprung
    call #nullprobekomma
branch_v:     ; ( -- Adresse-für-Sprungbefehl ) "branch-->"  ; Einleitung unbedingter Vorwärtssprung
    pushda &DictionaryPointer
    br #zwei_allot

  ifdef caseeinbinden
v_casebranch:
    push #02000h ; Opcode für einen bedingten Sprung jnz
    jmp +
  endif

v_nullbranch: ; ( Adresse-für-Sprungbefehl -- ) "-->0branch" ; Abschluss bedingter Vorwärtssprung
    push #0010010000000000b ; Opcode für einen bedingten Sprung jz
    jmp +

v_branch:     ; ( Adresse-für-Sprungbefehl -- ) "-->branch" ; Abschluss unbedingter Vorwärtssprung
    push #0011110000000000b ; Opcode für einen unbedingten Sprung jmp
+   pushdadouble &DictionaryPointer, @sp+
    jmp jumpgenerator

*/

nullprobekomma:
@  beq.n 1f
@  drop
@1: drop

 @ cmp tos, #0
 @ drop
 @ beq branch_v

@    132e:	2e00      	cmp	r6, #0
@    1330:	cf40      	ldmia	r7!, {r6}

  push {lr}
  pushdaconst 0x2e00 @ cmp tos, #0
  bl hkomma
  pushdaconstw 0xcf40 @ drop
  bl hkomma
  pop {pc}



branch_r:     @ ( -- Sprungziel ) "branch<--"  ; Einleitung bedingter und unbedingter Rückwärtssprung
    b here


r_branch_jne: @ ( Sprungziel -- ) "<--0branch" ; Abschluss besonderer bedingter Rückwärtssprung für loop
  push {lr}
  bl branch_v @ ( pushda Dictionaryinter und 2 allot )
  swap
  pushdaconst 0xD100 @ Opcode für den bedingten Sprung bne
  bl cjumpgenerator
  pop {pc}

r_branch_jvc: @ ( Sprungziel -- ) "<--0branch" ; Abschluss besonderer bedingter Rückwärtssprung für +loop
  push {lr}
  bl branch_v @ ( pushda Dictionaryinter und 2 allot )
  swap
  pushdaconst 0xD700 @ Opcode für den bedingten Sprung bvc
  bl cjumpgenerator
  pop {pc}


r_nullbranch: @ ( Sprungziel -- ) "<--0branch" ; Abschluss bedingter Rückwärtssprung
  push {lr}
  bl nullprobekomma
  bl branch_v @ ( pushda Dictionaryinter und 2 allot )
  swap
  pushdaconst 0xD000 @ Opcode für den bedingten Sprung beq
  bl cjumpgenerator
  pop {pc}

r_branch:     @ ( Sprungziel -- ) "<--branch" ; Abschluss unbedingter Rückwärtssprung
  push {lr}
  bl branch_v @ ( pushda Dictionaryinter und 2 allot )
  swap
  bl jumpgenerator
  pop {pc}


nullbranch_v: @ ( -- Adresse-für-Sprungbefehl ) "0branch-->" ; Einleitung bedingter Vorwärtssprung
  push {lr}
  bl nullprobekomma
  bl here
  pushdaconst 2 @ Platz für die Opcodelücke schaffen
  bl allot
  pop {pc}

branch_v:     @ ( -- Adresse-für-Sprungbefehl ) "branch-->"  ; Einleitung unbedingter Vorwärtssprung
  push {lr}
  bl here
  pushdaconst 2 @ Platz für die Opcodelücke schaffen
  bl allot
  pop {pc}


v_branch: @ Abschluss unbedingter Vorwärtssprung
  push {lr}
  bl here @ Sprungziel aus den Stack legen
  bl jumpgenerator
  pop {pc}

v_nullbranch:
  push {lr}
  bl here @ Sprungziel
  pushdaconst 0xD000 @ Opcode für den bedingten Sprung beq
  bl cjumpgenerator
  pop {pc}

v_casebranch:
  push {lr}
  bl here @ Sprungziel
  pushdaconst 0xD100 @ Opcode für den bedingten Sprung bne
  bl cjumpgenerator
  pop {pc}

@------------------------------------------------------------------------------
  Wortbirne Flag_immediate_compileonly, "then"
  @ ( -- Adresse-für-Sprung 2 | Adresse-für-Sprung 5 )
@------------------------------------------------------------------------------
  cmp tos, #5 @ Kommend aus Else-Zweig
  bne 1f
    drop @ ( Sprunglücke )    
    b v_branch @ Abschluss unbedingter Vorwärtssprung

1:cmp tos, #2 @ Kommend aus IF-Zweig
  bne strukturen_passen_nicht
    drop @ ( Sprunglücke )
    b v_nullbranch @ Abschluss bedingter Vorwärtssprung v_nullbranch

strukturen_passen_nicht:
  writeln "Structures don't match"
  b quit

@------------------------------------------------------------------------------
  Wortbirne Flag_immediate_compileonly, "else"
  @ ( Adresse-für-Sprung 2 -- Adresse-für-Sprung 5 )
@------------------------------------------------------------------------------
  @ Else macht es ein kleines bisschen Komplizierter.
  @ Bedingung  if           [true]    else                  [false]   then      Folgendes.
  @            0branch-->             branch--> -->0branch            -->branch
  push {lr}
  cmp tos, #2
  bne strukturen_passen_nicht
  drop

  @ ( Bedingter-Sprung )
  bl branch_v
  @ ( Bedingter-Sprung Unbedingter-Sprung )
  swap
  @ ( Unbedingter-Sprung Bedingter-Sprung )
  bl v_nullbranch
  @ ( Unbedingter Sprung )
  pushdaconst 5 @ Strukturerkennung bereitlegen
  @ ( Unbedingter Sprung 5 )
  pop {pc}

@------------------------------------------------------------------------------
  Wortbirne Flag_immediate_compileonly, "if"
struktur_if: @ ( -- Adresse-für-Sprung 2 )
@------------------------------------------------------------------------------
  push {lr}
  bl nullbranch_v
  pushdaconst 2           @ Strukturerkennung
  pop {pc}

@ : schleife begin key 27 <> while ." Moin" repeat ;


@------------------------------------------------------------------------------
  Wortbirne Flag_immediate_compileonly, "repeat"  @ Wie das Pascal-While-Konstrukt.
  @ ( Sprungziel Adresse-für-Sprung 4 -- )
@------------------------------------------------------------------------------
  @ begin (Bedingung) while (Agenda) repeat (Folgendes).
  @ In Pascal: while (true) do Agenda;

  @ ( Sprungziel-zurück-an-Anfang Adresse-für-Sprung-ans-Ende 4 )
  cmp tos, #4
  bne strukturen_passen_nicht
  drop
  @ ( Sprungziel-zurück-an-Anfang  Adresse-für-Sprung-ans-Ende )
  swap
  @ ( Adresse-für-Sprung-ans-Ende Sprungziel-zurück-an-Anfang )
  push {lr}
  bl r_branch @ Rücksprung an den Anfang, falls ich normal einlaufe
  @ ( Adresse-für-Sprung-ans-Ende )
  bl v_nullbranch @ Raussprung aus dem Konstrukt.
  pop {pc}

@------------------------------------------------------------------------------
  Wortbirne Flag_immediate_compileonly, "while"  @ Wie das Pascal-While-Konstrukt.
  @ ( Sprungziel 1 -- Sprungziel Adresse-Für-Sprung 4 )
@------------------------------------------------------------------------------
  @ begin (Bedingung) while (Agenda) repeat (Folgendes).
  @ In Pascal: while (true) do Agenda;
  cmp tos, #1
  bne strukturen_passen_nicht
  drop
  @ ( Sprungziel ) wird für den späteren Rücksprung benutzt.
  push {lr}
  bl struktur_if @ Benutze einfach mal If.
  @ ( Sprungziel Adresse-Für-Sprung 2 )
  adds tos, #2
  @ ( Sprungziel Adresse-Für-Sprung 4 ) ; Strukturkennung 4 !
  pop {pc}

@------------------------------------------------------------------------------
  Wortbirne Flag_immediate_compileonly, "until"  @ Bedingte Schleife
  @ ( Sprungziel 1 -- )
@------------------------------------------------------------------------------
  cmp tos, #1
  bne strukturen_passen_nicht
  drop
  b r_nullbranch

@------------------------------------------------------------------------------
  Wortbirne Flag_immediate_compileonly, "again"  @ Endlosschleife
  @ ( Sprungziel 1 -- )
@------------------------------------------------------------------------------
  cmp tos, #1
  bne strukturen_passen_nicht
  drop
  b r_branch

@------------------------------------------------------------------------------
  Wortbirne Flag_immediate_compileonly, "begin"
  @ ( -- Sprungziel 1 )
@------------------------------------------------------------------------------
  push {lr}
  bl branch_r
  pushdaconst 1       @ Strukturerkennung
  pop {pc}

@------------------------------------------------------------------------------
  Wortbirne Flag_immediate_compileonly, "exit" @ Kompiliert ein ret mitten in die Definition.
@------------------------------------------------------------------------------
  b retkomma

@ : viel begin [ .s ] ." Huhu " key 27 =  [ .s ] until ;
@ : viel begin [ .s ] 1 [ .s ] until ;
@ : taste begin ?key until ; Funktioniert.


