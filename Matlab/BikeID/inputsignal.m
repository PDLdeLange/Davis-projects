function u = multisine(f1,f2,N);
% Input bandwidth
f1 = 1/T; 
f2 = 2;

% Input amplitudes
A(1) = 10.0;
A(2) =  2.0;


%% Input signal generation

% Check for u.mat if not present than generate it
if ~exist('u.mat','file');
    % Multisine with random phase
        freqs   = f1:1/T:f2; % Multisine frequencies [Hz]
        phase = 2*pi*rand(size(freqs));
        amp = ones(size(freqs));
        amp_complex = amp'.*exp(phase.'*1j);
        amp_complex_crested = msinclip(freqs,amp_complex);
        tmp = zeros(N/2,1);
        tmp(1:size(freqs',1),1) = amp_complex_crested;
    u = ifft(tmp,N,'symmetric'); clear tmp;
    u = u / std(u);
    u = u - mean(u);
%     save u u; 
else
    load u;
end