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

@ Terminalroutinen
@ Terminal code and initialisations.
@ Porting: Rewrite this !

.include "../common/terminalhooks.s"

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "nop" @ ( -- ) @ Handler for unused hooks
nop_vektor:                    
@ ----------------------------------------------------------------------------- 
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "serial-emit"
serial_emit: @ ( c -- ) Emit one character
@ -----------------------------------------------------------------------------
  push {lr}
  bl pause
 
  push {r0, r1, r2, r3, r4, r5, r7}
 
  push {r6}
  
  movs r0, #1   @ File descriptor 1: STDOUT
  mov  r1, sp   @ Pointer to Message
  movs r2, #1   @ 1 Byte
  movs r7, #4   @ Syscall 4: Write
  swi #0
  
  pop {r6}
 
  pop {r0, r1, r2, r3, r4, r5, r7}
  
  drop
  pop {pc}

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "serial-emit?"
serial_qemit:  @ ( -- ? ) Ready to send a character ?
@ -----------------------------------------------------------------------------
   push {lr}
   bl pause
   pushdatos
   movs tos, #0
   rsbs tos, tos, #0
   pop {pc}
   
@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "serial-key?"
serial_qkey:  @ ( -- ? ) Is there a key press ?
@ -----------------------------------------------------------------------------
   push {lr}
   bl pause
   pushdatos
   movs tos, #0
   rsbs tos, tos, #0
   pop {pc}

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "serial-key"
serial_key: @ ( -- c ) Receive one character
@ -----------------------------------------------------------------------------
  push {lr}
  bl pause
  pushdaconst 0
  
  push {r0, r1, r2, r3, r4, r5, r7}
 
  push {r6}
  
  movs r0, #0   @ File descriptor 0: STDIN
  mov  r1, sp   @ Pointer to Message
  movs r2, #1   @ 1 Byte
  movs r7, #3   @ Syscall 3: Read
  swi #0
  
  cmp r0, #0 @ A size of zero bytes or less denotes EOF.
  ble.n bye

  pop {r6}
  
  pop {r0, r1, r2, r3, r4, r5, r7}
  
  cmp tos, #4 @ Ctrl-D
  beq.n bye
  
  pop {pc}

@ -----------------------------------------------------------------------------
 Wortbirne Flag_visible, "syscall" @ ( r0 r1 r2 r3 r4 r5 r6 Syscall# -- r0 )
@ -----------------------------------------------------------------------------
 push {lr}
 push {r4, r5, r7} @ Save registers !

 push {r6} @ Syscall number

 ldm psp!, {r6}
 ldm psp!, {r5}
 ldm psp!, {r4}
 ldm psp!, {r3}
 ldm psp!, {r2}
 ldm psp!, {r1}
 ldm psp!, {r0}

 pop {r7} @ into r7

 swi #0

 pop {r4, r5, r7}

 adds r7, #28 @ Drop 7 elements at once
 movs r6, r0 @ Syscall reply into TOS
 
 pop {pc}

@ -----------------------------------------------------------------------------
 Wortbirne Flag_visible, "syscall?" @ ( r0 r1 r2 r3 r4 r5 r6 Syscall# -- r0 error )
@ -----------------------------------------------------------------------------
 push {lr}
 push {r4, r5, r7} @ Save registers !

 push {r6} @ Syscall number

 ldm psp!, {r6}
 ldm psp!, {r5}
 ldm psp!, {r4}
 ldm psp!, {r3}
 ldm psp!, {r2}
 ldm psp!, {r1}
 ldm psp!, {r0}

 pop {r7} @ into r7

 swi #0


 sbcs r6, r6 @ error = -1 on success, 0 on failure
 adds r6, r6, #1 @ error = 0 on success, 1 on failure 

 pop {r4, r5, r7}

 adds r7, #28 @ Drop 7 elements at once
 pushda r0    @ push syscall return value
 
 pop {pc}
     
@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "cacheflush" @ ( -- )
cacheflush:
@ -----------------------------------------------------------------------------

.ifdef m0core
  @ ARMv6 hat keine Speicherbarrieren.  Das muss ??ber einen syscall realisiert werden
  push {r4-r7, lr}
  movs r0, #0      @ ARM_SYNC_ICACHE
  adr r1, 0f       @ Bereich: alles was zu Mecrisp Stellaris geh??rt
  movs r7, #165    @ Syscall 165: sysarch()
  swi #0           @ Systemaufruf: synchronisiere den icache
  pop {r4-r7, pc}

  .align
  @ Datenstruktur arm_sync_icache_args f??r den sysarch-Aufruf
0:.word incipit
  .word totalsize

.else
  @ auf ARMv7 und sp??ter nehmen wir einfach die Barrien-Befehle
  dmb
  dsb
  isb  
  bx lr
.endif

@ -----------------------------------------------------------------------------
  Wortbirne Flag_foldable_0, "arguments" @ ( -- a-addr )
@ -----------------------------------------------------------------------------
  pushdatos
  ldr tos, =arguments
  ldr tos, [tos]
  bx lr
  
@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "reset"
@ -----------------------------------------------------------------------------
  bl Reset
 
@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "bye"
bye:
@ -----------------------------------------------------------------------------
  movs r0, #0  @ Error code 0
  movs r7, #1  @ Syscall 1: Exit
  swi #0
   
@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "incipit"
@ -----------------------------------------------------------------------------
  pushdatos
  ldr tos, =incipit
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "explicit"
@ -----------------------------------------------------------------------------
  pushdatos
  ldr tos, =explicit
  bx lr



  .ltorg @ Hier werden viele spezielle Hardwarestellenkonstanten gebraucht, schreibe sie gleich !
         @ Write the many special hardware locations now !
