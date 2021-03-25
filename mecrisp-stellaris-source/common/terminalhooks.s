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

@ Terminal redirection hooks.

@------------------------------------------------------------------------------
  Wortbirne Flag_visible|Flag_variable, "hook-emit" @ ( -- addr )
  CoreVariable hook_emit
@------------------------------------------------------------------------------  
  pushdatos
  ldr tos, =hook_emit
  bx lr
  .word serial_emit  @ Serial communication for default

@------------------------------------------------------------------------------
  Wortbirne Flag_visible|Flag_variable, "hook-key" @ ( -- addr )
  CoreVariable hook_key
@------------------------------------------------------------------------------  
  pushdatos
  ldr tos, =hook_key
  bx lr
  .word serial_key  @ Serial communication for default

@------------------------------------------------------------------------------
  Wortbirne Flag_visible|Flag_variable, "hook-?emit" @ ( -- addr )
  CoreVariable hook_qemit
@------------------------------------------------------------------------------  
  pushdatos
  ldr tos, =hook_qemit
  bx lr
  .word serial_qemit  @ Serial communication for default

@------------------------------------------------------------------------------
  Wortbirne Flag_visible|Flag_variable, "hook-?key" @ ( -- addr )
  CoreVariable hook_qkey
@------------------------------------------------------------------------------  
  pushdatos
  ldr tos, =hook_qkey
  bx lr
  .word serial_qkey  @ Serial communication for default

@------------------------------------------------------------------------------
  Wortbirne Flag_visible|Flag_variable, "hook-pause" @ ( -- addr )
  CoreVariable hook_pause
@------------------------------------------------------------------------------  
  pushdatos
  ldr tos, =hook_pause
  bx lr
  .word nop_vektor  @ No Pause defined for default

@------------------------------------------------------------------------------
  Wortbirne Flag_visible, "emit" @ ( c -- )
emit:
@------------------------------------------------------------------------------  
  push {r0, r1, r2, r3, lr} @ Used in core, registers have to be saved !
  ldr r0, =hook_emit
  bl hook_intern
  pop {r0, r1, r2, r3, pc}

@------------------------------------------------------------------------------
  Wortbirne Flag_visible, "key" @ ( -- c )
key:
@------------------------------------------------------------------------------  
  push {r0, r1, r2, r3, lr} @ Used in core, registers have to be saved !
  ldr r0, =hook_key
  bl hook_intern
  pop {r0, r1, r2, r3, pc}

@------------------------------------------------------------------------------
  Wortbirne Flag_visible, "?emit" @ ( -- ? )
@------------------------------------------------------------------------------  
  push {lr} @ Not used in core, no need to save registers
  ldr r0, =hook_qemit
  bl hook_intern
  pop {pc}

@------------------------------------------------------------------------------
  Wortbirne Flag_visible, "?key" @ ( -- ? )
@------------------------------------------------------------------------------  
  push {lr} @ Not used in core, no need to save registers
  ldr r0, =hook_qkey
  bl hook_intern
  pop {pc}

@------------------------------------------------------------------------------
  Wortbirne Flag_visible, "pause" @ ( -- ? )
pause:
@------------------------------------------------------------------------------  
  push {lr} @ Not directly used in core, no need to save registers
  ldr r0, =hook_pause
  bl hook_intern
  pop {pc}

@------------------------------------------------------------------------------
hook_intern:
  ldr r0, [r0]
  mov pc, r0