.nolist
.include "mkl05z4.s"
.list
.section code, "ax"
.global Reset_Handler
Reset_Handler:
    bl Startup
    b .

// ****************************************************************
// Vector Table Mapped to Address 0 at Reset
// Linker requires __Vectors to be exported
.section RESET, "a"
            //  EXPORT  __Vectors
            //  EXPORT  __Vectors_End
            //  EXPORT  __Vectors_Size
            //  IMPORT  __initial_sp
            //  IMPORT  Dummy_Handler
            //  IMPORT  HardFault_Handler
__Vectors:
                                      // ARM core vectors
            .word    __initial_sp       // 00:end of stack
            .word    Reset_Handler      // 01:reset vector
            .word    Dummy_Handler      // 02:NMI
            .word    HardFault_Handler  // 03:hard fault
            .word    Dummy_Handler      // 04:(reserved)
            .word    Dummy_Handler      // 05:(reserved)
            .word    Dummy_Handler      // 06:(reserved)
            .word    Dummy_Handler      // 07:(reserved)
            .word    Dummy_Handler      // 08:(reserved)
            .word    Dummy_Handler      // 09:(reserved)
            .word    Dummy_Handler      // 10:(reserved)
            .word    Dummy_Handler      // 11:SVCall (supervisor call)
            .word    Dummy_Handler      // 12:(reserved)
            .word    Dummy_Handler      // 13:(reserved)
            .word    Dummy_Handler      // 14:PendSV (PendableSrvReq)
                                      //    pendable request 
                                      //    for system service)
            .word    Dummy_Handler      // 15:SysTick (system tick timer)
            .word    Dummy_Handler      // 16:DMA channel 0 transfer 
                                      //    complete/error
            .word    Dummy_Handler      // 17:DMA channel 1 transfer
                                      //    complete/error
            .word    Dummy_Handler      // 18:DMA channel 2 transfer
                                      //    complete/error
            .word    Dummy_Handler      // 19:DMA channel 3 transfer
                                      //    complete/error
            .word    Dummy_Handler      // 20:(reserved)
            .word    Dummy_Handler      // 21:FTFA command complete/
                                      //    read collision
            .word    Dummy_Handler      // 22:low-voltage detect;
                                      //    low-voltage warning
            .word    Dummy_Handler      // 23:low leakage wakeup
            .word    Dummy_Handler      // 24:I2C0
            .word    Dummy_Handler      // 25:(reserved)
            .word    Dummy_Handler      // 26:SPI0
            .word    Dummy_Handler      // 27:(reserved)
            .word    Dummy_Handler      // 28:UART0 (status; error)
            .word    Dummy_Handler      // 29:(reserved)
            .word    Dummy_Handler      // 30:(reserved)
            .word    Dummy_Handler      // 31:ADC0
            .word    Dummy_Handler      // 32:CMP0
            .word    Dummy_Handler      // 33:TPM0
            .word    Dummy_Handler      // 34:TPM1
            .word    Dummy_Handler      // 35:(reserved)
            .word    Dummy_Handler      // 36:RTC (alarm)
            .word    Dummy_Handler      // 37:RTC (seconds)
            .word    Dummy_Handler      // 38:PIT
            .word    Dummy_Handler      // 39:(reserved)
            .word    Dummy_Handler      // 40:(reserved)
            .word    Dummy_Handler      // 41:DAC0
            .word    Dummy_Handler      // 42:TSI0
            .word    Dummy_Handler      // 43:MCG
            .word    Dummy_Handler      // 44:LPTMR0
            .word    Dummy_Handler      // 45:(reserved)
            .word    Dummy_Handler      // 46:PORTA
            .word    Dummy_Handler      // 47:PORTB
__Vectors_End:
.set __Vectors_Size, __Vectors_End - __Vectors
.balign 4
// ****************************************************************
.section const, "a"
test:
.word 0x01234567
.section data, "aw", %nobits
test1:
.skip 0x8
