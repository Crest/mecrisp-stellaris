@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "ldo-on" @ ( -- )
@ -----------------------------------------------------------------------------
ldo_on:
    @ Use the internal low drop regulator
    @ Locks away the V_CAP bypass until the next power cycle
    ldr r0, =PWR_CR3
    ldr r1, [r0]
    orr r1, #PWR_CR3_LDOEN
    bic r1, #(PWR_CR3_SCUEN | PWR_CR3_BYPASS)
    str r1, [r0]

    bx  lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "vos1" @ ( -- )
@ -----------------------------------------------------------------------------
vos1:
    @ Raise the voltage to VOS1 level
    ldr r0, =PWR_D3CR
    ldr r1, [r0]
    orr r1, #(0b11 << PWR_D3CR_VOS_Shift)
    str r1, [r0]
    
    @ Wait for the voltage to reach VOS1 level
1:  ldr r1, [r0]
    tst r1, #PWR_D3CR_VOSRDY
    beq 1b

    bx  lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "hse-on" @ ( -- )
@ -----------------------------------------------------------------------------
hse_on:
    @ Enable the HSE oscillator
    ldr r0, =RCC_CR
    ldr r1, [r0]
    orr r1, #RCC_CR_HSEON
    str r1, [r0]

    @ Wait for the HSE oscillator become usable
1:  ldr r1, [r0]
    tst r1, #RCC_CR_HSERDY
    beq 1b

    bx  lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "pll-400MHz" @ ( -- )
@ -----------------------------------------------------------------------------
pll_400mhz:
    @ Keep the RCC_BASE around
    ldr r0, =RCC_BASE

    @ Select 8MHz HSE as PLL source
    ldr r1, [r0, #(RCC_PLLCKSELR - RCC_BASE)]
    bic r1, #(0b01 << RCC_PLLCKSELR_PLLSRC_Shift)
    orr r1, #(0b10 << RCC_PLLCKSELR_PLLSRC_Shift)
    str r1, [r0, #(RCC_PLLCKSELR - RCC_BASE)]
    
    @ Divide the HSE by 8 to get ref1_ck = 1MHz
    and r1, #((((1 << 6) - 1) & ~8) << RCC_PLLCKSELR_DIVM1_Shift)
    orr r1, #(8 << RCC_PLLCKSELR_DIVM1_Shift)
    str r1, [r0, #(RCC_PLLCKSELR - RCC_BASE)]

    @ PLL1 config (RCC_PLLCFGR)
    @ - DIVR1EN    = 1
    @ - DIVQ1EN    = 1
    @ - DIVP1EN    = 1
    @ - PLL1RGE    = 0b11 (8..16 MHz)
    @ - PLL1VCOSEL = 0 (Wide Range)
    @ - PLL1FRACEN = 0 (Integer)
    ldr r1, [r0, #(RCC_CFGR - RCC_BASE)]
    orr r1, #(RCC_PLLCFGR_DIVR1EN | RCC_PLLCFGR_DIVQ1EN | RCC_PLLCFGR_DIVP1EN)
    orr r1, #(0b11 << RCC_PLLCFGR_PLL1RGE_Shift)
    bic r1, #(RCC_PLLCFGR_PLL1FRACEN | RCC_PLLCFGR_PLL1VCOSEL)
    str r1, [r0, #(RCC_CFGR - RCC_BASE)]
    
    @ Init PLLx dividers (RCC_PLL1DIVR)
    @ - DIVN1 = 339 (vco1_ck   = ref1_ck * (399 + 1) = 400MHz)
    @ - DIVP1 =   0 (pll1_p_ck = vco1_ck/1           = 400MHz)
    @ - DIVQ1 =   1 (pll1_q_ck = vco1_ck/2           = 200MHz)
    @ - DIVR1 =   0 (pll1_r_ck = vco1_ck/1           = 400MHz)
    ldr r1, =((1<<RCC_PLL1DIVR_DIVQ1_Shift)|(339<<RCC_PLL1DIVR_DIVN1_Shift))
    str r1, [r0, #(RCC_PLL1DIVR - RCC_BASE)]
    
    @ Enable PLL1 (RCC_CR)
    @ - PLL1ON = 1
    ldr r1, [r0, #(RCC_CR - RCC_BASE)]
    orr r1, #RCC_CR_PLL1ON
    str r1, [r0, #(RCC_CR - RCC_BASE)]
    
    @ Wait for PLL1 to become usable (PLL1RDY = 1)
1:  ldr r1, [r0, #(RCC_CR - RCC_BASE)]
    tst r1, #RCC_CR_PLL1RDY
    beq 1b

    @ It's important to enable the clock divider before switching
    @ to the 400MHz PLL clock source
    @
    @ D1CPRE = 1 (400MHz = 400MHz/1)
    @ HPRE   = 2 (200MHz = 400MHz/2)
    @ D1PPRE = 1 (200MHz = 200MHz/1)
    @ D2PPRE = 1 (200MHz = 200MHz/1)
    @ D3PPRE = 1 (200MHz = 200MHz/1)
    ldr r1, =(0b1000 << RCC_D1CFGR_HPRE_Shift)
    str r1, [r0, #(RCC_D1CFGR - RCC_BASE)]

    @ Switch system clock from HSI to PLL1
    ldr r1, [r0, #(RCC_CFGR - RCC_BASE)]
    orr r1, #(0b11 << RCC_CFGR_SW_Shift)
    str r1, [r0, #(RCC_CFGR - RCC_BASE)]

    bx  lr
