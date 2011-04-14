clear all; close all; clc; addpath('functions');

%% Some administration

T       = 50; % Measurement time [s]
Fs      = 50; % 
Ts      = 1/Fs; % sample period
t       = (0:1/Fs:T-1/Fs)'; % Time vector [s]
N       = length(t); % Number of samples [-]

%% Input signal

w = zeros(size(t));
w(t>5 & t<=10) =  5;
w(t>10 & t<15) = -5;

%% Bike model
v = 5;
bike = bikesys_rider(v);  % statespace represention

%% Rider model

% rider = -Gnm*[Kphi*Kphid*Kdelta, Kdelta, Kphid*Kdelta, 0];
Kphi    = 9.975;
Kphid   = -0.07;
Kdelta  = 39.00;
Kpsi    = 0.1585;
Ky      = 0.1014;
Gnm     = tf(900,[1 2*.707*30  900]);

%% Simulation!

var = [t,w];
sim('model_rider');

%% Plot time results:

close all;
% Steering torque
figure(1);  title('Steering torque'); hold on;
plot(t,u(:,2));
xlabel('t [s]');
ylabel('T\delta [Nm]');
sdf('Latex');

% Steering angle
figure(2); title('Steering angle'); hold on;
plot(t,z(:,2));
xlabel('t [s]');
ylabel('\delta [rad]');
sdf('Latex');

% roll angle
figure(3); title('Roll angle'); hold on;
plot(t,z(:,1));
xlabel('t [s]');
ylabel('\phi [rad]');
sdf('Latex');

% Roll torque disturbance
figure(4);  title('Roll torque'); hold on;
plot(t,u(:,1));
xlabel('t [s]');
ylabel('T\phi [Nm]');
sdf('Latex');

% Lateral displacement
figure(5);  title('Lateral displacement'); hold on;
plot(t,y);
xlabel('t [s]');
ylabel('y [m]');
sdf('Latex');

