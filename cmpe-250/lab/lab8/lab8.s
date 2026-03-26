.set n, 4
.set stack_buf_sz, 8*n+4
.set num_sz, 4*n

.set hex_0, 0x30
.set hex_9, 0x3A
.set hex_A, 0x41
.set hex_a, 0x61
.set hex_a_A, 0x20
.set hex_A_10, 0x7

.section .text
.global _start
_start:
    ldr r0, =storage
    movs r1, #n
    bl GetHexIntMulti

    b .



/**
  * Adds n unsigned words together
  *
  * Inputs:
  *     r0 : address to store sum
  *     r1 : start address of the first addend
  *     r2 : start address of the second addend
  *     r3 : the length n of the numbers
  * Outputs:
  *     psr : clear c iff valid n-word number returned
  * Modifies:
  *     psr
  */
AddIntMultiU:
    push {r3-r6}
    //  r4 : addend store / sum
    //  r5 : addend store
    //  r6 : hold apsr
    lsls r3, #2
    // Clear carry
    adds r0, r0, #0
    mrs r6, apsr
aimu_loop:
    subs r3, r3, #4
    ldr r4, [r1, r3]
    ldr r5, [r2, r3]
    // Restore apsr flags
    msr apsr, r6
    adcs r4, r4, r5
    // Store apsr flags
    mrs r6, apsr
    str r4, [r0, r3]
    cmp r3, #0
    bne aimu_loop
    // Set C if addition overflowed
    msr apsr, r6
    pop {r3-r6}
    bx lr



/**
  * Gets an n-word ASCII-encoded hex number from UART, terminated on return
  * keystroke, and stores it as binary in memory
  *
  * Inputs:
  *     r0 : address to store binary number
  *     r1 : the length n of the number
  * Outputs:
  *     psr : clear c iff valid n-word number returned
  * Modifies:
  *     psr
  */
GetHexIntMulti:
    push {r0-r2, r4-r7, lr}
    // r4 : store address
    // r5 : length n
    // r6 : stack pointer
    movs r4, r0
    movs r5, r1
    // Use stack as buffer
    // In Thumb 1, cannot easily make dynamic buffer in stack. Uses an EQUate instead.
    sub sp, #stack_buf_sz
    mov r0, sp
    // Find length of string buffer
    lsls r1, #3
    adds r1, #1
    // Get input from user
    bl GetStringSB
    // Put LSB closest to the stack pointer
    bl ReverseString

    mov r6, sp
    movs r7, #0
    movs r1, #num_sz
    subs r1, #1
ghim_store_in:
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
ghim_pre_end_store:
    movs r0, r2
ghim_end_store:
    strb r0, [r4, r1]
    movs r0, #0
ghim_end_loop:
    cmp r1, #0
    beq ghim_clean_exit
    subs r1, #1

    strb r0, [r4, r1]
    b ghim_end_loop
ghim_clean_exit:
    // Clear C flag
    adds r0, #0
ghim_exit:
    add sp, #stack_buf_sz
    pop {r0-r2, r4-r7, pc}



/**
  * Outputs an n-word ASCII-encoded hex number to UART
  *
  * Inputs:
  *     r0 : start address of number
  *     r1 : the length n of the number
  * Outputs:
  *     None
  * Modifies:
  *     psr
  */
PutHexIntMulti:
    push {r0-r1, r4, lr}
    // r0 : arg for PutNumHex
    // r1 : loop counter
    // r4 : word address
    movs r4, r0
phim_loop:
    // Print the ith word
    ldr r0, [r4]
    bl PutNumHex
    // Increment counters
    adds r4, #4
    subs r1, #1
    // Loop
    cmp r1, #0
    bne phim_loop
    pop {r0-r1, r4, pc}



/**
  * Placeholder
  */
PutNumHex:
    movs r7, r0
    bx lr



/**
  * Placeholder
  */
GetStringSB:
    push {r1-r3}
    ldr r1, =str
    movs r3, #0
gssb_loop:
    ldrb r2, [r1, r3]
    strb r2, [r0, r3]
    adds r3, #1
    cmp r2, #0
    bne gssb_loop
    pop {r1-r3}
    bx lr



/**
  * Reverses a nul-terminated string in place
  *
  * Inputs:
  *     r0 : input string address
  * Outputs:
  *     None
  * Modifies:
  *     psr
  */
ReverseString:
    push {r4-r7}
    // r0 : input address
    // r4 : input offset
    // r5 : output offset
    // r6 : temporary byte storage
    // r7 : temporary byte storage
    movs r4, #0
    movs r5, #0
    // Search for NUL terminator
rs_find_nul:
    ldrb r6, [r0, r4]
    adds r4, #1
    cmp r6, #0
    bne rs_find_nul
    subs r4, #2
rs_reverse:
    // Swap bytes from either end of the string
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



/**
  * Convert an ASCII char byte to a binary nibble.
  *
  * Inputs:
  *     r0 : byte to convert
  * Outputs:
  *     r0 : converted byte
  *     psr : clear c iff valid input
  * Modifies:
  *     psr
  */
HexToBin:
    // Must be at least hex 0
    cmp r0, #hex_0
    blo htb_fail
    // Must not be between hex 9 and hex A
    cmp r0, #hex_9
    blo htb_tolower
    cmp r0, #hex_A
    blo htb_fail
htb_tolower:
    cmp r0, #hex_a
    blo htb_tooffsetbin
    subs r0, #hex_a_A
htb_tooffsetbin:
    cmp r0, #hex_A
    blo htb_tobin
    subs r0, #hex_A_10
htb_tobin:
    subs r0, #hex_0
    cmp r0, #0xF
    bhi htb_fail
htb_pass:
    // Clear C flag
    adds r0, #0
    b htb_exit
htb_fail:
    // Set C flag
    movs r0, #1
    subs r0, #1
htb_exit:
    bx lr



.section .data
sum: .word 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000
a1: .word 0x00001111, 0x00002222, 0x00003333, 0x00004444, 0x00005555, 0x00006666, 0x00007777, 0x00008888
a2: .word 0x00100000, 0x00200000, 0x00300000, 0x00400000, 0x00500000, 0x00600000, 0x00700000, 0x00800000
str: .byte '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f', 0x00
storage: .skip stack_buf_sz
