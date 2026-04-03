/***************************************************************/
/* Definitions for module to support circular FIFO queue       */
/* R. W. Melton                                                */
/* 10/16/2020                                                  */
/*-------------------------------------------------------------*/
/* Revision history:                                           */
/* 10/16/2020 Added module #define                             */
/* 6/15/2015 Creation                                          */
/***************************************************************/

#define CIRCULAR_FIFO_QUEUE (1)

/* Circular FIFO Queue type*/
typedef struct {
  char *InPointer;
  char *OutPointer;
  char *BufferStart;
  char *BufferPast;
  char BufferSize;
  char NumberEnqueued;
} qRecord;

int Dequeue (char *Character, qRecord *Queue);
int Enqueue (char Character, qRecord *Queue);
void Init_Queue (char *QBuffer, qRecord *Queue, char Capacity);
