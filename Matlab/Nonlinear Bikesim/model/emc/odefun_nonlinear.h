/*
 * odefun_nonlinear.h
 *
 * Embedded MATLAB Coder code generation for M-function 'odefun_nonlinear'
 *
 * C source code generated on: Mon Jan 31 17:02:31 2011
 *
 */

#ifndef __ODEFUN_NONLINEAR_H__
#define __ODEFUN_NONLINEAR_H__
/* Include files */
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include "rt_pow_snf.h"

#include "rtwtypes.h"
#include "odefun_nonlinear_types.h"

/* Type Definitions */

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */
extern void odefun_nonlinear(const real_T eml_x[11], const real_T eml_u[3], real_T eml_dxdt[11]);
extern void odefun_nonlinear_initialize(void);
extern void odefun_nonlinear_terminate(void);
#endif
/* End of Embedded MATLAB Coder code generation (odefun_nonlinear.h) */
