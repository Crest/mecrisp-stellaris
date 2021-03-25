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

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_1, "0=" @ ( x -- ? )
@ -----------------------------------------------------------------------------
  cmp tos, #0       @ Is it zero?
  ite eq
  mvneq tos, tos    @ If zero, invert bits to become true.
  movne tos, #0     @ Otherwise, clear all bits.  
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_1, "0<>" @ ( x -- ? ) @ Meins
@ -----------------------------------------------------------------------------
  cmp tos, #0       @ Is it zero?
  ite ne
  movne tos, #-1     @  set all bits in TOS,
  moveq tos, #0      @  otherwise clear 'em all.
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_1, "0<" @ ( n -- ? )
@ -----------------------------------------------------------------------------
  cmp tos, #0        @ Compare to zero.
  ite mi             @ If negative,
  movmi tos, #-1     @ set all bits,
  movpl tos, #0      @ Otherwise, clear all bits.
  bx lr


@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2, ">=" @ ( x1 x2 -- ? ) @ Meins
@ -----------------------------------------------------------------------------
  ldm psp!, {w}            @ Get x1 into a register.
  cmp w, tos         @ Is x2 less?
  ite lt             @ If so,
  movlt tos, #0     @  set all bits in TOS,
  movge tos, #-1      @  otherwise clear 'em all.
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2, "<=" @ ( x1 x2 -- ? ) @ Meins          
@ -----------------------------------------------------------------------------
  ldm psp!, {w}            @ Get x1 into a register.
  cmp w, tos         @ Is x2 greater?
  ite gt             @ If so,
  movgt tos, #0     @  set all bits in TOS,
  movle tos, #-1      @  otherwise clear 'em all.
  bx lr



@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2, "<" @ ( x1 x2 -- ? )
                      @ Checks if x2 is less than x1.
@ -----------------------------------------------------------------------------
  ldm psp!, {w}            @ Get x1 into a register.
  cmp w, tos         @ Is x2 less?
  ite lt             @ If so,
  movlt tos, #-1     @  set all bits in TOS,
  movge tos, #0      @  otherwise clear 'em all.
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2, ">" @ ( x1 x2 -- ? )
                      @ Checks if x2 is greater than x1.
@ -----------------------------------------------------------------------------
  ldm psp!, {w}            @ Get x1 into a register.
  cmp w, tos         @ Is x2 greater?
  ite gt             @ If so,
  movgt tos, #-1     @  set all bits in TOS,
  movle tos, #0      @  otherwise clear 'em all.
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2, "u>=" @ ( u1 u2 -- ? ) @ Meins
@ -----------------------------------------------------------------------------
  ldm psp!, {w}            @ Get u1 into a register.
  cmp w, tos         @ Compare.
  ite lo             @ If u1 is less than u2,
  movlo tos, #0     @  set TOS to true,
  movhs tos, #-1      @  otherwise set it to zero.
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2, "u<=" @ ( u1 u2 -- ? ) @ Meins
@ -----------------------------------------------------------------------------
  ldm psp!, {w}      @ Get u1 into a register.
  cmp tos, w         @ Compare.
  ite lo             @ If u1 is greater than u2,
  movlo tos, #0     @  set TOS to true,
  movhs tos, #-1      @  otherwise set it to zero.
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2, "u<" @ ( u1 u2 -- ? )
@ -----------------------------------------------------------------------------
  ldm psp!, {w}      @ Get u1 into a register.
  cmp w, tos         @ Compare.
  ite lo             @ If u1 is less than u2,
  movlo tos, #-1     @  set TOS to true,
  movhs tos, #0      @  otherwise set it to zero.
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2, "u>" @ ( u1 u2 -- ? ) @ Meins
@ -----------------------------------------------------------------------------
  ldm psp!, {w}      @ Get u1 into a register.
  cmp tos, w         @ Compare.
  ite lo             @ If u1 is greater than u2,
  movlo tos, #-1     @  set TOS to true,
  movhs tos, #0      @  otherwise set it to zero.
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2, "<>" @ ( x1 x2 -- ? )
                       @ Compares the top two stack elements for inequality.
@ -----------------------------------------------------------------------------
  ldm psp!, {w}      @ Get the next elt into a register.
  subs tos, w        @ Z=equality; if equal, TOS=0
  it ne              @ If not equal,
  movne TOS, #-1    @  set all bits in TOS.
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2, "=" @ ( x1 x2 -- ? )
                      @ Compares the top two stack elements for equality.
@ -----------------------------------------------------------------------------
  ldm psp!, {w}     @ Get the next elt into a register.
  subs tos, w       @ Z=equality; if equal, TOS=0
  ite eq            @ If the operands were equal,
  mvneq tos, tos    @  invert all bits in TOS (false -> true),
  movne tos, #0     @  otherwise clear TOS.
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2, "min" @ ( x1 x2 -- x3 )
                        @ x3 is the lesser of x1 and x2.
@ -----------------------------------------------------------------------------
  ldm psp!, {w}       @ Get x1 into a register.
  cmp x, tos          @ Compare 'em.
  it lt               @ If X is less,
  movlt tos, x        @  replace TOS with it.
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2, "max" @ ( x1 x2 -- x3 )
                        @ x3 is the greater of x1 and x2.
@ -----------------------------------------------------------------------------
  ldm psp!, {w}       @ Get x1 into a register.
  cmp x, tos          @ Compare 'em.
  it gt               @ If X is greater,
  movgt tos, x        @  replace TOS with it.
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2, "umax" @ ( u1 u2 -- u1|u2 )
@ -----------------------------------------------------------------------------
  ldm psp!, {w}  @ Get u1 into a register.
  cmp w, tos 
  it hi          @ If W > TOS,
  movhi tos, w   @  replace TOS with W.
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2, "umin" @ ( u1 u2 -- u1|u2 )
@ -----------------------------------------------------------------------------
  ldm psp!, {w}  @ Get u1 into a register.
  cmp w, tos
  it lo          @ If W < TOS,
  movlo tos, w   @  replace TOS with W.
  bx lr
