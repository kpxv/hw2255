/***************************************************************/
/* Program tests UART0 serial I/O driver using a previously    */
/* written program to test circular FIFO queue operation.      */
/*                                                             */
/* Program prompts user to enter a queue operation command.    */
/* D,d  dequeue a character                                    */
/* E,e  enqueue a character                                    */
/* H,h  help--list supported commands                          */
/* P,p  print the contents of the queue buffer                 */
/* S,s  status:  number enqueued, in pointer, and out pointer  */
/* Invalid commands are ignored.                               */
/* Tests: InitQueue, Dequeue, Enqueue,                         */
/*        PutNumHex, and PutNumUB                              */
/* Uses:  DIVU from Lab Exercise Four                          */
/*        GetChar and PutChar from Lab Exercise Five           */
/*        GetStringSB and PutStringSB from Lab Exercise Six    */
/*        PutNumU from Lab Exercise Six                        */
/* Name:  R. W. Melton                                         */
/* Date:  March 24, 2025                                       */
/* Class:  CMPE-250                                            */
/* Section:  All sections                                      */
/***************************************************************/
#include "Queue_Circular_FIFO.h"
#include "UART0_IRQ.h"
#include "Custom_IO.h"

/* Boolean values */
#define FALSE (0)
#define TRUE (1)

/* Convert lower-case character to upper-case character */
#define LOWER2UPPER(CHARACTER) \
  (((CHARACTER >= 'a') && (CHARACTER <= 'z')) ? \
    (CHARACTER - 'a' + 'A') : CHARACTER)

/* Convert upper-case character to lower-case character */
#define UPPER2LOWER(CHARACTER) \
  (((CHARACTER >= 'A') && (CHARACTER <= 'Z')) ? \
    (CHARACTER - 'A' + 'a') : CHARACTER)

/* Queue delimiters for printed output */
#define Q_BEGIN_CH  ('>')
#define Q_END_CH  ('<')
/* Queue Paramaters */
#define Q_BUF_SZ (4)

/* static constants */
const static char DequeueString[] = ":      ";
const static char EnqueueString[] = "Character to enqueue:";
const static char FailureString[] = "Failure:";
const static char HelpString[] = 
  "D (dequeue), E (enqueue), H (help), P (print), S (status)";
const static char InPtrString[] = "  In=0x";
const static char NewLineString[] = "\r\n";
const static char NumEnqdString[] = "  Num=";
const static char OutPtrString[] = "  Out=0x";
const static char PromptString[] = "Type a queue command (D,E,H,P,S):";
const static char StatusString[] = " Status:";
const static char SuccessString[] = "Success:";

/* static variables */
char QBuffer [Q_BUF_SZ];
qRecord QRecord;

/* Print queue status */
void PutStatus (qRecord *QRecord) {
/***************************************************************/
/* Prints current status of queue:                             */
/*   InPointer, OutPointer, and NumberEnqueued                 */  
/***************************************************************/
  PutStringSB ((char *) InPtrString, sizeof (InPtrString));
  PutNumHex ((unsigned int) QRecord->InPointer);
  PutStringSB ((char *) OutPtrString, sizeof (OutPtrString));
  PutNumHex ((unsigned int) QRecord->OutPointer);
  PutStringSB ((char *) NumEnqdString, sizeof (NumEnqdString));
  PutNumUB ((unsigned char) QRecord->NumberEnqueued);
  PutStringSB ((char *) NewLineString, sizeof (NewLineString));
} /* PutStatus () */

int main (void) {
  char Character,
       Command;
  char WaitForValidCommand;
  char *QBufferPtr;

  Init_UART0_IRQ ();
  Init_Queue (QBuffer, &QRecord, Q_BUF_SZ);

  do { /* while (TRUE) */
    /* Get character command */
    PutStringSB ((char *)PromptString, sizeof (PromptString));
    WaitForValidCommand = TRUE;
    do { /* while (WaitForValidCommand) */
      Command = GetChar ();
      switch (LOWER2UPPER(Command)) {
        case 'D' : {
          WaitForValidCommand = FALSE;
          PutChar (Command);
          PutStringSB ((char *) NewLineString, sizeof (NewLineString));
          if (Dequeue (&Character, &QRecord)) {
            /* dequeue fail */
            PutStringSB ((char *) FailureString, sizeof (FailureString));
          } /*dequeue fail */
          else { /* dequeue success */
            PutChar (Character);
            PutStringSB ((char *) DequeueString, sizeof (DequeueString));
          } /* dequeue success */
          PutStatus (&QRecord);
          break;
        } /* case 'd' */
        case 'E' : {
          WaitForValidCommand = FALSE;
          PutChar (Command);
          PutStringSB ((char *) NewLineString, sizeof (NewLineString));
          PutStringSB ((char *) EnqueueString, sizeof (EnqueueString));
          PutChar (Character = GetChar ());
          PutStringSB ((char *) NewLineString, sizeof (NewLineString));
          if (Enqueue (Character, &QRecord)) {
            /* enqueue fail */
            PutStringSB ((char *) FailureString, sizeof (FailureString));
          } /*enqueue fail */
          else { /* enqueue success */
            PutStringSB ((char *) SuccessString, sizeof (SuccessString));
          } /* enqueue success */
          PutStatus (&QRecord); 
          break;
        } /* case 'e' */
        case 'H' : {
          WaitForValidCommand = FALSE;
          PutChar (Command);
          PutStringSB ((char *) NewLineString, sizeof (NewLineString));
          PutStringSB ((char *) HelpString, sizeof (HelpString));
          PutStringSB ((char *) NewLineString, sizeof (NewLineString));
          break;
        } /* case 'h' */
        case 'P' : {
          WaitForValidCommand = FALSE;
          PutChar (Command);
          PutStringSB ((char *) NewLineString, sizeof (NewLineString));
          PutChar (Q_BEGIN_CH);
          QBufferPtr = QRecord.OutPointer;
          Command = QRecord.NumberEnqueued;
          while (Command-- > (char) 0) {
            /* print next queue character */
            PutChar (*QBufferPtr++);
            if (QBufferPtr >= QRecord.BufferPast) {
              /* circle to beginning of queue buffer */
              QBufferPtr = QRecord.BufferStart;
            } /* if (QBufferPtr) */
          } /* while (Command) */
          PutChar (Q_END_CH);
          PutStringSB ((char *) NewLineString, sizeof (NewLineString));
          break;
        } /* case 'p' */
        case 'S' : {
          WaitForValidCommand = FALSE;
          PutChar (Command);
          PutStringSB ((char *) NewLineString, sizeof (NewLineString));
          PutStringSB ((char *) StatusString, sizeof (StatusString));
          PutStatus (&QRecord);
          break;
        } /* case 's' */
      } /* switch (LOWER2UPPER(Command)) */
    } while (WaitForValidCommand);
  } while (TRUE);
} /* main () */
