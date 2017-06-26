% function [RecXProf,T] = picktimes(theSeisObj)
function picktimes(theSeisObj)
    %picktimes A routine for picking first arrivals in a seismic trace.
    %   
    %With this picking routine, the user will be given three opportunities
    %to pick the first arrivals on a set of geophones.
    %
    %1) On the wiggle plot created when the data file is first read in.
    %Click on each first arrival and hit enter when done making all the
    %picks. These picks will not be saved but will be shown on the
    %individual traces for comparison.
    %
    %2) On individual plots of each trace. For geophone 1, you will only
    %be shown the trace for that geophone but on all subsequent
    %geophones, you will see the trace for that geophone in the bottom
    %panel as well as the trace from the geophone before it. ONLY click
    %on the first arrival in the bottom panel.
    %
    %Carefully assess each trace clicking on the first arrival with the
    %left mouse button if you would like to save the first arrival or with
    %the right mouse button anywhere on the trace if you are not
    %comfortable with making a pick on this trace
    %
    %3) When all the picks are made on the individual traces, you will
    %be given a final opportunity to review the traces. A movie of the
    %trace picks will appear along with a dialog box. Carefully scroll
    %through the picks making a note of any traces that you would like
    %another opportunity to review (the frame number in the lower right
    %hand corner of the movie corresponds to the channel number). Type in
    %the each channel that you would like to review separated by a space or
    %click ok if you are happy with your picks. 
    %
    %The picks will automatically be saved to a file with the same stem as
    %the input file used for making the first arrival picks. The dialog box
    %also gives you the opportunity to save the movie of your picks; the
    %movie is not saved by default!!!!
    
    %setup path to save the results of the picking routine
    fs = filesep;
    filepath = pwd;
    
    Savepath = strcat([filepath fs 'Seismics' fs 'Processed_files']);

     if ishandle(1) && strcmp(get(1, 'type'), 'figure')
         figure(1);
       uiwait(msgbox(['Pick ALL first breaks now. Make a selection on every trace' ...
            ,'; use the left mouse button for "good" picks and the right' ...
            ' mouse button if you are unsure. Press enter when done picking on all traces']))
%         uiwait(msgbox('pick ALL first breaks now, press enter when done'))
        [X,F,button] = ginput;
%         X = round(X);
        X = MatchPicks(X,theSeisObj.RecXProf);
        [X,I] = sort(X);
        F = F(I);
        button = button(I);
     else 
        plot(theSeisObj,'clipped')
        uiwait(msgbox(['Pick ALL first breaks now. Make a selection on every trace' ...
            ,'; use the left mouse button for "good" picks and the right' ...
            ' mouse button if you are unsure. Press enter when done picking on all traces']))
%         uiwait(msgbox('pick ALL first breaks now, press enter when done'))
        [X,F,button] = ginput;
%         X = round(X);
        X = MatchPicks(X,theSeisObj.RecXProf);
        [X,I] = sort(X);
        F = F(I);
        button = button(I);
        
    end
    hold on;
    b = find(button==1);
    plot(X(b),F(b),'b+');
    
    %create a modified vector of data points so that all the waveforms do
    %not need to be selected
    
    f2 = ismember(theSeisObj.RecXProf,X);
    n = find(f2==1);
    
    F2 = 300*ones(length(theSeisObj.RecXProf));
    X2 = 300*ones(length(theSeisObj.RecXProf));
    
    
    for i = 1:length(X)
        F2(n(i)) = F(i);
        X2(n(i)) = X(i);
    end

    % quality control of picks
    % check that red line alligns with first break of each wiggle
    %             T = T*theSeisObj.SamplingInt(1)*1000;

    %create a plot of the individual traces for reselecting
    %first motions
    uiwait(msgbox('Please repick first breaks'))
    scrsz = get(0,'ScreenSize');
    t = theSeisObj.RecTime;
    traces = theSeisObj.W;
    Traces = traces(1:theSeisObj.NumSamples,:);



    %The filtered trace is not being plotted at the moment
    %because I found that it is sometimes accidentally selected
    %instead of the actual trace which results in an error.
    T =zeros(length(theSeisObj.Channels),1);
    button = zeros(length(theSeisObj.Channels),1);
    
    for index=1:numel(theSeisObj.Channels)
        f = figure('Position',[1 1 scrsz(3)*0.9 scrsz(4)*0.9], 'Visible','off');
        %                 plot(t, TRnorm(:,index), 'b');
        ax = axes('Units','pixels');
        normTrace(:,index) = Traces(:,index)/max(Traces(:,index));
    tmin = min(normTrace(:,index));
    tmax = max(normTrace(:,index));
    %swap min and max values for normalizing the traces
    Tmin = tmax*-1;
    Tmax = tmin*-1;
        if index==1
            plot(t, (-1*Traces(:,index))/max(Traces(:,index)), 'k');
            hold on;
            plot([F2(index) F2(index)],[1 -1], 'r');
%             plot([F(index) F(index)],[1 -1], 'r');
            title(['Shot at ',num2str(theSeisObj.ShotXProf),...
                ' m and geophone at ',num2str(theSeisObj.RecXProf(index)),' m'])
            xlim([0 200])
            xlabel('Time (ms)')
            ylabel('Normalized Trace Amplitude')
            legend('Normalized Trace','Original Pick')
            PicksUI(Tmin,Tmax,ax);
             f.Visible ='on';
             
             %activate the keep pick or change pick button
             waitfor(f,'Name');
%             
            if strcmp(f.Name,'1');
                T(index) = F2(index);
                button(index) = 1;
            else
            [T(index),~,button(index)]=ginput(1);
            end
            plot([T(index) T(index)],[1 -1], 'c', 'linewidth',2)
            M(index) = getframe(gcf);
            close
            clear f;
        else
            subplot(2,1,1)
            plot(t, (-1*Traces(:,index-1))/max(Traces(:,index-1)), 'k');
            hold on;
            plot([F2(index-1) F2(index-1)],[1 -1], 'r');
%             plot([F(index-1) F(index-1)],[1 -1], 'r');
            title(['Previous Trace; Geophone at ', ...
                num2str(theSeisObj.RecXProf(index-1)),' m'])
            xlim([0 200])
            xlabel('Time (ms)')
            ylabel('Normalized Trace Amplitude')
            plot([T(index-1) T(index-1)],[1 -1], 'c', 'linewidth',2);
            legend('Normalized Trace','Original Pick','New Pick')
            
            h = subplot(2,1,2);
            plot(t, (-1*Traces(:,index))/max(Traces(:,index)), 'k');
            hold on;
            plot([F2(index) F2(index)],[1 -1], 'r');
%             plot([F(index) F(index)],[1 -1], 'r');
            title(['Shot at ',num2str(theSeisObj.ShotXProf),...
                ' m and geophone at ',num2str(theSeisObj.RecXProf(index)),' m'])
            xlim([0 200])
            xlabel('Time (ms)')
            ylabel('Normalized Trace Amplitude')
            
            PicksUI(Tmin,Tmax,h);
            f.Visible = 'on';
            
            waitfor(f, 'Name');
            if strcmp(f.Name,'1');
                T(index) = F2(index);
                button(index) = 1;
            elseif strcmp(f.Name,'3');
                button(index) =3;
                T(index) = F2(index);
            else
                [T(index),~,button(index)]=ginput(1);
            end
            plot([T(index) T(index)],[1 -1], 'c', 'linewidth',2)
            legend('Normalized Trace','Original Pick','New Pick')
            M(index) = getframe(gcf);
            close
            clear f;
        end
    end

    %show picks
    RecXProf = theSeisObj.RecXProf;
    dt = theSeisObj.SamplingInt(1);
   
      
    %save the picks to a .mat file name using the same line number
    %as the original file.


    if numel(theSeisObj.FileNumber)==1
        filename = [num2str(theSeisObj.FileNumber),'_picks.mat'];

    else
        filename = [num2str(theSeisObj.FileNumber(1)),'_', ...
            num2str(theSeisObj.FileNumber(2)), '_picks.mat'];
    end

%     if strcmp('y',answer{1});
        f = find(button==1);
        RecXProf = RecXProf(f);
        PickTime =T(f);
        ShotXProf = theSeisObj.ShotXProf;
        
        %plot the new picks on the original trace figure as red
        %pluses on the original figure
        
        if ishandle(1) && strcmp(get(1, 'type'), 'figure')
           figure(1)
           plot(RecXProf, PickTime, 'r+')
        else
            plot(theSeisObj,'clipped');
            hold on
            plot(RecXProf, PickTime, 'r+')
        end
        
        
         %Give the user one last chance to verify their picks
    uiwait(msgbox('Please look carefully at the travel time curve to verify your picks'));
    g = figure('Position',[1 1 scrsz(3)*0.9 scrsz(4)*0.9], 'Visible','off');
    plot(RecXProf,PickTime,'g*');
    hold on
    plot(ShotXProf,min(PickTime),'xr','MarkerSize',30);
    xlabel('Geophone Position (m)');
    ylabel('First Arrival Time (ms)');
    DeletePicksUI()
    g.Visible = 'on';
    
    waitfor(g,'Name')
    if strcmp(g.Name,num2str(1));
%         close
%          clear g;
    else
        [Y,H] = ginput;
        Y = MatchPicks(Y,RecXProf);
        Y = sort(Y);
        
        [new_picks,IA] = setdiff(RecXProf,Y);
        RecXProf = new_picks;
        PickTime =PickTime(IA);
                
        cla(g)
        plot(RecXProf,PickTime,'*g');
        xlabel('Geophone Position (m)');
        ylabel('First Arrival Time (ms)');
        title({['File #', num2str(theSeisObj.FileNumber),'; ' ...
                        'Source Location =', num2str(theSeisObj.ShotXProf)]; ...
                        ['']}, 'FontWeight','bold');
        hold on;
        plot(ShotXProf,min(PickTime),'xr','MarkerSize',30);
    end
    
        
        if exist(Savepath,'dir')
            save([Savepath fs,filename],'RecXProf','PickTime','ShotXProf');
        else mkdir (Savepath)
            save([Savepath fs ,filename],'RecXProf','PickTime','ShotXProf');
        end
        
     close(g)   
       

end

