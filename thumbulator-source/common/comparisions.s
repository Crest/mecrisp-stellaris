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

@ Vergleichsoperatoren
@ Comparision operators

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_1|Flag_inline|Flag_allocator, "0=" @ ( x -- ? )
@ -----------------------------------------------------------------------------
@        subs TOS, TOS, #1       ; if zero, carry is set, else carry is clear
@        sbc TOS, TOS, TOS       ; subtracting r0 from itself leaves zero if
@                                ; carry was clear or -1 if carry was set.
  subs tos, #1
  sbcs tos, tos
  bx lr

allocator_equal_zero:
    push {lr}
      bl allocator_one_minus
      pushdaconstw 0x4180 @ sbcs r0, r0, #0
      bl smalltworegisters
    pop {pc}

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_1|Flag_inline|Flag_allocator, "0<>" @ ( x -- ? ) @ Meins
@ -----------------------------------------------------------------------------
  subs tos, #1
  sbcs tos, tos
  mvns tos, tos
  bx lr

allocator_unequal_zero:
    push {lr}
      bl allocator_equal_zero
      bl allocator_not
    pop {pc}

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_1|Flag_inline|Flag_allocator, "0<" @ ( n -- ? )
@ -----------------------------------------------------------------------------
  movs TOS, TOS, asr #31    @ Turn MSB into 0xffffffff or 0x00000000
  bx lr

    push {lr}
      pushdaconstw 0x17C0 @ asrs r0, r0, #31
      bl smalltworegisters
    pop {pc}

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2|Flag_allocator, ">=" @ ( x1 x2 -- ? ) @ Meins
@ -----------------------------------------------------------------------------
  .ifdef m0core
  ldm psp!, {r0}      @ Get x1 into a register.
  cmp r0, tos         @ Is x2 less?
  bge 1f
  movs tos, #0
  b 2f
1:movs tos, #0
  mvns tos, tos
2:bx lr

  .else
  ldm psp!, {r0}     @ Get x1 into a register.
  cmp r0, tos        @ Is x2 less?
  ite lt             @ If so,
  movlt tos, #0      @  set all bits in TOS,
  movge tos, #-1     @  otherwise clear 'em all.
  bx lr
  .endif

    pushdaconstw 0xDB02 @ bls signed less             drei Befehle weiter
    pushdaconstw 0xDA02 @ bge signed greater or equal drei Befehle weiter

    push {lr}
    bl allocator_compare
    bl flaggenerator_inverted
    pop {pc}

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2|Flag_allocator, "<=" @ ( x1 x2 -- ? ) @ Meins
@ -----------------------------------------------------------------------------
  .ifdef m0core
  ldm psp!, {r0}     @ Get x1 into a register.
  cmp r0, tos        @ Is x2 greater?
  ble 1f
  movs tos, #0
  b 2f
1:movs tos, #0
  mvns tos, tos
2:bx lr

  .else
  ldm psp!, {r0}     @ Get x1 into a register.
  cmp r0, tos        @ Is x2 greater?
  ite gt             @ If so,
  movgt tos, #0      @  set all bits in TOS,
  movle tos, #-1     @  otherwise clear 'em all.
  bx lr
  .endif

    pushdaconstw 0xDC02 @ bgt signed greater       drei Befehle weiter
    pushdaconstw 0xDD02 @ bls signed less or equal drei Befehle weiter

    push {lr}
    bl allocator_compare
    bl flaggenerator_inverted
    pop {pc}

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2|Flag_allocator, "<" @ ( x1 x2 -- ? )
                      @ Checks if x2 is less than x1.
@ -----------------------------------------------------------------------------
  .ifdef m0core
  ldm psp!, {r0}     @ Get x1 into a register.
  cmp r0, tos        @ Is x2 less?
  bge 1f
  movs tos, #0
  mvns tos, tos
  b 2f
1:movs tos, #0
2:bx lr

  .else
  ldm psp!, {r0}     @ Get x1 into a register.
  cmp r0, tos        @ Is x2 less?
  ite lt             @ If so,
  movlt tos, #-1     @  set all bits in TOS,
  movge tos, #0      @  otherwise clear 'em all.
  bx lr
  .endif

    pushdaconstw 0xDB01 @ bls signed less             zwei Befehle weiter
    pushdaconstw 0xDA01 @ bge signed greater or equal zwei Befehle weiter

    push {lr}
    bl allocator_compare
    bl flaggenerator
    pop {pc}

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2|Flag_allocator, ">" @ ( x1 x2 -- ? )
                      @ Checks if x2 is greater than x1.
@ -----------------------------------------------------------------------------
  .ifdef m0core
  ldm psp!, {r0}     @ Get x1 into a register.
  cmp r0, tos        @ Is x2 greater?
  ble 1f
  movs tos, #0
  mvns tos, tos
  b 2f
1:movs tos, #0
2:bx lr

  .else
  ldm psp!, {r0}     @ Get x1 into a register.
  cmp r0, tos        @ Is x2 greater?
  ite gt             @ If so,
  movgt tos, #-1     @  set all bits in TOS,
  movle tos, #0      @  otherwise clear 'em all.
  bx lr
  .endif

    pushdaconstw 0xDC01 @ bgt signed greater       zwei Befehle weiter
    pushdaconstw 0xDD01 @ bls signed less or equal zwei Befehle weiter

    push {lr}
    bl allocator_compare
    bl flaggenerator
    pop {pc}

@ -----------------------------------------------------------------------------
  Wortbirne Flag_inline|Flag_foldable_2|Flag_allocator, "u>=" @ ( u1 u2 -- ? ) @ Meins
@ -----------------------------------------------------------------------------
  ldm psp!, {r0}      @ Get u1 into a register.
  subs tos, r0, tos   @ subs tos, w, tos   @ TOS = a-b  -- carry set if a is less than b
  sbcs tos, tos
  mvns tos, tos
  bx lr

    pushdaconstw 0xD302 @ blo unsigned lower          drei Befehle weiter
    pushdaconstw 0xD202 @ bhs unsigned higher or same drei Befehle weiter

    push {lr}
    bl allocator_compare
    bl flaggenerator_inverted
    pop {pc}

@ -----------------------------------------------------------------------------
  Wortbirne Flag_inline|Flag_foldable_2|Flag_allocator, "u<=" @ ( u1 u2 -- ? ) @ Meins
@ -----------------------------------------------------------------------------
  ldm psp!, {r0}
  subs tos, r0
  sbcs tos, tos
  mvns tos, tos
  bx lr

    pushdaconstw 0xD802 @ bhi unsigned higher        drei Befehle weiter
    pushdaconstw 0xD902 @ bls unsigned lower or same drei Befehle weiter

    push {lr}
    bl allocator_compare
    bl flaggenerator_inverted
    pop {pc}

@ -----------------------------------------------------------------------------
  Wortbirne Flag_inline|Flag_foldable_2|Flag_allocator, "u<" @ ( u1 u2 -- ? )
@ -----------------------------------------------------------------------------
  ldm psp!, {r0}      @ Get u1 into a register.
  subs tos, r0, tos   @ subs tos, w, tos   @ TOS = a-b  -- carry set if a is less than b
  sbcs tos, tos
  bx lr

    pushdaconstw 0xD301 @ blo unsigned lower          zwei Befehle weiter
    pushdaconstw 0xD201 @ bhs unsigned higher or same zwei Befehle weiter

    push {lr}
    bl allocator_compare
    bl flaggenerator
    pop {pc}

@ -----------------------------------------------------------------------------
  Wortbirne Flag_inline|Flag_foldable_2|Flag_allocator, "u>" @ ( u1 u2 -- ? ) @ Meins
@ -----------------------------------------------------------------------------
  ldm psp!, {r0}
  subs tos, r0
  sbcs tos, tos
  bx lr

    pushdaconstw 0xD801 @ bhi unsigned higher        zwei Befehle weiter
    pushdaconstw 0xD901 @ bls unsigned lower or same zwei Befehle weiter

    push {lr}
    bl allocator_compare
    bl flaggenerator
    pop {pc}

@ -----------------------------------------------------------------------------
  Wortbirne Flag_inline|Flag_foldable_2|Flag_allocator, "<>" @ ( x1 x2 -- ? )
                       @ Compares the top two stack elements for inequality.
@ -----------------------------------------------------------------------------
  ldm psp!, {r0}      @ Get the next elt into a register.
  subs tos, r0        @ Z=equality; if equal, TOS=0

  .ifdef m0core
  beq 1f
  movs tos, #0
  mvns tos, tos
1:bx lr
  .else
  it ne             @ If not equal,
  movne tos, #-1    @  set all bits in TOS.
  bx lr
  .endif

    pushdaconstw 0xD101 @ bne zwei Befehle weiter
    dup
    push {lr}
    bl allocator_compare
    bl flaggenerator
    pop {pc}

@ -----------------------------------------------------------------------------
  Wortbirne Flag_inline|Flag_foldable_2|Flag_allocator, "=" @ ( x1 x2 -- ? )
                      @ Compares the top two stack elements for equality.
@ -----------------------------------------------------------------------------
  ldm psp!, {r0}     @ Get the next elt into a register.
  subs tos, r0       @ Z=equality; if equal, TOS=0

  subs tos, #1       @ Wenn es Null war, gibt es jetzt einen Überlauf
  sbcs tos, tos
  bx lr

    pushdaconstw 0xD001 @ beq zwei Befehle weiter
    dup
    push {lr}
    bl allocator_compare
    bl flaggenerator
    pop {pc}


allocator_compare:
    push {lr} @ So ähnlich wie die Optimierungen in Plus und Minus
    bl expect_two_elements @ Zwei Elemente, die NICHT verändert werden. Mindestens eins davon ist ein Register, sonst würde gefaltet werden.

    @ Ist in TOS oder in NOS eine kleine Konstante ?
    ldr r2, [r0, #offset_state_nos]
    cmp r2, #constant
    bne 1f
      bl swap_allocator @ Wenn NOS eine Konstante gewesen ist, war TOS es nicht (Vorherige Faltung !) und ich kann einfach umtauschen.
      nip @ Vergesse den unteren Sprungopcode
      b 2f
1:  @ Nicht umgetauscht:
    drop @ Vergesse den oberen Sprungopcode
2:  @ Wenn eine Konstante da ist, ist sie jetzt in TOS.

    @ Ist jetzt TOS eine kleine Konstante ?

    ldr r1, [r0, #offset_state_tos]
    cmp r1, #constant
    bne 3f
      ldr r1, [r0, #offset_constant_tos]
      cmp r1, #0xff
      bhi 3f
        @ TOS ist eine kleine Konstante.
        pushdaconstw 0x2800 @ cmp r0, #imm8
        orrs tos, r1
        ldr r1, [r0, offset_state_nos] @ NOS dann der Faltung wegen unbedingt ein Register.
        lsls r1, #8
        b.n 4f


3:  @ Schritt eins: Die Konstante, falls TOS jetzt eine sein sollten, laden.
    @ NOS kann durch den Swap keine Konstante sein.
    bl expect_tos_in_register

    @ Beide Argumente sind jetzt in Registern.
    pushdaconstw 0x4280 @ cmp r0, r0
    @ Baue Quell- und "Ziel-" Register in den Opcode ein.

    lsls r2, #3  @ Zweiter Operand ist um 3 Stellen geschoben

    @ Baue jetzt den Opcode zusammen:

    orrs tos, r2
4:  orrs tos, r1

    bl hkomma

    @ Vergiss die bisherige Registerzuordnung

    bl eliminiere_tos
    bl eliminiere_tos

    @ Kümmere mich um das Ergebnis !

    bl befreie_tos
    bl get_free_register
    str r3, [r0, #offset_state_tos]

    @ In diesen neuen Register muss ich nun abhängig von den Flags einen Wert generieren.

    @ Bedingten Sprung schreiben, um Flag zu generieren
    bl hkomma
    pop {pc}


flaggenerator:
  push {lr}
    pushdaconstw 0x2000 @ movs r0, #0
    bl smallplusminus

    pushdaconstw 0xE001 @ b zwei Befehle weiter
    bl hkomma

    pushdaconstw 0x2000 @ movs r0, #0
    bl smallplusminus
    bl allocator_not @ Generates: mvns r0, r0
  pop {pc}

flaggenerator_inverted:
  push {lr}
    pushdaconstw 0x2000 @ movs r0, #0
    bl smallplusminus
    bl allocator_not @ Generates: mvns r0, r0

    pushdaconstw 0xE000 @ b ein Befehl weiter
    bl hkomma
    pushdaconstw 0x2000 @ movs r0, #0
    bl smallplusminus
  pop {pc}


@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2|Flag_inline, "min" @ ( x1 x2 -- x3 )
                        @ x3 is the lesser of x1 and x2.
@ -----------------------------------------------------------------------------
  .ifdef m0core
  ldm psp!, {r0}       @ Get x1 into a register.
  cmp r0, tos          @ Compare 'em.
  bge 1f
  movs tos, r0
1:bx lr

  .else
  ldm psp!, {r0}       @ Get x1 into a register.
  cmp r0, tos          @ Compare 'em.
  it lt                @ If X is less,
  movlt tos, r0        @  replace TOS with it.
  bx lr
  .endif

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2|Flag_inline, "max" @ ( x1 x2 -- x3 )
                        @ x3 is the greater of x1 and x2.
@ -----------------------------------------------------------------------------
  .ifdef m0core
  ldm psp!, {r0}       @ Get x1 into a register.
  cmp r0, tos          @ Compare 'em.
  blt 1f
  movs tos, r0
1:bx lr

  .else
  ldm psp!, {r0}       @ Get x1 into a register.
  cmp r0, tos          @ Compare 'em.
  it gt                @ If X is greater,
  movgt tos, r0        @  replace TOS with it.
  bx lr
  .endif

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2|Flag_inline, "umax" @ ( u1 u2 -- u1|u2 )
@ -----------------------------------------------------------------------------
  .ifdef m0core
  ldm psp!, {r0}  @ Get u1 into a register.
  cmp r0, tos
  blo 1f
  movs tos, r0
1:bx lr

  .else
  ldm psp!, {r0}  @ Get u1 into a register.
  cmp r0, tos
  it hi           @ If W > TOS,
  movhi tos, r0   @  replace TOS with W.
  bx lr
  .endif

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2|Flag_inline, "umin" @ ( u1 u2 -- u1|u2 )
@ -----------------------------------------------------------------------------
  .ifdef m0core
  ldm psp!, {r0}  @ Get u1 into a register.
  cmp r0, tos
  bhi 1f
  movs tos, r0
1:bx lr

  .else
  ldm psp!, {r0}  @ Get u1 into a register.
  cmp r0, tos
  it lo           @ If W < TOS,
  movlo tos, r0   @  replace TOS with W.
  bx lr
  .endif
