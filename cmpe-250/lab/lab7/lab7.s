.set in_ptr, 0
.set out_ptr, 4
.set buf_strt, 8
.set buf_past, 12
.set buf_size, 16
.set num_enqd, 17

.set q_buf_sz, 80
.set q_rec_sz, 18

.section .text
.global _start
_start:
    // Init
    ldr r0, =qbuffer
    ldr r1, =qrecord
    movs r2, #4
    bl init_queue
    movs r0, 'h'
    bl enqueue
    bl dequeue

    movs r0, 'h'
    bl enqueue
    movs r0, 'e'
    bl enqueue
    movs r0, 'l'
    bl enqueue
    movs r0, 'o'
    bl enqueue
    movs r0, 'A'
    bl enqueue
    bl dequeue
    movs r0, 'A'
    bl enqueue
    bl dequeue
    bl dequeue
    bl dequeue
    bl dequeue
    bl dequeue
    b .

/**
  * Initialize queue record
  *
  * Inputs:
  *     r0 : buffer address
  *     r1 : record address
  *     r2 : queue capacity
  * Outputs:
  *     None
  * Modified:
  *     psr
  */
init_queue:
    push {r3}
    // In pointer
    str r0, [r1, #in_ptr]
    // Out pointer
    str r0, [r1, #out_ptr]
    // Buffer start
    str r0, [r1, #buf_strt]
    // Buffer end
    adds r3, r0, r2
    subs r3, r3, #1
    str r3, [r1, #buf_past]
    // Buffer size
    strb r2, [r1, #buf_size]
    // Number enqueued
    movs r3, #0
    strb r3, [r1, #num_enqd]
    pop {r3}
    bx lr

/**
  * Attempt to get char from queue
  *
  * Inputs:
  *     r1 : record address
  * Outputs:
  *     r0 : dequeued character
  *     psr : clear c iff successful
  * Modified:
  *     r0, iff dequeue successful
  *     psr
  */
dequeue:
    push {r2, lr}
    // Check if empty
    ldrb r2, [r1, #num_enqd]
    cmp r2, #0
    beq dequeue_empty
    // Get from queue
    ldr r2, [r1, #out_ptr]
    ldrb r0, [r2]
    // Increment pointer
    movs r2, #out_ptr
    bl pointer_inc
    // Decrement num enqueued
    ldrb r2, [r1, #num_enqd]
    subs r2, r2, #1
    strb r2, [r1, #num_enqd]
    // Clear C flag
    adds r2, #0
    b dequeue_exit
dequeue_empty:
    // Set C flag
    mvns r2, #0
    adds r2, r2, #1
dequeue_exit:
    pop {r2, pc}

/**
  * Attempt to put char in queue
  *
  * Inputs:
  *     r0 : enqueue char
  *     r1 : record address
  * Outputs:
  *     psr: clear c iff enqueue successful
  * Modified:
  *     psr
  */
enqueue:
    push {r2, r3, lr}
    // Check if full
    ldrb r2, [r1, #buf_size]
    ldrb r3, [r1, #num_enqd]
    cmp r2, r3
    beq enqueue_full
    // Store to queue
    ldr r2, [r1, #in_ptr]
    strb r0, [r2]
    // Increment in pointer
    movs r2, #in_ptr
    bl pointer_inc
    // Increment num enqueued
    adds r3, r3, #1
    strb r3, [r1, #num_enqd]
    // Clear C flag
    adds r2, #0
    b enqueue_exit
enqueue_full:
    // Set C flag
    mvns r2, #0
enqueue_exit:
    pop {r2, r3, pc}

/**
  * Increment queue pointer
  *
  * Inputs:
  *     r1 : record address
  *     r2 : pointer offset from record
  * Outputs:
  *     r2 : incremented pointer
  * Modifies:
  *     r2
  *     psr
  */
pointer_inc:
    push {r0, r3}
    // Load pointer
    ldr r0, [r1, r2]
    ldr r3, [r1, #buf_past]
    cmp r0, r3
    beq pointer_inc_wrap
    adds r0, r0, #1
    b pointer_inc_exit
pointer_inc_wrap:
    ldr r0, [r1, #buf_strt]
pointer_inc_exit:
    str r0, [r1, r2]
    movs r2, r0
    pop {r0, r3}
    bx lr



.section .data
qbuffer:
    .skip q_buf_sz
qrecord:
    .skip q_rec_sz
