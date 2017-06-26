classdef GPR
    
    % GPR a class definition for storing Ground Penetrating Radar data and
    % performing basic processing
    
    %   Class properties:
    %   Amplitude - The amplitude data for each trace
    %   Distance - The distance of each trace along the x axis (m)
    %   Time - Defines each time point on the y axis where amplitude data
    %   is sampled (ns)
    %   nTraces - total number of traces
    %   t0 - first recorded time usually 0 ns
    %   tend - last recorded time point in y axis. Also called range.
    %   tracespace - spacing between each trace
    %   Filename - name of the current working file without an extention
    
    %class properties are defined in the scripts radarviewnew.mat
    %and ekko2mat.mat which read in GPR data from header files and create
    %objects called "filename" saved under their respective input file
    %names
    
    %when a method is executed the resulting output is saved to a new
    %folder of the same name as the procesing method and the processing
    %method is appended to the file name. This is done to make multi step 
    %processing more easily facilitated. The user can load in data, perform
    %processing step 1, load the newly created object in the "Processing
    %step 1" folder, and then continue applying different steps.
    
    properties
        Amplitude
        Distance
        Time
        nTraces
        t0
        tend
        tracespace
        Filename
        DataDir
    end
    
    methods
        
        
        
        
        
   %----------------------------------------------------------------------%
      %displaydata: Displays data after running read in scripts. Saves
      %output as "raw"
        
        function displaydata(filename)
%              figure;
            imagesc(filename.Distance,filename.Time,filename.Amplitude); colormap(gray);
            ylim([filename.t0, filename.tend]);
            xlabel('Distance (m)');
            ylabel('Two-way Travel Time (ns)');
            
            
            %%%%%%%%%%%%% in case changes dont work%%%%%%%%%
%             fs = filesep;
%             filepath = filename.DataDir;
%             
%             %Datapath = strcat([filepath fs 'Data']);
%             
%             
%              Savepath = strcat([filepath fs 'Raw_Data']);
%              
%                 if exist(Savepath,'dir')
%                     save([Savepath fs,filename.Filename],'filename');
%                         else mkdir (Savepath)
%                             save([Savepath fs ,filename.Filename],'filename');
%                 end
                %%%%%%%%%% in case changes dont work%%%%%%%
                
                
                
                

        end    
        
        
        
        
        
 %----------------------------------------------------------------------%       
    %AGCobj: Automatic Gain Control method. Applies an AGC style gain to
    %a radargram based on user defined inputs for window size and maximum
    %AGC value
        
        
        function AGCobj(filename,agcwindow,agcmax)
% In GUI these parameter should be filled by user and should be input for the function            
%             agcwindow=input('enter the agc window')
%             agcmax=input('enter the agc maximum')
            
           
            
            % Convert AGC window from time to number of points in trace
            %dt=0.8;                     % 0.8 ns = 800 pts, sampling interval. 
            %%is this a standard fact? what is this based on???
            dt=filename.Time(2)-filename.Time(1);
            
            np = round(agcwindow/dt);
            Data = filename.Amplitude';                  % transpose matrix
            
            % find rms of data on whole line 
            Data2 = Data.^2;
            Datamean = mean(mean(Data2));
            Datamean = Datamean^0.5;
            [nx,nt]=size(Data);          % get size of matrix
        
            inn=[fliplr(Data(:,1:np)) Data fliplr(Data(:,nt-np:nt))]; % inn = original array with np mirrored columns on left,
                                                                  %  np+1 mirrored columns added to right 
            % each element is squared                                                       
            inn=inn.^2;
            f=ones(np,1)/np;
            % convolved with np points to left (WHY?)
            out=conv2(inn,f');
            % output offset array, so that convolution is centered about 
            % point in input array
            start=round(np+np/2); 
            endd=start+nt-1;
        
            outt=out(:,start:endd);                                 % this array contains the average of
            % all squared values in the window of width np
            
            Gain=Datamean./(sqrt(outt)+0.000001);

            % To set gain max at any value to agcmax, create array 
            % filled with values of agcmax ,
            % then find the max of this array and Gain
    
            Gmax = ones(nx,nt)*agcmax;
            Gain=min(Gain, Gmax);
            % apply gain to data  
            Dataagc=Data.*Gain;
            Aagc = Dataagc';
%-----------------Display original and gained data------------------------
%             figure;
% % % % %             subplot(2,1,1); imagesc(filename.Distance,filename.Time,filename.Amplitude); colormap(gray);
% % % % %             ylabel('time (ns)'); title('AGC: original');
% % % % %             subplot(2,1,2);
            imagesc(filename.Distance,filename.Time,Aagc); colormap(gray);
            ylim([filename.t0, filename.tend]);
            xlabel('position (m)'); ylabel('time (ns)'); title('with AGC');
        
%-----------------Display a sample original and gained trace------------------------
%             figure;
%             plot(filename.Time,filename.Amplitude(:,nx),'k'); hold on; plot(filename.Time,Aagc(:,nx),'r');
%             xlabel('time (ns)'); ylabel('amplitude'); legend('original','AGC gain');
%             ylabel('amplitude'); title('AGC: sample trace');
%             xlim([min(filename.Time) max(filename.Time)]);

%------for saving, call arrays A and t again------------------------------
        %       size of output array increases, because values are converted
        %       from integer to floating point
        
            filename.Amplitude= Aagc;
            
           
                fs = filesep;
                filepath=filename.DataDir

                Savepath = strcat([filepath fs 'AGC']);
             
                if exist(Savepath,'dir')
                    %save([Savepath fs,filename.Filename],'RecXProf','PickTime','ShotXProf');
                    save([Savepath fs,filename.Filename,'_AGC'],'filename');
                        else mkdir (Savepath)
                            %save([Savepath fs ,filename.Filename],'RecXProf','PickTime','ShotXProf');
                            save([Savepath fs ,filename.Filename,'_AGC'],'filename');
                end
        end 
        
        
        
        
        
        
        
     %----------------------------------------------------------------------%   
     %Dewow: Removes the median trace of the entire radargram from each
     %trace
        
        
        function Dewowobj(filename,windowSize)
            
%             windowSize=input('enter the window size')
            
            %--------------------apply median filter --------------------------------
            [nt nx] = size(filename.Amplitude);
            medianA = zeros(nt,nx);
                for ix=1:nx
                    medianA(:,ix) = medfilt1(filename.Amplitude(:,ix),windowSize);
                end
            Afilt = filename.Amplitude./medianA;
            
            %-----------------Display original and gained data------------------------
%             figure;
%             subplot(2,1,1); imagesc(filename.Distance,filename.Time,filename.Amplitude); colormap(gray);
%             ylabel('time (ns)'); title('original');
            imagesc(filename.Distance,filename.Time,Afilt); colormap(gray);
            ylim([filename.t0, filename.tend]);
            xlabel('position (m)'); ylabel('time (ns)'); title('dewowed');
            
            %------for saving, call arrays A and t again------------------------------
            filename.Amplitude= Afilt;
            
            fs = filesep;
            filepath=filename.DataDir;
            
             Savepath = strcat([filepath fs 'Dewow']);
             
                if exist(Savepath,'dir')
                    %save([Savepath fs,filename.Filename],'RecXProf','PickTime','ShotXProf');
                    save([Savepath fs,filename.Filename, '_Dewow'],'filename');
                        else mkdir (Savepath)
                            %save([Savepath fs ,filename.Filename],'RecXProf','PickTime','ShotXProf');
                            save([Savepath fs ,filename.Filename, '_Dewow'],'filename');
                end
            
        end
        
        
        
        
        
        
        
   %----------------------------------------------------------------------% 
   %SECobj: Applies a SEC style gain to the radargram
         
            
            function SECobj(filename)
                
                secdBperm=input('just put something here');
                secvel=input('numbers please');
                secmax=input('what do these mean?');
                
            [nt nx] = size(filename.Amplitude);
            Asec = filename.Amplitude;
            gain = zeros(nt);

                for it = 1:nt
                    if filename.Time(it) >=0
                        dist=secvel*filename.Time(it);
                        fac=dist*secdBperm/10;
                        gain(it)=10.^fac;
                            if gain(it) > secmax
                                gain(it) = secmax;
                            end
            Asec(it,:)=Asec(it,:)*gain(it);
                end
        end

        %trace balancing in rms sense
        %do this trace by trace
        %get rms average of first trace
        Ax2 = Asec(:,1).*Asec(:,1);
        M1=sqrt(mean(Ax2));
    
        for ix = 2:nx
            Ax2 = Asec(:,ix).*Asec(:,ix);
            M=sqrt(mean(Ax2));
            balance_fac = M1/M;
            Asec(:,ix)=Asec(:,ix)*balance_fac;
        end

        figure;
%         subplot(2,1,1); imagesc(filename.Distance,filename.Time,filename.Amplitude); colormap(gray);
%         ylabel('time (ns)'); title('original');
         imagesc(filename.Distance,filename.Time,Asec); colormap(gray);
         ylim([filename.t0, filename.tend]);
        xlabel('position (m)'); ylabel('time (ns)'); title('with SEC');
   
%-----------------Display a sample original and gained trace------------------------
%         figure;
%         subplot(2,1,1); plot(filename.Time,gain); xlabel('time (ns)'); ylabel('gain');
%         xlim([min(filename.Time) max(filename.Time)]); title('sec: sample trace gain');
%         subplot(2,1,2); plot(filename.Time,filename.Amplitude(:,nx),'k'); hold on; plot(filename.Time,Asec(:,nx),'r');
%         xlabel('time (ns)'); ylabel('amplitude'); legend('original','sec gain');
%         ylabel('amplitude'); 
%         xlim([min(filename.Time) max(filename.Time)]);

        %for saving, call arrays A and t again
        filename.Amplitude= Asec;
        
            fs = filesep;
            filepath=filename.DataDir;
        
         Savepath = strcat([filepath fs 'SEC']);
             
                if exist(Savepath,'dir')
                    %save([Savepath fs,filename.Filename],'RecXProf','PickTime','ShotXProf');
                    save([Savepath fs,filename.Filename, '_SEC'],'filename');
                        else mkdir (Savepath)
                            %save([Savepath fs ,filename.Filename],'RecXProf','PickTime','ShotXProf');
                            save([Savepath fs ,filename.Filename,'_SEC'],'filename');
                end
        
            end
        
            
            
            
            
            
    %----------------------------------------------------------------------% 
    %user defines distance, twtt, and possible material dielectric to match
    %a plotted hyperbola to one seen in the radargram. output is a measure
    %of radar velocity in the specified meterial
            
            
   function [velocity,depth]=Hyperbola_Drawing_obj(filename,dielectric)

        %%%%Hyporbola Drawing
        %allows user to define the position of a hyperbola and then vary the
        %dielectric to match the shape of its limbs outputting the material
        %dielectric and velocity 
        
        %input: filename
        %       Dielectric constant 
        %output: Material Velocity(cm/ns) 
        %        Hyperbola depth(m) 

        imagesc(filename.Distance,filename.Time,filename.Amplitude); colormap(gray);
        ylim([filename.t0, filename.tend]);
        xlabel('Distance (m)');
        ylabel('Two-way Travel Time (ns)');
            
        %figure;
        %plot(filename.Distance,filename.Time,filename.Amplitude); colormap(gray);
        %hold on
        %%%%%%%%
        %user defines apex height. 

        [ex AH]=ginput(1);
        %AH= 52 %apex height in ns. select using ginput
        %ex=4; %x position of reflector in x axis. select using ginput
 
%         DEC= 15 %dielectric constant
        DEC = dielectric; %dielectric constant
        
        %defined at first by script. 
        v=0.3/sqrt(DEC); % defined in script by auto use of 15
 
        %calculated in script after x and AH prompt
        DD= 0.3/sqrt(DEC)*AH;
 
        EX= [ex-4:0.2:ex+4]; %locations of data points along X
 
        R1= []
        T=[]
            for EX1=EX
   
                R= sqrt((EX1-ex).^2+DD^2);
                R1=[R1 R]
                T=R1/v
            end
 
        %hold on

%         figure
%         imagesc(filename.Distance,filename.Time,filename.Amplitude); colormap(gray); hold on;
        hold on; scatter(EX,T,'filled');
        % figure;
VV=v*100;

% comment because of showing in GUI
%         GG='Hyperbola Depth in m';
%         WP='Velocity of this material in cm/ns';
%         disp (GG);
%         disp (DD/2);
%         disp (WP);
%         disp (VV);
        velocity = VV;
        depth = DD/2;
        
          hold on;
         plot (EX, -T, 'yo', 'markersize', 6,'markerfacecolor',[.4 .7 .0]);        
                
    end
    
    
    
   %----------------------------------------------------------------------% 
   %T0shifts_obj: shifts the radargram twtt upwards by a user specified
   %amount to show first recorded reflections as "true" time zero.
    
    
    function T0shifts_obj(filename,tsh)
        
        
        % S Kruse March 2007
%----------------------------parameters---------------------------------
%   nshifts = number of zones that need time zero shifts
%   tshifts = array with nshift rows and 3 columns
%            each row looks like [xshmin  xshmax  tsh]
%            xshmin -> xshmax = range of zone that will be shifted
%            tsh = time that zone will be shifted, negative upwards

%-------------------------Load data file---------------------------------%
dt = filename.Time(2)-filename.Time(1);
nt = length(filename.Time);
Ash = filename.Amplitude;
xshmax=max(filename.Distance);
xshmin=min(filename.Distance);
% I need to comment this becuase this value should enter as a input in GUI
% tsh=input('negative number of how much you want the radargram to shift up');
%---------------------apply shifts and plot ---------------------------%
     jsh = round(-1*tsh/dt);
     [xmin,ishmin]=min(abs(filename.Distance-xshmin));
     [xmax,ishmax]=min(abs(filename.Distance-xshmax));
     if jsh > 0
         Ash(1:nt-jsh,ishmin:ishmax)=filename.Amplitude(jsh+1:nt,ishmin:ishmax);
         Ash(nt-jsh+1:nt,ishmin:ishmax)=0;
     else
         Ash(-1*jsh+1:nt,ishmin:ishmax)=filename.Amplitude(1:nt+jsh,ishmin:ishmax);
         Ash(1:-1*jsh-1,ishmin:ishmax)=0;
     end
    
    
%     figure;
      imagesc(filename.Distance,filename.Time,Ash); colormap(gray);
      ylabel('time (ns)'); xlabel('after');
      xlim([max(min(filename.Distance),xshmin-3) min(max(filename.Distance),xshmax+3)]);
      ylim([filename.t0, filename.tend+tsh]);
       

%------------------write out data with shifts---------------------------
filename.Amplitude = Ash;
newtime=filename.tend+tsh;
filename.tend=newtime;
%save(outfile,'A','x','t');

               fs = filesep;
            filepath=filename.DataDir;

                Savepath = strcat([filepath fs 'Time_Zero']);
             
                if exist(Savepath,'dir')
                    %save([Savepath fs,filename.Filename],'RecXProf','PickTime','ShotXProf');
                    save([Savepath fs,filename.Filename,'_TimeZero'],'filename');
                        else mkdir (Savepath)
                            %save([Savepath fs ,filename.Filename],'RecXProf','PickTime','ShotXProf');
                            save([Savepath fs ,filename.Filename,'_TimeZero'],'filename');
                end
    end
 

    
    end   
    
    
    
    
    
    
end

