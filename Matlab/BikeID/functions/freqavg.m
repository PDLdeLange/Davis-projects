function [out] = freqAvg_ult(in,nrbands)
%
% function [out] = freqAvg(in,nrbands)
%
% Averages the input 'in' over the number of frequency bands 'nrbands'
% version: February 15, 2007

[m,n]   = size(in);

Nmod    = floor(m/nrbands);
tmp     = zeros(nrbands,Nmod);
out     = zeros(Nmod,n);

for i = 1:n;

    tmp(:)   = in(1:nrbands*Nmod,i);   % arrange the samples of 'in' in the elements of tmp.
    out(:,i) = mean(tmp,1).';          % average over columns and make it a vector

end


