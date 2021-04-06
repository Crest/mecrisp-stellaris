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
