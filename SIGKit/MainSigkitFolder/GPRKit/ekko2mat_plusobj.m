      %THIS ONE IS FOR PLAIN GPR FILES 
      function [A,x,t]=ekko2mat_plusobj(radarfile) 
      % 
      % EKKO2MAT syntax: [A,x,t]=ekko2mat('filename') 
      %                  where filename has no .hd/.dt1 extension 
      % 
      % This function reads a PulseEkko binary file into a MATLAB matrix, 
      % where A is the matrix, x is a horizontal position vector, and t 
      % is a time vector.  The filename should have no extension supplied. 
      % 
      % by James Irving, Rock Physics, UBC 
      % June, 1998 (M-File) 
      
       
 
      [path,shortname,ext] = fileparts(radarfile)
      
      
      headerfile=[radarfile '.hd']; 
      datafile=[radarfile '.dt1']; 
      [fph,msg]=fopen(headerfile,'rt');  % open ASCII header file 
      
      
      if fph==-1                         % display error if necessary 
         disp(msg) 
         return 
      end 
      while(~feof(fph))                  % read information from header 
         temp=fgets(fph); 
         if (strncmp(temp,'NUMBER OF TRACES   =',20)) 
            ntraces=sscanf(temp(21:length(temp)),'%d'); %number of traces
            
         end 
         if (strncmp(temp,'NUMBER OF PTS/TRC  =',20)) 
            nppt=sscanf(temp(21:length(temp)),'%d'); %number of points per trace
         end 
         if (strncmp(temp,'TIMEZERO AT POINT  =',20)) 
            zeropt=sscanf(temp(21:length(temp)),'%d'); %point of time 0?
            
         end 
         if (strncmp(temp,'TOTAL TIME WINDOW  =',20)) 
            window=sscanf(temp(21:length(temp)),'%d'); %window time length ie range?
            
         end 
      end 
      fclose(fph); 


      [fpd,msg]=fopen(datafile,'rb','l'); % open binary data file 
      if fpd==-1                          % display error if necessary 
         disp(msg) 
         return 
      end 
      for j=1:ntraces                     % read data from file into A and x 
         fseek(fpd,4,0); 
         x(j)=fread(fpd,1,'float32'); 
         fseek(fpd,120,0); 
         A(:,j)=fread(fpd,nppt,'int16'); 
      end 
      
     
      
      fclose(fpd); 
      sampint=round((window/(nppt-1)*10))/10;   % create vertical time vector t 
      tstart=(zeropt-1)*(-sampint); 
      tEnd=tstart+(nppt-1)*sampint; 
      t=linspace(tstart,tEnd,nppt);
      
      
       %thisgprobj='fiddlename'; %need to make a string of the file name
 filename=GPR; %need to save the file name as object
 
      filename.Amplitude=A;
      filename.Distance=x;
      filename.Time=t;
      filename.nTraces=ntraces;
      filename.t0=zeropt;      % zeropt;
      filename.tend= tEnd ;         % window;
      filename.DataDir=path;
      filename.Filename=shortname;
      
      
      fs = filesep;
save ([filename.DataDir fs,filename.Filename,'.mat'], 'filename');
      
      
      
      
      
      fs = filesep;
             filepath=filename.DataDir;
             Savepath = strcat([filepath fs 'Raw_Data']);
             
                if exist(Savepath,'dir')
                    %save([Savepath fs,filename.Filename],'RecXProf','PickTime','ShotXProf');
                    save([Savepath fs,filename.Filename],'filename');
                        else mkdir (Savepath)
                            %save([Savepath fs ,filename.Filename],'RecXProf','PickTime','ShotXProf');
                            save([Savepath fs ,filename.Filename],'filename');
                end
 
      
%       figure;
%       imagesc(x,t,A); colormap(gray);
      
      %outfile= 'filename'
      %save(outfile,'A','x','t');
      