function [U,Y] = simfunction(modelname,sys,t,u,N,M)

% Simulation
I = [1 1; 1 -1];

Y = zeros(2,2*M,N);
for i = 1:M
    for j = 1:2
        keyboard;
        var = [t u*I(:,j)']; %#ok<NASGU>
        sim(modelname);  % call simulink model
        Y(:,2*(i-1)+j,:) = reshape(yout.signals.values,2,1,N);
        U(:,2*(i-1)+j,:) = reshape(u*I(:,j),2,1,N);
    end
end