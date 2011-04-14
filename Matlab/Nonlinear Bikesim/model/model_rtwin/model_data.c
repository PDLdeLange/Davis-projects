/*
 * model_data.c
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

#include "model.h"
#include "model_private.h"

/* Block parameters (auto storage) */
Parameters_model model_P = {
  0.0,                                 /* Expression: 0
                                        * Referenced by: '<S2>/Rightpaddle'
                                        */
  100.0,                               /* Expression: 100
                                        * Referenced by: '<S2>/u3'
                                        */

  /*  Expression: NaN+zeros(1,outwidth)
   * Referenced by: '<S9>/Constant'
   */
  { 0.0, 0.0, 0.0, 0.0 },

  /*  Expression: [0;0;1];
   * Referenced by: '<S3>/v_phi'
   */
  { 0.0, 0.0, 1.0 },

  /*  Expression: NaN+zeros(1,outwidth)
   * Referenced by: '<S11>/Constant'
   */
  { 0.0, 0.0, 0.0, 0.0 },

  /*  Expression: [0;sin(atan(3));cos(atan(3));];
   * Referenced by: '<S3>/v_delta'
   */
  { 0.0, 9.4868329805051377E-001, 3.1622776601683794E-001 },

  /*  Expression: NaN+zeros(1,outwidth)
   * Referenced by: '<S13>/Constant'
   */
  { 0.0, 0.0, 0.0, 0.0 },

  /*  Expression: [1;0;0];
   * Referenced by: '<S3>/v_Phi1'
   */
  { 1.0, 0.0, 0.0 },
  0.0,                                 /* Expression: 0
                                        * Referenced by: '<S1>/Integrator'
                                        */

  /*  Expression: NaN+zeros(1,outwidth)
   * Referenced by: '<S12>/Constant'
   */
  { 0.0, 0.0, 0.0, 0.0 },

  /*  Expression: [0;-1;0];
   * Referenced by: '<S3>/v_Psi'
   */
  { 0.0, -1.0, 0.0 },

  /*  Expression: NaN+zeros(1,outwidth)
   * Referenced by: '<S10>/Constant'
   */
  { 0.0, 0.0, 0.0 },
  39.37,                               /* Expression: 39.37
                                        * Referenced by: '<S3>/Gain1'
                                        */
  -3.3333333333333335E+000,            /* Expression: -1/0.3
                                        * Referenced by: '<S1>/Gain'
                                        */
  0,                                   /* Expression: Channels
                                        * Referenced by: '<S2>/Leftpaddle'
                                        */
  0,                                   /* Expression: RangeMode
                                        * Referenced by: '<S2>/Leftpaddle'
                                        */
  0,                                   /* Expression: VoltRange
                                        * Referenced by: '<S2>/Leftpaddle'
                                        */
  2,                                   /* Expression: Channels
                                        * Referenced by: '<S2>/Pedal'
                                        */
  0,                                   /* Expression: RangeMode
                                        * Referenced by: '<S2>/Pedal'
                                        */
  0,                                   /* Expression: VoltRange
                                        * Referenced by: '<S2>/Pedal'
                                        */
  6,                                   /* Expression: Channels
                                        * Referenced by: '<S2>/Backbutton'
                                        */
  0                                    /* Expression: BitMode
                                        * Referenced by: '<S2>/Backbutton'
                                        */
};
