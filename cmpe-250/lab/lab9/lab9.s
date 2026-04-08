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

// Offsets from base record
.set in_ptr, 0
.set out_ptr, 4
.set buf_start, 8
.set buf_past, 12
.set buf_size, 16
.set num_enqd, 17

// Sizes of buffers and records
.set rx_qbuf_sz, 80
.set rx_qrec_sz, 18
.set tx_qbuf_sz, 80
.set tx_qrec_sz, 18

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
            push {r0, r1, r2, lr}
            // Initialize queues
            ldr r0, =rx_buffer
            ldr r1, =rx_record
            movs r2, #rx_qbuf_sz
            bl init_queue
            ldr r0, =tx_buffer
            ldr r1, =tx_record
            bl init_queue
            // Select MCGFLLCLK as UART0 clock source 
            ldr   r0,=SIM_SOPT2 
            ldr   r1,=SIM_SOPT2_UART0SRC_MASK 
            ldr   r2,[r0,#0] 
            bics  r2,r2,r1 
            ldr   r1,=SIM_SOPT2_UART0SRC_MCGFLLCLK 
            orrs  r2,r2,r1 
            str   r2,[r0,#0] 
            // Set UART0 for external connection 
            ldr   r0,=SIM_SOPT5 
            ldr   r1,=SIM_SOPT5_UART0_EXTERN_MASK_CLEAR 
            ldr   r2,[r0,#0] 
            bics  r2,r2,r1 
            str   r2,[r0,#0] 
            // Enable UART0 module clock 
            ldr   r0,=SIM_SCGC4 
            ldr   r1,=SIM_SCGC4_UART0_MASK 
            ldr   r2,[r0,#0] 
            orrs  r2,r2,r1 
            str   r2,[r0,#0] 
            // Enable PORT B module clock 
            ldr   r0,=SIM_SCGC5 
            ldr   r1,=SIM_SCGC5_PORTB_MASK 
            ldr   r2,[r0,#0] 
            orrs  r2,r2,r1 
            str   r2,[r0,#0] 
            // Select PORT B Pin 2 (D0) for UART0 RX (J8 Pin 01) 
            ldr     r0,=PORTB_PCR2 
            ldr     r1,=PORT_PCR_SET_PTB2_UART0_RX 
            str     r1,[r0,#0] 
            //  Select PORT B Pin 1 (D1) for UART0 TX (J8 Pin 02) 
            ldr     r0,=PORTB_PCR1 
            ldr     r1,=PORT_PCR_SET_PTB1_UART0_TX 
            str     r1,[r0,#0] 
            // Disable UART0 receiver and transmitter 
            ldr   r0,=UART0_BASE 
            movs  r1,#UART0_C2_T_R 
            ldrb  r2,[r0,#UART0_C2_OFFSET] 
            bics  r2,r2,r1 
            strb  r2,[r0,#UART0_C2_OFFSET] 
            // Set UART0 for 9600 baud, 8N1 protocol 
            movs  r1,#UART0_BDH_9600 
            strb  r1,[r0,#UART0_BDH_OFFSET] 
            movs  r1,#UART0_BDL_9600 
            strb  r1,[r0,#UART0_BDL_OFFSET] 
            movs  r1,#UART0_C1_8N1 
            strb  r1,[r0,#UART0_C1_OFFSET] 
            movs  r1,#UART0_C3_NO_TXINV 
            strb  r1,[r0,#UART0_C3_OFFSET] 
            movs  r1,#UART0_C4_NO_MATCH_OSR_16 
            strb  r1,[r0,#UART0_C4_OFFSET] 
            movs  r1,#UART0_C5_NO_DMA_SSR_SYNC 
            strb  r1,[r0,#UART0_C5_OFFSET] 
            movs  r1,#UART0_S1_CLEAR_FLAGS 
            strb  r1,[r0,#UART0_S1_OFFSET] 
            movs  r1, #UART0_S2_NO_RXINV_BRK10_NO_LBKDETECT_CLEAR_FLAGS 
            strb  r1,[r0,#UART0_S2_OFFSET] 
            // Enable UART0 receiver and transmitter 
            movs  r1,#UART0_C2_T_R 
            strb  r1,[r0,#UART0_C2_OFFSET] 

            pop {r0, r1, r2}
            bx lr


/** Initialize queue record
  *
  * Inputs:
  *     R0 : buffer address
  *     R1 : record address
  *     R2 : buffer capacity
  * Outputs:
  *     None
  * Modified:
  *     psr
  */
init_queue:
            push {r3}
            // In pointer
            str r0, [r1, #in_ptr]
            // Out pointer
            str r0, [r1, #out_ptr]
            // Buffer start
            str r0, [r1, #buf_start]
            // Buffer end
            adds r3, r0, r2
            subs r3, #1
            str r3, [r1, #buf_past]
            // Buffer size
            strb r2, [r1, #buf_size]
            // Number enqueued
            movs r3, #0
            strb r3, [r1, #num_enqd]
            pop {r3}
            bx lr


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
rx_buffer:
.skip rx_qbuf_sz
rx_record:
.skip rx_qrec_sz

.balign 4

tx_buffer:
.skip tx_qbuf_sz
tx_record:
.skip tx_qrec_sz
