clear all; close all; clc;

%% Defining variables:

parms.M0 = [  80.812100000000   2.323431426235;   2.323431426235  0.301265709342];
parms.C1 = [   0.000000000000  33.773869475930;  -0.848234478256  1.706965397923];
parms.K0 = [-794.119500000000 -25.739089291258; -25.739089291258 -8.139414705882];
parms.K2 = [   0.000000000000  76.406208759656;   0.000000000000  2.675605536332];

% parms.M0 = [
%   119.9415    0.0654
%     0.0654    0.0933];
% parms.C1 = [
%          0  -33.8998
%          0    0.0934];
% parms.K0 = [
%  -947.6499         0
%          0         0];
% parms.K2 = [
%          0  -97.1881
%          0         0];

parms.A  = 0.074406;
parms.B  = 0.930081;

%% Calculate eigenvalues at points of interest

realmaxzero = @(v,parms)max(real(eigcalc(v,parms)));

v1 = fzero(@(v)realmaxzero(v,parms), 4);
v2 = fzero(@(v)realmaxzero(v,parms), 6);
e1 = eigcalc(v1,parms);
e2 = eigcalc(v2,parms);

v = 4;(v1 + v2)/2; % m/s


M = parms.M0;
C = parms.C1*v;
K = parms.K0+parms.K2*v^2;

sysA = [zeros(2) eye(2); -M\K -M\C];
sysB = [zeros(2); M\eye(2)];
sysC = eye(4);

sys = ss(sysA,sysB,sysC,0);



% Kp = 0;
% Kd = -10;
% G = [zeros(1,4); Kp 0 Kd 0];
% 
% % Kd = 1;
% % K = [Kp;Kd];
% sysAc = sysA - sysB*G;
% 
% 
% sys2 = ss(sysAc,sysB,sysC,0);




% phiA = [0 1; -K(1,1)/M(1,1) -C(1,1)/M(1,1)];
% phiB = [0; 1/M(1,1)];
% phiC = eye(2);
% 
% phisys = ss(phiA,phiB,phiC,0);
% 
% phicoef = [-M(1,2)/M(1,1); -C(1,2)/M(1,1); -K(1,2)/M(1,1);];
% 
% %% Equilibrium positions
% 
% u = [0;0.1]; % 0.1 Nm of steertorque
% 
% z_eq   = -sysA\sysB*u;
% Psi_eq =  sysB*v*z_eq(2);