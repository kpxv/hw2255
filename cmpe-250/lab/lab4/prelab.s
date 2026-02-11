.global _start

_start:
    ; Set divisor
    mov r0, #7
    ; Set dividend
    mov r1, #37

    bl divu

divu:
    

divu_loop:
    lsrs r0, #1

end:
    mov r7, #1
    swi 0
