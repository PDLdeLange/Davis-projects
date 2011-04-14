/*
 * rt_pow_snf.c
 *
 * Embedded MATLAB Coder code generation for M-function 'odefun_nonlinear'
 *
 * C source code generated on: Mon Jan 31 17:02:31 2011
 *
 */

#include "rt_pow_snf.h"
#include <math.h>
#include "rt_nonfinite.h"

#ifndef RT_PI
  #define RT_PI 3.14159265358979323846
#endif

/* Function: rt_pow =======================================================
 * Abstract:
 *   Calls double-precision version of POW, with guard against domain error
 *   and guards against non-finites
 */
real_T rt_pow_snf(const real_T xr, const real_T yr) 
{
  real_T axr, ayr;
  if (rtIsNaN(xr) || rtIsNaN(yr) ) {
    return( rtNaN );
  }

  axr = fabs(xr);
  if (rtIsInf(yr)) {
    if (axr == 1.0) {
      return( rtNaN );
    } else if (axr > 1.0) {
      return( ( yr > 0.0 ) ? rtInf : 0.0);
    } else {
      return( ( yr > 0.0 ) ? 0.0 : rtInf );
    }
  }

  ayr = fabs(yr);
  if (ayr == 0.0) {
    return( 1.0 );
  } else if (ayr == 1.0) {
    return( ( yr > 0.0 ) ? xr : 1.0/xr );
  } else if (yr == 2.0) {
    return( xr * xr);
  } else if (yr == 0.5 && xr >= 0.0) {
    return( sqrt(xr) );
  } else if ((xr < 0.0) && (yr > floor(yr)) ) {
    return( rtNaN );
  }

  return( pow(xr,yr) );

} /* end rt_pow_snf */
/* End of Embedded MATLAB Coder code generation (rt_pow_snf.c) */
