.nolist
.include "mkl05z4.s"
.list

.syntax unified
.thumb

.set PORT_PCR_SET_PTB2_UART0_RX  ,  (PORT_PCR_ISF_MASK | PORT_PCR_MUX_SELECT_2_MASK) 
.set PORT_PCR_SET_PTB1_UART0_TX  ,  (PORT_PCR_ISF_MASK | PORT_PCR_MUX_SELECT_2_MASK) 
.set SIM_SOPT2_UART0SRC_MCGFLLCLK  ,  (1 << SIM_SOPT2_UART0SRC_SHIFT) 
.set SIM_SOPT5_UART0_EXTERN_MASK_CLEAR  , (SIM_SOPT5_UART0ODE_MASK | SIM_SOPT5_UART0RXSRC_MASK | SIM_SOPT5_UART0TXSRC_MASK)
.set UART0_BDH_9600  ,  0x01 
.set UART0_BDL_9600  ,  0x38 
.set UART0_C1_8N1  ,  0x00 
.set UART0_C2_T_R  ,  (UART0_C2_TE_MASK | UART0_C2_RE_MASK) 
.set UART0_C3_NO_TXINV  ,  0x00
.set UART0_C4_OSR_16           ,  0x0F 
.set UART0_C4_NO_MATCH_OSR_16  ,  UART0_C4_OSR_16 
.set UART0_C5_NO_DMA_SSR_SYNC  ,  0x00 
.set UART0_S1_CLEAR_FLAGS  ,  (UART0_S1_IDLE_MASK | UART0_S1_OR_MASK |    UART0_S1_NF_MASK |  UART0_S1_FE_MASK | UART0_S1_PF_MASK) 
.set UART0_S2_NO_RXINV_BRK10_NO_LBKDETECT_CLEAR_FLAGS  ,  (UART0_S2_LBKDIF_MASK | UART0_S2_RXEDGIF_MASK) 

.section code, "ax"
.global Reset_Handler
Reset_Handler:
    cpsid I
    bl Startup
    bl Init_UART0_IRQ
    cpsie I
    b .

UART0_ISR:
    bx lr

Init_UART0_IRQ:
            PUSH {R0, R1, R2, LR}
            bl init_queue
            bl init_queue
            // Select MCGFLLCLK as UART0 clock source 
            LDR   R0,=SIM_SOPT2 
            LDR   R1,=SIM_SOPT2_UART0SRC_MASK 
            LDR   R2,[R0,#0] 
            BICS  R2,R2,R1 
            LDR   R1,=SIM_SOPT2_UART0SRC_MCGFLLCLK 
            ORRS  R2,R2,R1 
            STR   R2,[R0,#0] 
            // Set UART0 for external connection 
            LDR   R0,=SIM_SOPT5 
            LDR   R1,=SIM_SOPT5_UART0_EXTERN_MASK_CLEAR 
            LDR   R2,[R0,#0] 
            BICS  R2,R2,R1 
            STR   R2,[R0,#0] 
            // Enable UART0 module clock 
            LDR   R0,=SIM_SCGC4 
            LDR   R1,=SIM_SCGC4_UART0_MASK 
            LDR   R2,[R0,#0] 
            ORRS  R2,R2,R1 
            STR   R2,[R0,#0] 
            // Enable PORT B module clock 
            LDR   R0,=SIM_SCGC5 
            LDR   R1,=SIM_SCGC5_PORTB_MASK 
            LDR   R2,[R0,#0] 
            ORRS  R2,R2,R1 
            STR   R2,[R0,#0] 
            // Select PORT B Pin 2 (D0) for UART0 RX (J8 Pin 01) 
            LDR     R0,=PORTB_PCR2 
            LDR     R1,=PORT_PCR_SET_PTB2_UART0_RX 
            STR     R1,[R0,#0] 
            //  Select PORT B Pin 1 (D1) for UART0 TX (J8 Pin 02) 
            LDR     R0,=PORTB_PCR1 
            LDR     R1,=PORT_PCR_SET_PTB1_UART0_TX 
            STR     R1,[R0,#0] 
            // Disable UART0 receiver and transmitter 
            LDR   R0,=UART0_BASE 
            MOVS  R1,#UART0_C2_T_R 
            LDRB  R2,[R0,#UART0_C2_OFFSET] 
            BICS  R2,R2,R1 
            STRB  R2,[R0,#UART0_C2_OFFSET] 
            // Set UART0 for 9600 baud, 8N1 protocol 
            MOVS  R1,#UART0_BDH_9600 
            STRB  R1,[R0,#UART0_BDH_OFFSET] 
            MOVS  R1,#UART0_BDL_9600 
            STRB  R1,[R0,#UART0_BDL_OFFSET] 
            MOVS  R1,#UART0_C1_8N1 
            STRB  R1,[R0,#UART0_C1_OFFSET] 
            MOVS  R1,#UART0_C3_NO_TXINV 
            STRB  R1,[R0,#UART0_C3_OFFSET] 
            MOVS  R1,#UART0_C4_NO_MATCH_OSR_16 
            STRB  R1,[R0,#UART0_C4_OFFSET] 
            MOVS  R1,#UART0_C5_NO_DMA_SSR_SYNC 
            STRB  R1,[R0,#UART0_C5_OFFSET] 
            MOVS  R1,#UART0_S1_CLEAR_FLAGS 
            STRB  R1,[R0,#UART0_S1_OFFSET] 
            MOVS  R1, #UART0_S2_NO_RXINV_BRK10_NO_LBKDETECT_CLEAR_FLAGS 
            STRB  R1,[R0,#UART0_S2_OFFSET] 
            // Enable UART0 receiver and transmitter 
            MOVS  R1,#UART0_C2_T_R 
            STRB  R1,[R0,#UART0_C2_OFFSET] 

            POP {R0, R1, R2}
            BX LR

// ****************************************************************
// Vector Table Mapped to Address 0 at Reset
// Linker requires __Vectors to be exported
.section RESET, "a"
            //  EXPORT  __Vectors
            //  EXPORT  __Vectors_End
            //  EXPORT  __Vectors_Size
            //  IMPORT  __initial_sp
            //  IMPORT  Dummy_Handler
            //  IMPORT  HardFault_Handler
__Vectors:
                                      // ARM core vectors
            .word    __initial_sp       // 00:end of stack
            .word    Reset_Handler      // 01:reset vector
            .word    Dummy_Handler      // 02:NMI
            .word    HardFault_Handler  // 03:hard fault
            .word    Dummy_Handler      // 04:(reserved)
            .word    Dummy_Handler      // 05:(reserved)
            .word    Dummy_Handler      // 06:(reserved)
            .word    Dummy_Handler      // 07:(reserved)
            .word    Dummy_Handler      // 08:(reserved)
            .word    Dummy_Handler      // 09:(reserved)
            .word    Dummy_Handler      // 10:(reserved)
            .word    Dummy_Handler      // 11:SVCall (supervisor call)
            .word    Dummy_Handler      // 12:(reserved)
            .word    Dummy_Handler      // 13:(reserved)
            .word    Dummy_Handler      // 14:PendSV (PendableSrvReq)
                                      //    pendable request 
                                      //    for system service)
            .word    Dummy_Handler      // 15:SysTick (system tick timer)
            .word    Dummy_Handler      // 16:DMA channel 0 transfer 
                                      //    complete/error
            .word    Dummy_Handler      // 17:DMA channel 1 transfer
                                      //    complete/error
            .word    Dummy_Handler      // 18:DMA channel 2 transfer
                                      //    complete/error
            .word    Dummy_Handler      // 19:DMA channel 3 transfer
                                      //    complete/error
            .word    Dummy_Handler      // 20:(reserved)
            .word    Dummy_Handler      // 21:FTFA command complete/
                                      //    read collision
            .word    Dummy_Handler      // 22:low-voltage detect;
                                      //    low-voltage warning
            .word    Dummy_Handler      // 23:low leakage wakeup
            .word    Dummy_Handler      // 24:I2C0
            .word    Dummy_Handler      // 25:(reserved)
            .word    Dummy_Handler      // 26:SPI0
            .word    Dummy_Handler      // 27:(reserved)
            .word    UART0_ISR          // 28:UART0 (status; error)
            .word    Dummy_Handler      // 29:(reserved)
            .word    Dummy_Handler      // 30:(reserved)
            .word    Dummy_Handler      // 31:ADC0
            .word    Dummy_Handler      // 32:CMP0
            .word    Dummy_Handler      // 33:TPM0
            .word    Dummy_Handler      // 34:TPM1
            .word    Dummy_Handler      // 35:(reserved)
            .word    Dummy_Handler      // 36:RTC (alarm)
            .word    Dummy_Handler      // 37:RTC (seconds)
            .word    Dummy_Handler      // 38:PIT
            .word    Dummy_Handler      // 39:(reserved)
            .word    Dummy_Handler      // 40:(reserved)
            .word    Dummy_Handler      // 41:DAC0
            .word    Dummy_Handler      // 42:TSI0
            .word    Dummy_Handler      // 43:MCG
            .word    Dummy_Handler      // 44:LPTMR0
            .word    Dummy_Handler      // 45:(reserved)
            .word    Dummy_Handler      // 46:PORTA
            .word    Dummy_Handler      // 47:PORTB
__Vectors_End:
.set __Vectors_Size, __Vectors_End - __Vectors
.balign 4
// ****************************************************************
.section const, "a"
test:
.word 0x01234567
.section data, "aw", %nobits
test1:
.skip 0x8
