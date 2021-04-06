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
