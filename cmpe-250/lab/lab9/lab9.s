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

.set NVIC_ICPR_UART0_MASK, UART0_IRQ_MASK
.set UART0_IRQ_PRIORITY, 3
.set NVIC_IPR_UART0_MASK, (3 << UART0_PRI_POS)
.set NVIC_IPR_UART0_PRI_3, (UART0_IRQ_PRIORITY << UART0_PRI_POS)
.set NVIC_ISER_UART0_MASK, UART0_IRQ_MASK

.set UART0_C2_T_RI, (UART0_C2_RIE_MASK | UART0_C2_T_R)
.set UART0_C2_TI_RI, (UART0_C2_TIE_MASK | UART0_C2_T_RI)

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
.set qbuf_sz,    80
.set qrec_sz,    18

.set offset_a_A, ('a' - 'A')
.set max_string, 0x80


.section code, "ax"
.global Reset_Handler
Reset_Handler:
            cpsid I
            bl Startup
            bl Init_UART0_IRQ
            cpsie I

Main_loop:
            // Print command string
            ldr r0, =cmd_s
            movs r1, #max_string
            bl PutStringSB 

Poll_loop:
            bl GetChar          // Poll for character
            movs r4, r0         // Allow logic with toUpper, but save polled character for printing
            cmp r4, #'a'      // Check whether the polled character is less then 'a'
            blt Check           // If so, skip toUpper conversion
To_upper:
            subs r4, r4, #offset_a_A    // Else, convert character to uppercase.

Check:
			cmp r4, #'D'      // Check whether character is D
			beq D_instr
			cmp r4, #'E'      // Check whether character is E
			beq E_instr
			cmp r4, #'H'      // Check whether character is H
			beq H_instr
			cmp r4, #'P'      // Check whether character is P
			beq P_instr
			cmp r4, #'S'      // Check whether character is S
			beq S_instr
			
			b Poll_loop         // Loop
            b .



/**
  * Runs the D isntruction
  *
  * Inputs:
  *     R0 : the input character
  * Outputs:
  *     None
  * Modifies:
  *     psr
  */
D_instr:
            push {r0-r1}
            // Print input char and newline
            bl echo_cmd
            // Attempt dequeue
            ldr r1, =qrecord
            bl Dequeue
            movs r1, #max_string
            bcc D_instr_pass
            // If unsuccessful, print fail string
            ldr r0, =fail_s
            bl PutStringSB
            b D_instr_cont
D_instr_pass:
            // Else, print the dequeued character
            bl PutChar
            ldr r0, =char_s
            bl PutStringSB
D_instr_cont:
            // Print status of the record
            bl Status
            pop {r0-r1}
            b Main_loop



/**
  * Runs the E isntruction
  *
  * Inputs:
  *     R0 : the input character
  * Outputs:
  *     None
  * Modifies:
  *     psr
  */
E_instr:
            push {r0-r1}
            // Print input char and newline
            bl echo_cmd
            // Get character to enqueue
            ldr r0, =enqu_s
            movs r1, #max_string
            bl PutStringSB
            bl GetChar
            // Print the character selected and newline
			bl echo_cmd
            // Attempt enqueue
            ldr r1, =qrecord
            bl Enqueue
            bcc E_instr_pass
            // If unsuccessful, print fail string
            ldr r0, =fail_s
            bl PutStringSB
            b E_instr_cont
E_instr_pass:
            // Else, print success string
            ldr r0, =succ_s
            bl PutStringSB
E_instr_cont:
            // Print status of the record
            bl Status
            pop {r0-r1}
            b Main_loop



/**
  * Runs the H isntruction
  *
  * Inputs:
  *     R0 : the input character
  * Outputs:
  *     None
  * Modifies:
  *     psr
  */
H_instr:
            push {r0-r1}
            // Print input char and newline
            bl echo_cmd
            // Print help string
            ldr r0, =help_s
            movs r1, #max_string
            bl PutStringSB
            // Return
            pop {r0-r1}
            b Main_loop



/**
  * Runs the P isntruction
  *
  * Inputs:
  *     R0 : the input character
  * Outputs:
  *     None
  * Modifies:
  *     psr
  */
P_instr:
            push {r0-r3}
            // Print the input char and newline
            bl echo_cmd
            // Print left delimiter
            movs r0, #'>'
            bl PutChar
            // Exit if the queue is empty
            ldr r1, =qrecord
            ldrb r3, [r1, #num_enqd]
            cmp r3, #0
            beq P_instr_exit
            // Load in and out pointers
            ldr r0, [r1, #out_ptr]
            ldr r3, [r1, #in_ptr]
            movs r2, r0
P_instr_loop:
            // Print the value at the pointer in r2
            ldrb r0, [r2]
            bl PutChar
            // Increment the r2 pointer
            bl Pointer_inc
            // Exit when r2 pointer is the same as the in pointer
            cmp r2, r3
            bne P_instr_loop
P_instr_exit:
            // Print right delimiter and newline
            movs r0, #'<'
            bl PutChar
            ldr r0, =crlf_s
            movs r1, #max_string
			bl PutStringSB
            // Return
            pop {r0-r3}
            b Main_loop



/**
  * Runs the S isntruction
  *
  * Inputs:
  *     R0 : the input character
  * Outputs:
  *     None
  * Modifies:
  *     psr
  */
S_instr:
            push {r0-r1}
            // Print the input char and newline
            bl echo_cmd
            ldr r0, =stat_s
            movs r1, #max_string
            bl PutStringSB
            // Print the record status
			bl Status
            // Return
            pop {r0-r1}
            b Main_loop



/**
  * Print the status of the queue record
  *
  * Inputs:
  *     None
  * Outputs:
  *     None
  * Modifies:
  *     psr
  */
Status:
            push {r0-r1, lr}
            // Print the in pointer string
            movs r1, #max_string
            ldr r0, =stat_in_s
            bl PutStringSB
            // Print the in pointer
            ldr r1, =qrecord
            ldr r0, [r1, #in_ptr]
            bl PutNumHex
            // Print the out pointer string
            movs r1, #max_string
            ldr r0, =stat_out_s
            bl PutStringSB
            // Print the out pointer
            ldr r1, =qrecord
            ldr r0, [r1, #out_ptr]
            bl PutNumHex
            // Print the number enqueued string
            movs r1, #max_string
            ldr r0, =stat_num_s
            bl PutStringSB
            // Print the number enqueued
            ldr r1, =qrecord
            ldrb r0, [r1, #num_enqd]
            bl PutNumUB
            // Print newline
            movs r1, #max_string
            ldr r0, =crlf_s
            bl PutStringSB
            // Return
            pop  {r0-r1, pc}



/** Print the char and newline
  * Inputs:
  *     r0 : The char to print
  * Outputs:
  *     none
  * Modifies:
  *     LR, PSR
  */
echo_cmd:
            push {r0, r1, lr}
            // Print char
            bl PutChar
            // Print newline
            ldr r0, =crlf_s
			movs r1, #5
            bl PutStringSB
            pop {r0, r1, pc}



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
UART0_ISR:
            cpsid I
            push {lr}
            ldr r2, =UART0_BASE
            ldrb r1, [r2, #UART0_C2_OFFSET]
            ands r1, #UART0_C2_TIE_MASK
            // Check tx interrupt enabled
            cmp r1, #0
            // If disabled, jump to rx interrupt check
            beq UART0_ISR_rxint
            // Else, check tx interrupt
            ldrb r1, [r2, #UART0_S1_OFFSET]
            ands r1, #UART0_S1_TDRE_MASK
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
            ands r1, #UART0_S1_RDRF_MASK
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
  * Initialize UART for interrupt control at 9600 baud 8N1
  *
  * Inputs:
  *     none
  * Outputs:
  *     none
  * Modifies:
  *     psr
  */
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
GetChar:
            push {r1, lr}
            ldr r1, =rx_record
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
PutChar:
            push {r1, r2, lr}
            // Enable transmit interrupt
            ldr r1, =UART0_BASE
            ldrb r2, =UART0_C2_TI_RI
            strb r2, [r1, #UART0_C2_OFFSET]
            // Put char
            ldr r1, =tx_record
            bl Enqueue
            pop {r1, r2, pc}



/**
  * Prints a string
  * Inputs:
  *     R0 : Memory addr of the string to print
  *     R1 : Capacity of the string
  * Outputs:
  *     None
  * Modifies:
  *     LR, PSR
  */
PutStringSB:
            push {r0-r3, lr}
            movs r2, r0
            movs r3, #0
PutStringSBLoop:
            cmp r3, r1
            beq PutStringSBTerminate    // Exit if buffer size exceeded
            ldrb r0, [r2, r3]
            cmp r0, #0
            beq PutStringSBTerminate    // Exit if NUL
            
            bl PutChar                  // Print
            adds r3, r3, #1             // Increment string pointer
            b PutStringSBLoop
PutStringSBTerminate:
            pop {r0-r3, pc}



/**
  * Put byte as decimal to terminal
  *
  * Inputs:
  *     r1 : byte to send
  * Outputs:
  *     none
  * Modifies:
  *     psr
  */
PutNumUB:
            push {r0-r1, lr}
            movs r1, #0xff
            ands r0, r0, r1
            bl PutNumU
            pop {r0-r1, pc}



/**
  * Send register contents as ASCII over UART
  *
  * Inputs:
  *     r0 : the register to send
  * Outputs:
  *     none
  * Modifies:
  *     none
  */
PutNumHex:
            push {r1-r4, lr}
            // Find mask
            ldr r1, =0xf0000000
            movs r3, #8
PutNumHexLoop:
            // Exit after all bytes have been converted
            cmp r3, #0
            beq PutNumHexLoopExit
            // Isolate the byte
            movs r2, r1
            ands r2, r2, r0
            // Bring the active byte to the front
			movs r4, r3
			subs r4, #1
			lsls r4, #2
            lsrs r2, r2, r4
            // If the byte is a-f
            cmp r2, #10
            blt PutNumHexLow
            // Add 7 (offset from 9 to a)
            adds r2, #('A' - '9')
PutNumHexLow:
            // For all bytes, add the 0x00 to ASCII 0 offset
            adds r2, #'0'
            // Print the char
            movs r4, r0
            movs r0, r2
            bl PutChar
            movs r0, r4
            // Shift the mask
            lsrs r1, #4
            subs r3, r3, #1
            b PutNumHexLoop
PutNumHexLoopExit:
            pop {r1-r4, pc}



/**
  * Send ASCII-encoded decimal of a byte
  *
  * Inputs:
  *     r0 : the byte to print
  * Outputs:
  *     none
  * Modifies:
  *     psr
  */
PutNumU:
            push {r0-r2, r4, lr}
            cmp r0, #0
            beq PutNumUPrintZero        // Handle 0
            movs r2, r0
            movs r4, #0
			movs r1, r0
PutNumULoop:
            movs r0, #10
            bl Divu                     // Divide by 10
            push {r1}                   // Push remainder
            adds r4, r4, #1             // Increment digit counter
            cmp r0, #0
            beq PutNumUPop              // If quotient is 0, exit
			movs r1, r0
            b PutNumULoop               // Divide quotient by 10
PutNumUPop:
            cmp r4, #0
            beq PutNumUTerminate        // If 0 left to print, exit
            pop {r0}
			adds r0, r0, #'0'           // Convert from uint to char
            bl PutChar
            subs r4, r4, #1             // Decrement digit counter
            b PutNumUPop
PutNumUPrintZero:
            movs r0, #0x30
            bl PutChar                  // Print ascii 0
            b PutNumUTerminate          // Leave
PutNumUTerminate:
            pop {r0-r2, r4, pc}



/**
  * Get a quotient and a remainder
  *
  * Inputs:
  *     R0 : The divisor
  *     R1 : The dividend
  * Outputs:
  *     R0 : The quotient
  *     R1 : The remainder
  * Modifies:
  *     LR, PSR
  */
Divu:
            cmp r0, #0      // sets carry flag if equal
            beq Divu_end
            push {r2}
            movs r2, #0
Divu_loop:
            cmp r1, r0
            blo Divu_cleanup
            subs r1, r1, r0
            adds r2, r2, #1
            b Divu_loop
Divu_cleanup:
            movs r0, r2
            // Clear apsr flags
            movs r2, #1
            adds r2, #1
            pop {r2}
Divu_end:
            bx lr



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
.global __Vectors
.global __Vectors_End
.global __Vectors_Size
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



.section const, "a"
cmd_s:       
.asciz      "Type a queue command (D,E,H,P,S):"
crlf_s:      
.byte       0x0D, 0x0A, 0x00
fail_s:      
.asciz      "Failure:        "
char_s:      
.asciz      ":              "
stat_s:      
.asciz      " Status:        "
succ_s:      
.asciz      "Success:        "
enqu_s:      
.asciz      "Char to enqueue:"
help_s:      
.asciz      "D (dequeue), E (enqueue), H (help), P (print), S (status)"
.byte       0x0D, 0x0A, 0x00
stat_in_s:   
.asciz      "    In=0x"
stat_out_s:  
.asciz      "    Out=0x"
stat_num_s:  
.asciz      "    Num=0"

.balign 4



.section data, "aw", %nobits
.balign 4
rx_buffer:
.skip rx_qbuf_sz
.balign 4
rx_record:
.skip rx_qrec_sz

.balign 4
tx_buffer:
.skip tx_qbuf_sz
.balign 4
tx_record:
.skip tx_qrec_sz

.balign 4
qbuffer:
.skip qbuf_sz
.balign 4
qrecord:
.skip qrec_sz

.balign 4
