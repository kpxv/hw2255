MACRO validate_f
    adds r0, #128
    cmp r0, r4
    bhi err_f
    subs r0, #128
MEND

MACOR validate_g
    adds r0, #128
    cmp r0, r4
    bhi err_g
    subs r0, #128
MEND

MACRO validate_res
    adds r0, #128
    cmp r0, r4
    bhi err_res
    subs r0, #128
MEND

_start:
    bl init
    bl load_var

    ; Prep for comparison
    movs r4, #127
    adds r4, #128

    ;**
    ; * F
    ; */

    ; 3P
    movs r0, r1
    lsls r0, r0, #1
    validate_f
    adds r0, r0, r1
    validate_f

    ; 2Q
    adds r0, r0, r2
    validate_f
    adds r0, r0, r2
    validate_f

    ; -75
    ldr r3, =const_f
    ldr r3, [r3]
    subs r0, r0, r3
    validate_f
    b store_f

err_f:
    movs r0, #0

store_f:
    ; Store
    ldr r3, =f
    str r0, [r3]



    ;**
    ; * G
    ; */

    ; 2P
    movs r0, r1
    lsls r0, r0, #1
    validate_g

    ; -4Q
    lsls r2, r2, #2
    validate_g
    subs r0, r0, r2
    validate_g

    ; +63
    ldr r3, =const_g
    ldr r3, [r3]
    adds r0, r0, r3
    validate_g
    b store_g

err_g:
    movs r0, #0

store_g:
    ; Store
    ldr r3, =g
    str r0, [r3]

    ;**
    ; * Final
    ; */

    ; Sum
    ldr r1, =f
    ldr r1, [r1]
    adds r0, r0, r1
    validate_res
    b store_res

err_res:
    movs r0, #0

store_res:
    ; Store
    ldr r1, =result
    str r0, [r1]

    ; End
    b .



init:
    ldr r0, =p
    ldr r3, =q

    ; Input 1
    ; movs r1, #9
    ; movs r2, #4

    ; Input 2
    movs r1, #13
    movs r2, #14
    rsbs r2, r2, #0

    str r1, [r0]
    str r2, [r3]

    bx lr


load_var:
    ldr r0, =p
    ldr r3, =q
    ldr r1, [r0]
    ldr r2, [r3]

    bx lr
    

const_f:
.word 75
const_g:
.word 63


.section .data
f:
.space 4
g:
.space 4
p:
.space 4
q:
.space 4
result:
.space 4
