$58024400 constant RCC ( Reset and clock control ) 
RCC $0 + constant RCC_CR ( read-write )  \ clock control register
RCC $4 + constant RCC_ICSCR (  )  \ RCC Internal Clock Source Calibration  Register
RCC $8 + constant RCC_CRRCR ( read-only )  \ RCC Clock Recovery RC Register
RCC $10 + constant RCC_CFGR ( read-write )  \ RCC Clock Configuration  Register
RCC $18 + constant RCC_D1CFGR ( read-write )  \ RCC Domain 1 Clock Configuration  Register
RCC $1C + constant RCC_D2CFGR ( read-write )  \ RCC Domain 2 Clock Configuration  Register
RCC $20 + constant RCC_D3CFGR ( read-write )  \ RCC Domain 3 Clock Configuration  Register
RCC $28 + constant RCC_PLLCKSELR ( read-write )  \ RCC PLLs Clock Source Selection  Register
RCC $2C + constant RCC_PLLCFGR ( read-write )  \ RCC PLLs Configuration  Register
RCC $30 + constant RCC_PLL1DIVR ( read-write )  \ RCC PLL1 Dividers Configuration  Register
RCC $34 + constant RCC_PLL1FRACR ( read-write )  \ RCC PLL1 Fractional Divider  Register
RCC $38 + constant RCC_PLL2DIVR ( read-write )  \ RCC PLL2 Dividers Configuration  Register
RCC $3C + constant RCC_PLL2FRACR ( read-write )  \ RCC PLL2 Fractional Divider  Register
RCC $40 + constant RCC_PLL3DIVR ( read-write )  \ RCC PLL3 Dividers Configuration  Register
RCC $44 + constant RCC_PLL3FRACR ( read-write )  \ RCC PLL3 Fractional Divider  Register
RCC $4C + constant RCC_D1CCIPR ( read-write )  \ RCC Domain 1 Kernel Clock Configuration  Register
RCC $50 + constant RCC_D2CCIP1R ( read-write )  \ RCC Domain 2 Kernel Clock Configuration  Register
RCC $54 + constant RCC_D2CCIP2R ( read-write )  \ RCC Domain 2 Kernel Clock Configuration  Register
RCC $58 + constant RCC_D3CCIPR ( read-write )  \ RCC Domain 3 Kernel Clock Configuration  Register
RCC $60 + constant RCC_CIER ( read-write )  \ RCC Clock Source Interrupt Enable  Register
RCC $64 + constant RCC_CIFR ( read-write )  \ RCC Clock Source Interrupt Flag  Register
RCC $68 + constant RCC_CICR ( read-write )  \ RCC Clock Source Interrupt Clear  Register
RCC $70 + constant RCC_BDCR ( read-write )  \ RCC Backup Domain Control  Register
RCC $74 + constant RCC_CSR ( read-write )  \ RCC Clock Control and Status  Register
RCC $7C + constant RCC_AHB3RSTR ( read-write )  \ RCC AHB3 Reset Register
RCC $80 + constant RCC_AHB1RSTR ( read-write )  \ RCC AHB1 Peripheral Reset  Register
RCC $84 + constant RCC_AHB2RSTR ( read-write )  \ RCC AHB2 Peripheral Reset  Register
RCC $88 + constant RCC_AHB4RSTR ( read-write )  \ RCC AHB4 Peripheral Reset  Register
RCC $8C + constant RCC_APB3RSTR ( read-write )  \ RCC APB3 Peripheral Reset  Register
RCC $90 + constant RCC_APB1LRSTR ( read-write )  \ RCC APB1 Peripheral Reset  Register
RCC $94 + constant RCC_APB1HRSTR ( read-write )  \ RCC APB1 Peripheral Reset  Register
RCC $98 + constant RCC_APB2RSTR ( read-write )  \ RCC APB2 Peripheral Reset  Register
RCC $9C + constant RCC_APB4RSTR ( read-write )  \ RCC APB4 Peripheral Reset  Register
RCC $A0 + constant RCC_GCR ( read-write )  \ RCC Global Control Register
RCC $A8 + constant RCC_D3AMR ( read-write )  \ RCC D3 Autonomous mode  Register
RCC $D0 + constant RCC_RSR ( read-write )  \ RCC Reset Status Register
RCC $130 + constant RCC_C1_RSR ( read-write )  \ RCC Reset Status Register
RCC $134 + constant RCC_C1_AHB3ENR ( read-write )  \ RCC AHB3 Clock Register
RCC $D4 + constant RCC_AHB3ENR ( read-write )  \ RCC AHB3 Clock Register
RCC $D8 + constant RCC_AHB1ENR ( read-write )  \ RCC AHB1 Clock Register
RCC $138 + constant RCC_C1_AHB1ENR ( read-write )  \ RCC AHB1 Clock Register
RCC $13C + constant RCC_C1_AHB2ENR ( read-write )  \ RCC AHB2 Clock Register
RCC $DC + constant RCC_AHB2ENR ( read-write )  \ RCC AHB2 Clock Register
RCC $E0 + constant RCC_AHB4ENR ( read-write )  \ RCC AHB4 Clock Register
RCC $140 + constant RCC_C1_AHB4ENR ( read-write )  \ RCC AHB4 Clock Register
RCC $144 + constant RCC_C1_APB3ENR ( read-write )  \ RCC APB3 Clock Register
RCC $E4 + constant RCC_APB3ENR ( read-write )  \ RCC APB3 Clock Register
RCC $E8 + constant RCC_APB1LENR ( read-write )  \ RCC APB1 Clock Register
RCC $148 + constant RCC_C1_APB1LENR ( read-write )  \ RCC APB1 Clock Register
RCC $EC + constant RCC_APB1HENR ( read-write )  \ RCC APB1 Clock Register
RCC $14C + constant RCC_C1_APB1HENR ( read-write )  \ RCC APB1 Clock Register
RCC $150 + constant RCC_C1_APB2ENR ( read-write )  \ RCC APB2 Clock Register
RCC $F0 + constant RCC_APB2ENR ( read-write )  \ RCC APB2 Clock Register
RCC $F4 + constant RCC_APB4ENR ( read-write )  \ RCC APB4 Clock Register
RCC $154 + constant RCC_C1_APB4ENR ( read-write )  \ RCC APB4 Clock Register
RCC $15C + constant RCC_C1_AHB3LPENR ( read-write )  \ RCC AHB3 Sleep Clock Register
RCC $FC + constant RCC_AHB3LPENR ( read-write )  \ RCC AHB3 Sleep Clock Register
RCC $100 + constant RCC_AHB1LPENR ( read-write )  \ RCC AHB1 Sleep Clock Register
RCC $160 + constant RCC_C1_AHB1LPENR ( read-write )  \ RCC AHB1 Sleep Clock Register
RCC $164 + constant RCC_C1_AHB2LPENR ( read-write )  \ RCC AHB2 Sleep Clock Register
RCC $104 + constant RCC_AHB2LPENR ( read-write )  \ RCC AHB2 Sleep Clock Register
RCC $108 + constant RCC_AHB4LPENR ( read-write )  \ RCC AHB4 Sleep Clock Register
RCC $168 + constant RCC_C1_AHB4LPENR ( read-write )  \ RCC AHB4 Sleep Clock Register
RCC $16C + constant RCC_C1_APB3LPENR ( read-write )  \ RCC APB3 Sleep Clock Register
RCC $10C + constant RCC_APB3LPENR ( read-write )  \ RCC APB3 Sleep Clock Register
RCC $110 + constant RCC_APB1LLPENR ( read-write )  \ RCC APB1 Low Sleep Clock  Register
RCC $170 + constant RCC_C1_APB1LLPENR ( read-write )  \ RCC APB1 Low Sleep Clock  Register
RCC $174 + constant RCC_C1_APB1HLPENR ( read-write )  \ RCC APB1 High Sleep Clock  Register
RCC $114 + constant RCC_APB1HLPENR ( read-write )  \ RCC APB1 High Sleep Clock  Register
RCC $118 + constant RCC_APB2LPENR ( read-write )  \ RCC APB2 Sleep Clock Register
RCC $178 + constant RCC_C1_APB2LPENR ( read-write )  \ RCC APB2 Sleep Clock Register
RCC $17C + constant RCC_C1_APB4LPENR ( read-write )  \ RCC APB4 Sleep Clock Register
RCC $11C + constant RCC_APB4LPENR ( read-write )  \ RCC APB4 Sleep Clock Register
: RCC_CR. cr ." RCC_CR.  RW   $" RCC_CR @ hex. RCC_CR 1b. ;
: RCC_ICSCR. cr ." RCC_ICSCR.   $" RCC_ICSCR @ hex. RCC_ICSCR 1b. ;
: RCC_CRRCR. cr ." RCC_CRRCR.  RO   $" RCC_CRRCR @ hex. RCC_CRRCR 1b. ;
: RCC_CFGR. cr ." RCC_CFGR.  RW   $" RCC_CFGR @ hex. RCC_CFGR 1b. ;
: RCC_D1CFGR. cr ." RCC_D1CFGR.  RW   $" RCC_D1CFGR @ hex. RCC_D1CFGR 1b. ;
: RCC_D2CFGR. cr ." RCC_D2CFGR.  RW   $" RCC_D2CFGR @ hex. RCC_D2CFGR 1b. ;
: RCC_D3CFGR. cr ." RCC_D3CFGR.  RW   $" RCC_D3CFGR @ hex. RCC_D3CFGR 1b. ;
: RCC_PLLCKSELR. cr ." RCC_PLLCKSELR.  RW   $" RCC_PLLCKSELR @ hex. RCC_PLLCKSELR 1b. ;
: RCC_PLLCFGR. cr ." RCC_PLLCFGR.  RW   $" RCC_PLLCFGR @ hex. RCC_PLLCFGR 1b. ;
: RCC_PLL1DIVR. cr ." RCC_PLL1DIVR.  RW   $" RCC_PLL1DIVR @ hex. RCC_PLL1DIVR 1b. ;
: RCC_PLL1FRACR. cr ." RCC_PLL1FRACR.  RW   $" RCC_PLL1FRACR @ hex. RCC_PLL1FRACR 1b. ;
: RCC_PLL2DIVR. cr ." RCC_PLL2DIVR.  RW   $" RCC_PLL2DIVR @ hex. RCC_PLL2DIVR 1b. ;
: RCC_PLL2FRACR. cr ." RCC_PLL2FRACR.  RW   $" RCC_PLL2FRACR @ hex. RCC_PLL2FRACR 1b. ;
: RCC_PLL3DIVR. cr ." RCC_PLL3DIVR.  RW   $" RCC_PLL3DIVR @ hex. RCC_PLL3DIVR 1b. ;
: RCC_PLL3FRACR. cr ." RCC_PLL3FRACR.  RW   $" RCC_PLL3FRACR @ hex. RCC_PLL3FRACR 1b. ;
: RCC_D1CCIPR. cr ." RCC_D1CCIPR.  RW   $" RCC_D1CCIPR @ hex. RCC_D1CCIPR 1b. ;
: RCC_D2CCIP1R. cr ." RCC_D2CCIP1R.  RW   $" RCC_D2CCIP1R @ hex. RCC_D2CCIP1R 1b. ;
: RCC_D2CCIP2R. cr ." RCC_D2CCIP2R.  RW   $" RCC_D2CCIP2R @ hex. RCC_D2CCIP2R 1b. ;
: RCC_D3CCIPR. cr ." RCC_D3CCIPR.  RW   $" RCC_D3CCIPR @ hex. RCC_D3CCIPR 1b. ;
: RCC_CIER. cr ." RCC_CIER.  RW   $" RCC_CIER @ hex. RCC_CIER 1b. ;
: RCC_CIFR. cr ." RCC_CIFR.  RW   $" RCC_CIFR @ hex. RCC_CIFR 1b. ;
: RCC_CICR. cr ." RCC_CICR.  RW   $" RCC_CICR @ hex. RCC_CICR 1b. ;
: RCC_BDCR. cr ." RCC_BDCR.  RW   $" RCC_BDCR @ hex. RCC_BDCR 1b. ;
: RCC_CSR. cr ." RCC_CSR.  RW   $" RCC_CSR @ hex. RCC_CSR 1b. ;
: RCC_AHB3RSTR. cr ." RCC_AHB3RSTR.  RW   $" RCC_AHB3RSTR @ hex. RCC_AHB3RSTR 1b. ;
: RCC_AHB1RSTR. cr ." RCC_AHB1RSTR.  RW   $" RCC_AHB1RSTR @ hex. RCC_AHB1RSTR 1b. ;
: RCC_AHB2RSTR. cr ." RCC_AHB2RSTR.  RW   $" RCC_AHB2RSTR @ hex. RCC_AHB2RSTR 1b. ;
: RCC_AHB4RSTR. cr ." RCC_AHB4RSTR.  RW   $" RCC_AHB4RSTR @ hex. RCC_AHB4RSTR 1b. ;
: RCC_APB3RSTR. cr ." RCC_APB3RSTR.  RW   $" RCC_APB3RSTR @ hex. RCC_APB3RSTR 1b. ;
: RCC_APB1LRSTR. cr ." RCC_APB1LRSTR.  RW   $" RCC_APB1LRSTR @ hex. RCC_APB1LRSTR 1b. ;
: RCC_APB1HRSTR. cr ." RCC_APB1HRSTR.  RW   $" RCC_APB1HRSTR @ hex. RCC_APB1HRSTR 1b. ;
: RCC_APB2RSTR. cr ." RCC_APB2RSTR.  RW   $" RCC_APB2RSTR @ hex. RCC_APB2RSTR 1b. ;
: RCC_APB4RSTR. cr ." RCC_APB4RSTR.  RW   $" RCC_APB4RSTR @ hex. RCC_APB4RSTR 1b. ;
: RCC_GCR. cr ." RCC_GCR.  RW   $" RCC_GCR @ hex. RCC_GCR 1b. ;
: RCC_D3AMR. cr ." RCC_D3AMR.  RW   $" RCC_D3AMR @ hex. RCC_D3AMR 1b. ;
: RCC_RSR. cr ." RCC_RSR.  RW   $" RCC_RSR @ hex. RCC_RSR 1b. ;
: RCC_C1_RSR. cr ." RCC_C1_RSR.  RW   $" RCC_C1_RSR @ hex. RCC_C1_RSR 1b. ;
: RCC_C1_AHB3ENR. cr ." RCC_C1_AHB3ENR.  RW   $" RCC_C1_AHB3ENR @ hex. RCC_C1_AHB3ENR 1b. ;
: RCC_AHB3ENR. cr ." RCC_AHB3ENR.  RW   $" RCC_AHB3ENR @ hex. RCC_AHB3ENR 1b. ;
: RCC_AHB1ENR. cr ." RCC_AHB1ENR.  RW   $" RCC_AHB1ENR @ hex. RCC_AHB1ENR 1b. ;
: RCC_C1_AHB1ENR. cr ." RCC_C1_AHB1ENR.  RW   $" RCC_C1_AHB1ENR @ hex. RCC_C1_AHB1ENR 1b. ;
: RCC_C1_AHB2ENR. cr ." RCC_C1_AHB2ENR.  RW   $" RCC_C1_AHB2ENR @ hex. RCC_C1_AHB2ENR 1b. ;
: RCC_AHB2ENR. cr ." RCC_AHB2ENR.  RW   $" RCC_AHB2ENR @ hex. RCC_AHB2ENR 1b. ;
: RCC_AHB4ENR. cr ." RCC_AHB4ENR.  RW   $" RCC_AHB4ENR @ hex. RCC_AHB4ENR 1b. ;
: RCC_C1_AHB4ENR. cr ." RCC_C1_AHB4ENR.  RW   $" RCC_C1_AHB4ENR @ hex. RCC_C1_AHB4ENR 1b. ;
: RCC_C1_APB3ENR. cr ." RCC_C1_APB3ENR.  RW   $" RCC_C1_APB3ENR @ hex. RCC_C1_APB3ENR 1b. ;
: RCC_APB3ENR. cr ." RCC_APB3ENR.  RW   $" RCC_APB3ENR @ hex. RCC_APB3ENR 1b. ;
: RCC_APB1LENR. cr ." RCC_APB1LENR.  RW   $" RCC_APB1LENR @ hex. RCC_APB1LENR 1b. ;
: RCC_C1_APB1LENR. cr ." RCC_C1_APB1LENR.  RW   $" RCC_C1_APB1LENR @ hex. RCC_C1_APB1LENR 1b. ;
: RCC_APB1HENR. cr ." RCC_APB1HENR.  RW   $" RCC_APB1HENR @ hex. RCC_APB1HENR 1b. ;
: RCC_C1_APB1HENR. cr ." RCC_C1_APB1HENR.  RW   $" RCC_C1_APB1HENR @ hex. RCC_C1_APB1HENR 1b. ;
: RCC_C1_APB2ENR. cr ." RCC_C1_APB2ENR.  RW   $" RCC_C1_APB2ENR @ hex. RCC_C1_APB2ENR 1b. ;
: RCC_APB2ENR. cr ." RCC_APB2ENR.  RW   $" RCC_APB2ENR @ hex. RCC_APB2ENR 1b. ;
: RCC_APB4ENR. cr ." RCC_APB4ENR.  RW   $" RCC_APB4ENR @ hex. RCC_APB4ENR 1b. ;
: RCC_C1_APB4ENR. cr ." RCC_C1_APB4ENR.  RW   $" RCC_C1_APB4ENR @ hex. RCC_C1_APB4ENR 1b. ;
: RCC_C1_AHB3LPENR. cr ." RCC_C1_AHB3LPENR.  RW   $" RCC_C1_AHB3LPENR @ hex. RCC_C1_AHB3LPENR 1b. ;
: RCC_AHB3LPENR. cr ." RCC_AHB3LPENR.  RW   $" RCC_AHB3LPENR @ hex. RCC_AHB3LPENR 1b. ;
: RCC_AHB1LPENR. cr ." RCC_AHB1LPENR.  RW   $" RCC_AHB1LPENR @ hex. RCC_AHB1LPENR 1b. ;
: RCC_C1_AHB1LPENR. cr ." RCC_C1_AHB1LPENR.  RW   $" RCC_C1_AHB1LPENR @ hex. RCC_C1_AHB1LPENR 1b. ;
: RCC_C1_AHB2LPENR. cr ." RCC_C1_AHB2LPENR.  RW   $" RCC_C1_AHB2LPENR @ hex. RCC_C1_AHB2LPENR 1b. ;
: RCC_AHB2LPENR. cr ." RCC_AHB2LPENR.  RW   $" RCC_AHB2LPENR @ hex. RCC_AHB2LPENR 1b. ;
: RCC_AHB4LPENR. cr ." RCC_AHB4LPENR.  RW   $" RCC_AHB4LPENR @ hex. RCC_AHB4LPENR 1b. ;
: RCC_C1_AHB4LPENR. cr ." RCC_C1_AHB4LPENR.  RW   $" RCC_C1_AHB4LPENR @ hex. RCC_C1_AHB4LPENR 1b. ;
: RCC_C1_APB3LPENR. cr ." RCC_C1_APB3LPENR.  RW   $" RCC_C1_APB3LPENR @ hex. RCC_C1_APB3LPENR 1b. ;
: RCC_APB3LPENR. cr ." RCC_APB3LPENR.  RW   $" RCC_APB3LPENR @ hex. RCC_APB3LPENR 1b. ;
: RCC_APB1LLPENR. cr ." RCC_APB1LLPENR.  RW   $" RCC_APB1LLPENR @ hex. RCC_APB1LLPENR 1b. ;
: RCC_C1_APB1LLPENR. cr ." RCC_C1_APB1LLPENR.  RW   $" RCC_C1_APB1LLPENR @ hex. RCC_C1_APB1LLPENR 1b. ;
: RCC_C1_APB1HLPENR. cr ." RCC_C1_APB1HLPENR.  RW   $" RCC_C1_APB1HLPENR @ hex. RCC_C1_APB1HLPENR 1b. ;
: RCC_APB1HLPENR. cr ." RCC_APB1HLPENR.  RW   $" RCC_APB1HLPENR @ hex. RCC_APB1HLPENR 1b. ;
: RCC_APB2LPENR. cr ." RCC_APB2LPENR.  RW   $" RCC_APB2LPENR @ hex. RCC_APB2LPENR 1b. ;
: RCC_C1_APB2LPENR. cr ." RCC_C1_APB2LPENR.  RW   $" RCC_C1_APB2LPENR @ hex. RCC_C1_APB2LPENR 1b. ;
: RCC_C1_APB4LPENR. cr ." RCC_C1_APB4LPENR.  RW   $" RCC_C1_APB4LPENR @ hex. RCC_C1_APB4LPENR 1b. ;
: RCC_APB4LPENR. cr ." RCC_APB4LPENR.  RW   $" RCC_APB4LPENR @ hex. RCC_APB4LPENR 1b. ;
: RCC.
RCC_CR.
RCC_ICSCR.
RCC_CRRCR.
RCC_CFGR.
RCC_D1CFGR.
RCC_D2CFGR.
RCC_D3CFGR.
RCC_PLLCKSELR.
RCC_PLLCFGR.
RCC_PLL1DIVR.
RCC_PLL1FRACR.
RCC_PLL2DIVR.
RCC_PLL2FRACR.
RCC_PLL3DIVR.
RCC_PLL3FRACR.
RCC_D1CCIPR.
RCC_D2CCIP1R.
RCC_D2CCIP2R.
RCC_D3CCIPR.
RCC_CIER.
RCC_CIFR.
RCC_CICR.
RCC_BDCR.
RCC_CSR.
RCC_AHB3RSTR.
RCC_AHB1RSTR.
RCC_AHB2RSTR.
RCC_AHB4RSTR.
RCC_APB3RSTR.
RCC_APB1LRSTR.
RCC_APB1HRSTR.
RCC_APB2RSTR.
RCC_APB4RSTR.
RCC_GCR.
RCC_D3AMR.
RCC_RSR.
RCC_C1_RSR.
RCC_C1_AHB3ENR.
RCC_AHB3ENR.
RCC_AHB1ENR.
RCC_C1_AHB1ENR.
RCC_C1_AHB2ENR.
RCC_AHB2ENR.
RCC_AHB4ENR.
RCC_C1_AHB4ENR.
RCC_C1_APB3ENR.
RCC_APB3ENR.
RCC_APB1LENR.
RCC_C1_APB1LENR.
RCC_APB1HENR.
RCC_C1_APB1HENR.
RCC_C1_APB2ENR.
RCC_APB2ENR.
RCC_APB4ENR.
RCC_C1_APB4ENR.
RCC_C1_AHB3LPENR.
RCC_AHB3LPENR.
RCC_AHB1LPENR.
RCC_C1_AHB1LPENR.
RCC_C1_AHB2LPENR.
RCC_AHB2LPENR.
RCC_AHB4LPENR.
RCC_C1_AHB4LPENR.
RCC_C1_APB3LPENR.
RCC_APB3LPENR.
RCC_APB1LLPENR.
RCC_C1_APB1LLPENR.
RCC_C1_APB1HLPENR.
RCC_APB1HLPENR.
RCC_APB2LPENR.
RCC_C1_APB2LPENR.
RCC_C1_APB4LPENR.
RCC_APB4LPENR.
;
