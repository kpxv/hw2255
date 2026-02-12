.global _start

_start:
    movs r2, #0xF
    // 37 / 7
    movs r0, #7
    movs r1, #37
    bl divu         // Expect R0:5, R1:2
    // 37 / 0
    movs r0, #0
    movs r1, #37
    bl divu         // Expect R0:0, R1:37
    // 0 / 7
    movs r0, #7
    movs r1, #0
    bl divu         // Expect R0:0, R1:0
    // Exit
    b exit


divu:
    cmp r0, #0      // sets carry flag if equal
    beq divu_end
    push {r2}
    movs r2, #0
divu_loop:
    cmp r1, r0
    blt divu_cleanup
    subs r1, r1, r0
    adds r2, r2, #1
    b divu_loop
divu_cleanup:
    movs r0, r2
    // Clear APSR flags
    movs r2, #1
    adds r2, #1
    pop {r2}
divu_end:
    bx lr


exit:
    movs r7, #1
    swi 0
