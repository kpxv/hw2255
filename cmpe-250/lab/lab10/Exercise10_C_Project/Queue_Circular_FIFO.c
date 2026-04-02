/***************************************************************/
/* Module of functions to support circular FIFO queue          */
/* R. W. Melton                                                */
/* 6/15/2015                                                   */
/***************************************************************/

#include "Queue_Circular_FIFO.h"

#define FALSE (0)
#define TRUE (1)

int Dequeue (char *Character, qRecord *Queue) {
/***************************************************************/
/* Dequeues Character from queue if queue is not empty.        */
/* If queue is empty, Character is not changed.                */
/* Returns:  1 if failure; 0 otherwise                         */
/***************************************************************/
  int Failure = TRUE;

  if (Queue->NumberEnqueued) {
    *Character = *(Queue->OutPointer++);
    (Queue->NumberEnqueued)--;
    if (Queue->OutPointer >= Queue->BufferPast) {
     Queue->OutPointer = Queue->BufferStart;
    }
    Failure = FALSE;
  }
  return (Failure);
}

int Enqueue (char Character, qRecord *Queue) {
/***************************************************************/
/* Enqueues Character to queue if queue is not full.           */
/* Returns:  1 if failure; 0 otherwise                         */
/***************************************************************/
  int Failure = TRUE;

  if (Queue->NumberEnqueued < Queue->BufferSize) {
    *(Queue->InPointer++) = Character;
    (Queue->NumberEnqueued)++;
    if (Queue->InPointer >= Queue->BufferPast) {
      Queue->InPointer = Queue->BufferStart;
    }
    Failure = FALSE;
  }
  return (Failure);
}

void Init_Queue (char *QBuffer, qRecord *Queue, char Capacity) {
/***************************************************************/
/* Initializes Queue for empty QBuffer of specified Capacity.  */
/***************************************************************/
  Queue->BufferStart = QBuffer;
  Queue->InPointer = QBuffer;
  Queue->OutPointer = QBuffer;
  Queue->BufferPast = QBuffer + Capacity;
  Queue->BufferSize = Capacity;
  Queue->NumberEnqueued = 0;
}
