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
@ Logic.

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_0|Flag_inline, "true" @ ( -- -1 )
@ -----------------------------------------------------------------------------
  .ifdef m0core
  pushdatos
  movs tos, #0
  mvns tos, tos
  .else
  pushdaconst -1
  .endif
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_0|Flag_inline, "false" @ ( x -- 0 )
@ -----------------------------------------------------------------------------
  .ifdef m0core
  pushdatos
  movs tos, #0
  .else
  pushdaconst 0
  .endif
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2|Flag_inline, "and" @ ( x1 x2 -- x1&x2 )
                        @ Combines the top two stack elements using bitwise AND.
@ -----------------------------------------------------------------------------
  ldm psp!, {w}
  ands tos, w
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2|Flag_inline, "bic" @ ( x1 x2 -- x1&~x2 )
@ -----------------------------------------------------------------------------
  .ifdef m0core
  ldm psp!, {w}
  bics w, tos
  movs tos, w
  bx lr
  .else
  ldm psp!, {w}
  bics tos, w, tos
  bx lr
  .endif

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2|Flag_inline, "or" @ ( x1 x2 -- x1|x2 )
                       @ Combines the top two stack elements using bitwise OR.
@ -----------------------------------------------------------------------------
  ldm psp!, {w}
  orrs tos, w
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2|Flag_inline, "xor" @ ( x1 x2 -- x1|x2 )
                        @ Combines the top two stack elements using bitwise exclusive-OR.
@ -----------------------------------------------------------------------------
  ldm psp!, {w}
  eors tos, w
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_1|Flag_inline, "not" @ ( x -- ~x )
@ -----------------------------------------------------------------------------
  mvns tos, tos
  bx lr


  .ifdef m0core
@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_1, "clz" @ ( x -- u )
                        @ Counts leading zeroes in x.
@ -----------------------------------------------------------------------------
  movs r0, tos @ Fetch contents
  beq 3f @ If TOS contains 0 we have 32 leading zeros.

  movs tos, #0 @ No zeros counted yet.

1:lsls r0, #1 @ Shift TOS one place
  beq 2f @ Stop if register is zero.
  bcs 2f @ Stop if an one has been shifted out.
  adds tos, #1
  b 1b

2:bx lr

3:movs tos, #32
  bx lr

  .else

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_1|Flag_inline, "clz" @ ( x -- u )
                        @ Counts leading zeroes in x.
@ -----------------------------------------------------------------------------
  clz tos, tos
  bx lr

  .endif

@ -----------------------------------------------------------------------------
  Wortbirne Flag_inline|Flag_foldable_1, "shr" @ ( x -- x' ) @ Um eine Stelle rechts schieben
@ -----------------------------------------------------------------------------
  lsrs tos, #1
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_inline|Flag_foldable_1, "shl" @ ( x -- x' ) @ Um eine Stelle links schieben
@ -----------------------------------------------------------------------------
  lsls tos, #1
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2|Flag_inline, "rshift" @ ( x n -- x' )
                           @ Shifts 'x' right by 'n' bits.
@ -----------------------------------------------------------------------------

  .ifdef m0core
  ldm psp!, {w}
  lsrs w, tos
  movs tos, w
  bx lr
  .else
  ldm psp!, {w}   @ Get x into a register.
  lsrs tos, w, tos @ Shift by n into TOS.
  bx lr
  .endif

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2|Flag_inline, "arshift" @ ( x n -- x' )
                            @ Shifts 'x' right by 'n' bits, shifting in x's MSB.
@ -----------------------------------------------------------------------------

  .ifdef m0core
  ldm psp!, {w}
  asrs w, tos
  movs tos, w
  bx lr
  .else
  ldm psp!, {w}   @ Get x into a register.
  asrs tos, w, tos @ Shift by n into TOS.
  bx lr
  .endif


@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2|Flag_inline, "lshift" @ ( x n -- x' )
                           @ Shifts 'x' left by 'n' bits.
@ -----------------------------------------------------------------------------

  .ifdef m0core
  ldm psp!, {w}
  lsls w, tos
  movs tos, w
  bx lr
  .else
  ldm psp!, {w}   @ Get x into a register.
  lsls tos, w, tos @ Shift by n into TOS.
  bx lr
  .endif