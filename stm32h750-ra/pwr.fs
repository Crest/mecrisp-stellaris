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
