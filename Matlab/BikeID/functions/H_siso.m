function H = H_zpk(X,f)
% function H = sys_model(X,f)
% X: parameters
% f: frequencies
%
% Zero/pole/gain:
%       k (s+z1) (s+z2)
% -----------------------------------------
% (s+p1) (s+p2) (s^2 + x1*s + x0)

    k  = X(1);
    z1 = X(2);
    z2 = X(3);
    p1 = X(4);
    p2 = X(5);
    x1 = X(6);
    x0 = X(7);
    
    s = 1j*f*2*pi;
    
    H = k.*(s+z1).*(s+z2)./((s+p1).*(s+p2).*(s.^2 + x1.*s + x0));
    
end