clear all; close all; clc; addpath('functions');
% MIMO estimation of the bicycle equations

%% Some administration

Fs      = 10;   % sample frequency [Hz]
N       = 2^12; % number of samples [-]
M       = 2^4;  % number of measurements [-];

Ts      = 1/Fs;             % Sample period [s]
T       = Ts*N;             % Measurement time [s]
t       = linspace(0,T,N).'; % Time vector [s]
f       = (0:N-1)' / T;     % Frequency vector [Hz]

%% Bike model
v = 5;              % forward velocity
sys = bikesys(v);   % statespace represention
sys = sys(1:2,1:2);   % select inputs/outputs

%% Input design and simulation

% Input bandwidth [Hz]
f1 = 1/T; 
f2 = 3;
sel = f>=f1 & f<f2; Nsel = length(f(sel));

A1 = 5;
A2 = 1;

% Check for existance of simulation data, if not than peform simulation.
if ~exist('data.mat','file');
    un = multisine(f1,f2,T,N);
    % Simulation
    I = [A1 A1; A2 A2].*[1 1; 1 -1];
    u = zeros(2,2,M,N); U = zeros(2,2,M,N);
    y = zeros(2,2,M,N); Y = zeros(2,2,M,N);
    for k = 1:M
        for j = 1:2
            input = [t un*I(:,j)'];
            sim('model_mimo');  % call simulink model
            y(:,j,k,:) = reshape(output.signals.values.',2,1,1,N);
            u(:,j,k,:) = reshape((un*I(:,j).').',2,1,1,N);
            Y(:,j,k,:) = reshape(fft(output.signals.values).',2,1,1,N);
            U(:,j,k,:) = reshape(fft(un*I(:,j).').',2,1,1,N);  
        end
    end
    f = f(sel);
    omega = 2*pi*f;
    U = squeeze(sum(U(:,:,:,sel),3));
    Y = squeeze(sum(Y(:,:,:,sel),3));
%         save data U Y omega f; 
else
    load data;
end

%% Creating data objects
Udat  = cell(2,1);
Ydat  = cell(2,1);
Tsdat = cell(2,1); Tsdat(:) = {Ts};
fdat  = cell(2,1);  fdat(:) = {omega};
for j = 1:2
    Udat{j} = squeeze(U(:,j,:)).';
    Ydat{j} = squeeze(Y(:,j,:)).';
end
data = iddata(Ydat,Udat,Tsdat,'Frequency',fdat);


%% Sysid

m1 = pem(data,4);
m2 = n4sid(data,4);
g = spa(data,Nsel,omega);

Hss1 = freqresp(m1,omega);
Hss2 = freqresp(m2,omega);
Hfrf = freqresp(g,[omega(1) omega(end)]);
Htrue = freqresp(sys,omega);

%% Calculating spectral densities and stuff

H = zeros(2,2,Nsel);
for k = 1:Nsel;
    H(:,:,k) = Y(:,:,k)*U(:,:,k)'/(U(:,:,k)*U(:,:,k)');
end
% 
% mCuy = ones(size(H));
% 
% %% True system
% 
% % %% True system
% Htrue = squeeze(freqresp(sys,2*pi*f));
% 
% %% Parameter Estimation
% 
% % a = 
% %            x1      x2      x3      x4
% %    x1       0       0       0  -97.54
% %    x2       1       0       0  -293.5
% %    x3       0       1       0  -47.83
% %    x4       0       0       1  -16.21
% 
% options = optimset('MaxFunEvals',2000);
% 
% X0  = [97.54  293.5 47.83  16.21  -32.28  1.201  -0.175  -0.01866  0.0159   0.1926  -0.7833 -0.1226]; % Initial conditions
% % X0  = [97.54  293.5 47.83  16.21  -32.28  1.201  -0.175  -0.01866  0.0159   0.1926  -0.7833 -0.1226    2.212   -28.64]; % Initial conditions
% X0n = ones(size(X0)) + 0.01*(randn(size(X0))-0.5); % Perturbed initial conditions
% lsqfunc = @(Xn)error_freq(Xn,H(:,:,sel),@H_mimo2,mCuy(:,:,sel),f(sel),X0); % LSQ function
% 
% % Find optimal fit!
% [Xn,~,e,~,~,~,Jn] = lsqnonlin(lsqfunc,X0n,[],[],options);
% J = Jn./repmat(X0,size(Jn,1),1); % Jacobian
% 
% X = Xn.*X0; % Actual (non-normalized) parameters
% sem = full(sqrt(diag(inv(J'*J))*sum(e.^2)/length(e))); % SEM: Standard Error of the Mean
% semn = full(sqrt(diag(inv(Jn'*Jn))*sum(e.^2)/length(e))); % SEM: Standard Error of the Mean
% 
% % y_mod = H_zpk_time(X,u,t);
% % VAF = 1 - sum(abs(y_mod - y).^2)/sum(abs(y).^2);
% 
% Hfit = H_mimo2(X,f);
% 
% %% Select frequencyband of interest
% 
% % f = f(sel);
% % 
% % H = H(:,:,sel);
% % U = U(:,:,sel);
% % Y = Y(:,:,sel);
% 
% 
%% Plot results
close all;
% Bode plot
figure(3);
subplot(211);
    h(:,4) = loglog(f,abs(reshape(H,4,Nsel).'),'Color',0.8*ones(1,3)); hold on;
    h(:,2) = loglog(f,abs(reshape(Hfrf,4,Nsel).'),'Color',0.8*ones(1,3)); 
    h(:,1) = loglog(f,abs(reshape(Htrue,4,Nsel).'),'r'); hold on;
    h(:,3) = loglog(f,abs(reshape(Hss1,4,Nsel).'),'b');
    h(:,5) = loglog(f,abs(reshape(Hss2,4,Nsel).'),'g'); 
    xlim([f1,f2]); ylabel('Gain [Nm^{-1}]'); ylim([1e-5 1e1]);
    legend(h(1,:),'H_{true}','H_{est}','H_{mod}',2);
    title('Bode diagram of system C');
subplot(212);
    semilogx(f,unwrap(angle(reshape(H,4,Nsel).')),'Color',0.8*ones(1,3)); hold on;
    semilogx(f,unwrap(angle(reshape(Hfrf,4,Nsel).')),'Color',0.8*ones(1,3)); hold on;
    semilogx(f,unwrap(angle(reshape(Htrue,4,Nsel).')),'r'); hold on;
    semilogx(f,unwrap(angle(reshape(Hss1,4,Nsel).')),'b');
    semilogx(f,unwrap(angle(reshape(Hss2,4,Nsel).')),'g');
    xlim([f1,f2]); ylabel('Phase [rad]'); ylim([-2*pi 2*pi]);
xlabel('frequency [Hz]');
sdf('Latex');

