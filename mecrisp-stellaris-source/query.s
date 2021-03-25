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

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "query"
query: @ ( -- ) Nimmt einen String in den Eingabepuffer auf
@ -----------------------------------------------------------------------------
        push    {r0, r1, r2, r3, r4, r5, lr}


        ldr r0, =Pufferstand @ Aktueller Offset in den Eingabepuffer
        mov r1, #0
        strb r1, [r0]


        @ Normal loslegen
        ldr     r1, =Eingabepuffer @ Pufferadresse holen
        mov     r2, #0            @ Momentaner Pufferfüllstand Null

1:      @ Queryschleife
        bl key              @ Tastendruck holen
        popda r0
        cmp     r0, #32           @ ASCII 0-31 sind Steuerzeichen, 32 ist Space. Die Steuerzeichen müssten einzeln behandelt werden.
        bhs     2f                @ Space wird hier einfach so mit aufgenommen.
        
        @ Steuerzeichen bearbeiten.
        cmp     r0, #10           @ Bei Enter sind wir fertig.
        beq     3f

        cmp     r0, #8            @ Backspace
        bne     1b                @ Alle anderen Steuerzeichen ignorieren

        cmp     r2, #0            @ Null Zeichen im Puffer ? Dann ist nichts zu löschen da.
        beq     1b

        @ Tatsächlich ein Zeichen löschen. Noch ohne Unicode-Unterstützung.
        sub r2, #1                @ Ein Zeichen weniger im Puffer
        mov r0, #8                @ .byte 3, 8, 32, 8  Cursor einen Schritt zurück. Mit Leerzeichen überschreiben. Nochmal zurück.
        pushda r0
        bl emit
        mov r0, #32
        pushda r0
        bl emit
        mov r0, #8
        pushda r0
        bl emit
        b 1b

2:      @ Normale Zeichen annehmen
        cmp     r2, #maximaleeingabe @ Ist der Puffer voll ?
        bhs     1b                   @ Keine weiteren Zeichen mehr annehmen.

        pushda r0
        bl emit                   @ Zeichen ausgeben
        add     r2, #1            @ Pufferfüllstand erhöhen
        mov     r3, r1            @ Pufferadresse kopieren
        add     r3, r2            @ Füllstand hinzuaddieren
        strb    r0, [r3]          @ Zeichen in Puffer speichern
        b       1b

3:      mov     r0, #32           @ Statt des Zeilenumbruches ein LEerzeichen ausgeben
        pushda r0
        bl emit

        strb    r2, [r1]          @ Pufferfüllstand schreiben
@       mov     r0, r1            @ Pufferadresse für type zurückgeben
@       pushda r0
        pop     {r0, r1, r2, r3, r4, r5, pc}
 
