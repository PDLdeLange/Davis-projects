function msfuntmpl_nonlin(block)
%MSFUNTMPL_BASIC A template for a Leve-2 M-file S-function
%   The M-file S-function is written as a MATLAB function with the
%   same name as the S-function. Replace 'msfuntmpl_basic' with the 
%   name of your S-function.
%
%   It should be noted that the M-file S-function is very similar
%   to Level-2 C-Mex S-functions. You should be able to get more
%   information for each of the block methods by referring to the
%   documentation for C-Mex S-functions.
%
%   Copyright 2003-2009 The MathWorks, Inc.

setup(block);
    % The setup method is used to setup the basic attributes of the
    % S-function such as ports, parameters, etc. Do not add any other
    % calls to the main body of the function.

function setup(block)
    % Function: setup ===================================================
    % Abstract:
    %   Set up the S-function block's basic characteristics such as:
    %   - Input ports
    %   - Output ports
    %   - Dialog parameters
    %   - Options
    %
    %   Required         : Yes
    %   C-Mex counterpart: mdlInitializeSizes

    % Register number of ports
    block.NumInputPorts  = 1;
    block.NumOutputPorts = 1;

    % Setup port properties to be inherited or dynamic
    block.SetPreCompInpPortInfoToDynamic;
    block.SetPreCompOutPortInfoToDynamic;

    % Override input port properties
    block.InputPort(1).Dimensions  = 1;
    block.InputPort(1).DatatypeID  = 0;  % double
    block.InputPort(1).Complexity  = 'Real';
    block.InputPort(1).DirectFeedthrough = true;

    % Override output port properties
    block.OutputPort(1).Dimensions  = 1;
    block.OutputPort(1).DatatypeID  = 0; % double
    block.OutputPort(1).Complexity  = 'Real';

    % Constant states
    block.NumContStates  = 11;

    % Register parameters
    block.NumDialogPrms     = 0;
    block.SampleTimes = [0 0];
    block.SimStateCompliance = 'DefaultSimState';
    block.RegBlockMethod('InitializeConditions', @InitializeConditions);
    block.RegBlockMethod('Outputs', @Outputs);     
    block.RegBlockMethod('Derivatives', @Derivatives);


function InitializeConditions(block)
    % InitializeConditions:
    %   Functionality    : Called at the start of simulation and if it is 
    %                      present in an enabled subsystem configured to reset 
    %                      states, it will be called when the enabled subsystem
    %                      restarts execution to reset the states.
    %   Required         : No
    %   C-MEX counterpart: mdlInitializeConditions
    block.ContStates.Data = [
        0.0;                    % rad                 Yaw
        0.0;                    % rad                 Roll
        0.3141592653589794;     % rad                 Pitch
        0.0;                    % rad                 Steer
        0.0;                    % rad                 Rear wheel
        0.0;                    % rad                 Front wheel
        0.0;                    % m                   x rear contact
        0.0;                    % m                   y rear contact
        0.0;                    % rad/s               Roll rate
        0.0;                    % rad/s               Steer rate
        -5/0.35;      % rad/s               Front wheel rate
    ];
    disp('--- Initial Conditions ---');
    disp(block.ContStates.Data);


function Outputs(block)
    % Outputs:
    %   Functionality    : Called to generate block outputs in
    %                      simulation step
    %   Required         : Yes
    %   C-MEX counterpart: mdlOutputs
    block.OutputPort(1).Data = block.ContStates.Data(2);

function Derivatives(block)
    % Derivatives:
    %   Functionality    : Called to update derivatives of
    %                      continuous states during simulation step
    %   Required         : No
    %   C-MEX counterpart: mdlDerivatives
    block.Derivatives.Data = odefun_nonlinear(block.ContStates.Data,block.InputPort(1).Data);

