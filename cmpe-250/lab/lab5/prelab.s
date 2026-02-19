.set uart0_bdh, 0x4006A000
.set uart0_bdl, 0x4006A001
.set uart0_c1, 0x4006A002
.set uart0_c2, 0x4006A003
.set uart0_s1, 0x4006A004
.set uart0_s2, 0x4006A005
.set uart0_c3, 0x4006A006
.set uart0_d, 0x4006A007
.set uart0_ma1, 0x4006A008
.set uart0_ma2, 0x4006A009
.set uart0_c4, 0x4006A00A
.set uart0_c5, 0x4006A00B

.set sim_sopt1, 0x40047000
.set sim_sopt1cfg, 0x40047004
.set sim_sopt2, 0x40048004
.set sim_sopt4, 0x4004800C
.set sim_sopt5, 0x40048010
.set sim_sopt7, 0x40048018
.set sim_sdid, 0x40048024
.set sim_scgc4, 0x40048034
.set sim_scgc5, 0x40048038
.set sim_scgc6, 0x4004803C
.set sim_scgc7, 0x40048040
.set sim_clkdiv1, 0x40048044
.set sim_fcfg1, 0x4004804c
.set sim_fcfg2, 0x40048050
.set sim_uidmh, 0x40048058
.set sim_uidml, 0x4004805c
.set sim_uidl, 0x40048060
.set sim_copc, 0x40048100
.set sim_srvcop, 0x40048104

.set uart0_bdh_9600, 0x01
.set uart0_bdl_9600, 0x38

.set uart0_c1_opt, 0x00

.set uart0_c2_t_r_clr, 0x00
.set uart0_c2_t_en, 0x08
.set uart0_c2_r_en, 0x04
.set uart0_c2_t_r_en, 0x0c

// TDRE is bit 7: 2_1000 0000
.set uart0_s1_tdre_mask, 0x80
// RDRF is bit 5: 2_0010 0000
.set uart0_s1_rdrf_mask, 0x20

// Stores \data to \dest. Modifies R0 and R1
.macro storeb_unsafe data, dest
    ldr r0, =\dest
    movs r1, #\data
    strb r1, [r0, #0]
.endm


.global _start

_start:
    bl Init_UART0_Polling
    movs r0, #65
    bl PutChar
    bl GetChar
    b .

/**
  * Initialize board for polled serial I/O with UART0 through ports B pins 1
  * and 2, using: 8 data bits, no parity, and one stop bit at 9600 baud
  * Changes: LR, PC, PSR
  **/
Init_UART0_Polling:
    push {r0, r1}
    // Clear TE and RE
    storeb_unsafe uart0_c2_t_r_clr, uart0_c2

    // Enable polling; use 2 pins; set stop bit to 1; set baud rate to 9600
    storeb_unsafe uart0_bdh_9600, uart0_bdh
    storeb_unsafe uart0_bdl_9600, uart0_bdl

    // Set 8-bit data, no parity
    storeb_unsafe uart0_c1_opt, uart0_c1

    pop {r0, r1}
    bx lr

/**
  * Gets a character from UART0_D
  * Return value in R0
  * Changes: R0, LR, PC, PSR
  **/
GetChar:
    push {r1}
    movs r1, #uart0_s1_rdrf_mask
GetCharLoop:
    // Wait for RDRF to be set
    ldr r0, =uart0_s1
    ldrb r0, [r0, #0]
    ands r0, r0, r1
    cmp r0, #0
    bne GetCharLoop

    // Read UART0_D
    ldr r0, =uart0_d
    ldrb r0, [r0, #0]

    pop {r1}
    bx lr

/**
  * Puts a character into UART0_D
  * Reads from R0
  * Changes: LR, PC, PSR
  **/
PutChar:
    push {r1, r2}
    movs r1, #uart0_s1_tdre_mask
PutCharLoop:
    // Wait for TDRE to be set
    ldr r2, =uart0_s1
    ldrb r2, [r2, #0]
    ands r2, r2, r1
    cmp r2, #0
    bne PutCharLoop

    // Write UART0_D
    ldr r2, =uart0_d
    strb r0, [r2, #0]

    pop {r1, r2}
    bx lr
