            TTL Program Title for Listing Header Goes Here
;****************************************************************
;Descriptive comment header goes here.
;Secure Get and Put string operations
;Name:  Aden Perry
;Date:  2026-02-27
;Class:  CMPE-250
;Section:  L1 Thursday 14:00
;---------------------------------------------------------------
;Keil Template for KL05
;R. W. Melton
;September 13, 2020
;****************************************************************
;Assembler directives
            THUMB
            OPT    64  ;Turn on listing macro expansions
;****************************************************************
;Include files
            GET  MKL05Z4.s     ;Included by start.s
            OPT  1   ;Turn on listing
;****************************************************************
;EQUates
;--------------------------------------------------------------- 
;PORTx_PCRn (Port x pin control register n [for pin n]) 
;___->10-08:Pin mux control (select 0 to 8) 
;Use provided PORT_PCR_MUX_SELECT_2_MASK 
;--------------------------------------------------------------- 
;Port B 
PORT_PCR_SET_PTB2_UART0_RX  EQU  (PORT_PCR_ISF_MASK :OR: PORT_PCR_MUX_SELECT_2_MASK) 
PORT_PCR_SET_PTB1_UART0_TX  EQU  (PORT_PCR_ISF_MASK :OR: PORT_PCR_MUX_SELECT_2_MASK) 
;--------------------------------------------------------------- 
;SIM_SCGC4 
;1->10:UART0 clock gate control (enabled) 
;Use provided SIM_SCGC4_UART0_MASK 
;--------------------------------------------------------------- 
;SIM_SCGC5 
;1->10:Port B clock gate control (enabled) 
;Use provided SIM_SCGC5_PORTB_MASK 
;--------------------------------------------------------------- 
;SIM_SOPT2 
;01=27-26:UART0SRC=UART0 clock source select (MCGFLLCLK) 
;--------------------------------------------------------------- 
SIM_SOPT2_UART0SRC_MCGFLLCLK  EQU  (1 << SIM_SOPT2_UART0SRC_SHIFT) 
;--------------------------------------------------------------- 
;SIM_SOPT5 
; 0->   16:UART0 open drain enable (disabled) 
; 0->   02:UART0 receive data select (UART0_RX) 
;00->01-00:UART0 transmit data select source (UART0_TX) 
SIM_SOPT5_UART0_EXTERN_MASK_CLEAR  EQU (SIM_SOPT5_UART0ODE_MASK :OR: SIM_SOPT5_UART0RXSRC_MASK :OR: SIM_SOPT5_UART0TXSRC_MASK)
;--------------------------------------------------------------- 
;UART0_BDH 
;    0->  7:LIN break detect IE (disabled) 
;    0->  6:RxD input active edge IE (disabled) 
;    0->  5:Stop bit number select (1) 
;00001->4-0:SBR[12:0] (UART0CLK / [9600 * (OSR + 1)])  
;UART0CLK is MCGFLLCLK 
;MCGPLLCLK is 47972352 Hz ~=~ 48 MHz 
;SBR ~=~ 48 MHz / (9600 * 16) = 312.5 --> 312 = 0x138 
;SBR = 47972352 / (9600 * 16) = 312.32 --> 312 = 0x138 
UART0_BDH_9600  EQU  0x01 
;--------------------------------------------------------------- 
;UART0_BDL 
;26->7-0:SBR[7:0] (UART0CLK / [9600 * (OSR + 1)]) 
;UART0CLK is MCGFLLCLK 
;MCGPLLCLK is 47972352 Hz ~=~ 48 MHz 
;SBR ~=~ 48 MHz / (9600 * 16) = 312.5 --> 312 = 0x138 
;SBR = 47972352 / (9600 * 16) = 312.32 --> 312 = 0x138 
UART0_BDL_9600  EQU  0x38 
;--------------------------------------------------------------- 
;UART0_C1 
;0-->7:LOOPS=loops select (normal) 
;0-->6:DOZEEN=doze enable (disabled) 
;0-->5:RSRC=receiver source select (internal--no effect LOOPS=0) 
;0-->4:M=9- or 8-bit mode select  
;        (1 start, 8 data [lsb first], 1 stop) 
;0-->3:WAKE=receiver wakeup method select (idle) 
;0-->2:IDLE=idle line type select (idle begins after start bit) 
;0-->1:PE=parity enable (disabled) 
;0-->0:PT=parity type (even parity--no effect PE=0) 
UART0_C1_8N1  EQU  0x00 
;--------------------------------------------------------------- 
;UART0_C2 
;0-->7:TIE=transmit IE for TDRE (disabled) 
;0-->6:TCIE=transmission complete IE for TC (disabled) 
;0-->5:RIE=receiver IE for RDRF (disabled) 
;0-->4:ILIE=idle line IE for IDLE (disabled) 
;1-->3:TE=transmitter enable (enabled) 
;1-->2:RE=receiver enable (enabled) 
;0-->1:RWU=receiver wakeup control (normal) 
;0-->0:SBK=send break (disabled, normal) 
UART0_C2_T_R  EQU  (UART0_C2_TE_MASK :OR: UART0_C2_RE_MASK) 
;--------------------------------------------------------------- 
;UART0_C3 
;0-->7:R8T9=9th data bit for receiver (not used M=0) 
;           10th data bit for transmitter (not used M10=0) 
;0-->6:R9T8=9th data bit for transmitter (not used M=0) 
;           10th data bit for receiver (not used M10=0) 
;0-->5:TXDIR=UART_TX pin direction in single-wire mode 
;            (no effect LOOPS=0) 
;0-->4:TXINV=transmit data inversion (not inverted) 
;0-->3:ORIE=overrun IE for OR (disabled) 
;0-->2:NEIE=noise error IE for NF (disabled) 
;0-->1:FEIE=framing error IE for FE (disabled) 
;0-->0:PEIE=parity error IE for PF (disabled) 
UART0_C3_NO_TXINV  EQU  0x00

;--------------------------------------------------------------- 
;UART0_C4 
;    0-->  7:MAEN1=match address mode enable 1 (disabled) 
;    0-->  6:MAEN2=match address mode enable 2 (disabled) 
;    0-->  5:M10=10-bit mode select (not selected) 
;01111-->4-0:OSR=over sampling ratio (16) 
;               = 1 + OSR for 3 <= OSR <= 31 
;               = 16 for 0 <= OSR <= 2 (invalid values) 
UART0_C4_OSR_16           EQU  0x0F 
UART0_C4_NO_MATCH_OSR_16  EQU  UART0_C4_OSR_16 
;--------------------------------------------------------------- 
;UART0_C5 
;  0-->  7:TDMAE=transmitter DMA enable (disabled) 
;  0-->  6:Reserved; read-only; always 0 
;  0-->  5:RDMAE=receiver full DMA enable (disabled) 
;000-->4-2:Reserved; read-only; always 0 
;  0-->  1:BOTHEDGE=both edge sampling (rising edge only) 
;  0-->  0:RESYNCDIS=resynchronization disable (enabled) 
UART0_C5_NO_DMA_SSR_SYNC  EQU  0x00 
;--------------------------------------------------------------- 
;UART0_S1 
;0-->7:TDRE=transmit data register empty flag; read-only 
;0-->6:TC=transmission complete flag; read-only 
;0-->5:RDRF=receive data register full flag; read-only 
;1-->4:IDLE=idle line flag; write 1 to clear (clear) 
;1-->3:OR=receiver overrun flag; write 1 to clear (clear) 
;1-->2:NF=noise flag; write 1 to clear (clear) 
;1-->1:FE=framing error flag; write 1 to clear (clear) 
;1-->0:PF=parity error flag; write 1 to clear (clear) 
UART0_S1_CLEAR_FLAGS  EQU  (UART0_S1_IDLE_MASK :OR: UART0_S1_OR_MASK :OR:    UART0_S1_NF_MASK :OR:  UART0_S1_FE_MASK :OR: UART0_S1_PF_MASK) 
;--------------------------------------------------------------- 
;UART0_S2 
;1-->7:LBKDIF=LIN break detect interrupt flag (clear) 
;             write 1 to clear 
;1-->6:RXEDGIF=RxD pin active edge interrupt flag (clear) 
;              write 1 to clear 
;0-->5:(reserved); read-only; always 0 
;0-->4:RXINV=receive data inversion (disabled) 
;0-->3:RWUID=receive wake-up idle detect 
;0-->2:BRK13=break character generation length (10) 
;0-->1:LBKDE=LIN break detect enable (disabled) 
;0-->0:RAF=receiver active flag; read-only 
UART0_S2_NO_RXINV_BRK10_NO_LBKDETECT_CLEAR_FLAGS  EQU  (UART0_S2_LBKDIF_MASK :OR: UART0_S2_RXEDGIF_MASK) 
;---------------------------------------------------------------

n           EQU  4
stack_buf_sz  EQU 8*n+4
num_sz      EQU 4*n

putstr_buf_sz  EQU 0x8000

hex_0       EQU 0x30
hex_9       EQU 0x3A
hex_A       EQU 0x41
hex_a       EQU 0x61
hex_a_A     EQU 0x20
hex_A_10    EQU 0x7

;***************************************************************
;Program
;Linker requires Reset_Handler
            AREA    MyCode,CODE,READONLY
            ENTRY
            EXPORT  Reset_Handler
            IMPORT  Startup

Reset_Handler  PROC  {}
main
;---------------------------------------------------------------
;Mask interrupts
            CPSID   I
;KL05 system startup with 48-MHz system clock
            BL      Startup
;---------------------------------------------------------------
;>>>>> begin main program code <<<<<
            ; Init
            BL Init_UART0_Polling

main_num_1
            ;/ Get first number
            ldr r0, =prompt_1
            movs r1, #putstr_buf_sz
            bl PutStringSB
            ldr r0, =num1
            movs r1, #n
            bl GetHexIntMulti
            bcc main_num_2
            bl Invalid

main_num_2
            bl PrintNewline
            ;/ Get second number
            ldr r0, =prompt_2
            movs r1, #putstr_buf_sz
            bl PutStringSB
            ldr r0, =num2
            movs r1, #n
            bl GetHexIntMulti
            bcc main_sum
            bl Invalid

main_sum
            bl PrintNewline
            ;/ Print sum
            ldr r0, =sum_str
            movs r1, #putstr_buf_sz
            bl PutStringSB
            ldr r0, =sum
            ldr r1, =num1
            ldr r2, =num2
            movs r3, #n
            bl AddIntMultiU
            bcc main_print_sum

            ldr r0, =overflow_str
            movs r1, #putstr_buf_sz
            bl PutStringSB
            bl PrintNewline
            b main_num_1

main_print_sum
            ldr r0, =sum
            movs r1, #n
            bl PutHexIntMulti
            bl PrintNewline

            b main_num_1

;>>>>>   end main program code <<<<<
            B       .
            ENDP    ;main
;>>>>> begin subroutine code <<<<<

;*
; Initialize board for polled serial I/O with UART0 through ports B pins 1
; and 2, using: 8 data bits, no parity, and one stop bit at 9600 baud
; Changes: LR, PC, PSR
;*/
Init_UART0_Polling PROC {}
            ;Select MCGFLLCLK as UART0 clock source 
            PUSH {R0, R1, R2}
            
            LDR   R0,=SIM_SOPT2 
            LDR   R1,=SIM_SOPT2_UART0SRC_MASK 
            LDR   R2,[R0,#0] 
            BICS  R2,R2,R1 
            LDR   R1,=SIM_SOPT2_UART0SRC_MCGFLLCLK 
            ORRS  R2,R2,R1 
            STR   R2,[R0,#0] 
            ;Set UART0 for external connection 
            LDR   R0,=SIM_SOPT5 
            LDR   R1,=SIM_SOPT5_UART0_EXTERN_MASK_CLEAR 
            LDR   R2,[R0,#0] 
            BICS  R2,R2,R1 
            STR   R2,[R0,#0] 
            ;Enable UART0 module clock 
            LDR   R0,=SIM_SCGC4 
            LDR   R1,=SIM_SCGC4_UART0_MASK 
            LDR   R2,[R0,#0] 
            ORRS  R2,R2,R1 
            STR   R2,[R0,#0] 
            ;Enable PORT B module clock 
            LDR   R0,=SIM_SCGC5 
            LDR   R1,=SIM_SCGC5_PORTB_MASK 
            LDR   R2,[R0,#0] 
            ORRS  R2,R2,R1 
            STR   R2,[R0,#0] 
            ;Select PORT B Pin 2 (D0) for UART0 RX (J8 Pin 01) 
            LDR     R0,=PORTB_PCR2 
            LDR     R1,=PORT_PCR_SET_PTB2_UART0_RX 
            STR     R1,[R0,#0] 
            ; Select PORT B Pin 1 (D1) for UART0 TX (J8 Pin 02) 
            LDR     R0,=PORTB_PCR1 
            LDR     R1,=PORT_PCR_SET_PTB1_UART0_TX 
            STR     R1,[R0,#0] 
            ;Disable UART0 receiver and transmitter 
            LDR   R0,=UART0_BASE 
            MOVS  R1,#UART0_C2_T_R 
            LDRB  R2,[R0,#UART0_C2_OFFSET] 
            BICS  R2,R2,R1 
            STRB  R2,[R0,#UART0_C2_OFFSET] 
            ;Set UART0 for 9600 baud, 8N1 protocol 
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
            ;Enable UART0 receiver and transmitter 
            MOVS  R1,#UART0_C2_T_R 
            STRB  R1,[R0,#UART0_C2_OFFSET] 

            POP {R0, R1, R2}
            BX LR
            ENDP



;**
; * Tells user string was invalid and prompts to try again
; *
; * Inputs:
; *     r0 : address of number to store
; *     r1 : word length
; * Outputs:
; *     None
; * Modifies:
; *     psr
; */
Invalid     PROC {R0-R1, R4-R5}
            push {r4-r5, lr}
            movs r4, r0
            movs r5, r1
invalid_loop
            bl PrintNewline
            ldr r0, =prompt_err
            movs r0, #putstr_buf_sz
            bl PutStringSB
            movs r1, r5
            movs r0, r4
            bl GetHexIntMulti
            bcs invalid_loop
            pop {r4-r5, pc}
            ENDP



;**
; * Prints a newline and carriage return
; *
; * Inputs:
; *     None
; * Outputs:
; *     None
; * Modifies:
; *     psr
; */
PrintNewline PROC{R0-R1}
            push {r0-r1, lr}
            ldr r0, =crlf_s
            movs r1, #putstr_buf_sz
            bl putstr_buf_sz
            pop {r0-r1, pc}
            ENDP



;**
; * Adds n unsigned words together
; *
; * Inputs:
; *     r0 : address to store sum
; *     r1 : start address of the first addend
; *     r2 : start address of the second addend
; *     r3 : the length n of the numbers
; * Outputs:
; *     psr : clear c iff valid n-word number returned
; * Modifies:
; *     psr
; */
AddIntMultiU PROC {R0-R6}
            push {r3-r6}
            ;   r4 : addend store / sum
            ;   r5 : addend store
            ;   r6 : hold apsr
            lsls r3, #2
            ;  Clear carry
            adds r0, r0, #0
            mrs r6, apsr
aimu_loop
            subs r3, r3, #4
            ldr r4, [r1, r3]
            ldr r5, [r2, r3]
            ;  Restore apsr flags
            msr apsr, r6
            adcs r4, r4, r5
            ;  Store apsr flags
            mrs r6, apsr
            str r4, [r0, r3]
            cmp r3, #0
            bne aimu_loop
            ;  Set C if addition overflowed
            msr apsr, r6
            pop {r3-r6}
            bx lr
            ENDP



;**
; * Gets an n-word ASCII-encoded hex number from UART, terminated on return
; * keystroke, and stores it as binary in memory
; *
; * Inputs:
; *     r0 : address to store binary number
; *     r1 : the length n of the number
; * Outputs:
; *     psr : clear c iff valid n-word number returned
; * Modifies:
; *     psr
; */
GetHexIntMulti PROC {R0-R2, R4-R7}
            push {r0-r2, r4-r7, lr}
            ;  r4 : store address
            ;  r5 : length n
            ;  r6 : stack pointer
            movs r4, r0
            movs r5, r1
            ;  Use stack as buffer
            ;  In Thumb 1, cannot easily make dynamic buffer in stack. Uses an EQUate instead.
            sub sp, #stack_buf_sz
            mov r0, sp
            ;  Find length of string buffer
            lsls r1, #3
            adds r1, #1
            ;  Get input from user
            bl GetStringSB
            ;  Put LSB closest to the stack pointer
            bl ReverseString

            mov r6, sp
            movs r7, #0
            movs r1, #num_sz
            subs r1, #1
ghim_store_in
            ldrb r0, [r6, r7]
            cmp r0, #0
            beq ghim_end_store
            bl HexToBin
            bcs ghim_exit
            movs r2, r0
            adds r7, #1
            ldrb r0, [r6, r7]
            cmp r0, #0
            beq ghim_pre_end_store
            bl HexToBin
            bcs ghim_exit
            lsls r0, #4
            orrs r0, r0, r2
            strb r0, [r4, r1]
            cmp r1, #0
            beq ghim_clean_exit
            subs r1, #1
            adds r7, #1
            b ghim_store_in
ghim_pre_end_store
            movs r0, r2
ghim_end_store
            strb r0, [r4, r1]
            movs r0, #0
ghim_end_loop
            cmp r1, #0
            beq ghim_clean_exit
            subs r1, #1

            strb r0, [r4, r1]
            b ghim_end_loop
ghim_clean_exit
            ;  Clear C flag
            adds r0, #0
ghim_exit
            add sp, #stack_buf_sz
            pop {r0-r2, r4-r7, pc}
            ENDP



;**
; * Outputs an n-word ASCII-encoded hex number to UART
; *
; * Inputs:
; *     r0 : start address of number
; *     r1 : the length n of the number
; * Outputs:
; *     None
; * Modifies:
; *     psr
; */
PutHexIntMulti
            push {r0-r1, r4, lr}
            ;  r0 : arg for PutNumHex
            ;  r1 : loop counter
            ;  r4 : word address
            movs r4, r0
phim_loop
            ;  Print the ith word
            ldr r0, [r4]
            bl PutNumHex
            ;  Increment counters
            adds r4, #4
            subs r1, #1
            ;  Loop
            cmp r1, #0
            bne phim_loop
            pop {r0-r1, r4, pc}



;**
; * Reverses a nul-terminated string in place
; *
; * Inputs:
; *     r0 : input string address
; * Outputs:
; *     None
; * Modifies:
; *     psr
; */
ReverseString
            push {r4-r7}
            ;  r0 : input address
            ;  r4 : input offset
            ;  r5 : output offset
            ;  r6 : temporary byte storage
            ;  r7 : temporary byte storage
            movs r4, #0
            movs r5, #0
            ;  Search for NUL terminator
rs_find_nul
            ldrb r6, [r0, r4]
            adds r4, #1
            cmp r6, #0
            bne rs_find_nul
            subs r4, #2
rs_reverse
            ;  Swap bytes from either end of the string
            ldrb r6, [r0, r4]
            ldrb r7, [r0, r5]
            strb r6, [r0, r5]
            strb r7, [r0, r4]
            subs r4, #1
            adds r5, #1
            cmp r4, r5
            bge rs_reverse
            pop{r4-r7}
            bx lr



;**
; * Convert an ASCII char byte to a binary nibble.
; *
; * Inputs:
; *     r0 : byte to convert
; * Outputs:
; *     r0 : converted byte
; *     psr : clear c iff valid input
; * Modifies:
; *     psr
; */
HexToBin
            ;  Must be at least hex 0
            cmp r0, #hex_0
            blo htb_fail
            ;  Must not be between hex 9 and hex A
            cmp r0, #hex_9
            blo htb_tolower
            cmp r0, #hex_A
            blo htb_fail
htb_tolower
            cmp r0, #hex_a
            blo htb_tooffsetbin
            subs r0, #hex_a_A
htb_tooffsetbin
            cmp r0, #hex_A
            blo htb_tobin
            subs r0, #hex_A_10
htb_tobin
            subs r0, #hex_0
            cmp r0, #0xF
            bhi htb_fail
htb_pass
            ;  Clear C flag
            adds r0, #0
            b htb_exit
htb_fail
            ;  Set C flag
            movs r0, #1
            subs r0, #1
htb_exit
            bx lr



; Put register as hex to terminal
; Reads from R0
PutNumHex   PROC {R1-R4}
            PUSH {R1-R4, LR}
            ; Find mask
            LDR R1, =0xF0000000
            MOVS R3, #8
PutNumHexLoop
            ; Exit after all bytes have been converted
            CMP R3, #0
            BEQ PutNumHexLoopExit
            ; Isolate the byte
            MOVS R2, R1
            ANDS R2, R2, R0
            ; Bring the active byte to the front
			MOVS R4, R3
			SUBS R4, #1
			LSLS R4, #2
            LSRS R2, R2, R4
            ; If the byte is a-f
            CMP R2, #10
            BLT PutNumHexLow
            ; Add 7 (offset from 9 to a)
            ADDS R2, #0x7
PutNumHexLow
            ; For all bytes, add the 0x00 to ASCII 0 offset
            ADDS R2, #HEX_0
            ; Print the char
            MOVS R4, R0
            MOVS R0, R2
            BL PutChar
            MOVS R0, R4
            ; Shift the mask
            LSRS R1, #4
            SUBS R3, R3, #1
            B PutNumHexLoop
PutNumHexLoopExit
            POP {R1-R4, PC}
            ENDP

; Gets a string from user
; Inputs:
;   R1 : Buffer capacity
;   R0 : Address of stored string
; Outputs:
;   A string at location in memory specified by R0
GetStringSB PROC {R0-R7}
            PUSH {R0-R4, LR}
            CMP R1, #0
            BEQ GetStringSBTerminate   ; String must have at least one character
            SUBS R1, R1, #1
            MOVS R2, R0
            MOVS R3, #0
GetStringSBLoop
            BL GetChar
            CMP R0, #0x0D
            BEQ GetStringSBCleanup      ; End on return
            CMP R0, #0x08
            BEQ GetStringSBBackspace    ; Allow backspace
            CMP R0, #0x7F
            BEQ GetStringSBLoop         ; Get new character if control character
            CMP R0, #0x1F
            BLS GetStringSBLoop
            
            CMP R3, R1
            BHS GetStringSBLoop         ; If buffer size reached, wait for return or backspace
            
            STRB R0, [R2, R3]           ; Store
            ADDS R3, R3, #1             ; Increment string pointer
            BL PutChar
            B GetStringSBLoop
	
GetStringSBBackspace
            CMP R3, #0
            BEQ GetStringSBLoop         ; Only backspace if there are characters in the string
            BL PutChar                  ; Remove character from the screen
            MOVS R0, #0x20
            BL PutChar
            MOVS R0, #0x08
            BL PutChar
            SUBS R3, R3, #1             ; Decrement string poniter
            B GetStringSBLoop
		
GetStringSBCleanup
            MOVS R4, #0
            STRB R4, [R2, R3]           ; Store NUL terminator
			LDR R0, =crlf_str
            MOVS R1, #MAX_STRING
            BL PutStringSB              ; Print newline
GetStringSBTerminate
            POP {R0-R4, PC}
            ENDP


;*
; Gets a character from UART0_D
; Return value in R0
; Changes: R0, LR, PC, PSR
;*/
GetChar PROC {}
            PUSH {R1}
            MOVS R1, #UART0_S1_RDRF_MASK
GetCharLoop
            ; Wait for RDRF to be set
            LDR R0, =UART0_S1
            LDRB R0, [R0, #0]
            ANDS R0, R0, R1
            CMP R0, #0
            beq  GetCharLoop

            ; Read UART0_D
            LDR R0, =UART0_D
            LDRB R0, [R0, #0]

            POP {R1}
            BX LR
            ENDP

;*
; Puts a character into UART0_D
; Reads from R0
; Changes: LR, PC, PSR
;*/
PutChar PROC {}
            PUSH {R1, R2}
            MOVS R1, #UART0_S1_TDRE_MASK
PutCharLoop
            ; Wait for TDRE to be set
            LDR R2, =UART0_S1
            LDRB R2, [R2, #0]
            ANDS R2, R2, R1
            CMP R2, #0
            beq PutCharLoop

            ; Write UART0_D
            LDR R2, =UART0_D
            STRB R0, [R2, #0]

            POP {R1, R2}
            BX LR
            ENDP

; Prints a string
; Inputs:
;   R0 : Memory addr of the string to print
;   R1 : Capacity of the string
; Outputs:
;   None
; Modifies:
;   LR, PSR
PutStringSB PROC {R0-R7}
            PUSH {R0-R3, LR}
            MOVS R2, R0
            MOVS R3, #0
PutStringSBLoop
            CMP R3, R1
            BEQ PutStringSBTerminate    ; Exit if buffer size exceeded
            LDRB R0, [R2, R3]
            CMP R0, #0
            BEQ PutStringSBTerminate    ; Exit if NUL
            
            BL PutChar                  ; Print
            ADDS R3, R3, #1             ; Increment string pointer
            B PutStringSBLoop
PutStringSBTerminate
            POP {R0-R3, PC}
            ENDP
	
; Get a quotient and a remainder
; Inputs:
;   R0 : The divisor
;   R1 : The dividend
; Outputs:
;   R0 : The quotient
;   R1 : The remainder
; Modifies:
;   LR, PSR
DIVU PROC {R3-R14}
            CMP R0, #0      ; SETS CARRY FLAG IF EQUAL
            BEQ DIVU_END
            PUSH {R2}
            MOVS R2, #0
DIVU_LOOP
            CMP R1, R0
            BLO DIVU_CLEANUP
            SUBS R1, R1, R0
            ADDS R2, R2, #1
            B DIVU_LOOP
DIVU_CLEANUP
            MOVS R0, R2
            ; CLEAR APSR FLAGS
            MOVS R2, #1
            ADDS R2, #1
            POP {R2}
DIVU_END
            BX LR
            ENDP

;>>>>>   end subroutine code <<<<<
            ALIGN
;****************************************************************
;Vector Table Mapped to Address 0 at Reset
;Linker requires __Vectors to be exported
            AREA    RESET, DATA, READONLY
            EXPORT  __Vectors
            EXPORT  __Vectors_End
            EXPORT  __Vectors_Size
            IMPORT  __initial_sp
            IMPORT  Dummy_Handler
            IMPORT  HardFault_Handler
__Vectors 
                                      ;ARM core vectors
            DCD    __initial_sp       ;00:end of stack
            DCD    Reset_Handler      ;01:reset vector
            DCD    Dummy_Handler      ;02:NMI
            DCD    HardFault_Handler  ;03:hard fault
            DCD    Dummy_Handler      ;04:(reserved)
            DCD    Dummy_Handler      ;05:(reserved)
            DCD    Dummy_Handler      ;06:(reserved)
            DCD    Dummy_Handler      ;07:(reserved)
            DCD    Dummy_Handler      ;08:(reserved)
            DCD    Dummy_Handler      ;09:(reserved)
            DCD    Dummy_Handler      ;10:(reserved)
            DCD    Dummy_Handler      ;11:SVCall (supervisor call)
            DCD    Dummy_Handler      ;12:(reserved)
            DCD    Dummy_Handler      ;13:(reserved)
            DCD    Dummy_Handler      ;14:PendSV (PendableSrvReq)
                                      ;   pendable request 
                                      ;   for system service)
            DCD    Dummy_Handler      ;15:SysTick (system tick timer)
            DCD    Dummy_Handler      ;16:DMA channel 0 transfer 
                                      ;   complete/error
            DCD    Dummy_Handler      ;17:DMA channel 1 transfer
                                      ;   complete/error
            DCD    Dummy_Handler      ;18:DMA channel 2 transfer
                                      ;   complete/error
            DCD    Dummy_Handler      ;19:DMA channel 3 transfer
                                      ;   complete/error
            DCD    Dummy_Handler      ;20:(reserved)
            DCD    Dummy_Handler      ;21:FTFA command complete/
                                      ;   read collision
            DCD    Dummy_Handler      ;22:low-voltage detect;
                                      ;   low-voltage warning
            DCD    Dummy_Handler      ;23:low leakage wakeup
            DCD    Dummy_Handler      ;24:I2C0
            DCD    Dummy_Handler      ;25:(reserved)
            DCD    Dummy_Handler      ;26:SPI0
            DCD    Dummy_Handler      ;27:(reserved)
            DCD    Dummy_Handler      ;28:UART0 (status; error)
            DCD    Dummy_Handler      ;29:(reserved)
            DCD    Dummy_Handler      ;30:(reserved)
            DCD    Dummy_Handler      ;31:ADC0
            DCD    Dummy_Handler      ;32:CMP0
            DCD    Dummy_Handler      ;33:TPM0
            DCD    Dummy_Handler      ;34:TPM1
            DCD    Dummy_Handler      ;35:(reserved)
            DCD    Dummy_Handler      ;36:RTC (alarm)
            DCD    Dummy_Handler      ;37:RTC (seconds)
            DCD    Dummy_Handler      ;38:PIT
            DCD    Dummy_Handler      ;39:(reserved)
            DCD    Dummy_Handler      ;40:(reserved)
            DCD    Dummy_Handler      ;41:DAC0
            DCD    Dummy_Handler      ;42:TSI0
            DCD    Dummy_Handler      ;43:MCG
            DCD    Dummy_Handler      ;44:LPTMR0
            DCD    Dummy_Handler      ;45:(reserved)
            DCD    Dummy_Handler      ;46:PORTA
            DCD    Dummy_Handler      ;47:PORTB
__Vectors_End
__Vectors_Size  EQU     __Vectors_End - __Vectors
            ALIGN
;****************************************************************
;Constants
            AREA    MyConst,DATA,READONLY
;>>>>> begin constants here <<<<<
crlf_s      DCB 0x0D, 0x0A, 0x00
prompt_1    DCB "Enter first 128-but hex number:     0x", 0x00
prompt_2    DCB "Enter 128-but hex number to add:    0x", 0x00
prompt_err  DCB "Invalid number--try again:          0x", 0x00
sum_str     DCB "Sum:                                0x", 0x00
overflow_str  DCB "OVERFLOW", 0x00
;>>>>>   end constants here <<<<<
            ALIGN
;****************************************************************
;Variables
            AREA    MyData,DATA,READWRITE
;>>>>> begin variables here <<<<<
num1        SPACE num_sz
num2        SPACE num_sz
sum         SPACE num_sz
;>>>>>   end variables here <<<<<
            ALIGN
            END
