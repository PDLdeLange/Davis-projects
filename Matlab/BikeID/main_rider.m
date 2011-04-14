clear all; close all; clc; addpath('functions');

%% Some administration

T       = 200; % Measurement time [s]
Fs      = 50; % 
Ts      = 1/Fs; % sample period
t       = (0:1/Fs:T-1/Fs)'; % Time vector [s]
N       = length(t); % Number of samples [-]
f       = (0:N-1)' / T; % Frequency vector [Hz]
f       = f(2:N/2+1,:);
Nf      = length(f);
fmax    = 10; % [Hz] Frequency

%% Input signal generation

% % Check for u.mat if not present than generate it
% if ~exist('w.mat','file');
%     figure; sdf('Latex');
%     freqs   = 1/T:1/T:fmax; % Multisine frequencies [Hz]
%     w  = crested_signal(freqs,Fs,T); w = 1*w/max(abs(w));
%     save w w; close all;
% else
%     load w;
% end
% var     = [t w]; 

%% Bike model
v = 5;              % forward velocity
A = [0 1 0 0; 7.9468 -0.1505 -19.4598  -1.1604; 0 0 0 1; 19.8927 7.6349 -29.5611 -17.3444];
B = [0 0; 0.0117 -0.0867; 0 0; -0.0867 4.4005];
C = [1 0 0 0; 0 0 1 0; 0 1 0 0; 0 0 0 1];
bike = ss(A,B,C,[]);   % statespace represention

%% Rider model

Ky = .1021; %  ?
Kpsi = .1651; % ? 
Kphi  = 8.546; 
Kphid = -0.075;
Kdelta  = 60;% 39.00;
Gnm     = tf(900,[1 2*.707*30  900]);

Xtrue = [Kphi,Kphid,Kdelta,Kpsi,Ky];


%% Simulation!
Kn = 1; % Noise
sim('Model_rider');    % call simulink model

% %% Parameter Estimation in Time domain
% 
% X0 = Xtrue;
% X0n = ones(size(X0)) + 0.1*(randn(size(X0))-0.5); % Perturbed initial conditions
% Xdist = X0n.*X0;
% lsqfunc = @(Xn)error_time(Xn,u,y,X0); % LSQ function
% 
% % Find optimal fit!
% [Xn,~,e,~,~,~,Jn] = lsqnonlin(lsqfunc,X0n);
% J = Jn./repmat(X0,size(Jn,1),1); % Jacobian
% 
% X = Xn.*X0; % Actual (non-normalized) parameters
% sem = full(sqrt(diag(inv(J'*J))*sum(e.^2)/length(e))); % SEM: Standard Error of the Mean
% 
% % y_mod = H_zpk_time(X,u,t);
% % VAF = 1 - sum(abs(y_mod - y).^2)/sum(abs(y).^2);
% 
% output  = H_bikeplusrider(u,X);
% y_mod   = output.y;
% 
% output  = H_bikeplusrider(u,Xdist);
% y_dist   = output.y;

% %% Plot results
% close all;
% % Bode plot
% figure(3);
% subplot(211);
%     loglog(mf,abs(mHtrue),':'); hold on;
%     loglog(mf,abs(mH));
%     xlim([mf(1),fmax]); ylabel('Gain [Nm^{-1}]'); ylim([1e-1 1e3]);
%     title('Bode diagram of system C');
% subplot(212);
% 	semilogx(mf,unwrap(angle(mHtrue)),':'); hold on;
%     semilogx(mf,unwrap(angle(mH))); 
%     xlim([mf(1),fmax]); ylabel('Phase [rad]'); ylim([-pi pi]);
% % subplot(313);
% %     semilogx(mf,mCuy1,'r'); hold on;
% %     semilogx(mf,mCuy2,'b:');
% %     xlim([mf(1),fmax]); ylabel('\Gamma^2 [-]'); ylim([0 1.2]);
% xlabel('frequency [Hz]');
% % legend(h,'True Linear','Linear','Non-Linear','Estimated fit',1);
% sdf('Latex');
