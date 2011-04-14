clear all; close all; clc;

n = 200; m = 6;
v = linspace(3,8,m);
omega = logspace(-4,1,n);

resp = zeros(n,m);


for j = 1:m

    % System subject to control
    sys = tf(bikesys(v(j)));
    s   = tf('s');
    Yc{j}  = sys(1,2);

    % Crossover frequency
    omega_c = pi;

    % Parameter estimation
    theta0 = ones(3,1);
    theta  = lsqnonlin(@(theta)errorfunc(theta,Yc{j},omega_c),theta0);

    %% Results:

    % Parameters
    Kp(j)     = theta(1);
    T_lead(j) = theta(2);
    T_lag(j)  = theta(3);

    % Constraints
    T_mlag = 0.1;
    tau    = 0.2;
    Ycon   = 1/(T_mlag*s+1)*exp(-s*tau);

    % Human controller
    Yp{j}  = Kp(j)*(T_lead(j)*s+1)/(T_lag(j)*s+1)*Ycon;
    Yol{j} = ss(Yp{j}*Yc{j});
    Ycl{j} = Yol{j}/(1 + Yol{j});
    
    tmp = freqresp(Yol{j},omega); resp(:,j) = squeeze(tmp);
    
end


%% Data visualization

% Bode diagram
close all; figure;
subplot(2,1,1);
loglog(omega,abs(resp));
subplot(2,1,2);
h = semilogx(omega,180/pi*unwrap(angle(resp)));
legend(h,num2str(v'),4);
xlabel('\omega [rad/s]');
% ylabel('ph'
sdf('Latex');

