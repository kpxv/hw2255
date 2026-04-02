/***************************************************************/
/* Program implements a timer driver to time user input.       */
/* It prompts the user for three strings, and times the input. */
/*   "Enter your name."                                        */
/*   "Enter the date."                                         */
/*   "Enter the last name of a 250 lab TA."                    */
/* Timer interaction is via interrupts.                        */
/* All I/O is via UART0 interrupts.                            */
/* Tests: Init_PIT_IRQ subroutine                              */
/*        PIT_ISR                                              */
/* Uses:  DIVU from Lab Exercise Four                          */
/*        GetStringSB and PutStringSB from Lab Exercise Six    */
/*        PutNumU from Lab Exercise Six                        */
/*        Dequeue, Enqueue, and InitQueue                      */
/*             from Lab Exercise Seven                         */
/*        GetChar, Init_UART0_IRQ, UART0_ISR, and PutChar      */
/*             from Lab Exercise Nine                          */
/* Name:  R. W. Melton                                         */
/* Date:  March 31, 2025                                       */
/* Class:  CMPE-250                                            */
/* Section:  All sections                                      */
/***************************************************************/
#include <MKL05Z4.h>
#include "Queue_Circular_FIFO.h"
#include "UART0_IRQ.h"
#include "PIT_IRQ.h"
#include "Custom_IO.h"

/* Boolean values */
#define FALSE (0)
#define TRUE (1)

/* Pointer values */
#define NULL (0)

/* Strings */
#define MAX_STRING (79)

/* Convert lower-case character to upper-case character */
#define LOWER2UPPER(CHARACTER) \
  (((CHARACTER >= 'a') && (CHARACTER <= 'z')) ? \
    (CHARACTER - 'a' + 'A') : CHARACTER)

/* Convert upper-case character to lower-case character */
#define UPPER2LOWER(CHARACTER) \
  (((CHARACTER >= 'A') && (CHARACTER <= 'Z')) ? \
    (CHARACTER - 'A' + 'a') : CHARACTER)

/* static constants */
const static char nameString[] = "Enter your name.";
const static char dateString[] = "Enter the date.";
const static char finishString[] = "Thank you.  Goodbye!\r\n";
const static char promptString[] = "\r\n>";
const static char TAString[] = "Enter the last name of a 250 lab TA.";
const static char timeString[] = " x 0.01 s\r\n";
const static char* prompts[] = {nameString, 
                                dateString, 
                                TAString, 
                                (char *) NULL};
const static int promptSizes[] = {sizeof(nameString), 
                                  sizeof(dateString), 
                                  sizeof(TAString), 
                                  (int) NULL};

/* global variables */
static char StringBuffer[MAX_STRING];

int main (void) {
  char **PromptsPtr = (char **) prompts;
  int  *PromptSizesPtr = (int *) promptSizes;

  __ASM ("CPSID I");  /* Mask all KL05 IRQs */
  Init_UART0_IRQ ();
  RunStopWatch = FALSE;
  Count =0;
  Init_PIT_IRQ ();
  __ASM ("CPSIE I");  /* Unmask all KL05 IRQs */
  /* Output starting instructions */
  while (*PromptsPtr != NULL) { /* Another prompt to input */
    /* Output prompt */
    PutStringSB ((char *) *(PromptsPtr++), *(PromptSizesPtr++));
    PutStringSB ((char *) promptString, sizeof(promptString));
    /* Get and time user input */
    RunStopWatch = TRUE;
    GetStringSB ((char *) StringBuffer, sizeof(StringBuffer));
    RunStopWatch = FALSE;
    /* Report time */
    PutChar ('<');
    PutNumU (Count);
    PutStringSB ((char *) timeString, sizeof(timeString));
    Count =0;
  } /* while */
  /* final output */
  PutStringSB ((char *) finishString, sizeof(finishString));
  /* wait for TxQ to drain */
  PutFlush ();
  /* stay here forever */
  while (TRUE);
} /* main () */
