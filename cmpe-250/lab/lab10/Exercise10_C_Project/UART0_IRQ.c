/***************************************************************/
/* Module of functions to support UART0 I/O with interrupts    */
/* R. W. Melton                                                */
/* 10/12/2023                                                  */
/*-------------------------------------------------------------*/
/* Revision history:                                           */
/* 10/12/2023 Moved MKL46Z4.h include to UART0_IRQ.h           */
/* 6/22/2015 Original version                                  */
/***************************************************************/

#include "UART0_IRQ.h"

/* Boolean constants */
#define FALSE (0)
#define TRUE (1)

/* UART0 I/O Buffers */
#define UART_BUFFER_SIZE (80)

char RxQueueBuffer [UART_BUFFER_SIZE],
     TxQueueBuffer [UART_BUFFER_SIZE];  
qRecord RxQueue,
        TxQueue;

char GetChar (void) {
/***************************************************************/
/* Gets a character from UART0 via RxQueue.                    */
/* If RxQueue is empty, it waits for a character.              */
/* Dequeue is a critical code section shared with UART0_ISR.   */
/***************************************************************/
  /* return (GetCharQueue (&RxQueue)); */

  char Character; 
  int Failure;

  do {
    __asm("CPSID   I");  /* mask interrupts */
    Failure = Dequeue (&Character, &RxQueue);
    __asm("CPSIE   I");  /* unmask interrupts */
  } while (Failure);
  return (Character);
} /* char GetChar (void) */

char GetCharQueue (qRecord *RxQueue) {
/***************************************************************/
/* Gets a character from UART0 via RxQueue.                    */
/* If RxQueue is empty, it waits for a character.              */
/* Dequeue is a critical code section shared with UART0_ISR.   */
/***************************************************************/

  char Character; 
  int Failure;

  do {
    __asm("CPSID   I");  /* mask interrupts */
    Failure = Dequeue (&Character, RxQueue);
    __asm("CPSIE   I");  /* unmask interrupts */
  } while (Failure);
  return (Character);
} /* char GetCharQueue (qRecord *RxQueue) */

void Init_UART0_IRQ (void) {
/***************************************************************/
/* Initializes UART0 for 9600 baud and 8N1 format              */
/* Initializes circular FIFO queues for Rx and Tx              */
/***************************************************************/
  /* Initialize circular FIFO queues */
  Init_Queue (RxQueueBuffer, &RxQueue, UART_BUFFER_SIZE);
  Init_Queue (TxQueueBuffer, &TxQueue, UART_BUFFER_SIZE);

  /* Select MCGFLLCLK as UART0 clock source */
  SIM->SOPT2 &= ~SIM_SOPT2_UART0SRC_MASK;
  SIM->SOPT2 |= SIM_SOPT2_UART0SRC_MCGFLLCLK;
  /* Set UART0 for external connection */
  SIM->SOPT5 &= ~SIM_SOPT5_UART0_EXTERN_MASK_CLEAR;
  /* Enable UART0 module clock */
  SIM->SCGC4 |= SIM_SCGC4_UART0_MASK;
  /* Some OpenSDA applications provide a virtual serial port */
  /* through the OpenSDA USB connection using PTB1 and PTB2  */
  /* Enable PORT B module clock */
  SIM->SCGC5 |= SIM_SCGC5_PORTB_MASK;
  /* Select PORT B Pin 2 (D0) for UART0 RX */
  PORTB->PCR[2] = PORT_PCR_SET_PTB2_UART0_RX;
  /* Select PORT B Pin 1 (D1) for UART0 TX */
  PORTB->PCR[1] = PORT_PCR_SET_PTB1_UART0_TX;
  /* Set for 9600 baud from 48MHz FLL clock */
  /* Disable UART0 */
  UART0->C2 &= ~UART0_C2_T_R;
  /* Set UART0 interrupt priority */
  NVIC->IP[UART0_IPR_REGISTER] |= NVIC_IPR_UART0_MASK;
  /* Clear any pending UART0 interrupts */
  NVIC->ICPR[0] = NVIC_ICPR_UART0_MASK;
  /* Unmask UART0 interrupts */
  NVIC->ISER[0] = NVIC_ISER_UART0_MASK;
  /* Set for 9600 baud from 96MHz PLL clock */
  UART0->BDH = UART0_BDH_9600;
  UART0->BDL = UART0_BDL_9600;
  UART0->C1 = UART0_C1_8N1;
  UART0->C3 = UART0_C3_NO_TXINV;
  UART0->C4 = UART0_C4_NO_MATCH_OSR_16;
  UART0->C5 = UART0_C5_NO_DMA_SSR_SYNC;
  UART0->S1 = UART0_S1_CLEAR_FLAGS;
  UART0->S2 = UART0_S2_NO_RXINV_BRK10_NO_LBKDETECT_CLEAR_FLAGS;
  UART0->C2 = UART0_C2_T_RI;  /* enable UART0 */
} /* void Init_UART0_IRQ (void) */

void PutChar (char Character) {
/***************************************************************/
/* Puts Character to UART0 via TxQueue.                        */
/* If TxQueue is full, it waits for space in the queue.        */
/* Enqueue is a critical code section shared with UART0_ISR.   */
/***************************************************************/
  /* PutCharQueue (Character, &TxQueue); */

  int Failure = TRUE;

  do {
    __asm("CPSID   I");  /* mask interrupts */
    Failure = Enqueue (Character, &TxQueue);
    __asm("CPSIE   I");  /* unmask interrupts */
  } while (Failure);
  UART0->C2 = UART0_C2_TI_RI; /* enable TxIRQ */
} /* void PutChar (char Character) */

void PutCharQueue (char Character, qRecord *TxQueue) {
/***************************************************************/
/* Puts Character to UART0 via TxQueue.                        */
/* If TxQueue is full, it waits for space in the queue.        */
/* Enqueue is a critical code section shared with UART0_ISR.   */
/***************************************************************/
  int Failure = TRUE;

  do {
    __asm("CPSID   I");  /* mask interrupts */
    Failure = Enqueue (Character, TxQueue);
    __asm("CPSIE   I");  /* unmask interrupts */
  } while (Failure);
  UART0->C2 = UART0_C2_TI_RI; /* enable TxIRQ */
} /* void PutCharQueue (char Character, qRecord *TxQueue) */

void PutFlush (void) {
/***************************************************************/
/* Waits for TxQueue to empty.                                 */
/***************************************************************/
  while (TxQueue.NumberEnqueued);
} /* void PutFlush (void) */

void UART0_IRQHandler (void) {
/***************************************************************/
/* UART0 Interrupt Service Routine                             */
/* Handles RxIRQ (RDRF) and TxIRQ (TDRE).                      */
/* If TxIRQ but TxQueue is empty, TxIRQ is disabled.           */
/* If TxQueue is full, it waits for space in the queue.        */
/* Enqueue is a critical code section shared with UART0_ISR.   */
/***************************************************************/

  __asm("CPSID   I");  /* mask interrupts */
  if (UART0->C2 & UART0_C2_TIE_MASK) {
    if (UART0->S1 & UART0_S1_TDRE_MASK) {
      if (Dequeue ((char *) &(UART0->D), &TxQueue)) {
        /* Nothing to transmit--disable TxIRQ */
        UART0->C2 = UART0_C2_T_RI;
      }
    }
  }
  if (UART0->S1 & UART0_S1_RDRF_MASK) {
    Enqueue (UART0->D, &RxQueue);
  }
  __asm("CPSIE   I");  /* unmask interrupts */
} /* void UART0_IRQHandler (void) */
