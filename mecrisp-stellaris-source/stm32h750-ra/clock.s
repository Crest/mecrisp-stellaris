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

.equ RCC_PLLCKSELR_PLLSRC_Shift, 0
.equ RCC_PLLCKSELR_PLLSRC_Width, 2
.equ RCC_PLLCKSELR_PLLSRC_HSE  , 0b10

.equ RCC_PLLCKSELR_DIVM1_Shift , 4
.equ RCC_PLLCKSELR_DIVM1_Width , 6
.equ RCC_PLLCKSELR_DIVM1_Div4  , 4

@ Write out the dividers and multiplier
.equ RCC_PLL1DIVR_DIVR1_Div2  , ((  2 - 1) << RCC_PLL1DIVR_DIVR1_Shift)
.equ RCC_PLL1DIVR_DIVQ1_Div2  , ((  2 - 1) << RCC_PLL1DIVR_DIVQ1_Shift)
.equ RCC_PLL1DIVR_DIVP1_Div2  , ((  2 - 1) << RCC_PLL1DIVR_DIVP1_Shift)
.equ RCC_PLL1DIVR_DIVN1_Mul400, ((400 - 1) << RCC_PLL1DIVR_DIVN1_Shift)
.equ RCC_PLL1DIVR_Value       , (RCC_PLL1DIVR_DIVR1_Div2 | RCC_PLL1DIVR_DIVQ1_Div2 | RCC_PLL1DIVR_DIVP1_Div2 | RCC_PLL1DIVR_DIVN1_Mul400)

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "pll-400MHz" @ ( -- )
@ -----------------------------------------------------------------------------
pll_400mhz:
    @ This function configures PLL1 in integer mode as described in Figure 48
    @ on page 346 of RM0433 Rev 7:
    @   * Pick the PLL source
    @   * Set the PLL pre-divder
    @   * Configure parameters (input range, output range, dividers, multiplier)
    @   * Enable the PLL
    @   * Wait for its readiness

    @ Keep the RCC_BASE around
    ldr  r0, =RCC_BASE

    @ Select 8MHz the HSE clock as PLL source
    ldr  r1, [r0, #(RCC_PLLCKSELR - RCC_BASE)]
    orr  r1, #RCC_PLLCKSELR_PLLSRC_HSE
    
    @ Divide the HSE by 4 to get ref1_ck = 2MHz
    movs r2, #RCC_PLLCKSELR_DIVM1_Div4
    bfi  r1, r2, #RCC_PLLCKSELR_DIVM1_Shift, #RCC_PLLCKSELR_DIVM1_Width
    str  r1, [r0, #(RCC_PLLCKSELR - RCC_BASE)]

    @ Configure PLL1 for a reference clock between 2MHz and 4MHz
    ldr  r1, [r0, #(RCC_CFGR - RCC_BASE)]
    orr  r1, #(0b01 << RCC_PLLCFGR_PLL1RGE_Shift)
    str  r1, [r0, #(RCC_CFGR - RCC_BASE)]
    
    @ Multiply the 2MHz reference clock by 400 and divide by two
    ldr  r1, =RCC_PLL1DIVR_Value
    str  r1, [r0, #(RCC_PLL1DIVR - RCC_BASE)]
    
    @ Enable PLL1 (PLL1ON = 1)
    ldr  r1, [r0, #(RCC_CR - RCC_BASE)]
    orr  r1, #RCC_CR_PLL1ON
    str  r1, [r0, #(RCC_CR - RCC_BASE)]
    
    @ Wait for PLL1 to become usable (PLL1RDY = 1)
1:  ldr  r1, [r0, #(RCC_CR - RCC_BASE)]
    tst  r1, #RCC_CR_PLL1RDY
    beq  1b

    @ It's important to enable the clock dividers before switching
    @ to the 400MHz PLL clock source.
    @ Run the chip at its maximum clock rates for VOS1:
    @   * CPU: 400MHz
    @   * AHB: 200MHz
    @   * APB: 100MHz
    mov  r1, #(0b0000 << RCC_D1CFGR_D1CPRE_Shift) | (0b100 << RCC_D1CFGR_D1PPRE_Shift) | (0b1000 << RCC_D1CFGR_HPRE_Shift)
    str  r1, [r0, #(RCC_D1CFGR - RCC_BASE)]
    mov  r1, #(0b100 << RCC_D2CFGR_D2PPRE2_Shift) | (0b100 << RCC_D2CFGR_D2PPRE1_Shift)
    str  r1, [r0, #(RCC_D2CFGR - RCC_BASE)]
    mov  r1, #(0b100 << RCC_D3CFGR_D3PPRE_Shift)
    str  r1, [r0, #(RCC_D3CFGR - RCC_BASE)]

    @ Switch system clock from HSI to PLL1
    ldr  r1, [r0, #(RCC_CFGR - RCC_BASE)]
    orr  r1, #(0b11 << RCC_CFGR_SW_Shift)
    str  r1, [r0, #(RCC_CFGR - RCC_BASE)]

    bx   lr
