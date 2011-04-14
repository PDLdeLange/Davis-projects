function e = errorfunc(theta,Yc,omega_c)

% Parameters
Kp     = theta(1);
T_lead = theta(2);
T_lag  = theta(3);

s   = tf('s');

% Openloop TF
Yol = omega_c/s;

% Constraints
T_mlag = 0.1;
tau    = 0.2;
Ycon   = 1/(T_mlag*s+1)*exp(-s*tau);

% Human controller
Yp  = Kp*(T_lead*s+1)/(T_lag*s+1)*Ycon;

omega = 1j*linspace(pi*0.1,pi*10,20);

Yol_resp = freqresp(Yol,omega); Yol_resp = (squeeze(Yol_resp));
Yc_resp  = freqresp(Yc,omega);  Yc_resp  = (squeeze(Yc_resp));
Yp_resp  = freqresp(Yp,omega);  Yp_resp  = (squeeze(Yp_resp));

e = abs(Yol_resp) - abs(Yp_resp.*Yc_resp);



