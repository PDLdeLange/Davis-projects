function H = H_mimo2(X,f)
% function H = sys_model(X,f)
% X: parameters
% f: frequencies
%
% a = 
%            x1      x2      x3      x4
%    x1       0       0       0     -a0
%    x2       1       0       0     -a1
%    x3       0       1       0     -a2
%    x4       0       0       1     -a3
%  
% b = 
%              u1        u2
%    x1       b11       b12
%    x2       b21       b22
%    x3       b31       b32
%    x4       b41       b42
%  
% c = 
%             x1       x2       x3       x4
%    y1        0        0        1        0
%    y2        0        0        0        1
%  
% d = 
%        u1  u2
%    y1   0   0
%    y2   0   0
 

    % A-matrix
    a0 = X(1);
    a1 = X(2);
    a2 = X(3);
    a3 = X(4);
    
    % B-matrix
    b11 = X(5);
    b21 = X(6);
    b31 = X(7);
    b41 = X(8);
    b12 = X(5);
    b22 = X(6);
    b32 = X(7);
    b42 = X(8);
       

    a = [
           0        0        0      -a0;
           1        0        0      -a1;
           0        1        0      -a2;
           0        0        1      -a3;
    ];

    b = [
          b11       b12
          b21       b22
          b31       b32
          b41       b42
    ];

    c = [
           0        0        1        0
           0        0        0        1
    ];

    d = [
          0   0
          0   0
    ];

    sys = ss(a,b,c,zeros(2));
    H = freqresp(sys,2*pi*f);

end