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

@ Die zählenden Schleifen
 
rloopindex .req r10
rlooplimit .req r11

@------------------------------------------------------------------------------
  Wortbirne Flag_inline, "k" @ Kopiert den drittobersten Schleifenindex
@------------------------------------------------------------------------------
  @ Returnstack ( Limit Index Limit Index )
  stmdb psp!, {tos}
  ldr tos, [sp, #-8]
  bx lr

@------------------------------------------------------------------------------
  Wortbirne Flag_inline, "j" @ Kopiert den zweitobersten Schleifenindex
@------------------------------------------------------------------------------
  @ Returnstack ( Limit Index )
  stmdb psp!, {tos}
  ldr tos, [sp]
  bx lr

@------------------------------------------------------------------------------
  Wortbirne Flag_inline, "i" @ Kopiert den obersten Schleifenindex
@------------------------------------------------------------------------------
  @ Returnstack ( )
  pushda rloopindex @ Ist immer im Register.
  bx lr


/* Ein paar Testfälle

: table   cr 11 1 do
                    i 8 = if leave then
                    11 1 do
                           i j * . space
                           j 5 = if leave then
                           j 2 = if leave then
                         loop
                    cr
                  loop ;

: stars 0 ?do [char] * emit loop ;
: stars5 0 ?do [char] * emit   i 5 = if leave then loop ;

: table   cr 11 1 do 11 1 do i j * . space loop cr loop ;
: table   cr 11 1 do [ .s ] 11 1 do [ .s ] i j * . space loop [ .s ] cr loop [ .s ] ;
: table  cr 11 1 do i 8 = if leave then 11 1 do  i j * . space j 5 = if leave then  j 2 = if leave then loop cr loop ;

*/

@------------------------------------------------------------------------------
  Wortbirne Flag_immediate_compileonly, "leave" @ Beendet die Schleife sofort.
  @ ( ... AlterLeavePointer 0 Sprungziel 3 ... )
  @ --
  @ ( ... AlterLeavePointer Vorwärtssprungziel{or-1-JZ} Sprungziel 3 ... )
@------------------------------------------------------------------------------
  @ Der LeavePointer zeigt an die Stelle, wo steht, wie viele Spezialsprünge noch abzuarbeiten sind.
  @ Alle Stackelemente weiterschieben, Sprungadresse einfügen, Zähler erhöhen, Lücke anlegen.

  push {lr}
  
  @ Agenda:
  @ An dieser Stelle eine Vorwärtssprunglücke präparieren:
  @ TOS bleibt TOS
  @ Muss eine Lücke im Stack schaffen, alles NACH der Position des leavepointers muss weiterrücken.

  ldr r0, =leavepointer
  ldr r1, [r0] @ Die Stelle, wohin er zeigt = Inhalt der Variable Leavepointer

  mov r3, psp @ Alter Stackpointer
  subs psp, #4 @ Ein Element mehr auf dem Stack

1:@ Lückenschiebeschleife
  ldr r2, [r3]  @ mov @r10, -2(r10)
  subs r3, #4 
  str r2, [r3]
  adds r3, #4

  adds r3, #4
  cmp r3, r1 @ r1 enthält die Stelle am Ende
  bne 1b 

  @ Muss jetzt die Stelle auf dem Stack, wo die Sprünge gezählt werden um Eins erhöhen
  @ und an der freigewordenen Stelle die Lückenadresse einfügen.

  push {r0, r1}
  bl branch_v
  pop {r0, r1}

  popda r3 @ Die Lückenadresse

  subs r1, #4 @ Weiter in Richtung Spitze des Stacks wandern
  str r3, [r1] @ Lückenadresse einfügen

  @ Den neuen Leavepointer vermerken
  str r1, [r0]

  subs r1, #4   @ Weiter in Richtung Spitze des Stacks wandern
  ldr r2, [r1] @ Sprungzähler aus dem Stack kopieren

  adds r2, #1   @ Den Sprungzähler um eins erhöhen
  str r2, [r1] @ und zurückschreiben.

  pop {pc}


@------------------------------------------------------------------------------
  Wortbirne Flag_inline, "unloop" @ Wirft die Schleifenstruktur vom Returnstack
unloop:
@------------------------------------------------------------------------------
  pop {rloopindex, rlooplimit}  @ Hole die alten Schleifenwerte zurück
  bx lr

@ : mealsforwholeday cr 25 6 do i dup roman ." : " mealtime cr 2 +loop cr ;
@ : ml+ cr 25 6 do i . space 2 +loop ;

@------------------------------------------------------------------------------
  Wortbirne Flag_immediate_compileonly, "+loop" @ Es wird benutzt mit ( Increment -- ).
  @ ( Sprungziel 3 -- ) ohne leave
  @ ( AlterLeavePointer ... ZahlderAdressen Sprungziel 3 -- ) mit leave
@------------------------------------------------------------------------------
  cmp tos, #3
  bne strukturen_passen_nicht
  drop

  push {lr} 
  ldr r0, =struktur_plusloop

  pushda r0
  bl inlinekomma  

  bl r_branch_jvc @ Oder ein anderer Sprung ?

  bl spruenge_einpflegen @ Die gleiche Routine ist in Endcase am Werk

  ldr r0, =leavepointer
  popda r1
  str r1, [r0]           @ Zurückholen für die nächste Schleifenebene


  ldr r0, =unloop
  pushda r0
  bl inlinekomma
  pop {pc}


struktur_plusloop:
  adds rloopindex, #0x80000000  @ Index + $8000
  subs rloopindex, rlooplimit   @ Index + $8000 - Limit

  adds rloopindex, tos         @ Index + $8000 - Limit + Schritt  Hier werden die Flags gesetzt. Überlauf bedeutet: Schleife beenden.
  drop                         @ Runterwerfen, dabei Flags nicht verändern

  add rloopindex, rlooplimit   @ Index + $8000 + Schritt   Flags nicht verändern !
  sub rloopindex, #0x80000000  @ Index + Schritt           Flags nicht verändern !
  bx lr

@------------------------------------------------------------------------------
  Wortbirne Flag_immediate_compileonly, "loop" @ Es wird benutzt mit ( -- ).
  @ ( Sprungziel 3 -- ) ohne leave
  @ ( AlterLeavePointer ... ZahlderAdressen Sprungziel 3 -- ) mit leave
@------------------------------------------------------------------------------
  cmp tos, #3
  bne strukturen_passen_nicht
  drop

  push {lr} 
  ldr r0, =struktur_loop

  pushda r0
  bl inlinekomma  

  bl r_branch_jne

  bl spruenge_einpflegen @ Die gleiche Routine ist in Endcase am Werk

  ldr r0, =leavepointer
  popda r1
  str r1, [r0]           @ Zurückholen für die nächste Schleifenebene


  ldr r0, =unloop
  pushda r0
  bl inlinekomma
  pop {pc}

struktur_loop:
  adds rloopindex, #1          @ Index erhöhen
  cmp rloopindex, rlooplimit  @ Mit Limit vergleichen
  bx lr @ Ende für inline,
  
@------------------------------------------------------------------------------
  Wortbirne Flag_immediate_compileonly, "do" @ Es wird benutzt mit ( Limit Index -- ).
  @ ( -- Sprungziel 3 ) ohne leave
  @ ( -- AlterLeavePointer 0 Sprungziel 3 ) mit leave
@------------------------------------------------------------------------------
  push {lr}
  ldr r0, =struktur_do
  pushda r0
  bl inlinekomma


  ldr r0, =leavepointer
  ldr r1, [r0]
  pushda r1     @ Alten Leavepointer sichern
  pushdaconst 0
  str psp, [r0] @ Aktuelle Position im Stack sichern


  bl branch_r    @ Schleifen-Rücksprung vorbereiten
  pushdaconst 3  @ Strukturerkennung
  pop {pc}

struktur_do:
  push {rloopindex, rlooplimit}
  popda rloopindex
  popda rlooplimit
  bx lr @ Ende für inline,


@------------------------------------------------------------------------------
  Wortbirne Flag_immediate_compileonly, "?do" @ Es wird benutzt mit ( Limit Index -- ).
  @ ( -- Sprungziel 3 ) ohne leave
  @ ( -- AlterLeavePointer 0 Sprungziel 3 ) mit leave

  @ ( -- AlterLeavePointer Vorsprungadresse 1 Sprungziel 3 )
  @ Diese Schleife springt sofort ans Ende, wenn Limit=Index.
@------------------------------------------------------------------------------
  push {lr}
  ldr r0, =struktur_qdo
  pushda r0
  bl inlinekomma


  ldr r0, =leavepointer
  ldr r1, [r0]  @ here 2 allot
  pushda r1     @ Alten Leavepointer sichern

  @ An diese Stelle nun die Vorwärtssprunglücke einfügen:
  bl branch_v
  orrs tos, #1   @ Markierung anbringen, dass ich mir einen bedingten Sprung wünsche

  pushdaconst 1
  ldr r0, =leavepointer
  str psp, [r0] @ Aktuelle Position im Stack sichern

  
  bl branch_r    @ Schleifen-Rücksprung vorbereiten
  pushdaconst 3  @ Strukturerkennung
  pop {pc}

struktur_qdo:
  push {rloopindex, rlooplimit}
  popda rloopindex
  popda rlooplimit
  cmp rloopindex, rlooplimit @ Vergleiche die beiden Schleifenparameter
  bx lr @ Ende für inline,
