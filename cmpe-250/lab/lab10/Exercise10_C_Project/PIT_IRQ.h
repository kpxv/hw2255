/***************************************************************/
/* Definitions for module to support PIT timing with           */
/* interrupts.                                                 */
/* R. W. Melton                                                */
/* 10/17/2023                                                  */
/*-------------------------------------------------------------*/
/* Revision history:                                           */
/* 10/17/2023 Added check for MKL05Z4.h include                */
/* 3/24/2021  Added module #define                             */
/* 10/30/2020 Adapted to KL05                                  */
/* 11/2/2015  Creation for KL46                                */
/***************************************************************/

#define PIT_IRQ (1)

#if !defined(MKL05Z4_H_)
#include <MKL05Z4.h>
#endif

/*------------------------------------------------------------*/
/* NVIC                                                       */
/*------------------------------------------------------------*/
#define PIT_IRQ_NUMBER (22)
/*------------------------------------------------------------*/
/* NVIC_ICPR                                                  */
/* 31-00:CLRPEND=pending status for HW IRQ sources;           */
/*              read:   0 = not pending;  1 = pending         */
/*              write:  0 = no effect;                        */
/*                      1 = change status to not pending      */
/* 22:PIT IRQ pending status                                  */
/*------------------------------------------------------------*/
#define NVIC_ICPR_PIT_MASK (1 << PIT_IRQ_NUMBER)
/*------------------------------------------------------------*/
/* NVIC_IPR0-NVIC_IPR7                                        */
/* 2-bit priority:  0 = highest; 3 = lowest                   */
/*------------------------------------------------------------*/
#define PIT_IRQ_PRIORITY (0)
#define PIT_IPR_REGISTER (PIT_IRQ_NUMBER >> 2)
#define NVIC_IPR_PIT_MASK \
                      (3 << (((PIT_IRQ_NUMBER & 3) << 3) + 6))
/*------------------------------------------------------------*/
/* NVIC_ISER                                                  */
/* 31-00:SETENA=masks for HW IRQ sources;                     */
/*              read:   0 = masked;     1 = unmasked          */
/*              write:  0 = no effect;  1 = unmask            */
/* 22:PIT IRQ mask                                            */
/*------------------------------------------------------------*/
#define NVIC_ISER_PIT_MASK (1 << PIT_IRQ_NUMBER)
/*------------------------------------------------------------*/
/* PIT_LDVALn                                                 */
/* Clock ticks for 0.01 s = 10 ms at 24 MHz PIT clock rate    */
/* 0.01 s * 24,000,000 Hz = 240,000                           */
/* TSV = 240,000 - 1 = 239,999                                */
/* Clock ticks for 0.01 s at 23,986,176 Hz count rate         */
/* 0.01 s * 23,986,176 Hz = 239,862                           */
/* TSV = 239,862 - 1 = 239,861                                */
/*------------------------------------------------------------*/
/* #define PIT_LDVAL_10ms  (239999u)  //approximate */
#define PIT_LDVAL_10ms  (239861u)
/*------------------------------------------------------------*/
/* PIT_MCR:  PIT module control register                      */
/* 1-->    0:FRZ=freeze (continue'/stop in debug mode)        */
/* 0-->    1:MDIS=module disable (PIT section)                */
/*                RTI timer not affected                      */
/*                must be enabled before any other PIT setup  */
/*------------------------------------------------------------*/
#define PIT_MCR_EN_FRZ  (PIT_MCR_FRZ_MASK)
/*------------------------------------------------------------*/
/* PIT_TCTRL:  timer control register                         */
/* 0-->   2:CHN=chain mode (enable)                           */
/* 1-->   1:TIE=timer interrupt enable                        */
/* 1-->   0:TEN=timer enable                                  */
/*------------------------------------------------------------*/
#define PIT_TCTRL_CH_IE  \
                       (PIT_TCTRL_TEN_MASK | PIT_TCTRL_TIE_MASK)
                       
extern unsigned char RunStopWatch;  /* Enable timing */
extern unsigned int Count;          /* PIT IRQ count */

void Init_PIT_IRQ (void);
void PIT_IRQHandler (void);
