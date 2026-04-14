.nolist
.include "mkl05z4.s"
.include "equ_lab10.s"
.list

.syntax unified
.thumb

.section code, "ax"
.global Reset_Handler
Reset_Handler:
            cpsid I
            bl Startup
            bl Init_UART0_IRQ
            bl Init_PIT_IRQ
            ldr r0, =qbuffer
            ldr r1, =qrecord
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
            .word    PIT_ISR            // 38:PIT
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
qbuffer:
.skip qbuf_sz
.balign 4
qrecord:
.skip qrec_sz

.balign 4
