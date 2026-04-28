.nolist
.include "mkl05z4.s"
.include "equ_lab11.s"
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
            cpsie I
Main_loop:
            // Print command string
            ldr r0, =prompt1_s
            movs r1, #max_string
            bl PutStringSB 
            ldr r0, =response
            // Start timing the user
            movs r3, #0
            movs r4, #1
            ldr r2, =pit_count
            str r3, [r2]
            ldrb r2, =run_stop_watch
            strb r4, [r2]
            // Get response and stop timer
            bl GetStringSB
            strb r3, [r2]
            // Print time
            movs r0, #'<'
            bl PutChar
            ldr r1, =pit_count
            ldrb r0, [r1]
            bl PutNumU
            movs r1, #max_string
            ldr r0, =time_factor_s
            bl PutStringSB

            // Print command string
            ldr r0, =prompt2_s
            bl PutStringSB 
            ldr r0, =response
            // Start timing the user
            movs r3, #0
            movs r4, #1
            ldr r2, =pit_count
            str r3, [r2]
            ldrb r2, =run_stop_watch
            strb r4, [r2]
            // Get response and stop timer
            bl GetStringSB
            strb r3, [r2]
            // Print time
            movs r0, #'<'
            bl PutChar
            ldr r1, =pit_count
            ldrb r0, [r1]
            bl PutNumU
            movs r1, #max_string
            ldr r0, =time_factor_s
            bl PutStringSB

            // Print command string
            ldr r0, =prompt3_s
            bl PutStringSB 
            ldr r0, =response
            // Start timing the user
            movs r3, #0
            movs r4, #1
            ldr r2, =pit_count
            str r3, [r2]
            ldrb r2, =run_stop_watch
            strb r4, [r2]
            // Get response and stop timer
            bl GetStringSB
            strb r3, [r2]
            // Print time
            movs r0, #'<'
            bl PutChar
            ldr r1, =pit_count
            ldrb r0, [r1]
            bl PutNumU
            movs r1, #max_string
            ldr r0, =time_factor_s
            bl PutStringSB

            ldr r0, =goodbye_s
            bl PutStringSB



/**
  * Prints a string
  *
  * Inputs:
  *     R0 : Memory addr of the string to print
  *     R1 : Capacity of the string
  * Outputs:
  *     None
  * Modifies:
  *     lr, psr
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
  * Gets a string from UART
  *
  * Inputs:
  *     r0 : address of stored string
  *     r1 : buffer capacity
  * Outputs:
  *     a string at the memory location contained in r0
  * Modifies:
  *     psr
  */
GetStringSB:
            push {r0-r4, lr}
            cmp r1, #0
            beq GetStringSBTerminate   // String must have at least one character
            subs r1, r1, #1
            movs r2, r0
            movs r3, #0
GetStringSBLoop:
            bl GetChar
            cmp r0, #0x0D
            beq GetStringSBCleanup      // End on return
            cmp r0, #0x08
            beq GetStringSBBackspace    // Allow backspace
            cmp r0, #0x7F
            beq GetStringSBLoop         // Get new character if control character
            cmp r0, #0x1F
            bls GetStringSBLoop
            cmp r3, r1
            bhs GetStringSBLoop         // If buffer size reached, wait for return or backspace
            strb r0, [r2, r3]           // Store
            adds r3, r3, #1             // Increment string pointer
            bl PutChar
            b GetStringSBLoop
GetStringSBBackspace:
            cmp r3, #0
            beq GetStringSBLoop         // Only backspace if there are characters in the string
            bl PutChar                  // Remove character from the screen
            movs r0, #0x20
            bl PutChar
            movs r0, #0x08
            bl PutChar
            subs r3, r3, #1             // Decrement string poniter
            b GetStringSBLoop
GetStringSBCleanup:
            movs r4, #0
            strb r4, [r2, r3]           // Store NUL terminator
			ldr r0, =crlf_s
            movs r1, #max_string
            bl PutStringSB              // Print newline
GetStringSBTerminate:
            pop {r0-r4, pc}



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
crlf_s:
.byte 0x0a, 0x0d, 0x00
prompt1_s:
.ascii "Enter your name."
.byte 0x0a, 0x0d
.asciz "> "
prompt2_s:
.ascii "Enter the date."
.byte 0x0a, 0x0d
.asciz "> "
prompt3_s:
.ascii "Enter the last name of a 250 lab TA."
.byte 0x0a, 0x0d
.asciz "> "
time_factor_s:
.ascii " x 0.01 s"
.byte 0x0a, 0x0d, 0x00
goodbye_s:
.ascii "Thank you.  Goodbye!"
.byte 0x0a, 0x0d, 0x00

.balign 4



.section data, "aw", %nobits
.balign 4
response:
.skip max_string
