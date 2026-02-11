.global _start

.equ vector_table_size, 0x000000c0
.equ vector_size, 4


.section .text

_start:
    movs r0, #7
    movs r1, #21


.section .data
