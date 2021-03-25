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
  Wortbirne Flag_foldable_1|Flag_inline, "0=" @ ( x -- ? )
@ -----------------------------------------------------------------------------
@  cmp tos, #0       @ Is it zero?
@  ite eq
@  mvneq tos, tos    @ If zero, invert bits to become true.
@  movne tos, #0     @ Otherwise, clear all bits.  
@  bx lr

@        subs TOS, TOS, #1       ; if zero, carry is set, else carry is clear
@        sbc TOS, TOS, TOS       ; subtracting r0 from itself leaves zero if
@                                ; carry was clear or -1 if carry was set.
  subs tos, #1
  sbcs tos, tos
  bx lr


@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_1|Flag_inline, "0<>" @ ( x -- ? ) @ Meins
@ -----------------------------------------------------------------------------
@  cmp tos, #0       @ Is it zero?
@  ite ne
@  movne tos, #-1     @  set all bits in TOS,
@  moveq tos, #0      @  otherwise clear 'em all.
@  bx lr

  subs tos, #1
  sbcs tos, tos
  mvns tos, tos
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_1|Flag_inline, "0<" @ ( n -- ? )
@ -----------------------------------------------------------------------------
@  cmp tos, #0        @ Compare to zero.
@  ite mi             @ If negative,
@  movmi tos, #-1     @ set all bits,
@  movpl tos, #0      @ Otherwise, clear all bits.
@  bx lr

  movs TOS, TOS, asr #31    @ Turn MSB into 0xffffffff or 0x00000000
  bx lr


@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2, ">=" @ ( x1 x2 -- ? ) @ Meins
@ -----------------------------------------------------------------------------
  .ifdef m0core
  ldm psp!, {w}      @ Get x1 into a register.
  cmp w, tos         @ Is x2 less?
  bge 1f
  movs tos, #0
  bx lr
1:movs tos, #0
  mvns tos, tos
  bx lr

  .else
  ldm psp!, {w}      @ Get x1 into a register.
  cmp w, tos         @ Is x2 less?
  ite lt             @ If so,
  movlt tos, #0      @  set all bits in TOS,
  movge tos, #-1     @  otherwise clear 'em all.
  bx lr
  .endif

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2, "<=" @ ( x1 x2 -- ? ) @ Meins          
@ -----------------------------------------------------------------------------
  .ifdef m0core
  ldm psp!, {w}      @ Get x1 into a register.
  cmp w, tos         @ Is x2 greater?
  ble 1f  
  movs tos, #0
  bx lr
1:movs tos, #0
  mvns tos, tos
  bx lr

  .else
  ldm psp!, {w}      @ Get x1 into a register.
  cmp w, tos         @ Is x2 greater?
  ite gt             @ If so,
  movgt tos, #0      @  set all bits in TOS,
  movle tos, #-1     @  otherwise clear 'em all.
  bx lr
  .endif


@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2, "<" @ ( x1 x2 -- ? )
                      @ Checks if x2 is less than x1.
@ -----------------------------------------------------------------------------
  .ifdef m0core
  ldm psp!, {w}      @ Get x1 into a register.
  cmp w, tos         @ Is x2 less?
  bge 1f
  movs tos, #0
  mvns tos, tos
  bx lr
1:movs tos, #0
  bx lr


  .else
  ldm psp!, {w}      @ Get x1 into a register.
  cmp w, tos         @ Is x2 less?
  ite lt             @ If so,
  movlt tos, #-1     @  set all bits in TOS,
  movge tos, #0      @  otherwise clear 'em all.
  bx lr
  .endif

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2, ">" @ ( x1 x2 -- ? )
                      @ Checks if x2 is greater than x1.
@ -----------------------------------------------------------------------------
  .ifdef m0core
  ldm psp!, {w}      @ Get x1 into a register.
  cmp w, tos         @ Is x2 greater?
  ble 1f
  movs tos, #0
  mvns tos, tos
  bx lr
1:movs tos, #0
  bx lr

  .else
  ldm psp!, {w}      @ Get x1 into a register.
  cmp w, tos         @ Is x2 greater?
  ite gt             @ If so,
  movgt tos, #-1     @  set all bits in TOS,
  movle tos, #0      @  otherwise clear 'em all.
  bx lr
  .endif

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2, "u>=" @ ( u1 u2 -- ? ) @ Meins
@ -----------------------------------------------------------------------------
@  ldm psp!, {w}            @ Get u1 into a register.
@  cmp w, tos         @ Compare.
@  ite lo             @ If u1 is less than u2,
@  movlo tos, #0     @  set TOS to true,
@  movhs tos, #-1      @  otherwise set it to zero.
@  bx lr

  .ifdef m0core
  ldm psp!, {w}      @ Get u1 into a register.
  subs tos, w, tos   @ subs tos, w, tos   @ TOS = a-b  -- carry set if a is less than b
  sbcs tos, tos
  mvns tos, tos
  bx lr

  .else
  ldm psp!, {w}      @ Get u1 into a register.
  rsbs tos, w        @ subs tos, w, tos   @ TOS = a-b  -- carry set if a is less than b
  sbcs tos, tos
  mvns tos, tos
  bx lr
  .endif

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2, "u<=" @ ( u1 u2 -- ? ) @ Meins
@ -----------------------------------------------------------------------------
@  ldm psp!, {w}      @ Get u1 into a register.
@  cmp tos, w         @ Compare.
@  ite lo             @ If u1 is greater than u2,
@  movlo tos, #0     @  set TOS to true,
@  movhs tos, #-1      @  otherwise set it to zero.
@  bx lr

  ldm psp!, {w}
  subs tos, w
  sbcs tos, tos
  mvns tos, tos
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2|Flag_inline, "u<" @ ( u1 u2 -- ? )
@ -----------------------------------------------------------------------------
@  ldm psp!, {w}      @ Get u1 into a register.
@  cmp w, tos         @ Compare.
@  ite lo             @ If u1 is less than u2,
@  movlo tos, #-1     @  set TOS to true,
@  movhs tos, #0      @  otherwise set it to zero.
@  bx lr

@    ; U<  uses the Robert Berkey trick whereby subtracting sets the  
@    ;   carry and then subtracting the difference from itself leaves
@    ;   zero if carry was clear or -1 if carry was set.
@        dpop r1
@        subs TOS, r1, TOS      ; TOS = a-b  -- carry set if a is less than b
@        sbc TOS, TOS, TOS
@        nxt

  .ifdef m0core
  ldm psp!, {w}      @ Get u1 into a register.
  subs tos, w, tos   @ subs tos, w, tos   @ TOS = a-b  -- carry set if a is less than b
  sbcs tos, tos
  bx lr

  .else
  ldm psp!, {w}      @ Get u1 into a register.
  rsbs tos, w        @ subs tos, w, tos   @ TOS = a-b  -- carry set if a is less than b
  sbcs tos, tos
  bx lr
  .endif

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2|Flag_inline, "u>" @ ( u1 u2 -- ? ) @ Meins
@ -----------------------------------------------------------------------------
@  ldm psp!, {w}      @ Get u1 into a register.
@  cmp tos, w         @ Compare.
@  ite lo             @ If u1 is greater than u2,
@  movlo tos, #-1     @  set TOS to true,
@  movhs tos, #0      @  otherwise set it to zero.
@  bx lr

  ldm psp!, {w}
  subs tos, w
  sbcs tos, tos
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2|Flag_inline, "<>" @ ( x1 x2 -- ? )
                       @ Compares the top two stack elements for inequality.
@ -----------------------------------------------------------------------------
  .ifdef m0core
  ldm psp!, {w}      @ Get the next elt into a register.
  subs tos, w        @ Z=equality; if equal, TOS=0
  beq 1f
  movs tos, #0
  mvns tos, tos
1:bx lr

  .else
  ldm psp!, {w}      @ Get the next elt into a register.
  subs tos, w        @ Z=equality; if equal, TOS=0
  it ne              @ If not equal,
  movne tos, #-1    @  set all bits in TOS.
  bx lr
  .endif

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2|Flag_inline, "=" @ ( x1 x2 -- ? )
                      @ Compares the top two stack elements for equality.
@ -----------------------------------------------------------------------------
@  ldm psp!, {w}     @ Get the next elt into a register.
@  subs tos, w       @ Z=equality; if equal, TOS=0
@  ite eq            @ If the operands were equal,
@  mvneq tos, tos    @  invert all bits in TOS (false -> true),
@  movne tos, #0     @  otherwise clear TOS.
@  bx lr

  ldm psp!, {w}     @ Get the next elt into a register.
  subs tos, w       @ Z=equality; if equal, TOS=0
  subs tos, #1      @ Wenn es Null war, gibt es jetzt einen Überlauf
  sbcs tos, tos
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2, "min" @ ( x1 x2 -- x3 )
                        @ x3 is the lesser of x1 and x2.
@ -----------------------------------------------------------------------------
  .ifdef m0core
  ldm psp!, {w}       @ Get x1 into a register.
  cmp w, tos          @ Compare 'em.
  bge 1f
  movs tos, w
1:bx lr

  .else
  ldm psp!, {w}       @ Get x1 into a register.
  cmp w, tos          @ Compare 'em.
  it lt               @ If X is less,
  movlt tos, w        @  replace TOS with it.
  bx lr
  .endif

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2, "max" @ ( x1 x2 -- x3 )
                        @ x3 is the greater of x1 and x2.
@ -----------------------------------------------------------------------------
  .ifdef m0core
  ldm psp!, {w}       @ Get x1 into a register.
  cmp w, tos          @ Compare 'em.  
  blt 1f
  movs tos, w
1:bx lr

  .else
  ldm psp!, {w}       @ Get x1 into a register.
  cmp w, tos          @ Compare 'em.
  it gt               @ If X is greater,
  movgt tos, w        @  replace TOS with it.
  bx lr
  .endif

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2, "umax" @ ( u1 u2 -- u1|u2 )
@ -----------------------------------------------------------------------------
  .ifdef m0core
  ldm psp!, {w}  @ Get u1 into a register.
  cmp w, tos 
  blo 1f
  movs tos, w
1:bx lr

  .else
  ldm psp!, {w}  @ Get u1 into a register.
  cmp w, tos 
  it hi          @ If W > TOS,
  movhi tos, w   @  replace TOS with W.
  bx lr
  .endif

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2, "umin" @ ( u1 u2 -- u1|u2 )
@ -----------------------------------------------------------------------------
  .ifdef m0core
  ldm psp!, {w}  @ Get u1 into a register.
  cmp w, tos 
  bhi 1f
  movs tos, w
1:bx lr

  .else
  ldm psp!, {w}  @ Get u1 into a register.
  cmp w, tos
  it lo          @ If W < TOS,
  movlo tos, w   @  replace TOS with W.
  bx lr
  .endif