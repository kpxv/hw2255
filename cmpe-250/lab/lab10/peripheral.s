.nolist
.include "mkl05z4.s"
.include "equ_lab10.s"
.list

.syntax unified
.thumb

.section code, "ax"
/**
  * Initialize UART for interrupt control at 9600 baud 8N1
  *
  * Inputs:
  *     none
  * Outputs:
  *     none
  * Modifies:
  *     psr
  */
.global Init_UART0_IRQ
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
            // Init NVIC
            // Set UART0 IRQ priority
            ldr r0, =UART0_IPR
            ldr r2, =NVIC_IPR_UART0_PRI_3
            ldr r3, [r0]
            orrs r3, r2
            str r3, [r0]
            // Clear pending interrupts
            ldr r0, =NVIC_ICPR
            ldr r1, =NVIC_IPR_UART0_MASK
            str r1, [r0]
            // Unmask interrupts
            ldr r0, =NVIC_ISER
            ldr r1, =NVIC_ISER_UART0_MASK
            str r1, [r0]
            // Set UART0 for 9600 baud, 8N1 protocol 
            ldr   r0, =UART0_BASE
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
            movs  r1,#UART0_C2_T_RI
            strb  r1,[r0,#UART0_C2_OFFSET] 
            pop {r0, r1, r2, pc}



/**
  * Initialize PIT module to use 10ms clock, timer freeze in debug, interrupts,
  * and no chain mode.
  *
  * Inputs:
  *     none
  * Outputs:
  *     none
  * Modifies:
  *     psr
  */
.global Init_PIT_IRQ
Init_PIT_IRQ:
            push {r0-r3}
            // Disable PIT for setup and disable timer in debug
            ldr r0, =PIT_BASE
            ldr r1, [r0, #PIT_MCR_OFFSET]
            movs r2, #PIT_MCR_MF
            ands r1, r2
            str r1, [r0, #PIT_MCR_OFFSET]
            // Allow PIT clock
            ldr r0, =SIM_BASE
            ldr r1, =SIM_SCGC6_OFFSET
            ldr r2, [r0, r1]
            movs r3, #1
            lsls r3, #SIM_SCGC6_PIT_SHIFT
            ands r2, r3
            str r2, [r0, r1]
            // Disable timer and timer interrupt
            ldr r1, =PIT_TCTRL0_OFFSET
            movs r2, #0
            str r2, [r0, r1]
            // NVIC interrupts
            // Does this order matter?
            // Set PIT interrupt priority
            ldr r0, =PIT_IPR
            ldr r1, [r0]
            ldr r2, =NVIC_IPR_PIT_PRI_0
            orrs r1, r2
            str r1, [r0]
            // Clear pending PIT interrupts
            ldr r0, =NVIC_ICPR
            str r1, [r0]
            // Enable PIT interrupts
            ldr r0, =NVIC_ISER
            ldr r1, =PIT_IRQ_MASK
            str r1, [r0]
            // Enable PIT module
            // Why is this here? Shouldn't it be at the end?
            ldr r0, =PIT_BASE
            ldr r1, [r0, #PIT_MCR_OFFSET]
            movs r2, #PIT_MCR_MDIS_MASK
            bics r1, r2
            str r1, [r0, #PIT_MCR_OFFSET]
            // Set PIT timer value
            // Wtf? This seems like setup
            ldr r0, =PIT_CH0_BASE
            ldr r1, =PIT_LDVAL_10ms
            str r1, [r0, #PIT_LDVAL_OFFSET]
            // Enable timer and timer interrupt; disable chain mode
            // Still seems like setup
            ldr r1, =PIT_TCTRL0_OFFSET
            movs r2, #PIT_TCTRL_TIE_TEN_MASK
            str r2, [r0, r1]
            pop {r0-r3}
            bx lr



/**
  * Handle PIT interrupts
  *
  * Inputs:
  *     none
  * Outputs:
  *     none
  * Modifies:
  *     psr
  */
.global PIT_ISR
PIT_ISR:
    // Increment only if run_stop_watch is set
    ldr r0, =run_stop_watch
    cmp r0, #0
    beq PIT_ISR_exit
    ldr r0, =pit_count
    ldr r1, [r0]
    adds r1, #1
    str r1, [r0]
PIT_ISR_exit:
    // Clear interrupt
    ldr r0, =PIT_CH0_BASE
    ldr r1, =PIT_TFLG_TIF_MASK
    str r1, [r0, #PIT_TFLG_OFFSET]
    bx lr



/**
  * Handle UART interrupts
  *
  * Inputs:
  *     none
  * Outputs:
  *     none
  * Modifies:
  *     psr
  */
.global UART0_ISR
UART0_ISR:
            cpsid I
            push {lr}
            ldr r2, =UART0_BASE
            ldrb r1, [r2, #UART0_C2_OFFSET]
            ldr r3, =UART0_C2_TIE_MASK
            ands r1, r3
            // Check tx interrupt enabled
            cmp r1, #0
            // If disabled, jump to rx interrupt check
            beq UART0_ISR_rxint
            // Else, check tx interrupt
            ldrb r1, [r2, #UART0_S1_OFFSET]
            ldr r3, =UART0_S1_TDRE_MASK
            ands r1, r3
            cmp r1, #0
            // If disabled, jump to rx interrupt check
            beq UART0_ISR_rxint
            // Else, dequeue
            ldr r1, =tx_record
            bl Dequeue
            bcs UART0_ISR_disable_tx
            // If successful, store
            strb r0, [r2, #UART0_D_OFFSET]
            b UART0_ISR_rxint
            // Else, disable tx
UART0_ISR_disable_tx:
            ldr r1, =UART0_C2_T_RI
            strb r1, [r2, #UART0_C2_OFFSET]
            // Check rx interrupt
UART0_ISR_rxint:
            ldrb r1, [r2, #UART0_S1_OFFSET]
            ldr r3, =UART0_S1_RDRF_MASK
            ands r1, r3
            cmp r1, #0
            // Exit if rx interrupt not set
            beq UART0_ISR_exit
            // Otherwise, enqueue
            ldrb r0, [r2, #UART0_D_OFFSET]
            ldr r1, =rx_record
            bl Enqueue
UART0_ISR_exit:
            cpsie I
            pop {pc}




/**
  * Get a byte from UART0
  *
  * Inputs:
  *     none, but requires rx_record to be defined
  * Outputs:
  *     r0 : returned byte
  * Modifies:
  *     r0
  *     psr
  */
.global GetChar
GetChar:
            push {r1, lr}
GetChar_loop:
            cpsid I
            ldr r1, =rx_record
            bl Dequeue
            cpsie I
            bcs GetChar_loop
            bl Dequeue
            pop {r1, pc}



/**
  * Send a byte over UART0
  *
  * Inputs:
  *     r0 : byte to send
  *     requires tx_record to be defined
  * Outputs:
  *     none
  * Modifies:
  *     psr
  */
.global PutChar
PutChar:
            push {r1, r2, lr}
PutChar_loop:
            // Put char
            cpsid I
            ldr r1, =tx_record
            bl Enqueue
            cpsie I
            bcs PutChar_loop
            // Enable transmit interrupt
            ldr r1, =UART0_BASE
            ldr r2, =UART0_C2_TI_RI
            strb r2, [r1, #UART0_C2_OFFSET]
            pop {r1, r2, pc}



/** Initialize queue record
  *
  * Inputs:
  *     R0 : buffer address
  *     R1 : record address
  *     R2 : buffer capacity
  * Outputs:
  *     None
  * Modifies:
  *     psr
  */
.global init_queue
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



/**
  * Increment queue pointer
  *
  * Inputs:
  *     R1 : record address
  *     R2 : pointer
  * Outputs:
  *     R2 : incremented pointer
  * Modifies:
  *     R2
  *     psr
  */
.global Pointer_inc
Pointer_inc:
            push {r0, r3}
            // Load end of buffer
            movs r0, r2
            ldr r3, [r1, #buf_past]
            // If pointer is at the end of the buffer
            cmp r0, r3
            // Wrap
            beq Pointer_inc_wrap
            // Else increment
            adds r0, r0, #1
            b Pointer_inc_exit
Pointer_inc_wrap:
            // Wrap by setting pointer to start of buffer
            ldr r0, [r1, #buf_start]
Pointer_inc_exit:
            // Return
            movs r2, r0
            pop {r0, r3}
            bx lr



/**
  * Attempt to get char from queue
  *
  * Inputs:
  *     R1 : record address
  * Outputs:
  *     R0 : dequeued character
  *     psr : clear c iff successful
  * Modifies:
  *     R0, iff DEQUEUE successful
  *     psr
  */
.global Dequeue
Dequeue:
            push {r2, lr}
            // Check if empty
            ldrb r2, [r1, #num_enqd]
            cmp r2, #0
            BEQ Dequeue_empty
            // Get from queue
            ldr r2, [r1, #out_ptr]
            ldrb r0, [r2]
            // Increment pointer
            bl Pointer_inc
            str r2, [r1, #out_ptr]
            // Decrement num enqueued
            ldrb r2, [r1, #num_enqd]
            subs r2, r2, #1
            strb r2, [r1, #num_enqd]
            // Clear C flag
            adds r2, #0
            B Dequeue_exit
Dequeue_empty:
            // Set C flag
            MOVS R2, #0
            MVNS R2, R2
            ADDS R2, R2, #1
Dequeue_exit:
            POP {R2, PC}



/**
  * Attempt to put char in queue
  *
  * Inputs:
  *     R0 : ENQUEUE char
  *     R1 : record address
  * Outputs:
  *     psr: clear c iff ENQUEUE successful
  * Modifies:
  *     psr
  */
.global Enqueue
Enqueue:
            push {r2-r3, lr}
            // Check if full
            ldrb r2, [r1, #buf_size]
            ldrb r3, [r1, #num_enqd]
            cmp r2, r3
            beq Enqueue_full
            // Store to queue
            ldr r2, [r1, #in_ptr]
            strb r0, [r2]
            // Increment in pointer
            bl Pointer_inc
            str r2, [r1, #in_ptr]
            // Increment num enqueued
            adds r3, r3, #1
            strb r3, [r1, #num_enqd]
            // Clear C flag
            adds r2, #0
            b Enqueue_exit
Enqueue_full:
            // Set C flag
            movs r2, #0
            mvns r2, r2
Enqueue_exit:
            pop {r2-r3, pc}



.section data, "aw", %nobits
// Receive queue variables
.balign WORD_SIZE
rx_buffer:
.skip rx_qbuf_sz
.balign WORD_SIZE
rx_record:
.skip rx_qrec_sz

// Transmit queue variables
.balign WORD_SIZE
tx_buffer:
.skip tx_qbuf_sz
.balign WORD_SIZE
tx_record:
.skip tx_qrec_sz

// PIT counter variables
.balign WORD_SIZE
.global pit_count
pit_count:
.skip WORD_SIZE
.global run_stop_watch
run_stop_watch:
.skip 1
