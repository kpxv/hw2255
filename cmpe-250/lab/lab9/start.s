.syntax unified
.thumb

.set SIM_COPC, 0x40048100
.set SIM_COPC_COP_DISABLED, 0
.set SIM_SCGC5, 0x4008038
.set SIM_SCGC5_PORTA_MASK, 0x00000200
.set PORTA_BASE, 0x40049000
.set PORT_PCR_SET_PTA3_EXTAL, 0x01000000
.set PORTA_PCR3_OFFSET, 0x0c
.set PORTA_PCR4_OFFSET, 0x10
.set SIM_CLKDIV1, 0x40048044
.set SIM_CLKDIV1_COREDIV1_BUSDIV2, 0x00010000
.set MCG_BASE, 0x40064000
.set MCG_C2_LF_EREFOSC, 0x04
.set MCG_C2_OFFSET, 0x01
.set OSC0_CR, 0x40065000
.set OSC0_CR_ERCLK_STOP_NOLOAD, 0x80
.set MCG_C1_FLL_DIV1_IRCLKEXTSTOP, 0x02
.set MCG_C1_OFFSET, 0x00
.set MCG_S_OSCINIT0_MASK, 0x02
.set MCG_S_OFFSET, 0x06
.set MCG_S_IREFST_MASK, 0x10
.set MCG_C4_OFFSET, 0x03
.set MCG_C4_DRST_DRS_MASK, 0x60
.set MCG_C4_DCO_25PMAX_MID, 0xa0
.set MCG_S_CLKST_MASK, 0xc

.global Startup
Startup:
    push {lr}
    bl SystemInit
    cpsid I
    bl SetClock48MHz
    pop {pc}

SystemInit:
    // Mask interrupts
    cpsid I
    // Disable COP watchdog timer
    ldr r0, =SIM_COPC
    movs r1, #SIM_COPC_COP_DISABLED
    str r1, [r0]
    // Put return addr on stack
    push {lr}
    ldr r1, =0x11111111
    adds r2, r1, r1
    adds r3, r2, r1
    adds r4, r3, r1
    adds r5, r4, r1
    adds r6, r5, r1
    adds r7, r6, r1
    mov r8, r1
    add r8, r8, r7
    mov r9, r1
    add r9, r9, r8
    mov r10, r1
    add r10, r10, r9
    mov r11, r1
    add r11, r11, r10
    mov r12, r1
    add r12, r12, r11
    mov r14, r2
    add r14, r14, r12
    mov r0, r1
    add r0, r0, r14
    msr apsr, r0
    ldr r0, =0x05250113
    pop {pc}

SetClock48MHz:
    push {r0-r3}
            LDR      R0,=SIM_SCGC5
            LDR      R1,=SIM_SCGC5_PORTA_MASK
            LDR      R2,[R0,#0]
            ORRS     R2,R2,R1
            STR      R2,[R0,#0]
            LDR      R0,=PORTA_BASE
            LDR      R1,=PORT_PCR_SET_PTA3_EXTAL
            STR      R1,[R0,#PORTA_PCR3_OFFSET]
            STR      R1,[R0,#PORTA_PCR4_OFFSET]
            LDR      R0,=SIM_CLKDIV1
            LDR      R1,=SIM_CLKDIV1_COREDIV1_BUSDIV2
            STR      R1,[R0,#0]
            LDR     R0,=MCG_BASE
            MOVS    R1,#MCG_C2_LF_EREFOSC
            STRB    R1,[R0,#MCG_C2_OFFSET]
            LDR     R2,=OSC0_CR
            MOVS    R1,#OSC0_CR_ERCLK_STOP_NOLOAD
            STRB    R1,[R2,#0]
            MOVS    R1,#MCG_C1_FLL_DIV1_IRCLKEXTSTOP
            STRB    R1,[R0,#MCG_C1_OFFSET]
            MOVS    R1,#MCG_S_OSCINIT0_MASK
SetClock48MHz_Wait_MCG_S_OSCINIT0:                      //repeat {
            LDRB    R2,[R0,#MCG_S_OFFSET]
            TST     R1,R2
            BEQ     SetClock48MHz_Wait_MCG_S_OSCINIT0  //} until OSCINIT0
            MOVS    R1,#MCG_S_IREFST_MASK
SetClock48MHz_Wait_MCG_S_IREFST_Clear:                      //do {
            LDRB    R2,[R0,#MCG_S_OFFSET]
            TST     R1,R2
            BNE     SetClock48MHz_Wait_MCG_S_IREFST_Clear  //} while IREFST
            LDRB    R2,[R0,#MCG_C4_OFFSET]
            MOVS    R1,#MCG_C4_DRST_DRS_MASK
            MOVS    R3,#MCG_C4_DCO_25PMAX_MID
            BICS    R2,R2,R1
            ORRS    R2,R2,R3
            STRB    R2,[R0,#MCG_C4_OFFSET]
            MOVS    R1,#MCG_S_CLKST_MASK
SetClock48MHz_Wait_MCG_FLL_Selected:                      //do {
            LDRB    R2,[R0,#MCG_S_OFFSET]
            TST     R1,R2
            BNE     SetClock48MHz_Wait_MCG_FLL_Selected  //} while CLKST
            POP     {R0-R3}
            BX      LR

.align

.global Dummy_Handler
Dummy_Handler:
    b .

.align
