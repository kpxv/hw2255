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
IN_PTR EQU 0
OUT_PTR EQU 4
BUF_START EQU 8
BUF_PAST EQU 12
BUF_SIZE EQU 16
NUM_ENQD EQU 17

Q_BUF_SZ EQU 80
Q_REC_SZ EQU 18

HEX_a EQU 0x41
HEX_D EQU 0x44
HEX_E EQU 0x45
HEX_H EQU 0x48
HEX_P EQU 0x50
HEX_S EQU 0x53
HEX_0 EQU 0x30
MAX_STRING 0xF0


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
            LDR R0, =QBUFFER
            LDR R1, =QRECORD
            MOVS R2, #4
            BL INIT_QUEUE

MAIN_LOOP
            LDR R0, =CMD_S
            MOVS R1, #MAX_STRING
            BL PutStringSB 

POLL_LOOP
            BL GetChar          ; Poll for character
            MOVS R4, R0         ; Allow logic with toUpper, but save polled character for printing
            CMP R4, #HEX_a      ; Check whether the polled character is less then 'a'
            BLT CHECK           ; If so, skip toUpper conversion
TO_UPPER
            SUBS R4, R4, #OFFSET_a_A    ; Else, convert character to uppercase.

CHECK
			CMP R4, #HEX_D      ; Check whether character is D
			BEQ D_INSTR
			CMP R4, #HEX_E      ; Check whether character is E
			BEQ E_INSTR
			CMP R4, #HEX_H      ; Check whether character is H
			BEQ H_INSTR
			CMP R4, #HEX_P      ; Check whether character is P
			BEQ P_INSTR
			CMP R4, #HEX_S      ; Check whether character is S
			BEQ S_INSTR
			
			B POLL_LOOP         ; Loop
;>>>>>   end main program code <<<<<
            B .
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

; Attempts dequeue. Makes no modifications
D_INSTR     PROC {}
            PUSH {R0-R1, LR}
            BL ECHO_CMD
            LDR R1, =QRECORD
            BL DEQUEUE
            MOVS R1, #MAX_STRING
            BCC D_INSTR_PASS
            LDR R0, =FAIL_S
            BL PutStringSB
            B D_INSTR_CONT
D_INSTR_PASS
            BL PutChar
            LDR R0, =CHAR_S
            BL PutStringSB
D_INSTR_CONT
            BL STATUS
            POP {R0-R1, PC}
            ENDP

; Attempts enqueue. Makes no Modifications
E_INSTR     PROC {}
            PUSH {R0-R1, LR}
            BL ECHO_CMD

            LDR R0, =ENQU_S
            MOVS R1, #MAX_STRING
            BL PutStringSB
            BL GetChar
            BL PutChar
            LDR R1, =QRECORD
            BL ENQUEUE
            MOVS R1, #MAX_STRING
            BCC E_INSTR_PASS
            LDR R0, =FAIL_S
            BL PutStringSB
            B E_INSTR_CONT
E_INSTR_PASS
            LDR R0, =SUCC_S
            BL PutStringSB
E_INSTR_CONT
            BL STATUS
            POP {R0-R1, PC}
            ENDP

; Print help string. Makes no modifications
H_INSTR     PROC {}
            PUSH {R0-R1, LR}
            BL ECHO_CMD
            LDR R0, =HELP_S
            MOVS R1, #MAX_STRING
            BL PutStringSB
            POP {R0-R1, PC}
            ENDP

; Print Queue contents. Makes no modifications
P_INSTR     PROC {}
            PUSH {R0-R3, LR}
            BL ECHO_CMD
            MOVS R0, #'>'
            BL PutChar
            LDR R1, =QRECORD
            LDR R2, [R1, #BUF_SIZE]
            LDR R3, [R1, #NUM_ENQD]
            CMP R2, R3
            BEQ P_INSTR_EXIT
            LDR R0, [R1, #OUT_PTR]
            LDR R3, [R1, #IN_PTR]
            MOVS R2, #OUT_PTR
P_INSTR_LOOP
            LDR R0, [R2]
            BL PutChar
            BL POINTER_INC
            CMP R2, R3
            BNE P_INSTR_LOOP
P_INSTR_EXIT
            MOVS R0, #'<'
            BL PutChar
            LDR R0, =CRLF_S
            MOVS R1, #MAX_STRING
            POP {R0-R3, PC}
            ENDP

; Print status string. Makes no modifications
S_INSTR     PROC {}
            PUSH {R0-R1, LR}
            BL ECHO_CMD
            LDR R0, =STAT_S
            MOVS R1, #MAX_STRING
            BL PutStringSB
            POP {R0-R1, PC}
            ENDP

STATUS      PROC {}
            PUSH {R0-R1, LR}

            MOVS R1, #MAX_STRING
            LDR R0, =STAT_IN_S
            BL PutStringSB

            LDR R1, =QRECORD
            LDR R0, [R1, #IN_PTR]
            BL PutNumHex

            MOVS R1, #MAX_STRING
            LDR R0, =STAT_OUT_S
            BL PutStringSB

            LDR R1, =QRECORD
            LDR R0, [R1, #OUT_PTR]
            BL PutNumHex

            MOVS R1, #MAX_STRING
            LDR R0, =STAT_NUM_S
            BL PutStringSB

            LDR R1, =QRECORD
            LDRB R0, [R1, #NUM_ENQD]
            BL PutNumUb

            MOVS R1, #MAX_STRING
            LDR R0, =CRLF_S
            BL PutStringSB

            POP  {R0-R1, PC}
            ENDP

; Print the char and newline
; Inputs:
;   R0 : The char to print
; Outputs:
;   None
; Modifies:
;   LR, PSR
ECHO_CMD PROC {}
            PUSH {R0, R1, LR}
            BL PutChar
            LDR R0, =CRLF_S
			MOVS R1, #5
            BL PutStringSB
            POP {R0, R1, PC}
            ENDP

;**
; * Initialize queue record
; *
; * Inputs:
; *     R0 : buffer address
; *     R1 : record address
; *     R2 : queue capacity
; * Outputs:
; *     None
; * Modified:
; *     psr
; */
INIT_QUEUE
            PUSH {R3}
            ; In pointer
            STR R0, [R1, #IN_PTR]
            ; Out pointer
            STR R0, [R1, #OUT_PTR]
            ; Buffer start
            STR R0, [R1, #BUF_START]
            ; Buffer end
            ADDS R3, R0, R2
            SUBS R3, R3, #1
            STR R3, [R1, #BUF_PAST]
            ; Buffer size
            STRB R2, [R1, #BUF_SIZE]
            ; Number enqueued
            MOVS R3, #0
            STRB R3, [R1, #NUM_ENQD]
            POP {R3}
            BX LR

;**
; * Attempt to get char from queue
; *
; * Inputs:
; *     R1 : record address
; * Outputs:
; *     R0 : dequeued character
; *     psr : clear c iff successful
; * Modified:
; *     R0, iff DEQUEUE successful
; *     psr
; */
DEQUEUE    PROC {}
            PUSH {R2, LR}
            ; Check if empty
            LDRB R2, [R1, #NUM_ENQD]
            CMP R2, #0
            BEQ DEQUEUE_EMPTY
            ; Get from queue
            LDR R2, [R1, #OUT_PTR]
            LDRB R0, [R2]
            ; Increment pointer
            BL POINTER_INC
            STR R2, [R1, #OUT_PTR]
            ; Decrement num enqueued
            LDRB R2, [R1, #NUM_ENQD]
            SUBS R2, R2, #1
            STRB R2, [R1, #NUM_ENQD]
            ; Clear C flag
            ADDS R2, #0
            B DEQUEUE_EXIT
DEQUEUE_EMPTY
            ; Set C flag
            MOVS R2, #0
            MVNS R2, R2
            ADDS R2, R2, #1
DEQUEUE_EXIT
            POP {R2, PC}
            ENDP

;**
; * Attempt to put char in queue
; *
; * Inputs:
; *     R0 : ENQUEUE char
; *     R1 : record address
; * Outputs:
; *     psr: clear c iff ENQUEUE successful
; * Modified:
; *     psr
; */
ENQUEUE    PROC {}
            PUSH {R2, R3, LR}
            ; Check if full
            LDRB R2, [R1, #BUF_SIZE]
            LDRB R3, [R1, #NUM_ENQD]
            CMP R2, R3
            BEQ ENQUEUE_FULL
            ; Store to queue
            LDR R2, [R1, #IN_PTR]
            STRB R0, [R2]
            ; Increment in pointer
            BL POINTER_INC
            STR R2, [R1, #IN_PTR]
            ; Increment num enqueued
            ADDS R3, R3, #1
            STRB R3, [R1, #NUM_ENQD]
            ; Clear C flag
            ADDS R2, #0
            B ENQUEUE_EXIT
ENQUEUE_FULL
            ; Set C flag
            MOVS R2, #0
            MVNS R2, R2
ENQUEUE_EXIT
            POP {R2, R3, PC}
            ENDP

;**
; * Increment queue pointer
; *
; * Inputs:
; *     R1 : record address
; *     R2 : pointer
; * Outputs:
; *     R2 : incremented pointer
; * Modifies:
; *     R2
; *     psr
; */
POINTER_INC PROC {}
            PUSH {R0, R3}
            ; Load pointer
            MOVS R0, R2
            LDR R3, [R1, #BUF_PAST]
            CMP R0, R3
            BEQ POINTER_INC_WRAP
            ADDS R0, R0, #1
            B POINTER_INC_EXIT
POINTER_INC_WRAP
            LDR R0, [R1, #BUF_START]
POINTER_INC_EXIT
            MOVS R2, R0
            POP {R0, R3}
            BX LR
            ENDP

; Put byte as decimal to terminal
; Reads from R0
; Changes: PC, PSR
PutNumUB    PROC {}
            PUSH {R1, LR}
            MOVS R1, #0xFF
            ANDS R1, R1, R0
            BL PutNumU
            POP {R1, PC}
            ENDP

; Put register as hex to terminal
; Reads from R0
PutNumHex   PROC {}
            PUSH {R1-R4, LR}
            LDR R1, =0xF0000000
            MOVS R3, #0
PutNumHexLoop
            CMP R3, #8
            BEQ PutNumHexLoopExit
            MOVS R2, R0
            ANDS R2, R2, R1

            ; Bring the active byte to the front
            LSRS R2, R2, R3
            LSRS R2, R2, R3
            LSRS R2, R2, R3
            LSRS R2, R2, R3

            CMP R2, #10
            BLT PutNumHexLow
            ADDS R2, #0x7
PutNumHexLow
            ADDS R2, #HEX_0

            MOVS R4, R0
            MOVS R0, R2
            BL PutChar
            MOVS R0, R4

            LSRS R1, #4
            ADDS R3, R3, #1
            B PutNumHexLoop
PutNumHexLoopExit
            POP {R1-R4, PC}
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
	
; Print decimal of binary value
; Inputs:
;   R0 : The value to print
; Outputs:
;   None
; Modifies:
;   LR, PSR
PutNumU PROC {}
            PUSH {R0-R2, R4, LR}
            CMP R0, #0
            BEQ PutNumUPrintZero        ; Handle 0
            MOVS R2, R0
            MOVS R4, #0
			MOVS R1, R0
PutNumULoop
            MOVS R0, #10
            BL DIVU                     ; Divide by 10
            PUSH {R1}                   ; Push remainder
            ADDS R4, R4, #1             ; Increment digit counter
            CMP R0, #0
            BEQ PutNumUPop              ; If quotient is 0, exit
			MOVS R1, R0
            B PutNumULoop               ; Divide quotient by 10

PutNumUPop
            CMP R4, #0
            BEQ PutNumUTerminate        ; If 0 left to print, exit
            POP {R0}
			ADDS R0, R0, #HEX_0         ; Convert from uint to char
            BL PutChar
            SUBS R4, R4, #1             ; Decrement digit counter
            B PutNumUPop
	
PutNumUPrintZero
            MOVS R0, #0x30
            BL PutChar                  ; Print ascii 0
            B PutNumUTerminate; LEAVE
	
PutNumUTerminate
            POP {R0-R2, R4, PC}
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
CMD_S       DCB "Type a queue command (D,E,H,P,S):", 0x00
CRLF_S      DCB 0x0D, 0x0A, 0x00
FAIL_S      DCB "Failure:        ", 0x00
CHAR_S      DCB ":               ", 0x00
STAT_S      DCB " Status:        ", 0x00
SUCC_S      DCB "Success:        ", 0x00
ENQU_S      DCB "Char to enqueue:", 0x00
HELP_S      DCB "D (dequeue), E (enqueue), H (help), P (print), S (status)", 0x0D, 0x0A, 0x00
STAT_IN_S   DCB "    In=0x", 0x00
STAT_OUT_S  DCB "    Out=0x", 0x00
STAT_NUM_S  DCB "    Num=0", 0x00
;>>>>>   end constants here <<<<<
            ALIGN
;****************************************************************
;Variables
            AREA    MyData,DATA,READWRITE
;>>>>> begin variables here <<<<<
QBUFFER
            SPACE Q_BUF_SZ
QRECORD
            SPACE Q_REC_SZ
;>>>>>   end variables here <<<<<
            ALIGN
            END
