clear all; close all; clc; addpath('functions');

%% Some administration

load u; u = 0.6*u/max(u);
N = length(u);
Fs = 200;
definitions;

% Input bandwidth [Hz]
f1 = 1/T; 
f2 = 8;
sel = f>=f1 & f<f2; Nsel = length(f(sel));

%% Bike model
var = [t,u];
v = 5;              % forward velocity
sys = bikesys(v);   % statespace represention
sys = sys(1,2);     % Select steer torque to mfroll angle

%% Bike simulation

sim('Model_siso');    % call simulink model

u  = u.signals.values;
y1 = y1.signals.values;
y2 = y2.signals.values;
ytrue = y_true.signals.values;

%% Calculating spectral densities and stuff

% Convert time domain signals to frequency domain
U = fft(u); U = U(2:N/2+1,:); 
Y1 = fft(y1); Y1 = Y1(2:N/2+1,:);
Y2 = fft(y2); Y2 = Y2(2:N/2+1,:); 

% Spectral densities
Suu   = 1/N*conj(U).*U; Suu = real(Suu);
Sy1y1 = 1/N*conj(Y1).*Y1; Sy1y1 = real(Sy1y1);
Sy2y2 = 1/N*conj(Y2).*Y2; Sy2y2 = real(Sy2y2);
Suy1  = 1/N*conj(U).*Y1; 
Suy2  = 1/N*conj(U).*Y2; 

% Apply frequency averaging
Nb   = 4; 
mf   = freqavg(f,Nb); 
mSuu = freqavg(Suu,Nb);
mSy1y1 = freqavg(Sy1y1,Nb);
mSy2y2 = freqavg(Sy2y2,Nb);
mSuy1 = freqavg(Suy1,Nb);
mSuy2 = freqavg(Suy2,Nb);
msel = mf>=f1 & mf<f2; mNsel = length(mf(msel));


% Estimate system transferfunction and corresponding coherence
mH1   = mSuy1./mSuu;
mH2   = mSuy2./mSuu;
mCuy1 = conj(mSuy1).*mSuy1./(mSuu.*mSy1y1);
mCuy2 = conj(mSuy2).*mSuy2./(mSuu.*mSy2y2);

%% True system
mHtrue = squeeze(freqresp(sys,2*pi*mf));

%% Parameter Estimation in Frequency domain

options = optimset('MaxFunEvals',2000);

X0 = [97.54 293.5 47.83 16.21 -32.28 1.201 -0.175 -0.01866 0.0159   0.1926  -0.7833 -0.1226    2.212   -28.64];
X0n = ones(size(X0)); + randn(size(X0)) -0.5; %#ok<MNEFF> % Perturbed initial conditions

lsqfunc = @(Xn)error_freq(Xn,mH1(msel),@H_siso,mCuy1(msel),mf(msel),X0n);
   

% Find optimal fit!
[Xn,~,e,~,~,~,Jn] = lsqnonlin(lsqfunc,X0n,[],[],options);
J = Jn./repmat(X0,size(Jn,1),1); % Jacobian

X = Xn.*X0; % Actual (non-normalized) parameters
sem = full(sqrt(diag(inv(J'*J))*sum(e.^2)/length(e))); % SEM: Standard Error of the Mean

% y_mod = H_zpk_time(X,u,t);
% VAF = 1 - sum(abs(y_mod - y).^2)/sum(abs(y).^2);

mH1fit = H_siso(X,mf);

%% Plot results
close all;
% Bode plot
figure(3);
subplot(311);
    h(2) = loglog(mf,abs(mH1),'Color',0.8*ones(1,3));hold on;
    h(1) = loglog(mf,abs(mHtrue),'k:'); 
    % h(3) = loglog(mf,abs(mH2),'b'); 
    h(3) = loglog(mf,abs(mH1fit),'k');
    xlim([mf(1),mf(end)]); ylabel('Gain [Nm^{-1}]'); ylim([1e-5 1e1]);
    legend(h,'H','H_{est}','H_{mod}',1);
    title('Bode diagram of system C');
subplot(312);
    semilogx(mf,(angle(mH1)),'Color',0.8*ones(1,3)); 
    semilogx(mf,unwrap(angle(mHtrue)),'k:'); hold on;
    % semilogx(mf,(angle(mH2)),'b'); 
    semilogx(mf,unwrap(angle(mH1fit)),'k');hold on;
    xlim([mf(1),mf(end)]); ylabel('Phase [rad]'); ylim([-pi pi]);
subplot(313);
    semilogx(mf,mCuy1,'Color',0.8*ones(1,3)); 
    % semilogx(mf,mCuy2,'b');
    xlim([mf(1),mf(end)]); ylabel('\Gamma^2 [-]'); ylim([0 1.2]);
xlabel('frequency [Hz]');
sdf('Latex');
