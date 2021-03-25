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
@ Case structure

@------------------------------------------------------------------------------
  Wortbirne Flag_immediate_compileonly, "case"
  @ ( -- 0 8 )
case:
@------------------------------------------------------------------------------
  pushdaconst 0 @ Zahl der Zweige    Current number of branches
  pushdaconst 8 @ Strukturerkennung  Structure pattern
  bx lr

@ Small test:
@ : wahl case 1 of ." Eins" endof 2 of ." Zwei" endof dup 3 = ?of ." Drei?" endof ." Andere" endcase ;

@------------------------------------------------------------------------------
  Wortbirne Flag_immediate_compileonly, "?of"
  @ ( ... #of 8 -- ... addr #of+1 9 )
  @ Nimmt einen Flag statt einer Konstanten entgegen.
  @ Kann so eigene Vergleiche aufbauen.
  @ Takes flag instead of constant to build your own comparisions.
@------------------------------------------------------------------------------
  ldr r0, =struktur_qof
  b.n of_inneneinsprung

struktur_qof: @ Will be inlined.
  subs tos, #1
  sbcs tos, tos
  drop
  @ bne... is generated here.
  bx lr

@------------------------------------------------------------------------------
  Wortbirne Flag_immediate_compileonly, "of"
  @ ( ... #of 8 -- ... addr #of+1 9 )
@------------------------------------------------------------------------------
  ldr r0, =struktur_of

of_inneneinsprung:
  cmp tos, #8                  @ Check for structure pattern: Give error message and quit if wrong.
  .ifdef m0core
  beq 1f
  b strukturen_passen_nicht
1:
  .else
  bne strukturen_passen_nicht
  .endif
  drop

  push {lr}

  pushda r0
  bl inlinekomma  @ Insert opcodes for structure

  @ ( #of --> Addr #of+1)

  bl branch_v @ here 2 allot
  swap
  adds tos, #1 @ Eine Adresse mehr, die abzuarbeiten ist  One more location a branch opcode has to be written in later.

  pushdaconst 9 @ Strukturerkennung bereitlegen  Structure pattern

  pushdaconstw 0xcf40 @ Opcode for ldmia r7!, {r6}
  bl hkomma

  pop {pc}

struktur_of:
  popda r0
  cmp r0, tos
  bx lr

/* Simply a small disassembly section to see opcodes.
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

@------------------------------------------------------------------------------
  Wortbirne Flag_immediate_compileonly, "endof"
  @ ( ... addr-jne #of 9 -- ... addr-jmp #of 8 )
strukturendof:
@------------------------------------------------------------------------------
  cmp tos, #9
  .ifdef m0core
  beq 1f
  b strukturen_passen_nicht
1:
  .else
  bne strukturen_passen_nicht
  .endif
  drop

  push {lr}
  to_r @ #of auf Returnstack  Move #of to Returnstack and out of the way

    bl branch_v @ here 2 allot
    swap @ ( here Addr-jne )
    bl v_casebranch @ Den aktuellen of-Block mit bne überspringen   Skip current of-block with a bne opcode

  r_from @ #of zurückholen fetch back of#
  pushdaconst 8
  pop {pc}

@------------------------------------------------------------------------------
  Wortbirne Flag_immediate_compileonly, "endcase"
  @ ( ... addrs-jmp #of 8 -- )
strukturendcase:
@------------------------------------------------------------------------------
  cmp tos, #8
  .ifdef m0core
  beq 1f
  b strukturen_passen_nicht
1:
  .else
  bne strukturen_passen_nicht
  .endif
  drop

  push {lr}
  pushdaconstw 0xcf40 @ Opcode for ldmia r7!, {r6}
  bl hkomma

  bl spruenge_einpflegen
  pop {pc}


@------------------------------------------------------------------------------
spruenge_einpflegen: @ Internal use only.
@------------------------------------------------------------------------------
  push {lr}
  @ Einpflegen der gesammelten Sprünge
  @ Fill in collected jumps.
  popda r0 @ Zahl der einzupflegenden Sprünge holen Fetch number of jumps that need to be generated

1:cmp r0, #0 @ Sind noch Sprünge zu bearbeiten ? Any jumps left ?
  beq 2f
  

  push {r0, r1}        @ Check if this shall be a conditional jump instead. Needed for ?do which reuses this code.
  
  .ifdef m0core
  movs r1, #1
  ands r1, tos
  .else
  ands r1, tos, #1 @ Prüfe, ob es ein bedingter Sprung werden soll - ?do benötigt solche.#
  .endif

  cmp r1, #0
  beq 3f
    subs tos, #1 @ Markierung für den bedingten Sprung entfernen  Remove temporary bit for this beeing a conditional jump
    bl v_nullbranch  @ Insert conditional jump
    b 4f
  
3:bl v_branch @ Unbedingten Sprung einpflegen  Insert unconditional jump

4:pop {r0, r1}

  subs r0, #1 @ Ein Sprung weniger übrig  One jump less to do.
  b 1b

2: pop {pc}
