function u = crested_signal(freqs,fs,T)
% function u = crested_signal(freqs,fs,T)
% 
% sign
% 

    t       = (0:1/fs:T-1/fs)'; % Time vector [s]
    N       = length(t); % Number of samples [-]
    f       = (0:N-1)' / T; % Frequency vector [Hz]

    %% Multisine without cresting (random phase)
    % Use msinprep() right away, no msinclip() needed.
    % Make a random phase vector
    phase = 2*pi*rand(size(freqs));
    % Make an amplitude vector, all ones.
    amp = ones(size(freqs));
    % Make a single complex amplitude vector
    amp_complex = amp.*exp(phase*1j);
    % Make the time-domain signal from the complex amplitude vector.
    msin_nocrest = msinprep(freqs, amp_complex, N, fs);
    % Determine crest factor
    cf_nocrest = max(abs(msin_nocrest)) / sqrt(mean(msin_nocrest.^2));

    %% Make the same multisine, but now WITH cresting
    % Crest the multisine. The result (cx) is a new complex amplitude
    % vector which has the phase optimized for a low crest factor,
    % while amplitudes remain the same.
    cx = msinclip(freqs, amp_complex);
    % Make a time signal from the complex amplitude vector.
    msin_crest = msinprep(freqs, cx, N, fs);
    % Determine crest factor
    cf_crest = max(abs(msin_crest)) / sqrt(mean(msin_crest.^2));

    u = msin_crest;
%     %% Plot results (time)
%     figure
%     plot(t, msin_nocrest, 'b'); hold on
%     plot(t, msin_crest, 'r')
%     xlabel('time [s]')
%     ylabel('y [-]')
% 
%     legend({['no cresting, CF=', num2str(cf_nocrest)],['cresting,CF=', num2str(cf_crest)]})
%     title('More compacted signal when crested.')
% 
%     %% Plot results (specral densities)
%     figure
%     semilogx(f, abs(fft(msin_nocrest)).^2, 'b'); hold on
%     semilogx(f, abs(fft(msin_crest)).^2, 'r--')
%     xlim([1/T fs/2])
%     xlabel('frequency [Hz]')
%     ylabel('Syy [-]')
%     legend({'no cresting','cresting'})
%     title('No change in power contents when cresting!')
end


