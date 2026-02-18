.set uart0_bdh, 0x4006_A000
.set uart0_bdl, 0x4006_A001
.set uart0_c1, 0x4006_A002
.set uart0_c2, 0x4006_A003
.set uart0_s1, 0x4006_A004
.set uart0_s2, 0x4006_A005
.set uart0_c3, 0x4006_A006
.set uart0_d, 0x4006_A007
.set uart0_ma1, 0x4006_A008
.set uart0_ma2, 0x4006_A009
.set uart0_c4, 0x4006_A00A
.set uart0_c5, 0x4006_A00B

.set uart0_bdh_9600, 0x01
.set uart0_bdl_9600, 0x38

.set uart0_c1_opt, 0x00

.set uart0_c2_t_r_clr, 0x00
.set uart0_c2_t_en, 0x08
.set uart0_c2_r_en, 0x04
.set uart0_c2_t_r_en, 0x0c

// Stores \data to \to. Modifies R0 and R1
.macro storeb_unsafe data, to
    movs r0, \to
    movs r1, \data
    strb r1, [r0, #0]
.endm


.global _start

_start:
    bl Init_UART0_Polling
    b .

/**
  * Initialize board for polled serial I/O with UART0 through ports B pins 1
  * and 2, using: 8 data bits, no parity, and one stop bit at 9600 baud
  * Changes: LR, PC, PSR
  **/
Init_UART0_Polling:
    push {r0, r1}
    // Clear TE and RE
    storeb_unsafe uart0_c2_t_r_clr, =uart0_c2

    // Enable polling; use 2 pins; set stop bit to 1; set baud rate to 9600
    storeb_unsafe uart0_bdh_9600, =uart0_bdh
    storeb_unsafe uart0_bdl_9600, =uart0_bdl

    // Set 8-bit data, no parity
    storeb_unsafe uart0_c1_opt, =uart0_c1

    pop {r0, r1}
    bx lr

/**
  * Gets a character from ____
  * Return value in R0
  * Changes: R0, LR, PC, PSR
  **/
GetChar:
    bx lr

/**
  * Puts a character into ____
  * Reads from R0
  * Changes: LR, PC, PSR
  **/
PutChar:
    bx lr
