function H = H_mimo(X,f)
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
%    x1         1        b0
%    x2         0        b1
%    x3         0        b2
%    x4         0        b3
%  
% c = 
%             x1       x2       x3       x4
%    y1        0      c12      c13      c14
%    y2        0      c22      c23      c24
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
    b0 = X(5);
    b1 = X(6);
    b2 = X(7);
    b3 = X(8);
    
    % B-matrix
    c12 = X(9);
    c13 = X(10);
    c14 = X(11);
    c22 = X(12);
    c23 = X(13);
    c24 = X(14);
    
    a = [
           0        0        0      -a0;
           1        0        0      -a1;
           0        1        0      -a2;
           0        0        1      -a3;
    ];
 
    b = [
               1       b0;
               0       b1;
               0       b2;
               0       b3;
    ];

    c = [
               0 c12 c13 c14;
               0 c22 c23 c24;
    ];
 
    sys = ss(a,b,c,zeros(2));
    H = freqresp(sys,2*pi*f);
    
end