: portc-on ( -- ) 2 bit RCC_AHB4ENR bis! ;
: pc9-af0 ( -- ) $f0 GPIOC_AFRH bic! ;
: pc9-alt ( -- ) GPIOC_MODER @ 19 bit or 18 bit not and GPIOC_MODER ! ;
: pc9-very-fast ( -- ) %11 18 lshift GPIOC_OSPEEDR bis! ;
: init-mco2 ( -- )
    10 25 lshift RCC_CFGR bis!
    portc-on
    pc9-very-fast
    pc9-af0
    pc9-alt ;

: porta-on ( -- ) 0 bit RCC_AHB4ENR bis! ;
: pa8-af0 ( -- ) $f GPIOA_AFRH bic! ;
: pa8-alt ( -- ) GPIOA_MODER @ 17 bit or 16 bit not and GPIOA_MODER ! ;
: pa8-very-fast ( -- ) %11 16 lshift GPIOA_OSPEEDR bis! ;
: init-mco1 ( -- ) porta-on pa8-very-fast pa8-af0 pa8-alt ;
: mco1! ( x -- ) 22 lshift RCC_CFGR @ %111 22 lshift not and or RCC_CFGR ! ;

init-mco2
