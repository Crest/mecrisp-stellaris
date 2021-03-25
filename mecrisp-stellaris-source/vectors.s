
@ -----------------------------------------------------------------------------
@ Interruptvektortabelle
@ -----------------------------------------------------------------------------

.word   returnstackanfang  @ Stack top address
.word   Reset+1            @ Reset Vector  +1 wegen des Thumb-Einsprunges

@ ... Interruptvektortabelle noch ziemlich leer ...

.word nullhandler+1   @ The NMI handler
.word nullhandler+1   @ The hard fault handler
.word nullhandler+1   @ The MPU fault handler
.word nullhandler+1   @ The bus fault handler
.word nullhandler+1   @ The usage fault handler
.word 0               @ Reserved
.word 0               @ Reserved
.word 0               @ Reserved
.word 0               @ Reserved
.word nullhandler+1   @ SVCall handler
.word nullhandler+1   @ Debug monitor handler
.word 0               @ Reserved
.word nullhandler+1   @ The PendSV handler

.word irq_vektor_systick+1   @ The SysTick handler

.word nullhandler+1   @ GPIO Port A
.word nullhandler+1   @ GPIO Port B
.word nullhandler+1   @ GPIO Port C
.word nullhandler+1   @ GPIO Port D
.word nullhandler+1   @ GPIO Port E
.word nullhandler+1   @ UART0 Rx and Tx
.word nullhandler+1   @ UART1 Rx and Tx
.word nullhandler+1   @ SSI0 Rx and Tx
.word nullhandler+1   @ I2C0 Master and Slave
.word nullhandler+1   @ PWM Fault
.word nullhandler+1   @ PWM Generator 0
.word nullhandler+1   @ PWM Generator 1
.word nullhandler+1   @ PWM Generator 2
.word nullhandler+1   @ Quadrature Encoder 0
.word nullhandler+1   @ ADC Sequence 0
.word nullhandler+1   @ ADC Sequence 1
.word nullhandler+1   @ ADC Sequence 2
.word nullhandler+1   @ ADC Sequence 3
.word nullhandler+1   @ Watchdog timer
.word nullhandler+1   @ Timer 0 subtimer A
.word nullhandler+1   @ Timer 0 subtimer B
.word nullhandler+1   @ Timer 1 subtimer A
.word nullhandler+1   @ Timer 1 subtimer B
.word nullhandler+1   @ Timer 2 subtimer A
.word nullhandler+1   @ Timer 2 subtimer B
.word nullhandler+1   @ Analog Comparator 0
.word nullhandler+1   @ Analog Comparator 1
.word nullhandler+1   @ Analog Comparator 2
.word nullhandler+1   @ System Control (PLL, OSC, BO)
.word nullhandler+1   @ FLASH Control
.word nullhandler+1   @ GPIO Port F
.word nullhandler+1   @ GPIO Port G
.word nullhandler+1   @ GPIO Port H
.word nullhandler+1   @ UART2 Rx and Tx
.word nullhandler+1   @ SSI1 Rx and Tx
.word nullhandler+1   @ Timer 3 subtimer A
.word nullhandler+1   @ Timer 3 subtimer B
.word nullhandler+1   @ I2C1 Master and Slave
.word nullhandler+1   @ Quadrature Encoder 1
.word nullhandler+1   @ CAN0
.word nullhandler+1   @ CAN1
.word nullhandler+1   @ CAN2
.word nullhandler+1   @ Ethernet
.word nullhandler+1   @ Hibernate
.word nullhandler+1   @ USB0
.word nullhandler+1   @ PWM Generator 3
.word nullhandler+1   @ uDMA Software Transfer
.word nullhandler+1   @ uDMA Error
.word nullhandler+1   @ ADC1 Sequence 0
.word nullhandler+1   @ ADC1 Sequence 1
.word nullhandler+1   @ ADC1 Sequence 2
.word nullhandler+1   @ ADC1 Sequence 3
.word nullhandler+1   @ I2S0
.word nullhandler+1   @ External Bus Interface 0
.word nullhandler+1   @ GPIO Port J
.word nullhandler+1   @ GPIO Port K
.word nullhandler+1   @ GPIO Port L
.word nullhandler+1   @ SSI2 Rx and Tx
.word nullhandler+1   @ SSI3 Rx and Tx
.word nullhandler+1   @ UART3 Rx and Tx
.word nullhandler+1   @ UART4 Rx and Tx
.word nullhandler+1   @ UART5 Rx and Tx
.word nullhandler+1   @ UART6 Rx and Tx
.word nullhandler+1   @ UART7 Rx and Tx
.word 0               @ Reserved
.word 0               @ Reserved
.word 0               @ Reserved
.word 0               @ Reserved
.word nullhandler+1   @ I2C2 Master and Slave
.word nullhandler+1   @ I2C3 Master and Slave
.word nullhandler+1   @ Timer 4 subtimer A
.word nullhandler+1   @ Timer 4 subtimer B
.word 0               @ Reserved
.word 0               @ Reserved
.word 0               @ Reserved
.word 0               @ Reserved
.word 0               @ Reserved
.word 0               @ Reserved
.word 0               @ Reserved
.word 0               @ Reserved
.word 0               @ Reserved
.word 0               @ Reserved
.word 0               @ Reserved
.word 0               @ Reserved
.word 0               @ Reserved
.word 0               @ Reserved
.word 0               @ Reserved
.word 0               @ Reserved
.word 0               @ Reserved
.word 0               @ Reserved
.word 0               @ Reserved
.word 0               @ Reserved
.word nullhandler+1   @ Timer 5 subtimer A
.word nullhandler+1   @ Timer 5 subtimer B
.word nullhandler+1   @ Wide Timer 0 subtimer A
.word nullhandler+1   @ Wide Timer 0 subtimer B
.word nullhandler+1   @ Wide Timer 1 subtimer A
.word nullhandler+1   @ Wide Timer 1 subtimer B
.word nullhandler+1   @ Wide Timer 2 subtimer A
.word nullhandler+1   @ Wide Timer 2 subtimer B
.word nullhandler+1   @ Wide Timer 3 subtimer A
.word nullhandler+1   @ Wide Timer 3 subtimer B
.word nullhandler+1   @ Wide Timer 4 subtimer A
.word nullhandler+1   @ Wide Timer 4 subtimer B
.word nullhandler+1   @ Wide Timer 5 subtimer A
.word nullhandler+1   @ Wide Timer 5 subtimer B
.word nullhandler+1   @ FPU
.word nullhandler+1   @ PECI 0
.word nullhandler+1   @ LPC 0
.word nullhandler+1   @ I2C4 Master and Slave
.word nullhandler+1   @ I2C5 Master and Slave
.word nullhandler+1   @ GPIO Port M
.word nullhandler+1   @ GPIO Port N
.word nullhandler+1   @ Quadrature Encoder 2
.word nullhandler+1   @ Fan 0
.word 0               @ Reserved
.word nullhandler+1   @ GPIO Port P (Summary or P0)
.word nullhandler+1   @ GPIO Port P1
.word nullhandler+1   @ GPIO Port P2
.word nullhandler+1   @ GPIO Port P3
.word nullhandler+1   @ GPIO Port P4
.word nullhandler+1   @ GPIO Port P5
.word nullhandler+1   @ GPIO Port P6
.word nullhandler+1   @ GPIO Port P7
.word nullhandler+1   @ GPIO Port Q (Summary or Q0)
.word nullhandler+1   @ GPIO Port Q1
.word nullhandler+1   @ GPIO Port Q2
.word nullhandler+1   @ GPIO Port Q3
.word nullhandler+1   @ GPIO Port Q4
.word nullhandler+1   @ GPIO Port Q5
.word nullhandler+1   @ GPIO Port Q6
.word nullhandler+1   @ GPIO Port Q7
.word nullhandler+1   @ GPIO Port R
.word nullhandler+1   @ GPIO Port S
.word nullhandler+1   @ PWM 1 Generator 0
.word nullhandler+1   @ PWM 1 Generator 1
.word nullhandler+1   @ PWM 1 Generator 2
.word nullhandler+1   @ PWM 1 Generator 3
.word nullhandler+1   @ PWM 1 Fault

@ -----------------------------------------------------------------------------
nullhandler:   
  writeln "Unhandled Interrupt !"
  bx lr
@ -----------------------------------------------------------------------------
