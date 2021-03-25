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

@ Zahlenzauber enthält die Routinen für die Umwandlung von Zahlen in Strings und umgekehrt.
@ Die Zahlenbasis kann maximal bis 36 gehen, danach fehlt einfach der Zeichensatz.


@ -----------------------------------------------------------------------------
@ Zahleneingabe
@ -----------------------------------------------------------------------------

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "digit" @ ( Zeichen -- false / Ziffer true )
digit: @ Erwartet Base in r3
@ -----------------------------------------------------------------------------
  ldr r3, =base
  ldr r3, [r3]
  
digit_base_r3:

  push {r0}
  popda r0      @ Zeichen holen
  subs r0, #48  @ "0" abziehen.
  blo 5f        @ negativ --> Zeichen war "unter Null"

  cmp r0, #10   @ Im Bereich bis "9" ?
  blo 4f        @ Ziffer korrekt erkannt.

  @ Nein: Also ist die Ziffer nicht in den Zahlen 0-9 enthalten gewesen.
  @ Prüfe Buchstaben.

  subs r0, #7    @ Anfang der Großbuchstaben, "A"
  cmp r0, #10   @ Buchstabenwerte beginnen bei 10
  blo 5f        @ --> Zeichen war ein Sonderzeichen zwischen Ziffern und Großbuchstaben.

  cmp r0, #36   @ Es gibt 26 Buchstaben.
  blo 4f        @ In dem Bereich: Ziffer korrekt erkannt.

  @ Für den Fall, dass die Ziffer immer noch nicht erkannt ist, probiere es mit den Kleinbuchstaben.

  subs r0, #32   @ Schiebe zum Anfang der Kleinbuchstaben, "A"
  cmp r0, #10   @ Buchstabenwerte beginnen bei 10
  blo 5f        @ --> Zeichen war ein Sonderzeichen zwischen Großbuchstaben und Kleinbuchstaben.

  cmp r0, #36   @ Es gibt 26 Buchstaben.
  blo 4f        @ In dem Bereich: Ziffer korrekt erkannt.

  @ Immer noch nicht ? Dann ist das ein Sonderzeichen oberhalb der Kleinbuchstaben oder ein Unicode-Zeichen.
  @ Keine gültige Ziffer.

5: @ Aussprung mit Fehler 
  movs r0, #0    @ False-Flag
  pushda r0     @ bereitlegen
  pop {r0}
  bx lr

4: @ Korrekt erkannt. Ziffer in r0 

  @ ; Prüfe nun noch, ob die Ziffer innerhalb der Basis liegt !
  @ cmp &Base, r10
  @ jhs -          ; Außerhalb der Basis werden keine Buchstaben als Zahlen akzeptiert.

  cmp r0, r3 @ r3 enthält von number aus die Basis.
  bhs 5b

  pushda r0
  movs r0, #-1   @ True-Flag
  pushda r0     @ bereitlegen
  pop {r0}
  bx lr


@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "number" @ ( Addr -- n 1 | 0 ) Versucht den String in eine Zahl zu verwandeln.
number:
@ -----------------------------------------------------------------------------

/*
    ; Sind noch Zeichen da ? Sonst fertig.
    ; Hole ein Zeichen von vorne.
    ; Prüfe, ob Digit das mag.
    ; Wenn ja: Zahl := Zahl * Basis + neue Ziffer. Zeichen abtrennen.
    ; Wenn nein: Fertig.
    ; Wiederholen.
*/

  push {r0, r1, r2, r3, r4, r5, lr}

  popda r0 @ Hole die Stringadresse
  ldrb r1, [r0] @ Hole die Länge des Strings

  movs r2, #0  @ Am Anfang noch keine Resultate

  @mov r3, #10 @ Base
  ldr r3, =base
  ldr r3, [r3]
  
  movs r5, #1  @ Positiv oder Negativ ?

1: @ Sind noch Zeichen da ?
@  writeln "Schleife"
  cmp r1, #0
  beq 4f @ String ist leer, bin fertig !

@  writeln "Zeichen holen"
  @ Hole ein Zeichen:
  adds r0, #1 @ Pointer weiterrücken
  subs r1, #1 @ Länge um eins verringern
  ldrb r4, [r0] @ Zeichen holen.


@ Vorzeichen und Basisvorsilben:
  cmp r4, #45   @ Minus ?
  itt eq
  moveq r5, #-1
  beq 1b

  cmp r4, #35   @ # ?
  itt eq
  moveq r3, #10 @ Umschalten auf Dezimal
  beq 1b

  cmp r4, #36   @ $ ?
  itt eq
  moveq r3, #16 @ Umschalten auf Hexadezimal
  beq 1b

  cmp r4, #37   @ % ?
  itt eq
  moveq r3, #2  @ Umschalten auf Binär
  beq 1b


  @ Wandele das Zeichen
  pushda r4
@ bl dots

  bl digit_base_r3
@  writeln "Gewandelt"
@ bl dots
  popda r4 @ Flag.
  cmp r4, #0 @ Bei false mochte digit das Zeichen nicht.
  beq 5f     @ Aussprung mit Fehler.

@  writeln "Zeichen gemocht"
  @ Zeichen wurde gemocht.
  popda r4 @ Ziffer holen

  mla r2, r2, r3, r4 @ (Zahl * Basis) + Ziffer
@  mul r2, r2, r3
@  add r2, r4
  b 1b
  

4: @ String ist leer und wurde korrekt umgewandelt.

  @ Vorzeichen beachten:
  muls r2, r2, r5 @ Mit 1 oder -1 malnehmen.
  pushda r2   @ Zahl

  movs r2, #1 @ True, 1 Stackelement von der Zahl belegt
  pushda r2
  pop {r0, r1, r2, r3, r4, r5, pc} @ Rücksprung

5: @ Digit mochte das Zeichen nicht.
  movs r2, #0
  pushda r2
  pop {r0, r1, r2, r3, r4, r5, pc}


@ -----------------------------------------------------------------------------
@ Zahlenausgabe
@ -----------------------------------------------------------------------------


@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, ".digit" @ ( Ziffer -- Zeichen ) Wandelt eine Ziffer in ein Zeichen um.
               @ Wenn ein Zahlensystem größer 36 angestrebt wird,
               @ werden nicht druckbare Zeichen einfach mit # beschrieben.
digitausgeben:
@ -----------------------------------------------------------------------------
  popda r0      @ Ziffer holen
  cmp r0, #10   @ Von 0-9:
  itt lo
  addlo r0, #48 @ Schiebe zum Anfang der Zahlen
  blo 1f

  cmp r0, #36   @ Von A-Z:
  ite lo        @ Schiebe zum Anfang der Großbuchstaben - 10 = 55.
  addlo r0, #55 @ Alternative für Kleinbuchstaben: 87.
  movhs r0, #35 @ Zeichen #, falls diese Ziffer nicht darstellbar ist

1:pushda r0     @ Zeichen zurückschreiben
  bx lr


@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "hold" @ Fügt dem Zahlenstring von vorne ein Zeichen hinzu.
hold: @ ( Zeichen -- )
@------------------------------------------------------------------------------

  @ Alter String:  | Länge     |     |
  @ Neuer String:  | Länge + 1 | Neu |

  @ Alter String:  | Länge     | I   | II  | III |     |
  @ Neuer String:  | Länge + 1 | Neu | I   | II  | III |

  @ Mache mich an die Arbeit !

  popda r3 @ Das einzufügende Zeichen

  ldr r0, =Zahlenpuffer
  ldrb r1, [r0] @ Länge holen  

  cmp r1, #Zahlenpufferlaenge  @ Ist der Puffer voll ?
  bhs 3f                       @ Keine weiteren Zeichen mehr annehmen.  

  @ Länge des Puffers um 1 erhöhen
  adds r1, #1
  strb r1, [r0] @ Aktualisierte Länge schreiben

  @ Am Ende anfangen:
  adds r0, r1 @ Zeiger an die freie Stelle für das neue Zeichen

  @ Ist die Länge jetzt genau 1 Zeichen ? Dann muss ich nichs schieben.
  cmp r1, #1
  beq 2f

1:@ Schiebeschleife:
  subs r0, #1
  ldrb r2, [r0] @ Holen an der Stelle-1
  adds r0, #1
  strb r2, [r0] @ Schreiben an der Stelle
  subs r0, #1 @ Weiterrücken

  subs r1, #1
  cmp r1, #1 @ Bis nur noch ein Zeichen bleibt. Das ist das Neue.
  bne 1b

2:@ Das neue Zeichen an seinen Platz legen
  strb r3, [r0] 

3:bx lr


@------------------------------------------------------------------------------
  Wortbirne Flag_visible, "sign"
vorzeichen: @ ( Vorzeichen -- )
      @ Prüft die Zahl auf dem Stack auf ihr Vorzeichen hin und
      @ fügt bei Bedarf ein Minus an den Ziffernstring an.
@------------------------------------------------------------------------------
  popda r0

  cmp r0, #0
  bmi 1f
  bx lr

1:pushdaconst 45 @ Minuszeichen
  b hold         @ an den Zahlenpuffer anhängen

@------------------------------------------------------------------------------
  Wortbirne Flag_visible, "#>" @ ( ZahlenrestL (ZahlenrestH) -- Addr )
zifferstringende:  @ Schließt einen neuen Ziffernstring ab und gibt seine Adresse zurück.
                   @ Benutzt dafür einfach den Zahlenpuffer.
@------------------------------------------------------------------------------
@  ifdef doppeltzahleneinbinden
@    drop
@  endif
  ldr tos, =Zahlenpuffer @ Rest überschreiben, einfach in TOS legen.
  bx lr

@------------------------------------------------------------------------------
  Wortbirne Flag_visible, "#S"
alleziffern: @ ( Zahl -- Zahl=0 )
      @ Fügt alle Ziffern, jedoch mindestens eine,
      @ an den im aufbau befindlichen String an.
      @ Benutzt dafür einfach den Zahlenpuffer.
      @ Normalerweise doppeltgenau, hier nur einfachgenau.
@------------------------------------------------------------------------------
  push {lr}
1:bl ziffer
  cmp tos, #0 @ Wenn im High-Teil
  bne 1b
  pop {pc}

@------------------------------------------------------------------------------
  Wortbirne Flag_visible, "#"
ziffer: @ ( Zahl -- Zahl ) oder
        @ ( ZahlL ZahlH -- ZahlL ZahlH )
      @ Fügt eine weitere Ziffer hinzu, Rest entsprechend verkleinert.
      @ Benutzt dafür einfach den Zahlenpuffer.
@------------------------------------------------------------------------------
  @ Idee dahinter: Teile durch die Basis.
  @ Bekomme einen Rest, und einen Teil, den ich im nächsten Durchlauf
  @ behandeln muss. Der Rest ist die Ziffer.
  push {lr}
    @ Normalerweise doppeltgenau, hier nur einfachgenau.
    ldr r0, =base
    ldr r0, [r0]
    pushda r0 @ Basis
    @ Müsste haben: (u Basis -- )
    bl u_divmod @ ( u u -- u u ) Dividend Divisor -- Ergebnis Rest
    swap
    @ Erhalte zurück ( -- Ergebnis Rest )
    @ Der Rest ist die Ziffer, die ich an dieser Stelle wünsche.
    bl digitausgeben
    @ Habe nun das Zeichen auf dem Stack. ( -- Ergebnis Zeichen )
    @ Füge das Zeichen in den String ein.
    bl hold
    @ ( Ergebnis )
  pop {pc}


@------------------------------------------------------------------------------
  Wortbirne Flag_visible, "<#" @ ( Zahl -- Zahl )
zifferstringanfang: @ Eröffnet einen neuen Ziffernstring.
                    @ Benutzt dafür einfach den Zahlenpuffer.
                    @ Normalerweise doppeltgenau, hier nur einfachgenau.
@------------------------------------------------------------------------------
  ldr r0, =Zahlenpuffer @ Länge löschen, bisherige Länge Null.
  movs r1, #0
  strb r1, [r0]
  bx lr  

/*
  ; Idee dahinter: Teile durch die Basis.
  ; Bekomme einen Rest, und einen Teil, den ich im nächsten Durchlauf
  ; behandeln muss. Der Rest ist die Ziffer.
*/ 

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "u."
      @ ( Zahl -- )
      @ Gibt eine vorzeichenlose Zahl aus.
      @ Benutzt dafür einfach den Zahlenpuffer.
@ -----------------------------------------------------------------------------
  push {lr}
  @ In Forth: <# #S #>
  bl zifferstringanfang
  bl alleziffern
  bl dot_inneneinsprung

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "." @ ( Zahl -- )
     @ Gibt eine vorzeichenbehaftete Zahl aus.
     @ Benutzt dafür einfach den Zahlenpuffer.
@ -----------------------------------------------------------------------------
  push {lr}
  @ In Forth: dup abs <# #S SIGN #>
  dup @ ( Vorzeichen Zahl )

  cmp tos, #0 @ abs(tos)
  it mi
  rsbsmi tos, tos, #0 @ ( Vorzeichen u )

  bl zifferstringanfang
  bl alleziffern    @ ( Vorzeichen 0 )
  swap              @ ( 0 Vorzeichen )
  bl vorzeichen

dot_inneneinsprung:
  bl zifferstringende
  bl type
  pushdaconst 32
  bl emit
  pop {pc}
