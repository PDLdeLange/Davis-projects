% Time and frequency signal generation
Ts      = 1/Fs;             % Sample period
T       = Ts*N;             % Measurement time
t       = linspace(0,T,N)'; % Time vector [s]
f       = (0:N-1)' / T;     % Frequency vector [Hz]
f       = f(2:N/2+1,:);    % "              " [Hz]