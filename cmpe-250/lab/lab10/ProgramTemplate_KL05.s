            TTL Program Title for Listing Header Goes Here
; ***************************************************************
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
; ***************************************************************
;Assembler directives
            THUMB
            OPT    64  ;Turn on listing macro expansions
; ***************************************************************
;Include files
            GET  MKL05Z4.s     ;Included by start.s
            OPT  1   ;Turn on listing
; ***************************************************************
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

NVIC_ICPR_UART0_MASK EQU UART0_IRQ_MASK
UART0_IRQ_PRIORITY EQU 3
NVIC_IPR_UART0_MASK EQU (3 << UART0_PRI_POS)
NVIC_IPR_UART0_PRI_3 EQU (UART0_IRQ_PRIORITY << UART0_PRI_POS)
NVIC_ISER_UART0_MASK EQU UART0_IRQ_MASK

UART0_C2_T_RI EQU (UART0_C2_RIE_MASK :OR: UART0_C2_T_R)
UART0_C2_TI_RI EQU (UART0_C2_TIE_MASK :OR: UART0_C2_T_RI)


; Sizes of buffers and records
rx_qbuf_sz EQU 80
rx_qrec_sz EQU 18
tx_qbuf_sz EQU 80
tx_qrec_sz EQU 18




IN_PTR EQU 0
OUT_PTR EQU 4
BUF_START EQU 8
BUF_PAST EQU 12
BUF_SIZE EQU 16
NUM_ENQD EQU 17

Q_BUF_SZ EQU 80
Q_REC_SZ EQU 18

HEX_a EQU 'a'
HEX_D EQU 'D'
HEX_E EQU 'E'
HEX_H EQU 'H'
HEX_P EQU 'P'
HEX_S EQU 'S'
HEX_0 EQU '0'
MAX_STRING EQU 0x80
OFFSET_a_A EQU 0x20


; **************************************************************
;Program
;Linker requires Reset_Handler
            AREA    MyCode,CODE,READONLY
            ENTRY
            EXPORT  Reset_Handler
            IMPORT  Startup

            Reset_Handler
            cpsid I
            bl Startup
            bl Init_UART0_IRQ
            bl Init_PIT_IRQ
            cpsie I
Main_loop
            ; Print command string
            ldr r0, =prompt1_s
            movs r1, #max_string
            bl PutStringSB 
            ldr r0, =response
            ; Start timing the user
            movs r3, #0
            movs r4, #1
            ldr r2, =pit_count
            str r3, [r2]
            ldrb r2, =run_stop_watch
            strb r4, [r2]
            ; Get response and stop timer
            bl GetStringSB
            strb r3, [r2]
            ; Print time
            movs r0, #'<'
            bl PutChar
            ldr r1, =pit_count
            ldrb r0, [r1]
            bl PutNumU
            movs r1, #max_string
            ldr r0, =time_factor_s
            bl PutStringSB

            ; Print command string
            ldr r0, =prompt2_s
            bl PutStringSB 
            ldr r0, =response
            ; Start timing the user
            movs r3, #0
            movs r4, #1
            ldr r2, =pit_count
            str r3, [r2]
            ldrb r2, =run_stop_watch
            strb r4, [r2]
            ; Get response and stop timer
            bl GetStringSB
            strb r3, [r2]
            ; Print time
            movs r0, #'<'
            bl PutChar
            ldr r1, =pit_count
            ldrb r0, [r1]
            bl PutNumU
            movs r1, #max_string
            ldr r0, =time_factor_s
            bl PutStringSB

            ; Print command string
            ldr r0, =prompt3_s
            bl PutStringSB 
            ldr r0, =response
            ; Start timing the user
            movs r3, #0
            movs r4, #1
            ldr r2, =pit_count
            str r3, [r2]
            ldrb r2, =run_stop_watch
            strb r4, [r2]
            ; Get response and stop timer
            bl GetStringSB
            strb r3, [r2]
            ; Print time
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



; *
; * Prints a string
; *
; * Inputs
; *     R0 : Memory addr of the string to print
; *     R1 : Capacity of the string
; * Outputs
; *     None
; * Modifies
; *     lr, psr
; */
PutStringSB
            push {r0-r3, lr}
            movs r2, r0
            movs r3, #0
PutStringSBLoop
            cmp r3, r1
            beq PutStringSBTerminate    ; Exit if buffer size exceeded
            ldrb r0, [r2, r3]
            cmp r0, #0
            beq PutStringSBTerminate    ; Exit if NUL
            
            bl PutChar                  ; Print
            adds r3, r3, #1             ; Increment string pointer
            b PutStringSBLoop
PutStringSBTerminate
            pop {r0-r3, pc}
            


; *
; * Gets a string from UART
; *
; * Inputs
; *     r0 : address of stored string
; *     r1 : buffer capacity
; * Outputs
; *     a string at the memory location contained in r0
; * Modifies
; *     psr
; */
GetStringSB
            push {r0-r4, lr}
            cmp r1, #0
            beq GetStringSBTerminate   ; String must have at least one character
            subs r1, r1, #1
            movs r2, r0
            movs r3, #0
GetStringSBLoop
            bl GetChar
            cmp r0, #0x0D
            beq GetStringSBCleanup      ; End on return
            cmp r0, #0x08
            beq GetStringSBBackspace    ; Allow backspace
            cmp r0, #0x7F
            beq GetStringSBLoop         ; Get new character if control character
            cmp r0, #0x1F
            bls GetStringSBLoop
            cmp r3, r1
            bhs GetStringSBLoop         ; If buffer size reached, wait for return or backspace
            strb r0, [r2, r3]           ; Store
            adds r3, r3, #1             ; Increment string pointer
            bl PutChar
            b GetStringSBLoop
GetStringSBBackspace
            cmp r3, #0
            beq GetStringSBLoop         ; Only backspace if there are characters in the string
            bl PutChar                  ; Remove character from the screen
            movs r0, #0x20
            bl PutChar
            movs r0, #0x08
            bl PutChar
            subs r3, r3, #1             ; Decrement string poniter
            b GetStringSBLoop
GetStringSBCleanup
            movs r4, #0
            strb r4, [r2, r3]           ; Store NUL terminator
			ldr r0, =crlf_s
            movs r1, #max_string
            bl PutStringSB              ; Print newline
GetStringSBTerminate
            pop {r0-r4, pc}



; *
; * Send ASCII-encoded decimal of a byte
; *
; * Inputs
; *     r0 : the byte to print
; * Outputs
; *     none
; * Modifies
; *     psr
; */
PutNumU
            push {r0-r2, r4, lr}
            cmp r0, #0
            beq PutNumUPrintZero        ; Handle 0
            movs r2, r0
            movs r4, #0
			movs r1, r0
PutNumULoop
            movs r0, #10
            bl Divu                     ; Divide by 10
            push {r1}                   ; Push remainder
            adds r4, r4, #1             ; Increment digit counter
            cmp r0, #0
            beq PutNumUPop              ; If quotient is 0, exit
			movs r1, r0
            b PutNumULoop               ; Divide quotient by 10
PutNumUPop
            cmp r4, #0
            beq PutNumUTerminate        ; If 0 left to print, exit
            pop {r0}
			adds r0, r0, #'0'           ; Convert from uint to char
            bl PutChar
            subs r4, r4, #1             ; Decrement digit counter
            b PutNumUPop
PutNumUPrintZero
            movs r0, #0x30
            bl PutChar                  ; Print ascii 0
            b PutNumUTerminate          ; Leave
PutNumUTerminate
            pop {r0-r2, r4, pc}



; *
; * Get a quotient and a remainder
; *
; * Inputs
; *     R0 : The divisor
; *     R1 : The dividend
; * Outputs
; *     R0 : The quotient
; *     R1 : The remainder
; * Modifies
; *     LR, PSR
; */
Divu
            cmp r0, #0      ; sets carry flag if equal
            beq Divu_end
            push {r2}
            movs r2, #0
Divu_loop
            cmp r1, r0
            blo Divu_cleanup
            subs r1, r1, r0
            adds r2, r2, #1
            b Divu_loop
Divu_cleanup
            movs r0, r2
            ; Clear apsr flags
            movs r2, #1
            adds r2, #1
            pop {r2}
Divu_end
            bx lr

; *
; * Initialize UART for interrupt control at 9600 baud 8N1
; *
; * Inputs
; *     none
; * Outputs
; *     none
; * Modifies
; *     psr
; */

Init_UART0_IRQ
            push {r0, r1, r2, lr}
            ; Initialize queues
            ldr r0, =rx_buffer
            ldr r1, =rx_record
            movs r2, #rx_qbuf_sz
            bl init_queue
            ldr r0, =tx_buffer
            ldr r1, =tx_record
            bl init_queue
            ; Select MCGFLLCLK as UART0 clock source 
            ldr   r0,=SIM_SOPT2 
            ldr   r1,=SIM_SOPT2_UART0SRC_MASK 
            ldr   r2,[r0,#0] 
            bics  r2,r2,r1 
            ldr   r1,=SIM_SOPT2_UART0SRC_MCGFLLCLK 
            orrs  r2,r2,r1 
            str   r2,[r0,#0] 
            ; Set UART0 for external connection 
            ldr   r0,=SIM_SOPT5 
            ldr   r1,=SIM_SOPT5_UART0_EXTERN_MASK_CLEAR 
            ldr   r2,[r0,#0] 
            bics  r2,r2,r1 
            str   r2,[r0,#0] 
            ; Enable UART0 module clock 
            ldr   r0,=SIM_SCGC4 
            ldr   r1,=SIM_SCGC4_UART0_MASK 
            ldr   r2,[r0,#0] 
            orrs  r2,r2,r1 
            str   r2,[r0,#0] 
            ; Enable PORT B module clock 
            ldr   r0,=SIM_SCGC5 
            ldr   r1,=SIM_SCGC5_PORTB_MASK 
            ldr   r2,[r0,#0] 
            orrs  r2,r2,r1 
            str   r2,[r0,#0] 
            ; Select PORT B Pin 2 (D0) for UART0 RX (J8 Pin 01) 
            ldr     r0,=PORTB_PCR2 
            ldr     r1,=PORT_PCR_SET_PTB2_UART0_RX 
            str     r1,[r0,#0] 
            ;  Select PORT B Pin 1 (D1) for UART0 TX (J8 Pin 02) 
            ldr     r0,=PORTB_PCR1 
            ldr     r1,=PORT_PCR_SET_PTB1_UART0_TX 
            str     r1,[r0,#0] 
            ; Disable UART0 receiver and transmitter 
            ldr   r0,=UART0_BASE 
            movs  r1,#UART0_C2_T_R 
            ldrb  r2,[r0,#UART0_C2_OFFSET] 
            bics  r2,r2,r1 
            strb  r2,[r0,#UART0_C2_OFFSET] 
            ; Init NVIC
            ; Set UART0 IRQ priority
            ldr r0, =UART0_IPR
            ldr r2, =NVIC_IPR_UART0_PRI_3
            ldr r3, [r0]
            orrs r3, r2
            str r3, [r0]
            ; Clear pending interrupts
            ldr r0, =NVIC_ICPR
            ldr r1, =NVIC_IPR_UART0_MASK
            str r1, [r0]
            ; Unmask interrupts
            ldr r0, =NVIC_ISER
            ldr r1, =NVIC_ISER_UART0_MASK
            str r1, [r0]
            ; Set UART0 for 9600 baud, 8N1 protocol 
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
            ; Enable UART0 receiver and transmitter 
            movs  r1,#UART0_C2_T_RI
            strb  r1,[r0,#UART0_C2_OFFSET] 
            pop {r0, r1, r2, pc}



; *
; * Initialize PIT module to use 10ms clock, timer freeze in debug, interrupts,
; * and no chain mode.
; *
; * Inputs
; *     none
; * Outputs
; *     none
; * Modifies
; *     psr
; */

Init_PIT_IRQ
            push {r0-r3}
            ; Disable PIT for setup and disable timer in debug
            ldr r0, =PIT_BASE
            ldr r1, [r0, #PIT_MCR_OFFSET]
            movs r2, #PIT_MCR_MF
            ands r1, r2
            str r1, [r0, #PIT_MCR_OFFSET]
            ; Allow PIT clock
            ldr r0, =SIM_BASE
            ldr r1, =SIM_SCGC6_OFFSET
            ldr r2, [r0, r1]
            movs r3, #1
            lsls r3, #SIM_SCGC6_PIT_SHIFT
            ands r2, r3
            str r2, [r0, r1]
            ; Disable timer and timer interrupt
            ldr r1, =PIT_TCTRL0_OFFSET
            movs r2, #0
            str r2, [r0, r1]
            ; NVIC interrupts
            ; Does this order matter?
            ; Set PIT interrupt priority
            ldr r0, =PIT_IPR
            ldr r1, [r0]
            ldr r2, =NVIC_IPR_PIT_PRI_0
            orrs r1, r2
            str r1, [r0]
            ; Clear pending PIT interrupts
            ldr r0, =NVIC_ICPR
            str r1, [r0]
            ; Enable PIT interrupts
            ldr r0, =NVIC_ISER
            ldr r1, =PIT_IRQ_MASK
            str r1, [r0]
            ; Enable PIT module
            ; Why is this here? Shouldn't it be at the end?
            ldr r0, =PIT_BASE
            ldr r1, [r0, #PIT_MCR_OFFSET]
            movs r2, #PIT_MCR_MDIS_MASK
            bics r1, r2
            str r1, [r0, #PIT_MCR_OFFSET]
            ; Set PIT timer value
            ; Wtf? This seems like setup
            ldr r0, =PIT_CH0_BASE
            ldr r1, =PIT_LDVAL_10ms
            str r1, [r0, #PIT_LDVAL_OFFSET]
            ; Enable timer and timer interrupt; disable chain mode
            ; Still seems like setup
            ldr r1, =PIT_TCTRL0_OFFSET
            movs r2, #PIT_TCTRL_TIE_TEN_MASK
            str r2, [r0, r1]
            pop {r0-r3}
            bx lr



; *
; * Handle PIT interrupts
; *
; * Inputs
; *     none
; * Outputs
; *     none
; * Modifies
; *     psr
; */

PIT_ISR
    ; Increment only if run_stop_watch is set
    ldr r0, =run_stop_watch
    cmp r0, #0
    beq PIT_ISR_exit
    ldr r0, =pit_count
    ldr r1, [r0]
    adds r1, #1
    str r1, [r0]
PIT_ISR_exit
    ; Clear interrupt
    ldr r0, =PIT_CH0_BASE
    ldr r1, =PIT_TFLG_TIF_MASK
    str r1, [r0, #PIT_TFLG_OFFSET]
    bx lr



; *
; * Handle UART interrupts
; *
; * Inputs
; *     none
; * Outputs
; *     none
; * Modifies
; *     psr
; */

UART0_ISR
            cpsid I
            push {lr}
            ldr r2, =UART0_BASE
            ldrb r1, [r2, #UART0_C2_OFFSET]
            ldr r3, =UART0_C2_TIE_MASK
            ands r1, r3
            ; Check tx interrupt enabled
            cmp r1, #0
            ; If disabled, jump to rx interrupt check
            beq UART0_ISR_rxint
            ; Else, check tx interrupt
            ldrb r1, [r2, #UART0_S1_OFFSET]
            ldr r3, =UART0_S1_TDRE_MASK
            ands r1, r3
            cmp r1, #0
            ; If disabled, jump to rx interrupt check
            beq UART0_ISR_rxint
            ; Else, dequeue
            ldr r1, =tx_record
            bl Dequeue
            bcs UART0_ISR_disable_tx
            ; If successful, store
            strb r0, [r2, #UART0_D_OFFSET]
            b UART0_ISR_rxint
            ; Else, disable tx
UART0_ISR_disable_tx
            ldr r1, =UART0_C2_T_RI
            strb r1, [r2, #UART0_C2_OFFSET]
            ; Check rx interrupt
UART0_ISR_rxint
            ldrb r1, [r2, #UART0_S1_OFFSET]
            ldr r3, =UART0_S1_RDRF_MASK
            ands r1, r3
            cmp r1, #0
            ; Exit if rx interrupt not set
            beq UART0_ISR_exit
            ; Otherwise, enqueue
            ldrb r0, [r2, #UART0_D_OFFSET]
            ldr r1, =rx_record
            bl Enqueue
UART0_ISR_exit
            cpsie I
            pop {pc}




; *
; * Get a byte from UART0
; *
; * Inputs
; *     none, but requires rx_record to be defined
; * Outputs
; *     r0 : returned byte
; * Modifies
; *     r0
; *     psr
; */

GetChar
            push {r1, lr}
GetChar_loop
            cpsid I
            ldr r1, =rx_record
            bl Dequeue
            cpsie I
            bcs GetChar_loop
            bl Dequeue
            pop {r1, pc}



; *
; * Send a byte over UART0
; *
; * Inputs
; *     r0 : byte to send
; *     requires tx_record to be defined
; * Outputs
; *     none
; * Modifies
; *     psr
; */

PutChar
            push {r1, r2, lr}
PutChar_loop
            ; Put char
            cpsid I
            ldr r1, =tx_record
            bl Enqueue
            cpsie I
            bcs PutChar_loop
            ; Enable transmit interrupt
            ldr r1, =UART0_BASE
            ldr r2, =UART0_C2_TI_RI
            strb r2, [r1, #UART0_C2_OFFSET]
            pop {r1, r2, pc}



; * Initialize queue record
; *
; * Inputs
; *     R0 : buffer address
; *     R1 : record address
; *     R2 : buffer capacity
; * Outputs
; *     None
; * Modifies
; *     psr
; */

init_queue
            push {r3}
            ; In pointer
            str r0, [r1, #in_ptr]
            ; Out pointer
            str r0, [r1, #out_ptr]
            ; Buffer start
            str r0, [r1, #buf_start]
            ; Buffer end
            adds r3, r0, r2
            subs r3, #1
            str r3, [r1, #buf_past]
            ; Buffer size
            strb r2, [r1, #buf_size]
            ; Number enqueued
            movs r3, #0
            strb r3, [r1, #num_enqd]
            pop {r3}
            bx lr



; *
; * Increment queue pointer
; *
; * Inputs
; *     R1 : record address
; *     R2 : pointer
; * Outputs
; *     R2 : incremented pointer
; * Modifies
; *     R2
; *     psr
; */

Pointer_inc
            push {r0, r3}
            ; Load end of buffer
            movs r0, r2
            ldr r3, [r1, #buf_past]
            ; If pointer is at the end of the buffer
            cmp r0, r3
            ; Wrap
            beq Pointer_inc_wrap
            ; Else increment
            adds r0, r0, #1
            b Pointer_inc_exit
Pointer_inc_wrap
            ; Wrap by setting pointer to start of buffer
            ldr r0, [r1, #buf_start]
Pointer_inc_exit
            ; Return
            movs r2, r0
            pop {r0, r3}
            bx lr



; *
; * Attempt to get char from queue
; *
; * Inputs
; *     R1 : record address
; * Outputs
; *     R0 : dequeued character
; *     psr : clear c iff successful
; * Modifies
; *     R0, iff DEQUEUE successful
; *     psr
; */

Dequeue
            push {r2, lr}
            ; Check if empty
            ldrb r2, [r1, #num_enqd]
            cmp r2, #0
            BEQ Dequeue_empty
            ; Get from queue
            ldr r2, [r1, #out_ptr]
            ldrb r0, [r2]
            ; Increment pointer
            bl Pointer_inc
            str r2, [r1, #out_ptr]
            ; Decrement num enqueued
            ldrb r2, [r1, #num_enqd]
            subs r2, r2, #1
            strb r2, [r1, #num_enqd]
            ; Clear C flag
            adds r2, #0
            B Dequeue_exit
Dequeue_empty
            ; Set C flag
            MOVS R2, #0
            MVNS R2, R2
            ADDS R2, R2, #1
Dequeue_exit
            POP {R2, PC}



; *
; * Attempt to put char in queue
; *
; * Inputs
; *     R0 : ENQUEUE char
; *     R1 : record address
; * Outputs
; *     psr: clear c iff ENQUEUE successful
; * Modifies
; *     psr
; */

Enqueue
            push {r2-r3, lr}
            ; Check if full
            ldrb r2, [r1, #buf_size]
            ldrb r3, [r1, #num_enqd]
            cmp r2, r3
            beq Enqueue_full
            ; Store to queue
            ldr r2, [r1, #in_ptr]
            strb r0, [r2]
            ; Increment in pointer
            bl Pointer_inc
            str r2, [r1, #in_ptr]
            ; Increment num enqueued
            adds r3, r3, #1
            strb r3, [r1, #num_enqd]
            ; Clear C flag
            adds r2, #0
            b Enqueue_exit
Enqueue_full
            ; Set C flag
            movs r2, #0
            mvns r2, r2
Enqueue_exit
            pop {r2-r3, pc}



;>>>>>   end subroutine code <<<<<
            ALIGN
; ***************************************************************
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
            DCD    UART0_ISR          ;28:UART0 (status; error)
            DCD    Dummy_Handler      ;29:(reserved)
            DCD    Dummy_Handler      ;30:(reserved)
            DCD    Dummy_Handler      ;31:ADC0
            DCD    Dummy_Handler      ;32:CMP0
            DCD    Dummy_Handler      ;33:TPM0
            DCD    Dummy_Handler      ;34:TPM1
            DCD    Dummy_Handler      ;35:(reserved)
            DCD    Dummy_Handler      ;36:RTC (alarm)
            DCD    Dummy_Handler      ;37:RTC (seconds)
            DCD    PIT_ISR            ;38:PIT
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
; ***************************************************************
;Constants
            AREA    MyConst,DATA,READONLY

;>>>>> begin constants here <<<<<
crlf_s
DCB 0x0a, 0x0d, 0x00
prompt1_s
DCB "Enter your name."
DCB 0x0a, 0x0d
DCB "> ", 0x00
prompt2_s
DCB "Enter the date."
DCB 0x0a, 0x0d
DCB "> ", 0x00
prompt3_s
DCB "Enter the last name of a 250 lab TA."
DCB 0x0a, 0x0d
DCB "> ", 0x00
time_factor_s
DCB " x 0.01 s"
DCB 0x0a, 0x0d, 0x00
goodbye_s
DCB "Thank you.  Goodbye!"
DCB 0x0a, 0x0d, 0x00
;>>>>>   end constants here <<<<<
            ALIGN
; ***************************************************************
;Variables
            AREA    MyData,DATA,READWRITE
;>>>>> begin variables here <<<<<
// PIT counter variables
pit_count
            SPACE 4
run_stop_watch
            SPACE 1
            ALIGN
rx_buffer
            SPACE rx_qbuf_sz
rx_record
            SPACE rx_qrec_sz
            ALIGN
tx_buffer
            SPACE tx_qbuf_sz
tx_record
            SPACE tx_qrec_sz
            ALIGN
response
            SPACE max_string
;>>>>>   end variables here <<<<<
            ALIGN
            END
