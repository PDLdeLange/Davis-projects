clear all; close all; clc;
    
%% Comments:

% - Numerical estimation of deltad based on delta using finite differincing
% - Ode solving very unstable, find out whats behind it
% - 

%%  Load data

omega0 = 28;

load('../../data/CalibData/calibdata.mat');

for i = 1:6
    load(['../../data/0021' num2str(i) '.mat']);

    % Steerangle
    V = NIData(:,2);
    p = [calibdata(2).slope, calibdata(2).offset];
    delta(:,i) = polyval(p,V);
    delta(:,i) = delta(:,i) - mean(delta(end-5:end,i));
    %     % Steerrate
    %     V = NIData(:,6);
    %     p = [calibdata(5).slope, calibdata(5).offset];
    %     deltad = polyval(p,V);

    % Time axis
    N = length(delta);
    Fs = 200;
    t(:,i) = linspace(0,N/Fs,N)';
    deltad(:,i) = gradient(delta(:,i),1/Fs);
    Enorm(:,i) = 1/2.*(deltad(:,i).^2 + omega0.^2*delta(:,i).^2);
    Estrt = 1/2*omega0^2*0.1^2;
    
    strt(i) = find(Enorm(:,i)<Estrt,1);
    
    deltasel(:,i) = delta(strt(i)+(1:360),i);
    deltadsel(:,i) = deltad(strt(i)+(1:360),i);

end

tsel = linspace(0,size(deltasel,1)/Fs,size(deltasel,1))';

% Raw data
figure(1);
plot(t,delta);  hold on;
xlabel('time [s]');
ylabel('\delta [rad]');
title('Steering angle measurement: \delta(t)');
sdf('Latex');

% Estimated energy
figure(2);
plot(t,Enorm); hold on;
plot([t(strt);t(strt)],[0,15],':');
plot(t,ones(length(t),1)*Estrt,':k');
xlabel('time [s]');
ylabel('Mass normalized energy [J/(kg*m^2)]');
title('Energy selection method');
sdf('Latex');

% Selected data
figure(3);
plot(tsel,deltasel);
xlabel('time [s]');
ylabel('\delta [rad]');
title('Steering angle measurement: \delta(t)');
sdf('Latex');


%% Parameter fitting

X0  = [28 0.03 2];
X0n = ones(1,3);

% Optimization
options = optimset;
options = optimset(options,'Diagnostics', 'on');
options = optimset(options,'Display', 'final');

for i = 1:6
    
    disp([num2str(i) '/6']);
    
    z0{i} = [deltasel(1,i);deltadsel(1,i)];
    Xn{i} = lsqnonlin(@(Xn)errorfun(Xn,tsel,deltasel(:,i),z0{i},X0),X0n,[],[],options); 
    X{i}  = Xn{i}.*X0;

%     ODE simulation
    odeopts = odeset('Events',@eventfun,'AbsTol',1e-6); % stop at y =0
    [~,z{i}] = ode45(@(t,z)odefun(t,z,X{i}),tsel,z0{i},odeopts);
    deltamod(:,i) = z{i}(:,1);
    
end

% Plotting
figure;
title('Steering angle'); hold on; box on;
h1 = plot(tsel,deltasel);
h2 = plot(tsel,deltamod,':');
sdf('Latex');
xlabel('Time [s]');
ylabel('\delta [rad]');
legend([h1],'1','2','3','4','5','6');

%% Calculate parameters and estimate moment of inertia

Xmean = mean(cell2mat(X'));

omega0 = Xmean(1);
zeta   = Xmean(2);
A      = Xmean(3);

% # Stifness measurement and calculation
lbs2kg = 0.45359237;
g = 9.81;
L1 = 0.165;
L2 = 0.204;
e  = 0.231;
dL = L2-L1;
dm = 2*4*lbs2kg;
k  = dm*g/dL;

Idelta = 2*k*e/omega0^2;

%% Next: load some random measurement

load('../../data/00190.mat');

% Steerangle
Vdelta = NIData(:,2);
pdelta = [calibdata(2).slope, calibdata(2).offset];
delta = polyval(p,Vdelta);
% Time axis
N = length(delta);
Fs = 200;
t = linspace(0,N/Fs,N)';
% Deltadot
deltad = gradient(delta,1/Fs);
% Steertorque
Vtorque = NIData(:,11);
ptorque = [calibdata(4).slope, calibdata(4).offset];
torque = polyval(ptorque,Vtorque);
    

%% Determine friction force

% Steerrate
Vdeltad = NIData(:,6);
pdeltad = [calibdata(5).slope, calibdata(5).offset];
deltad_gyro = polyval(pdeltad,Vdeltad);

Tf1 = -2*zeta*omega0*Idelta*deltad;
Tf2 = zeros(size(Tf1));
Tf2(deltad<1e-3) =  A*Idelta;
Tf2(deltad>1e-3) = -A*Idelta;

t1 = 10;
t2 = 15;

figure;
subplot(3,1,1);
plot(t,delta); xlim([t1,t2]);
subplot(3,1,2 );
plot(t,[deltad,deltad_gyro]); xlim([t1,t2]);
subplot(3,1,3);
plot(t,torque); hold on;
plot(t,Tf1,'r:');
plot(t,Tf2,'r:');
plot(t,Tf2+Tf1,'r');
plot([t1,t2],[0 0],':k');
ylim([-2,2]); xlim([t1,t2]);
sdf('Latex');

