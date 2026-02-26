            TTL Program Title for Listing Header Goes Here
;****************************************************************
;Descriptive comment header goes here.
;(What does the program do?)
;Name:  <Your name here>
;Date:  <Date completed here>
;Class:  CMPE-250
;Section:  <Your lab section, day, and time here>
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
MAX_STRING EQU 79

HEX_0 EQU "0"
HEX_a EQU "a"
OFFSET_a_A EQU 0x20

HEX_G EQU "G"
HEX_I EQU "I"
HEX_L EQU "L"
HEX_P EQU "P"

;****************************************************************
;Program
;Linker requires Reset_Handler
            AREA    MyCode,CODE,READONLY
            ENTRY
            EXPORT  Reset_Handler
            IMPORT  Startup
			IMPORT LengthStringSB

Reset_Handler  PROC  {}
main
;---------------------------------------------------------------
;Mask interrupts
            CPSID   I
;KL05 system startup with 48-MHz system clock
            BL      Startup
;---------------------------------------------------------------
;>>>>> begin main program code <<<<<
			bl Init_UART0_Polling

            LDR R0, =var
            MOVS R1, #0
            STRB R1, [R0, #0]

MAIN_LOOP
            LDR R0, =instr_str
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
			CMP R4, #HEX_G      ; Check whether character is G
			BEQ G_INSTR
			CMP R4, #HEX_I      ; Check whether character is I
			BEQ I_INSTR
			CMP R4, #HEX_L      ; Check whether character is L
			BEQ L_INSTR
			CMP R4, #HEX_P      ; Check whether character is P
			BEQ P_INSTR
			
			B POLL_LOOP         ; Loop

;>>>>>   end main program code <<<<<
;Stay here
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
            push {r0, r1, r2}
            
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

; Prints a string from user input
; Inputs:
;   R0 : TODO
; Outputs:
;   None
; Modifies:
;   LR, PSR
G_INSTR PROC {}
            PUSH {R0, R1}
            BL ECHO_CMD
            MOVS R0, #"<"
            BL PutChar
            LDR R0, =var
            MOVS R1, #MAX_STRING
            BL GetStringSB
            POP{R0, R1}
            B MAIN_LOOP
            ENDP

; Initialize
; Inputs:
;   R0 : TODO
; Outputs:
;   None
; Modifies:
;   LR, PSR
I_INSTR PROC {}
            PUSH {R0, R1}
            BL ECHO_CMD
            LDR R0, =var
            MOVS R1, #0
            STRB R1, [R0, #0]

            MOVS R1, #4
            LDR R0, =crlf_str
            BL PutStringSB
            POP {R0, R1}
            B MAIN_LOOP
            ENDP

; Prints the length of the string
; Inputs:
;   R0 : TODO
; Outputs:
;   None
; Modifies:
;   LR, PSR
L_INSTR PROC {}
            PUSH {R0, R1}
            BL ECHO_CMD
			LDR R0, =len_str
            MOVS R1, #MAX_STRING
            BL PutStringSB
            LDR R0, =var
            MOVS R1, #MAX_STRING
            BL LengthStringSB
            BL PutNumU
			MOVS R0, #0
			BL ECHO_CMD
            POP {R0, R1}
            B MAIN_LOOP
            ENDP

; Print the operational string
; Inputs:
;   R0 : TOOD
; Outputs:
;   None
; Modifies:
;   LR, PSR
P_INSTR PROC {}
            PUSH {R0, R1}
            BL ECHO_CMD
            MOVS R0, #">"
            BL PutChar

            LDR R0, =var
            MOVS R1, #MAX_STRING
            BL PutStringSB

            MOVS R0, #">"
            BL PutChar
			MOVS R0, #0
			BL ECHO_CMD
            POP {R0, R1}
            B MAIN_LOOP
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
            LDR R0, =crlf_str
			MOVS R1, #5
            BL PutStringSB
            POP {R0, R1, PC}
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

; Gets a string from user
; Inputs:
;   R1 : Buffer capacity
;   R0 : Address of stored string
; Outputs:
;   A string at location in memory specified by R0
GetStringSB PROC {}
            PUSH {R0-R4, LR}
            CMP R1, #0
            BEQ GetStringSBTerminate   ; String must have at least one character
            SUBS R1, R1, #1
            MOVS R2, R0
            MOVS R3, #0
GetStringSBLoop
            BL GetChar
            CMP R0, #0x0D
            BEQ GetStringSBCleanup
            CMP R0, #0x08
            BEQ GetStringSBBackspace
            CMP R0, #0x7F
            BEQ GetStringSBLoop
            CMP R0, #0x1F
            BLS GetStringSBLoop
            
            CMP R3, R1
            BHS GetStringSBLoop
            
            STRB R0, [R2, R3]
            ADDS R3, R3, #1
            BL PutChar
            B GetStringSBLoop
	
GetStringSBBackspace
            CMP R3, #0
            BEQ GetStringSBLoop
            BL PutChar
            MOVS R0, #0x20
            BL PutChar
            MOVS R0, #0x08
            BL PutChar
			MOVS R0, #0x00
			STRB R0, [R2, R3]
            SUBS R3, R3, #1
            B GetStringSBLoop
		
GetStringSBCleanup
            MOVS R4, #0
            STRB R4, [R2, R3]
			LDR R0, =crlf_str
            MOVS R1, #MAX_STRING
            BL PutStringSB
GetStringSBTerminate
            POP {R0-R4, PC}
            
            ENDP
	
; Prints a string
; Inputs:
;   R0 : Memory addr of the string to print
;   R1 : Capacity of the string
; Outputs:
;   None
; Modifies:
;   LR, PSR
PutStringSB PROC {}
            PUSH {R0-R3, LR}
            MOVS R2, R0
            MOVS R3, #0
PutStringSBLoop
            CMP R3, R1
            BEQ PutStringSBTerminate
            LDRB R0, [R2, R3]
            CMP R0, #0
            BEQ PutStringSBTerminate
            
            BL PutChar
            ADDS R3, R3, #1
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
            PUSH {R0-R4, LR}
            CMP R0, #0
            BEQ PutNumUPrintZero
            MOVS R2, R0
            MOVS R4, #0
			MOVS R1, R2
PutNumULoop
            MOVS R0, #10
            BL DIVU
            PUSH {R1}
            ADDS R4, R4, #1
            CMP R0, #0
            BEQ PutNumUPop
			MOVS R1, R0
            B PutNumULoop

PutNumUPop
            CMP R4, #0
            BEQ PutNumUTerminate
            POP {R0}
			ADDS R0, R0, #HEX_0
            BL PutChar
            SUBS R4, R4, #1
            B PutNumUPop
	
PutNumUPrintZero
            MOVS R0, #0x30
            BL PutChar
            B PutNumUTerminate; LEAVE
	
PutNumUTerminate
            POP {R0-R4, PC}
            ENDP



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
instr_str   DCB "Type a string command (G,I,L,P):", 0x00
crlf_str    DCB 0x0D, 0x0A, 0x00
len_str		DCB "Length:", 0x00
;>>>>>   end constants here <<<<<
            ALIGN
;****************************************************************
;Variables
            AREA    MyData,DATA,READWRITE
;>>>>> begin variables here <<<<<
var			SPACE MAX_STRING
;>>>>>   end variables here <<<<<
            ALIGN
            END
