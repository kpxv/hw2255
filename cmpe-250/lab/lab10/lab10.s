.set SIM_SCGC6_ADDR, 0x4004_803C
.set PIT_TCTRL0_ADDR, 0x4003_7108

.set SIM_SCGC6_PIT_BIT, 23
.set SIM_SCGC6_PIT_MASK, (1 << SIM_SCGC6_PIT_BIT)

.set PIT_TCTRL0_TEN_BIT, 31
.set PIT_TCTRL0_TEN_MASK, (1 << PIT_TCTRL0_TEN_BIT)

.section .text
.global _start
_start:
    bl Init_PIT_IRQ

Init_PIT_IRQ:
    // Enable PIT clock
    ldr r0, =SIM_SCGC6_ADDR
    ldr r1, [r0]
    ldr r2, =SIM_SCGC6_PIT_MASK
    orrs r1, r2
    str r1, [r0]
    // Disable Timer 0
    ldr r0, =PIT_TCTRL0_ADDR
    ldr r1, [r0]
    ldr r2, =PIT_TCTRL0_TEN_MASK
    bics r1, r2
    str r1, [r0]
    // Set interrupt priority to 0
