/*
 * model.c
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
#include <stdio.h>
#include "model_dt.h"

/* list of Real-Time Windows Target boards */
const int RTWinBoardCount = 1;
RTWINBOARD RTWinBoards[1] = {
  { "Standard_Devices/Joystick", 1U, 0, NULL },
};

/* Block signals (auto storage) */
BlockIO_model model_B;

/* Continuous states */
ContinuousStates_model model_X;

/* Block states (auto storage) */
D_Work_model model_DWork;

/* Real-time model */
RT_MODEL_model model_M_;
RT_MODEL_model *model_M = &model_M_;

/*
 * This function updates continuous states using the ODE5 fixed-step
 * solver algorithm
 */
static void rt_ertODEUpdateContinuousStates(RTWSolverInfo *si )
{
  /* Solver Matrices */
  static const real_T rt_ODE5_A[6] = {
    1.0/5.0, 3.0/10.0, 4.0/5.0, 8.0/9.0, 1.0, 1.0
  };

  static const real_T rt_ODE5_B[6][6] = {
    { 1.0/5.0, 0.0, 0.0, 0.0, 0.0, 0.0 },

    { 3.0/40.0, 9.0/40.0, 0.0, 0.0, 0.0, 0.0 },

    { 44.0/45.0, -56.0/15.0, 32.0/9.0, 0.0, 0.0, 0.0 },

    { 19372.0/6561.0, -25360.0/2187.0, 64448.0/6561.0, -212.0/729.0, 0.0, 0.0 },

    { 9017.0/3168.0, -355.0/33.0, 46732.0/5247.0, 49.0/176.0, -5103.0/18656.0,
      0.0 },

    { 35.0/384.0, 0.0, 500.0/1113.0, 125.0/192.0, -2187.0/6784.0, 11.0/84.0 }
  };

  time_T t = rtsiGetT(si);
  time_T tnew = rtsiGetSolverStopTime(si);
  time_T h = rtsiGetStepSize(si);
  real_T *x = rtsiGetContStates(si);
  ODE5_IntgData *id = (ODE5_IntgData *)rtsiGetSolverData(si);
  real_T *y = id->y;
  real_T *f0 = id->f[0];
  real_T *f1 = id->f[1];
  real_T *f2 = id->f[2];
  real_T *f3 = id->f[3];
  real_T *f4 = id->f[4];
  real_T *f5 = id->f[5];
  real_T hB[6];
  int_T i;
  int_T nXc = 12;
  rtsiSetSimTimeStep(si,MINOR_TIME_STEP);

  /* Save the state values at time t in y, we'll use x as ynew. */
  (void) memcpy(y,x,
                nXc*sizeof(real_T));

  /* Assumes that rtsiSetT and ModelOutputs are up-to-date */
  /* f0 = f(t,y) */
  rtsiSetdX(si, f0);
  model_derivatives();

  /* f(:,2) = feval(odefile, t + hA(1), y + f*hB(:,1), args(:)(*)); */
  hB[0] = h * rt_ODE5_B[0][0];
  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (f0[i]*hB[0]);
  }

  rtsiSetT(si, t + h*rt_ODE5_A[0]);
  rtsiSetdX(si, f1);
  model_output(0);
  model_derivatives();

  /* f(:,3) = feval(odefile, t + hA(2), y + f*hB(:,2), args(:)(*)); */
  for (i = 0; i <= 1; i++) {
    hB[i] = h * rt_ODE5_B[1][i];
  }

  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (f0[i]*hB[0] + f1[i]*hB[1]);
  }

  rtsiSetT(si, t + h*rt_ODE5_A[1]);
  rtsiSetdX(si, f2);
  model_output(0);
  model_derivatives();

  /* f(:,4) = feval(odefile, t + hA(3), y + f*hB(:,3), args(:)(*)); */
  for (i = 0; i <= 2; i++) {
    hB[i] = h * rt_ODE5_B[2][i];
  }

  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (f0[i]*hB[0] + f1[i]*hB[1] + f2[i]*hB[2]);
  }

  rtsiSetT(si, t + h*rt_ODE5_A[2]);
  rtsiSetdX(si, f3);
  model_output(0);
  model_derivatives();

  /* f(:,5) = feval(odefile, t + hA(4), y + f*hB(:,4), args(:)(*)); */
  for (i = 0; i <= 3; i++) {
    hB[i] = h * rt_ODE5_B[3][i];
  }

  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (f0[i]*hB[0] + f1[i]*hB[1] + f2[i]*hB[2] +
                   f3[i]*hB[3]);
  }

  rtsiSetT(si, t + h*rt_ODE5_A[3]);
  rtsiSetdX(si, f4);
  model_output(0);
  model_derivatives();

  /* f(:,6) = feval(odefile, t + hA(5), y + f*hB(:,5), args(:)(*)); */
  for (i = 0; i <= 4; i++) {
    hB[i] = h * rt_ODE5_B[4][i];
  }

  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (f0[i]*hB[0] + f1[i]*hB[1] + f2[i]*hB[2] +
                   f3[i]*hB[3] + f4[i]*hB[4]);
  }

  rtsiSetT(si, tnew);
  rtsiSetdX(si, f5);
  model_output(0);
  model_derivatives();

  /* tnew = t + hA(6);
     ynew = y + f*hB(:,6); */
  for (i = 0; i <= 5; i++) {
    hB[i] = h * rt_ODE5_B[5][i];
  }

  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (f0[i]*hB[0] + f1[i]*hB[1] + f2[i]*hB[2] +
                   f3[i]*hB[3] + f4[i]*hB[4] + f5[i]*hB[5]);
  }

  rtsiSetSimTimeStep(si,MAJOR_TIME_STEP);
}

/* Model output function */
void model_output(int_T tid)
{
  /* local block i/o variables */
  real_T rtb_Pedal;
  real_T rtb_Backbutton;
  if (rtmIsMajorTimeStep(model_M)) {
    /* set solver stop time */
    if (!(model_M->Timing.clockTick0+1)) {
      rtsiSetSolverStopTime(&model_M->solverInfo, ((model_M->Timing.clockTickH0
        + 1) * model_M->Timing.stepSize0 * 4294967296.0));
    } else {
      rtsiSetSolverStopTime(&model_M->solverInfo, ((model_M->Timing.clockTick0 +
        1) * model_M->Timing.stepSize0 + model_M->Timing.clockTickH0 *
        model_M->Timing.stepSize0 * 4294967296.0));
    }
  }                                    /* end MajorTimeStep */

  /* Update absolute time of base rate at minor time step */
  if (rtmIsMinorTimeStep(model_M)) {
    model_M->Timing.t[0] = rtsiGetT(&model_M->solverInfo);
  }

  if (rtmIsMajorTimeStep(model_M)) {
    /* S-Function Block: <S2>/Leftpaddle */
    {
      ANALOGIOPARM parm;
      parm.mode = (RANGEMODE) model_P.Leftpaddle_RangeMode;
      parm.rangeidx = model_P.Leftpaddle_VoltRange;
      RTBIO_DriverIO(0, ANALOGINPUT, IOREAD, 1, &model_P.Leftpaddle_Channels,
                     &model_B.Leftpaddle, &parm);
    }

    /* S-Function Block: <S2>/Pedal */
    {
      ANALOGIOPARM parm;
      parm.mode = (RANGEMODE) model_P.Pedal_RangeMode;
      parm.rangeidx = model_P.Pedal_VoltRange;
      RTBIO_DriverIO(0, ANALOGINPUT, IOREAD, 1, &model_P.Pedal_Channels,
                     &rtb_Pedal, &parm);
    }

    /* S-Function Block: <S2>/Backbutton */
    {
      RTBIO_DriverIO(0, DIGITALINPUT, IOREAD, 1, &model_P.Backbutton_Channels,
                     &rtb_Backbutton, &model_P.Backbutton_BitMode);
    }

    /* Constant: '<S2>/Rightpaddle' */
    model_B.Rightpaddle = model_P.Rightpaddle_Value;

    /* Gain: '<S2>/u3' */
    model_B.u3 = model_P.u3_Gain * rtb_Pedal;

    /* Stop: '<S2>/Stop Simulation' */
    if (rtb_Backbutton != 0.0) {
      rtmSetStopRequested(model_M, 1);
    }
  }

  /* SignalConversion: '<S1>/TmpSignal ConversionAtBikeInport1' */
  model_B.TmpSignalConversionAtBikeInport1[0] = model_B.Rightpaddle;
  model_B.TmpSignalConversionAtBikeInport1[1] = model_B.Leftpaddle;
  model_B.TmpSignalConversionAtBikeInport1[2] = model_B.u3;

  /* S-Function (bike): '<S1>/Bike' */
  {
    real_T *pxc = &model_X.Bike_CSTATE[0];
    bike_Outputs_wrapper(model_B.TmpSignalConversionAtBikeInport1,
                         model_B.Bike_o1, model_B.Bike_o2, &model_B.Bike_o3,
                         &model_B.Bike_o4, pxc);
  }

  if (rtmIsMajorTimeStep(model_M)) {
  }

  /* Assignment: '<S4>/Assignment' incorporates:
   *  Constant: '<S3>/v_phi'
   *  Constant: '<S9>/Constant'
   *  SignalConversion: '<S4>/TmpSignal ConversionAtAssignmentInport2'
   */
  model_B.Assignment[0] = model_P.Constant_Value[0];
  model_B.Assignment[1] = model_P.Constant_Value[1];
  model_B.Assignment[2] = model_P.Constant_Value[2];
  model_B.Assignment[3] = model_P.Constant_Value[3];
  model_B.Assignment[0] = model_P.v_phi_Value[0];
  model_B.Assignment[1] = model_P.v_phi_Value[1];
  model_B.Assignment[2] = model_P.v_phi_Value[2];
  model_B.Assignment[3] = model_B.Bike_o1[0];

  /* Assignment: '<S6>/Assignment' incorporates:
   *  Constant: '<S11>/Constant'
   *  Constant: '<S3>/v_delta'
   *  SignalConversion: '<S6>/TmpSignal ConversionAtAssignmentInport2'
   */
  model_B.Assignment_j[0] = model_P.Constant_Value_f[0];
  model_B.Assignment_j[1] = model_P.Constant_Value_f[1];
  model_B.Assignment_j[2] = model_P.Constant_Value_f[2];
  model_B.Assignment_j[3] = model_P.Constant_Value_f[3];
  model_B.Assignment_j[0] = model_P.v_delta_Value[0];
  model_B.Assignment_j[1] = model_P.v_delta_Value[1];
  model_B.Assignment_j[2] = model_P.v_delta_Value[2];
  model_B.Assignment_j[3] = model_B.Bike_o1[1];

  /* Assignment: '<S8>/Assignment' incorporates:
   *  Constant: '<S13>/Constant'
   *  Constant: '<S3>/v_Phi1'
   *  Integrator: '<S1>/Integrator'
   *  SignalConversion: '<S8>/TmpSignal ConversionAtAssignmentInport2'
   */
  model_B.Assignment_l[0] = model_P.Constant_Value_i[0];
  model_B.Assignment_l[1] = model_P.Constant_Value_i[1];
  model_B.Assignment_l[2] = model_P.Constant_Value_i[2];
  model_B.Assignment_l[3] = model_P.Constant_Value_i[3];
  model_B.Assignment_l[0] = model_P.v_Phi1_Value[0];
  model_B.Assignment_l[1] = model_P.v_Phi1_Value[1];
  model_B.Assignment_l[2] = model_P.v_Phi1_Value[2];
  model_B.Assignment_l[3] = model_X.Integrator_CSTATE;

  /* Assignment: '<S7>/Assignment' incorporates:
   *  Constant: '<S12>/Constant'
   *  Constant: '<S3>/v_Psi'
   *  SignalConversion: '<S7>/TmpSignal ConversionAtAssignmentInport2'
   */
  model_B.Assignment_i[0] = model_P.Constant_Value_m[0];
  model_B.Assignment_i[1] = model_P.Constant_Value_m[1];
  model_B.Assignment_i[2] = model_P.Constant_Value_m[2];
  model_B.Assignment_i[3] = model_P.Constant_Value_m[3];
  model_B.Assignment_i[0] = model_P.v_Psi_Value[0];
  model_B.Assignment_i0[0] = model_P.Constant_Value_e[0];
  model_B.Assignment_i[1] = model_P.v_Psi_Value[1];
  model_B.Assignment_i0[1] = model_P.Constant_Value_e[1];
  model_B.Assignment_i[2] = model_P.v_Psi_Value[2];
  model_B.Assignment_i0[2] = model_P.Constant_Value_e[2];
  model_B.Assignment_i[3] = model_B.Bike_o3;

  /* Assignment: '<S5>/Assignment' incorporates:
   *  Constant: '<S10>/Constant'
   *  Gain: '<S3>/Gain1'
   */
  model_B.Assignment_i0[2] = model_P.Gain1_Gain * model_B.Bike_o2[0];
  model_B.Assignment_i0[0] = model_P.Gain1_Gain * model_B.Bike_o2[1];
  if (rtmIsMajorTimeStep(model_M)) {
  }

  /* Gain: '<S1>/Gain' */
  model_B.Gain = model_P.Gain_Gain * model_B.Bike_o4;

  /* tid is required for a uniform function interface.
   * Argument tid is not used in the function. */
  UNUSED_PARAMETER(tid);
}

/* Model update function */
void model_update(int_T tid)
{
  if (rtmIsMajorTimeStep(model_M)) {
    rt_ertODEUpdateContinuousStates(&model_M->solverInfo);
  }

  /* Update absolute time for base rate */
  /* The "clockTick0" counts the number of times the code of this task has
   * been executed. The absolute time is the multiplication of "clockTick0"
   * and "Timing.stepSize0". Size of "clockTick0" ensures timer will not
   * overflow during the application lifespan selected.
   * Timer of this task consists of two 32 bit unsigned integers.
   * The two integers represent the low bits Timing.clockTick0 and the high bits
   * Timing.clockTickH0. When the low bit overflows to 0, the high bits increment.
   */
  if (!(++model_M->Timing.clockTick0))
    ++model_M->Timing.clockTickH0;
  model_M->Timing.t[0] = rtsiGetSolverStopTime(&model_M->solverInfo);
  if (rtmIsMajorTimeStep(model_M)) {
    /* Update absolute timer for sample time: [0.02s, 0.0s] */
    /* The "clockTick1" counts the number of times the code of this task has
     * been executed. The absolute time is the multiplication of "clockTick1"
     * and "Timing.stepSize1". Size of "clockTick1" ensures timer will not
     * overflow during the application lifespan selected.
     * Timer of this task consists of two 32 bit unsigned integers.
     * The two integers represent the low bits Timing.clockTick1 and the high bits
     * Timing.clockTickH1. When the low bit overflows to 0, the high bits increment.
     */
    if (!(++model_M->Timing.clockTick1))
      ++model_M->Timing.clockTickH1;
    model_M->Timing.t[1] = model_M->Timing.clockTick1 *
      model_M->Timing.stepSize1 + model_M->Timing.clockTickH1 *
      model_M->Timing.stepSize1 * 4294967296.0;
  }

  /* tid is required for a uniform function interface.
   * Argument tid is not used in the function. */
  UNUSED_PARAMETER(tid);
}

/* Derivatives for root system: '<Root>' */
void model_derivatives(void)
{
  /* S-Function "bike_wrapper" Block: <S1>/Bike */
  {
    real_T *pxc = &model_X.Bike_CSTATE[0];
    real_T *dx = &((StateDerivatives_model *) model_M->ModelData.derivs)
      ->Bike_CSTATE[0];
    bike_Derivatives_wrapper(model_B.TmpSignalConversionAtBikeInport1,
      model_B.Bike_o1, model_B.Bike_o2, &model_B.Bike_o3, &model_B.Bike_o4, dx,
      pxc);
  }

  /* Derivatives for Integrator: '<S1>/Integrator' */
  ((StateDerivatives_model *) model_M->ModelData.derivs)->Integrator_CSTATE =
    model_B.Gain;
}

/* Model initialize function */
void model_initialize(boolean_T firstTime)
{
  (void)firstTime;

  /* Registration code */

  /* initialize non-finites */
  rt_InitInfAndNaN(sizeof(real_T));

  /* non-finite (run-time) assignments */
  model_P.Constant_Value[0] = rtNaN;
  model_P.Constant_Value[1] = rtNaN;
  model_P.Constant_Value[2] = rtNaN;
  model_P.Constant_Value[3] = rtNaN;
  model_P.Constant_Value_f[0] = rtNaN;
  model_P.Constant_Value_f[1] = rtNaN;
  model_P.Constant_Value_f[2] = rtNaN;
  model_P.Constant_Value_f[3] = rtNaN;
  model_P.Constant_Value_i[0] = rtNaN;
  model_P.Constant_Value_i[1] = rtNaN;
  model_P.Constant_Value_i[2] = rtNaN;
  model_P.Constant_Value_i[3] = rtNaN;
  model_P.Constant_Value_m[0] = rtNaN;
  model_P.Constant_Value_m[1] = rtNaN;
  model_P.Constant_Value_m[2] = rtNaN;
  model_P.Constant_Value_m[3] = rtNaN;
  model_P.Constant_Value_e[0] = rtNaN;
  model_P.Constant_Value_e[1] = rtNaN;
  model_P.Constant_Value_e[2] = rtNaN;

  /* initialize real-time model */
  (void) memset((void *)model_M,0,
                sizeof(RT_MODEL_model));

  {
    /* Setup solver object */
    rtsiSetSimTimeStepPtr(&model_M->solverInfo, &model_M->Timing.simTimeStep);
    rtsiSetTPtr(&model_M->solverInfo, &rtmGetTPtr(model_M));
    rtsiSetStepSizePtr(&model_M->solverInfo, &model_M->Timing.stepSize0);
    rtsiSetdXPtr(&model_M->solverInfo, &model_M->ModelData.derivs);
    rtsiSetContStatesPtr(&model_M->solverInfo, &model_M->ModelData.contStates);
    rtsiSetNumContStatesPtr(&model_M->solverInfo, &model_M->Sizes.numContStates);
    rtsiSetErrorStatusPtr(&model_M->solverInfo, (&rtmGetErrorStatus(model_M)));
    rtsiSetRTModelPtr(&model_M->solverInfo, model_M);
  }

  rtsiSetSimTimeStep(&model_M->solverInfo, MAJOR_TIME_STEP);
  model_M->ModelData.intgData.y = model_M->ModelData.odeY;
  model_M->ModelData.intgData.f[0] = model_M->ModelData.odeF[0];
  model_M->ModelData.intgData.f[1] = model_M->ModelData.odeF[1];
  model_M->ModelData.intgData.f[2] = model_M->ModelData.odeF[2];
  model_M->ModelData.intgData.f[3] = model_M->ModelData.odeF[3];
  model_M->ModelData.intgData.f[4] = model_M->ModelData.odeF[4];
  model_M->ModelData.intgData.f[5] = model_M->ModelData.odeF[5];
  model_M->ModelData.contStates = ((real_T *) &model_X);
  rtsiSetSolverData(&model_M->solverInfo, (void *)&model_M->ModelData.intgData);
  rtsiSetSolverName(&model_M->solverInfo,"ode5");

  /* Initialize timing info */
  {
    int_T *mdlTsMap = model_M->Timing.sampleTimeTaskIDArray;
    mdlTsMap[0] = 0;
    mdlTsMap[1] = 1;
    model_M->Timing.sampleTimeTaskIDPtr = (&mdlTsMap[0]);
    model_M->Timing.sampleTimes = (&model_M->Timing.sampleTimesArray[0]);
    model_M->Timing.offsetTimes = (&model_M->Timing.offsetTimesArray[0]);

    /* task periods */
    model_M->Timing.sampleTimes[0] = (0.0);
    model_M->Timing.sampleTimes[1] = (0.02);

    /* task offsets */
    model_M->Timing.offsetTimes[0] = (0.0);
    model_M->Timing.offsetTimes[1] = (0.0);
  }

  rtmSetTPtr(model_M, &model_M->Timing.tArray[0]);

  {
    int_T *mdlSampleHits = model_M->Timing.sampleHitArray;
    mdlSampleHits[0] = 1;
    mdlSampleHits[1] = 1;
    model_M->Timing.sampleHits = (&mdlSampleHits[0]);
  }

  rtmSetTFinal(model_M, -1);
  model_M->Timing.stepSize0 = 0.02;
  model_M->Timing.stepSize1 = 0.02;

  /* external mode info */
  model_M->Sizes.checksums[0] = (1112512880U);
  model_M->Sizes.checksums[1] = (1652045512U);
  model_M->Sizes.checksums[2] = (1121166553U);
  model_M->Sizes.checksums[3] = (2588789612U);

  {
    static const sysRanDType rtAlwaysEnabled = SUBSYS_RAN_BC_ENABLE;
    static RTWExtModeInfo rt_ExtModeInfo;
    static const sysRanDType *systemRan[1];
    model_M->extModeInfo = (&rt_ExtModeInfo);
    rteiSetSubSystemActiveVectorAddresses(&rt_ExtModeInfo, systemRan);
    systemRan[0] = &rtAlwaysEnabled;
    rteiSetModelMappingInfoPtr(model_M->extModeInfo,
      &model_M->SpecialInfo.mappingInfo);
    rteiSetChecksumsPtr(model_M->extModeInfo, model_M->Sizes.checksums);
    rteiSetTPtr(model_M->extModeInfo, rtmGetTPtr(model_M));
  }

  model_M->solverInfoPtr = (&model_M->solverInfo);
  model_M->Timing.stepSize = (0.02);
  rtsiSetFixedStepSize(&model_M->solverInfo, 0.02);
  rtsiSetSolverMode(&model_M->solverInfo, SOLVER_MODE_SINGLETASKING);

  /* block I/O */
  model_M->ModelData.blockIO = ((void *) &model_B);
  (void) memset(((void *) &model_B),0,
                sizeof(BlockIO_model));

  /* parameters */
  model_M->ModelData.defaultParam = ((real_T *) &model_P);

  /* states (continuous) */
  {
    real_T *x = (real_T *) &model_X;
    model_M->ModelData.contStates = (x);
    (void) memset((void *)&model_X,0,
                  sizeof(ContinuousStates_model));
  }

  /* states (dwork) */
  model_M->Work.dwork = ((void *) &model_DWork);
  (void) memset((void *)&model_DWork, 0,
                sizeof(D_Work_model));

  /* data type transition information */
  {
    static DataTypeTransInfo dtInfo;
    (void) memset((char_T *) &dtInfo,0,
                  sizeof(dtInfo));
    model_M->SpecialInfo.mappingInfo = (&dtInfo);
    dtInfo.numDataTypes = 14;
    dtInfo.dataTypeSizes = &rtDataTypeSizes[0];
    dtInfo.dataTypeNames = &rtDataTypeNames[0];

    /* Block I/O transition table */
    dtInfo.B = &rtBTransTable;

    /* Parameters transition table */
    dtInfo.P = &rtPTransTable;
  }
}

/* Model terminate function */
void model_terminate(void)
{
}

/*========================================================================*
 * Start of GRT compatible call interface                                 *
 *========================================================================*/
void MdlOutputs(int_T tid)
{
  model_output(tid);
}

void MdlUpdate(int_T tid)
{
  model_update(tid);
}

void MdlInitializeSizes(void)
{
  model_M->Sizes.numContStates = (12); /* Number of continuous states */
  model_M->Sizes.numY = (0);           /* Number of model outputs */
  model_M->Sizes.numU = (0);           /* Number of model inputs */
  model_M->Sizes.sysDirFeedThru = (0); /* The model is not direct feedthrough */
  model_M->Sizes.numSampTimes = (2);   /* Number of sample times */
  model_M->Sizes.numBlocks = (33);     /* Number of blocks */
  model_M->Sizes.numBlockIO = (14);    /* Number of block outputs */
  model_M->Sizes.numBlockPrms = (44);  /* Sum of parameter "widths" */
}

void MdlInitializeSampleTimes(void)
{
}

void MdlInitialize(void)
{
  /* S-Function Block: <S1>/Bike */
  {
    real_T *xC = &model_X.Bike_CSTATE[0];
    xC[0] = 0;
    xC[1] = 0;
    xC[2] = 0.3141592653589794;
    xC[3] = 0;
    xC[4] = 0;
    xC[5] = 0;
    xC[6] = 0;
    xC[7] = 0;
    xC[8] = 0;
    xC[9] = 0;
    xC[10] = -13.14285714285714;
  }

  /* InitializeConditions for Integrator: '<S1>/Integrator' */
  model_X.Integrator_CSTATE = model_P.Integrator_IC;
}

void MdlStart(void)
{
  MdlInitialize();
}

void MdlTerminate(void)
{
  model_terminate();
}

RT_MODEL_model *model(void)
{
  model_initialize(1);
  return model_M;
}

/*========================================================================*
 * End of GRT compatible call interface                                   *
 *========================================================================*/
