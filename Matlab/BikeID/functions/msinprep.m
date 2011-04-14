function [xtim,df]=msinprep(varargin)
%MSINPREP Generate time series from complex amplitudes (multisine).
%
%       [xtim,df]=MSINPREP(Fdat,N,fs,dev)
%
%       It is assumed that the frequencies are harmonically related, and an
%       integer number of periods is to be generated. The function can be
%       asked to introduce a predistortion to compensate a zero order hold.
%
%       Output arguments:
%       xtim = generated time series
%       df = calculated common divider of frequencies
%
%       Input arguments:
%       Fdat = the output of msinclip (fiddata object, or maybe a structure),
%          containing the frequency points and the complex Fourier amplitudes as input.
%       N = length of the time series. If it is not given or empty, it will
%           be defined as fs/df, where df is the maximal common divider of
%           frequencies in freqv
%       fs = sampling frequency. If it is not given, it will be chosen
%           as N*df, where df is the maximal common divider of the frequencies
%           in freqv. If N is not given, either, fs=df*2*(max(freqv)/df+1)
%       dev = device for which the series is prepared. Possibilities:
%           'screen': for plotting etc, no modification
%           'DAC': for D/A converter, the amplitudes will be predistorted by
%                the inverse tf of the zero order hold
%           default: type of the input of Fdat, if undefined then 'screen'
%                (no predistortion)
%
%       Usage: [xtim,df]=msinprep(Fdat,N,fs,dev);
%       Example: [cx,crestx]=msinclip(fiddata([],[],[1:15]'/256));
%                arbitgen=msinprep(cx,512,1);
%
%       See also: MSINCLIP, OPTEXCIT, CRESTMIN.

%Old fdident help
%MSINPREP Generate time series from complex amplitudes (multisine).
%
%       [xtim,df]=MSINPREP(freqv,cx,N,fs,dev)
%
%       It is assumed that the frequencies are harmonically related, and an
%       integer number of periods is to be generated. The function can be
%       asked to introduce a predistortion to compensate a zero order hold.
%
%       Output arguments:
%       xtim = generated time series (tiddata object)
%       df = calculated common divider of frequencies
%
%       Input arguments:
%       freqv = frequency vector, where the complex amplitudes are given
%       cx = vector of complex amplitudes: fft of xtim gives back cx values
%            at appropriate frequencies (approximately only for dev='DAC')
%       N = length of the time series. If it is not given or empty, it will
%           be defined as fs/df, where df is the maximal common divider of
%           frequencies in freqv
%       fs = sampling frequency. If it is not given, it will be chosen
%           as N*df, where df is the maximal common divider of the frequencies
%           in freqv. If N is not given, either, fs=df*2*(max(freqv)/df+1)
%       dev = device for which the series is prepared. Possibilities:
%           'screen': for plotting etc, no modification
%           'DAC': for D/A converter, the amplitudes will be predistorted by
%                the inverse tf of the zero order hold
%           default: 'DAC'
%
%       Usage: [xtim,df]=msinprep(freqv,cx,N,fs,dev);
%       Example: [cx,crestx]=msinclip([1:15]'/256,ones(15,1));
%                arbitgen=msinprep([1:15]'/256,cx,512,1,'DAC');
%
%       See also: MSINCLIP, OPTEXCIT.

%       Copyright (c) I. Kollar and Vrije Universiteit Brussel, ELEC, 1991-2003
%       All rights reserved.
%       $Revision: $
%       Last modified: 31-Aug-2003

Fdat=varargin{1};
if isa(Fdat,'fiddata')|isstruct(Fdat) %new call
  error(nargchk(1,4,nargin))
  ch=Fdat.InputCharacter;
  if any(strmatch(ch,{'BL','Samples','Discrete'}))
    dev='screen'; %no predistrotion
  elseif strcmp(ch,'ZOH')|strcmp(ch,'FOH')
    dev='DAC';
  else
    dev='';
  end
  if (nargin>=4)&~isempty(varargin{4}), dev=varargin{4}; end
  if isempty(dev), dev='screen'; end
  if nargin<3, fs=[]; else fs=varargin{3}; end
  if nargin<2, N=[]; else N=varargin{2}; end
  cx=Fdat.Input;
  freqv=Fdat.FreqPoints;
else
  error(nargchk(2,5,nargin))
  if nargin<5, dev=''; else dev=varargin{5}; end
  if nargin<4, fs=[]; else fs=varargin{4}; end
  if nargin<3, N=[]; else N=varargin{3}; end
  cx=varargin{2};
  freqv=varargin{1};
  if isempty(dev), dev='DAC'; end
end
%
if length(freqv)~=length(cx), error('freqv and cx have different lengths'), end
[freqv,ind]=sort(freqv); freqv=freqv(:);
cx=cx(ind); cx=cx(:);
if any(freqv<0), error('freqv has negative element(s)'), end
freqvnz=freqv;
if freqvnz(1)==0, freqvnz(1)=[]; end
dfv=diff([0;freqvnz]);
if any(dfv==0), error('freqv must not contain equal elements'), end
%find common divider df
if isempty(N), remfnegl=max(freqv)/min(diff([0;freqvnz]))*eps*max(freqv);
elseif ~isempty(fs), remfnegl=fs/N/2;
else remfnegl=2*max(freqv)/N;
end
df=freqvnz(1);
if any(dfv<=0), error('freqv is not monotonously increasing'), end
while any(dfv>remfnegl)
  df0=df; df=min([df0;dfv]);
  dfv=sort(rem([df0;dfv],df));
  if isempty(N), remfnegl=max(freqv)/df*eps*max(freqv); end
  ind=find(dfv<=remfnegl); dfv(ind)=[];
end
fi=round(freqv/df); %harmonic numbers
if max(fi)>1023,
  warning(sprintf(['Maximum harmonic index found in ''msinprep''\n',...
            '   is %.0f, with df = %.3g Hz, T = %.3g s'],max(fi),df,1/df))
  if max(fi)>1e4
    disp('Large indexes are often due to inaccurately given frequency values.')
    disp('If this is the case, before invoking msinprep do')
    disp('   freqv = round(freqv*T)/T;')
    disp('where T is the desired period length.')
    disp(' ')
  end
end
devii=fi*df-freqv; ddf=fi\devii;
if max(abs(fi*df-freqv))>max(abs(fi*(df+ddf)-freqv)), df=df+ddf; end
maxdev=max(abs(fi*df-freqv));
if maxdev>2*eps*max(freqv)*max(fi)
  warning(sprintf('Maximum deviation of i*df from fi is %.2e in msinprep',maxdev))
end
%
if isempty(N)&isempty(fs) %none of them is given
  fs=df*2*(max(freqv)/df+1); N=round(fs/df);
end
if isempty(fs)
  fs=N*df;
elseif max(freqv)>(1+N*eps)*fs/2
  error('max of freqv exceeds fs/2')
end
if isempty(N)
  N=round(fs/df);
elseif N<(1-N*eps)*round(fs/df)
  error(sprintf('N (%.0f) must be at least %.0f for one period',...
      N,round(fs/df)))
end
N=round(N);
if abs(rem(df/(fs/N)+0.5,1)-0.5)>1e3*eps*N
  pno=N/(fs/df); digno=ceil(-log10(abs(rem(pno+0.5,1)-0.5)))+1;
  warning(sprintf(['The N (%.0f) samples cover %.',int2str(digno),'f'...
       ' periods,\n   this is not an integer number'],N,N/(fs/df)))
end
%
if strcmp(dev,'DAC') %precompensation for zero order hold
  tf=exp(-j*pi*freqv/fs).*sin(pi*freqv/fs+eps)./(pi*freqv/fs+eps);
  cx=cx./tf;
elseif strcmp(dev,'screen')|isempty(dev)
  %nothing to do
else
  error(['dev ''',dev,''' unknown'])
end
%
hno=round(freqv/(fs/N)); %harmonic numbers
Xk=zeros(N,1); Xk(hno+1)=2*cx; Xk(1)=Xk(1)/2; xtim=real(ifft(Xk));
if isa(Fdat,'fiddata')
  xtim=tiddata([],xtim,1/fs);
  if strcmp(dev,'screen'), xtim.inputcharacter='BL'; end
end
%%%%%%%%%%%%%%%%%%%%%%%% end of msinprep %%%%%%%%%%%%%%%%%%%%%%%%

function message = oldhelp(mfile,opt)
%OLDHELP MFILE  displays the help on the old call form of fdident functions

%       Copyright (c) I. Kollar and Vrije Universiteit Brussel, ELEC, 1996-2000
%       All rights reserved.
%       $Revision: $
%       Last modified: 09-Dec-2000

if nargin==0, mfile=''; end
if nargin<2, opt=''; end
if isempty(mfile)
  help oldhelp
  return
elseif isempty(opt)&any(strmatch(mfile,...
    {'crestmin'}))
  %Just <funcname> oldhelp
  feval(mfile,'oldhelp')
  return
end
if isstr(mfile)&(length(mfile)>0)&isstr(opt)&(length(opt)>0)&~strcmpi(opt,'date')
  %help with option
  eval([mfile,' ',opt])
  return
end
mfilein=mfile;
perpos=find(mfile=='.');
if isempty(perpos), mfile=[mfile,'.m']; end
perpos=find(mfile=='.');
mfname=mfile(1:perpos(1)-1);
clear perpos
%
mfline=which(mfile);
if isempty(mfline)&isdir(mfilein)
  if strcmp(mfilein(end),filesep)|strcmp(mfilein(end),'\')|...
      strcmp(mfilein(end),'/')
    %mfilein(end)='';
  else
    mfilein=[mfilein,filsesep];
  end
  type([mfilein,'Contents.m'])
  return
end
if isempty(findstr(['fdident',filesep,'fdident',filesep,lower(mfile)],lower(mfline))) &...
    isempty(findstr(['fdident',filesep,'fddemos',filesep,lower(mfile)],lower(mfline))) &...
    isempty(findstr([filesep,'fd',filesep,lower(mfile)],lower(mfline))) &...
    isempty(findstr([filesep,'fdd',filesep,lower(mfile)],lower(mfline))) & ...
    ~strcmpi(opt,'date')
  if isempty(mfline), error(['Not fdident M-file: ',mfile]), end
  error(['Not fdident M-file: ',mfline])
end
%
[fid,errmess]=fopen(mfile,'r');
if fid==-1
  if exist(mfname)==5
    messagei=[mfname,' is a built-in function, no M-file available'];
    disp(messagei)
    if nargout>0, message=messagei; end
    help(mfile)
    return
  elseif exist(mfname)==1
    if strcmp(mfname,'mfile')|strcmp(mfname,'mfname')|...
        strcmp(mfname,'nargin')|strcmp(mfname,'nargout')|...
        strcmp(mfname,'fid')|strcmp(mfname,'errmess')
      messagei=['File ',mfile,': ',errmess];
    else
      messagei=[mfname,' is a built-in variable, no help M-file available'];
    end
    disp(messagei)
    if nargout>0, message=messagei; end
    return
  elseif exist(mfname)==0
    c=computer;
    pathsep = ':'; %Unixpath separator character
    dirsep = '/'; %Unix directory separator character
    if strcmp(c(1:2),'PC')
      pathsep = ';'; dirsep = '\';
    elseif strcmp(c(1:2),'MA')
      pathsep = ';'; dirsep = ':';
    elseif strncmp(version,'5.',2)
      if isvms pathsep = ','; dirsep='.'; end
    end
    ps=[pathsep,path,pathsep];
    ind=find(ps==pathsep);
    dirfound=0;
    for i=2:length(ind)
      if ind(i)>length(mfname)
        if strcmp(ps(ind(i)-[length(mfname):-1:1]),mfname)
          dirfound=1;
          break
        end
      end
    end %for i
    if dirfound==1
      messagei=[mfname,' is not an M-file, it is a directory:',sprintf('\n'),...
          ps(ind(i-1)+1:ind(i)-1)];
    else
      messagei=[mfname,' does not exist in workspace of function OLDHELP'];
    end
    disp(messagei)
    if nargout>0, message=messagei; end
    return
  end
  disp(errmess)
  if nargout>0, message=str2mat(message,errmess); end
  return
end
%
filestr=fread(fid); fclose(fid);
filestr=setstr(filestr');
lfstr=length(filestr);
if lfstr==0, error(['File ',mfile,' is empty']), end
if strcmpi(mfname,'elis'), scanlen=14000;
else scanlen=7000;
end
filestrsh=filestr(1:min(scanlen,length(filestr)));
indcr=[find((filestrsh==13)|(filestrsh==10)),length(filestrsh)+1]; %cr or lf
helpbegind=1; %index of first character of help to scan for call forms
helpendind=0; %index of last character of help to scan for call forms
if strcmpi(opt,'date')
  %Look for the file 'Last modified:'
  ind=findstr('last modified:',lower(filestrsh)); fmod=15;
  if length(ind)>1, ind=ind(1); end
  if isempty(ind), ind=findstr('modified:',lower(filestrsh)); fmod=10; end
  if length(ind)>1, ind=ind(1); end
  if isempty(ind), ind=findstr('date:',lower(filestrsh)); fmod=6; end
  if length(ind)>1, ind=ind(1); end
  if ~isempty(ind)
    %ind=ind+fmod;
    indind=min(find(indcr>ind));
    inde=indcr(indind)-1;
    dstr=filestrsh(ind:inde);
    indd=find(dstr=='$'); if ~isempty(indd), dstr(indd)=''; end
    disp(dstr);
  end
  return
end
%
%We will look for the word '%' and 'function' or 'Old fdident help' as string
%We will also explore here the beginning and end of the help text
firstchar=findstr(filestrsh,['%','function']); %Different old version definition
if isempty(firstchar), firstchar=findstr(filestrsh,['%','Old fdident help']); end
nfdstr=['%','Old fdident help: same as now'];
if ~isempty(firstchar)&strcmp(filestrsh(firstchar(1)+[0:length(nfdstr)-1]),nfdstr)
  help(mfile), return
elseif ~isempty(firstchar)
  firstchar=firstchar(1);
else
  %disp(' ')
  %disp('Warning: Modified fdident help not found, regular help is invoked')
  help(mfile), return
end
%
fhc=min(find(filestrsh(firstchar+2:length(filestrsh))=='%'));
nextchi=firstchar+1+fhc; %first 'hidden' help character: % sign
fhc=nextchi;
%
nch=filestrsh(nextchi); cri=1; stopsig=0; inhelp=1; funfound=-1;
commentline=1;
while stopsig==0
  if ( (nch==' ') | ((nch>=9)&(nch<=13)) ) %blank character
    commentline=commentline-1;
    if (inhelp==1)&(commentline<=0), inhelp=0; helpendind=nextchi-1; end
    nextchi=nextchi+1;
    if nextchi<=lfstr
      if (nch==13)&(filestrsh(nextchi)==10) %cr-lf on PC
        nextchi=nextchi+1;
      end
    end
  elseif nch=='%'
    if helpbegind==1, helpbegind=nextchi+1; inhelp=1; end
    nextchi=indcr(min(find(indcr>nextchi)));
    commentline=2;
  else %general character, cycle has to stop
    stopsig=1;
  end
  %Prepare next cycle
  if (nextchi>length(filestrsh)-400)&(length(filestrsh)<length(filestr))
    filestrsh=filestr;
    indcr=[find((filestrsh==13)|(filestrsh==10)),length(filestrsh)+1]; %cr or lf
  end
  if nextchi<=lfstr
    nch=filestrsh(nextchi);
  else
    stopsig=1;
  end
end %while
if inhelp==1, helpendind=nextchi-1; end
%
helptext=filestrsh(fhc+1:helpendind);
if length(helptext)>1;
  ind=findstr(helptext,setstr([13,10]));
  for ii=length(ind):-1:1, helptext(ind(ii))=''; end
end
ind=[findstr(helptext,[setstr(13),'%']),findstr(helptext,[setstr(10),'%'])];
for ii=length(ind):-1:1, helptext(ind(ii)+[0,1])='\n'; end
ind=findstr(helptext,'%');
for ii=length(ind):-1:1
  helptext=[helptext(1:ind(ii)),helptext(ind(ii):length(helptext))];
end
fprintf(['\n',helptext,'\n'])
%
ci=findstr('Copyright',filestrsh);
bci=max(find(filestrsh(1:ci(1))=='%')); %begin index of copyright string
yi=min(findstr('odified',filestrsh(bci+1:length(filestrsh))))+bci;
if isempty(bci), return, end
eci=min([find(filestrsh(yi+[0:min(length(filestrsh)-yi,80)])==setstr(13)),...
    find(filestrsh(yi+[0:min(length(filestrsh)-yi,80)])==setstr(10))])+yi-2;
ctext=filestrsh(bci:eci);
%
ctextm=ctext;
%Fix strange bug
eol=find((ctext==setstr(13))|(ctext==setstr(10)));
for ii=1:length(eol)
  if ii==1, ctextm=ctext(1:eol(1)-1); cti=eol(1)+1;
  else
    if eol(ii)>eol(ii-1)+1
      ctextm=[ctextm,sprintf('\n'),ctext(cti:eol(ii)-1)]; cti=eol(ii)+1;
    else
      cti=cti+1;
    end
  end
end %for
if cti<=length(ctext), ctextm=[ctextm,sprintf('\n'),ctext(cti:length(ctext))]; end
ind=find(ctextm=='%');
ctextm(ind)='';
%disp(ctextm) %display copyright info
%
%End of oldhelp
