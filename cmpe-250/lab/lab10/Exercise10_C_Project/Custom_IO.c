/***************************************************************/
/* Definitions for module to support I/O based on UART         */
/* character I/O.                                              */
/* R. W. Melton                                                */
/* 10/3/2022                                                   */
/***************************************************************/

#include "Custom_IO.h"

/* Boolean values */
#define FALSE (0)
#define TRUE (1)

/* Output characteristics */
#define MAX_WORD_DECIMAL_DIGITS (10)

/* Convert binary value of nibble to ASCII character */
#define HEXN2ASCII(NIBBLE) ((NIBBLE) < 10 ? ((NIBBLE) + '0') : \
                                            ((NIBBLE) - 10 + 'A'))

uint32_t GetStringSB (char *String, uint32_t Capacity) {
/***************************************************************/
/* Fills String with input from UART until carriage return     */
/* encountered, (which is not stored in String), and then adds */
/* null termination.  Any characters after the first           */
/* Capacity - 1 are accepted but not stored.  All stored       */
/* characters are also output to UART.                         */
/* Returns the number of characters stored in the string,      */
/* not including the NULL character.                           */
/* Uses:  GetChar (from a separate UART module)                */
/*        PutChar (from a separate UART module)                */
/*        PutStringSB                                          */
/***************************************************************/
  char Character;
  unsigned int  CharacterCapacity = Capacity - 1;

  if (Capacity--) {
    /* Room in string */
    while ((Character = GetChar ()) != '\r') {
      if (Capacity && (Character >= ' ') && (Character < 0x7F)) {
        /* Standard ASCII character code with room in string*/
        PutChar (Character);
        *(String++) = Character;
        Capacity--;
      } /* if Standard ASCII character code with room in string */
      else if (Character == '\b') {
        if (CharacterCapacity - Capacity) {
          /* String has a previous character to remove */
          PutStringSB ("\b \b", 4); /* blank on terminal */
          String--;
          Capacity++;
        }
        /* else ignore backspace since no previous character */
      } /* else if ('\b') */
      else if (Character == '\x1B') {
        /* Escape character may start escape sequence */
        if (GetChar () == '[') {
          /* Escape sequence has begun */
          /* Consume characters until tilde (end of escape sequence) */
          while (GetChar () != '~');
        } /* if ('[') */
      } /* else if ('\x1B') */
      /* else ignore ASCII control code */
    } /* while (NotFinished) */
    *String = '\0';
  } /* if (Capacity) */
  else { /* no bytes allocated for string */
    /* Consume characters until carriage return */
    while (GetChar () != '\r');
  } /* else */
  PutStringSB ("\r\n", 3);
  return (CharacterCapacity - Capacity);
} /* GetStringSB */

uint32_t LengthStringSB (char *String, uint32_t Capacity) {
/***************************************************************/
/* Determines length of null-terminated String.                */
/***************************************************************/
  uint32_t Length = 0;

  while (Length < Capacity) {
    /* Unread string buffer */
    if (String[Length]){
      /* NULL not encountered */
      Length++;
    } /* if (not NULL) */
    else {
      /* NULL encountered; force while loop exit */
      Capacity = Length;
    } /* else (NULL) */
  } /* while (Length < Capacity) */
  return (Length);
} /* LengthStringSB */

void PutNumHex (uint32_t Number) {
/***************************************************************/
/* Prints hex representation of unsigned word (32-bit) number. */
/* Uses PutNumHexB                                             */
/***************************************************************/
  unsigned int ShiftAmount;
  
  for (ShiftAmount = 28; ShiftAmount > 0; ShiftAmount -= 4) {
    PutChar ((char) HEXN2ASCII((Number >> ShiftAmount) & 0x0F));
  }
  PutChar ((char) HEXN2ASCII(Number & 0x0F));
} /* PutNumHex */

void PutNumHexB (uint8_t Byte) {
/***************************************************************/
/* Prints hex representation of unsigned byte number.          */
/* Uses:  HEXN2ASCII                                           */
/*        PutChar                                              */
/***************************************************************/
  PutChar (HEXN2ASCII((char) (Byte >> 4)));
  PutChar (HEXN2ASCII((char) (Byte & 0x0F)));
}

void PutNumU (uint32_t Number) {
/***************************************************************/
/* Prints text representation of unsigned word (32-bit) in a   */
/* minimum number of characters.                               */
/* number.                                                     */
/* Uses:  PutString                                            */
/***************************************************************/
  /* String for number digits up to 4 billion */
  char String[MAX_WORD_DECIMAL_DIGITS + 1];
  char *StringPtr;

  StringPtr = &(String[MAX_WORD_DECIMAL_DIGITS]);
  *StringPtr = 0;
  
  do {
    /* next least significant digit is remainder of division by 10 */
    *(--StringPtr) = ((char) (Number % 10u)) + '0';
    /* rest of number to print */
    Number /= 10u; 
  } while (Number > 0);
  /* print text digits of number */
  PutStringSB (StringPtr, (MAX_WORD_DECIMAL_DIGITS + 1));
} /* PutNumU */

void PutNumUB (uint8_t NumberB) {
/***************************************************************/
/* Prints text representation of unsigned byte (8-bit) number. */
/* Uses:  PutString                                            */
/***************************************************************/
  PutNumU ((uint32_t) NumberB);
}

void PutStringSB (char *String, uint32_t Capacity) {
/***************************************************************/
/* Puts null-terminated String to screen.                      */
/***************************************************************/
  char Character;
  
  while (Capacity--) {
    /* Unread string buffer */
    if (Character = *(String++)) {
      /* Character read was not NULL */
      PutChar (Character);
    } /* if (Character not NULL) */
    else {
      /* No more characters to output */
      Capacity = 0;
    } /* else (NULL found) */
  } /* while (Capacity) */
} /* PutStringSB */
