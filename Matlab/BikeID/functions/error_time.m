function e = error_time(Xn,u,y,X0)
% function e = error_freq(Xn,H,H_modfunc,gamma,f,X0)
% 
% e:            error vector in the time domian
% Xn:           normalized parameter vector
% u:            input
% y:            output

    X       = Xn.*X0;    
    output  = H_bikeplusrider(u,X);
    y_mod   = output.y;
    
    e       = y - y_mod;
    
end