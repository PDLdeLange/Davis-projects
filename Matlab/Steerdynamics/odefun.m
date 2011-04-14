function zd = odefun(~,z,X)

    delta = z(1);
    deltad = z(2);
    
    omega = X(1);
    zeta = X(2);
    
    if deltad > 1e-3;
        Fc = -X(3);
    elseif deltad < 1e-3;
        Fc = X(3);
    else
        Fc = 0;
    end
    
    deltadd = -2*omega*zeta*deltad -omega^2*delta + Fc;
   
    zd = [deltad;deltadd];