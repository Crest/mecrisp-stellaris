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

@ Case-Struktur

@------------------------------------------------------------------------------
  Wortbirne Flag_immediate_compileonly, "case"
  @ ( -- 0 8 )
case:
@------------------------------------------------------------------------------
  pushdaconst 0 @ Zahl der Zweige
  pushdaconst 8 @ Strukturerkennung
  bx lr

@ : wahl case 1 of ." Eins" endof 2 of ." Zwei" endof dup 3 = ?of ." Drei?" endof ." Andere" endcase ;
@------------------------------------------------------------------------------
  Wortbirne Flag_immediate_compileonly, "?of"
  @ ( ... #of 8 -- ... addr #of+1 9 )
  @ Nimmt einen Flag statt einer Konstanten entgegen.
  @ Kann so eigene Vergleiche aufbauen.
@------------------------------------------------------------------------------
  ldr r0, =struktur_qof
  b of_inneneinsprung

struktur_qof:
  cmp tos, #-1
  drop
  @ bne...
  bx lr

@------------------------------------------------------------------------------
  Wortbirne Flag_immediate_compileonly, "of"
  @ ( ... #of 8 -- ... addr #of+1 9 )
@------------------------------------------------------------------------------
  ldr r0, =struktur_of

of_inneneinsprung:
  cmp tos, #8
  bne strukturen_passen_nicht
  drop

  push {lr}

  @ Hier war mal die Wahl der einzufügenden Struktur
  pushda r0
  bl inlinekomma  

  @ ( #of --> Addr #of+1)

  bl branch_v @ here 2 allot
  swap
  adds tos, #1 @ Eine Adresse mehr, die abzuarbeiten ist

  pushdaconst 9 @ Strukturerkennung bereitlegen

  pop {lr}

dropkomma:
  pushdaconstw 0xcf40 @ Opcode für ldmia	r7!, {r6}
  b hkomma

/*
  popda r0
  cmp r0, tos
  bne.n .+4   @... Sprung falls ungleich
  drop

    1698:	4630      	mov	r0, r6
    169a:	cf40      	ldmia	r7!, {r6}
    169c:	42b0      	cmp	r0, r6
    169e:	d100      	bne.n	16a2 <strukturof+0xa>
    16a0:	cf40      	ldmia	r7!, {r6}

*/

struktur_of:
  popda r0
  cmp r0, tos
  bx lr

@------------------------------------------------------------------------------
  Wortbirne Flag_immediate_compileonly, "endof"
  @ ( ... addr-jne #of 9 -- ... addr-jmp #of 8 )
strukturendof:
@------------------------------------------------------------------------------
  cmp tos, #9
  bne strukturen_passen_nicht
  drop

  push {lr}
  to_r @ #of auf Returnstack

    bl branch_v @ here 2 allot
    swap @ ( here Addr-jne )
    bl v_casebranch @ Den aktuellen of-Block mit bne überspringen

  r_from @ #of zurückholen
  pushdaconst 8
  pop {pc}

@------------------------------------------------------------------------------
  Wortbirne Flag_immediate_compileonly, "endcase"
  @ ( ... addrs-jmp #of 8 -- )
strukturendcase:
@------------------------------------------------------------------------------
  cmp tos, #8
  bne strukturen_passen_nicht
  drop

  push {lr}
  bl dropkomma
  pop {lr}

spruenge_einpflegen:
  push {lr}
  @ Einpflegen der gesammelten Sprünge
  popda r0 @ Zahl der einzupflegenden Sprünge holen

1:cmp r0, #0 @ Sind noch Sprünge zu bearbeiten ?
  beq 2f
  

  push {r0}
  ands r1, tos, #1 @ Prüfe, ob es ein bedingter Sprung werden soll - ?do benötigt solche.
  cmp r1, #0
  beq 3f
     @ writeln "Bedingten Sprung einpflegen"
     bics tos, #1 @ Markierung für den bedingten Sprung entfernen
     bl v_nullbranch
     b 4f
  
3:@ writeln "Sprung einpflegen"
  bl v_branch @ Unbedingten Sprung einpflegen
4:
  pop {r0}

  subs r0, #1 @ Ein Sprung weniger übrig
  b 1b

2: pop {pc}
