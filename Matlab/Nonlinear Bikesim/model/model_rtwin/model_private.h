/*
 * model_private.h
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
 */
#ifndef RTW_HEADER_model_private_h_
#define RTW_HEADER_model_private_h_
#include "rtwtypes.h"
#ifndef __RTWTYPES_H__
#error This file requires rtwtypes.h to be included
#else
#ifdef TMWTYPES_PREVIOUSLY_INCLUDED
#error This file requires rtwtypes.h to be included before tmwtypes.h
#else

/* Check for inclusion of an incorrect version of rtwtypes.h */
#ifndef RTWTYPES_ID_C08S16I32L32N32F1
#error This code was generated with a different "rtwtypes.h" than the file included
#endif                                 /* RTWTYPES_ID_C08S16I32L32N32F1 */
#endif                                 /* TMWTYPES_PREVIOUSLY_INCLUDED */
#endif                                 /* __RTWTYPES_H__ */

/*
 * UNUSED_PARAMETER(x)
 *   Used to specify that a function parameter (argument) is required but not
 *   accessed by the function body.
 */
#ifndef UNUSED_PARAMETER
# if defined(__LCC__)
#   define UNUSED_PARAMETER(x)                                   /* do nothing */
# else

/*
 * This is the semi-ANSI standard way of indicating that an
 * unused function parameter is required.
 */
#   define UNUSED_PARAMETER(x)         (void) (x)
# endif
#endif

extern void bike_Outputs_wrapper(const real_T *u,
  real_T *z,
  real_T *xy,
  real_T *psi,
  real_T *v,
  const real_T *xC);
extern void bike_Derivatives_wrapper(const real_T *u,
  const real_T *z,
  const real_T *xy,
  const real_T *psi,
  const real_T *v,
  real_T *dx,
  real_T *xC);

/* private model entry point functions */
extern void model_derivatives(void);

#endif                                 /* RTW_HEADER_model_private_h_ */
