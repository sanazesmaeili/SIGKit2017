function  [theSeisObj,PickTime,RecXProf] = DeletePicksUI( theSeisObj,PickTime,RecXProf)
%DeletePICKUI Creates a push button in a figure so that the user can delete
%bad picks from their data file

%setup path to save the results of the picking routine
fs = filesep;
filepath = pwd;

Savepath = strcat([filepath fs 'Seismics' fs 'Processed_files']);
%save the picks to a .mat file name using the same line number
%as the original file.
if numel(theSeisObj.FileNumber)==1
    filename = [num2str(theSeisObj.FileNumber),'_picks.mat'];

else
    filename = [num2str(theSeisObj.FileNumber(1)),'_', ...
        num2str(theSeisObj.FileNumber(2)), '_picks.mat'];
end

%Give the user one last chance to verify their picks
scrsz = get(0,'ScreenSize');
uiwait(msgbox('Please look carefully at the travel time curve to verify your picks'));
close(findobj('type','figure','Tag','g'));
g = figure('Position',[1 1 scrsz(3)*0.9 scrsz(4)*0.9], 'Visible','off');
g.Tag = 'g';
plot(RecXProf,PickTime,'g*');
hold on
plot(theSeisObj.ShotXProf,min(PickTime),'xr','MarkerSize',30);
title({'Choose a pick that you like to delete then press Enter';' '},...
       'FontWeight','bold','color','r');
xlabel('Geophone Position (m)');
ylabel('First Arrival Time (ms)');    
g.Visible = 'on';

btn2 = uicontrol('Style', 'pushbutton', 'String', 'Finished', 'Position',...
    [850 100 75 20], 'Callback', 'btn_gcbf = gcbf;  btn_gcbf.Name = num2str(1);');

btn = uicontrol('Style', 'pushbutton', 'String', 'Delete Pick (s)', 'Position',...
    [950 100 75 20], 'Callback', 'btn_gcbf = gcbf;  btn_gcbf.Name = num2str(2);');



waitfor(g,'Name')
if strcmp(g.Name,num2str(1));
    close (g);
    clear g;
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
    plot(theSeisObj.ShotXProf,min(PickTime),'xr','MarkerSize',30);
end

ShotXProf = theSeisObj.ShotXProf;
if exist(Savepath,'dir')
    save([Savepath fs,filename],'RecXProf','PickTime','ShotXProf');
else mkdir (Savepath)
    save([Savepath fs ,filename],'RecXProf','PickTime','ShotXProf');
end
        
end

