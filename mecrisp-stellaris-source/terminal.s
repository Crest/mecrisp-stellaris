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

/*
@ -----------------------------------------------------------------------------
gpio_init: @ ( -- )
@ -----------------------------------------------------------------------------
        push    {r3}
        ldr     r0, .L8
        ldr r0, [r0] @ Register lesen
        orr     r1, r0, #32
        ldr     r0, .L8
        str r1, [r0] @ Register schreiben
.L2:
        ldr     r0, .L8+4
        ldr r0, [r0] @ Register lesen
        lsls    r3, r0, #26
        bpl     .L2
        ldr     r0, .L8+8
        ldr r0, [r0] @ Register lesen
        orr     r1, r0, #14
        ldr     r0, .L8+8
        str r1, [r0] @ Register schreiben
        ldr     r0, .L8+12
        ldr r0, [r0] @ Register lesen
        bic     r1, r0, #14
        ldr     r0, .L8+12
        str r1, [r0] @ Register schreiben
        ldr     r0, .L8+16
        ldr r0, [r0] @ Register lesen
        bic     r1, r0, #14
        ldr     r0, .L8+16
        str r1, [r0] @ Register schreiben
        ldr     r0, .L8+20
        ldr r0, [r0] @ Register lesen
        orr     r1, r0, #14
        ldr     r0, .L8+20
        str r1, [r0] @ Register schreiben
        pop     {r3}
        bx lr

        @ .align        2
.L8:
        .word   0x400FE608 @ 1074783752
        .word   0x400FEA08 @ 1074784776
        .word   0x40025400 @ 1073894400
        .word   0x40025420 @ 1073894432
        .word   0x4002550C @ 1073894668
        .word   0x4002551C @ 1073894684

*/

@ -----------------------------------------------------------------------------
uart_init: @ ( -- )
@ -----------------------------------------------------------------------------
        push    {r4}
        ldr     r4, .L11
        mov     r0, r4
        ldr r0, [r0] @ Register lesen
        orr     r1, r0, #1
        mov     r0, r4
        subs    r4, r4, #16
        str r1, [r0] @ Register schreiben
        mov     r0, r4
        ldr r0, [r0] @ Register lesen
        orr     r1, r0, #1
        mov     r0, r4
        ldr     r4, .L11+4
        str r1, [r0] @ Register schreiben
        mov     r0, r4
        ldr r0, [r0] @ Register lesen
        orr     r1, r0, #3
        mov     r0, r4
        adds    r4, r4, #252
        str r1, [r0] @ Register schreiben
        mov     r0, r4
        ldr r0, [r0] @ Register lesen
        orr     r1, r0, #3
        mov     r0, r4
        ldr     r4, .L11+8
        str r1, [r0] @ Register schreiben
        mov     r0, r4
        movs    r1, #0
        str r1, [r0] @ Register schreiben
        movs    r1, #8
        ldr     r0, .L11+12
        str r1, [r0] @ Register schreiben
        movs    r1, #44
        ldr     r0, .L11+16
        str r1, [r0] @ Register schreiben
        movs    r1, #96
        ldr     r0, .L11+20
        str r1, [r0] @ Register schreiben
        movs    r1, #5
        ldr     r0, .L11+24
        str r1, [r0] @ Register schreiben
        movs    r1, #0
        ldr     r0, .L11+28
        str r1, [r0] @ Register schreiben
        mov     r0, r4
        movw    r1, #769
        str r1, [r0] @ Register schreiben
        pop     {r4}
        bx lr

        @ .align        2
.L11:
        .word   0x400FE618 @ 1074783768
        .word   0x40004420 @ 1073759264
        .word   0x4000C030 @ 1073791024
        .word   0x4000C024 @ 1073791012
        .word   0x4000C028 @ 1073791016
        .word   0x4000C02C @ 1073791020
        .word   0x4000CFC8 @ 1073795016
        .word   0x4000C018 @ 1073791000

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "emit"
emit: @ ( c -- ) Sendet Wert in r0
@ -----------------------------------------------------------------------------
        push    {r0, r1, r2}
1:      @ Warte bis UART frei ist
        literal r1, 0x4000C018
        ldr r1, [r1] @ Register lesen
        lsls    r2, r1, #24
        bpl     1b

        literal r1, 0x4000C000
        popda r0
        str r0, [r1] @ Register schreiben
        pop     {r0, r1, r2}
        bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "key"
key: @ ( -- c ) Empfängt Wert in r0
@ -----------------------------------------------------------------------------
        push    {r0, r1}
1:      @ Ist schon etwas da ?
        literal r0, 0x4000C018
        ldr r0, [r0] @ Register lesen
        lsls    r1, r0, #25
        bpl     1b

        @ Einkommendes Zeichen abholen
        literal r0, 0x4000C000
        ldr r0, [r0] @ Register lesen
        uxtb    r0, r0 @ 8 Bits nehmen, Rest mit Nullen auffüllen.
        pushda r0
        pop     {r0, r1}
        bx lr


@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "?key"
  @ ( -- ? ) Ist eine Taste gedrückt ?
@ -----------------------------------------------------------------------------
        @ Ist schon etwas da ?
        literal r0, 0x4000C018
        ldr r0, [r0] @ Register lesen
        lsls    r1, r0, #25
        bpl     1f

  pushda -1
  bx lr

1: @ Noch nichts da
  pushda 0
  bx lr

/*
@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "echo"
echo: @ ( -- ) Sendet alle einkommenden Zeichen zurück und leuchtet bunt.
@ -----------------------------------------------------------------------------
1:      @ Hauptschleife
        bl      key @ Zeichen holen
        popda r0
        mov     r4, r0    @ und noch eine Kopie sichern
        pushda r0
        bl      emit

        ands    r1, r4, #1  @ Bit 1 gesetzt ? --> Rot
        it      ne
        movne   r1, #2
        literal r0, 0x40025008
        str r1, [r0] @ Register schreiben

        ands    r1, r4, #2 @ Bit 2 gesetzt ? --> Blau
        it      ne
        movne   r1, #4
        literal r0, 0x40025010
        str r1, [r0] @ Register schreiben

        ands    r1, r4, #4 @ Bit 3 gesetzt ? --> Grün
        literal r0, 0x40025020
        it      ne
        movne   r1, #8
        str r1, [r0] @ Register schreiben

        b       1b @ Hauptschleife
 
*/
