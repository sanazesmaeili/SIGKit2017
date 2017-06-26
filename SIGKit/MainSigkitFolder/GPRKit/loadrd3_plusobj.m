function [A,twt]=loadrd3_copy(fname,varargin)
% loads an rd3 file... (requires the .rad file to be present)
% syntax: [A,twt]=loadrd3('prof4',[starttrace],[tracecount],[options]) 
%
% options: 'stack'... return the mean of the profile
%
% Aslak Grinsted 2002
%

% load details from .RAD file

fname=strrep(lower(fname),'.rd3','');

numargcount=size(varargin,2);
tracecount=inf;
starttrace=1;
stack=0;

l=1;
numargcount=size(varargin,2); %how many numeric arguments are there before the settings?
while (l<=size(varargin,2))
   a=varargin{l};
   if ischar(a)
      v=[];
      if (l<numargcount), numargcount=l-1; end
      %if ((l+1)<=size(varargin,2)), v=varargin{l+1}; end
      switch lower(a)
      case {'stack','s'}
          stack=1;
      end
   end
   l=l+1;
end
switch numargcount
case 2
    starttrace=varargin{1};
    tracecount=varargin{2};
end

format long

infos=rd3info(fname,'scans','samples','timewindow', 'distance interval', 'stop position');
sz=infos{2}; %
timewindow=infos{3};
distint=infos{4};
stoppos=infos{5};

timewindow = double(timewindow);

samplespc=timewindow/sz; 
samplespc=double(samplespc);

%xxx=0:samplespc:timewindow;

time=samplespc:samplespc:timewindow;

dist=0:distint:stoppos;
ntraces=size(dist);



%%%%%twt=((1:sz)'-1)*timewindow*1e-9/sz; %converting the time window to ns which isnt actually 
                                %needed for displaying the data and results in rounding errors 

%loads the rd3 file
fid=fopen([fname '.rd3'],'r');
if (starttrace>1)
   fseek(fid,(starttrace-1)*sz*2,0);
end

if (stack==0) 
    A=fread(fid,[sz tracecount],'short');
else
    blocksize=1+fix(1000000/sz); %number of traces to read at a time...
    
    A=zeros(sz,1);
    tracesread=0;
    while ((~feof(fid))&(tracesread<tracecount))
        B=fread(fid,[sz blocksize],'short');
        A=A+sum(B,2);
        tracesread=tracesread+size(B,2);
    end
    A=A/tracesread;
end
fclose(fid);
%A=reshape(A,sz,size(A,1)/sz);

%outfile=fname
%save(outfile,'scans','samples','timewindow');

        [path,shortname,ext] = fileparts(radarfile)

        filename=GPR;

        filename.Amplitude=A
        filename.Distance=dist
        filename.Time=time
        filename.nTraces=ntraces
        filename.t0=samplespc
        filename.tend=timewindow
        filename.tracespace=distint
        filename.Filename=shortname
        filename.DataDir=path
        
        
        fs=filesep;
        save ([filename.DataDir fs,filename.Filename,'.mat'], 'filename');
      
%      figure;
%       imagesc(dist,time,A); colormap(gray);

