/***************************************************************/
/* Definitions for module to support I/O based on UART         */
/* character I/O.                                              */
/* R. W. Melton                                                */
/* 9/23/2023                                                   */
/*-------------------------------------------------------------*/
/* Revision history:                                           */
/* 9/22/2023 Added check for MKL05Z4.h include                 */
/*           Added module #define;                             */
/*           Added check for UART0_Polling.h include           */
/* 9/21/2020 Creation                                          */
/***************************************************************/

#define Custom_IO (1)

#ifndef MKL05Z4_H_
  #include <MKL05Z4.h>
#endif

#ifndef UART0_IRQ
  #include "UART0_IRQ.h"
#endif

/* Provided by this module */
uint32_t GetStringSB (char *String, uint32_t Capacity);
uint32_t LengthStringSB (char *String, uint32_t Capacity);
void PutNumHex (uint32_t Number);
void PutNumHexB (uint8_t NumberB);
void PutNumU (uint32_t Number);
void PutNumUB (uint8_t NumberB);
void PutStringSB (char *String, uint32_t Capacity);
