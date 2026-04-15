// **********************************************************************
// Freescale MKL05Z32xxx4 device values and configuration code
// * CPU Architecture values
// * CPU Registers
// * Various core, system, and peripheral modules and interfaces
// [1] Freescale Semiconductor, <B>Kinetis L Peripheral Module Quick
//     Reference</B>, KLQRUG, Rev. 0, 9/2012.
// [2] Freescale Semiconductor, <B>KL05 Sub-Family Reference Manual</B>,
//     KL05P48M48SF1RM, Rev. 3.1, 11/2012.
// [3] Freescale Semiconductor, MKL05Z4.h, rev. 1.6, 4/11/2013
// [4] Arm, core_cm0plus.h, v5.0.9, 8/21/2019
// [5] RIT CMPE-250 MKL46Z4.s, rev. 1/5/2018
// [6] Freescale startup_MKL05Z4.s
//     CMSIS Cortex-M0plus Core Device Startup File for the MKL05Z4
//     v1.6, 4/11/
//     FTFA_FlashConfig and NV
// [7] Freescale startup_MKL46Z4.s
//     CMSIS Cortex-M0plus Core Device Startup File for the MKL64Z4
//     v2.2, 4/12/2013
//     FCF_ naming convention
// ---------------------------------------------------------------
// Author:  R. W. Melton
// Date:  August 2, 2022
// ***************************************************************
// EQUates
// Standard data masks
.set BYTE_MASK         ,  0xFF
.set NIBBLE_MASK       ,  0x0F
// Standard data sizes (in bits)
.set BYTE_BITS         ,  8
.set NIBBLE_BITS       ,  4
// Architecture data sizes (in bytes)
.set WORD_SIZE         ,  4  // Cortex-M0+
.set HALFWORD_SIZE     ,  2  // Cortex-M0+
// Architecture data masks
.set HALFWORD_MASK     ,  0xFFFF
// Return                 
.set RET_ADDR_T_MASK   ,  1  // Bit 0 of ret. addr. must be
                          // set for BX, BLX, or POP
                          // mask in thumb mode
// ---------------------------------------------------------------
// Vectors
.set VECTOR_TABLE_SIZE ,  0x000000C0  // KL46
.set VECTOR_SIZE       ,  4           // Bytes per vector
// ---------------------------------------------------------------
// CPU CONTROL:  Control register
// 31-2:(reserved)
//    1:SPSEL=current stack pointer select
//            0=MSP (main stack pointer) (reset value)
//            1=PSP (process stack pointer)
//    0:nPRIV=not privileged
//         0=privileged (Freescale/NXP "supervisor") (reset value)
//         1=not privileged (Freescale/NXP "user")
.set CONTROL_SPSEL_MASK   ,  2
.set CONTROL_SPSEL_SHIFT  ,  1
.set CONTROL_nPRIV_MASK   ,  1
.set CONTROL_nPRIV_SHIFT  ,  0
// ---------------------------------------------------------------
// CPU PRIMASK:  Interrupt mask register
// 31-1:(reserved)
//    0:PM=prioritizable interrupt mask:
//         0=all interrupts unmasked (reset value)
//           (value after CPSIE I instruction)
//         1=prioritizable interrrupts masked
//           (value after CPSID I instruction)
.set PRIMASK_PM_MASK   ,  1
.set PRIMASK_PM_SHIFT  ,  0
// ---------------------------------------------------------------
// CPU PSR:  Program status register
// Combined APSR, EPSR, and IPSR
// ----------------------------------------------------------
// CPU APSR:  Application Program Status Register
// 31  :N=negative flag
// 30  :Z=zero flag
// 29  :C=carry flag
// 28  :V=overflow flag
// 27-0:(reserved)
.set APSR_MASK     ,  0xF0000000
.set APSR_SHIFT    ,  28
.set APSR_N_MASK   ,  0x80000000
.set APSR_N_SHIFT  ,  31
.set APSR_Z_MASK   ,  0x40000000
.set APSR_Z_SHIFT  ,  30
.set APSR_C_MASK   ,  0x20000000
.set APSR_C_SHIFT  ,  29
.set APSR_V_MASK   ,  0x10000000
.set APSR_V_SHIFT  ,  28
// ----------------------------------------------------------
// CPU EPSR
// 31-25:(reserved)
//    24:T=thumb state bit
// 23- 0:(reserved)
.set EPSR_MASK     ,  0x01000000
.set EPSR_SHIFT    ,  24
.set EPSR_T_MASK   ,  0x01000000
.set EPSR_T_SHIFT  ,  24
// ----------------------------------------------------------
// CPU IPSR
// 31-6:(reserved)
//  5-0:Exception number=number of current exception
//       0=thread mode
//       1:(reserved)
//       2=NMI
//       3=hard fault
//       4-10:(reserved)
//      11=SVCall
//      12-13:(reserved)
//      14=PendSV
//      15=SysTick
//      16=IRQ0
//      16-47:IRQ(Exception number - 16)
//      47=IRQ31
//      48-63:(reserved)
.set IPSR_MASK             ,  0x0000003F
.set IPSR_SHIFT            ,  0
.set IPSR_EXCEPTION_MASK   ,  0x0000003F
.set IPSR_EXCEPTION_SHIFT  ,  0
// ----------------------------------------------------------
.set PSR_N_MASK           ,  APSR_N_MASK
.set PSR_N_SHIFT          ,  APSR_N_SHIFT
.set PSR_Z_MASK           ,  APSR_Z_MASK
.set PSR_Z_SHIFT          ,  APSR_Z_SHIFT
.set PSR_C_MASK           ,  APSR_C_MASK
.set PSR_C_SHIFT          ,  APSR_C_SHIFT
.set PSR_V_MASK           ,  APSR_V_MASK
.set PSR_V_SHIFT          ,  APSR_V_SHIFT
.set PSR_T_MASK           ,  EPSR_T_MASK
.set PSR_T_SHIFT          ,  EPSR_T_SHIFT
.set PSR_EXCEPTION_MASK   ,  IPSR_EXCEPTION_MASK
.set PSR_EXCEPTION_SHIFT  ,  IPSR_EXCEPTION_SHIFT
// ---------------------------------------------------------------
// Cortex-M0+ Core
.set __CM0PLUS_REV           ,  0x0000  // Core revision r0p0
.set __MPU_PRESENT           ,  0       // Whether MPU is present
.set __NVIC_PRIO_BITS        ,  2       // Number of NVIC priority bits
.set __Vendor_SysTickConfig  ,  0       // Whether vendor-specific 
                                     // SysTickConfig is defined
.set __VTOR_PRESENT          ,  1       // Whether VTOR is present
// ---------------------------------------------------------------
// Interrupt numbers (IRQn)
// Interrupt vector is 16 + IRQn
// Core interrupts
.set NonMaskableInt_IRQn  ,  -14  // Non-maskable interrupt (NMI)
.set HardFault_IRQn       ,  -13  // Hard fault interrupt
.set SVCall_IRQn          ,  -5   // Supervisor call interrupt (SVCall)
.set PendSV_IRQn          ,  -2   // Pendable request for system-level service interrupt
                               // (PendableSrvReq)
.set SysTick_IRQn         ,  -1   // System tick timer interrupt (SysTick)
// --------------------------
// Device specific interrupts
.set DMA0_IRQn            ,  0   // DMA channel 0 transfer complete/error interrupt
.set DMA1_IRQn            ,  1   // DMA channel 1 transfer complete/error interrupt
.set DMA2_IRQn            ,  2   // DMA channel 2 transfer complete/error interrupt
.set DMA3_IRQn            ,  3   // DMA channel 3 transfer complete/error interrupt
.set Reserved20_IRQn      ,  4   // Reserved interrupt 20
.set FTFA_IRQn            ,  5   // FTFA command complete/read collision interrupt
.set LVD_LVW_IRQn         ,  6   // Low-voltage detect, low-voltage warning interrupt
.set LLW_IRQn             ,  7   // Low leakage wakeup interrupt
.set I2C0_IRQn            ,  8   // I2C0 interrupt
.set Reserved25_IRQn      ,  9   // Reserved interrupt 25
.set SPI0_IRQn            ,  10  // SPI0 interrupt
.set Reserved27_IRQn      ,  11  // Reserved interrupt 27
.set UART0_IRQn           ,  12  // UART0 status/error interrupt
.set Reserved29_IRQn      ,  13  // Reserved interrupt 29
.set Reserved30_IRQn      ,  14  // Reserved interrupt 30
.set ADC0_IRQn            ,  15  // ADC0 interrupt
.set CMP0_IRQn            ,  16  // CMP0 interrupt
.set TPM0_IRQn            ,  17  // TPM0 fault, overflow, and channels interrupt
.set TPM1_IRQn            ,  18  // TPM1 fault, overflow, and channels interrupt
.set Reserved35_IRQn      ,  19  // Reserved interrupt 35
.set RTC_IRQn             ,  20  // RTC alarm interrupt
.set RTC_Seconds_IRQn     ,  21  // RTC seconds interrupt
.set PIT_IRQn             ,  22  // PIT interrupt
.set Reserved39_IRQn      ,  23  // Reserved interrupt 39
.set Reserved40_IRQn      ,  24  // Reserved interrupt 40
.set DAC0_IRQn            ,  25  // DAC0 interrupt
.set TSI0_IRQn            ,  26  // TSI0 interrupt
.set MCG_IRQn             ,  27  // MCG interrupt
.set LPTimer_IRQn         ,  28  // LPTMR0 interrupt
.set Reserved45_IRQn      ,  29  // Reserved interrupt 45
.set PORTA_IRQn           ,  30  // Port A interrupt
.set PORTB_IRQn           ,  31  // Port B interrupt
// ---------------------------------------------------------------
// Memory map major version
// (Memory maps with equal major version number are compatible)
.set MCU_MEM_MAP_VERSION        , 0x0100
// Memory map minor version
.set MCU_MEM_MAP_VERSION_MINOR  ,  0x0006
// ---------------------------------------------------------------
// ADC
.set ADC0_BASE        ,  0x4003B000
// ADC_BASES        EQU  ADC0_BASE
// ADC_SC1_OFFSET   EQU  0x00
.set ADC_SC1A_OFFSET  ,  0x00
.set ADC_SC1B_OFFSET  ,  0x04
.set ADC_CFG1_OFFSET  ,  0x08
.set ADC_CFG2_OFFSET  ,  0x0C
// ADC_R_OFFSET     EQU  0x10
.set ADC_RA_OFFSET    ,  0x10
.set ADC_RB_OFFSET    ,  0x14
.set ADC_CV1_OFFSET   ,  0x18
.set ADC_CV2_OFFSET   ,  0x1C
.set ADC_SC2_OFFSET   ,  0x20
.set ADC_SC3_OFFSET   ,  0x24
.set ADC_OFS_OFFSET   ,  0x28
.set ADC_PG_OFFSET    ,  0x2C
// ADC_RESERVED_0_OFFSET  EQU  0x30
.set ADC_CLPD_OFFSET  ,  0x34
.set ADC_CLPS_OFFSET  ,  0x38
.set ADC_CLP4_OFFSET  ,  0x3C
.set ADC_CLP3_OFFSET  ,  0x40
.set ADC_CLP2_OFFSET  ,  0x44
.set ADC_CLP1_OFFSET  ,  0x48
.set ADC_CLP0_OFFSET  ,  0x4C
.set ADC0_CFG1        ,  (ADC0_BASE + ADC_CFG1_OFFSET)
.set ADC0_CFG2        ,  (ADC0_BASE + ADC_CFG2_OFFSET)
.set ADC0_CLPD        ,  (ADC0_BASE + ADC_CLPD_OFFSET)
.set ADC0_CLPS        ,  (ADC0_BASE + ADC_CLPS_OFFSET)
.set ADC0_CLP0        ,  (ADC0_BASE + ADC_CLP0_OFFSET)
.set ADC0_CLP1        ,  (ADC0_BASE + ADC_CLP1_OFFSET)
.set ADC0_CLP2        ,  (ADC0_BASE + ADC_CLP2_OFFSET)
.set ADC0_CLP3        ,  (ADC0_BASE + ADC_CLP3_OFFSET)
.set ADC0_CLP4        ,  (ADC0_BASE + ADC_CLP4_OFFSET)
.set ADC0_CV1         ,  (ADC0_BASE + ADC_CV1_OFFSET)
.set ADC0_CV2         ,  (ADC0_BASE + ADC_CV2_OFFSET)
.set ADC0_OFS         ,  (ADC0_BASE + ADC_OFS_OFFSET)
.set ADC0_PG          ,  (ADC0_BASE + ADC_PG_OFFSET) 
// ACD0_R           EQU  (ADC0_BASE + ADC_R_OFFSET)  
.set ADC0_RA          ,  ( ADC0_BASE + ADC_RA_OFFSET)  
.set ADC0_RB          ,  ( ADC0_BASE + ADC_RB_OFFSET)
// ADC0_RESERVED_0  EQU  ( ADC0_BASE + ADC_RESERVED_0_OFFSET)
// ADC0_SC1         EQU  ( ADC0_BASE + ADC_SC1_OFFSET)
.set ADC0_SC1A        ,  ( ADC0_BASE + ADC_SC1A_OFFSET)
.set ADC0_SC1B        ,  ( ADC0_BASE + ADC_SC1B_OFFSET)
.set ADC0_SC2         ,  ( ADC0_BASE + ADC_SC2_OFFSET)
.set ADC0_SC3         ,  ( ADC0_BASE + ADC_SC3_OFFSET)
// ---------------------------------------------------------------
// ADC_CFG1:  ADC configuration register 1
// 31-8:(reserved):read-only:0
//    7:ADLPC=ADC low-power configuration
//  6-5:ADIV=ADC clock divide select
//      Internal ADC clock = input clock / 2^ADIV
//    4:ADLSMP=ADC long sample time configuration
//             0=short
//             1=long
//  3-2:MODE=conversion mode selection
//           00=single-ended 8-bit conversion
//           01=single-ended 12-bit conversion
//           10=single-ended 10-bit conversion
//           11=(reserved; do not set this value)
//  1-0:ADICLK=ADC input clock select
//           00=bus clock
//           01=bus clock / 2
//           10=alternate clock (ALTCLK)
//           11=asynchronous clock (ADACK)
.set ADC_CFG1_ADLPC_MASK   ,  0x80
.set ADC_CFG1_ADLPC_SHIFT  ,  7
.set ADC_CFG1_ADIV_MASK    ,  0x60
.set ADC_CFG1_ADIV_SHIFT   ,  5
.set ADC_CFG1_ADLSMP_MASK  ,  0x10
.set ADC_CFG1_ADLSMP_SHIFT ,  4
.set ADC_CFG1_MODE_MASK    ,  0x0C
.set ADC_CFG1_MODE_SHIFT   ,  2
.set ADC_CFG1_ADICLK_MASK  ,  0x03
.set ADC_CFG1_ADICLK_SHIFT ,  0
// ---------------------------------------------------------------
// ADC_CFG2:  ADC configuration register 2
// 31-8:(reserved):read-only:0
//  7-5:(reserved):read-only:0
//    4:MUXSEL=ADC mux select
//             0=ADxxA channels are selected
//             1=ADxxB channels are selected
//    3:ADACKEN=ADC asynchronous clock output enable
//              0=asynchronous clock determined by ACD0_CFG1.ADICLK 
//              1=asynchronous clock enabled
//    2:ADHSC=ADC high-speed configuration
//            0=normal conversion
//            1=high-speed conversion (only 2 additional ADK cycles)
//  1-0:ADLSTS=ADC long sample time select (ADK cycles)
//           00=default longest sample time:  
//              24 total ADK cycles (20 extra)
//           01=16 total ADK cycles (12 extra)
//           10=10 total ADK cycles (6 extra)
//           11=6 total ADK cycles (2 extra)
.set ADC_CFG2_MUXSEL_MASK    ,  0x10
.set ADC_CFG2_MUXSEL_SHIFT   ,  4
.set ADC_CFG2_ADACKEN_MASK   ,  0x08
.set ADC_CFG2_ADACKEN_SHIFT  ,  3
.set ADC_CFG2_ADHSC_MASK     ,  0x04
.set ADC_CFG2_ADHSC_SHIFT    ,  2
.set ADC_CFG2_ADLSTS_MASK    ,  0x03
.set ADC_CFG2_ADLSTS_SHIFT   ,  0
// ---------------------------------------------------------------
// ADC_CLPD:  ADC plus-side general calibration value register D
// 31-6:(reserved):read-only:0
//  5-0:CLPD=calibration value
.set ADC_CLPD_MASK   ,  0x3F
.set ADC_CLPD_SHIFT  ,  0
// ---------------------------------------------------------------
// ADC_CLPS:  ADC plus-side general calibration value register S
// 31-6:(reserved):read-only:0
//  5-0:CLPS=calibration value
.set ADC_CLPS_MASK   ,  0x3F
.set ADC_CLPS_SHIFT  ,  0
// ---------------------------------------------------------------
// ADC_CLP0:  ADC plus-side general calibration value register 0
// 31-6:(reserved):read-only:0
//  5-0:CLP0=calibration value
.set ADC_CLP0_MASK   ,  0x3F
.set ADC_CLP0_SHIFT  ,  0
// ---------------------------------------------------------------
// ADC_CLP1:  ADC plus-side general calibration value register 1
// 31-7:(reserved):read-only:0
//  6-0:CLP1=calibration value
.set ADC_CLP1_MASK   ,  0x7F
.set ADC_CLP1_SHIFT  ,  0
// ---------------------------------------------------------------
// ADC_CLP2:  ADC plus-side general calibration value register 2
// 31-8:(reserved):read-only:0
//  7-0:CLP2=calibration value
.set ADC_CLP2_MASK   ,  0xFF
.set ADC_CLP2_SHIFT  ,  0
// ---------------------------------------------------------------
// ADC_CLP3:  ADC plus-side general calibration value register 3
// 31-9:(reserved):read-only:0
//  8-0:CLP3=calibration value
.set ADC_CLP3_MASK   ,  0x1FF
.set ADC_CLP3_SHIFT  ,  0
// ---------------------------------------------------------------
// ADC_CLP4:  ADC plus-side general calibration value register 4
// 31-10:(reserved):read-only:0
//  9- 0:CLP4=calibration value
.set ADC_CLP4_MASK   ,  0x3FF
.set ADC_CLP4_SHIFT  ,  0
// ---------------------------------------------------------------
// ADC_CVn:  ADC channel n compare value register
// CV1 used to compare result when ADC_SC2.ACFE=1
// CV2 used to compare result when ADC_SC2.ACREN=1
// 31-16:(reserved):read-only:0
// 15- 0:compare value (zero-extended to 16 bits,
//                      consistent with format of ACD_Rn)
.set ADC_CV_MASK   ,  0xFFFF
.set ADC_CV_SHIFT  ,  0
// ---------------------------------------------------------------
// ADC_OFS:  ADC offset correction register
// 31-16:(reserved):read-only:0
// 15- 0:OFS=offset error correction value
.set ADC_OFS_MASK   ,  0xFFFF
.set ADC_OFS_SHIFT  ,  0
// ---------------------------------------------------------------
// ADC_PG:  ADC plus-side gain register
// 31-16:(reserved):read-only:0
// 15- 0:PG=plus-side gain
.set ADC_PG_MASK   ,  0xFFFF
.set ADC_PG_SHIFT  ,  0
// ---------------------------------------------------------------
// ADC_Rn:  ADC channel n data result register
// 31-16:(reserved):read-only:0
// 15- 0:data result (zero-extended to 16 bits)
.set ADC_R_D_MASK   ,  0xFFFF
.set ADC_R_D_SHIFT  ,  0
// ---------------------------------------------------------------
// ADC_SC1n:  ADC channel n status and control register 1
// 31-8:(reserved):read-only:0
//    7:COCO=conversion complete flag (read-only)
//    6:AIEN=ADC interrupt enabled
//    5:(reserved)
//  4-0:ADCH=ADC input channel select
//           00000=AD0
//           00001=AD1
//           00010=AD2
//           00011=AD3
//           00100=AD4
//           00101=AD5 (12-bit DAC0 Output)
//           00110=AD6
//           00111=AD7
//           01000=AD8
//           01001=AD9
//           01010=AD10
//           01011=AD11
//           01100=AD12
//           01101=AD13
//           01110=(reserved)
//           01111=(reserved)
//           10000=(reserved)
//           10001=(reserved)
//           10010=(reserved)
//           10011=(reserved)
//           10100=(reserved)
//           10101=(reserved)
//           10110=(reserved)
//           10111=(reserved)
//           11000=(reserved)
//           11001=(reserved)
//           11010=temp sensor (single-ended)
//           11011=bandgap
//           11100=(reserved)
//           11101=VREFSH
//           11110=VREFSL
//           11111=disabled
.set ADC_SC1_COCO_MASK   ,  0x80
.set ADC_SC1_COCO_SHIFT  ,  7
.set ADC_SC1_AIEN_MASK   ,  0x40
.set ADC_SC1_AIEN_SHIFT  ,  6
.set ADC_SC1_ADCH_MASK   ,  0x1F
.set ADC_SC1_ADCH_SHIFT  ,  0
// ---------------------------------------------------------------
// ADC_SC2:  ADC status and control register 2
// 31-8:(reserved):read-only:0
//    7:ADACT=ADC conversion active
//    6:ADTRG=ADC conversion trigger select
//            0=software trigger
//            1=hardware trigger
//    5:ACFE=ADC compare function enable
//    4:ACFGT=ADC compare function greater than enable
//            based on values in ADC_CV1 and ADC_CV2
//            0=configure less than threshold and non-inclusive range
//            1=configure greater than threshold and non-inclusive range
//    3:ACREN=ADC compare function range enable
//            0=disabled; only ADC_CV1 compared
//            1=enabled; both ADC_CV1 and ADC_CV2 compared
//    2:DMAEN=DMA enable
//  1-0:REFSEL=voltage reference selection
//             00=default:VREFH and VREFL
//             01=alternative:VALTH and VALTL
//             10=(reserved)
//             11=(reserved)
.set ADC_SC2_ADACT_MASK    ,  0x80
.set ADC_SC2_ADACT_SHIFT   ,  7
.set ADC_SC2_ADTRG_MASK    ,  0x40
.set ADC_SC2_ADTRG_SHIFT   ,  6
.set ADC_SC2_ACFE_MASK     ,  0x20
.set ADC_SC2_ACFE_SHIFT    ,  5
.set ADC_SC2_ACFGT_MASK    ,  0x10
.set ADC_SC2_ACFGT_SHIFT   ,  4
.set ADC_SC2_ACREN_MASK    ,  0x08
.set ADC_SC2_ACREN_SHIFT   ,  3
.set ADC_SC2_DMAEN_MASK    ,  0x04
.set ADC_SC2_DMAEN_SHIFT   ,  2
.set ADC_SC2_REFSEL_MASK   ,  0x03
.set ADC_SC2_REFSEL_SHIFT  ,  0
// ---------------------------------------------------------------
// ADC_SC3:  ADC status and control register 3
// 31-8:(reserved):read-only:0
//    7:CAL=calibration
//          write:0=(no effect)
//                1=start calibration sequence
//          read:0=calibration sequence complete
//               1=calibration sequence in progress
//    6:CALF=calibration failed flag
//  5-4:(reserved):read-only:0
//    3:ADC=ADC continuous conversion enable (if ADC_SC3.AVGE = 1)
//    2:AVGE=hardware average enable
//  1-0:AVGS=hardware average select:  2^(2+AVGS) samples
.set ADC_SC3_CAL_MASK    ,  0x80
.set ADC_SC3_CAL_SHIFT   ,  7
.set ADC_SC3_CALF_MASK   ,  0x40
.set ADC_SC3_CALF_SHIFT  ,  6
.set ADC_SC3_ADCO_MASK   ,  0x08
.set ADC_SC3_ADCO_SHIFT  ,  3
.set ADC_SC3_AVGE_MASK   ,  0x04
.set ADC_SC3_AVGE_SHIFT  ,  2
.set ADC_SC3_AVGS_MASK   ,  0x03
.set ADC_SC3_AVGS_SHIFT  ,  0
// ---------------------------------------------------------------
// CMP
.set CMP0_BASE          ,  0x40073000
// CMP_BASES          EQU  CMP0_BASE
.set CMP0_CR0_OFFSET    ,  0x00
.set CMP0_CR1_OFFSET    ,  0x01
.set CMP0_FPR_OFFSET    ,  0x02
.set CMP0_SCR_OFFSET    ,  0x03
.set CMP0_DACCR_OFFSET  ,  0x04
.set CMP0_MUXCR_OFFSET  ,  0x05
.set CMP0_CR0           ,  (CMP0_BASE + CMP0_CR0_OFFSET)
.set CMP0_CR1           ,  (CMP0_BASE + CMP0_CR1_OFFSET)
.set CMP0_FPR           ,  (CMP0_BASE + CMP0_FPR_OFFSET)
.set CMP0_SCR           ,  (CMP0_BASE + CMP0_SCR_OFFSET)
.set CMP0_DACCR         ,  (CMP0_BASE + CMP0_DACCR_OFFSET)
.set CMP0_MUXCR         ,  (CMP0_BASE + CMP0_MUXCR_OFFSET)
// ---------------------------------------------------------------
// CMP0_CR0:  CMP0 control register 0 (0x00)
//   7:(reserved):read-only:0
// 6-4:FILTER_CNT=filter sample count (00)
//   3:(reserved):read-only:0
//   2:(reserved):read-only:0
// 1-0:HYSTCTR=comparator hard block hysteresis control (00)
.set CMP_CR0_HYSTCTR_MASK      ,  0x3
.set CMP_CR0_HYSTCTR_SHIFT     ,  0
.set CMP_CR0_FILTER_CNT_MASK   ,  0x70
.set CMP_CR0_FILTER_CNT_SHIFT  ,  4
// ---------------------------------------------------------------
// CMP0_CR1:  CMP0 control register 1 (0x00)
// 7:SE=sample enable (0)
// 6:WE=windowing enable (0)
// 5:TRIGM=trigger mode enable (0)
// 4:PMODE=power mode select (0)
//         0=low-speed comparison mode
//         1=high-speed comparison mode
// 3:INV=comparator invert (0)
// 2:COS=comparator output select (0)
//       0=filtered output COUT
//       1=unfiltered output COUTA
// 1:OPE=comparator output pin enable (0)
// 0:EN=comparator module enable (0)
.set CMP_CR1_EN_MASK      ,  0x1
.set CMP_CR1_EN_SHIFT     ,  0
.set CMP_CR1_OPE_MASK     ,  0x2
.set CMP_CR1_OPE_SHIFT    ,  1
.set CMP_CR1_COS_MASK     ,  0x4
.set CMP_CR1_COS_SHIFT    ,  2
.set CMP_CR1_INV_MASK     ,  0x8
.set CMP_CR1_INV_SHIFT    ,  3
.set CMP_CR1_PMODE_MASK   ,  0x10
.set CMP_CR1_PMODE_SHIFT  ,  4
.set CMP_CR1_TRIGM_MASK   ,  0x20
.set CMP_CR1_TRIGM_SHIFT  ,  5
.set CMP_CR1_WE_MASK      ,  0x40
.set CMP_CR1_WE_SHIFT     ,  6
.set CMP_CR1_SE_MASK      ,  0x80
.set CMP_CR1_SE_SHIFT     ,  7
// ---------------------------------------------------------------
// CMP0_FPR=CMP filter period register (0x00)
// 7-0:FILT_PER=CMP filter period register (0x00)
.set CMP_FPR_FILT_PER_MASK   ,  0xFF
.set CMP_FPR_FILT_PER_SHIFT  ,  0
// ---------------------------------------------------------------
// CMP0_SCR=CMP status and control register (0x00)
// 7:(reserved):read-only:0
// 6:DMAEN=DMA enable control (0)
// 5:(reserved):read-only:0
// 4:IER=comparator interrupt enable rising (0)
// 3:IEF=comparator interrupt enable falling (0)
// 2:CFR=analog comparator flag rising: w1c (0)
// 1:CFF=analog comparator flag falling: w1c (0)
// 0:COUT=analog comparator output:  read-only (0)
.set CMP_SCR_COUT_MASK    ,  0x1
.set CMP_SCR_COUT_SHIFT   ,  0
.set CMP_SCR_CFF_MASK     ,  0x2
.set CMP_SCR_CFF_SHIFT    ,  1
.set CMP_SCR_CFR_MASK     ,  0x4
.set CMP_SCR_CFR_SHIFT    ,  2
.set CMP_SCR_IEF_MASK     ,  0x8
.set CMP_SCR_IEF_SHIFT    ,  3
.set CMP_SCR_IER_MASK     ,  0x10
.set CMP_SCR_IER_SHIFT    ,  4
.set CMP_SCR_DMAEN_MASK   ,  0x40
.set CMP_SCR_DMAEN_SHIFT  ,  6
// ---------------------------------------------------------------
// CMP0_DACCR=DAC control register (0x00)
//   7:DACEN=DAC enable (0)
//   6:VRSEL=supply voltage reference source select (0)
//           0=Selected from mux by Vin1
//           1=Selected from mux by Vin2
// 5-0:VOSEL=DAC output voltage select (00000)
//           DAC0 = (Vin / 64) x (VOSEL[5:0] + 1)
.set CMP_DACCR_VOSEL_MASK   ,  0x3F
.set CMP_DACCR_VOSEL_SHIFT  ,  0
.set CMP_DACCR_VRSEL_MASK   ,  0x40
.set CMP_DACCR_VRSEL_SHIFT  ,  6
.set CMP_DACCR_DACEN_MASK   ,  0x80
.set CMP_DACCR_DACEN_SHIFT  ,  7
// ---------------------------------------------------------------
// CMP0_MUXCR=MUX control register (0x00)
//   7:PSTM=pass through mode enable (0)
//   6:(reserved):read-only:0
// 5-3:PSEL=plus input mux control (000)
//          selects IN[PSEL]
// 2-0:MSEL=minus input mux control (000)
//          selects IN[MSEL]
.set CMP_MUXCR_MSEL_MASK   ,  0x7
.set CMP_MUXCR_MSEL_SHIFT  ,  0
.set CMP_MUXCR_PSEL_MASK   ,  0x38
.set CMP_MUXCR_PSEL_SHIFT  ,  3
.set CMP_MUXCR_PSTM_MASK   ,  0x80
.set CMP_MUXCR_PSTM_SHIFT  ,  7
// ---------------------------------------------------------------
// DAC
.set DAC0_BASE          ,  0x4003F000
// DAC_BASES          EQU  DAC0_BASE
// DAC0_DAT_OFFSET    EQU  0x00
.set DAC0_DAT0L_OFFSET  ,  0x00
.set DAC0_DAT0H_OFFSET  ,  0x01
.set DAC0_DAT1L_OFFSET  ,  0x02
.set DAC0_DAT1H_OFFSET  ,  0x03
// DAC0_RESERVED_0_OFFSET  EQU  0x04
.set DAC0_SR_OFFSET     ,  0x20
.set DAC0_C0_OFFSET     ,  0x21
.set DAC0_C1_OFFSET     ,  0x22
.set DAC0_C2_OFFSET     ,  0x23
// DAC0_DAT           EQU  (DAC0_BASE + DAC0_DAT_OFFSET)
.set DAC0_DAT0L         ,  (DAC0_BASE + DAC0_DAT0L_OFFSET)
.set DAC0_DAT0H         ,  (DAC0_BASE + DAC0_DAT0H_OFFSET)
.set DAC0_DAT1L         ,  (DAC0_BASE + DAC0_DAT1L_OFFSET)
.set DAC0_DAT1H         ,  (DAC0_BASE + DAC0_DAT1H_OFFSET)
// DAC0_RESERVED_0    EQU  (DAC0_BASE + DAC0_RESERVED_0_OFFSET)
.set DAC0_SR            ,  (DAC0_BASE + DAC0_SR_OFFSET)
.set DAC0_C0            ,  (DAC0_BASE + DAC0_C0_OFFSET)
.set DAC0_C1            ,  (DAC0_BASE + DAC0_C1_OFFSET)
.set DAC0_C2            ,  (DAC0_BASE + DAC0_C2_OFFSET)
// ---------------------------------------------------------------
// DAC_DAT0H:  DAC data high register 0
// If buffer not enabled, Vout = Vin * (1 + DATA[11:0])/4096.
// 7-4:(reserved):read-only:0
// 3-0:DATA1=DATA[11:8] (0000)
.set DAC_DAT0H_MASK   ,  0x0F
.set DAC_DAT0H_SHIFT  ,  0
// ---------------------------------------------------------------
// DAC_DAT0L:  DAC data low register 0
// If buffer not enabled, Vout = Vin * (1 + DATA[11:0])/4096.
// 7-0:DATA0=DATA[7:0] (00000000)
.set DAC_DAT0L_MASK   ,  0xFF
.set DAC_DAT0L_SHIFT  ,  0
// ---------------------------------------------------------------
// DAC_DAT1H:  DAC data high register 1
// If buffer not enabled, Vout = Vin * (1 + DATA[11:0])/4096.
// 7-4:(reserved):read-only:0
// 3-0:DATA1=DATA[11:8] (0000)
.set DAC_DAT1H_MASK   ,  0x0F
.set DAC_DAT1H_SHIFT  ,  0
// ---------------------------------------------------------------
// DAC_DAT1L:  DAC data low register 1
// If buffer not enabled, Vout = Vin * (1 + DATA[11:0])/4096.
// 7-0:DATA0=DATA[7:0] (00000000)
.set DAC_DAT1L_MASK   ,  0xFF
.set DAC_DAT1L_SHIFT  ,  0
// ;---------------------------------------------------------------
// ;DAC_DATH:  DAC data high registers
// ;If buffer not enabled, Vout = Vin * (1 + DATA[11:0])/4096.
// ;7-4:(reserved):read-only:0
// ;3-0:DATA1=DATA[11:8] (0000)
// DAC_DATH_DATA0_MASK   EQU  0x0F
// DAC_DATH_DATA0_SHIFT  EQU  0
// ;---------------------------------------------------------------
// ;DAC_DATL:  DAC data low registers
// ;If buffer not enabled, Vout = Vin * (1 + DATA[11:0])/4096.
// ;7-0:DATA0=DATA[7:0] (00000000)
// DAC_DATL_DATA0_MASK   EQU  0xFF
// DAC_DATL_DATA0_SHIFT  EQU  0
// ---------------------------------------------------------------
// DAC_C0:  DAC control register 0
// 7:DACEN=DAC enable (0)
// 6:DACRFS=DAC reference select (0)
//          0:DACREF_1=VREFH
//          1:DACREF_2=VDDA (best for ADC operation)
// 5:DACTRGSEL=DAC trigger select (0)
//             0:HW
//             1:SW
// 4:DACSWTRG=DAC software trigger (0)
//            active-high write-only field that reads 0
//            DACBFEN & DACTRGSEL:  writing 1 advances buffer pointer
// 3:LPEN=DAC low power control (0)
//        0:high-power mode
//        1:low-power mode
// 2:(reserved):read-only:0
// 1:DACBTIEN=DAC buffer read pointer top flag interrupt enable (0)
// 0:DACBBIEN=DAC buffer read pointer bottom flag interrupt enable (0)
.set DAC_C0_DACEN_MASK       ,  0x80
.set DAC_C0_DACEN_SHIFT      ,  7
.set DAC_C0_DACRFS_MASK      ,  0x40
.set DAC_C0_DACRFS_SHIFT     ,  6
.set DAC_C0_DACTRGSEL_MASK   ,  0x20
.set DAC_C0_DACTRGSEL_SHIFT  ,  5
.set DAC_C0_DACSWTRG_MASK    ,  0x10
.set DAC_C0_DACSWTRG_SHIFT   ,  4
.set DAC_C0_LPEN_MASK        ,  0x08
.set DAC_C0_LPEN_SHIFT       ,  3
.set DAC_C0_DACBTIEN_MASK    ,  0x02
.set DAC_C0_DACBTIEN_SHIFT   ,  1
.set DAC_C0_DACBBIEN_MASK    ,  0x01
.set DAC_C0_DACBBIEN_SHIFT   ,  0
// ---------------------------------------------------------------
// DAC_C1:  DAC control register 1
//   7:DMAEN=DMA enable select (0)
// 6-3:(reserved):read-only:0000
//   2:DACBFMD=DAC buffer work mode select (0)
//             0:normal
//             1:one-time scan
//   1:(reserved):read-only:0
//   0:DACBFEN=DAC buffer enable (0)
//             0:disabled:data in first word of buffer
//             1:enabled:read pointer points to data
.set DAC_C1_DMAEN_MASK       ,  0x80
.set DAC_C1_DMAEN_SHIFT      ,  7
.set DAC_C1_DACBFMD_MASK     ,  0x04
.set DAC_C1_DACBFMD_SHIFT    ,  2
.set DAC_C1_DACBFEN_MASK     ,  0x01
.set DAC_C1_DACBFEN_SHIFT    ,  0
// ---------------------------------------------------------------
// DAC_C2:  DAC control register 2
// 7-5:(reserved):read-only:0
//   4:DACBFRP=DAC buffer read pointer (0)
// 3-1:(reserved):read-only:0
//   0:DACBFUP=DAC buffer read upper limit (1)
.set DAC_C2_DACBFRP_MASK   ,  0x10
.set DAC_C2_DACBFRP_SHIFT  ,  4
.set DAC_C2_DACBFUP_MASK   ,  0x01
.set DAC_C2_DACBFUP_SHIFT  ,  0
// ---------------------------------------------------------------
// DAC_SR:  DAC status register
// Writing 0 clears a field; writing 1 has no effect.
// 7-2:(reserved):read-only:000000
// 1:DACBFRPTF=DAC buffer read pointer top position flag (1)
//             Indicates whether pointer is zero
// 0:DACBFRPBF=DAC buffer read pointer bottom position flag (0)
//             Indicates whether pointer is equal to DAC0_C2.DACBFUP.
.set DAC_SR_DACBFRPTF_MASK   , 0x02
.set DAC_SR_DACBFRPTF_SHIFT  , 1
.set DAC_SR_DACBFRPBF_MASK   , 0x01
.set DAC_SR_DACBFRPBF_SHIFT  , 0
// ---------------------------------------------------------------
// Flash Configuration Field (FCF) 0x400-0x40F
// Following [6, 7]
// 16-byte flash configuration field that stores default protection settings
// (loaded on reset) and security information that allows the MCU to 
// restrict acces to the FTFL module.
// FCF Backdoor Comparison Key
// 8 bytes from 0x400-0x407
// -----------------------------------------------------
// FCF Backdoor Comparison Key 0
// 7-0:Backdoor Key 0
.set FCF_BACKDOOR_KEY0  ,  0xFF
.set BackDoorK0         ,  0xFF
// -----------------------------------------------------
// FCF Backdoor Comparison Key 1
// 7-0:Backdoor Key 1
.set FCF_BACKDOOR_KEY1  ,  0xFF
.set BackDoorK1         ,  0xFF
// -----------------------------------------------------
// FCF Backdoor Comparison Key 2
// 7-0:Backdoor Key 2
.set FCF_BACKDOOR_KEY2  ,  0xFF
.set BackDoorK2         ,  0xFF
// -----------------------------------------------------
// FCF Backdoor Comparison Key 3
// 7-0:Backdoor Key 3
.set FCF_BACKDOOR_KEY3  ,  0xFF
.set BackDoorK3         ,  0xFF
// -----------------------------------------------------
// FCF Backdoor Comparison Key 4
// 7-0:Backdoor Key 4
.set FCF_BACKDOOR_KEY4  ,  0xFF
.set BackDoorK4         ,  0xFF
// -----------------------------------------------------
// FCF Backdoor Comparison Key 5
// 7-0:Backdoor Key 5
.set FCF_BACKDOOR_KEY5  ,  0xFF
.set BackDoorK5         ,  0xFF
// -----------------------------------------------------
// FCF Backdoor Comparison Key 6
// 7-0:Backdoor Key 6
.set FCF_BACKDOOR_KEY6  ,  0xFF
.set BackDoorK6         ,  0xFF
// -----------------------------------------------------
// FCF Backdoor Comparison Key 7
// 7-0:Backdoor Key 7
.set FCF_BACKDOOR_KEY7  ,  0xFF
.set BackDoorK7         ,  0xFF
// -----------------------------------------------------
// FCF Flash nonvolatile option byte (FCF_FOPT)
// Allows user to customize operation of the MCU at boot time.
// 7-6:11:(reserved)
//   5: 1:FAST_INIT=fast initialization
// 4,0:11:LPBOOT=core and system clock divider:  2^(3-LPBOOT)
//   3: 1:RESET_PIN_CFG=enable reset pin following POR
//   2: 1:NMI_DIS=Enable NMI
//   1: 1:(reserved)
//   0:(see bit 4 above)
.set FCF_FOPT  ,  0xFF
.set FOPT      ,  0xFF
// -----------------------------------------------------
// FCF Program flash protection bytes (FCF_FPROT)
// Each program flash region can be protected from program and erase 
// operation by setting the associated PROT bit.  Each bit protects a 
// 1/32 region of the program flash memory.
// FCF FPROT0
// 7:1:FCF_PROT7=Program flash region 7/32 not protected
// 6:1:FCF_PROT6=Program flash region 6/32 not protected
// 5:1:FCF_PROT5=Program flash region 5/32 not protected
// 4:1:FCF_PROT4=Program flash region 4/32 not protected
// 3:1:FCF_PROT3=Program flash region 3/32 not protected
// 2:1:FCF_PROT2=Program flash region 2/32 not protected
// 1:1:FCF_PROT1=Program flash region 1/32 not protected
// 0:1:FCF_PROT0=Program flash region 0/32 not protected
.set FCF_FPROT0  ,  0xFF
.set nFPROT0     ,  0x00
.set FPROT0      ,  nFPROT0 ^ 0xFF
// -----------------------------------------------------
// FCF FPROT1
// 7:1:FCF_PROT15=Program flash region 15/32 not protected
// 6:1:FCF_PROT14=Program flash region 14/32 not protected
// 5:1:FCF_PROT13=Program flash region 13/32 not protected
// 4:1:FCF_PROT12=Program flash region 12/32 not protected
// 3:1:FCF_PROT11=Program flash region 11/32 not protected
// 2:1:FCF_PROT10=Program flash region 10/32 not protected
// 1:1:FCF_PROT9=Program flash region 9/32 not protected
// 0:1:FCF_PROT8=Program flash region 8/32 not protected
.set FCF_FPROT1  ,  0xFF
.set nFPROT1     ,  0x00
.set FPROT1      ,  nFPROT1 ^ 0xFF
// -----------------------------------------------------
// FCF FPROT2
// 7:1:FCF_PROT23=Program flash region 23/32 not protected
// 6:1:FCF_PROT22=Program flash region 22/32 not protected
// 5:1:FCF_PROT21=Program flash region 21/32 not protected
// 4:1:FCF_PROT20=Program flash region 20/32 not protected
// 3:1:FCF_PROT19=Program flash region 19/32 not protected
// 2:1:FCF_PROT18=Program flash region 18/32 not protected
// 1:1:FCF_PROT17=Program flash region 17/32 not protected
// 0:1:FCF_PROT16=Program flash region 16/32 not protected
.set FCF_FPROT2  ,  0xFF
.set nFPROT2     ,  0x00
.set FPROT2      ,  nFPROT2 ^ 0xFF
// -----------------------------------------------------
// FCF FPROT3
// 7:1:FCF_PROT31=Program flash region 31/32 not protected
// 6:1:FCF_PROT30=Program flash region 30/32 not protected
// 5:1:FCF_PROT29=Program flash region 29/32 not protected
// 4:1:FCF_PROT28=Program flash region 28/32 not protected
// 3:1:FCF_PROT27=Program flash region 27/32 not protected
// 2:1:FCF_PROT26=Program flash region 26/32 not protected
// 1:1:FCF_PROT25=Program flash region 25/32 not protected
// 0:1:FCF_PROT24=Program flash region 24/32 not protected
.set FCF_FPROT3  ,  0xFF
.set nFPROT3     ,  0x00
.set FPROT3      ,  nFPROT3 ^ 0xFF
// -----------------------------------------------------
// FCF Flash security byte (FCF_FSEC)
// WARNING: If SEC field is configured as "MCU security status is 
// secure" and MEEN field is configured as "Mass erase is disabled",
// MCU's security status cannot be set back to unsecure state since 
// mass erase via the debugger is blocked !!!
// 7-6:01:KEYEN=backdoor key security enable
//             :00=Backdoor key access disabled
//             :01=Backdoor key access disabled (preferred value)
//             :10=Backdoor key access enabled
//             :11=Backdoor key access disabled
// 5-4:11:MEEN=mass erase enable bits
//            (does not matter if SEC unsecure)
//            :00=mass erase enabled
//            :01=mass erase enabled
//            :10=mass erase disabled
//            :11=mass erase enabled
// 3-2:11:FSLACC=Freescale failure analysis access code
//              (does not matter if SEC unsecure)
//              :00=Freescale factory access granted
//              :01=Freescale factory access denied
//              :10=Freescale factory access denied
//              :11=Freescale factory access granted
// 1-0:10:SEC=flash security
//           :00=MCU secure
//           :01=MCU secure
//           :10=MCU unsecure (standard value)
//           :11=MCU secure
.set FCF_FSEC  ,  0x7E
.set FSEC      ,  0xFE
// ---------------------------------------------------------------
// Fast (zero wait state) GPIO (FGPIO) or (IOPORT)
// FGPIOx_PDD:  Port x Data Direction Register
//   Bit n:  0=Port x pin n configured as input
//           1=Port x pin n configured as output
// FGPIOx_PDIR:  Port x Data Input Register
//   Bit n:  Value read from Port x pin n (if input pin)
// FGPIOx_PDOR:  Port x Data Output Register
//   Bit n:  Value written to Port x pin n (if output pin)
// FGPIOx_PoOR: Port x operation o direction x Register
//   Operation o:  C=Clear (clear to 0)
//                 S=Set (set to 1)
//                 T=Toggle (complement)
//   Bit n:  0=Port x pin n not affected
//           1=Port x pin n affected
.set FGPIO_BASE         ,  0xF80FF000
.set FGPIO_PDOR_OFFSET  ,  0x00
.set FGPIO_PSOR_OFFSET  ,  0x04
.set FGPIO_PCOR_OFFSET  ,  0x08
.set FGPIO_PTOR_OFFSET  ,  0x0C
.set FGPIO_PDIR_OFFSET  ,  0x10
.set FGPIO_PDDR_OFFSET  ,  0x14
// FGPIOx not present in MKL05Z4.h:  FPTx instead
// FGPIOx included for compatibility with MKL46Z4.h
// Fast Port A
.set FGPIOA_BASE        ,  0xF80FF000
.set FGPIOA_PDOR        ,  (FGPIOA_BASE + GPIO_PDOR_OFFSET)
.set FGPIOA_PSOR        ,  (FGPIOA_BASE + GPIO_PSOR_OFFSET)
.set FGPIOA_PCOR        ,  (FGPIOA_BASE + GPIO_PCOR_OFFSET)
.set FGPIOA_PTOR        ,  (FGPIOA_BASE + GPIO_PTOR_OFFSET)
.set FGPIOA_PDIR        ,  (FGPIOA_BASE + GPIO_PDIR_OFFSET)
.set FGPIOA_PDDR        ,  (FGPIOA_BASE + GPIO_PDDR_OFFSET)
// Fast Port B
.set FGPIOB_BASE        ,  0xF80FF040
.set FGPIOB_PDOR        ,  (FGPIOB_BASE + GPIO_PDOR_OFFSET)
.set FGPIOB_PSOR        ,  (FGPIOB_BASE + GPIO_PSOR_OFFSET)
.set FGPIOB_PCOR        ,  (FGPIOB_BASE + GPIO_PCOR_OFFSET)
.set FGPIOB_PTOR        ,  (FGPIOB_BASE + GPIO_PTOR_OFFSET)
.set FGPIOB_PDIR        ,  (FGPIOB_BASE + GPIO_PDIR_OFFSET)
.set FGPIOB_PDDR        ,  (FGPIOB_BASE + GPIO_PDDR_OFFSET)
// Fast GPIO
// FGPIO_BASES        EQU  FGPIOA_BASE
// ---------------------------------------------------------------
// FPTx not present in MKL46Z4.h
// Fast (zero wait state) general-purpose input and output (FPTx)
// FPTx_PDD:  Port x Data Direction Register
//   Bit n:  0=Port x pin n configured as input
//           1=Port x pin n configured as output
// FPTx_PDIR:  Port x Data Input Register
//   Bit n:  Value read from Port x pin n (if input pin)
// FPTx_PDOR:  Port x Data Output Register
//   Bit n:  Value written to Port x pin n (if output pin)
// FPTx_PoOR: Port x operation o direction x Register
//   Operation o:  C=Clear (clear to 0)
//                 S=Set (set to 1)
//                 T=Toggle (complement)
//   Bit n:  0=Port x pin n not affected
//           1=Port x pin n affected
.set FPT_BASE         ,  0xF80FF000
.set FPT_PDOR_OFFSET  ,  0x00
.set FPT_PSOR_OFFSET  ,  0x04
.set FPT_PCOR_OFFSET  ,  0x08
.set FPT_PTOR_OFFSET  ,  0x0C
.set FPT_PDIR_OFFSET  ,  0x10
.set FPT_PDDR_OFFSET  ,  0x14
.set FPTA_OFFSET      ,  0x00
.set FPTB_OFFSET      ,  0x40
// Fast Port A (FPTA)
.set FPTA_BASE        ,  0xF80FF000
.set FPTA_PSOR        ,  (FPTA_BASE + FPT_PSOR_OFFSET)
.set FPTA_PDOR        ,  (FPTA_BASE + FPT_PDOR_OFFSET)
.set FPTA_PCOR        ,  (FPTA_BASE + FPT_PCOR_OFFSET)
.set FPTA_PTOR        ,  (FPTA_BASE + FPT_PTOR_OFFSET)
.set FPTA_PDIR        ,  (FPTA_BASE + FPT_PDIR_OFFSET)
.set FPTA_PDDR        ,  (FPTA_BASE + FPT_PDDR_OFFSET)
// Fast Port B (FPTB)
.set FPTB_BASE        ,  0xF80FF040
.set FPTB_PDOR        ,  (FPTB_BASE + FPT_PDOR_OFFSET)
.set FPTB_PSOR        ,  (FPTB_BASE + FPT_PSOR_OFFSET)
.set FPTB_PCOR        ,  (FPTB_BASE + FPT_PCOR_OFFSET)
.set FPTB_PTOR        ,  (FPTB_BASE + FPT_PTOR_OFFSET)
.set FPTB_PDIR        ,  (FPTB_BASE + FPT_PDIR_OFFSET)
.set FPTB_PDDR        ,  (FPTB_BASE + FPT_PDDR_OFFSET)
// ---------------------------------------------------------------
// Flash configuration field
// Nonvolatile (NV) Peripheral access layer
// Following [3]
.set FTFA_FlashConfig_BASE             ,  0x400
.set FTFA_FlashConfig_BACKKEY3_OFFSET  ,  0x0
.set FTFA_FlashConfig_BACKKEY2_OFFSET  ,  0x1
.set FTFA_FlashConfig_BACKKEY1_OFFSET  ,  0x2
.set FTFA_FlashConfig_BACKKEY0_OFFSET  ,  0x3
.set FTFA_FlashConfig_BACKKEY7_OFFSET  ,  0x4
.set FTFA_FlashConfig_BACKKEY6_OFFSET  ,  0x5
.set FTFA_FlashConfig_BACKKEY5_OFFSET  ,  0x6
.set FTFA_FlashConfig_BACKKEY4_OFFSET  ,  0x7
.set FTFA_FlashConfig_FPROT3_OFFSET    ,  0x8
.set FTFA_FlashConfig_FPROT2_OFFSET    ,  0x9
.set FTFA_FlashConfig_FPROT1_OFFSET    ,  0xA
.set FTFA_FlashConfig_FPROT0_OFFSET    ,  0xB
.set FTFA_FlashConfig_FSEC_OFFSET      ,  0xC
.set FTFA_FlashConfig_FOPT_OFFSET      ,  0xD
.set FTFA_FlashConfig_BACKKEY3         ,  (FTFA_FlashConfig_BASE + FTFA_FlashConfig_BACKKEY3_OFFSET)
.set FTFA_FlashConfig_BACKKEY2         ,  (FTFA_FlashConfig_BASE + FTFA_FlashConfig_BACKKEY2_OFFSET)
.set FTFA_FlashConfig_BACKKEY1         ,  (FTFA_FlashConfig_BASE + FTFA_FlashConfig_BACKKEY1_OFFSET)
.set FTFA_FlashConfig_BACKKEY0         ,  (FTFA_FlashConfig_BASE + FTFA_FlashConfig_BACKKEY0_OFFSET)
.set FTFA_FlashConfig_BACKKEY7         ,  (FTFA_FlashConfig_BASE + FTFA_FlashConfig_BACKKEY7_OFFSET)
.set FTFA_FlashConfig_BACKKEY6         ,  (FTFA_FlashConfig_BASE + FTFA_FlashConfig_BACKKEY6_OFFSET)
.set FTFA_FlashConfig_BACKKEY5         ,  (FTFA_FlashConfig_BASE + FTFA_FlashConfig_BACKKEY5_OFFSET)
.set FTFA_FlashConfig_BACKKEY4         ,  (FTFA_FlashConfig_BASE + FTFA_FlashConfig_BACKKEY4_OFFSET)
.set FTFA_FlashConfig_FPROT3           ,  (FTFA_FlashConfig_BASE + FTFA_FlashConfig_FPROT3_OFFSET)
.set FTFA_FlashConfig_FPROT2           ,  (FTFA_FlashConfig_BASE + FTFA_FlashConfig_FPROT2_OFFSET)
.set FTFA_FlashConfig_FPROT1           ,  (FTFA_FlashConfig_BASE + FTFA_FlashConfig_FPROT1_OFFSET)
.set FTFA_FlashConfig_FPROT0           ,  (FTFA_FlashConfig_BASE + FTFA_FlashConfig_FPROT0_OFFSET)
.set FTFA_FlashConfig_FSEC             ,  (FTFA_FlashConfig_BASE + FTFA_FlashConfig_FSEC_OFFSET)
.set FTFA_FlashConfig_FOPT             ,  (FTFA_FlashConfig_BASE + FTFA_FlashConfig_FOPT_OFFSET)
// ---------------------------------------------------------------
// NV FCF Backdoor Comparison Key 3
.set FTFA_FlashConfig_BACKKEY3_KEY_MASK   ,  0xFF
.set FTFA_FlashConfig_BACKKEY3_KEY_SHIFT  ,  0
// ---------------------------------------------------------------
// NV FCF Backdoor Comparison Key 2
.set FTFA_FlashConfig_BACKKEY2_KEY_MASK   ,  0xFF
.set FTFA_FlashConfig_BACKKEY2_KEY_SHIFT  ,  0
// ---------------------------------------------------------------
// NV FCF Backdoor Comparison Key 1
.set FTFA_FlashConfig_BACKKEY1_KEY_MASK   ,  0xFF
.set FTFA_FlashConfig_BACKKEY1_KEY_SHIFT  ,  0
// ---------------------------------------------------------------
// NV FCF Backdoor Comparison Key 0
.set FTFA_FlashConfig_BACKKEY0_KEY_MASK   ,  0xFF
.set FTFA_FlashConfig_BACKKEY0_KEY_SHIFT  ,  0
// ---------------------------------------------------------------
// NV FCF Backdoor Comparison Key 7
.set FTFA_FlashConfig_BACKKEY7_KEY_MASK   ,  0xFF
.set FTFA_FlashConfig_BACKKEY7_KEY_SHIFT  ,  0
// ---------------------------------------------------------------
// NV FCF Backdoor Comparison Key 6
.set FTFA_FlashConfig_BACKKEY6_KEY_MASK   ,  0xFF
.set FTFA_FlashConfig_BACKKEY6_KEY_SHIFT  ,  0
// ---------------------------------------------------------------
// NV FCF Backdoor Comparison Key 5
.set FTFA_FlashConfig_BACKKEY5_KEY_MASK   ,  0xFF
.set FTFA_FlashConfig_BACKKEY5_KEY_SHIFT  ,  0
// ---------------------------------------------------------------
// NV FCF Backdoor Comparison Key 4
.set FTFA_FlashConfig_BACKKEY4_KEY_MASK   ,  0xFF
.set FTFA_FlashConfig_BACKKEY4_KEY_SHIFT  ,  0
// ---------------------------------------------------------------
// NV FCF Flash Program Protection Byte 3
.set FTFA_FlashConfig_FPROT3_PROT_MASK   ,  0xFF
.set FTFA_FlashConfig_FPROT3_PROT_SHIFT  ,  0
// ---------------------------------------------------------------
// NV FCF Flash Program Protection Byte 2
.set FTFA_FlashConfig_FPROT2_PROT_MASK   ,  0xFF
.set FTFA_FlashConfig_FPROT2_PROT_SHIFT  ,  0
// ---------------------------------------------------------------
// NV FCF Flash Program Protection Byte 1
.set FTFA_FlashConfig_FPROT1_PROT_MASK   ,  0xFF
.set FTFA_FlashConfig_FPROT1_PROT_SHIFT  ,  0
// ---------------------------------------------------------------
// NV FCF Flash Program Protection Byte 0
.set FTFA_FlashConfig_FPROT0_PROT_MASK   ,  0xFF
.set FTFA_FlashConfig_FPROT0_PROT_SHIFT  ,  0
// ---------------------------------------------------------------
// NV FCF Flash Security Register
// 7-6:KEYEN=backdoor key security enable
//          :00,01(preferred),11=backdoor key access disabled
//          :10=backdoor key access enabled
// 5-4:MEEN=mass erase enable bits
//         :00,01,11=mass erase enabled
//         :10=mass erase disabled
// 3-2:FSLACC=Freescale failure analysis access code
//           :00,11=Freescale factory access granted
//           :01,10=Freescale factory access denied
// 1-0:SEC=flash security
//        :00,01,11=secure
//        :10=unsecure (standard shipping condition)
.set FTFA_FlashConfig_FSEC_SEC_MASK      ,  0x3
.set FTFA_FlashConfig_FSEC_SEC_SHIFT     ,  0
.set FTFA_FlashConfig_FSEC_FSLACC_MASK   ,  0xC
.set FTFA_FlashConfig_FSEC_FSLACC_SHIFT  ,  2
.set FTFA_FlashConfig_FSEC_MEEN_MASK     ,  0x30
.set FTFA_FlashConfig_FSEC_MEEN_SHIFT    ,  4
.set FTFA_FlashConfig_FSEC_KEYEN_MASK    ,  0xC0
.set FTFA_FlashConfig_FSEC_KEYEN_SHIFT   ,  6
// ---------------------------------------------------------------
// NV FCF Flash Option Register
.set FTFA_FlashConfig_FOPT_LPBOOT0_MASK         ,  0x1
.set FTFA_FlashConfig_FOPT_LPBOOT0_SHIFT        ,  0
.set FTFA_FlashConfig_FOPT_NMI_DIS_MASK         ,  0x4
.set FTFA_FlashConfig_FOPT_NMI_DIS_SHIFT        ,  2
.set FTFA_FlashConfig_FOPT_RESET_PIN_CFG_MASK   ,  0x8
.set FTFA_FlashConfig_FOPT_RESET_PIN_CFG_SHIFT  ,  3
.set FTFA_FlashConfig_FOPT_LPBOOT1_MASK         ,  0x10
.set FTFA_FlashConfig_FOPT_LPBOOT1_SHIFT        ,  4
.set FTFA_FlashConfig_FOPT_FAST_INIT_MASK       ,  0x20
.set FTFA_FlashConfig_FOPT_FAST_INIT_SHIFT      ,  5
// ---------------------------------------------------------------
// General-purpose input and output (GPIO)
// GPIOx_PDD:  Port x Data Direction Register
//   Bit n:  0=Port x pin n configured as input
//           1=Port x pin n configured as output
// GPIOx_PDIR:  Port x Data Input Register
//   Bit n:  Value read from Port x pin n (if input pin)
// GPIOx_PDOR:  Port x Data Output Register
//   Bit n:  Value written to Port x pin n (if output pin)
// GPIOx_PoOR: Port x operation o direction x Register
//   Operation o:  C=Clear (clear to 0)
//                 S=Set (set to 1)
//                 T=Toggle (complement)
//   Bit n:  0=Port x pin n not affected
//           1=Port x pin n affected
.set GPIO_BASE         ,  0x400FF000
.set GPIO_PDOR_OFFSET  ,  0x00
.set GPIO_PSOR_OFFSET  ,  0x04
.set GPIO_PCOR_OFFSET  ,  0x08
.set GPIO_PTOR_OFFSET  ,  0x0C
.set GPIO_PDIR_OFFSET  ,  0x10
.set GPIO_PDDR_OFFSET  ,  0x14
// GPIOx not present in MKL05Z4.h:  PTx instead
// GPIOx included for compatibility with MKL46Z4.h
.set GPIOA_OFFSET      ,  0x00
.set GPIOB_OFFSET      ,  0x40
// Port A
.set GPIOA_BASE        ,  0x400FF000
.set GPIOA_PDOR        ,  (GPIOA_BASE + GPIO_PDOR_OFFSET)
.set GPIOA_PSOR        ,  (GPIOA_BASE + GPIO_PSOR_OFFSET)
.set GPIOA_PCOR        ,  (GPIOA_BASE + GPIO_PCOR_OFFSET)
.set GPIOA_PTOR        ,  (GPIOA_BASE + GPIO_PTOR_OFFSET)
.set GPIOA_PDIR        ,  (GPIOA_BASE + GPIO_PDIR_OFFSET)
.set GPIOA_PDDR        ,  (GPIOA_BASE + GPIO_PDDR_OFFSET)
// Port B
.set GPIOB_BASE        ,  0x400FF040
.set GPIOB_PDOR        ,  (GPIOB_BASE + GPIO_PDOR_OFFSET)
.set GPIOB_PSOR        ,  (GPIOB_BASE + GPIO_PSOR_OFFSET)
.set GPIOB_PCOR        ,  (GPIOB_BASE + GPIO_PCOR_OFFSET)
.set GPIOB_PTOR        ,  (GPIOB_BASE + GPIO_PTOR_OFFSET)
.set GPIOB_PDIR        ,  (GPIOB_BASE + GPIO_PDIR_OFFSET)
.set GPIOB_PDDR        ,  (GPIOB_BASE + GPIO_PDDR_OFFSET)
// ---------------------------------------------------------------
// IOPORT:  GPIO alias for zero wait state access to GPIO
// See FGPIO
// ---------------------------------------------------------------
// Multipurpose clock generator (MCG)
.set MCG_BASE          ,  0x40064000
.set MCG_C1_OFFSET     ,  0x00
.set MCG_C2_OFFSET     ,  0x01
.set MCG_C3_OFFSET     ,  0x02
.set MCG_C4_OFFSET     ,  0x03
.set MCG_C6_OFFSET     ,  0x05
.set MCG_S_OFFSET      ,  0x06
.set MCG_SC_OFFSET     ,  0x08
.set MCG_ATCVH_OFFSET  ,  0x0A
.set MCG_ATCVL_OFFSET  ,  0x0B
.set MCG_C1            ,  (MCG_BASE + MCG_C1_OFFSET)
.set MCG_C2            ,  (MCG_BASE + MCG_C2_OFFSET)
.set MCG_C3            ,  (MCG_BASE + MCG_C3_OFFSET)
.set MCG_C4            ,  (MCG_BASE + MCG_C4_OFFSET)
.set MCG_C6            ,  (MCG_BASE + MCG_C6_OFFSET)
.set MCG_S             ,  (MCG_BASE + MCG_S_OFFSET)
.set MCG_SC            ,  (MCG_BASE + MCG_SC_OFFSET)
.set MCG_ATCVH         ,  (MCG_BASE + MCG_ATCVH_OFFSET)
.set MCG_ATCVL         ,  (MCG_BASE + MCG_ATCVL_OFFSET)
// ---------------------------------------------------------------
// MCG_C1 MCG Control 1 Register(0x04)
// 7-6:CLKS=clock source select (00)
//         :00=output of FLL
//         :01=internal reference clock
//         :10=external reference clock
//         :11=(reserved)
// 5-3:FRDIV=FLL external reference divider (000)
//     (depends on MCG_C2.RANGE0)
//          :first divider is for RANGE0=0
//          :second divider is for all other RANGE0 values
//          :000=  1 or   32
//          :001=  2 or   64
//          :010=  4 or  128
//          :011=  8 or  256
//          :100= 16 or  512
//          :101= 32 or 1024
//          :110= 64 or 1280
//          :111=128 or 1536
//   2:IREFS=internal reference select (for FLL) (1)
//          :0=external reference clock
//          :1=slow internal reference clock
//   1:IRCLKEN=internal reference clock (MCGIRCLK) enable (0)
//   0:IREFSTEN=internal reference stop enable (0)
.set MCG_C1_CLKS_MASK       , 0xC0
.set MCG_C1_CLKS_SHIFT      , 6
.set MCG_C1_FRDIV_MASK      , 0x38
.set MCG_C1_FRDIV_SHIFT     , 3
.set MCG_C1_IREFS_MASK      , 0x04
.set MCG_C1_IREFS_SHIFT     , 2
.set MCG_C1_IRCLKEN_MASK    , 0x02
.set MCG_C1_IRCLKEN_SHIFT   , 1
.set MCG_C1_IREFSTEN_MASK   , 0x01
.set MCG_C1_IREFSTEN_SHIFT  , 0
// ---------------------------------------------------------------
// MCG_C2 MCG Control 2 Register(0xC0)
//   7:LOCRE0=loss of clock reset enable (1)
//           :0=interrupt request on loss of OCS0 external reference clock
//           :1=reset request on loss of OCS0 external reference clock
//   6:(reserved):read-only:0
// 5-4:RANGE0=frequency range select (00)
//           :00=low frequency range for crystal oscillator
//           :01=high frequency range for crystal oscillator
//           :1X=very high frequency range for crystal oscillator
//   3:HGO0=high gain oscillator select (0)
//         :0=low-power operation
//         :1=high-gain operation
//   2:EREFS0=external reference select (0)
//           :0=external reference clock
//           :1=oscillator
//   1:LP=low power select (0)
//       :0=FLL or PLL not disabled in bypass modes
//       :1=FLL or PLL disabled in bypass modes (lower power)
//   0:IRCS=internal reference clock select (0)
//         :0=slow internal reference clock
//         :1=fast internal reference clock
.set MCG_C2_LOCRE0_MASK        ,  0x80
.set MCG_C2_LOCRE0_SHIFT       ,  7
.set MCG_C2_RANGE0_MASK        ,  0x30
.set MCG_C2_RANGE0_SHIFT       ,  4
.set MCG_C2_HGO0_MASK          ,  0x08
.set MCG_C2_HGO0_SHIFT         ,  3
.set MCG_C2_EREFS0_MASK        ,  0x04
.set MCG_C2_EREFS0_SHIFT       ,  2
.set MCG_C2_LP_MASK            ,  0x02
.set MCG_C2_LP_SHIFT           ,  1
.set MCG_C2_IRCS_MASK          ,  0x01
.set MCG_C2_IRCS_SHIFT         ,  0
// ---------------------------------------------------------------
// MCG_C3 MCG Control 3 Register (0xXX)
// 7-0:SCTRIM=slow internal reference clock trim setting;
//            on reset, loaded with a factory trim value
.set MCG_C3_SCTRIM_MASK   ,  0xFF
.set MCG_C3_SCTRIM_SHIFT  ,  0
// ---------------------------------------------------------------
// MCG_C4 MCG Control 4 Register (2_000XXXXX)
//   7:DMX32=DCO maximum frequency with 32.768 kHz reference (0)
//          :0=default range of 25%
//          :1=fine-tuned for 32.768 kHz reference
// 6-5:DRST_DRS=DCO range select (00)
//             :00=low range (default)
//             :01=mid range
//             :10=mid-high range
//             :11=high range
// 4-1:FCTRIM=fast internal reference clock trim setting (XXXX)
//            on reset, loaded with a factory trim value
//   0:SCFTRIM=slow internal reference clock fine trim (X)
//            on reset, loaded with a factory trim value
.set MCG_C4_DMX32_MASK      ,  0x80
.set MCG_C4_DMX32_SHIFT     ,  7
.set MCG_C4_DRST_DRS_MASK   ,  0x60
.set MCG_C4_DRST_DRS_SHIFT  ,  5
.set MCG_C4_FCTRIM_MASK     ,  0x1E
.set MCG_C4_FCTRIM_SHIFT    ,  1
.set MCG_C4_SCFTRIM_MASK    ,  0x1
.set MCG_C4_SCFTRIM_SHIFT   ,  0
// ---------------------------------------------------------------
// MCG_C6 MCG Control 6 Register (0x00)
// 7-6:(reserved):read-only:00
//   5:CME=clock monitor enable (0)
// 4-0:(reserved):read-only:00000
.set MCG_C6_CME_MASK      ,  0x20
.set MCG_C6_CME_SHIFT     ,  5
// ---------------------------------------------------------------
// MCG_S MCG Status Register (0x10)
// 7-5:(reserved):read-only:000
//   4:IREFST=internal reference status (1)
//           :0=FLL source external
//           :1=FLL source internal
// 3-2:CLKST=clock mode status (00)
//          :00=FLL
//          :01=internal reference
//          :10=external reference
//          :11=(reserved)
//   1:OSCINIT0=OSC initialization (complete)
//   0:IRCST=internal reference clock status
//          :0=slow (32 kHz)
//          :1=fast (4 MHz)
.set MCG_S_IREFST_MASK      ,  0x10
.set MCG_S_IREFST_SHIFT     ,  4
.set MCG_S_CLKST_MASK       ,  0x0C
.set MCG_S_CLKST_SHIFT      ,  2
.set MCG_S_OSCINIT0_MASK    ,  0x02
.set MCG_S_OSCINIT0_SHIFT   ,  1
.set MCG_S_IRCST_MASK       ,  0x01
.set MCG_S_IRCST_SHIFT      ,  0
// ---------------------------------------------------------------
// MCG_SC:  MCG Status and Control Register (0x02)
//   7:ATME=automatic trim machine enable (0)
//   6:ATMS=automatic trim machine select (0)
//         :0=32-kHz internal reference clock
//         :1=4-MHz internal reference clock
//   5:ATMF=automatic trim machine fail flag (read only) (0)
//   4:FLTPRSRV=FLL filter preserve enable (0)
// 3-1:FCRDIV=fast clock internal reference divider (001)
//           :000=  1
//           :001=  2
//           :010=  4
//           :011=  8
//           :100= 16
//           :101= 32
//           :110= 64
//           :111=128
//   0:LOCS0=OSC0 loss of clock status (0)
.set MCG_SC_ATME_MASK       ,  0x80
.set MCG_SC_ATME_SHIFT      ,  7
.set MCG_SC_ATMS_MASK       ,  0x40
.set MCG_SC_ATMS_SHIFT      ,  6
.set MCG_SC_ATMF_MASK       ,  0x20
.set MCG_SC_ATMF_SHIFT      ,  5
.set MCG_SC_FLTPRSRV_MASK   ,  0x10
.set MCG_SC_FLTPRSRV_SHIFT  ,  4
.set MCG_SC_FCRDIV_MASK     ,  0xE
.set MCG_SC_FCRDIV_SHIFT    ,  1
.set MCG_SC_LOCS0_MASK      ,  0x01
.set MCG_SC_LOCS0_SHIFT     ,  0
// ---------------------------------------------------------------
// MCG_ATCVH:  MCG Auto Trim Compare Value High Register (0x00)
// 7-0:ATCVH=Auto trim machine compare value high (0x00)
.set MCG_ATCVH_ATCVH_MASK   ,  0xFF
.set MCG_ATCVH_ATCVH_SHIFT  ,  0
// ---------------------------------------------------------------
// MCG_ATCVL:  MCG Auto Trim Compare Value Low Register (0x00)
// 7-0:ATCVL=Auto trim machine compare value low (0x00)
.set MCG_ATCVL_ATCVL_MASK   ,  0xFF
.set MCG_ATCVL_ATCVL_SHIFT  ,  0
// ---------------------------------------------------------------
// Nonvolatile (flash configuration field)
// NV Peripheral access layer
// Following [3]
.set NV_BASE             ,  0x400
.set NV_BACKKEY3_OFFSET  ,  0x0
.set NV_BACKKEY2_OFFSET  ,  0x1
.set NV_BACKKEY1_OFFSET  ,  0x2
.set NV_BACKKEY0_OFFSET  ,  0x3
.set NV_BACKKEY7_OFFSET  ,  0x4
.set NV_BACKKEY6_OFFSET  ,  0x5
.set NV_BACKKEY5_OFFSET  ,  0x6
.set NV_BACKKEY4_OFFSET  ,  0x7
.set NV_FPROT3_OFFSET    ,  0x8
.set NV_FPROT2_OFFSET    ,  0x9
.set NV_FPROT1_OFFSET    ,  0xA
.set NV_FPROT0_OFFSET    ,  0xB
.set NV_FSEC_OFFSET      ,  0xC
.set NV_FOPT_OFFSET      ,  0xD
.set NV_BACKKEY3         ,  (NV_BASE + NV_BACKKEY3_OFFSET)
.set NV_BACKKEY2         ,  (NV_BASE + NV_BACKKEY2_OFFSET)
.set NV_BACKKEY1         ,  (NV_BASE + NV_BACKKEY1_OFFSET)
.set NV_BACKKEY0         ,  (NV_BASE + NV_BACKKEY0_OFFSET)
.set NV_BACKKEY7         ,  (NV_BASE + NV_BACKKEY7_OFFSET)
.set NV_BACKKEY6         ,  (NV_BASE + NV_BACKKEY6_OFFSET)
.set NV_BACKKEY5         ,  (NV_BASE + NV_BACKKEY5_OFFSET)
.set NV_BACKKEY4         ,  (NV_BASE + NV_BACKKEY4_OFFSET)
.set NV_FPROT3           ,  (NV_BASE + NV_FPROT3_OFFSET)
.set NV_FPROT2           ,  (NV_BASE + NV_FPROT2_OFFSET)
.set NV_FPROT1           ,  (NV_BASE + NV_FPROT1_OFFSET)
.set NV_FPROT0           ,  (NV_BASE + NV_FPROT0_OFFSET)
.set NV_FSEC             ,  (NV_BASE + NV_FSEC_OFFSET)
.set NV_FOPT             ,  (NV_BASE + NV_FOPT_OFFSET)
// ---------------------------------------------------------------
// NV FCF Backdoor Comparison Key 3
.set NV_BACKKEY3_KEY_MASK   ,  0xFF
.set NV_BACKKEY3_KEY_SHIFT  ,  0
// ---------------------------------------------------------------
// NV FCF Backdoor Comparison Key 2
.set NV_BACKKEY2_KEY_MASK   ,  0xFF
.set NV_BACKKEY2_KEY_SHIFT  ,  0
// ---------------------------------------------------------------
// NV FCF Backdoor Comparison Key 1
.set NV_BACKKEY1_KEY_MASK   ,  0xFF
.set NV_BACKKEY1_KEY_SHIFT  ,  0
// ---------------------------------------------------------------
// NV FCF Backdoor Comparison Key 0
.set NV_BACKKEY0_KEY_MASK   ,  0xFF
.set NV_BACKKEY0_KEY_SHIFT  ,  0
// ---------------------------------------------------------------
// NV FCF Backdoor Comparison Key 7
.set NV_BACKKEY7_KEY_MASK   ,  0xFF
.set NV_BACKKEY7_KEY_SHIFT  ,  0
// ---------------------------------------------------------------
// NV FCF Backdoor Comparison Key 6
.set NV_BACKKEY6_KEY_MASK   ,  0xFF
.set NV_BACKKEY6_KEY_SHIFT  ,  0
// ---------------------------------------------------------------
// NV FCF Backdoor Comparison Key 5
.set NV_BACKKEY5_KEY_MASK   ,  0xFF
.set NV_BACKKEY5_KEY_SHIFT  ,  0
// ---------------------------------------------------------------
// NV FCF Backdoor Comparison Key 4
.set NV_BACKKEY4_KEY_MASK   ,  0xFF
.set NV_BACKKEY4_KEY_SHIFT  ,  0
// ---------------------------------------------------------------
// NV FCF Flash Program Protection Byte 3
.set NV_FPROT3_PROT_MASK   ,  0xFF
.set NV_FPROT3_PROT_SHIFT  ,  0
// ---------------------------------------------------------------
// NV FCF Flash Program Protection Byte 2
.set NV_FPROT2_PROT_MASK   ,  0xFF
.set NV_FPROT2_PROT_SHIFT  ,  0
// ---------------------------------------------------------------
// NV FCF Flash Program Protection Byte 1
.set NV_FPROT1_PROT_MASK   ,  0xFF
.set NV_FPROT1_PROT_SHIFT  ,  0
// ---------------------------------------------------------------
// NV FCF Flash Program Protection Byte 0
.set NV_FPROT0_PROT_MASK   ,  0xFF
.set NV_FPROT0_PROT_SHIFT  ,  0
// ---------------------------------------------------------------
// NV FCF Flash Security Register
// 7-6:KEYEN=backdoor key security enable
//          :00,01(preferred),11=backdoor key access disabled
//          :10=backdoor key access enabled
// 5-4:MEEN=mass erase enable bits
//         :00,01,11=mass erase enabled
//         :10=mass erase disabled
// 3-2:FSLACC=Freescale failure analysis access code
//           :00,11=Freescale factory access granted
//           :01,10=Freescale factory access denied
// 1-0:SEC=flash security
//        :00,01,11=secure
//        :10=unsecure (standard shipping condition)
.set NV_FSEC_SEC_MASK      ,  0x3
.set NV_FSEC_SEC_SHIFT     ,  0
.set NV_FSEC_FSLACC_MASK   ,  0xC
.set NV_FSEC_FSLACC_SHIFT  ,  2
.set NV_FSEC_MEEN_MASK     ,  0x30
.set NV_FSEC_MEEN_SHIFT    ,  4
.set NV_FSEC_KEYEN_MASK    ,  0xC0
.set NV_FSEC_KEYEN_SHIFT   ,  6
// ---------------------------------------------------------------
// NV FCF Flash Option Register
.set NV_FOPT_LPBOOT0_MASK         ,  0x1
.set NV_FOPT_LPBOOT0_SHIFT        ,  0
.set NV_FOPT_NMI_DIS_MASK         ,  0x4
.set NV_FOPT_NMI_DIS_SHIFT        ,  2
.set NV_FOPT_RESET_PIN_CFG_MASK   ,  0x8
.set NV_FOPT_RESET_PIN_CFG_SHIFT  ,  3
.set NV_FOPT_LPBOOT1_MASK         ,  0x10
.set NV_FOPT_LPBOOT1_SHIFT        ,  4
.set NV_FOPT_FAST_INIT_MASK       ,  0x20
.set NV_FOPT_FAST_INIT_SHIFT      ,  5
// ---------------------------------------------------------------
// Nested vectored interrupt controller (NVIC)
// Part of system control space (SCS)
.set NVIC_BASE         ,  0xE000E100
.set NVIC_ISER_OFFSET  ,  0x00
.set NVIC_ICER_OFFSET  ,  0x80
.set NVIC_ISPR_OFFSET  ,  0x100
.set NVIC_ICPR_OFFSET  ,  0x180
.set NVIC_IPR0_OFFSET  ,  0x300
.set NVIC_IPR1_OFFSET  ,  0x304
.set NVIC_IPR2_OFFSET  ,  0x308
.set NVIC_IPR3_OFFSET  ,  0x30C
.set NVIC_IPR4_OFFSET  ,  0x310
.set NVIC_IPR5_OFFSET  ,  0x314
.set NVIC_IPR6_OFFSET  ,  0x318
.set NVIC_IPR7_OFFSET  ,  0x31C
.set NVIC_ISER         ,  (NVIC_BASE + NVIC_ISER_OFFSET)
.set NVIC_ICER         ,  (NVIC_BASE + NVIC_ICER_OFFSET)
.set NVIC_ISPR         ,  (NVIC_BASE + NVIC_ISPR_OFFSET)
.set NVIC_ICPR         ,  (NVIC_BASE + NVIC_ICPR_OFFSET)
.set NVIC_IPR0         ,  (NVIC_BASE + NVIC_IPR0_OFFSET)
.set NVIC_IPR1         ,  (NVIC_BASE + NVIC_IPR1_OFFSET)
.set NVIC_IPR2         ,  (NVIC_BASE + NVIC_IPR2_OFFSET)
.set NVIC_IPR3         ,  (NVIC_BASE + NVIC_IPR3_OFFSET)
.set NVIC_IPR4         ,  (NVIC_BASE + NVIC_IPR4_OFFSET)
.set NVIC_IPR5         ,  (NVIC_BASE + NVIC_IPR5_OFFSET)
.set NVIC_IPR6         ,  (NVIC_BASE + NVIC_IPR6_OFFSET)
.set NVIC_IPR7         ,  (NVIC_BASE + NVIC_IPR7_OFFSET)
// ---------------------------------------------------------------
// NVIC IPR assignments
.set DMA0_IPR         ,  NVIC_IPR0  // DMA channel 0 transfer complete/error interrupt
.set DMA1_IPR         ,  NVIC_IPR0  // DMA channel 1 transfer complete/error interrupt
.set DMA2_IPR         ,  NVIC_IPR0  // DMA channel 2 transfer complete/error interrupt
.set DMA3_IPR         ,  NVIC_IPR0  // DMA channel 3 transfer complete/error interrupt
.set Reserved20_IPR   ,  NVIC_IPR1  // Reserved interrupt 20
.set FTFA_IPR         ,  NVIC_IPR1  // FTFA command complete/read collision interrupt
.set LVD_LVW_IPR      ,  NVIC_IPR1  // Low-voltage detect, low-voltage warning interrupt
.set LLW_IPR          ,  NVIC_IPR1  // Low leakage wakeup interrupt
.set I2C0_IPR         ,  NVIC_IPR2  // I2C0 interrupt
.set Reserved25_IPR   ,  NVIC_IPR2  // Reserved interrupt 25
.set SPI0_IPR         ,  NVIC_IPR2  // SPI0 interrupt
.set Reserved27_IPR   ,  NVIC_IPR2  // Reserved interrupt 27
.set UART0_IPR        ,  NVIC_IPR3  // UART0 status/error interrupt
.set Reserved29_IPR   ,  NVIC_IPR3  // Reserved interrupt 29
.set Reserved30_IPR   ,  NVIC_IPR3  // Reserved interrupt 30
.set ADC0_IPR         ,  NVIC_IPR3  // ADC0 interrupt
.set CMP0_IPR         ,  NVIC_IPR4  // CMP0 interrupt
.set TPM0_IPR         ,  NVIC_IPR4  // TPM0 fault, overflow, and channels interrupt
.set TPM1_IPR         ,  NVIC_IPR4  // TPM1 fault, overflow, and channels interrupt
.set Reserved35_IPR   ,  NVIC_IPR4  // Reserved interrupt 35
.set RTC_IPR          ,  NVIC_IPR5  // RTC alarm interrupt
.set RTC_Seconds_IPR  ,  NVIC_IPR5  // RTC seconds interrupt
.set PIT_IPR          ,  NVIC_IPR5  // PIT interrupt
.set Reserved39_IPR   ,  NVIC_IPR5  // Reserved interrupt 39
.set Reserved40_IPR   ,  NVIC_IPR6  // Reserved interrupt 40
.set DAC0_IPR         ,  NVIC_IPR6  // DAC0 interrupt
.set TSI0_IPR         ,  NVIC_IPR6  // TSI0 interrupt
.set MCG_IPR          ,  NVIC_IPR6  // MCG interrupt
.set LPTimer_IPR      ,  NVIC_IPR7  // LPTMR0 interrupt
.set Reserved45_IPR   ,  NVIC_IPR7  // Reserved interrupt 45
.set PORTA_IPR        ,  NVIC_IPR7  // Port A interrupt
.set PORTB_IPR        ,  NVIC_IPR7  // Port B interrupt
// ---------------------------------------------------------------
// NVIC IPR position
// priority is a 2-bit value (0-3)
// position EQUates are for LSB of priority
.set DMA0_PRI_POS         ,   (8 -__NVIC_PRIO_BITS)  // DMA channel 0 transfer complete/error interrupt
.set DMA1_PRI_POS         ,  (16 -__NVIC_PRIO_BITS)  // DMA channel 1 transfer complete/error interrupt
.set DMA2_PRI_POS         ,  (24 -__NVIC_PRIO_BITS)  // DMA channel 2 transfer complete/error interrupt
.set DMA3_PRI_POS         ,  (32 -__NVIC_PRIO_BITS)  // DMA channel 3 transfer complete/error interrupt
.set Reserved20_PRI_POS   ,   (8 -__NVIC_PRIO_BITS)  // Reserved interrupt 20
.set FTFA_PRI_POS         ,  (16 -__NVIC_PRIO_BITS)  // FTFA command complete/read collision interrupt
.set LVD_LVW_PRI_POS      ,  (24 -__NVIC_PRIO_BITS)  // Low-voltage detect, low-voltage warning interrupt
.set LLW_PRI_POS          ,  (32 -__NVIC_PRIO_BITS)  // Low leakage wakeup interrupt
.set I2C0_PRI_POS         ,   (8 -__NVIC_PRIO_BITS)  // I2C0 interrupt
.set Reserved25_PRI_POS   ,  (16 -__NVIC_PRIO_BITS)  // Reserved interrupt 25
.set SPI0_PRI_POS         ,  (24 -__NVIC_PRIO_BITS)  // SPI0 interrupt
.set Reserved27_PRI_POS   ,  (32 -__NVIC_PRIO_BITS)  // Reserved interrupt 27
.set UART0_PRI_POS        ,   (8 -__NVIC_PRIO_BITS)  // UART0 status/error interrupt
.set Reserved29_PRI_POS   ,  (16 -__NVIC_PRIO_BITS)  // Reserved interrupt 29
.set Reserved30_PRI_POS   ,  (24 -__NVIC_PRIO_BITS)  // Reserved interrupt 30
.set ADC0_PRI_POS         ,  (32 -__NVIC_PRIO_BITS)  // ADC0 interrupt
.set CMP0_PRI_POS         ,   (8 -__NVIC_PRIO_BITS)  // CMP0 interrupt
.set TPM0_PRI_POS         ,  (16 -__NVIC_PRIO_BITS)  // TPM0 fault, overflow, and channels interrupt
.set TPM1_PRI_POS         ,  (24 -__NVIC_PRIO_BITS)  // TPM1 fault, overflow, and channels interrupt
.set Reserved35_PRI_POS   ,  (32 -__NVIC_PRIO_BITS)  // Reserved interrupt 35
.set RTC_PRI_POS          ,   (8 -__NVIC_PRIO_BITS)  // RTC alarm interrupt
.set RTC_Seconds_PRI_POS  ,  (16 -__NVIC_PRIO_BITS)  // RTC seconds interrupt
.set PIT_PRI_POS          ,  (24 -__NVIC_PRIO_BITS)  // PIT interrupt
.set Reserved39_PRI_POS   ,  (32 -__NVIC_PRIO_BITS)  // Reserved interrupt 39
.set Reserved40_PRI_POS   ,   (8 -__NVIC_PRIO_BITS)  // Reserved interrupt 40
.set DAC0_PRI_POS         ,  (16 -__NVIC_PRIO_BITS)  // DAC0 interrupt
.set TSI0_PRI_POS         ,  (24 -__NVIC_PRIO_BITS)  // TSI0 interrupt
.set MCG_PRI_POS          ,  (32 -__NVIC_PRIO_BITS)  // MCG interrupt
.set LPTimer_PRI_POS      ,   (8 -__NVIC_PRIO_BITS)  // LPTMR0 interrupt
.set Reserved45_PRI_POS   ,  (16 -__NVIC_PRIO_BITS)  // Reserved interrupt 45
.set PORTA_PRI_POS        ,  (24 -__NVIC_PRIO_BITS)  // Port A interrupt
.set PORTB_PRI_POS        ,  (32 -__NVIC_PRIO_BITS)  // Port B interrupt
// ---------------------------------------------------------------
// NVIC IRQ masks for ICER, ISER, ICPR, and ISPR
.set DMA0_IRQ_MASK         ,  (1 << DMA0_IRQn      )   // DMA channel 0 transfer complete/error interrupt
.set DMA1_IRQ_MASK         ,  (1 << DMA1_IRQn      )   // DMA channel 1 transfer complete/error interrupt
.set DMA2_IRQ_MASK         ,  (1 << DMA2_IRQn      )   // DMA channel 2 transfer complete/error interrupt
.set DMA3_IRQ_MASK         ,  (1 << DMA3_IRQn      )   // DMA channel 3 transfer complete/error interrupt
.set Reserved20_IRQ_MASK   ,  (1 << Reserved20_IRQn)   // Reserved interrupt 20
.set FTFA_IRQ_MASK         ,  (1 << FTFA_IRQn      )   // FTFA command complete/read collision interrupt
.set LVD_LVW_IRQ_MASK      ,  (1 << LVD_LVW_IRQn   )   // Low-voltage detect, low-voltage warning interrupt
.set LLW_IRQ_MASK          ,  (1 << LLW_IRQn       )   // Low leakage wakeup interrupt
.set I2C0_IRQ_MASK         ,  (1 << I2C0_IRQn      )   // I2C0 interrupt
.set Reserved25_IRQ_MASK   ,  (1 << Reserved25_IRQn)   // Reserved interrupt 25
.set SPI0_IRQ_MASK         ,  (1 << SPI0_IRQn      )   // SPI0 interrupt
.set Reserved27_IRQ_MASK   ,  (1 << Reserved27_IRQn)   // Reserved interrupt 27
.set UART0_IRQ_MASK        ,  (1 << UART0_IRQn     )   // UART0 status/error interrupt
.set Reserved29_IRQ_MASK   ,  (1 << Reserved29_IRQn)   // Reserved interrupt 29
.set Reserved30_IRQ_MASK   ,  (1 << Reserved30_IRQn)   // Reserved interrupt 30
.set ADC0_IRQ_MASK         ,  (1 << ADC0_IRQn      )   // ADC0 interrupt
.set CMP0_IRQ_MASK         ,  (1 << CMP0_IRQn      )   // CMP0 interrupt
.set TPM0_IRQ_MASK         ,  (1 << TPM0_IRQn      )   // TPM0 fault, overflow, and channels interrupt
.set TPM1_IRQ_MASK         ,  (1 << TPM1_IRQn      )   // TPM1 fault, overflow, and channels interrupt
.set Reserved35_IRQ_MASK   ,  (1 << Reserved35_IRQn)   // Reserved interrupt 35
.set RTC_IRQ_MASK          ,  (1 << RTC_IRQn       )   // RTC alarm interrupt
.set RTC_Seconds_IRQ_MASK  ,  (1 << RTC_Seconds_IRQn)  // RTC seconds interrupt
.set PIT_IRQ_MASK          ,  (1 << PIT_IRQn       )   // PIT interrupt
.set Reserved39_IRQ_MASK   ,  (1 << Reserved39_IRQn)   // Reserved interrupt 39
.set Reserved40_IRQ_MASK   ,  (1 << Reserved40_IRQn)   // Reserved interrupt 40
.set DAC0_IRQ_MASK         ,  (1 << DAC0_IRQn      )   // DAC0 interrupt
.set TSI0_IRQ_MASK         ,  (1 << TSI0_IRQn      )   // TSI0 interrupt
.set MCG_IRQ_MASK          ,  (1 << MCG_IRQn       )   // MCG interrupt
.set LPTimer_IRQ_MASK      ,  (1 << LPTimer_IRQn   )   // LPTMR0 interrupt
.set Reserved45_IRQ_MASK   ,  (1 << Reserved45_IRQn)   // Reserved interrupt 45
.set PORTA_IRQ_MASK        ,  (1 << PORTA_IRQn     )   // Port A interrupt
.set PORTB_IRQ_MASK        ,  (1 << PORTB_IRQn     )   // Port B interrupt
// ---------------------------------------------------------------
// NVIC vectors
.set Init_SP_Vector      ,   0  // End of stack
.set Reset_Vector        ,   1  // Reset
.set NMI_Vector          ,   2  // Non-maskable interrupt (NMI)
.set Hard_Fault_Vector   ,   3  // Hard fault interrupt
.set Reserved04_Vector   ,   4  // (reserved)
.set Reserved05_Vector   ,   5  // (reserved)
.set Reserved06_Vector   ,   6  // (reserved)
.set Reserved07_Vector   ,   7  // (reserved)
.set Reserved08_Vector   ,   8  // (reserved)
.set Reserved09_Vector   ,   9  // (reserved)
.set Reserved10_Vector   ,  10  // (reserved)
.set SVCall_Vector       ,  11  // Supervisor call interrupt (SVCall)
.set Reserved12_Vector   ,  12  // (reserved)
.set Reserved13_Vector   ,  13  // (reserved)
.set PendSV_Vector       ,  14  // Pendable request for system-level service interrupt
                             // (PendableSrvReq)
.set SysTick_Vector      ,  15  // System tick timer interrupt (SysTick)
.set DMA0_Vector         ,  16  // DMA channel 0 transfer complete/error interrupt
.set DMA1_Vector         ,  17  // DMA channel 1 transfer complete/error interrupt
.set DMA2_Vector         ,  18  // DMA channel 2 transfer complete/error interrupt
.set DMA3_Vector         ,  19  // DMA channel 3 transfer complete/error interrupt
.set Reserved20_Vector   ,  20  // Reserved interrupt 20
.set FTFA_Vector         ,  21  // FTFA command complete/read collision interrupt
.set LVD_LVW_Vector      ,  22  // Low-voltage detect, low-voltage warning interrupt
.set LLW_Vector          ,  23  // Low leakage wakeup interrupt
.set I2C0_Vector         ,  24  // I2C0 interrupt
.set Reserved25_Vector   ,  25  // Reserved interrupt 25
.set SPI0_Vector         ,  26  // SPI0 interrupt
.set Reserved27_Vector   ,  27  // Reserved interrupt 27
.set UART0_Vector        ,  28  // UART0 status/error interrupt
.set Reserved29_Vector   ,  29  // Reserved interrupt 29
.set Reserved30_Vector   ,  30  // Reserved interrupt 30
.set ADC0_Vector         ,  31  // ADC0 interrupt
.set CMP0_Vector         ,  32  // CMP0 interrupt
.set TPM0_Vector         ,  33  // TPM0 fault, overflow, and channels interrupt
.set TPM1_Vector         ,  34  // TPM1 fault, overflow, and channels interrupt
.set Reserved35_Vector   ,  35  // Reserved interrupt 35
.set RTC_Vector          ,  36  // RTC alarm interrupt
.set RTC_Seconds_Vector  ,  37  // RTC seconds interrupt
.set PIT_Vector          ,  38  // PIT interrupt
.set Reserved39_Vector   ,  39  // Reserved interrupt 39
.set Reserved40_Vector   ,  40  // Reserved interrupt 40
.set DAC0_Vector         ,  41  // DAC0 interrupt
.set TSI0_Vector         ,  42  // TSI0 interrupt
.set MCG_Vector          ,  43  // MCG interrupt
.set LPTimer_Vector      ,  44  // LPTMR0 interrupt
.set Reserved45_Vector   ,  45  // Reserved interrupt 45
.set PORTA_Vector        ,  46  // Port A interrupt
.set PORTB_Vector        ,  47  // Port B interrupt
// ---------------------------------------------------------------
// OSC
.set OSC0_BASE       ,  0x40065000
.set OSC0_CR_OFFSET  ,  0
.set OSC0_CR         ,  (OSC0_BASE + OSC0_CR_OFFSET)
// ---------------------------------------------------------------
// OSC0_CR (0x00)
// 7:ERCLKEN=external reference enable, OSCERCLK (0)
// 6:(reserved):read-only:0
// 5:EREFSTEN=external reference stop enable (0)
// 4:(reserved):read-only:0
// 3:SC2P=oscillator 2-pF capacitor load configure (0)
// 2:SC4P=oscillator 4-pF capacitor load configure (0)
// 1:SC8P=oscillator 8-pF capacitor load configure (0)
// 0:SC16P=oscillator 16-pF capacitor load configure (0)
.set OSC_CR_SC16P_MASK      ,  0x1
.set OSC_CR_SC16P_SHIFT     ,  0
.set OSC_CR_SC8P_MASK       ,  0x2
.set OSC_CR_SC8P_SHIFT      ,  1
.set OSC_CR_SC4P_MASK       ,  0x4
.set OSC_CR_SC4P_SHIFT      ,  2
.set OSC_CR_SC2P_MASK       ,  0x8
.set OSC_CR_SC2P_SHIFT      ,  3
.set OSC_CR_EREFSTEN_MASK   ,  0x20
.set OSC_CR_EREFSTEN_SHIFT  ,  5
.set OSC_CR_ERCLKEN_MASK    ,  0x80
.set OSC_CR_ERCLKEN_SHIFT   ,  7
// ---------------------------------------------------------------
// PIT
.set PIT_BASE            ,  0x40037000
.set PIT_CH0_BASE        ,  0x40037100
.set PIT_CH1_BASE        ,  0x40037110
.set PIT_LDVAL_OFFSET    , 0x00
.set PIT_CVAL_OFFSET     , 0x04
.set PIT_TCTRL_OFFSET    , 0x08
.set PIT_TFLG_OFFSET     , 0x0C
.set PIT_MCR_OFFSET      ,  0x00
.set PIT_LTMR64H_OFFSET  ,  0xE0
.set PIT_LTMR64L_OFFSET  ,  0xE4
.set PIT_LDVAL0_OFFSET   ,  0x100
.set PIT_CVAL0_OFFSET    ,  0x104
.set PIT_TCTRL0_OFFSET   ,  0x108
.set PIT_TFLG0_OFFSET    ,  0x10C
.set PIT_LDVAL1_OFFSET   ,  0x110
.set PIT_CVAL1_OFFSET    ,  0x114
.set PIT_TCTRL1_OFFSET   ,  0x118
.set PIT_TFLG1_OFFSET    ,  0x11C
.set PIT_MCR      ,  (PIT_BASE + PIT_MCR_OFFSET)
.set PIT_LTMR64H  ,  (PIT_BASE + PIT_LTMR64H_OFFSET)
.set PIT_LTMR64L  ,  (PIT_BASE + PIT_LTMR64L_OFFSET)
.set PIT_LDVAL0   ,  (PIT_BASE + PIT_LDVAL0_OFFSET)
.set PIT_CVAL0    ,  (PIT_BASE + PIT_CVAL0_OFFSET)
.set PIT_TCTRL0   ,  (PIT_BASE + PIT_TCTRL0_OFFSET)
.set PIT_TFLG0    ,  (PIT_BASE + PIT_TFLG0_OFFSET)
.set PIT_LDVAL1   ,  (PIT_BASE + PIT_LDVAL1_OFFSET)
.set PIT_CVAL1    ,  (PIT_BASE + PIT_CVAL1_OFFSET)
.set PIT_TCTRL1   ,  (PIT_BASE + PIT_TCTRL1_OFFSET)
.set PIT_TFLG1    ,  (PIT_BASE + PIT_TFLG1_OFFSET)
// ---------------------------------------------------------------
// PIT_CVALn:  current timer value register (channel n)
// 31-0:TVL=current timer value
// ---------------------------------------------------------------
// PIT_LDVALn:  timer load value register (channel n)
// 31-0:TSV=timer start value
//          PIT chan. n counts down from this value to 0,
//          then sets TIF and loads LDVALn
// ---------------------------------------------------------------
// PIT_LTMR64H:  PIT upper lifetime timer register
// for applications chaining timer 0 and timer 1 for 64-bit timer
// 31-0:LTH=life timer value (high word)
//          value of timer 1 (CVAL1); read before PIT_LTMR64L
// ---------------------------------------------------------------
// PIT_LTMR64L:  PIT lower lifetime timer register
// for applications chaining timer 0 and timer 1 for 64-bit timer
// 31-0:LTL=life timer value (low word)
//          value of timer 0 (CVAL0); read after PIT_LTMR64H
// ---------------------------------------------------------------
// PIT_MCR:  PIT module control register
// 31-3:(reserved):read-only:0
//    2:(reserved)
//    1:MDIS=module disable (PIT section)
//           RTI timer not affected by this field
//           must be enabled before any other setup
//    0:FRZ=freeze:  continue'/stop timers in debug mode
.set PIT_MCR_MDIS_MASK   ,  0x00000002
.set PIT_MCR_MDIS_SHIFT  ,  1
.set PIT_MCR_FRZ_MASK    ,  0x00000001
.set PIT_MCR_FRZ_SHIFT   ,  0
// ---------------------------------------------------------------
// PIT_TCTRLn:  timer control register (channel n)
// 31-3:(reserved):read-only:0
//    2:CHN=chain mode (enable)
//           in chain mode, channel n-1 must expire before
//                          channel n counts
//           timer 0 cannot be changed
//    1:TIE=timer interrupt enable (on TIF)
//    0:TEN=timer enable
.set PIT_TCTRL_CHN_MASK   ,  0x00000004
.set PIT_TCTRL_CHN_SHIFT  ,  2
.set PIT_TCTRL_TIE_MASK   ,  0x00000002
.set PIT_TCTRL_TIE_SHIFT  ,  1
.set PIT_TCTRL_TEN_MASK   ,  0x00000001
.set PIT_TCTRL_TEN_SHIFT  ,  0
// ---------------------------------------------------------------
// PIT_TFLGn:  timer flag register (channel n)
// 31-1:(reserved):read-only:0
//    0:TIF=timer interrupt flag
//          write 1 to clear
.set PIT_TFLG_TIF_MASK   ,  0x00000001
.set PIT_TFLG_TIF_SHIFT  ,  0
// ---------------------------------------------------------------
// Port A
.set PORTA_BASE         ,  0x40049000
.set PORTA_PCR0_OFFSET  ,  0x00
.set PORTA_PCR1_OFFSET  ,  0x04
.set PORTA_PCR2_OFFSET  ,  0x08
.set PORTA_PCR3_OFFSET  ,  0x0C
.set PORTA_PCR4_OFFSET  ,  0x10
.set PORTA_PCR5_OFFSET  ,  0x14
.set PORTA_PCR6_OFFSET  ,  0x18
.set PORTA_PCR7_OFFSET  ,  0x1C
.set PORTA_PCR8_OFFSET  ,  0x20
.set PORTA_PCR9_OFFSET  ,  0x24
.set PORTA_PCR10_OFFSET ,  0x28
.set PORTA_PCR11_OFFSET ,  0x2C
.set PORTA_PCR12_OFFSET ,  0x30
.set PORTA_PCR13_OFFSET ,  0x34
.set PORTA_PCR14_OFFSET ,  0x38
.set PORTA_PCR15_OFFSET ,  0x3C
.set PORTA_PCR16_OFFSET ,  0x40
.set PORTA_PCR17_OFFSET ,  0x44
.set PORTA_PCR18_OFFSET ,  0x48
.set PORTA_PCR19_OFFSET ,  0x4C
.set PORTA_PCR20_OFFSET ,  0x50
.set PORTA_PCR21_OFFSET ,  0x54
.set PORTA_PCR22_OFFSET ,  0x58
.set PORTA_PCR23_OFFSET ,  0x5C
.set PORTA_PCR24_OFFSET ,  0x60
.set PORTA_PCR25_OFFSET ,  0x64
.set PORTA_PCR26_OFFSET ,  0x68
.set PORTA_PCR27_OFFSET ,  0x6C
.set PORTA_PCR28_OFFSET ,  0x70
.set PORTA_PCR29_OFFSET ,  0x74
.set PORTA_PCR30_OFFSET ,  0x78
.set PORTA_PCR31_OFFSET ,  0x7C
.set PORTA_GPCLR_OFFSET ,  0x80
.set PORTA_GPCHR_OFFSET ,  0x84
.set PORTA_ISFR_OFFSET  ,  0xA0
.set PORTA_PCR0         ,  (PORTA_BASE + PORTA_PCR0_OFFSET)
.set PORTA_PCR1         ,  (PORTA_BASE + PORTA_PCR1_OFFSET)
.set PORTA_PCR2         ,  (PORTA_BASE + PORTA_PCR2_OFFSET)
.set PORTA_PCR3         ,  (PORTA_BASE + PORTA_PCR3_OFFSET)
.set PORTA_PCR4         ,  (PORTA_BASE + PORTA_PCR4_OFFSET)
.set PORTA_PCR5         ,  (PORTA_BASE + PORTA_PCR5_OFFSET)
.set PORTA_PCR6         ,  (PORTA_BASE + PORTA_PCR6_OFFSET)
.set PORTA_PCR7         ,  (PORTA_BASE + PORTA_PCR7_OFFSET)
.set PORTA_PCR8         ,  (PORTA_BASE + PORTA_PCR8_OFFSET)
.set PORTA_PCR9         ,  (PORTA_BASE + PORTA_PCR9_OFFSET)
.set PORTA_PCR10        ,  (PORTA_BASE + PORTA_PCR10_OFFSET)
.set PORTA_PCR11        ,  (PORTA_BASE + PORTA_PCR11_OFFSET)
.set PORTA_PCR12        ,  (PORTA_BASE + PORTA_PCR12_OFFSET)
.set PORTA_PCR13        ,  (PORTA_BASE + PORTA_PCR13_OFFSET)
.set PORTA_PCR14        ,  (PORTA_BASE + PORTA_PCR14_OFFSET)
.set PORTA_PCR15        ,  (PORTA_BASE + PORTA_PCR15_OFFSET)
.set PORTA_PCR16        ,  (PORTA_BASE + PORTA_PCR16_OFFSET)
.set PORTA_PCR17        ,  (PORTA_BASE + PORTA_PCR17_OFFSET)
.set PORTA_PCR18        ,  (PORTA_BASE + PORTA_PCR18_OFFSET)
.set PORTA_PCR19        ,  (PORTA_BASE + PORTA_PCR19_OFFSET)
.set PORTA_PCR20        ,  (PORTA_BASE + PORTA_PCR20_OFFSET)
.set PORTA_PCR21        ,  (PORTA_BASE + PORTA_PCR21_OFFSET)
.set PORTA_PCR22        ,  (PORTA_BASE + PORTA_PCR22_OFFSET)
.set PORTA_PCR23        ,  (PORTA_BASE + PORTA_PCR23_OFFSET)
.set PORTA_PCR24        ,  (PORTA_BASE + PORTA_PCR24_OFFSET)
.set PORTA_PCR25        ,  (PORTA_BASE + PORTA_PCR25_OFFSET)
.set PORTA_PCR26        ,  (PORTA_BASE + PORTA_PCR26_OFFSET)
.set PORTA_PCR27        ,  (PORTA_BASE + PORTA_PCR27_OFFSET)
.set PORTA_PCR28        ,  (PORTA_BASE + PORTA_PCR28_OFFSET)
.set PORTA_PCR29        ,  (PORTA_BASE + PORTA_PCR29_OFFSET)
.set PORTA_PCR30        ,  (PORTA_BASE + PORTA_PCR30_OFFSET)
.set PORTA_PCR31        ,  (PORTA_BASE + PORTA_PCR31_OFFSET)
.set PORTA_GPCLR        ,  (PORTA_BASE + PORTA_GPCLR_OFFSET)
.set PORTA_GPCHR        ,  (PORTA_BASE + PORTA_GPCHR_OFFSET)
.set PORTA_ISFR         ,  (PORTA_BASE + PORTA_ISFR_OFFSET)
// ---------------------------------------------------------------
// Port B
.set PORTB_BASE         ,  0x4004A000
.set PORTB_PCR0_OFFSET  ,  0x00
.set PORTB_PCR1_OFFSET  ,  0x04
.set PORTB_PCR2_OFFSET  ,  0x08
.set PORTB_PCR3_OFFSET  ,  0x0C
.set PORTB_PCR4_OFFSET  ,  0x10
.set PORTB_PCR5_OFFSET  ,  0x14
.set PORTB_PCR6_OFFSET  ,  0x18
.set PORTB_PCR7_OFFSET  ,  0x1C
.set PORTB_PCR8_OFFSET  ,  0x20
.set PORTB_PCR9_OFFSET  ,  0x24
.set PORTB_PCR10_OFFSET ,  0x28
.set PORTB_PCR11_OFFSET ,  0x2C
.set PORTB_PCR12_OFFSET ,  0x30
.set PORTB_PCR13_OFFSET ,  0x34
.set PORTB_PCR14_OFFSET ,  0x38
.set PORTB_PCR15_OFFSET ,  0x3C
.set PORTB_PCR16_OFFSET ,  0x40
.set PORTB_PCR17_OFFSET ,  0x44
.set PORTB_PCR18_OFFSET ,  0x48
.set PORTB_PCR19_OFFSET ,  0x4C
.set PORTB_PCR20_OFFSET ,  0x50
.set PORTB_PCR21_OFFSET ,  0x54
.set PORTB_PCR22_OFFSET ,  0x58
.set PORTB_PCR23_OFFSET ,  0x5C
.set PORTB_PCR24_OFFSET ,  0x60
.set PORTB_PCR25_OFFSET ,  0x64
.set PORTB_PCR26_OFFSET ,  0x68
.set PORTB_PCR27_OFFSET ,  0x6C
.set PORTB_PCR28_OFFSET ,  0x70
.set PORTB_PCR29_OFFSET ,  0x74
.set PORTB_PCR30_OFFSET ,  0x78
.set PORTB_PCR31_OFFSET ,  0x7C
.set PORTB_GPCLR_OFFSET ,  0x80
.set PORTB_GPCHR_OFFSET ,  0x84
.set PORTB_ISFR_OFFSET  ,  0xA0
.set PORTB_PCR0         ,  (PORTB_BASE + PORTB_PCR0_OFFSET)
.set PORTB_PCR1         ,  (PORTB_BASE + PORTB_PCR1_OFFSET)
.set PORTB_PCR2         ,  (PORTB_BASE + PORTB_PCR2_OFFSET)
.set PORTB_PCR3         ,  (PORTB_BASE + PORTB_PCR3_OFFSET)
.set PORTB_PCR4         ,  (PORTB_BASE + PORTB_PCR4_OFFSET)
.set PORTB_PCR5         ,  (PORTB_BASE + PORTB_PCR5_OFFSET)
.set PORTB_PCR6         ,  (PORTB_BASE + PORTB_PCR6_OFFSET)
.set PORTB_PCR7         ,  (PORTB_BASE + PORTB_PCR7_OFFSET)
.set PORTB_PCR8         ,  (PORTB_BASE + PORTB_PCR8_OFFSET)
.set PORTB_PCR9         ,  (PORTB_BASE + PORTB_PCR9_OFFSET)
.set PORTB_PCR10        ,  (PORTB_BASE + PORTB_PCR10_OFFSET)
.set PORTB_PCR11        ,  (PORTB_BASE + PORTB_PCR11_OFFSET)
.set PORTB_PCR12        ,  (PORTB_BASE + PORTB_PCR12_OFFSET)
.set PORTB_PCR13        ,  (PORTB_BASE + PORTB_PCR13_OFFSET)
.set PORTB_PCR14        ,  (PORTB_BASE + PORTB_PCR14_OFFSET)
.set PORTB_PCR15        ,  (PORTB_BASE + PORTB_PCR15_OFFSET)
.set PORTB_PCR16        ,  (PORTB_BASE + PORTB_PCR16_OFFSET)
.set PORTB_PCR17        ,  (PORTB_BASE + PORTB_PCR17_OFFSET)
.set PORTB_PCR18        ,  (PORTB_BASE + PORTB_PCR18_OFFSET)
.set PORTB_PCR19        ,  (PORTB_BASE + PORTB_PCR19_OFFSET)
.set PORTB_PCR20        ,  (PORTB_BASE + PORTB_PCR20_OFFSET)
.set PORTB_PCR21        ,  (PORTB_BASE + PORTB_PCR21_OFFSET)
.set PORTB_PCR22        ,  (PORTB_BASE + PORTB_PCR22_OFFSET)
.set PORTB_PCR23        ,  (PORTB_BASE + PORTB_PCR23_OFFSET)
.set PORTB_PCR24        ,  (PORTB_BASE + PORTB_PCR24_OFFSET)
.set PORTB_PCR25        ,  (PORTB_BASE + PORTB_PCR25_OFFSET)
.set PORTB_PCR26        ,  (PORTB_BASE + PORTB_PCR26_OFFSET)
.set PORTB_PCR27        ,  (PORTB_BASE + PORTB_PCR27_OFFSET)
.set PORTB_PCR28        ,  (PORTB_BASE + PORTB_PCR28_OFFSET)
.set PORTB_PCR29        ,  (PORTB_BASE + PORTB_PCR29_OFFSET)
.set PORTB_PCR30        ,  (PORTB_BASE + PORTB_PCR30_OFFSET)
.set PORTB_PCR31        ,  (PORTB_BASE + PORTB_PCR31_OFFSET)
.set PORTB_GPCLR        ,  (PORTB_BASE + PORTB_GPCLR_OFFSET)
.set PORTB_GPCHR        ,  (PORTB_BASE + PORTB_GPCHR_OFFSET)
.set PORTB_ISFR         ,  (PORTB_BASE + PORTB_ISFR_OFFSET)
// ---------------------------------------------------------------
// PORTx_PCRn (Port x pin control register n [for pin n])
// 31-25:(reserved):read-only:0
//    24:ISF=interrupt status flag; write 1 clears
// 23-20:(reserved):read-only:0
// 19-16:IRCQ=interrupt configuration
//           :0000=interrupt/DMA request disabled
//           :0001=DMA request on rising edge
//           :0010=DMA request on falling edge
//           :0011=DMA request on either edge
//           :1000=interrupt when logic zero
//           :1001=interrupt on rising edge
//           :1010=interrupt on falling edge
//           :1011=interrupt on either edge
//           :1100=interrupt when logic one
//           :others=reserved
// 15-11:(reserved):read-only:0
// 10-08:MUX=Pin mux control
//          :000=pin disabled (analog)
//          :001=alternative 1 (GPIO)
//          :010-111=alternatives 2-7 (chip-specific)
//     7:(reserved):read-only:0
//     6:DSE=Drive strength enable
//          :0=low
//          :1=high
//     5:(reserved):read-only:0
//     4:PFE=Passive filter enable
//     3:(reserved):read-only:0
//     2:SRE=Slew rate enable
//          :0=fast
//          :1=slow
//     1:PE=Pull enable
//     0:PS=Pull select (if PE=1)
//         :0=internal pulldown
//         :1=internal pullup
.set PORT_PCR_ISF_MASK           ,  0x1000000
.set PORT_PCR_ISF_SHIFT          ,  24
.set PORT_PCR_IRCQ_MASK          ,  0xF0000
.set PORT_PCR_IRCQ_SHIFT         ,  16
.set PORT_PCR_MUX_MASK           ,  0x700
.set PORT_PCR_MUX_SHIFT          ,  8
.set PORT_PCR_DSE_MASK           ,  0x40
.set PORT_PCR_DSE_SHIFT          ,  6
.set PORT_PCR_PFE_MASK           ,  0x10
.set PORT_PCR_PFE_SHIFT          ,  4
.set PORT_PCR_SRE_MASK           ,  0x04
.set PORT_PCR_SRE_SHIFT          ,  2
.set PORT_PCR_PE_MASK            ,  0x02
.set PORT_PCR_PE_SHIFT           ,  1
.set PORT_PCR_PS_MASK            ,  0x01
.set PORT_PCR_PS_SHIFT           ,  0
.set PORT_PCR_MUX_SELECT_0_MASK  ,  0x00000000 // analog
.set PORT_PCR_MUX_SELECT_1_MASK  ,  0x00000100 // GPIO
.set PORT_PCR_MUX_SELECT_2_MASK  ,  0x00000200
.set PORT_PCR_MUX_SELECT_3_MASK  ,  0x00000300
.set PORT_PCR_MUX_SELECT_4_MASK  ,  0x00000400
.set PORT_PCR_MUX_SELECT_5_MASK  ,  0x00000500
.set PORT_PCR_MUX_SELECT_6_MASK  ,  0x00000600
.set PORT_PCR_MUX_SELECT_7_MASK  ,  0x00000700
// ---------------------------------------------------------------
// PORTx_GPCLR (Port x global pin control low register) 
// (32-bit write only)
// 31-16:GPWE=global pin write enable; write only (0x0000)
//       bit n:  0=PORTx_PCR<n-16> not updated from GPWD
//               1=PORTx_PCR<n-16> is updated from GPWD
//  15-0:GPWD=global pin write data; write only (0x0000)
//       Value written to PORTx_PCR[15:0] selected by GPWE
.set PORT_GPCLR_GPWE_MASK   ,  0xFFFF0000
.set PORT_GPCLR_GPWE_SHIFT  ,  16
.set PORT_GPCLR_GPWD_MASK   ,  0xFFFF
.set PORT_GPCLR_GPWD_SHIFT  ,  0
// ---------------------------------------------------------------
// PORTx_GPCHR (Port x global pin control high register)
// (32-bit write only)
// 31-16:GPWE=global pin write enable; write only (0x0000)
//       bit n:  0=PORTx_PCRn not updated from GPWD
//               1=PORTx_PCRn is updated from GPWD
//  15-0:GPWD=global pin write data; write only (0x0000)
//       Value written to PORTx_PCR[15:0] selected by GPWE
.set PORT_GPCHR_GPWE_MASK   ,  0xFFFF0000
.set PORT_GPCHR_GPWE_SHIFT  ,  16
.set PORT_GPCHR_GPWD_MASK   ,  0xFFFF
.set PORT_GPCHR_GPWD_SHIFT  ,  0
// ---------------------------------------------------------------
// PORTx_ISFR (Port x interrupt status flag register)
// (bit n read-only if PORTX pin n does not support interrupts)
// (bit n write 1 clears bit n)
// bit n:  0:  PORTx pin n configured interrupt not detected
//         1:  PORTx pin n configured interrupt detected
//             * If used to generate DMA request,
//               automatically cleared on DMA transfer completion
//             * Otherwise, remains 1 until 1 written
//       bit nn:  0=PORTx_PCRnn not updated from GPWD
//                1=PORTx_PCRnn is updated from GPWD
//  15-0:GPWD=global pin write data; write only (0x0000)
//       Value written to PORTx_PCR[15:0] selected by GPWE
.set PORT_ISFR_ISF_MASK   ,  0xFFFFFFFF
.set PORT_ISFR_ISF_SHIFT  ,  0
// ---------------------------------------------------------------
// PTx not present in MKL46Z4.h
// General-purpose input and output (PTx)
// PTx_PDD:  Port x Data Direction Register
//   Bit n:  0=Port x pin n configured as input
//           1=Port x pin n configured as output
// PTx_PDIR:  Port x Data Input Register
//   Bit n:  Value read from Port x pin n (if input pin)
// PTx_PDOR:  Port x Data Output Register
//   Bit n:  Value written to Port x pin n (if output pin)
// PTx_PoOR: Port x operation o direction x Register
//   Operation o:  C=Clear (clear to 0)
//                 S=Set (set to 1)
//                 T=Toggle (complement)
//   Bit n:  0=Port x pin n not affected
//           1=Port x pin n affected
.set PT_BASE         ,  0x400FF000
.set PT_PDOR_OFFSET  ,  0x00
.set PT_PSOR_OFFSET  ,  0x04
.set PT_PCOR_OFFSET  ,  0x08
.set PT_PTOR_OFFSET  ,  0x0C
.set PT_PDIR_OFFSET  ,  0x10
.set PT_PDDR_OFFSET  ,  0x14
.set PTA_OFFSET      ,  0x00
.set PTB_OFFSET      ,  0x40
// Port A (PTA)
.set PTA_BASE        ,  0x400FF000
.set PTA_PDOR        ,  (PTA_BASE + PT_PDOR_OFFSET)
.set PTA_PSOR        ,  (PTA_BASE + PT_PSOR_OFFSET)
.set PTA_PCOR        ,  (PTA_BASE + PT_PCOR_OFFSET)
.set PTA_PTOR        ,  (PTA_BASE + PT_PTOR_OFFSET)
.set PTA_PDIR        ,  (PTA_BASE + PT_PDIR_OFFSET)
.set PTA_PDDR        ,  (PTA_BASE + PT_PDDR_OFFSET)
// Port B (PTB)
.set PTB_BASE         ,  0x400FF040
.set PTB_PDOR         ,  (PTB_BASE + PT_PDOR_OFFSET)
.set PTB_PSOR         ,  (PTB_BASE + PT_PSOR_OFFSET)
.set PTB_PCOR         ,  (PTB_BASE + PT_PCOR_OFFSET)
.set PTB_PTOR         ,  (PTB_BASE + PT_PTOR_OFFSET)
.set PTB_PDIR         ,  (PTB_BASE + PT_PDIR_OFFSET)
.set PTB_PDDR         ,  (PTB_BASE + PT_PDDR_OFFSET)
// ---------------------------------------------------------------
// IOPORT:  GPIO alias for zero wait state access to GPIO
// See FGPIO
// ---------------------------------------------------------------
// System integration module (SIM)
.set SIM_BASE             ,  0x40047000
.set SIM_SOPT1_OFFSET     ,  0x00
.set SIM_SOPT1CFG_OFFSET  ,  0x04
.set SIM_SOPT2_OFFSET     ,  0x1004
.set SIM_SOPT4_OFFSET     ,  0x100C
.set SIM_SOPT5_OFFSET     ,  0x1010
.set SIM_SOPT7_OFFSET     ,  0x1018
.set SIM_SDID_OFFSET      ,  0x1024
.set SIM_SCGC4_OFFSET     ,  0x1034
.set SIM_SCGC5_OFFSET     ,  0x1038
.set SIM_SCGC6_OFFSET     ,  0x103C
.set SIM_SCGC7_OFFSET     ,  0x1040
.set SIM_CLKDIV1_OFFSET   ,  0x1044
.set SIM_FCFG1_OFFSET     ,  0x104C
.set SIM_FCFG2_OFFSET     ,  0x1050
.set SIM_UIDMH_OFFSET     ,  0x1058
.set SIM_UIDML_OFFSET     ,  0x105C
.set SIM_UIDL_OFFSET      ,  0x1060
.set SIM_COPC_OFFSET      ,  0x1100
.set SIM_SRVCOP_OFFSET    ,  0x1104
.set SIM_CLKDIV1          ,  (SIM_BASE + SIM_CLKDIV1_OFFSET)
.set SIM_COPC             ,  (SIM_BASE + SIM_COPC_OFFSET)
.set SIM_FCFG1            ,  (SIM_BASE + SIM_FCFG1_OFFSET)
.set SIM_FCFG2            ,  (SIM_BASE + SIM_FCFG2_OFFSET)
.set SIM_SCGC4            ,  (SIM_BASE + SIM_SCGC4_OFFSET) 
.set SIM_SCGC5            ,  (SIM_BASE + SIM_SCGC5_OFFSET)
.set SIM_SCGC6            ,  (SIM_BASE + SIM_SCGC6_OFFSET)
.set SIM_SCGC7            ,  (SIM_BASE + SIM_SCGC7_OFFSET)
.set SIM_SDID             ,  (SIM_BASE + SIM_SDID_OFFSET)
.set SIM_SOPT1            ,  (SIM_BASE + SIM_SOPT1_OFFSET)
.set SIM_SOPT1CFG         ,  (SIM_BASE + SIM_SOPT1CFG_OFFSET)
.set SIM_SOPT2            ,  (SIM_BASE + SIM_SOPT2_OFFSET)
.set SIM_SOPT4            ,  (SIM_BASE + SIM_SOPT4_OFFSET)
.set SIM_SOPT5            ,  (SIM_BASE + SIM_SOPT5_OFFSET)
.set SIM_SOPT7            ,  (SIM_BASE + SIM_SOPT7_OFFSET)
.set SIM_SRVCOP           ,  (SIM_BASE + SIM_SRVCOP_OFFSET)
.set SIM_UIDL             ,  (SIM_BASE + SIM_UIDL_OFFSET)
.set SIM_UIDMH            ,  (SIM_BASE + SIM_UIDMH_OFFSET)
.set SIM_UIDML            ,  (SIM_BASE + SIM_UIDML_OFFSET)
// ---------------------------------------------------------------
// SIM_CLKDIV1
// 31-28:OUTDIV1=clock 1 output divider value
//              :set divider for core/system clock,
//              :from which bus/flash clocks are derived
//              :divide by OUTDIV1 + 1
// 27-19:Reserved; read-only; always 0
// 18-16:OUTDIV4=clock 4 output divider value
//              :sets divider for bus and flash clocks,
//              :relative to core/system clock
//              :divide by OUTDIV4 + 1
// 15-00:Reserved; read-only; always 0
.set SIM_CLKDIV1_OUTDIV1_MASK       , 0xF0000000
.set SIM_CLKDIV1_OUTDIV1_SHIFT      , 28
.set SIM_CLKDIV1_OUTDIV4_MASK       , 0x00070000
.set SIM_CLKDIV1_OUTDIV4_SHIFT      , 16
// ---------------------------------------------------------------
// SIM_COPC
// 31-04:Reserved; read-only; always 0
// 03-02:COPT=COP watchdog timeout
//           :00=disabled
//           :01=timeout after 2^5 LPO cycles or 2^13 bus cycles
//           :10=timeout after 2^8 LPO cycles or 2^16 bus cycles
//           :11=timeout after 2^10 LPO cycles or 2^18 bus cycles
//    01:COPCLKS=COP clock select
//              :0=internal 1 kHz
//              :1=bus clock
//    00:COPW=COP windowed mode
.set COP_COPT_MASK      ,  0x0000000C
.set COP_COPT_SHIFT     ,  2
.set COP_COPCLKS_MASK   ,  0x00000002
.set COP_COPCLKS_SHIFT  ,  1
.set COP_COPW_MASK      ,  0x00000001
.set COP_COPW_SHIFT     ,  1
// ---------------------------------------------------------------
// SIM_SCGC4
// 1->31-28:Reserved; read-only; always 1
// 0->27-24:Reserved; read-only; always 0
// 0->   23:SPI1=SPI1 clock gate control (disabled)
// 0->   22:SPI0=SPI0 clock gate control (disabled)
// 0->21-20:Reserved; read-only; always 0
// 0->   19:CMP=comparator clock gate control (disabled)
// 0->   18:USBOTG=USB clock gate control (disabled)
// 0->17-14:Reserved; read-only; always 0
// 0->   13:Reserved; read-only; always 0
// 0->   12:UART2=UART2 clock gate control (disabled)
// 1->   11:UART1=UART1 clock gate control (disabled)
// 0->   10:UART0=UART0 clock gate control (disabled)
// 0->09-08:Reserved; read-only; always 0
// 0->   07:I2C1=I2C1 clock gate control (disabled)
// 0->   06:I2C0=I2C0 clock gate control (disabled)
// 1->05-04:Reserved; read-only; always 1
// 0->03-00:Reserved; read-only; always 0
.set SIM_SCGC4_SPI0_MASK     ,  0x00400000
.set SIM_SCGC4_SPI0_SHIFT    ,  22
.set SIM_SCGC4_CMP_MASK      ,  0x00080000
.set SIM_SCGC4_CMP_SHIFT     ,  19
.set SIM_SCGC4_UART0_MASK    ,  0x00000400
.set SIM_SCGC4_UART0_SHIFT   ,  10
.set SIM_SCGC4_I2C0_MASK     ,  0x00000040
.set SIM_SCGC4_I2C0_SHIFT    ,  6
// ---------------------------------------------------------------
// SIM_SCGC5
// 31-20:Reserved; read-only; always 0
//    19:SLCD=segment LCD clock gate control
// 18-14:Reserved; read-only; always 0
//    13:PORTE=Port E clock gate control
//    12:PORTD=Port D clock gate control
//    11:PORTC=Port C clock gate control
//    10:PORTB=Port B clock gate control
//     9:PORTA=Port A clock gate control
// 08-07:Reserved; read-only; always 1
//     6:Reserved; read-only; always 0
//     5:TSI=TSI access control
// 04-02:Reserved; read-only; always 0
//     1:Reserved; read-only; always 0
//     0:LPTMR=Low power timer access control
.set SIM_SCGC5_PORTB_MASK   ,  0x00000400
.set SIM_SCGC5_PORTB_SHIFT  ,  10
.set SIM_SCGC5_PORTA_MASK   ,  0x00000200
.set SIM_SCGC5_PORTA_SHIFT  ,  9
.set SIM_SCGC5_TSI_MASK     ,  0x00000020
.set SIM_SCGC5_TSI_SHIFT    ,  5
.set SIM_SCGC5_LPTMR_MASK   ,  0x00000001
.set SIM_SCGC5_LPTMR_SHIFT  ,  0
// ---------------------------------------------------------------
// SIM_SCGC6
//    31:DAC0=DAC0 clock gate control
//    30:(reserved):read-only:0
//    29:RTC=RTC access control
//    28:(reserved):read-only:0
//    27:ADC0=ADC0 clock gate control
//    26:TPM2=TPM2 clock gate control
//    25:TPM1=TMP1 clock gate control
//    24:TPM0=TMP0 clock gate control
//    23:PIT=PIT clock gate control
// 22-16:(reserved)
//    15:(reserved)
// 14-02:(reserved)
//     1:DMAMUX=DMA mux clock gate control
//     0:FTF=flash memory clock gate control
.set SIM_SCGC6_DAC0_MASK     ,  0x80000000
.set SIM_SCGC6_DAC0_SHIFT    ,  31
.set SIM_SCGC6_RTC_MASK      ,  0x20000000
.set SIM_SCGC6_RTC_SHIFT     ,  29
.set SIM_SCGC6_ADC0_MASK     ,  0x08000000
.set SIM_SCGC6_ADC0_SHIFT    ,  27
.set SIM_SCGC6_TPM1_MASK     ,  0x02000000
.set SIM_SCGC6_TPM1_SHIFT    ,  25
.set SIM_SCGC6_TPM0_MASK     ,  0x01000000
.set SIM_SCGC6_TPM0_SHIFT    ,  24
.set SIM_SCGC6_PIT_MASK      ,  0x00800000
.set SIM_SCGC6_PIT_SHIFT     ,  23
.set SIM_SCGC6_DMAMUX_MASK   ,  0x00000002
.set SIM_SCGC6_DMAMUX_SHIFT  ,  1
.set SIM_SCGC6_FTF_MASK      ,  0x00000001
.set SIM_SCGC6_FTF_SHIFT     ,  0
// ---------------------------------------------------------------
// SIM_SOPT1 (POR or LVD:  0x80000000)
//    31:USBREGEN=USB voltage regulator enable (1)
//    30:USBSSTBY=USB voltage regulator standby during stop, VLPS, LLS, and VLLS (0)
//    29:USBVSTBY=USB voltage regulator standby during VLPS and VLLS (0)
// 28-20:(reserved):read-only:000000000
// 19-18:OSC32KSEL=32K oscillator clock select (00)
//       (ERCLK32K for sLCD, RTC, and LPTMR)
//                 00:System oscillator (OSC32KCLK)
//                 01:(reserved)
//                 10:RTC_CLKIN
//                 11:LPO 1kHz
//  17-6:(reserved):read-only:000000000000
//   5-0:(reserved)
.set SIM_SOPT1_OSC32KSEL_MASK   ,  0xC0000
.set SIM_SOPT1_OSC32KSEL_SHIFT  ,  18
// ---------------------------------------------------------------
// SIM_SOPT2
// 31-28:(reserved):read-only:0
// 27-26:UART0SRC=UART0 clock source select
//                00:clock disabled
//                01:MCGFLLCLK
//                10:OSCERCLK
//                11:MCGIRCLK
// 25-24:TPMSRC=TPM clock source select
//              00:clock disabled
//              01:MCGFLLCLK
//              10:OSCERCLK
//              11:MCGIRCLK
// 23-19:(reserved):read-only:0
// 15- 8:(reserved):read-only:0
//  7- 5:CLKOUTSEL=CLKOUT select
//                 000:(reserved)
//                 001:(reserved)
//                 010:bus clock
//                 011:LPO clock (1 KHz)
//                 100:MCGIRCLK
//                 101:(reserved)
//                 110:OSCERCLK
//                 110:(reserved)
//     4:RTCCLKOUTSEL=RTC clock out select
//                    0:RTC (1 Hz)
//                    1:OSCERCLK
//  3- 0:(reserved):read-only:0
.set SIM_SOPT2_UART0SRC_MASK       ,  0x0C000000
.set SIM_SOPT2_UART0SRC_SHIFT      ,  26
.set SIM_SOPT2_TPMSRC_MASK         ,  0x03000000
.set SIM_SOPT2_TPMSRC_SHIFT        ,  24
.set SIM_SOPT2_CLKOUTSEL_MASK      ,  0xE0
.set SIM_SOPT2_CLKOUTSEL_SHIFT     ,  5
.set SIM_SOPT2_RTCCLKOUTSEL_MASK   ,  0x10
.set SIM_SOPT2_RTCCLKOUTSEL_SHIFT  ,  4
// ---------------------------------------------------------------
// SIM_SOPT5
// 31-20:Reserved; read-only; always 0
//    19:Reserved; read-only; always 0
//    18:UART2ODE=UART2 open drain enable
//    17:UART1ODE=UART1 open drain enable
//    16:UART0ODE=UART0 open drain enable
// 15-07:Reserved; read-only; always 0
//    06:UART1TXSRC=UART1 receive data select
//                 :0=UART1_RX pin
//                 :1=CMP0 output
// 05-04:UART1TXSRC=UART1 transmit data select source
//                 :00=UART1_TX pin
//                 :01=UART1_TX pin modulated with TPM1 channel 0 output
//                 :10=UART1_TX pin modulated with TPM2 channel 0 output
//                 :11=(reserved)
//    03:Reserved; read-only; always 0
//    02:UART0RXSRC=UART0 receive data select
//                 :0=UART0_RX pin
//                 :1=CMP0 output
// 01-00:UART0TXSRC=UART0 transmit data select source
//                 :00=UART0_TX pin
//                 :01=UART0_TX pin modulated with TPM1 channel 0 output
//                 :10=UART0_TX pin modulated with TPM2 channel 0 output
//                 :11=(reserved)
.set SIM_SOPT5_UART0ODE_MASK     ,  0x00010000
.set SIM_SOPT5_UART0ODE_SHIFT    ,  16
.set SIM_SOPT5_UART0RXSRC_MASK   ,  0x00000004
.set SIM_SOPT5_UART0RXSRC_SHIFT  ,  2
.set SIM_SOPT5_UART0TXSRC_MASK   ,  0x00000001
.set SIM_SOPT5_UART0TXSRC_SHIFT  ,  0
// ---------------------------------------------------------------
// Timer/PWM modules (TPMx)
.set TPM_SC_OFFSET      ,  0x00
.set TPM_CNT_OFFSET     ,  0x04
.set TPM_MOD_OFFSET     ,  0x08
.set TPM_C0SC_OFFSET    ,  0x0C
.set TPM_C0V_OFFSET     ,  0x10
.set TPM_C1SC_OFFSET    ,  0x14
.set TPM_C1V_OFFSET     ,  0x18
.set TPM_C2SC_OFFSET    ,  0x1C
.set TPM_C2V_OFFSET     ,  0x20
.set TPM_C3SC_OFFSET    ,  0x24
.set TPM_C3V_OFFSET     ,  0x28
.set TPM_C4SC_OFFSET    ,  0x2C
.set TPM_C4V_OFFSET     ,  0x30
.set TPM_C5SC_OFFSET    ,  0x34
.set TPM_C5V_OFFSET     ,  0x38
// TPM_CONTROLS_OFFSET  EQU  TPM_C0SC_OFFSET
// TPM_RESERVED_0_OFFSET  EQU  0x3C
.set TPM_STATUS_OFFSET  ,  0x50
// TPM_RESERVED_1_OFFSET  EQU  0x54
.set TPM_CONF_OFFSET    ,  0x84
// ---------------------------------------------------------------
// Timer/PWM module 0 (TPM0)
.set TPM0_BASE           ,  0x40038000
// TPM_BASES           EQU  TPM0_BASE
.set TPM0_SC      , (TPM0_BASE + TPM_SC_OFFSET    )
.set TPM0_CNT     , (TPM0_BASE + TPM_CNT_OFFSET   )
.set TPM0_MOD     , (TPM0_BASE + TPM_MOD_OFFSET   )
.set TPM0_C0SC    , (TPM0_BASE + TPM_C0SC_OFFSET  )
.set TPM0_C0V     , (TPM0_BASE + TPM_C0V_OFFSET   )
.set TPM0_C1SC    , (TPM0_BASE + TPM_C1SC_OFFSET  )
.set TPM0_C1V     , (TPM0_BASE + TPM_C1V_OFFSET   )
.set TPM0_C2SC    , (TPM0_BASE + TPM_C2SC_OFFSET  )
.set TPM0_C2V     , (TPM0_BASE + TPM_C2V_OFFSET   )
.set TPM0_C3SC    , (TPM0_BASE + TPM_C3SC_OFFSET  )
.set TPM0_C3V     , (TPM0_BASE + TPM_C3V_OFFSET   )
.set TPM0_C4SC    , (TPM0_BASE + TPM_C4SC_OFFSET  )
.set TPM0_C4V     , (TPM0_BASE + TPM_C4V_OFFSET   )
.set TPM0_C5SC    , (TPM0_BASE + TPM_C5SC_OFFSET  )
.set TPM0_C5V     , (TPM0_BASE + TPM_C5V_OFFSET   )
// TPM0_CONTROLS  EQU  (TPM0_BASE + TPM_CONTROLS_OFFSET)
// TPM0_RESERVED_0  EQU (TPM0_BASE + TPM_RESERVED_0_OFFSET)
.set TPM0_STATUS  , (TPM0_BASE + TPM_STATUS_OFFSET)
// TPM0_RESERVED_1  EQU (TPM0_BASE + TPM_RESERVED_1_OFFSET)
.set TPM0_CONF    , (TPM0_BASE + TPM_CONF_OFFSET  )
// ---------------------------------------------------------------
// Timer/PWM module 1 (TPM1)
.set TPM1_BASE           ,  0x40039000
.set TPM1_SC      , (TPM1_BASE + TPM_SC_OFFSET    )
.set TPM1_CNT     , (TPM1_BASE + TPM_CNT_OFFSET   )
.set TPM1_MOD     , (TPM1_BASE + TPM_MOD_OFFSET   )
.set TPM1_C0SC    , (TPM1_BASE + TPM_C0SC_OFFSET  )
.set TPM1_C0V     , (TPM1_BASE + TPM_C0V_OFFSET   )
.set TPM1_C1SC    , (TPM1_BASE + TPM_C1SC_OFFSET  )
.set TPM1_C1V     , (TPM1_BASE + TPM_C1V_OFFSET   )
.set TPM1_C2SC    , (TPM1_BASE + TPM_C2SC_OFFSET  )
.set TPM1_C2V     , (TPM1_BASE + TPM_C2V_OFFSET   )
.set TPM1_C3SC    , (TPM1_BASE + TPM_C3SC_OFFSET  )
.set TPM1_C3V     , (TPM1_BASE + TPM_C3V_OFFSET   )
.set TPM1_C4SC    , (TPM1_BASE + TPM_C4SC_OFFSET  )
.set TPM1_C4V     , (TPM1_BASE + TPM_C4V_OFFSET   )
.set TPM1_C5SC    , (TPM1_BASE + TPM_C5SC_OFFSET  )
.set TPM1_C5V     , (TPM1_BASE + TPM_C5V_OFFSET   )
// TPM1_CONTROLS  EQU  (TPM0_BASE + TPM_CONTROLS_OFFSET)
// TPM1_RESERVED_0  EQU (TPM0_BASE + TPM_RESERVED_0_OFFSET)
.set TPM1_STATUS  , (TPM1_BASE + TPM_STATUS_OFFSET)
// TPM1_RESERVED_1  EQU (TPM0_BASE + TPM_RESERVED_1_OFFSET)
.set TPM1_CONF    , (TPM1_BASE + TPM_CONF_OFFSET  )
// ---------------------------------------------------------------
// TPMx_CnSC:  Channel n Status and Control
// 31-8:(reserved):read-only:0
//    7:CHF=channel flag (0)
//          set on channel event
//          write 1 to clear
//    6:CHIE=channel interrupt enable (0)
//    5:MSB=channel mode select B (0) (see selection table below)
//    4:MSA=channel mode select A (0) (see selection table below)
//    3:ELSB=edge or level select B (0) (see selection table below)
//    2:ELSA=edge or level select A (0) (see selection table below)
//    1:(reserved):read-only:0
//    0:DMA=DMA enable (0)
// Mode, Edge, and Level Selection
// MSB:MSA | ELSB:ELSA | Mode           | Configuration
//   0 0   |    0 0    | (none)         | channel disabled
//   0 1   |    0 0    | SW compare     | pin not used
//   1 X   |    0 0    | SW compare     | pin not used
//   0 0   |    0 1    | input capture  | rising edge
//   0 0   |    1 0    | input capture  | falling edge
//   0 0   |    1 1    | input capture  | either edge
//   0 1   |    0 1    | output compare | toggle on match
//   0 1   |    1 0    | output compare | clear on match
//   0 1   |    1 1    | output compare | set on match
//   1 0   |    X 1    | PWM            | low pulse
//   1 0   |    1 0    | PWM            | high pulse
//   1 1   |    X 1    | output compare | pulse high on match
//   1 1   |    1 0    | output compare | pulse low on match
.set TPM_CnSC_CHF_MASK    ,  0x80
.set TPM_CnSC_CHF_SHIFT   ,  7
.set TPM_CnSC_CHIE_MASK   ,  0x40
.set TPM_CnSC_CHIE_SHIFT  ,  6
.set TPM_CnSC_MSB_MASK    ,  0x20
.set TPM_CnSC_MSB_SHIFT   ,  5
.set TPM_CnSC_MSA_MASK    ,  0x10
.set TPM_CnSC_MSA_SHIFT   ,  4
.set TPM_CnSC_ELSB_MASK   ,  0x08
.set TPM_CnSC_ELSB_SHIFT  ,  3
.set TPM_CnSC_ELSA_MASK   ,  0x04
.set TPM_CnSC_ELSA_SHIFT  ,  2
.set TPM_CnSC_CDMA_MASK   ,  0x01
.set TPM_CnSC_CDMA_SHIFT  ,  0
// ---------------------------------------------------------------
// TPMx_CnV:  Channel n Value
// 31-16:(reserved):read-only:0
// 16- 0:VAL (0x0000) (all bytes must be written at the same time)
.set TPM_CnV_VAL_MASK   , 0xFFFF
.set TPM_CnV_VAL_SHIFT  , 0
// ---------------------------------------------------------------
// TPMx_CONF:  Configuration
// 31-28:(reserved):read-only:0
// 27-24:TRGSEL=trigger select (0000)
//              should be changed only when counter disabled
//              0000:EXTRG_IN (external trigger pin input)
//              0001:CMP0 output
//              0010:(reserved)
//              0011:(reserved)
//              0100:PIT trigger 0
//              0101:PIT trigger 1
//              0110:(reserved)
//              0111:(reserved)
//              1000:TPM0 overflow
//              1001:TPM1 overflow
//              1010:TPM2 overflow
//              1011:(reserved)
//              1100:RTC alarm
//              1101:RTC seconds
//              1110:LPTMR trigger
//              1111:(reserved)
// 23-19:(reserved):read-only:0
//    18:CROT=counter reload on trigger (0)
//            should be changed only when counter disabled
//    17:CSOO=counter stop on overflow (0)
//            should be changed only when counter disabled
//    16:CSOT=counter start on trigger (0)
//            should be changed only when counter disabled
// 15-10:(reserved):read-only:000000
//     9:GTBEEN=global time base enable (0)
//     8:(reserved):read-only:0
//  7- 6:DBGMODE=debug mode (00)
//               00:paused during debug, and during debug
//                  trigger and input capture events ignored
//               01:(reserved)
//               10:(reserved)
//               11:counter continues during debug
//     5:DOZEEN=doze enable (0)
//              0:counter continues during debug
//              1:paused during debug, and during debug
//                trigger and input capture events ignored
//  4- 0:(reserved):read-only:0000
.set TPM_CONF_TRGSEL_MASK    ,  0x0F000000
.set TPM_CONF_TRGSEL_SHIFT   ,  24
.set TPM_CONF_CROT_MASK      ,  0x00040000
.set TPM_CONF_CROT_SHIFT     ,  18
.set TPM_CONF_CSOO_MASK      ,  0x00020000
.set TPM_CONF_CSOO_SHIFT     ,  17
.set TPM_CONF_CSOT_MASK      ,  0x00010000
.set TPM_CONF_CSOT_SHIFT     ,  16
.set TPM_CONF_GTBEEN_MASK    ,  0x200
.set TPM_CONF_GTBEEN_SHIFT   ,  9
.set TPM_CONF_DBGMODE_MASK   ,  0xC0
.set TPM_CONF_DBGMODE_SHIFT  ,  6
.set TPM_CONF_DOZEEN_MASK    ,  0x20
.set TPM_CONF_DOZEEN_SHIFT   ,  5
// ---------------------------------------------------------------
// TPMx_MOD:  Modulo
// 31-16:(reserved):read-only:0
// 16- 0:MOD (0xFFFF) (all bytes must be written at the same time)
.set TPM_MOD_MOD_MASK   , 0xFFFF
.set TPM_MOD_MOD_SHIFT  , 0
// ---------------------------------------------------------------
// TPMx_SC:  Status and Control
// 31-9:(reserved):read-only:0
//    8:DMA=DMA enable (0)
//    7:TOF=timer overflow flag (0)
//          set on count after TPMx_CNT = TPMx_MOD
//          write 1 to clear
//    6:TOIE=timer overflow interrupt enable (0)
//    5:CPWMS=center-aligned PWM select
//            0:edge align (up count)
//            1:center align (up-down count)
//  4-3:CMOD=clock mode selection (00)
//           00:counter disabled
//           01:TPMx_CNT increments on every TPMx clock
//           10:TPMx_CNT increments on rising edge of TPMx_EXTCLK
//           11:(reserved)
//  2-0:PS=prescale factor selection (000)
//         can be written only when counter is disabled
//         count clock = CMOD selected clock / 2^PS
.set TPM_SC_DMA_MASK     , 0x100
.set TPM_SC_DMA_SHIFT    , 8
.set TPM_SC_TOF_MASK     , 0x80
.set TPM_SC_TOF_SHIFT    , 7
.set TPM_SC_TOIE_MASK    , 0x40
.set TPM_SC_TOIE_SHIFT   , 6
.set TPM_SC_CPWMS_MASK   , 0x20
.set TPM_SC_CPWMS_SHIFT  , 5
.set TPM_SC_CMOD_MASK    , 0x18
.set TPM_SC_CMOD_SHIFT   , 3
.set TPM_SC_PS_MASK      , 0x07
.set TPM_SC_PS_SHIFT     , 0
// ---------------------------------------------------------------
// TPMx_STATUS:  Capture and Compare Status
// 31-9:(reserved):read-only:0
//    8:TOF=timer overflow flag=TPMx_SC.TOF: w1c (0)
//  7-6:(reserved):read-only:0
//    5:CH5F=channel 5 flag=TPMx_C5SC.CHF: w1c (0)
//    4:CH4F=channel 4 flag=TPMx_C4SC.CHF: w1c (0)
//    3:CH3F=channel 3 flag=TPMx_C3SC.CHF: w1c (0)
//    2:CH2F=channel 2 flag=TPMx_C2SC.CHF: w1c (0)
//    1:CH1F=channel 1 flag=TPMx_C1SC.CHF: w1c (0)
//    0:CH0F=channel 0 flag=TPMx_C0SC.CHF: w1c (0)
.set TPM_STATUS_TOF_MASK    , 0x100
.set TPM_STATUS_TOF_SHIFT   , 8
.set TPM_STATUS_CH5F_MASK   , 0x20
.set TPM_STATUS_CH5F_SHIFT  , 5
.set TPM_STATUS_CH4F_MASK   , 0x10
.set TPM_STATUS_CH4F_SHIFT  , 4
.set TPM_STATUS_CH3F_MASK   , 0x08
.set TPM_STATUS_CH3F_SHIFT  , 3
.set TPM_STATUS_CH2F_MASK   , 0x04
.set TPM_STATUS_CH2F_SHIFT  , 2
.set TPM_STATUS_CH1F_MASK   , 0x02
.set TPM_STATUS_CH1F_SHIFT  , 1
.set TPM_STATUS_CH0F_MASK   , 0x01
.set TPM_STATUS_CH0F_SHIFT  , 0
// ---------------------------------------------------------------
// UART 0
.set UART0_BASE  ,  0x4006A000
// UART_BASES  EQU  UART0_BASE
.set UART0_BDH_OFFSET  ,  0x00
.set UART0_BDL_OFFSET  ,  0x01
.set UART0_C1_OFFSET   ,  0x02
.set UART0_C2_OFFSET   ,  0x03
.set UART0_S1_OFFSET   ,  0x04
.set UART0_S2_OFFSET   ,  0x05
.set UART0_C3_OFFSET   ,  0x06
.set UART0_D_OFFSET    ,  0x07
.set UART0_MA1_OFFSET  ,  0x08
.set UART0_MA2_OFFSET  ,  0x09
.set UART0_C4_OFFSET   ,  0x0A
.set UART0_C5_OFFSET   ,  0x0B
.set UART0_BDH        ,  (UART0_BASE + UART0_BDH_OFFSET)
.set UART0_BDL        ,  (UART0_BASE + UART0_BDL_OFFSET)
.set UART0_C1         ,  (UART0_BASE + UART0_C1_OFFSET)
.set UART0_C2         ,  (UART0_BASE + UART0_C2_OFFSET)
.set UART0_S1         ,  (UART0_BASE + UART0_S1_OFFSET)
.set UART0_S2         ,  (UART0_BASE + UART0_S2_OFFSET)
.set UART0_C3         ,  (UART0_BASE + UART0_C3_OFFSET)
.set UART0_D          ,  (UART0_BASE + UART0_D_OFFSET)
.set UART0_MA1        ,  (UART0_BASE + UART0_MA1_OFFSET)
.set UART0_MA2        ,  (UART0_BASE + UART0_MA2_OFFSET)
.set UART0_C4         ,  (UART0_BASE + UART0_C4_OFFSET)
.set UART0_C5         ,  (UART0_BASE + UART0_C5_OFFSET)
// ---------------------------------------------------------------
// UART0_BDH
//   7:LBKDIE=LIN break detect IE
//   6:RXEDGIE=RxD input active edge IE
//   5:SBNS=Stop bit number select
// 4-0:SBR[12:0] (BUSCLK / (16 x 9600))
.set UART0_BDH_LBKDIE_MASK    ,  0x80
.set UART0_BDH_LBKDIE_SHIFT   ,  7
.set UART0_BDH_RXEDGIE_MASK   ,  0x40
.set UART0_BDH_RXEDGIE_SHIFT  ,  6
.set UART0_BDH_SBNS_MASK      ,  0x20
.set UART0_BDH_SBNS_SHIFT     ,  5
.set UART0_BDH_SBR_MASK       ,  0x1F
.set UART0_BDH_SBR_SHIFT      ,  0
// ---------------------------------------------------------------
// UART0_BDL
// 7-0:SBR[7:0] (BUSCLK / 16 x 9600))
.set UART0_BDL_SBR_MASK   ,  0xFF
.set UART0_BDL_SBR_SHIFT  ,  0
// ---------------------------------------------------------------
// UART0_C1
// 7:LOOPS=loop mode select (normal)
// 6:DOZEEN=UART disabled in wait mode (enabled)
// 5:RSRC=receiver source select (internal--no effect LOOPS=0)
// 4:M=9- or 8-bit mode select (1 start, 8 data [lsb first], 1 stop)
// 3:WAKE=receiver wakeup method select (idle)
// 2:IDLE=idle line type select (idle begins after start bit)
// 1:PE=parity enable (disabled)
// 0:PT=parity type (even parity--no effect PE=0)
.set UART0_C1_LOOPS_MASK      ,  0x80
.set UART0_C1_LOOPS_SHIFT     ,  7
.set UART0_C1_DOZEEN_MASK     ,  0x40
.set UART0_C1_DOZEEN_SHIFT    ,  6
.set UART0_C1_RSRC_MASK       ,  0x20
.set UART0_C1_RSRC_SHIFT      ,  5
.set UART0_C1_M_MASK          ,  0x10
.set UART0_C1_M_SHIFT         ,  4
.set UART0_C1_WAKE_MASK       ,  0x08
.set UART0_C1_WAKE_SHIFT      ,  3
.set UART0_C1_ILT_MASK        ,  0x04
.set UART0_C1_ILT_SHIFT       ,  2
.set UART0_C1_PE_MASK         ,  0x02
.set UART0_C1_PE_SHIFT        ,  1
.set UART0_C1_PT_MASK         ,  0x01
.set UART0_C1_PT_SHIFT        ,  0
// ---------------------------------------------------------------
// UART0_C2
// 7:TIE=transmitter IE for TDRE (disabled)
// 6:TCIE=trasmission complete IE for TC (disabled)
// 5:RIE=receiver IE for RDRF (disabled)
// 4:ILIE=idle line IE for IDLE (disabled)
// 3:TE=transmitter enable (disabled)
// 2:RE=receiver enable (disabled)
// 1:RWU=receiver wakeup control (normal)
// 0:SBK=send break (disabled, normal)
.set UART0_C2_TIE_MASK    ,  0x80
.set UART0_C2_TIE_SHIFT   ,  7
.set UART0_C2_TCIE_MASK   ,  0x40
.set UART0_C2_TCIE_SHIFT  ,  6
.set UART0_C2_RIE_MASK    ,  0x20
.set UART0_C2_RIE_SHIFT   ,  5
.set UART0_C2_ILIE_MASK   ,  0x10
.set UART0_C2_ILIE_SHIFT  ,  4
.set UART0_C2_TE_MASK     ,  0x08
.set UART0_C2_TE_SHIFT    ,  3
.set UART0_C2_RE_MASK     ,  0x04
.set UART0_C2_RE_SHIFT    ,  2
.set UART0_C2_RWU_MASK    ,  0x02
.set UART0_C2_RWU_SHIFT   ,  1
.set UART0_C2_SBK_MASK    ,  0x01
.set UART0_C2_SBK_SHIFT   ,  0
// ---------------------------------------------------------------
// UART0_C3
// 7:R8T9=Receive bit 8; transmit bit 9 (not used M=0)
// 6:R9T8=Receive bit 9; transmit bit 8 (not used M=0)
// 5:TXDIR=TxD pin direction in single-wire mode 
//                         (input--no effect LOOPS=0)
// 4:TXINV=transmit data inversion (not invereted)
// 3:ORIE=overrun IE for OR (disabled)
// 2:NEIE=noise error IE for NF (disabled)
// 1:FEIE=framing error IE for FE (disabled)
// 0:PEIE=parity error IE for PF (disabled)
.set UART0_C3_R8T9_MASK    ,  0x80
.set UART0_C3_R8T9_SHIFT   ,  7
.set UART0_C3_R9T8_MASK    ,  0x40
.set UART0_C3_R9T8_SHIFT   ,  6
.set UART0_C3_TXDIR_MASK   ,  0x20
.set UART0_C3_TXDIR_SHIFT  ,  5
.set UART0_C3_TXINV_MASK   ,  0x10
.set UART0_C3_TXINV_SHIFT  ,  4
.set UART0_C3_ORIE_MASK    ,  0x08
.set UART0_C3_ORIE_SHIFT   ,  3
.set UART0_C3_NEIE_MASK    ,  0x04
.set UART0_C3_NEIE_SHIFT   ,  2
.set UART0_C3_FEIE_MASK    ,  0x02
.set UART0_C3_FEIE_SHIFT   ,  1
.set UART0_C3_PEIE_MASK    ,  0x01
.set UART0_C3_PEIE_SHIFT   ,  0
// ---------------------------------------------------------------
// UART0_C4
//   7:MAEN1=Match address mode enable 1 (disabled)
//   6:MAEN2=Match address mode enable 2 (disabled)
//   5:M10=10-bit mode select (not selected)
// 4-0:OSR=Over sampling ratio (01111)
//         00000 <= OSR <= 00010:  (invalid; defaults to ratio = 16)        
//         00011 <= OSR <= 11111:  ratio = OSR + 1
.set UART0_C4_MAEN1_MASK   ,  0x80
.set UART0_C4_MAEN1_SHIFT  ,  7
.set UART0_C4_MAEN2_MASK   ,  0x40
.set UART0_C4_MAEN2_SHIFT  ,  6
.set UART0_C4_M10_MASK     ,  0x20
.set UART0_C4_M10_SHIFT    ,  5
.set UART0_C4_OSR_MASK     ,  0x1F
.set UART0_C4_OSR_SHIFT    ,  0
// ---------------------------------------------------------------
// UART0_C5
//   7:TDMAE=Transmitter DMA enable (disabled)
//   6:(reserved):  read-only:  0
//   5:RDMAE=Receiver full DMA enable (disabled)
// 4-2:(reserved):  read-only:  000
//   1:BOTHEDGE=Both edge sampling (only rising edge)
//   0:RESYNCDIS=Resynchronization disable (enabled)
.set UART0_C5_TDMAE_MASK       ,  0x80
.set UART0_C5_TDMAE_SHIFT      ,  7
.set UART0_C5_RDMAE_MASK       ,  0x20
.set UART0_C5_RDMAE_SHIFT      ,  5
.set UART0_C5_BOTHEDGE_MASK    ,  0x02
.set UART0_C5_BOTHEDGE_SHIFT   ,  1
.set UART0_C5_RESYNCDIS_MASK   ,  0x01
.set UART0_C5_RESYNCDIS_SHIFT  ,  0
// ---------------------------------------------------------------
// UART0_D
// 7:R7T7=Receive data buffer bit 7; 
//        transmit data buffer bit 7
// 6:R6T6=Receive data buffer bit 6; 
//        transmit data buffer bit 6
// 5:R5T5=Receive data buffer bit 5; 
//        transmit data buffer bit 5
// 4:R4T4=Receive data buffer bit 4; 
//        transmit data buffer bit 4
// 3:R3T3=Receive data buffer bit 3; 
//        transmit data buffer bit 3
// 2:R2T2=Receive data buffer bit 2; 
//        transmit data buffer bit 2
// 1:R1T1=Receive data buffer bit 1; 
//        transmit data buffer bit 1
// 0:R0T0=Receive data buffer bit 0; 
//        transmit data buffer bit 0
.set UART0_D_R7T7_MASK   ,  0x80
.set UART0_D_R7T7_SHIFT  ,  7
.set UART0_D_R6T6_MASK   ,  0x40
.set UART0_D_R6T6_SHIFT  ,  6
.set UART0_D_R5T5_MASK   ,  0x20
.set UART0_D_R5T5_SHIFT  ,  5
.set UART0_D_R4T4_MASK   ,  0x10
.set UART0_D_R4T4_SHIFT  ,  4
.set UART0_D_R3T3_MASK   ,  0x08
.set UART0_D_R3T3_SHIFT  ,  3
.set UART0_D_R2T2_MASK   ,  0x04
.set UART0_D_R2T2_SHIFT  ,  2
.set UART0_D_R1T1_MASK   ,  0x02
.set UART0_D_R1T1_SHIFT  ,  1
.set UART0_D_R0T0_MASK   ,  0x01
.set UART0_D_R0T0_SHIFT  ,  0
// ---------------------------------------------------------------
// UART0_MA1
// 7-0:MA=Match address
.set UART0_MA1_MA_MASK   ,  0xFF
.set UART0_MA1_MA_SHIFT  ,  0
// ---------------------------------------------------------------
// UART0_MA2
// 7-0:MA=Match address
.set UART0_MA2_MA_MASK   ,  0xFF
.set UART0_MA2_MA_SHIFT  ,  0
// ---------------------------------------------------------------
// UART0_S1
// 7:TDRE=transmit data register empty flag
// 6:TC=transmission complete flag
// 5:RDRF=receive data register full flag
// 4:IDLE=idle line flag
// 3:OR=receiver overrun flag
// 2:NF=noise flag
// 1:FE=framing error flag
// 0:PF=parity error flag
.set UART0_S1_TDRE_MASK   , 0x80
.set UART0_S1_TDRE_SHIFT  , 7
.set UART0_S1_TC_MASK     , 0x40
.set UART0_S1_TC_SHIFT    , 6
.set UART0_S1_RDRF_MASK   , 0x20
.set UART0_S1_RDRF_SHIFT  , 5
.set UART0_S1_IDLE_MASK   , 0x10
.set UART0_S1_IDLE_SHIFT  , 4
.set UART0_S1_OR_MASK     , 0x08
.set UART0_S1_OR_SHIFT    , 3
.set UART0_S1_NF_MASK     , 0x04
.set UART0_S1_NF_SHIFT    , 2
.set UART0_S1_FE_MASK     , 0x02
.set UART0_S1_FE_SHIFT    , 1
.set UART0_S1_PF_MASK     , 0x01
.set UART0_S1_PF_SHIFT    , 0
// ---------------------------------------------------------------
// UART0_S2
// 7:LBKDIF=LIN break detect interrupt flag
// 6:RXEDGIF=RxD pin active edge interrupt flag
// 5:MSBF=MSB first (LSB first)
// 4:RXINV=receive data inversion (not inverted)
// 3:RWUID=receive wake-up idle detect (not detected)
// 2:BRK13=break character generation length (10 bit times)
// 1:LBKDE=LIN break detect enable (10 bit times)
// 0:RAF=receiver active flag
.set UART0_S2_LBKDIF_MASK   , 0x80
.set UART0_S2_LBKDIF_SHIFT  , 7
.set UART0_S2_RXEDGIF_MASK  , 0x40
.set UART0_S2_RXEDGIF_SHIFT , 6
.set UART0_S2_MSBF_MASK     , 0x20
.set UART0_S2_MSBF_SHIFT    , 5
.set UART0_S2_RXINV_MASK    , 0x10
.set UART0_S2_RXINV_SHIFT   , 4
.set UART0_S2_RWUID_MASK    , 0x08
.set UART0_S2_RWUID_SHIFT   , 3
.set UART0_S2_BRK13_MASK    , 0x04
.set UART0_S2_BRK13_SHIFT   , 2
.set UART0_S2_LBKDE_MASK    , 0x02
.set UART0_S2_LBKDE_SHIFT   , 1
.set UART0_S2_RAF_MASK      , 0x01
.set UART0_S2_RAF_SHIFT     , 0
// ---------------------------------------------------------------
