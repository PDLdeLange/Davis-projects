/*
 * rtGetNaN.c
 *
 * Real-Time Workshop code generation for Simulink model "model.mdl".
 *
 * Model Version              : 1.180
 * Real-Time Workshop version : 7.4.1  (R2009bSP1)  02-Mar-2010
 * C source code generated on : Mon Jan 31 17:25:48 2011
 *
 * Target selection: rtwin.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: Generic->32-bit x86 compatible
 * Code generation objectives: Unspecified
 * Validation result: Not run
 *
 */

/*
 * Abstract:
 *      Real-Time Workshop function to intialize non-finite, NaN
 */
#include "rtGetNaN.h"
#define NumBitsPerChar                 8

/*
 * Initialize rtNaN needed by the generated code.
 * NaN is initialized as non-signaling. Assumes IEEE.
 */
real_T rtGetNaN(void)
{
  size_t bitsPerReal = sizeof(real_T) * (NumBitsPerChar);
  real_T nan = 0.0;
  if (bitsPerReal == 32) {
    nan = rtGetNaNF();
  } else {
    uint16_T one = 1;
    enum {
      LittleEndian,
      BigEndian
    } machByteOrder = (*((uint8_T *) &one) == 1) ? LittleEndian : BigEndian;
    switch (machByteOrder) {
     case LittleEndian:
      {
        typedef struct {
          struct {
            uint32_T wordL;
            uint32_T wordH;
          } words;
        } LittleEndianIEEEDouble;

        union {
          LittleEndianIEEEDouble bitVal;
          real_T fltVal;
        } tmpVal;

        tmpVal.bitVal.words.wordH = 0xFFF80000;
        tmpVal.bitVal.words.wordL = 0x00000000;
        nan = tmpVal.fltVal;
        break;
      }

     case BigEndian:
      {
        typedef struct {
          struct {
            uint32_T wordH;
            uint32_T wordL;
          } words;
        } BigEndianIEEEDouble;

        union {
          BigEndianIEEEDouble bitVal;
          real_T fltVal;
        } tmpVal;

        tmpVal.bitVal.words.wordH = 0x7FFFFFFF;
        tmpVal.bitVal.words.wordL = 0xFFFFFFFF;
        nan = tmpVal.fltVal;
        break;
      }
    }
  }

  return nan;
}

/*
 * Initialize rtNaNF needed by the generated code.
 * NaN is initialized as non-signaling. Assumes IEEE.
 */
real32_T rtGetNaNF(void)
{
  typedef struct {
    union {
      real32_T wordLreal;
      uint32_T wordLuint;
    } wordL;
  } IEEESingle;

  IEEESingle nanF;
  uint16_T one = 1;
  enum {
    LittleEndian,
    BigEndian
  } machByteOrder = (*((uint8_T *) &one) == 1) ? LittleEndian : BigEndian;
  switch (machByteOrder) {
   case LittleEndian:
    {
      nanF.wordL.wordLuint = 0xFFC00000;
      break;
    }

   case BigEndian:
    {
      nanF.wordL.wordLuint = 0x7FFFFFFF;
      break;
    }
  }

  return nanF.wordL.wordLreal;
}

/* end rt_getNaN.c */
