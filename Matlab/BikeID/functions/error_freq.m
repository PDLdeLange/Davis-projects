function e = error_freq(Xn,H,H_modfunc,gamma,f,X0)
% function e = error_freq(Xn,H,H_modfunc,gamma,f,X0)
% 
% e:            error vector in the frequency domian
% Xn:           normalized parameter vector
% H:            sys_id transferfunction
% H_modfunc:    function handle to modelled transferfunction

    X = Xn.*X0;
    H_mod = H_modfunc(X,f);

    e = sqrt(1./f).*squeeze(sum(sum(gamma.*abs(log(H./H_mod)),2),1));
    
end