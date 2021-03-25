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

@ Logikfunktionen

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_0|Flag_inline, "true" @ ( -- -1 )
@ -----------------------------------------------------------------------------
  stmdb psp!, {tos}
  mov tos, #-1
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_0|Flag_inline, "false" @ ( x -- 0 )
@ -----------------------------------------------------------------------------
  stmdb psp!, {tos}
  mov tos, #0
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2|Flag_inline, "and" @ ( x1 x2 -- x1&x2 )
                        @ Combines the top two stack elements using bitwise AND.
@ -----------------------------------------------------------------------------
  ldm psp!, {w}
  and tos, w
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2|Flag_inline, "bic" @ ( x1 x2 -- x1&~x2 )
@ -----------------------------------------------------------------------------
  ldm psp!, {w}
  bic tos, w, tos
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2|Flag_inline, "or" @ ( x1 x2 -- x1|x2 )
                       @ Combines the top two stack elements using bitwise OR.
@ -----------------------------------------------------------------------------
  ldm psp!, {w}
  orr tos, w
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2|Flag_inline, "xor" @ ( x1 x2 -- x1|x2 )
                        @ Combines the top two stack elements using bitwise exclusive-OR.
@ -----------------------------------------------------------------------------
  ldm psp!, {w}
  eor tos, w
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_1|Flag_inline, "not" @ ( x -- ~x )
@ -----------------------------------------------------------------------------
  mvn tos, tos
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_1|Flag_inline, "clz" @ ( x -- u )
                        @ Counts leading zeroes in x.
@ -----------------------------------------------------------------------------
  clz tos, tos
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_inline|Flag_foldable_1, "shr" @ ( x -- x' ) @ Um eine Stelle rechts schieben
@ -----------------------------------------------------------------------------
  lsr tos, #1
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_inline|Flag_foldable_1, "shl" @ ( x -- x' ) @ Um eine Stelle links schieben
@ -----------------------------------------------------------------------------
  lsl tos, #1
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2|Flag_inline, "rshift" @ ( x n -- x' )
                           @ Shifts 'x' right by 'n' bits.
@ -----------------------------------------------------------------------------
  ldm psp!, {w}   @ Get x into a register.
  lsr tos, w, tos @ Shift by n into TOS.
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2|Flag_inline, "arshift" @ ( x n -- x' )
                            @ Shifts 'x' right by 'n' bits, shifting in x's MSB.
@ -----------------------------------------------------------------------------
  ldm psp!, {w}   @ Get x into a register.
  asr tos, w, tos @ Shift by n into TOS.
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2|Flag_inline, "lshift" @ ( x n -- x' )
                           @ Shifts 'x' left by 'n' bits.
@ -----------------------------------------------------------------------------
  ldm psp!, {w}   @ Get x into a register.
  lsl tos, w, tos @ Shift by n into TOS.
  bx lr
 
