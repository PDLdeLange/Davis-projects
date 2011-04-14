function sys = bikesys(v)

    %% Defining variables:
    
    % State: [phi, delta, phid, deltad]'
    
    parms.M0 = [  80.812100000000   2.323431426235;   2.323431426235  0.301265709342];
    parms.C1 = [   0.000000000000  33.773869475930;  -0.848234478256  1.706965397923];
    parms.K0 = [-794.119500000000 -25.739089291258; -25.739089291258 -8.139414705882];
    parms.K2 = [   0.000000000000  76.406208759656;   0.000000000000  2.675605536332];

    M = parms.M0;
    C = parms.C1*v;
    K = parms.K0+parms.K2*v^2;

    sysA = [zeros(2) eye(2); -M\K -M\C];
    sysB = [zeros(2); M\eye(2)];
    sysC = eye(4);

    sys = ss(sysA,sysB,sysC,0);

end