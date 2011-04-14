function u = multisine(f1,f2,T,N)

    % Multisine with random phase
    freqs   = f1:1/T:f2+1/T; % Multisine frequencies [Hz]
    phase = 2*pi*rand(size(freqs));
    amp = ones(size(freqs));
    amp_complex = amp'.*exp(phase.'*1j);
    amp_complex_crested = msinclip(freqs,amp_complex);
    tmp = zeros(N/2,1);
    tmp(1:size(freqs',1),1) = amp_complex_crested;
    u = ifft(tmp,N,'symmetric');
    u = u / std(u);
    u = u - mean(u);