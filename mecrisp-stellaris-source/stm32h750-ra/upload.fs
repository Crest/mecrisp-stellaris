\ Program Name: utils.fs  for Mecrisp-Stellaris by Matthias Koch and licensed under the GPL
\ Copyright 2019 t.porter <terry@tjporter.com.au> and licensed under the BSD license.
\ This program must be loaded before memmap.fs as it provided the pretty printing legend for generic 32 bit prints
\ Also included is "bin." which prints the binary form of a number with no spaces between numbers for easy copy and pasting purposes

\ -------------------
\  Beautiful output
\ -------------------

: u.1 ( u -- ) 0 <# # #> type ;
: u.2 ( u -- ) 0 <# # # #> type ;
: u.3 ( u -- ) 0 <# # # # #> type ;
: u.4 ( u -- ) 0 <# # # # # #> type ;
: u.8 ( u -- ) 0 <# # # # # # # # # #> type ;
: h.1 ( u -- ) base @ hex swap  u.1  base ! ;
: h.2 ( u -- ) base @ hex swap  u.2  base ! ;
: h.3 ( u -- ) base @ hex swap  u.3  base ! ;
: h.4 ( u -- ) base @ hex swap  u.4  base ! ;
: h.8 ( u -- ) base @ hex swap  u.8  base ! ;

: hex.1 h.1 ;
: hex.2 h.2 ;
: hex.3 h.3 ;
: hex.4 h.4 ;

: u.ns 0 <# #s #> type ;
: const. ."  #" u.ns ;
: addr. u.8 ;
: .decimal base @ >r decimal . r> base ! ;

: bit ( u -- u ) 1 swap lshift  1-foldable ;	\ turn a bit position into a binary number.

: b8loop. ( u -- ) \ print  32 bits in 4 bit groups
0 <#
7 0 DO
# # # #
32 HOLD
LOOP
# # # # 
#>
TYPE ;

: b16loop. ( u -- ) \ print 32 bits in 2 bit groups
0 <#
15 0 DO
# #
32 HOLD
LOOP
# #
#>
TYPE ;

: b16loop-a. ( u -- ) \ print 16 bits in 1 bit groups
0  <#
15 0 DO 
#
32 HOLD
LOOP
#
#>
TYPE ;

: b32loop. ( u -- ) \ print 32 bits in 1 bit groups with vertical bars
0  <#
31 0 DO 
# 32 HOLD LOOP
# #>
TYPE ; 

: b32sloop. ( u -- ) \ print 32 bits in 1 bit groups without vertical bars
0  <#
31 0 DO
# LOOP
# #>
TYPE ;

\ Manual Use Legends ..............................................
: bin. ( u -- )  cr \ 1 bit legend - manual use
." 3322222222221111111111" cr
." 10987654321098765432109876543210 " cr
binary b32sloop. decimal cr ;

: bin1. ( u -- ) cr \ 1 bit legend - manual use
." 3|3|2|2|2|2|2|2|2|2|2|2|1|1|1|1|1|1|1|1|1|1|" cr
." 1|0|9|8|7|6|5|4|3|2|1|0|9|8|7|6|5|4|3|2|1|0|9|8|7|6|5|4|3|2|1|0 " cr
binary b32loop. decimal cr ;

: 1b. ( addr -- ) @ bin1. ;

: bin2. ( u -- ) cr \ 2 bit legend - manual use
." 15|14|13|12|11|10|09|08|07|06|05|04|03|02|01|00 " cr
binary b16loop. decimal cr ;

: bin4. ." Must be bin4h. or bin4l. " cr ;

: bin4l. ( u -- ) cr \ 4 bit generic legend for bits 7 - 0 - manual use
."  07   06   05   04   03   02   01   00  " cr
binary b8loop. decimal cr ;

: bin4h. ( u -- ) cr \ 4 bit generic legend for bits 15 - 8 - manual use
."  15   14   13   12   11   10   09   08  " cr
binary b8loop. decimal cr ;

: bin16. ( u -- ) cr  \ halfword legend
." 1|1|1|1|1|1|" cr
." 5|4|3|2|1|0|9|8|7|6|5|4|3|2|1|0 " cr
binary b16loop-a. decimal cr ;

: WRITEONLY ( -- ) ." write-only" cr ;
$58024800 constant PWR ( PWR ) 
PWR $0 + constant PWR_CR1 ( read-write )  \ PWR control register 1
PWR $4 + constant PWR_CSR1 ( read-only )  \ PWR control status register 1
PWR $8 + constant PWR_CR2 (  )  \ This register is not reset by wakeup from  Standby mode, RESET signal and VDD POR. It is only reset  by VSW POR and VSWRST reset. This register shall not be  accessed when VSWRST bit in RCC_BDCR register resets the  VSW domain.After reset, PWR_CR2 register is  write-protected. Prior to modifying its content, the DBP  bit in PWR_CR1 register must be set to disable the write  protection.
PWR $C + constant PWR_CR3 (  )  \ Reset only by POR only, not reset by wakeup  from Standby mode and RESET pad. The lower byte of this  register is written once after POR and shall be written  before changing VOS level or ck_sys clock frequency. No  limitation applies to the upper bytes.Programming data  corresponding to an invalid combination of SDLEVEL,  SDEXTHP, SDEN, LDOEN and BYPASS bits see Table9 will be  ignored: data will not be written, the written-once  mechanism will lock the register and any further write  access will be ignored. The default supply configuration  will be kept and the ACTVOSRDY bit in PWR control status  register 1 PWR_CSR1 will go on indicating invalid  voltage levels. The system shall be power cycled before  writing a new value.
PWR $10 + constant PWR_CPUCR (  )  \ This register allows controlling CPU1  power.
PWR $18 + constant PWR_D3CR (  )  \ This register allows controlling D3 domain  power.Following reset VOSRDY will be read 1 by  software
PWR $20 + constant PWR_WKUPCR ( read-write )  \ reset only by system reset, not reset by  wakeup from Standby mode5 wait states are required when  writing this register when clearing a WKUPF bit in  PWR_WKUPFR, the AHB write access will complete after the  WKUPF has been cleared.
PWR $24 + constant PWR_WKUPFR ( read-write )  \ reset only by system reset, not reset by  wakeup from Standby mode
PWR $28 + constant PWR_WKUPEPR ( read-write )  \ Reset only by system reset, not reset by  wakeup from Standby mode
: PWR_CR1. cr ." PWR_CR1.  RW   $" PWR_CR1 @ hex. PWR_CR1 1b. ;
: PWR_CSR1. cr ." PWR_CSR1.  RO   $" PWR_CSR1 @ hex. PWR_CSR1 1b. ;
: PWR_CR2. cr ." PWR_CR2.   $" PWR_CR2 @ hex. PWR_CR2 1b. ;
: PWR_CR3. cr ." PWR_CR3.   $" PWR_CR3 @ hex. PWR_CR3 1b. ;
: PWR_CPUCR. cr ." PWR_CPUCR.   $" PWR_CPUCR @ hex. PWR_CPUCR 1b. ;
: PWR_D3CR. cr ." PWR_D3CR.   $" PWR_D3CR @ hex. PWR_D3CR 1b. ;
: PWR_WKUPCR. cr ." PWR_WKUPCR.  RW   $" PWR_WKUPCR @ hex. PWR_WKUPCR 1b. ;
: PWR_WKUPFR. cr ." PWR_WKUPFR.  RW   $" PWR_WKUPFR @ hex. PWR_WKUPFR 1b. ;
: PWR_WKUPEPR. cr ." PWR_WKUPEPR.  RW   $" PWR_WKUPEPR @ hex. PWR_WKUPEPR 1b. ;
: PWR.
PWR_CR1.
PWR_CSR1.
PWR_CR2.
PWR_CR3.
PWR_CPUCR.
PWR_D3CR.
PWR_WKUPCR.
PWR_WKUPFR.
PWR_WKUPEPR.
;
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
$58020000 constant GPIOA ( GPIO ) 
GPIOA $0 + constant GPIOA_MODER ( read-write )  \ GPIO port mode register
GPIOA $4 + constant GPIOA_OTYPER ( read-write )  \ GPIO port output type register
GPIOA $8 + constant GPIOA_OSPEEDR ( read-write )  \ GPIO port output speed  register
GPIOA $C + constant GPIOA_PUPDR ( read-write )  \ GPIO port pull-up/pull-down  register
GPIOA $10 + constant GPIOA_IDR ( read-only )  \ GPIO port input data register
GPIOA $14 + constant GPIOA_ODR ( read-write )  \ GPIO port output data register
GPIOA $18 + constant GPIOA_BSRR ( write-only )  \ GPIO port bit set/reset  register
GPIOA $1C + constant GPIOA_LCKR ( read-write )  \ This register is used to lock the  configuration of the port bits when a correct write  sequence is applied to bit 16 LCKK. The value of bits  [15:0] is used to lock the configuration of the GPIO.  During the write sequence, the value of LCKR[15:0] must  not change. When the LOCK sequence has been applied on a  port bit, the value of this port bit can no longer be  modified until the next MCU reset or peripheral reset.A  specific write sequence is used to write to the  GPIOx_LCKR register. Only word access 32-bit long is  allowed during this locking sequence.Each lock bit  freezes a specific configuration register control and  alternate function registers.
GPIOA $20 + constant GPIOA_AFRL ( read-write )  \ GPIO alternate function low  register
GPIOA $24 + constant GPIOA_AFRH ( read-write )  \ GPIO alternate function high  register
: GPIOA_MODER. cr ." GPIOA_MODER.  RW   $" GPIOA_MODER @ hex. GPIOA_MODER 1b. ;
: GPIOA_OTYPER. cr ." GPIOA_OTYPER.  RW   $" GPIOA_OTYPER @ hex. GPIOA_OTYPER 1b. ;
: GPIOA_OSPEEDR. cr ." GPIOA_OSPEEDR.  RW   $" GPIOA_OSPEEDR @ hex. GPIOA_OSPEEDR 1b. ;
: GPIOA_PUPDR. cr ." GPIOA_PUPDR.  RW   $" GPIOA_PUPDR @ hex. GPIOA_PUPDR 1b. ;
: GPIOA_IDR. cr ." GPIOA_IDR.  RO   $" GPIOA_IDR @ hex. GPIOA_IDR 1b. ;
: GPIOA_ODR. cr ." GPIOA_ODR.  RW   $" GPIOA_ODR @ hex. GPIOA_ODR 1b. ;
: GPIOA_BSRR. cr ." GPIOA_BSRR " WRITEONLY ; 
: GPIOA_LCKR. cr ." GPIOA_LCKR.  RW   $" GPIOA_LCKR @ hex. GPIOA_LCKR 1b. ;
: GPIOA_AFRL. cr ." GPIOA_AFRL.  RW   $" GPIOA_AFRL @ hex. GPIOA_AFRL 1b. ;
: GPIOA_AFRH. cr ." GPIOA_AFRH.  RW   $" GPIOA_AFRH @ hex. GPIOA_AFRH 1b. ;
: GPIOA.
GPIOA_MODER.
GPIOA_OTYPER.
GPIOA_OSPEEDR.
GPIOA_PUPDR.
GPIOA_IDR.
GPIOA_ODR.
GPIOA_BSRR.
GPIOA_LCKR.
GPIOA_AFRL.
GPIOA_AFRH.
;

$58020400 constant GPIOB ( GPIO ) 
GPIOB $0 + constant GPIOB_MODER ( read-write )  \ GPIO port mode register
GPIOB $4 + constant GPIOB_OTYPER ( read-write )  \ GPIO port output type register
GPIOB $8 + constant GPIOB_OSPEEDR ( read-write )  \ GPIO port output speed  register
GPIOB $C + constant GPIOB_PUPDR ( read-write )  \ GPIO port pull-up/pull-down  register
GPIOB $10 + constant GPIOB_IDR ( read-only )  \ GPIO port input data register
GPIOB $14 + constant GPIOB_ODR ( read-write )  \ GPIO port output data register
GPIOB $18 + constant GPIOB_BSRR ( write-only )  \ GPIO port bit set/reset  register
GPIOB $1C + constant GPIOB_LCKR ( read-write )  \ This register is used to lock the  configuration of the port bits when a correct write  sequence is applied to bit 16 LCKK. The value of bits  [15:0] is used to lock the configuration of the GPIO.  During the write sequence, the value of LCKR[15:0] must  not change. When the LOCK sequence has been applied on a  port bit, the value of this port bit can no longer be  modified until the next MCU reset or peripheral reset.A  specific write sequence is used to write to the  GPIOx_LCKR register. Only word access 32-bit long is  allowed during this locking sequence.Each lock bit  freezes a specific configuration register control and  alternate function registers.
GPIOB $20 + constant GPIOB_AFRL ( read-write )  \ GPIO alternate function low  register
GPIOB $24 + constant GPIOB_AFRH ( read-write )  \ GPIO alternate function high  register
: GPIOB_MODER. cr ." GPIOB_MODER.  RW   $" GPIOB_MODER @ hex. GPIOB_MODER 1b. ;
: GPIOB_OTYPER. cr ." GPIOB_OTYPER.  RW   $" GPIOB_OTYPER @ hex. GPIOB_OTYPER 1b. ;
: GPIOB_OSPEEDR. cr ." GPIOB_OSPEEDR.  RW   $" GPIOB_OSPEEDR @ hex. GPIOB_OSPEEDR 1b. ;
: GPIOB_PUPDR. cr ." GPIOB_PUPDR.  RW   $" GPIOB_PUPDR @ hex. GPIOB_PUPDR 1b. ;
: GPIOB_IDR. cr ." GPIOB_IDR.  RO   $" GPIOB_IDR @ hex. GPIOB_IDR 1b. ;
: GPIOB_ODR. cr ." GPIOB_ODR.  RW   $" GPIOB_ODR @ hex. GPIOB_ODR 1b. ;
: GPIOB_BSRR. cr ." GPIOB_BSRR " WRITEONLY ; 
: GPIOB_LCKR. cr ." GPIOB_LCKR.  RW   $" GPIOB_LCKR @ hex. GPIOB_LCKR 1b. ;
: GPIOB_AFRL. cr ." GPIOB_AFRL.  RW   $" GPIOB_AFRL @ hex. GPIOB_AFRL 1b. ;
: GPIOB_AFRH. cr ." GPIOB_AFRH.  RW   $" GPIOB_AFRH @ hex. GPIOB_AFRH 1b. ;
: GPIOB.
GPIOB_MODER.
GPIOB_OTYPER.
GPIOB_OSPEEDR.
GPIOB_PUPDR.
GPIOB_IDR.
GPIOB_ODR.
GPIOB_BSRR.
GPIOB_LCKR.
GPIOB_AFRL.
GPIOB_AFRH.
;

$58020800 constant GPIOC ( GPIO ) 
GPIOC $0 + constant GPIOC_MODER ( read-write )  \ GPIO port mode register
GPIOC $4 + constant GPIOC_OTYPER ( read-write )  \ GPIO port output type register
GPIOC $8 + constant GPIOC_OSPEEDR ( read-write )  \ GPIO port output speed  register
GPIOC $C + constant GPIOC_PUPDR ( read-write )  \ GPIO port pull-up/pull-down  register
GPIOC $10 + constant GPIOC_IDR ( read-only )  \ GPIO port input data register
GPIOC $14 + constant GPIOC_ODR ( read-write )  \ GPIO port output data register
GPIOC $18 + constant GPIOC_BSRR ( write-only )  \ GPIO port bit set/reset  register
GPIOC $1C + constant GPIOC_LCKR ( read-write )  \ This register is used to lock the  configuration of the port bits when a correct write  sequence is applied to bit 16 LCKK. The value of bits  [15:0] is used to lock the configuration of the GPIO.  During the write sequence, the value of LCKR[15:0] must  not change. When the LOCK sequence has been applied on a  port bit, the value of this port bit can no longer be  modified until the next MCU reset or peripheral reset.A  specific write sequence is used to write to the  GPIOx_LCKR register. Only word access 32-bit long is  allowed during this locking sequence.Each lock bit  freezes a specific configuration register control and  alternate function registers.
GPIOC $20 + constant GPIOC_AFRL ( read-write )  \ GPIO alternate function low  register
GPIOC $24 + constant GPIOC_AFRH ( read-write )  \ GPIO alternate function high  register
: GPIOC_MODER. cr ." GPIOC_MODER.  RW   $" GPIOC_MODER @ hex. GPIOC_MODER 1b. ;
: GPIOC_OTYPER. cr ." GPIOC_OTYPER.  RW   $" GPIOC_OTYPER @ hex. GPIOC_OTYPER 1b. ;
: GPIOC_OSPEEDR. cr ." GPIOC_OSPEEDR.  RW   $" GPIOC_OSPEEDR @ hex. GPIOC_OSPEEDR 1b. ;
: GPIOC_PUPDR. cr ." GPIOC_PUPDR.  RW   $" GPIOC_PUPDR @ hex. GPIOC_PUPDR 1b. ;
: GPIOC_IDR. cr ." GPIOC_IDR.  RO   $" GPIOC_IDR @ hex. GPIOC_IDR 1b. ;
: GPIOC_ODR. cr ." GPIOC_ODR.  RW   $" GPIOC_ODR @ hex. GPIOC_ODR 1b. ;
: GPIOC_BSRR. cr ." GPIOC_BSRR " WRITEONLY ; 
: GPIOC_LCKR. cr ." GPIOC_LCKR.  RW   $" GPIOC_LCKR @ hex. GPIOC_LCKR 1b. ;
: GPIOC_AFRL. cr ." GPIOC_AFRL.  RW   $" GPIOC_AFRL @ hex. GPIOC_AFRL 1b. ;
: GPIOC_AFRH. cr ." GPIOC_AFRH.  RW   $" GPIOC_AFRH @ hex. GPIOC_AFRH 1b. ;
: GPIOC.
GPIOC_MODER.
GPIOC_OTYPER.
GPIOC_OSPEEDR.
GPIOC_PUPDR.
GPIOC_IDR.
GPIOC_ODR.
GPIOC_BSRR.
GPIOC_LCKR.
GPIOC_AFRL.
GPIOC_AFRH.
;

$58020C00 constant GPIOD ( GPIO ) 
GPIOD $0 + constant GPIOD_MODER ( read-write )  \ GPIO port mode register
GPIOD $4 + constant GPIOD_OTYPER ( read-write )  \ GPIO port output type register
GPIOD $8 + constant GPIOD_OSPEEDR ( read-write )  \ GPIO port output speed  register
GPIOD $C + constant GPIOD_PUPDR ( read-write )  \ GPIO port pull-up/pull-down  register
GPIOD $10 + constant GPIOD_IDR ( read-only )  \ GPIO port input data register
GPIOD $14 + constant GPIOD_ODR ( read-write )  \ GPIO port output data register
GPIOD $18 + constant GPIOD_BSRR ( write-only )  \ GPIO port bit set/reset  register
GPIOD $1C + constant GPIOD_LCKR ( read-write )  \ This register is used to lock the  configuration of the port bits when a correct write  sequence is applied to bit 16 LCKK. The value of bits  [15:0] is used to lock the configuration of the GPIO.  During the write sequence, the value of LCKR[15:0] must  not change. When the LOCK sequence has been applied on a  port bit, the value of this port bit can no longer be  modified until the next MCU reset or peripheral reset.A  specific write sequence is used to write to the  GPIOx_LCKR register. Only word access 32-bit long is  allowed during this locking sequence.Each lock bit  freezes a specific configuration register control and  alternate function registers.
GPIOD $20 + constant GPIOD_AFRL ( read-write )  \ GPIO alternate function low  register
GPIOD $24 + constant GPIOD_AFRH ( read-write )  \ GPIO alternate function high  register
: GPIOD_MODER. cr ." GPIOD_MODER.  RW   $" GPIOD_MODER @ hex. GPIOD_MODER 1b. ;
: GPIOD_OTYPER. cr ." GPIOD_OTYPER.  RW   $" GPIOD_OTYPER @ hex. GPIOD_OTYPER 1b. ;
: GPIOD_OSPEEDR. cr ." GPIOD_OSPEEDR.  RW   $" GPIOD_OSPEEDR @ hex. GPIOD_OSPEEDR 1b. ;
: GPIOD_PUPDR. cr ." GPIOD_PUPDR.  RW   $" GPIOD_PUPDR @ hex. GPIOD_PUPDR 1b. ;
: GPIOD_IDR. cr ." GPIOD_IDR.  RO   $" GPIOD_IDR @ hex. GPIOD_IDR 1b. ;
: GPIOD_ODR. cr ." GPIOD_ODR.  RW   $" GPIOD_ODR @ hex. GPIOD_ODR 1b. ;
: GPIOD_BSRR. cr ." GPIOD_BSRR " WRITEONLY ; 
: GPIOD_LCKR. cr ." GPIOD_LCKR.  RW   $" GPIOD_LCKR @ hex. GPIOD_LCKR 1b. ;
: GPIOD_AFRL. cr ." GPIOD_AFRL.  RW   $" GPIOD_AFRL @ hex. GPIOD_AFRL 1b. ;
: GPIOD_AFRH. cr ." GPIOD_AFRH.  RW   $" GPIOD_AFRH @ hex. GPIOD_AFRH 1b. ;
: GPIOD.
GPIOD_MODER.
GPIOD_OTYPER.
GPIOD_OSPEEDR.
GPIOD_PUPDR.
GPIOD_IDR.
GPIOD_ODR.
GPIOD_BSRR.
GPIOD_LCKR.
GPIOD_AFRL.
GPIOD_AFRH.
;

$58021000 constant GPIOE ( GPIO ) 
GPIOE $0 + constant GPIOE_MODER ( read-write )  \ GPIO port mode register
GPIOE $4 + constant GPIOE_OTYPER ( read-write )  \ GPIO port output type register
GPIOE $8 + constant GPIOE_OSPEEDR ( read-write )  \ GPIO port output speed  register
GPIOE $C + constant GPIOE_PUPDR ( read-write )  \ GPIO port pull-up/pull-down  register
GPIOE $10 + constant GPIOE_IDR ( read-only )  \ GPIO port input data register
GPIOE $14 + constant GPIOE_ODR ( read-write )  \ GPIO port output data register
GPIOE $18 + constant GPIOE_BSRR ( write-only )  \ GPIO port bit set/reset  register
GPIOE $1C + constant GPIOE_LCKR ( read-write )  \ This register is used to lock the  configuration of the port bits when a correct write  sequence is applied to bit 16 LCKK. The value of bits  [15:0] is used to lock the configuration of the GPIO.  During the write sequence, the value of LCKR[15:0] must  not change. When the LOCK sequence has been applied on a  port bit, the value of this port bit can no longer be  modified until the next MCU reset or peripheral reset.A  specific write sequence is used to write to the  GPIOx_LCKR register. Only word access 32-bit long is  allowed during this locking sequence.Each lock bit  freezes a specific configuration register control and  alternate function registers.
GPIOE $20 + constant GPIOE_AFRL ( read-write )  \ GPIO alternate function low  register
GPIOE $24 + constant GPIOE_AFRH ( read-write )  \ GPIO alternate function high  register
: GPIOE_MODER. cr ." GPIOE_MODER.  RW   $" GPIOE_MODER @ hex. GPIOE_MODER 1b. ;
: GPIOE_OTYPER. cr ." GPIOE_OTYPER.  RW   $" GPIOE_OTYPER @ hex. GPIOE_OTYPER 1b. ;
: GPIOE_OSPEEDR. cr ." GPIOE_OSPEEDR.  RW   $" GPIOE_OSPEEDR @ hex. GPIOE_OSPEEDR 1b. ;
: GPIOE_PUPDR. cr ." GPIOE_PUPDR.  RW   $" GPIOE_PUPDR @ hex. GPIOE_PUPDR 1b. ;
: GPIOE_IDR. cr ." GPIOE_IDR.  RO   $" GPIOE_IDR @ hex. GPIOE_IDR 1b. ;
: GPIOE_ODR. cr ." GPIOE_ODR.  RW   $" GPIOE_ODR @ hex. GPIOE_ODR 1b. ;
: GPIOE_BSRR. cr ." GPIOE_BSRR " WRITEONLY ; 
: GPIOE_LCKR. cr ." GPIOE_LCKR.  RW   $" GPIOE_LCKR @ hex. GPIOE_LCKR 1b. ;
: GPIOE_AFRL. cr ." GPIOE_AFRL.  RW   $" GPIOE_AFRL @ hex. GPIOE_AFRL 1b. ;
: GPIOE_AFRH. cr ." GPIOE_AFRH.  RW   $" GPIOE_AFRH @ hex. GPIOE_AFRH 1b. ;
: GPIOE.
GPIOE_MODER.
GPIOE_OTYPER.
GPIOE_OSPEEDR.
GPIOE_PUPDR.
GPIOE_IDR.
GPIOE_ODR.
GPIOE_BSRR.
GPIOE_LCKR.
GPIOE_AFRL.
GPIOE_AFRH.
;

$58021400 constant GPIOF ( GPIO ) 
GPIOF $0 + constant GPIOF_MODER ( read-write )  \ GPIO port mode register
GPIOF $4 + constant GPIOF_OTYPER ( read-write )  \ GPIO port output type register
GPIOF $8 + constant GPIOF_OSPEEDR ( read-write )  \ GPIO port output speed  register
GPIOF $C + constant GPIOF_PUPDR ( read-write )  \ GPIO port pull-up/pull-down  register
GPIOF $10 + constant GPIOF_IDR ( read-only )  \ GPIO port input data register
GPIOF $14 + constant GPIOF_ODR ( read-write )  \ GPIO port output data register
GPIOF $18 + constant GPIOF_BSRR ( write-only )  \ GPIO port bit set/reset  register
GPIOF $1C + constant GPIOF_LCKR ( read-write )  \ This register is used to lock the  configuration of the port bits when a correct write  sequence is applied to bit 16 LCKK. The value of bits  [15:0] is used to lock the configuration of the GPIO.  During the write sequence, the value of LCKR[15:0] must  not change. When the LOCK sequence has been applied on a  port bit, the value of this port bit can no longer be  modified until the next MCU reset or peripheral reset.A  specific write sequence is used to write to the  GPIOx_LCKR register. Only word access 32-bit long is  allowed during this locking sequence.Each lock bit  freezes a specific configuration register control and  alternate function registers.
GPIOF $20 + constant GPIOF_AFRL ( read-write )  \ GPIO alternate function low  register
GPIOF $24 + constant GPIOF_AFRH ( read-write )  \ GPIO alternate function high  register
: GPIOF_MODER. cr ." GPIOF_MODER.  RW   $" GPIOF_MODER @ hex. GPIOF_MODER 1b. ;
: GPIOF_OTYPER. cr ." GPIOF_OTYPER.  RW   $" GPIOF_OTYPER @ hex. GPIOF_OTYPER 1b. ;
: GPIOF_OSPEEDR. cr ." GPIOF_OSPEEDR.  RW   $" GPIOF_OSPEEDR @ hex. GPIOF_OSPEEDR 1b. ;
: GPIOF_PUPDR. cr ." GPIOF_PUPDR.  RW   $" GPIOF_PUPDR @ hex. GPIOF_PUPDR 1b. ;
: GPIOF_IDR. cr ." GPIOF_IDR.  RO   $" GPIOF_IDR @ hex. GPIOF_IDR 1b. ;
: GPIOF_ODR. cr ." GPIOF_ODR.  RW   $" GPIOF_ODR @ hex. GPIOF_ODR 1b. ;
: GPIOF_BSRR. cr ." GPIOF_BSRR " WRITEONLY ; 
: GPIOF_LCKR. cr ." GPIOF_LCKR.  RW   $" GPIOF_LCKR @ hex. GPIOF_LCKR 1b. ;
: GPIOF_AFRL. cr ." GPIOF_AFRL.  RW   $" GPIOF_AFRL @ hex. GPIOF_AFRL 1b. ;
: GPIOF_AFRH. cr ." GPIOF_AFRH.  RW   $" GPIOF_AFRH @ hex. GPIOF_AFRH 1b. ;
: GPIOF.
GPIOF_MODER.
GPIOF_OTYPER.
GPIOF_OSPEEDR.
GPIOF_PUPDR.
GPIOF_IDR.
GPIOF_ODR.
GPIOF_BSRR.
GPIOF_LCKR.
GPIOF_AFRL.
GPIOF_AFRH.
;

$58021800 constant GPIOG ( GPIO ) 
GPIOG $0 + constant GPIOG_MODER ( read-write )  \ GPIO port mode register
GPIOG $4 + constant GPIOG_OTYPER ( read-write )  \ GPIO port output type register
GPIOG $8 + constant GPIOG_OSPEEDR ( read-write )  \ GPIO port output speed  register
GPIOG $C + constant GPIOG_PUPDR ( read-write )  \ GPIO port pull-up/pull-down  register
GPIOG $10 + constant GPIOG_IDR ( read-only )  \ GPIO port input data register
GPIOG $14 + constant GPIOG_ODR ( read-write )  \ GPIO port output data register
GPIOG $18 + constant GPIOG_BSRR ( write-only )  \ GPIO port bit set/reset  register
GPIOG $1C + constant GPIOG_LCKR ( read-write )  \ This register is used to lock the  configuration of the port bits when a correct write  sequence is applied to bit 16 LCKK. The value of bits  [15:0] is used to lock the configuration of the GPIO.  During the write sequence, the value of LCKR[15:0] must  not change. When the LOCK sequence has been applied on a  port bit, the value of this port bit can no longer be  modified until the next MCU reset or peripheral reset.A  specific write sequence is used to write to the  GPIOx_LCKR register. Only word access 32-bit long is  allowed during this locking sequence.Each lock bit  freezes a specific configuration register control and  alternate function registers.
GPIOG $20 + constant GPIOG_AFRL ( read-write )  \ GPIO alternate function low  register
GPIOG $24 + constant GPIOG_AFRH ( read-write )  \ GPIO alternate function high  register
: GPIOG_MODER. cr ." GPIOG_MODER.  RW   $" GPIOG_MODER @ hex. GPIOG_MODER 1b. ;
: GPIOG_OTYPER. cr ." GPIOG_OTYPER.  RW   $" GPIOG_OTYPER @ hex. GPIOG_OTYPER 1b. ;
: GPIOG_OSPEEDR. cr ." GPIOG_OSPEEDR.  RW   $" GPIOG_OSPEEDR @ hex. GPIOG_OSPEEDR 1b. ;
: GPIOG_PUPDR. cr ." GPIOG_PUPDR.  RW   $" GPIOG_PUPDR @ hex. GPIOG_PUPDR 1b. ;
: GPIOG_IDR. cr ." GPIOG_IDR.  RO   $" GPIOG_IDR @ hex. GPIOG_IDR 1b. ;
: GPIOG_ODR. cr ." GPIOG_ODR.  RW   $" GPIOG_ODR @ hex. GPIOG_ODR 1b. ;
: GPIOG_BSRR. cr ." GPIOG_BSRR " WRITEONLY ; 
: GPIOG_LCKR. cr ." GPIOG_LCKR.  RW   $" GPIOG_LCKR @ hex. GPIOG_LCKR 1b. ;
: GPIOG_AFRL. cr ." GPIOG_AFRL.  RW   $" GPIOG_AFRL @ hex. GPIOG_AFRL 1b. ;
: GPIOG_AFRH. cr ." GPIOG_AFRH.  RW   $" GPIOG_AFRH @ hex. GPIOG_AFRH 1b. ;
: GPIOG.
GPIOG_MODER.
GPIOG_OTYPER.
GPIOG_OSPEEDR.
GPIOG_PUPDR.
GPIOG_IDR.
GPIOG_ODR.
GPIOG_BSRR.
GPIOG_LCKR.
GPIOG_AFRL.
GPIOG_AFRH.
;

$58021C00 constant GPIOH ( GPIO ) 
GPIOH $0 + constant GPIOH_MODER ( read-write )  \ GPIO port mode register
GPIOH $4 + constant GPIOH_OTYPER ( read-write )  \ GPIO port output type register
GPIOH $8 + constant GPIOH_OSPEEDR ( read-write )  \ GPIO port output speed  register
GPIOH $C + constant GPIOH_PUPDR ( read-write )  \ GPIO port pull-up/pull-down  register
GPIOH $10 + constant GPIOH_IDR ( read-only )  \ GPIO port input data register
GPIOH $14 + constant GPIOH_ODR ( read-write )  \ GPIO port output data register
GPIOH $18 + constant GPIOH_BSRR ( write-only )  \ GPIO port bit set/reset  register
GPIOH $1C + constant GPIOH_LCKR ( read-write )  \ This register is used to lock the  configuration of the port bits when a correct write  sequence is applied to bit 16 LCKK. The value of bits  [15:0] is used to lock the configuration of the GPIO.  During the write sequence, the value of LCKR[15:0] must  not change. When the LOCK sequence has been applied on a  port bit, the value of this port bit can no longer be  modified until the next MCU reset or peripheral reset.A  specific write sequence is used to write to the  GPIOx_LCKR register. Only word access 32-bit long is  allowed during this locking sequence.Each lock bit  freezes a specific configuration register control and  alternate function registers.
GPIOH $20 + constant GPIOH_AFRL ( read-write )  \ GPIO alternate function low  register
GPIOH $24 + constant GPIOH_AFRH ( read-write )  \ GPIO alternate function high  register
: GPIOH_MODER. cr ." GPIOH_MODER.  RW   $" GPIOH_MODER @ hex. GPIOH_MODER 1b. ;
: GPIOH_OTYPER. cr ." GPIOH_OTYPER.  RW   $" GPIOH_OTYPER @ hex. GPIOH_OTYPER 1b. ;
: GPIOH_OSPEEDR. cr ." GPIOH_OSPEEDR.  RW   $" GPIOH_OSPEEDR @ hex. GPIOH_OSPEEDR 1b. ;
: GPIOH_PUPDR. cr ." GPIOH_PUPDR.  RW   $" GPIOH_PUPDR @ hex. GPIOH_PUPDR 1b. ;
: GPIOH_IDR. cr ." GPIOH_IDR.  RO   $" GPIOH_IDR @ hex. GPIOH_IDR 1b. ;
: GPIOH_ODR. cr ." GPIOH_ODR.  RW   $" GPIOH_ODR @ hex. GPIOH_ODR 1b. ;
: GPIOH_BSRR. cr ." GPIOH_BSRR " WRITEONLY ; 
: GPIOH_LCKR. cr ." GPIOH_LCKR.  RW   $" GPIOH_LCKR @ hex. GPIOH_LCKR 1b. ;
: GPIOH_AFRL. cr ." GPIOH_AFRL.  RW   $" GPIOH_AFRL @ hex. GPIOH_AFRL 1b. ;
: GPIOH_AFRH. cr ." GPIOH_AFRH.  RW   $" GPIOH_AFRH @ hex. GPIOH_AFRH 1b. ;
: GPIOH.
GPIOH_MODER.
GPIOH_OTYPER.
GPIOH_OSPEEDR.
GPIOH_PUPDR.
GPIOH_IDR.
GPIOH_ODR.
GPIOH_BSRR.
GPIOH_LCKR.
GPIOH_AFRL.
GPIOH_AFRH.
;

$58022000 constant GPIOI ( GPIO ) 
GPIOI $0 + constant GPIOI_MODER ( read-write )  \ GPIO port mode register
GPIOI $4 + constant GPIOI_OTYPER ( read-write )  \ GPIO port output type register
GPIOI $8 + constant GPIOI_OSPEEDR ( read-write )  \ GPIO port output speed  register
GPIOI $C + constant GPIOI_PUPDR ( read-write )  \ GPIO port pull-up/pull-down  register
GPIOI $10 + constant GPIOI_IDR ( read-only )  \ GPIO port input data register
GPIOI $14 + constant GPIOI_ODR ( read-write )  \ GPIO port output data register
GPIOI $18 + constant GPIOI_BSRR ( write-only )  \ GPIO port bit set/reset  register
GPIOI $1C + constant GPIOI_LCKR ( read-write )  \ This register is used to lock the  configuration of the port bits when a correct write  sequence is applied to bit 16 LCKK. The value of bits  [15:0] is used to lock the configuration of the GPIO.  During the write sequence, the value of LCKR[15:0] must  not change. When the LOCK sequence has been applied on a  port bit, the value of this port bit can no longer be  modified until the next MCU reset or peripheral reset.A  specific write sequence is used to write to the  GPIOx_LCKR register. Only word access 32-bit long is  allowed during this locking sequence.Each lock bit  freezes a specific configuration register control and  alternate function registers.
GPIOI $20 + constant GPIOI_AFRL ( read-write )  \ GPIO alternate function low  register
GPIOI $24 + constant GPIOI_AFRH ( read-write )  \ GPIO alternate function high  register
: GPIOI_MODER. cr ." GPIOI_MODER.  RW   $" GPIOI_MODER @ hex. GPIOI_MODER 1b. ;
: GPIOI_OTYPER. cr ." GPIOI_OTYPER.  RW   $" GPIOI_OTYPER @ hex. GPIOI_OTYPER 1b. ;
: GPIOI_OSPEEDR. cr ." GPIOI_OSPEEDR.  RW   $" GPIOI_OSPEEDR @ hex. GPIOI_OSPEEDR 1b. ;
: GPIOI_PUPDR. cr ." GPIOI_PUPDR.  RW   $" GPIOI_PUPDR @ hex. GPIOI_PUPDR 1b. ;
: GPIOI_IDR. cr ." GPIOI_IDR.  RO   $" GPIOI_IDR @ hex. GPIOI_IDR 1b. ;
: GPIOI_ODR. cr ." GPIOI_ODR.  RW   $" GPIOI_ODR @ hex. GPIOI_ODR 1b. ;
: GPIOI_BSRR. cr ." GPIOI_BSRR " WRITEONLY ; 
: GPIOI_LCKR. cr ." GPIOI_LCKR.  RW   $" GPIOI_LCKR @ hex. GPIOI_LCKR 1b. ;
: GPIOI_AFRL. cr ." GPIOI_AFRL.  RW   $" GPIOI_AFRL @ hex. GPIOI_AFRL 1b. ;
: GPIOI_AFRH. cr ." GPIOI_AFRH.  RW   $" GPIOI_AFRH @ hex. GPIOI_AFRH 1b. ;
: GPIOI.
GPIOI_MODER.
GPIOI_OTYPER.
GPIOI_OSPEEDR.
GPIOI_PUPDR.
GPIOI_IDR.
GPIOI_ODR.
GPIOI_BSRR.
GPIOI_LCKR.
GPIOI_AFRL.
GPIOI_AFRH.
;

$58022400 constant GPIOJ ( GPIO ) 
GPIOJ $0 + constant GPIOJ_MODER ( read-write )  \ GPIO port mode register
GPIOJ $4 + constant GPIOJ_OTYPER ( read-write )  \ GPIO port output type register
GPIOJ $8 + constant GPIOJ_OSPEEDR ( read-write )  \ GPIO port output speed  register
GPIOJ $C + constant GPIOJ_PUPDR ( read-write )  \ GPIO port pull-up/pull-down  register
GPIOJ $10 + constant GPIOJ_IDR ( read-only )  \ GPIO port input data register
GPIOJ $14 + constant GPIOJ_ODR ( read-write )  \ GPIO port output data register
GPIOJ $18 + constant GPIOJ_BSRR ( write-only )  \ GPIO port bit set/reset  register
GPIOJ $1C + constant GPIOJ_LCKR ( read-write )  \ This register is used to lock the  configuration of the port bits when a correct write  sequence is applied to bit 16 LCKK. The value of bits  [15:0] is used to lock the configuration of the GPIO.  During the write sequence, the value of LCKR[15:0] must  not change. When the LOCK sequence has been applied on a  port bit, the value of this port bit can no longer be  modified until the next MCU reset or peripheral reset.A  specific write sequence is used to write to the  GPIOx_LCKR register. Only word access 32-bit long is  allowed during this locking sequence.Each lock bit  freezes a specific configuration register control and  alternate function registers.
GPIOJ $20 + constant GPIOJ_AFRL ( read-write )  \ GPIO alternate function low  register
GPIOJ $24 + constant GPIOJ_AFRH ( read-write )  \ GPIO alternate function high  register
: GPIOJ_MODER. cr ." GPIOJ_MODER.  RW   $" GPIOJ_MODER @ hex. GPIOJ_MODER 1b. ;
: GPIOJ_OTYPER. cr ." GPIOJ_OTYPER.  RW   $" GPIOJ_OTYPER @ hex. GPIOJ_OTYPER 1b. ;
: GPIOJ_OSPEEDR. cr ." GPIOJ_OSPEEDR.  RW   $" GPIOJ_OSPEEDR @ hex. GPIOJ_OSPEEDR 1b. ;
: GPIOJ_PUPDR. cr ." GPIOJ_PUPDR.  RW   $" GPIOJ_PUPDR @ hex. GPIOJ_PUPDR 1b. ;
: GPIOJ_IDR. cr ." GPIOJ_IDR.  RO   $" GPIOJ_IDR @ hex. GPIOJ_IDR 1b. ;
: GPIOJ_ODR. cr ." GPIOJ_ODR.  RW   $" GPIOJ_ODR @ hex. GPIOJ_ODR 1b. ;
: GPIOJ_BSRR. cr ." GPIOJ_BSRR " WRITEONLY ; 
: GPIOJ_LCKR. cr ." GPIOJ_LCKR.  RW   $" GPIOJ_LCKR @ hex. GPIOJ_LCKR 1b. ;
: GPIOJ_AFRL. cr ." GPIOJ_AFRL.  RW   $" GPIOJ_AFRL @ hex. GPIOJ_AFRL 1b. ;
: GPIOJ_AFRH. cr ." GPIOJ_AFRH.  RW   $" GPIOJ_AFRH @ hex. GPIOJ_AFRH 1b. ;
: GPIOJ.
GPIOJ_MODER.
GPIOJ_OTYPER.
GPIOJ_OSPEEDR.
GPIOJ_PUPDR.
GPIOJ_IDR.
GPIOJ_ODR.
GPIOJ_BSRR.
GPIOJ_LCKR.
GPIOJ_AFRL.
GPIOJ_AFRH.
;

$58022800 constant GPIOK ( GPIO ) 
GPIOK $0 + constant GPIOK_MODER ( read-write )  \ GPIO port mode register
GPIOK $4 + constant GPIOK_OTYPER ( read-write )  \ GPIO port output type register
GPIOK $8 + constant GPIOK_OSPEEDR ( read-write )  \ GPIO port output speed  register
GPIOK $C + constant GPIOK_PUPDR ( read-write )  \ GPIO port pull-up/pull-down  register
GPIOK $10 + constant GPIOK_IDR ( read-only )  \ GPIO port input data register
GPIOK $14 + constant GPIOK_ODR ( read-write )  \ GPIO port output data register
GPIOK $18 + constant GPIOK_BSRR ( write-only )  \ GPIO port bit set/reset  register
GPIOK $1C + constant GPIOK_LCKR ( read-write )  \ This register is used to lock the  configuration of the port bits when a correct write  sequence is applied to bit 16 LCKK. The value of bits  [15:0] is used to lock the configuration of the GPIO.  During the write sequence, the value of LCKR[15:0] must  not change. When the LOCK sequence has been applied on a  port bit, the value of this port bit can no longer be  modified until the next MCU reset or peripheral reset.A  specific write sequence is used to write to the  GPIOx_LCKR register. Only word access 32-bit long is  allowed during this locking sequence.Each lock bit  freezes a specific configuration register control and  alternate function registers.
GPIOK $20 + constant GPIOK_AFRL ( read-write )  \ GPIO alternate function low  register
GPIOK $24 + constant GPIOK_AFRH ( read-write )  \ GPIO alternate function high  register
: GPIOK_MODER. cr ." GPIOK_MODER.  RW   $" GPIOK_MODER @ hex. GPIOK_MODER 1b. ;
: GPIOK_OTYPER. cr ." GPIOK_OTYPER.  RW   $" GPIOK_OTYPER @ hex. GPIOK_OTYPER 1b. ;
: GPIOK_OSPEEDR. cr ." GPIOK_OSPEEDR.  RW   $" GPIOK_OSPEEDR @ hex. GPIOK_OSPEEDR 1b. ;
: GPIOK_PUPDR. cr ." GPIOK_PUPDR.  RW   $" GPIOK_PUPDR @ hex. GPIOK_PUPDR 1b. ;
: GPIOK_IDR. cr ." GPIOK_IDR.  RO   $" GPIOK_IDR @ hex. GPIOK_IDR 1b. ;
: GPIOK_ODR. cr ." GPIOK_ODR.  RW   $" GPIOK_ODR @ hex. GPIOK_ODR 1b. ;
: GPIOK_BSRR. cr ." GPIOK_BSRR " WRITEONLY ; 
: GPIOK_LCKR. cr ." GPIOK_LCKR.  RW   $" GPIOK_LCKR @ hex. GPIOK_LCKR 1b. ;
: GPIOK_AFRL. cr ." GPIOK_AFRL.  RW   $" GPIOK_AFRL @ hex. GPIOK_AFRL 1b. ;
: GPIOK_AFRH. cr ." GPIOK_AFRH.  RW   $" GPIOK_AFRH @ hex. GPIOK_AFRH 1b. ;
: GPIOK.
GPIOK_MODER.
GPIOK_OTYPER.
GPIOK_OSPEEDR.
GPIOK_PUPDR.
GPIOK_IDR.
GPIOK_ODR.
GPIOK_BSRR.
GPIOK_LCKR.
GPIOK_AFRL.
GPIOK_AFRH.
;

\ Partial ARM Cortex M3/M4 Disassembler, Copyright (C) 2013  Matthias Koch
\ This is free software under GNU General Public License v3.
\ Knows all M0 and some M3/M4 machine instructions, 
\ resolves call entry points, literal pools and handles inline strings.
\ Usage: Specify your target address in disasm-$ and give disasm-step some calls.

\ ------------------------
\  A quick list of words 
\ ------------------------

: list ( -- )
  cr
  dictionarystart 
  begin
    dup 6 + ctype space
    dictionarynext
  until
  drop
;

\ ---------------------------------------
\  Memory pointer and instruction fetch
\ ---------------------------------------

0 variable disasm-$   \ Current position for disassembling

: disasm-fetch        \ ( -- Data ) Fetches opcodes and operands, increments disasm-$
    disasm-$ @ h@     \             Holt Opcode oder Operand, incrementiert disasm-$
  2 disasm-$ +!   ;

\ --------------------------------------------------
\  Try to find address as code start in Dictionary 
\ --------------------------------------------------

: disasm-string ( -- ) \ Takes care of an inline string
  disasm-$ @ dup ctype skipstring disasm-$ !
;

: name. ( Address -- ) \ If the address is Code-Start of a dictionary word, it gets named.
  1 bic \ Thumb has LSB of address set.

  >r
  dictionarystart
  begin
    dup   6 + dup skipstring r@ = if ."   --> " ctype else drop then
    dictionarynext
  until
  drop
  r> 

  case \ Check for inline strings ! They are introduced by calls to ." or s" internals.
    ['] ." $1E + of ."   -->  .' " disasm-string ." '" endof \ It is ." runtime ?
    ['] s"  $4 + of ."   -->  s' " disasm-string ." '" endof \ It is .s runtime ?
    ['] c"  $4 + of ."   -->  c' " disasm-string ." '" endof \ It is .c runtime ?
  endcase
;

\ -------------------
\  Beautiful output
\ -------------------

: u.4  0 <# # # # # #> type ;
: u.8  0 <# # # # # # # # # #> type ;
: u.ns 0 <# #s #> type ;
: const. ."  #" u.ns ;
: addr. u.8 ;

: register. ( u -- )
  case 
    13 of ."  sp" endof
    14 of ."  lr" endof
    15 of ."  pc" endof
    dup ."  r" decimal u.ns hex 
  endcase ;

\ ----------------------------------------
\  Disassembler logic and opcode cutters
\ ----------------------------------------

: opcode? ( Opcode Bits Mask -- Opcode ? ) \ (Opcode and Mask) = Bits
  rot ( Bits Mask Opcode )
  tuck ( Bits Opcode Mask Opcode )
  and ( Bits Opcode Opcode* )
  rot ( Opcode Opcode* Bits )
  =
;

: reg.    ( Opcode Position -- Opcode ) over swap rshift  $7 and register. ;
: reg16.  ( Opcode Position -- Opcode ) over swap rshift  $F and register. ;
: reg16split. ( Opcode -- Opcode ) dup $0007 and over 4 rshift $0008 and or register. ;
: registerlist. ( Opcode -- Opcode ) 8 0 do dup 1 i lshift and if i register. space then loop ;

: imm3. ( Opcode Position -- Opcode ) over swap rshift  $7  and const. ;
: imm5. ( Opcode Position -- Opcode ) over swap rshift  $1F and const. ;
: imm8. ( Opcode Position -- Opcode ) over swap rshift  $FF and const. ;

: imm3<<1. ( Opcode Position -- Opcode ) over swap rshift  $7  and shl const. ;
: imm5<<1. ( Opcode Position -- Opcode ) over swap rshift  $1F and shl const. ;
: imm8<<1. ( Opcode Position -- Opcode ) over swap rshift  $FF and shl const. ;

: imm3<<2. ( Opcode Position -- Opcode ) over swap rshift  $7  and shl shl const. ;
: imm5<<2. ( Opcode Position -- Opcode ) over swap rshift  $1F and shl shl const. ;
: imm7<<2. ( Opcode Position -- Opcode ) over swap rshift  $7F and shl shl const. ;
: imm8<<2. ( Opcode Position -- Opcode ) over swap rshift  $FF and shl shl const. ;

: condition. ( Condition -- )
  case
    $0 of ." eq" endof  \ Z set
    $1 of ." ne" endof  \ Z clear
    $2 of ." cs" endof  \ C set
    $3 of ." cc" endof  \ C clear
                       
    $4 of ." mi" endof  \ N set
    $5 of ." pl" endof  \ N clear
    $6 of ." vs" endof  \ V set
    $7 of ." vc" endof  \ V clear
                       
    $8 of ." hi" endof  \ C set Z clear
    $9 of ." ls" endof  \ C clear or Z set
    $A of ." ge" endof  \ N == V
    $B of ." lt" endof  \ N != V
                       
    $C of ." gt" endof  \ Z==0 and N == V
    $D of ." le" endof  \ Z==1 or N != V
  endcase
;

: rotateleft  ( x u -- x ) 0 ?do rol loop ;
: rotateright ( x u -- x ) 0 ?do ror loop ;

: imm12. ( Opcode -- Opcode )
  dup $FF and                 \ Bits 0-7
  over  4 rshift $700 and or  \ Bits 8-10
  over 15 rshift $800 and or  \ Bit  11
  ( Opcode imm12 )
  dup 8 rshift
  case
    0 of $FF and                                  const. endof \ Plain 8 Bit Constant
    1 of $FF and                 dup 16 lshift or const. endof \ 0x00XY00XY
    2 of $FF and        8 lshift dup 16 lshift or const. endof \ 0xXY00XY00
    3 of $FF and dup 8 lshift or dup 16 lshift or const. endof \ 0xXYXYXYXY

    \ Shifted 8-Bit Constant
    swap
      \ Otherwise, the 32-bit constant is rotated left until the most significant bit is bit[7]. The size of the left
      \ rotation is encoded in bits[11:7], overwriting bit[7]. imm12 is bits[11:0] of the result.
      dup 7 rshift swap $7F and $80 or swap rotateright const.
  endcase
;

\ --------------------------------------
\  Name resolving for blx r0 sequences
\ --------------------------------------

0 variable destination-r0

\ ----------------------------------
\  Single instruction disassembler
\ ----------------------------------

: disasm-thumb-2 ( Opcode16 -- Opcode16 )
  dup 16 lshift disasm-fetch or ( Opcode16 Opcode32 )

  $F000D000 $F800D000 opcode? if  \ BL
                                ( Opcode )
                                ." bl  "
                                dup $7FF and ( Opcode DestinationL )
                                over ( Opcode DestinationL Opcode )
                                16 rshift $7FF and ( Opcode DestinationL DestinationH )
                                dup $400 and if $FFFFF800 or then ( Opcode DestinationL DestinationHsigned )
                                11 lshift or ( Opcode Destination )
                                shl 
                                disasm-$ @ +
                                dup addr. name. \ Try to resolve destination
                              then

  \ MOVW / MOVT
  \ 1111 0x10 t100 xxxx 0xxx dddd xxxx xxxx
  \ F    2    4    0    0    0    0    0
  \ F    B    7    0    8    0    0    0

  $F2400000 $FB708000 opcode? if \ MOVW / MOVT
                                ( Opcode )
                                dup $00800000 and if ." movt"
                                                  else ." movw"
                                                  then

                                8 reg16. \ Destination register

                                \ Extract 16 Bit constant from opcode:
                                dup        $FF and              ( Opcode Constant* )
                                over     $7000 and  4 rshift or ( Opcode Constant** )
                                over $04000000 and 15 rshift or ( Opcode Constant*** )
                                over $000F0000 and  4 rshift or ( Opcode Constant )
                                dup ."  #" u.4
                                ( Opcode Constant )
                                over $00800000 and if 16 lshift destination-r0 @ or destination-r0 !
                                                   else                             destination-r0 !
                                                   then
                              then

  \ 
  \ 1111 0i0x xxxs nnnn 0iii dddd iiii iiii
  \ F    0    0    0    0    0    0    0
  \ F    A    0    0    8    0    0    0

  $F0000000 $FA008000 opcode? not if else \ Data processing, modified 12-bit immediate
                                dup 21 rshift $F and
                                case
                                  %0000 of ." and" endof
                                  %0001 of ." bic" endof
                                  %0010 of ." orr" endof
                                  %0011 of ." orn" endof
                                  %0100 of ." eor" endof
                                  %1000 of ." add" endof
                                  %1010 of ." adc" endof
                                  %1011 of ." sbc" endof
                                  %1101 of ." sub" endof
                                  %1110 of ." rsb" endof
                                  ." ?"
                                endcase
                                dup 1 20 lshift and if ." s" then \ Set Flags ?
                                8 reg16. 16 reg16. \ Destionation and Source registers
                                imm12.
                              then

  case \ Decode remaining "singular" opcodes used in Mecrisp-Stellaris:

    $EA5F0676 of ." rors r6 r6 #1" endof

    $F8470D04 of ." str r0 [ r7 #-4 ]!" endof
    $F8471D04 of ." str r1 [ r7 #-4 ]!" endof
    $F8472D04 of ." str r2 [ r7 #-4 ]!" endof
    $F8473D04 of ." str r3 [ r7 #-4 ]!" endof
    $F8476D04 of ." str r6 [ r7 #-4 ]!" endof

    $F8576026 of ." ldr r6 [ r7 r6 lsl #2 ]" endof
    $F85D6C08 of ." ldr r6 [ sp #-8 ]" endof

    $FAB6F686 of ." clz r6 r6" endof

    $FB90F6F6 of ." sdiv r6 r0 r6" endof
    $FBB0F6F6 of ." udiv r6 r0 r6" endof
    $FBA00606 of ." umull r0 r6 r0 r6" endof
    $FBA00806 of ." smull r0 r6 r0 r6" endof

  endcase \ Case drops Opcode32
  ( Opcode16 )
;

: disasm ( -- ) \ Disassembles one machine instruction and advances disasm-$

disasm-fetch \ Instruction opcode on stack the whole time.

$4140 $FFC0 opcode? if ." adcs"  0 reg. 3 reg. then          \ ADC
$1C00 $FE00 opcode? if ." adds" 0 reg. 3 reg. 6 imm3. then   \ ADD(1) small immediate two registers
$3000 $F800 opcode? if ." adds" 8 reg. 0 imm8. then          \ ADD(2) big immediate one register
$1800 $FE00 opcode? if ." adds" 0 reg. 3 reg. 6 reg. then    \ ADD(3) three registers
$4400 $FF00 opcode? if ." add"  reg16split. 3 reg16. then    \ ADD(4) two registers one or both high no flags
$A000 $F800 opcode? if ." add"  8 reg. ."  pc " 0 imm8<<2. then  \ ADD(5) rd = pc plus immediate
$A800 $F800 opcode? if ." add"  8 reg. ."  sp " 0 imm8<<2. then  \ ADD(6) rd = sp plus immediate
$B000 $FF80 opcode? if ." add sp" 0 imm7<<2. then            \ ADD(7) sp plus immediate

$4000 $FFC0 opcode? if ." ands" 0 reg. 3 reg. then           \ AND
$1000 $F800 opcode? if ." asrs" 0 reg. 3 reg. 6 imm5. then   \ ASR(1) two register immediate
$4100 $FFC0 opcode? if ." asrs" 0 reg. 3 reg. then           \ ASR(2) two register
$D000 $F000 opcode? not if else dup $0F00 and 8 rshift       \ B(1) conditional branch
                       case
                         $00 of ." beq" endof  \ Z set
                         $01 of ." bne" endof  \ Z clear
                         $02 of ." bcs" endof  \ C set
                         $03 of ." bcc" endof  \ C clear
                       
                         $04 of ." bmi" endof  \ N set
                         $05 of ." bpl" endof  \ N clear
                         $06 of ." bvs" endof  \ V set
                         $07 of ." bvc" endof  \ V clear
                       
                         $08 of ." bhi" endof  \ C set Z clear
                         $09 of ." bls" endof  \ C clear or Z set
                         $0A of ." bge" endof  \ N == V
                         $0B of ." blt" endof  \ N != V
                       
                         $0C of ." bgt" endof  \ Z==0 and N == V
                         $0D of ." ble" endof  \ Z==1 or N != V
                         \ $0E: Undefined Instruction
                         \ $0F: SWI                       
                       endcase
                       space
                       dup $FF and dup $80 and if $FFFFFF00 or then
                       shl disasm-$ @ 1 bic + 2 + addr. 
                    then

$E000 $F800 opcode? if ." b"                                 \ B(2) unconditional branch
                      dup $7FF and shl
                      dup $800 and if $FFFFF000 or then
                      disasm-$ @ + 2+                     
                      space addr.
                    then

$4380 $FFC0 opcode? if ." bics" 0 reg. 3 reg. then           \ BIC
$BE00 $FF00 opcode? if ." bkpt" 0 imm8. then                 \ BKPT

\ BL/BLX handled as Thumb-2 instruction on M3/M4.

$4780 $FF87 opcode? if ." blx"  3 reg16. then                \ BLX(2)
$4700 $FF87 opcode? if ." bx"   3 reg16. then                \ BX
$42C0 $FFC0 opcode? if ." cmns" 0 reg. 3 reg. then           \ CMN
$2800 $F800 opcode? if ." cmp"  8 reg. 0 imm8. then          \ CMP(1) compare immediate
$4280 $FFC0 opcode? if ." cmp"  0 reg. 3 reg. then           \ CMP(2) compare register
$4500 $FF00 opcode? if ." cmp"  reg16split. 3 reg16. then    \ CMP(3) compare high register
$B660 $FFE8 opcode? if ." cps"  0 imm5. then                 \ CPS
$4040 $FFC0 opcode? if ." eors" 0 reg. 3 reg. then           \ EOR

$C800 $F800 opcode? if ." ldmia" 8 reg. ."  {" registerlist. ." }" then     \ LDMIA

$6800 $F800 opcode? if ." ldr" 0 reg. ."  [" 3 reg. 6 imm5<<2. ."  ]" then  \ LDR(1) two register immediate
$5800 $FE00 opcode? if ." ldr" 0 reg. ."  [" 3 reg. 6 reg. ."  ]" then      \ LDR(2) three register
$4800 $F800 opcode? if ." ldr" 8 reg. ."  [ pc" 0 imm8<<2. ."  ]  Literal " \ LDR(3) literal pool
                       dup $FF and shl shl ( Opcode Offset ) \ Offset for PC
                       disasm-$ @ 2+ 3 bic + ( Opcode Address )
                       dup addr. ." : " @ addr. then

$9800 $F800 opcode? if ." ldr"  8 reg. ."  [ sp" 0 imm8<<2. ."  ]" then     \ LDR(4)

$7800 $F800 opcode? if ." ldrb" 0 reg. ."  [" 3 reg. 6 imm5. ."  ]" then    \ LDRB(1) two register immediate
$5C00 $FE00 opcode? if ." ldrb" 0 reg. ."  [" 3 reg. 6 reg.  ."  ]" then    \ LDRB(2) three register

$8800 $F800 opcode? if ." ldrh" 0 reg. ."  [" 3 reg. 6 imm5<<1. ."  ]" then \ LDRH(1) two register immediate
$5A00 $FE00 opcode? if ." ldrh" 0 reg. ."  [" 3 reg. 6 reg.  ."  ]" then    \ LDRH(2) three register

$5600 $FE00 opcode? if ." ldrsb" 0 reg. ."  [" 3 reg. 6 reg. ."  ]" then    \ LDRSB
$5E00 $FE00 opcode? if ." ldrsh" 0 reg. ."  [" 3 reg. 6 reg. ."  ]" then    \ LDRSH

$0000 $F800 opcode? if ." lsls" 0 reg. 3 reg. 6 imm5. then   \ LSL(1)
$4080 $FFC0 opcode? if ." lsls" 0 reg. 3 reg. then           \ LSL(2) two register
$0800 $F800 opcode? if ." lsrs" 0 reg. 3 reg. 6 imm5. then   \ LSR(1) two register immediate
$40C0 $FFC0 opcode? if ." lsrs" 0 reg. 3 reg. then           \ LSR(2) two register
$2000 $F800 opcode? if ." movs" 8 reg. 0 imm8. then          \ MOV(1) immediate
$4600 $FF00 opcode? if ." mov" reg16split. 3 reg16. then     \ MOV(3)

$4340 $FFC0 opcode? if ." muls" 0 reg. 3 reg. then           \ MUL
$43C0 $FFC0 opcode? if ." mvns" 0 reg. 3 reg. then           \ MVN
$4240 $FFC0 opcode? if ." negs" 0 reg. 3 reg. then           \ NEG
$4300 $FFC0 opcode? if ." orrs" 0 reg. 3 reg. then           \ ORR

$BC00 $FE00 opcode? if ." pop {"  registerlist. dup $0100 and if ."  pc " then ." }" then \ POP
$B400 $FE00 opcode? if ." push {" registerlist. dup $0100 and if ."  lr " then ." }" then \ PUSH

$BA00 $FFC0 opcode? if ." rev"   0 reg. 3 reg. then         \ REV
$BA40 $FFC0 opcode? if ." rev16" 0 reg. 3 reg. then         \ REV16
$BAC0 $FFC0 opcode? if ." revsh" 0 reg. 3 reg. then         \ REVSH
$41C0 $FFC0 opcode? if ." rors"  0 reg. 3 reg. then         \ ROR
$4180 $FFC0 opcode? if ." sbcs"  0 reg. 3 reg. then         \ SBC
$B650 $FFF7 opcode? if ." setend" then                      \ SETEND

$C000 $F800 opcode? if ." stmia" 8 reg. ."  {" registerlist. ." }" then     \ STMIA

$6000 $F800 opcode? if ." str" 0 reg. ."  [" 3 reg. 6 imm5<<2. ."  ]" then  \ STR(1) two register immediate
$5000 $FE00 opcode? if ." str" 0 reg. ."  [" 3 reg. 6 reg. ."  ]" then      \ STR(2) three register
$9000 $F800 opcode? if ." str" 8 reg. ."  [ sp + " 0 imm8<<2. ."  ]" then   \ STR(3)

$7000 $F800 opcode? if ." strb" 0 reg. ."  [" 3 reg. 6 imm5. ."  ]" then    \ STRB(1) two register immediate
$5400 $FE00 opcode? if ." strb" 0 reg. ."  [" 3 reg. 6 reg.  ."  ]" then    \ STRB(2) three register

$8000 $F800 opcode? if ." strh" 0 reg. ."  [" 3 reg. 6 imm5<<1. ."  ]" then \ STRH(1) two register immediate
$5200 $FE00 opcode? if ." strh" 0 reg. ."  [" 3 reg. 6 reg.  ."  ]" then    \ STRH(2) three register

$1E00 $FE00 opcode? if ." subs" 0 reg. 3 reg. 6 imm3. then   \ SUB(1)
$3800 $F800 opcode? if ." subs" 8 reg. 0 imm8. then          \ SUB(2)
$1A00 $FE00 opcode? if ." subs" 0 reg. 3 reg. 6 reg. then    \ SUB(3)
$B080 $FF80 opcode? if ." sub sp" 0 imm7<<2. then            \ SUB(4)

$DF00 $FF00 opcode? if ." swi"  0 imm8. then                 \ SWI
$B240 $FFC0 opcode? if ." sxtb" 0 reg. 3 reg. then           \ SXTB
$B200 $FFC0 opcode? if ." sxth" 0 reg. 3 reg. then           \ SXTH
$4200 $FFC0 opcode? if ." tst"  0 reg. 3 reg. then           \ TST
$B2C0 $FFC0 opcode? if ." uxtb" 0 reg. 3 reg. then           \ UXTB
$B280 $FFC0 opcode? if ." uxth" 0 reg. 3 reg. then           \ UXTH


\ 16 Bit Thumb-2 instruction ?

$BF00 $FF00 opcode? not if else                              \ IT...
                      dup $000F and
                      case
                        $8 of ." it" endof

                        over $10 and if else $8 xor then
                        $C of ." itt" endof
                        $4 of ." ite" endof

                        over $10 and if else $4 xor then
                        $E of ." ittt" endof
                        $6 of ." itet" endof
                        $A of ." itte" endof
                        $2 of ." itee" endof

                        over $10 and if else $2 xor then
                        $F of ." itttt" endof
                        $7 of ." itett" endof
                        $B of ." ittet" endof
                        $3 of ." iteet" endof
                        $D of ." ittte" endof
                        $5 of ." itete" endof
                        $9 of ." ittee" endof
                        $1 of ." iteee" endof
                      endcase
                      space
                      dup $00F0 and 4 rshift condition.
                    then

\ 32 Bit Thumb-2 instruction ?

$E800 $F800 opcode? if disasm-thumb-2 then
$F000 $F000 opcode? if disasm-thumb-2 then


\ If nothing of the above hits: Invalid Instruction... They are not checked for.

\ Try name resolving for blx r0 sequences:

$2000 $FF00 opcode? if dup $FF and destination-r0  ! then \ movs r0, #...
$3000 $FF00 opcode? if dup $FF and destination-r0 +! then \ adds r0, #...
$0000 $F83F opcode? if destination-r0 @                   \ lsls r0, r0, #...
                         over $07C0 and 6 rshift lshift
                       destination-r0 ! then
dup $4780 =         if destination-r0 @ name. then        \ blx r0

drop \ Forget opcode
; \ disasm

\ ------------------------------
\  Single instruction printing
\ ------------------------------

: memstamp \ ( Addr -- ) Shows a memory location nicely
    dup u.8 ." : " h@ u.4 ."   " ;

: disasm-step ( -- )
    disasm-$ @                 \ Note current position
    dup memstamp disasm cr     \ Disassemble one instruction

    begin \ Write out all disassembled memory locations
      2+ dup disasm-$ @ <>
    while
      dup memstamp cr
    repeat
    drop
;

\ ------------------------------
\  Disassembler for definitions
\ ------------------------------

: seec ( -- ) \ Continues to see
  base @ hex cr

  begin
    disasm-$ @ h@           $4770 =  \ Flag: Loop terminates with bx lr
    disasm-$ @ h@ $FF00 and $BD00 =  \ Flag: Loop terminates with pop { ... pc }
    or
    disasm-step
  until

  base !
;

: see ( -- ) \ Takes name of definition and shows its contents from beginning to first ret
  ' disasm-$ !
  seec
;
$40013000 constant SPI1 ( Serial peripheral interface ) 
SPI1 $0 + constant SPI1_CR1 (  )  \ control register 1
SPI1 $4 + constant SPI1_CR2 (  )  \ control register 2
SPI1 $8 + constant SPI1_CFG1 ( read-write )  \ configuration register 1
SPI1 $C + constant SPI1_CFG2 ( read-write )  \ configuration register 2
SPI1 $10 + constant SPI1_IER (  )  \ Interrupt Enable Register
SPI1 $14 + constant SPI1_SR ( read-only )  \ Status Register
SPI1 $18 + constant SPI1_IFCR ( write-only )  \ Interrupt/Status Flags Clear  Register
SPI1 $20 + constant SPI1_TXDR ( write-only )  \ Transmit Data Register
SPI1 $30 + constant SPI1_RXDR ( read-only )  \ Receive Data Register
SPI1 $40 + constant SPI1_CRCPOLY ( read-write )  \ Polynomial Register
SPI1 $44 + constant SPI1_TXCRC ( read-write )  \ Transmitter CRC Register
SPI1 $48 + constant SPI1_RXCRC ( read-write )  \ Receiver CRC Register
SPI1 $4C + constant SPI1_UDRDR ( read-write )  \ Underrun Data Register
SPI1 $50 + constant SPI1_CGFR ( read-write )  \ configuration register
: SPI1_CR1. cr ." SPI1_CR1.   $" SPI1_CR1 @ hex. SPI1_CR1 1b. ;
: SPI1_CR2. cr ." SPI1_CR2.   $" SPI1_CR2 @ hex. SPI1_CR2 1b. ;
: SPI1_CFG1. cr ." SPI1_CFG1.  RW   $" SPI1_CFG1 @ hex. SPI1_CFG1 1b. ;
: SPI1_CFG2. cr ." SPI1_CFG2.  RW   $" SPI1_CFG2 @ hex. SPI1_CFG2 1b. ;
: SPI1_IER. cr ." SPI1_IER.   $" SPI1_IER @ hex. SPI1_IER 1b. ;
: SPI1_SR. cr ." SPI1_SR.  RO   $" SPI1_SR @ hex. SPI1_SR 1b. ;
: SPI1_IFCR. cr ." SPI1_IFCR " WRITEONLY ; 
: SPI1_TXDR. cr ." SPI1_TXDR " WRITEONLY ; 
: SPI1_RXDR. cr ." SPI1_RXDR.  RO   $" SPI1_RXDR @ hex. SPI1_RXDR 1b. ;
: SPI1_CRCPOLY. cr ." SPI1_CRCPOLY.  RW   $" SPI1_CRCPOLY @ hex. SPI1_CRCPOLY 1b. ;
: SPI1_TXCRC. cr ." SPI1_TXCRC.  RW   $" SPI1_TXCRC @ hex. SPI1_TXCRC 1b. ;
: SPI1_RXCRC. cr ." SPI1_RXCRC.  RW   $" SPI1_RXCRC @ hex. SPI1_RXCRC 1b. ;
: SPI1_UDRDR. cr ." SPI1_UDRDR.  RW   $" SPI1_UDRDR @ hex. SPI1_UDRDR 1b. ;
: SPI1_CGFR. cr ." SPI1_CGFR.  RW   $" SPI1_CGFR @ hex. SPI1_CGFR 1b. ;
: SPI1.
SPI1_CR1.
SPI1_CR2.
SPI1_CFG1.
SPI1_CFG2.
SPI1_IER.
SPI1_SR.
SPI1_IFCR.
SPI1_TXDR.
SPI1_RXDR.
SPI1_CRCPOLY.
SPI1_TXCRC.
SPI1_RXCRC.
SPI1_UDRDR.
SPI1_CGFR.
;

$24000000  constant ram-base
512 1024 * constant ram-size
: load ( -- ) 0 ram-base ram-size spi-move ;
: ram-crc ( -- crc ) ram-base ram-size reset-crc >crc crc@ ;
