function e = errorfun(Xn,t,delta,z0,X0)    

X = Xn.*X0;

% ODE simulation
options = odeset('Events',@eventfun,'AbsTol',1e-2); % stop at y =0
z = zeros(size(t,1),2);
[t,z_tmp] = ode45(@(t,z)odefun(t,z,X),t,z0,options);

z(1:length(z_tmp),:) = z_tmp;
% Error defintionrr

% e = 1/size(t,1)*sum((z(:,1)-delta).^2);
e = z(:,1)-delta;

%disp([sum(e.^2),X,length(t),length(e)]);

% % Plotting
% close all;
% title('Steering angle'); hold on; box on;
% h(1) = plot(t,delta,'k');
% h(2) = plot(t,z(:,1),'r');
% sdf('Latex');
% xlabel('Time [s]');
% ylabel('\delta [rad]');
% legend(h,'Measured','Simulated');
% pause;