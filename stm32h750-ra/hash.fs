$48021400 constant HASH ( Hash processor ) 
HASH $0 + constant HASH_CR (  )  \ control register
HASH $4 + constant HASH_DIN ( read-write )  \ data input register
HASH $8 + constant HASH_STR (  )  \ start register
HASH $C + constant HASH_HR0 ( read-only )  \ digest registers
HASH $10 + constant HASH_HR1 ( read-only )  \ digest registers
HASH $14 + constant HASH_HR2 ( read-only )  \ digest registers
HASH $18 + constant HASH_HR3 ( read-only )  \ digest registers
HASH $1C + constant HASH_HR4 ( read-only )  \ digest registers
HASH $20 + constant HASH_IMR ( read-write )  \ interrupt enable register
HASH $24 + constant HASH_SR (  )  \ status register
HASH $F8 + constant HASH_CSR0 ( read-write )  \ context swap registers
HASH $FC + constant HASH_CSR1 ( read-write )  \ context swap registers
HASH $100 + constant HASH_CSR2 ( read-write )  \ context swap registers
HASH $104 + constant HASH_CSR3 ( read-write )  \ context swap registers
HASH $108 + constant HASH_CSR4 ( read-write )  \ context swap registers
HASH $10C + constant HASH_CSR5 ( read-write )  \ context swap registers
HASH $110 + constant HASH_CSR6 ( read-write )  \ context swap registers
HASH $114 + constant HASH_CSR7 ( read-write )  \ context swap registers
HASH $118 + constant HASH_CSR8 ( read-write )  \ context swap registers
HASH $11C + constant HASH_CSR9 ( read-write )  \ context swap registers
HASH $120 + constant HASH_CSR10 ( read-write )  \ context swap registers
HASH $124 + constant HASH_CSR11 ( read-write )  \ context swap registers
HASH $128 + constant HASH_CSR12 ( read-write )  \ context swap registers
HASH $12C + constant HASH_CSR13 ( read-write )  \ context swap registers
HASH $130 + constant HASH_CSR14 ( read-write )  \ context swap registers
HASH $134 + constant HASH_CSR15 ( read-write )  \ context swap registers
HASH $138 + constant HASH_CSR16 ( read-write )  \ context swap registers
HASH $13C + constant HASH_CSR17 ( read-write )  \ context swap registers
HASH $140 + constant HASH_CSR18 ( read-write )  \ context swap registers
HASH $144 + constant HASH_CSR19 ( read-write )  \ context swap registers
HASH $148 + constant HASH_CSR20 ( read-write )  \ context swap registers
HASH $14C + constant HASH_CSR21 ( read-write )  \ context swap registers
HASH $150 + constant HASH_CSR22 ( read-write )  \ context swap registers
HASH $154 + constant HASH_CSR23 ( read-write )  \ context swap registers
HASH $158 + constant HASH_CSR24 ( read-write )  \ context swap registers
HASH $15C + constant HASH_CSR25 ( read-write )  \ context swap registers
HASH $160 + constant HASH_CSR26 ( read-write )  \ context swap registers
HASH $164 + constant HASH_CSR27 ( read-write )  \ context swap registers
HASH $168 + constant HASH_CSR28 ( read-write )  \ context swap registers
HASH $16C + constant HASH_CSR29 ( read-write )  \ context swap registers
HASH $170 + constant HASH_CSR30 ( read-write )  \ context swap registers
HASH $174 + constant HASH_CSR31 ( read-write )  \ context swap registers
HASH $178 + constant HASH_CSR32 ( read-write )  \ context swap registers
HASH $17C + constant HASH_CSR33 ( read-write )  \ context swap registers
HASH $180 + constant HASH_CSR34 ( read-write )  \ context swap registers
HASH $184 + constant HASH_CSR35 ( read-write )  \ context swap registers
HASH $188 + constant HASH_CSR36 ( read-write )  \ context swap registers
HASH $18C + constant HASH_CSR37 ( read-write )  \ context swap registers
HASH $190 + constant HASH_CSR38 ( read-write )  \ context swap registers
HASH $194 + constant HASH_CSR39 ( read-write )  \ context swap registers
HASH $198 + constant HASH_CSR40 ( read-write )  \ context swap registers
HASH $19C + constant HASH_CSR41 ( read-write )  \ context swap registers
HASH $1A0 + constant HASH_CSR42 ( read-write )  \ context swap registers
HASH $1A4 + constant HASH_CSR43 ( read-write )  \ context swap registers
HASH $1A8 + constant HASH_CSR44 ( read-write )  \ context swap registers
HASH $1AC + constant HASH_CSR45 ( read-write )  \ context swap registers
HASH $1B0 + constant HASH_CSR46 ( read-write )  \ context swap registers
HASH $1B4 + constant HASH_CSR47 ( read-write )  \ context swap registers
HASH $1B8 + constant HASH_CSR48 ( read-write )  \ context swap registers
HASH $1BC + constant HASH_CSR49 ( read-write )  \ context swap registers
HASH $1C0 + constant HASH_CSR50 ( read-write )  \ context swap registers
HASH $1C4 + constant HASH_CSR51 ( read-write )  \ context swap registers
HASH $1C8 + constant HASH_CSR52 ( read-write )  \ context swap registers
HASH $1CC + constant HASH_CSR53 ( read-write )  \ context swap registers
HASH $310 + constant HASH_HASH_HR0 ( read-only )  \ HASH digest register
HASH $314 + constant HASH_HASH_HR1 ( read-only )  \ read-only
HASH $318 + constant HASH_HASH_HR2 ( read-only )  \ read-only
HASH $31C + constant HASH_HASH_HR3 ( read-only )  \ read-only
HASH $320 + constant HASH_HASH_HR4 ( read-only )  \ read-only
HASH $324 + constant HASH_HASH_HR5 ( read-only )  \ read-only
HASH $328 + constant HASH_HASH_HR6 ( read-only )  \ read-only
HASH $32C + constant HASH_HASH_HR7 ( read-only )  \ read-only
: HASH_CR. cr ." HASH_CR.   $" HASH_CR @ hex. HASH_CR 1b. ;
: HASH_DIN. cr ." HASH_DIN.  RW   $" HASH_DIN @ hex. HASH_DIN 1b. ;
: HASH_STR. cr ." HASH_STR.   $" HASH_STR @ hex. HASH_STR 1b. ;
: HASH_HR0. cr ." HASH_HR0.  RO   $" HASH_HR0 @ hex. HASH_HR0 1b. ;
: HASH_HR1. cr ." HASH_HR1.  RO   $" HASH_HR1 @ hex. HASH_HR1 1b. ;
: HASH_HR2. cr ." HASH_HR2.  RO   $" HASH_HR2 @ hex. HASH_HR2 1b. ;
: HASH_HR3. cr ." HASH_HR3.  RO   $" HASH_HR3 @ hex. HASH_HR3 1b. ;
: HASH_HR4. cr ." HASH_HR4.  RO   $" HASH_HR4 @ hex. HASH_HR4 1b. ;
: HASH_IMR. cr ." HASH_IMR.  RW   $" HASH_IMR @ hex. HASH_IMR 1b. ;
: HASH_SR. cr ." HASH_SR.   $" HASH_SR @ hex. HASH_SR 1b. ;
: HASH_CSR0. cr ." HASH_CSR0.  RW   $" HASH_CSR0 @ hex. HASH_CSR0 1b. ;
: HASH_CSR1. cr ." HASH_CSR1.  RW   $" HASH_CSR1 @ hex. HASH_CSR1 1b. ;
: HASH_CSR2. cr ." HASH_CSR2.  RW   $" HASH_CSR2 @ hex. HASH_CSR2 1b. ;
: HASH_CSR3. cr ." HASH_CSR3.  RW   $" HASH_CSR3 @ hex. HASH_CSR3 1b. ;
: HASH_CSR4. cr ." HASH_CSR4.  RW   $" HASH_CSR4 @ hex. HASH_CSR4 1b. ;
: HASH_CSR5. cr ." HASH_CSR5.  RW   $" HASH_CSR5 @ hex. HASH_CSR5 1b. ;
: HASH_CSR6. cr ." HASH_CSR6.  RW   $" HASH_CSR6 @ hex. HASH_CSR6 1b. ;
: HASH_CSR7. cr ." HASH_CSR7.  RW   $" HASH_CSR7 @ hex. HASH_CSR7 1b. ;
: HASH_CSR8. cr ." HASH_CSR8.  RW   $" HASH_CSR8 @ hex. HASH_CSR8 1b. ;
: HASH_CSR9. cr ." HASH_CSR9.  RW   $" HASH_CSR9 @ hex. HASH_CSR9 1b. ;
: HASH_CSR10. cr ." HASH_CSR10.  RW   $" HASH_CSR10 @ hex. HASH_CSR10 1b. ;
: HASH_CSR11. cr ." HASH_CSR11.  RW   $" HASH_CSR11 @ hex. HASH_CSR11 1b. ;
: HASH_CSR12. cr ." HASH_CSR12.  RW   $" HASH_CSR12 @ hex. HASH_CSR12 1b. ;
: HASH_CSR13. cr ." HASH_CSR13.  RW   $" HASH_CSR13 @ hex. HASH_CSR13 1b. ;
: HASH_CSR14. cr ." HASH_CSR14.  RW   $" HASH_CSR14 @ hex. HASH_CSR14 1b. ;
: HASH_CSR15. cr ." HASH_CSR15.  RW   $" HASH_CSR15 @ hex. HASH_CSR15 1b. ;
: HASH_CSR16. cr ." HASH_CSR16.  RW   $" HASH_CSR16 @ hex. HASH_CSR16 1b. ;
: HASH_CSR17. cr ." HASH_CSR17.  RW   $" HASH_CSR17 @ hex. HASH_CSR17 1b. ;
: HASH_CSR18. cr ." HASH_CSR18.  RW   $" HASH_CSR18 @ hex. HASH_CSR18 1b. ;
: HASH_CSR19. cr ." HASH_CSR19.  RW   $" HASH_CSR19 @ hex. HASH_CSR19 1b. ;
: HASH_CSR20. cr ." HASH_CSR20.  RW   $" HASH_CSR20 @ hex. HASH_CSR20 1b. ;
: HASH_CSR21. cr ." HASH_CSR21.  RW   $" HASH_CSR21 @ hex. HASH_CSR21 1b. ;
: HASH_CSR22. cr ." HASH_CSR22.  RW   $" HASH_CSR22 @ hex. HASH_CSR22 1b. ;
: HASH_CSR23. cr ." HASH_CSR23.  RW   $" HASH_CSR23 @ hex. HASH_CSR23 1b. ;
: HASH_CSR24. cr ." HASH_CSR24.  RW   $" HASH_CSR24 @ hex. HASH_CSR24 1b. ;
: HASH_CSR25. cr ." HASH_CSR25.  RW   $" HASH_CSR25 @ hex. HASH_CSR25 1b. ;
: HASH_CSR26. cr ." HASH_CSR26.  RW   $" HASH_CSR26 @ hex. HASH_CSR26 1b. ;
: HASH_CSR27. cr ." HASH_CSR27.  RW   $" HASH_CSR27 @ hex. HASH_CSR27 1b. ;
: HASH_CSR28. cr ." HASH_CSR28.  RW   $" HASH_CSR28 @ hex. HASH_CSR28 1b. ;
: HASH_CSR29. cr ." HASH_CSR29.  RW   $" HASH_CSR29 @ hex. HASH_CSR29 1b. ;
: HASH_CSR30. cr ." HASH_CSR30.  RW   $" HASH_CSR30 @ hex. HASH_CSR30 1b. ;
: HASH_CSR31. cr ." HASH_CSR31.  RW   $" HASH_CSR31 @ hex. HASH_CSR31 1b. ;
: HASH_CSR32. cr ." HASH_CSR32.  RW   $" HASH_CSR32 @ hex. HASH_CSR32 1b. ;
: HASH_CSR33. cr ." HASH_CSR33.  RW   $" HASH_CSR33 @ hex. HASH_CSR33 1b. ;
: HASH_CSR34. cr ." HASH_CSR34.  RW   $" HASH_CSR34 @ hex. HASH_CSR34 1b. ;
: HASH_CSR35. cr ." HASH_CSR35.  RW   $" HASH_CSR35 @ hex. HASH_CSR35 1b. ;
: HASH_CSR36. cr ." HASH_CSR36.  RW   $" HASH_CSR36 @ hex. HASH_CSR36 1b. ;
: HASH_CSR37. cr ." HASH_CSR37.  RW   $" HASH_CSR37 @ hex. HASH_CSR37 1b. ;
: HASH_CSR38. cr ." HASH_CSR38.  RW   $" HASH_CSR38 @ hex. HASH_CSR38 1b. ;
: HASH_CSR39. cr ." HASH_CSR39.  RW   $" HASH_CSR39 @ hex. HASH_CSR39 1b. ;
: HASH_CSR40. cr ." HASH_CSR40.  RW   $" HASH_CSR40 @ hex. HASH_CSR40 1b. ;
: HASH_CSR41. cr ." HASH_CSR41.  RW   $" HASH_CSR41 @ hex. HASH_CSR41 1b. ;
: HASH_CSR42. cr ." HASH_CSR42.  RW   $" HASH_CSR42 @ hex. HASH_CSR42 1b. ;
: HASH_CSR43. cr ." HASH_CSR43.  RW   $" HASH_CSR43 @ hex. HASH_CSR43 1b. ;
: HASH_CSR44. cr ." HASH_CSR44.  RW   $" HASH_CSR44 @ hex. HASH_CSR44 1b. ;
: HASH_CSR45. cr ." HASH_CSR45.  RW   $" HASH_CSR45 @ hex. HASH_CSR45 1b. ;
: HASH_CSR46. cr ." HASH_CSR46.  RW   $" HASH_CSR46 @ hex. HASH_CSR46 1b. ;
: HASH_CSR47. cr ." HASH_CSR47.  RW   $" HASH_CSR47 @ hex. HASH_CSR47 1b. ;
: HASH_CSR48. cr ." HASH_CSR48.  RW   $" HASH_CSR48 @ hex. HASH_CSR48 1b. ;
: HASH_CSR49. cr ." HASH_CSR49.  RW   $" HASH_CSR49 @ hex. HASH_CSR49 1b. ;
: HASH_CSR50. cr ." HASH_CSR50.  RW   $" HASH_CSR50 @ hex. HASH_CSR50 1b. ;
: HASH_CSR51. cr ." HASH_CSR51.  RW   $" HASH_CSR51 @ hex. HASH_CSR51 1b. ;
: HASH_CSR52. cr ." HASH_CSR52.  RW   $" HASH_CSR52 @ hex. HASH_CSR52 1b. ;
: HASH_CSR53. cr ." HASH_CSR53.  RW   $" HASH_CSR53 @ hex. HASH_CSR53 1b. ;
: HASH_HASH_HR0. cr ." HASH_HASH_HR0.  RO   $" HASH_HASH_HR0 @ hex. HASH_HASH_HR0 1b. ;
: HASH_HASH_HR1. cr ." HASH_HASH_HR1.  RO   $" HASH_HASH_HR1 @ hex. HASH_HASH_HR1 1b. ;
: HASH_HASH_HR2. cr ." HASH_HASH_HR2.  RO   $" HASH_HASH_HR2 @ hex. HASH_HASH_HR2 1b. ;
: HASH_HASH_HR3. cr ." HASH_HASH_HR3.  RO   $" HASH_HASH_HR3 @ hex. HASH_HASH_HR3 1b. ;
: HASH_HASH_HR4. cr ." HASH_HASH_HR4.  RO   $" HASH_HASH_HR4 @ hex. HASH_HASH_HR4 1b. ;
: HASH_HASH_HR5. cr ." HASH_HASH_HR5.  RO   $" HASH_HASH_HR5 @ hex. HASH_HASH_HR5 1b. ;
: HASH_HASH_HR6. cr ." HASH_HASH_HR6.  RO   $" HASH_HASH_HR6 @ hex. HASH_HASH_HR6 1b. ;
: HASH_HASH_HR7. cr ." HASH_HASH_HR7.  RO   $" HASH_HASH_HR7 @ hex. HASH_HASH_HR7 1b. ;
: HASH.
HASH_CR.
HASH_DIN.
HASH_STR.
HASH_HR0.
HASH_HR1.
HASH_HR2.
HASH_HR3.
HASH_HR4.
HASH_IMR.
HASH_SR.
HASH_CSR0.
HASH_CSR1.
HASH_CSR2.
HASH_CSR3.
HASH_CSR4.
HASH_CSR5.
HASH_CSR6.
HASH_CSR7.
HASH_CSR8.
HASH_CSR9.
HASH_CSR10.
HASH_CSR11.
HASH_CSR12.
HASH_CSR13.
HASH_CSR14.
HASH_CSR15.
HASH_CSR16.
HASH_CSR17.
HASH_CSR18.
HASH_CSR19.
HASH_CSR20.
HASH_CSR21.
HASH_CSR22.
HASH_CSR23.
HASH_CSR24.
HASH_CSR25.
HASH_CSR26.
HASH_CSR27.
HASH_CSR28.
HASH_CSR29.
HASH_CSR30.
HASH_CSR31.
HASH_CSR32.
HASH_CSR33.
HASH_CSR34.
HASH_CSR35.
HASH_CSR36.
HASH_CSR37.
HASH_CSR38.
HASH_CSR39.
HASH_CSR40.
HASH_CSR41.
HASH_CSR42.
HASH_CSR43.
HASH_CSR44.
HASH_CSR45.
HASH_CSR46.
HASH_CSR47.
HASH_CSR48.
HASH_CSR49.
HASH_CSR50.
HASH_CSR51.
HASH_CSR52.
HASH_CSR53.
HASH_HASH_HR0.
HASH_HASH_HR1.
HASH_HASH_HR2.
HASH_HASH_HR3.
HASH_HASH_HR4.
HASH_HASH_HR5.
HASH_HASH_HR6.
HASH_HASH_HR7.
;

00002984
\ HASH_CR (multiple-access)  Reset:0x00000000
: HASH_CR_INIT ( -- x addr ) 2 bit HASH_CR ; \ HASH_CR_INIT, Initialize message digest  calculation
: HASH_CR_DMAE ( -- x addr ) 3 bit HASH_CR ; \ HASH_CR_DMAE, DMA enable
: HASH_CR_DATATYPE ( %bb -- x addr ) 4 lshift HASH_CR ; \ HASH_CR_DATATYPE, Data type selection
: HASH_CR_MODE ( -- x addr ) 6 bit HASH_CR ; \ HASH_CR_MODE, Mode selection
: HASH_CR_ALGO0 ( -- x addr ) 7 bit HASH_CR ; \ HASH_CR_ALGO0, Algorithm selection
: HASH_CR_NBW ( %bbbb -- x addr ) 8 lshift HASH_CR ; \ HASH_CR_NBW, Number of words already  pushed
: HASH_CR_DINNE ( -- x addr ) 12 bit HASH_CR ; \ HASH_CR_DINNE, DIN not empty
: HASH_CR_MDMAT ( -- x addr ) 13 bit HASH_CR ; \ HASH_CR_MDMAT, Multiple DMA Transfers
: HASH_CR_LKEY ( -- x addr ) 16 bit HASH_CR ; \ HASH_CR_LKEY, Long key selection
: HASH_CR_ALGO1 ( -- x addr ) 18 bit HASH_CR ; \ HASH_CR_ALGO1, ALGO

\ HASH_DIN (read-write) Reset:0x00000000
: HASH_DIN_DATAIN ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_DIN ; \ HASH_DIN_DATAIN, Data input

\ HASH_STR (multiple-access)  Reset:0x00000000
: HASH_STR_DCAL ( -- x addr ) 8 bit HASH_STR ; \ HASH_STR_DCAL, Digest calculation
: HASH_STR_NBLW ( %bbbbb -- x addr ) HASH_STR ; \ HASH_STR_NBLW, Number of valid bits in the last word of  the message

\ HASH_HR0 (read-only) Reset:0x00000000
: HASH_HR0_H0? ( --  x ) HASH_HR0 @ ; \ HASH_HR0_H0, H0

\ HASH_HR1 (read-only) Reset:0x00000000
: HASH_HR1_H1? ( --  x ) HASH_HR1 @ ; \ HASH_HR1_H1, H1

\ HASH_HR2 (read-only) Reset:0x00000000
: HASH_HR2_H2? ( --  x ) HASH_HR2 @ ; \ HASH_HR2_H2, H2

\ HASH_HR3 (read-only) Reset:0x00000000
: HASH_HR3_H3? ( --  x ) HASH_HR3 @ ; \ HASH_HR3_H3, H3

\ HASH_HR4 (read-only) Reset:0x00000000
: HASH_HR4_H4? ( --  x ) HASH_HR4 @ ; \ HASH_HR4_H4, H4

\ HASH_IMR (read-write) Reset:0x00000000
: HASH_IMR_DCIE ( -- x addr ) 1 bit HASH_IMR ; \ HASH_IMR_DCIE, Digest calculation completion interrupt  enable
: HASH_IMR_DINIE ( -- x addr ) 0 bit HASH_IMR ; \ HASH_IMR_DINIE, Data input interrupt  enable

\ HASH_SR (multiple-access)  Reset:0x00000001
: HASH_SR_BUSY ( -- x addr ) 3 bit HASH_SR ; \ HASH_SR_BUSY, Busy bit
: HASH_SR_DMAS ( -- x addr ) 2 bit HASH_SR ; \ HASH_SR_DMAS, DMA Status
: HASH_SR_DCIS? ( -- 1|0 ) 1 bit HASH_SR bit@ ; \ HASH_SR_DCIS, Digest calculation completion interrupt  status
: HASH_SR_DINIS? ( -- 1|0 ) 0 bit HASH_SR bit@ ; \ HASH_SR_DINIS, Data input interrupt  status

\ HASH_CSR0 (read-write) Reset:0x00000000
: HASH_CSR0_CSR0 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR0 ; \ HASH_CSR0_CSR0, CSR0

\ HASH_CSR1 (read-write) Reset:0x00000000
: HASH_CSR1_CSR1 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR1 ; \ HASH_CSR1_CSR1, CSR1

\ HASH_CSR2 (read-write) Reset:0x00000000
: HASH_CSR2_CSR2 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR2 ; \ HASH_CSR2_CSR2, CSR2

\ HASH_CSR3 (read-write) Reset:0x00000000
: HASH_CSR3_CSR3 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR3 ; \ HASH_CSR3_CSR3, CSR3

\ HASH_CSR4 (read-write) Reset:0x00000000
: HASH_CSR4_CSR4 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR4 ; \ HASH_CSR4_CSR4, CSR4

\ HASH_CSR5 (read-write) Reset:0x00000000
: HASH_CSR5_CSR5 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR5 ; \ HASH_CSR5_CSR5, CSR5

\ HASH_CSR6 (read-write) Reset:0x00000000
: HASH_CSR6_CSR6 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR6 ; \ HASH_CSR6_CSR6, CSR6

\ HASH_CSR7 (read-write) Reset:0x00000000
: HASH_CSR7_CSR7 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR7 ; \ HASH_CSR7_CSR7, CSR7

\ HASH_CSR8 (read-write) Reset:0x00000000
: HASH_CSR8_CSR8 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR8 ; \ HASH_CSR8_CSR8, CSR8

\ HASH_CSR9 (read-write) Reset:0x00000000
: HASH_CSR9_CSR9 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR9 ; \ HASH_CSR9_CSR9, CSR9

\ HASH_CSR10 (read-write) Reset:0x00000000
: HASH_CSR10_CSR10 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR10 ; \ HASH_CSR10_CSR10, CSR10

\ HASH_CSR11 (read-write) Reset:0x00000000
: HASH_CSR11_CSR11 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR11 ; \ HASH_CSR11_CSR11, CSR11

\ HASH_CSR12 (read-write) Reset:0x00000000
: HASH_CSR12_CSR12 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR12 ; \ HASH_CSR12_CSR12, CSR12

\ HASH_CSR13 (read-write) Reset:0x00000000
: HASH_CSR13_CSR13 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR13 ; \ HASH_CSR13_CSR13, CSR13

\ HASH_CSR14 (read-write) Reset:0x00000000
: HASH_CSR14_CSR14 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR14 ; \ HASH_CSR14_CSR14, CSR14

\ HASH_CSR15 (read-write) Reset:0x00000000
: HASH_CSR15_CSR15 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR15 ; \ HASH_CSR15_CSR15, CSR15

\ HASH_CSR16 (read-write) Reset:0x00000000
: HASH_CSR16_CSR16 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR16 ; \ HASH_CSR16_CSR16, CSR16

\ HASH_CSR17 (read-write) Reset:0x00000000
: HASH_CSR17_CSR17 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR17 ; \ HASH_CSR17_CSR17, CSR17

\ HASH_CSR18 (read-write) Reset:0x00000000
: HASH_CSR18_CSR18 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR18 ; \ HASH_CSR18_CSR18, CSR18

\ HASH_CSR19 (read-write) Reset:0x00000000
: HASH_CSR19_CSR19 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR19 ; \ HASH_CSR19_CSR19, CSR19

\ HASH_CSR20 (read-write) Reset:0x00000000
: HASH_CSR20_CSR20 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR20 ; \ HASH_CSR20_CSR20, CSR20

\ HASH_CSR21 (read-write) Reset:0x00000000
: HASH_CSR21_CSR21 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR21 ; \ HASH_CSR21_CSR21, CSR21

\ HASH_CSR22 (read-write) Reset:0x00000000
: HASH_CSR22_CSR22 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR22 ; \ HASH_CSR22_CSR22, CSR22

\ HASH_CSR23 (read-write) Reset:0x00000000
: HASH_CSR23_CSR23 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR23 ; \ HASH_CSR23_CSR23, CSR23

\ HASH_CSR24 (read-write) Reset:0x00000000
: HASH_CSR24_CSR24 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR24 ; \ HASH_CSR24_CSR24, CSR24

\ HASH_CSR25 (read-write) Reset:0x00000000
: HASH_CSR25_CSR25 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR25 ; \ HASH_CSR25_CSR25, CSR25

\ HASH_CSR26 (read-write) Reset:0x00000000
: HASH_CSR26_CSR26 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR26 ; \ HASH_CSR26_CSR26, CSR26

\ HASH_CSR27 (read-write) Reset:0x00000000
: HASH_CSR27_CSR27 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR27 ; \ HASH_CSR27_CSR27, CSR27

\ HASH_CSR28 (read-write) Reset:0x00000000
: HASH_CSR28_CSR28 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR28 ; \ HASH_CSR28_CSR28, CSR28

\ HASH_CSR29 (read-write) Reset:0x00000000
: HASH_CSR29_CSR29 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR29 ; \ HASH_CSR29_CSR29, CSR29

\ HASH_CSR30 (read-write) Reset:0x00000000
: HASH_CSR30_CSR30 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR30 ; \ HASH_CSR30_CSR30, CSR30

\ HASH_CSR31 (read-write) Reset:0x00000000
: HASH_CSR31_CSR31 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR31 ; \ HASH_CSR31_CSR31, CSR31

\ HASH_CSR32 (read-write) Reset:0x00000000
: HASH_CSR32_CSR32 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR32 ; \ HASH_CSR32_CSR32, CSR32

\ HASH_CSR33 (read-write) Reset:0x00000000
: HASH_CSR33_CSR33 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR33 ; \ HASH_CSR33_CSR33, CSR33

\ HASH_CSR34 (read-write) Reset:0x00000000
: HASH_CSR34_CSR34 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR34 ; \ HASH_CSR34_CSR34, CSR34

\ HASH_CSR35 (read-write) Reset:0x00000000
: HASH_CSR35_CSR35 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR35 ; \ HASH_CSR35_CSR35, CSR35

\ HASH_CSR36 (read-write) Reset:0x00000000
: HASH_CSR36_CSR36 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR36 ; \ HASH_CSR36_CSR36, CSR36

\ HASH_CSR37 (read-write) Reset:0x00000000
: HASH_CSR37_CSR37 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR37 ; \ HASH_CSR37_CSR37, CSR37

\ HASH_CSR38 (read-write) Reset:0x00000000
: HASH_CSR38_CSR38 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR38 ; \ HASH_CSR38_CSR38, CSR38

\ HASH_CSR39 (read-write) Reset:0x00000000
: HASH_CSR39_CSR39 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR39 ; \ HASH_CSR39_CSR39, CSR39

\ HASH_CSR40 (read-write) Reset:0x00000000
: HASH_CSR40_CSR40 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR40 ; \ HASH_CSR40_CSR40, CSR40

\ HASH_CSR41 (read-write) Reset:0x00000000
: HASH_CSR41_CSR41 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR41 ; \ HASH_CSR41_CSR41, CSR41

\ HASH_CSR42 (read-write) Reset:0x00000000
: HASH_CSR42_CSR42 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR42 ; \ HASH_CSR42_CSR42, CSR42

\ HASH_CSR43 (read-write) Reset:0x00000000
: HASH_CSR43_CSR43 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR43 ; \ HASH_CSR43_CSR43, CSR43

\ HASH_CSR44 (read-write) Reset:0x00000000
: HASH_CSR44_CSR44 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR44 ; \ HASH_CSR44_CSR44, CSR44

\ HASH_CSR45 (read-write) Reset:0x00000000
: HASH_CSR45_CSR45 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR45 ; \ HASH_CSR45_CSR45, CSR45

\ HASH_CSR46 (read-write) Reset:0x00000000
: HASH_CSR46_CSR46 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR46 ; \ HASH_CSR46_CSR46, CSR46

\ HASH_CSR47 (read-write) Reset:0x00000000
: HASH_CSR47_CSR47 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR47 ; \ HASH_CSR47_CSR47, CSR47

\ HASH_CSR48 (read-write) Reset:0x00000000
: HASH_CSR48_CSR48 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR48 ; \ HASH_CSR48_CSR48, CSR48

\ HASH_CSR49 (read-write) Reset:0x00000000
: HASH_CSR49_CSR49 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR49 ; \ HASH_CSR49_CSR49, CSR49

\ HASH_CSR50 (read-write) Reset:0x00000000
: HASH_CSR50_CSR50 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR50 ; \ HASH_CSR50_CSR50, CSR50

\ HASH_CSR51 (read-write) Reset:0x00000000
: HASH_CSR51_CSR51 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR51 ; \ HASH_CSR51_CSR51, CSR51

\ HASH_CSR52 (read-write) Reset:0x00000000
: HASH_CSR52_CSR52 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR52 ; \ HASH_CSR52_CSR52, CSR52

\ HASH_CSR53 (read-write) Reset:0x00000000
: HASH_CSR53_CSR53 ( %bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb -- x addr ) HASH_CSR53 ; \ HASH_CSR53_CSR53, CSR53

\ HASH_HASH_HR0 (read-only) Reset:0x00000000
: HASH_HASH_HR0_H0? ( --  x ) HASH_HASH_HR0 @ ; \ HASH_HASH_HR0_H0, H0

\ HASH_HASH_HR1 (read-only) Reset:0x00000000
: HASH_HASH_HR1_H1? ( --  x ) HASH_HASH_HR1 @ ; \ HASH_HASH_HR1_H1, H1

\ HASH_HASH_HR2 (read-only) Reset:0x00000000
: HASH_HASH_HR2_H2? ( --  x ) HASH_HASH_HR2 @ ; \ HASH_HASH_HR2_H2, H2

\ HASH_HASH_HR3 (read-only) Reset:0x00000000
: HASH_HASH_HR3_H3? ( --  x ) HASH_HASH_HR3 @ ; \ HASH_HASH_HR3_H3, H3

\ HASH_HASH_HR4 (read-only) Reset:0x00000000
: HASH_HASH_HR4_H4? ( --  x ) HASH_HASH_HR4 @ ; \ HASH_HASH_HR4_H4, H4

\ HASH_HASH_HR5 (read-only) Reset:0x00000000
: HASH_HASH_HR5_H5? ( --  x ) HASH_HASH_HR5 @ ; \ HASH_HASH_HR5_H5, H5

\ HASH_HASH_HR6 (read-only) Reset:0x00000000
: HASH_HASH_HR6_H6? ( --  x ) HASH_HASH_HR6 @ ; \ HASH_HASH_HR6_H6, H6

\ HASH_HASH_HR7 (read-only) Reset:0x00000000
: HASH_HASH_HR7_H7? ( --  x ) HASH_HASH_HR7 @ ; \ HASH_HASH_HR7_H7, H7

: HR. ( -- ) HASH_HASH_HR0. HASH_HASH_HR1. HASH_HASH_HR2. HASH_HASH_HR3. HASH_HASH_HR4. HASH_HASH_HR5. HASH_HASH_HR6. HASH_HASH_HR7. ;

: hash-on ( -- ) 5 bit RCC_AHB2ENR bis! ;
: hash-sha256 ( -- ) HASH_CR_ALGO0 drop HASH_CR_ALGO1 drop or HASH_CR_INIT drop or HASH_CR ! ;
: hash-init ( -- ) HASH_CR_INIT ! ;
: hash-calc ( -- ) HASH_STR_DCAL ! ;
: >hash ( -- ) HASH_DIN ! ;
