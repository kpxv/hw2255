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
; Address EQUates
uart0_bdh EQU 0x4006A000
uart0_bdl EQU 0x4006A001
uart0_c1 EQU 0x4006A002
uart0_c2 EQU 0x4006A003
uart0_s1 EQU 0x4006A004
uart0_s2 EQU 0x4006A005
uart0_c3 EQU 0x4006A006
uart0_d EQU 0x4006A007
uart0_ma1 EQU 0x4006A008
uart0_ma2 EQU 0x4006A009
uart0_c4 EQU 0x4006A00A
uart0_c5 EQU 0x4006A00B

sim_sopt1 EQU 0x40047000
sim_sopt1cfg EQU 0x40047004
sim_sopt2 EQU 0x40048004
sim_sopt4 EQU 0x4004800C
sim_sopt5 EQU 0x40048010
sim_sopt7 EQU 0x40048018
sim_sdid EQU 0x40048024
sim_scgc4 EQU 0x40048034
sim_scgc5 EQU 0x40048038
sim_scgc6 EQU 0x4004803C
sim_scgc7 EQU 0x40048040
sim_clkdiv1 EQU 0x40048044
sim_fcfg1 EQU 0x4004804c
sim_fcfg2 EQU 0x40048050
sim_uidmh EQU 0x40048058
sim_uidml EQU 0x4004805c
sim_uidl EQU 0x40048060
sim_copc EQU 0x40048100
sim_srvcop EQU 0x40048104

; Shift EQUates
sim_sopt2_uart0src_shift EQU 26

; Setting EQUates
uart0_bdh_9600 EQU 0x01
uart0_bdl_9600 EQU 0x38

uart0_c1_opt EQU 0x00

uart0_c2_t_r_clr EQU 0x00
uart0_c2_t_en EQU 0x08
uart0_c2_r_en EQU 0x04
uart0_c2_t_r_en EQU 0x0c

sim_sopt2_uart0src_mcgfllclk EQU (01 << sim_sopt2_uart0src_shift)

; Mask EQUates
uart0_s1_tdre_mask EQU 0x80
uart0_s1_rdrf_mask EQU 0x20


; Stores \data to \dest. Modifies R0 and R1
	MACRO
	storeb_unsafe $data, $dest
    ldr r0, =$dest
    movs r1, #$data
    strb r1, [r0, #0]
	MEND
;****************************************************************
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
			bl Init_UART0_Polling
			movs r0, #65
			bl PutChar
			bl GetChar
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
Init_UART0_Polling
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

    ; TODO: use MCGFLLCLK

    ; Clear TE and RE
    ;storeb_unsafe uart0_c2_t_r_clr, uart0_c2

    ; Enable polling; use 2 pins; set stop bit to 1; set baud rate to 9600
    ;storeb_unsafe uart0_bdh_9600, uart0_bdh
    ;storeb_unsafe uart0_bdl_9600, uart0_bdl

    ; Set 8-bit data, no parity
    ;storeb_unsafe uart0_c1_opt, uart0_c1

    pop {r0, r1, r2}
    bx lr

;*
; Gets a character from UART0_D
; Return value in R0
; Changes: R0, LR, PC, PSR
;*/
GetChar
    push {r1}
    movs r1, #uart0_s1_rdrf_mask
GetCharLoop
    ; Wait for RDRF to be set
    ldr r0, =uart0_s1
    ldrb r0, [r0, #0]
    ands r0, r0, r1
    cmp r0, #0
    bne GetCharLoop

    ; Read UART0_D
    ldr r0, =uart0_d
    ldrb r0, [r0, #0]

    pop {r1}
    bx lr

;*
; Puts a character into UART0_D
; Reads from R0
; Changes: LR, PC, PSR
;*/
PutChar
    push {r1, r2}
    movs r1, #uart0_s1_tdre_mask
PutCharLoop
    ; Wait for TDRE to be set
    ldr r2, =uart0_s1
    ldrb r2, [r2, #0]
    ands r2, r2, r1
    cmp r2, #0
    bne PutCharLoop

    ; Write UART0_D
    ldr r2, =uart0_d
    strb r0, [r2, #0]

    pop {r1, r2}
    bx lr
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
;>>>>>   end constants here <<<<<
            ALIGN
;****************************************************************
;Variables
            AREA    MyData,DATA,READWRITE
;>>>>> begin variables here <<<<<
;>>>>>   end variables here <<<<<
            ALIGN
            END
