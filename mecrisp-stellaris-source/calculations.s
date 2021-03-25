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

@ Kleine Rechenmeister

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2|Flag_inline, "+" @ ( x1 x2 -- x1+x2 )
                      @ Adds x1 and x2.
@ -----------------------------------------------------------------------------
  ldm psp!, {w}
  adds tos, w 
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2|Flag_inline, "-" @ ( x1 x2 -- x1-x2 )
                      @ Subtracts x2 from x1.
@ -----------------------------------------------------------------------------
  ldm psp!, {w}
  subs tos, w, tos
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_1|Flag_inline, "1-" @ ( u -- u-1 )
                      @ Subtracts one from the cell on top of the stack.
@ -----------------------------------------------------------------------------
  subs tos, #1
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_1|Flag_inline, "1+" @ ( u -- u+1 )
                       @ Adds one to the cell on top of the stack.
@ -----------------------------------------------------------------------------
  adds tos, #1
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_1|Flag_inline, "2-" @ ( u -- u-1 )
                      @ Subtracts two from the cell on top of the stack.
@ -----------------------------------------------------------------------------
  subs tos, #2
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_1|Flag_inline, "2+" @ ( u -- u+1 )
                       @ Adds two to the cell on top of the stack.
@ -----------------------------------------------------------------------------
  adds tos, #2
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_1|Flag_inline, "negate" @ ( n1 -- -n1 )
@ -----------------------------------------------------------------------------
  rsbs tos, tos, #0
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_1, "abs" @ ( n1 -- |n1| )
@ -----------------------------------------------------------------------------
  cmp tos, #0
  it mi
  rsbsmi tos, tos, #0
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2, "u/mod" @ ( u1 u2 -- rem quot )
u_divmod:                            @ ARM provides no remainder operation, so we fake it by un-dividing and subtracting.
@ -----------------------------------------------------------------------------
  ldm psp!, {w}        @ Get u1 into a register
  mov x, tos          @ Back up the divisor in X.
  udiv tos, w, tos   @ Divide: quotient in TOS.
  muls x, tos, x      @ Un-divide to compute remainder.
  subs w, x            @ Compute remainder.
  stmdb psp!, {w}
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2, "/mod" @ ( n1 n2 -- rem quot )
                                    @ ARM provides no remainder operation, so we fake it by un-dividing and subtracting.
@ -----------------------------------------------------------------------------
  ldm psp!, {w}       @ Get u1 into a register
  mov x, tos         @ Back up the divisor in X.
  sdiv tos, w, tos  @ Divide: quotient in TOS.
  muls x, tos, x     @ Un-divide to compute remainder.
  subs w, x           @ Compute remainder.
  stmdb psp!, {w}  
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2|Flag_inline, "/" @ ( n1 n2 -- n1/n2 )
@ -----------------------------------------------------------------------------
  ldm psp!, {w}       @ Get n1 into a register
  sdiv tos, w, tos    @ Divide !
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2|Flag_inline, "*" @ ( u1|n1 u2|n2 -- u3|n3 )
@ -----------------------------------------------------------------------------
  ldm psp!, {w}     @ Get u1|n1 into a register.
  muls tos, w, tos   @ Multiply!
  bx lr 

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_1|Flag_inline, "2*" @ ( n -- n*2 )
@ -----------------------------------------------------------------------------
  lsls tos, #1
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_1|Flag_inline, "2/" @ ( n -- n/2 )
@ -----------------------------------------------------------------------------
  asrs tos, #1
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_1|Flag_inline, "even" @ ( x -- x' )
@ -----------------------------------------------------------------------------
  ands r1, tos, #1
  adds tos, r1
  bx lr

/*
@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_1|Flag_inline, "even4" @ ( x -- x' )
@ -----------------------------------------------------------------------------
  ands r1, tos, #1 @ Gerade machen
  adds tos, r1
  ands r1, tos, #2 @ Auf vier gerade machen
  adds tos, r1
  bx lr
*/

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_0, "base" @ ( -- addr )
@ -----------------------------------------------------------------------------
  ldr r0, =base
  pushda r0
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "binary" @ ( -- )
@ -----------------------------------------------------------------------------
  ldr r0, =base
  movs r1, #2
  str r1, [r0]
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "decimal" @ ( -- )
@ -----------------------------------------------------------------------------
  ldr r0, =base
  movs r1, #10
  str r1, [r0]
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "hex" @ ( -- )
@ -----------------------------------------------------------------------------
  ldr r0, =base
  movs r1, #16
  str r1, [r0]
  bx lr
