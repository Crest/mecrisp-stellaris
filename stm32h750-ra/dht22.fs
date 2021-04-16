3 bit constant GPIODEN
12    constant dht22-pin
false variable dht22-valid
-1    variable dht22-sample

: >us ( n -- x )      400   * 1-foldable inline ;
: >ms ( n -- x ) 1000 400 * * 1-foldable inline ;
: us ( n -- ) >us delay-cycles ;
: ms ( n -- ) >ms delay-cycles ;
: dht22-port-on ( -- ) GPIODEN RCC_AHB4ENR bis! ;
: dht22-input  ( -- ) %11 dht22-pin 2* lshift GPIOD_MODER bic! ; \ Configure PD12 as digital input
: dht22-output ( -- ) %01 dht22-pin 2* lshift GPIOD_MODER bis! ; \ Configure PD12 as digital output
: dht22-pullup ( -- ) %01 dht22-pin 2* lshift GPIOD_PUPDR bis! ; \ Enable internal pull-up on PD12
: dht22-high ( -- ) dht22-output 12  0 + bit GPIOD_BSRR ! ; \ Output high
: dht22-low  ( -- ) dht22-output 12 16 + bit GPIOD_BSRR ! ; \ Output low
: dht22-data ( -- ? ) GPIOD_IDR @ 31 dht22-pin - lshift 31 arshift ;
: init-dht22 ( -- ) dht22-port-on dht22-pullup dht22-input ;

: dht22-falling ( -- ) begin dht22-data not until ;
: dht22-rising  ( -- ) begin dht22-data     until ;
: dht22-read1  ( -- 0/1 ) dht22-rising cycles dht22-falling cycles swap - 40 >us > 1 and ;
: dht22-read32 ( -- x   ) 0 32 0 do 1 lshift dht22-read1 or loop ;
: dht22-read8  ( -- x   ) 0  8 0 do 1 lshift dht22-read1 or loop ;
: dht22-start ( -- ) dht22-low 2 ms dht22-high 25 us dht22-input dht22-falling dht22-rising dht22-falling ;

: dht22-read ( -- sample sum ) dht22-start dht22-read32 dht22-read8 ;

: dht22. ( x -- )
    dup 16 rshift 0 ." RH: " <# [char] % hold # [char] . hold # # # #> type
    dup $8000 and 0<> swap $7fff and 0 ." , T: " <# [char] C hold # [char] . hold # # # rot sign #> type ;

: init ( -- ) init-cycles init-dht22 ;
init
\ dht22-read drop dht22.
