/***************************************************************/
/* Module of functions to support PIT timing with interrupts   */
/* every 0.01 s                                                */
/* R. W. Melton                                                */
/* 10/17/2023                                                  */
/*-------------------------------------------------------------*/
/* Revision history:                                           */
/* 10/17/2023 Added check for MKL05Z4.h include (header)       */
/* 3/24/2021  Added module #define (header)                    */
/* 10/30/2020 Adapted to KL05 (header)                         */
/* 11/2/2015 Creation for KL46                                 */
/***************************************************************/

#include "PIT_IRQ.h"

/* PIT Timing Variables */
uint8_t  RunStopWatch;  /* Enable timing */
uint32_t Count;         /* PIT IRQ count */


void Init_PIT_IRQ (void) {
/***************************************************************/
/* Initializes PIT for interrupt every 0.01 s.                 */
/* Initializes RunStopWatch to 0 to disable timing.            */
/* Initializes Count to 0 for number of PIT IRQs counted.      */
/***************************************************************/
  /* Initialize PIT timing variables */
  RunStopWatch = (uint8_t) 0u; /* disable timing measurement */
  Count = (uint32_t) 0u; /* No IRQ periods measured */

  /* Enable PIT module clock */
  SIM->SCGC6 |= SIM_SCGC6_PIT_MASK;
  /* Disable PIT Timer 0 */
  PIT->CHANNEL[0].TCTRL &= ~PIT_TCTRL_TEN_MASK;
  /* Set PIT interrupt priority to 0 (highest) */
  NVIC->IP[PIT_IPR_REGISTER] &= NVIC_IPR_PIT_MASK;
  /* Clear any pending PIT interrupts */
  NVIC->ICPR[0] = NVIC_ICPR_PIT_MASK;
  /* Unmask UART0 interrupts */
  NVIC->ISER[0] = NVIC_ISER_PIT_MASK;
  /* Enable PIT timer module */
  /* and set to stop in debug mode */
  PIT->MCR = PIT_MCR_EN_FRZ;
  /* Set PIT Timer 0 period for 0.01 s */
  PIT->CHANNEL[0].LDVAL = PIT_LDVAL_10ms;
  /* Enable PIT Timer 0 and interrupt */
  PIT->CHANNEL[0].TCTRL = PIT_TCTRL_CH_IE;
}

void PIT_IRQHandler (void) {
/***************************************************************/
/* PIT Interrupt Service Routine                               */
/* Handles PIT Timer 0 interrupt.                              */
/* Global variable RunStopWatch is IRQ count (timing) enable.  */
/***************************************************************/

  __asm("CPSID   I");  /* mask interrupts */
  if (RunStopWatch) {
    Count++;
  }
  /* clear PIT timer 0 interrupt flag */
  PIT->CHANNEL[0].TFLG = PIT_TFLG_TIF_MASK;
  __asm("CPSIE   I");  /* unmask interrupts */
}
