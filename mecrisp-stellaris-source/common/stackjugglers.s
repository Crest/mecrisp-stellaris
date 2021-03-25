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

@ Stackjongleure

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "depth" @ ( -- Zahl der Elemente, die vorher auf den Datenstack waren )
@ -----------------------------------------------------------------------------
  @ Berechne den Stackfüllstand
  ldr r1, =datenstackanfang @ Anfang laden
  subs r1, psp @ und aktuellen Stackpointer abziehen
  lsr r1, r1, #2 @ Durch 4 teilen
  pushda r1
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_1|Flag_inline, "dup" @ ( x -- x x )
@ -----------------------------------------------------------------------------
  dup
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_1|Flag_inline, "drop" @ ( x -- )
@ -----------------------------------------------------------------------------
  drop
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_1|Flag_inline, "?dup" @ ( x -- 0 | x x )
@ -----------------------------------------------------------------------------
  cmp tos, #0
  it ne
  stmdbne psp!, {tos}
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2|Flag_inline, "swap" @ ( x y -- y x )
@ -----------------------------------------------------------------------------
  ldr x, [psp]   @ Load X from the stack, no SP change.
  str tos, [psp] @ Replace it with TOS.
  mov tos, x     @ And vice versa.
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2|Flag_inline, "nip" @ ( x y -- x )
@ -----------------------------------------------------------------------------
  adds psp, #4    @ Move SP to eliminate next element.
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2|Flag_inline, "over" @ ( x y -- x y x )
@ -----------------------------------------------------------------------------
  ldr x, [psp]        @ Get X into a register.
  stmdb psp!, {tos}   @ Flush cached TOS
  mov tos, x          @ Copy X into TOS.
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_2|Flag_inline, "tuck" @ ( x1 x2 -- x2 x1 x2 )
@ -----------------------------------------------------------------------------
  ldm psp!, {w}     @ x1 in Register holen
  stmdb psp!, {tos} @ x2 nochmal in den Stack
  stmdb psp!, {w}   @ x1 wieder obenauf legen
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_3, "rot" @ ( x w y -- w y x )
@ -----------------------------------------------------------------------------
  ldm psp!, {w, x}    @ Get W and X into registers
  stmdb psp!, {w}     @ These two instructions cannot be combined.
  stmdb psp!, {tos}   @ (Order will be wrong.)
  mov tos, x
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_3, "-rot" @ ( x w y -- y x w )
@ -----------------------------------------------------------------------------
  ldm psp!, {w, x}    @ Get W and X into registers
  stmdb psp!, {tos}   @ These two instructions cannot be combined.
  stmdb psp!, {x}     @ (Order will be wrong.)
  mov tos, w
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible|Flag_inline, "pick" @ ( xu .. x1 x0 u -- xu ... x1 x0 xu ) 
@ -----------------------------------------------------------------------------
  ldr tos, [psp, tos, lsl #2]  @ I love ARM. :-)
  bx lr

@ Returnstack

@------------------------------------------------------------------------------
  Wortbirne Flag_visible|Flag_inline, ">r" @ Legt das oberste Element des Datenstacks auf den Returnstack.
@------------------------------------------------------------------------------
  push {tos}
  ldm psp!, {tos}
  bx lr

@------------------------------------------------------------------------------
  Wortbirne Flag_visible|Flag_inline, "r>" @ Holt das zwischengespeicherte Element aus dem Returnstack zurück
@------------------------------------------------------------------------------
  stmdb psp!, {tos}
  pop {tos}
  bx lr

@------------------------------------------------------------------------------
  Wortbirne Flag_visible|Flag_inline, "r@" @ Kopiert das oberste Element des Returnstacks auf den Datenstack
@------------------------------------------------------------------------------
  stmdb psp!, {tos}
  ldr tos, [sp]
  bx lr
