clear all; close all; clc; addpath('bikeID\functions');
% Matlab function to set up various inputsignals which are described in the
% input signal design section of the Davis report.

%% Some administration

Fs      = 50; %
N       = 2^12;
Ts      = 1/Fs; % sample period
T       = Ts*N;
t       = linspace(0,T,N);%(0:1/Fs:T-1/Fs)'; % Time vector [s]
% N       = length(t); % Number of samples [-]
f       = (0:N-1)' / T; % Frequency vector [Hz]
f       = f(2:N/2+1,:);

f1 = 1/T;
f2 = 10;


%% Input signal generation

% Check for u.mat if not present than generate it
if ~exist('u.mat','file');
    u = zeros(N,4);
    % Gaussian white noise
    u(:,1) = randn(N,1);
    % Swept sine
    u(:,2) = sin((pi.*(f2-f1).*t./T+2.*pi.*f1).*t);
    % Multisine with random phase
        freqs   = f1:1/T:f2; % Multisine frequencies [Hz]
        phase = 2*pi*rand(size(freqs));
        amp = ones(size(freqs));
        amp_complex = amp'.*exp(phase.'*1j);
        temp = zeros(N/2,1);
        temp(1:size(freqs',1),1) = amp_complex;
    u(:,3) = ifft(temp,N,'symmetric');% msinprep(freqs, amp_complex, N, Fs);
    % Crested multisine
        amp_complex_crested = msinclip(freqs,amp_complex);
        temp = zeros(N/2,1);
        temp(1:size(freqs',1),1) = amp_complex_crested;
    u(:,4) = ifft(temp,N,'symmetric');
    u = u./repmat(std(u),N,1);
    u = u - repmat(mean(u),N,1);
    save u u; 
else
    load u;
end

%% Evaluating results
U = fft(u); U = U(2:N/2+1,:); 

Suu = 1/N*conj(U).*U; Suu = real(Suu);

ii = find(f>f1 & f<f2);

Suu_avg = (mean(Suu(ii,:)));
mu      = mean(u);
Ruu     = std(u);
umax    = max(u);
C       = max(u)./(sqrt(1/N*diag(u'*u)'));

%% PLotting results
close all;
desc{1} = 'Gaussian white noise';
desc{2} = 'Swept sine';
desc{3} = 'Random phase multisine';
desc{4} = 'Crested multisine';

figure(2);

for i = 1:4

%     figure(i);
    
    subplot(4,2,i*2-1);
        h = plot(t,u(:,i),'k');
        title([desc{i} ': u(t)']);
        if i == 4; xlabel('t [s]'); end;
        ylabel('A [-]');
%         legend(h,desc{i});
        axis([0,t(end),-4,4]);
 
    subplot(4,2,i*2);
        h = plot(f,Suu(:,i),'k');
        title([desc{i} ': U(\omega)']);
        if i == 4; xlabel('f [Hz]'); end;
        ylabel('A [-]');
%         legend(h,desc{i});
        axis([0,f(end),0,12]);
    
    set(gcf,'Units','centimeters');
    set(gcf,'Position',[14.779 19.062 16.000 6]);
    
end


    sdf('Latex');

