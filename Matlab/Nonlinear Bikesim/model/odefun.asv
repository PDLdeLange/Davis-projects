function dz = odefun(z,u) %#eml
% function dz = odefun(z,v)
%
% Returns the derivative of the state (dz) as a function of the state (z),
% input torque (u).

% Predetermine inputsizes (required for c-code compiling)
assert(all(size(z) == [8 1]));
assert(all(size(u) == [3 1]));

v = z(5); % velocity

Tphi   = u(1);
Tdelta = 2*u(2);%*abs(Kv*omega*phimax*(v-vmax));


T = [Tphi;Tdelta];

% System parameters
M0 = [  80.812100000000   2.323431426235;   2.323431426235  0.301265709342];
C1 = [   0.000000000000  33.773869475930;  -0.848234478256  1.706965397923];
K0 = [-794.119500000000 -25.739089291258; -25.739089291258 -8.139414705882];
K2 = [   0.000000000000  76.406208759656;   0.000000000000  2.675605536332];
pA  = 0.074406;
pB  = 0.930081;

M = M0;
C = C1*v;
K = K0 + K2*v^2;

% velocity: (0 < v < 10) [m/s)
if v<0 && u(3)<0
    u(3) = 0;
elseif v>10 && u(3)>0
    u(3) = 0;
end


  
% State space formulation
dz = zeros(8,1);
dz(1:4) = [zeros(2) eye(2); -M\K -M\C]*z(1:4) + [zeros(2); M\eye(2)]*T(1:2); % state
dz(5)   = 2*u(3); % forward acceleration
dz(6)   = -v*cos(z(8)); % global xd
dz(7)   = -v*sin(z(8)); % global yd
dz(8)   = pA*z(4) + pB*v*z(2); % global psid

