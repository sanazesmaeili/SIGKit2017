function varargout = seismicsGUI(varargin)
% Last Modified by GUIDE v2.5 11-Nov-2016 14:46:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @seismicsGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @seismicsGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before seismicsGUI is made visible.
function seismicsGUI_OpeningFcn(hObject, eventdata, handles, varargin)

set(handles.txtWait,'Visible','off');
set(handles.radiobnSingle, 'Value', 1);
set(handles.radiobnDipping, 'Value', 0);
set(handles.pushbnReadData,'Enable','on');
set(handles.pushbnReadData,'BackgroundColor',[0.831,0.816,0.784]);
set(handles.pushbnPickTime,'Enable','off');
set(handles.pushbnPickTime,'BackgroundColor',[0.831,0.816,0.784]);
set(handles.pushbnVelocity,'Enable','off');
set(handles.pushbnVelocity,'BackgroundColor',[0.831,0.816,0.784]);
set(handles.pushbnForward,'Enable','off');
set(handles.pushbnForward,'BackgroundColor',[0.86,0.86,0.86]);
set(handles.pushbnReverse,'Enable','off');
set(handles.pushbnReverse,'BackgroundColor',[0.86,0.86,0.86]);
set(handles.pushbnPickForward,'Enable','off');
set(handles.pushbnPickForward,'BackgroundColor',[0.86,0.86,0.86]);
set(handles.pushbnPickReverse,'Enable','off');
set(handles.pushbnPickReverse,'BackgroundColor',[0.86,0.86,0.86]);
set(handles.pushbnVelocityDip,'Enable','off');
set(handles.pushbnVelocityDip,'BackgroundColor',[0.86,0.86,0.86]);

axes(handles.axesReadData);
matlabImage = imread('Read-Data.tif');
image(matlabImage);
handles.axesReadData.XColor = 'black';
axis off;
axis image;
axes(handles.axesPick);
matlabImage = imread('pick.tif');
image(matlabImage);
axis off;
axis image;
axes(handles.axesVelocity);
matlabImage = imread('velocity.tif');
image(matlabImage);
axis off;
axis image;

% Choose default command line output for seismicsGUI
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = seismicsGUI_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbnReadData.
function pushbnReadData_Callback(hObject, eventdata, handles)

fh = findall(0,'Type','Figure');
    for i=1:length(fh)
        if isempty(fh(i).Tag)==1
            close(fh(i))
        end
    end
set(handles.txtWait,'String','Reading Data, Please wait ... ')    
set(handles.txtWait,'Visible','on');
[filenameInput,filepathInput]=uigetfile({'*.dat'},'MultiSelect','on',...
  'Select Input File');

if char(filenameInput) ~= 0 
    
    %**** multiselect
    if isa(filenameInput,'cell')
        sources = numel(filenameInput);
        objFilename =  SeisObj(sources,filenameInput{:});
    else
        FileName = filenameInput(1:(length(filenameInput)-4));
        objFilename =SeisObj(filenameInput);
    end 
%      FileName = filenameInput(1:(length(filenameInput)-4));
%      objFilename = SeisObj(filenameInput);

     handles.objFilename = objFilename;
     plot(objFilename,'clipped','','ReadData');
     set(handles.txtWait,'Visible','off');
     set(handles.pushbnReadData,'Enable','off');
     set(handles.pushbnPickTime,'Enable','on');
     set(handles.pushbnVelocity,'Enable','off');
    %  Save the handles structure.
else 
    set(handles.txtWait,'Visible','off');
    return
end
% guidata(hObject, handles);  % END OPEN INPUT FILE

 
set(handles.txtWait,'Visible','off');
shotPosition = objFilename.ShotXProf;
ReceiverPosition = objFilename.RecXProf;
options.Interpreter = 'tex';
% Include the desired Default answer
options.Default = 'Yes';
% Create a TeX string for the question
qstringS = strcat('Shot position is at ' , ' :( ' , num2str(shotPosition), ' ',') Is it correct?');
choiceS = questdlg(qstringS,'','Yes','No',options);
switch choiceS
    case 'Yes'
        %%%%case yes in shot position
        ShotCaseAnswer = 1;
        %%%%asking about receiver position
        qstringR = strcat('Receiver position is at ' , ' :( ' , num2str(ReceiverPosition), ' ',') Is it correct?');
        choiceR = questdlg(qstringR,'','Yes','No',options);
        switch choiceR
            case 'Yes'
                RecCaseAnswer = 1;
            case 'No'
                %%%%case No and changing in receiver position in case of yes for shot
                RecCaseAnswer = 2;
                prompt = {'What is the correct Receiver position? FirstGeophone:','Spacing:','LastGeophone:'};
                answer = inputdlg(prompt,'',[1 50; 1 50; 1 50]);
                if isempty(answer)
                    RecCaseAnswer = 0;
                else
                    handles.objFilename.RecXProf = [str2num(answer{1}):str2num(answer{2}):str2num(answer{3})];
                end
                
            case ''
                RecCaseAnswer = 0;
        end    
    case 'No'
        ShotCaseAnswer = 2;
        %%%%case No and changing in shot position
        answer = inputdlg('What is the correct shot position : ',...
             ' ', [1 20]); 
        if isempty(answer)
            ShotCaseAnswer = 0; 
        else
            handles.objFilename.ShotXProf = [str2double(answer{1})];
        end
        
        %%%%asking about receiver position
        qstringR = strcat('Receiver position is at ' , ' :( ' , num2str(ReceiverPosition), ' ',') Is it correct?');
        choiceR = questdlg(qstringR,'','Yes','No',options);
        switch choiceR
            case 'Yes'
                RecCaseAnswer = 1;
            case 'No'
        %%%%case No and changing in receiver position in case of no for shot
                RecCaseAnswer = 2;
                prompt = {'What is the correct Receiver position? FirstGeophone:','Spacing:','LastGeophone:'};
                answer = inputdlg(prompt,'',[1 50; 1 50; 1 50]);
                if isempty(answer)
                    RecCaseAnswer = 0;
                else
                    handles.objFilename.RecXProf = [str2num(answer{1}):str2num(answer{2}):str2num(answer{3})];
                end
    
            case ''
                RecCaseAnswer = 0;
        end    
    case ''
        ShotCaseAnswer = 0;
end

objFinal = handles.objFilename; 

if (ShotCaseAnswer == 2) || (RecCaseAnswer == 2)
    set(handles.txtWait,'String','Reading Data, Please wait ... ');  
    set(handles.txtWait,'Visible','on');
    fh = findall(0,'Type','Figure');
    
    for i=1:length(fh)
        if isempty(fh(i).Tag)==1
            close(fh(i))
        end
    end

    plot(objFinal,'simple','','ReadData');
    if length(handles.objFilename.FileNumber) ==2
        filenumber = strcat(num2str(handles.objFilename.FileNumber(1)),'_',num2str(handles.objFilename.FileNumber(2)));
    elseif length(handles.objFilename.FileNumber) ==1
        filenumber = num2str(handles.objFilename.FileNumber);
    end
    filename = [filenumber,'_corr.mat'];
    %setup path to save the results of the picking routine
    fs = filesep;
    filepath = pwd;    
    Savepath = strcat([filepath fs 'Seismics' fs 'Processed_files']);
    %test the existence of a Processed files directory for saving the file.
    %If the directory does not exist, make one then save the files to it.
    if exist(Savepath,'dir')
        save([Savepath fs,filename],'objFinal');
    else
        mkdir (Savepath)
        save([Savepath fs ,filename],'objFinal');
    end
        
    set(handles.txtWait,'Visible','off');
    msgbox(strcat('Your correction file has been saved with (', filename, ' ) name'));
end

%%%%*********All the Figures should be closed for next step, So ask user
%%%%*********to save and close figures and then Program will
%%%%*********automatically close all figures at opening the next step
CreateStruct.Interpreter = 'tex';
CreateStruct.WindowStyle = 'modal';
% msgString = {'Please save your figures that you may need' ...
%              ,'and close all figures before going to the next step.'...
%              ,'If you do not the program will close but NOT save them automatically!'};
% uiwait(msgbox(msgString,'Warning','error',CreateStruct));
msgString = {'Thanks for verifying your data' ...
             ,'Please select the "Pick first arrival time" button on the SeismicGUI'...
             ,'to proceed to the next step!'};
uiwait(msgbox(msgString,'Warning','error',CreateStruct));

 AFigure = findobj(0, 'Tag', 'seismicsGUI');
uistack(AFigure,'top');
%%%%*******************************************************


guidata(hObject, handles);  % END OPEN INPUT FILE
setappdata(handles.seismicsGUI,'objFilename',handles.objFilename);

% msgbox('Please for continuing seicmic steps go back to main seismic page')

% --- Executes on button press in pushbnPickTime.
function pushbnPickTime_Callback(hObject, eventdata, handles)

set(handles.pushbnReadData,'Enable','off');
set(handles.pushbnPickTime,'Enable','off');
set(handles.pushbnVelocity,'Enable','on');
varargout = picksGUI(figure(picksGUI));

% --- Executes on button press in pushbnVelocity.
function pushbnVelocity_Callback(hObject, eventdata, handles)

try
   varargout = singleShotGUI(figure(singleShotGUI));
catch
   msgbox('Error while loading and estimate velocity');
   close singleShotGUI
end

 


% --- Executes on button press in pushbnReverse.
function pushbnReverse_Callback(hObject, eventdata, handles)
%%Read data for reverse shot-when radio button dipping iterface is selected
set(handles.txtWait,'String','Reading Data, Please wait ... ');
set(handles.txtWait,'Visible','on');
[filenameInput,filepathInput]=uigetfile({'*.dat'},'MultiSelect','on',...
  'Select Input File');
if char(filenameInput) ~= 0 
    
             %**** multiselect
    if isa(filenameInput,'cell')
        sources = numel(filenameInput);
        objFilenameRvs =  SeisObj(sources,filenameInput{:});
    else
        FileName = filenameInput(1:(length(filenameInput)-4));
        objFilenameRvs =SeisObj(filenameInput);
    end
    
%      FileName = filenameInput(1:(length(filenameInput)-4));
%      objFilenameRvs = SeisObj(filenameInput);
fh = findall(0,'Type','Figure');
    for i=1:length(fh)
        if isempty(fh(i).Tag)==1
            close(fh(i))
        end
    end

     handles.objFilenameRvs = objFilenameRvs;
     plot(objFilenameRvs,'clipped','','ReadData');
     set(handles.txtWait,'Visible','off');
     set(handles.pushbnForward,'Enable','off');
     set(handles.pushbnReverse,'Enable','off');
     set(handles.pushbnPickForward,'Enable','off');
     set(handles.pushbnPickReverse,'Enable','on');
     set(handles.pushbnVelocityDip,'Enable','off');
    %  Save the handles structure.
else 
    set(handles.txtWait,'Visible','off');
    return
end
% guidata(hObject, handles);  % END OPEN INPUT FILE

 
set(handles.txtWait,'Visible','off');
shotPosition = objFilenameRvs.ShotXProf;
ReceiverPosition = objFilenameRvs.RecXProf;
options.Interpreter = 'tex';
% Include the desired Default answer
options.Default = 'Yes';
% Create a TeX string for the question
qstringS = strcat('Shot position is at ' , ' :( ' , num2str(shotPosition), ' ',') Is it correct?');
choiceS = questdlg(qstringS,'','Yes','No',options);
switch choiceS
    case 'Yes'
        %%%%case yes in shot position
        ShotCaseAnswer = 1;
        %%%%asking about receiver position
        qstringR = strcat('Receiver position is at ' , ' :( ' , num2str(ReceiverPosition), ' ',') Is it correct?');
        choiceR = questdlg(qstringR,'','Yes','No',options);
        switch choiceR
            case 'Yes'
                RecCaseAnswer = 1;
            case 'No'
                %%%%case No and changing in receiver position in case of yes for shot
                RecCaseAnswer = 2;
                prompt = {'What is the correct Receiver position? FirstGeophone:','Spacing:','LastGeophone:'};
                answer = inputdlg(prompt,'',[1 50; 1 50; 1 50]);
                if isempty(answer)
                    RecCaseAnswer = 0;
                else
                    handles.objFilenameRvs.RecXProf = [str2num(answer{1}):str2num(answer{2}):str2num(answer{3})];
                end
                
            case ''
                RecCaseAnswer = 0;
        end    
    case 'No'
        ShotCaseAnswer = 2;
        %%%%case No and changing in shot position
        answer = inputdlg('What is the correct shot position : ',...
             ' ', [1 20]); 
        if isempty(answer)
            ShotCaseAnswer = 0; 
        else
            handles.objFilenameRvs.ShotXProf = [str2double(answer{1})];
        end
        
        %%%%asking about receiver position
        qstringR = strcat('Receiver position is at ' , ' :( ' , num2str(ReceiverPosition), ' ',') Is it correct?');
        choiceR = questdlg(qstringR,'','Yes','No',options);
        switch choiceR
            case 'Yes'
                RecCaseAnswer = 1;
            case 'No'
        %%%%case No and changing in receiver position in case of no for shot
                RecCaseAnswer = 2;
                prompt = {'What is the correct Receiver position? FirstGeophone:','Spacing:','LastGeophone:'};
                answer = inputdlg(prompt,'',[1 50; 1 50; 1 50]);
                if isempty(answer)
                    RecCaseAnswer = 0;
                else
                    handles.objFilenameRvs.RecXProf = [str2num(answer{1}):str2num(answer{2}):str2num(answer{3})];
                end
    
            case ''
                RecCaseAnswer = 0;
        end    
    case ''
        ShotCaseAnswer = 0;
end

objFinal = handles.objFilenameRvs; 

if (ShotCaseAnswer == 2) || (RecCaseAnswer == 2)
    set(handles.txtWait,'String','Reading Data, Please wait ... ');
    set(handles.txtWait,'Visible','on');
    fh = findall(0,'Type','Figure');
    
    for i=1:length(fh)
        if isempty(fh(i).Tag)==1
            close(fh(i))
        end
    end

    plot(objFinal,'simple','','ReadData');
    if length(handles.objFilenameRvs.FileNumber) ==2
        filenumber = strcat(num2str(handles.objFilenameRvs.FileNumber(1)),'_',num2str(handles.objFilenameRvs.FileNumber(2)));
    elseif length(handles.objFilenameRvs.FileNumber) ==1
        filenumber = num2str(handles.objFilenameRvs.FileNumber);
    end
    filename = [filenumber,'_corr.mat'];
    %setup path to save the results of the picking routine
    fs = filesep;
    filepath = pwd;    
    Savepath = strcat([filepath fs 'Seismics' fs 'Processed_files']);
    %test the existence of a Processed files directory for saving the file.
    %If the directory does not exist, make one then save the files to it.
    if exist(Savepath,'dir')
        save([Savepath fs,filename],'objFinal');
    else
        mkdir (Savepath)
        save([Savepath fs ,filename],'objFinal');
    end
        
    set(handles.txtWait,'Visible','off');
    msgbox(strcat('Your correction file has been saved with (', filename, ' ) name'));
end

%%%%*********All the Figures should be closed for next step, So ask user
%%%%*********to save and close figures and then Program will
%%%%*********automatically close all figures at opening the next step
CreateStruct.Interpreter = 'tex';
CreateStruct.WindowStyle = 'modal';
% msgString = {'Please save your figures that you may need' ...
%              ,'and close all figures before going to the next step.'...
%              ,'If you do not the program will close but NOT save them automatically!'};
% uiwait(msgbox(msgString,'Warning','error',CreateStruct));
msgString = {'Thanks for verifying your data' ...
             ,'Please select the "Pick first arrival time" button on the SeismicGUI'...
             ,'to proceed to the next step!'};
uiwait(msgbox(msgString,'Warning','error',CreateStruct));

 AFigure = findobj(0, 'Tag', 'seismicsGUI');
uistack(AFigure,'top');
%%%%*******************************************************
%**** define a flag: if is forward handles.flg = 1 or reverse handles.flg = 2
handles.flg = 2;

guidata(hObject, handles);  % END OPEN INPUT FILE
setappdata(handles.seismicsGUI,'objFilenameRvs',handles.objFilenameRvs);


% --- Executes on button press in pushbnPickReverse.
function pushbnPickReverse_Callback(hObject, eventdata, handles)

set(handles.pushbnReadData,'Enable','off');
set(handles.pushbnReadData,'BackgroundColor',[0.86,0.86,0.86]);
set(handles.pushbnPickTime,'Enable','off');
set(handles.pushbnPickTime,'BackgroundColor',[0.86,0.86,0.86]);
set(handles.pushbnVelocity,'Enable','off');
set(handles.pushbnVelocity,'BackgroundColor',[0.86,0.86,0.86]);
set(handles.pushbnForward,'Enable','off');
set(handles.pushbnForward,'BackgroundColor',[0.831,0.816,0.784]);
set(handles.pushbnReverse,'Enable','off');
set(handles.pushbnReverse,'BackgroundColor',[0.831,0.816,0.784]);
set(handles.pushbnPickForward,'Enable','off');
set(handles.pushbnPickForward,'BackgroundColor',[0.831,0.816,0.784]);
set(handles.pushbnPickReverse,'Enable','off');
set(handles.pushbnPickReverse,'BackgroundColor',[0.831,0.816,0.784]);
set(handles.pushbnVelocityDip,'Enable','on');
set(handles.pushbnVelocityDip,'BackgroundColor',[0.831,0.816,0.784]);
varargout = picksGUI(figure(picksGUI));


% --- Executes on button press in pushbnVelocityDip.
function pushbnVelocityDip_Callback(hObject, eventdata, handles)

try
   varargout = DippingInterfaceGUI(figure(DippingInterfaceGUI));
catch
   msgbox('Error while loading and estimate velocity');
   close DippingInterfaceGUI
end


% --- Executes on button press in pushbnForward.
function pushbnForward_Callback(hObject, eventdata, handles)
%%Read data for forward shot - when dipping interface radio button is selected
set(handles.txtWait,'String','Reading Data, Please wait ... ');
set(handles.txtWait,'Visible','on');
[filenameInput,filepathInput]=uigetfile({'*.dat'},'MultiSelect','on',...
  'Select Input File');
if char(filenameInput) ~= 0 
    
         %**** multiselect
    if isa(filenameInput,'cell')
        sources = numel(filenameInput);
        objFilenameFwd =  SeisObj(sources,filenameInput{:});
    else
        FileName = filenameInput(1:(length(filenameInput)-4));
        objFilenameFwd =SeisObj(filenameInput);
    end     
%      FileName = filenameInput(1:(length(filenameInput)-4));
%      objFilenameFwd = SeisObj(filenameInput);
fh = findall(0,'Type','Figure');
for i=1:length(fh)
    if isempty(fh(i).Tag)==1
        close(fh(i))
    end
end
     handles.objFilenameFwd = objFilenameFwd;
     plot(objFilenameFwd,'clipped','','ReadData');
     set(handles.txtWait,'Visible','off');
     set(handles.pushbnForward,'Enable','off');
     set(handles.pushbnReverse,'Enable','off');
     set(handles.pushbnPickForward,'Enable','on');
     set(handles.pushbnPickReverse,'Enable','off');
     set(handles.pushbnVelocityDip,'Enable','off');
    %  Save the handles structure.
else 
    set(handles.txtWait,'Visible','off');
    return
end
% guidata(hObject, handles);  % END OPEN INPUT FILE

 
set(handles.txtWait,'Visible','off');
shotPosition = objFilenameFwd.ShotXProf;
ReceiverPosition = objFilenameFwd.RecXProf;
options.Interpreter = 'tex';
% Include the desired Default answer
options.Default = 'Yes';
% Create a TeX string for the question
qstringS = strcat('Shot position is at ' , ' :( ' , num2str(shotPosition), ' ',') Is it correct?');
choiceS = questdlg(qstringS,'','Yes','No',options);
switch choiceS
    case 'Yes'
        %%%%case yes in shot position
        ShotCaseAnswer = 1;
        %%%%asking about receiver position
        qstringR = strcat('Receiver position is at ' , ' :( ' , num2str(ReceiverPosition), ' ',') Is it correct?');
        choiceR = questdlg(qstringR,'','Yes','No',options);
        switch choiceR
            case 'Yes'
                RecCaseAnswer = 1;
            case 'No'
                %%%%case No and changing in receiver position in case of yes for shot
                RecCaseAnswer = 2;
                prompt = {'What is the correct Receiver position? FirstGeophone:','Spacing:','LastGeophone:'};
                answer = inputdlg(prompt,'',[1 50; 1 50; 1 50]);
                if isempty(answer)
                    RecCaseAnswer = 0;
                else
                    handles.objFilenameFwd.RecXProf = [str2num(answer{1}):str2num(answer{2}):str2num(answer{3})];
                end
                
            case ''
                RecCaseAnswer = 0;
        end    
    case 'No'
        ShotCaseAnswer = 2;
        %%%%case No and changing in shot position
        answer = inputdlg('What is the correct shot position : ',...
             ' ', [1 20]); 
        if isempty(answer)
            ShotCaseAnswer = 0; 
        else
            handles.objFilenameFwd.ShotXProf = [str2double(answer{1})];
        end
        
        %%%%asking about receiver position
        qstringR = strcat('Receiver position is at ' , ' :( ' , num2str(ReceiverPosition), ' ',') Is it correct?');
        choiceR = questdlg(qstringR,'','Yes','No',options);
        switch choiceR
            case 'Yes'
                RecCaseAnswer = 1;
            case 'No'
        %%%%case No and changing in receiver position in case of no for shot
                RecCaseAnswer = 2;
                prompt = {'What is the correct Receiver position? FirstGeophone:','Spacing:','LastGeophone:'};
                answer = inputdlg(prompt,'',[1 50; 1 50; 1 50]);
                if isempty(answer)
                    RecCaseAnswer = 0;
                else
                    handles.objFilenameFwd.RecXProf = [str2num(answer{1}):str2num(answer{2}):str2num(answer{3})];
                end
    
            case ''
                RecCaseAnswer = 0;
        end    
    case ''
        ShotCaseAnswer = 0;
end

objFinal = handles.objFilenameFwd; 

if (ShotCaseAnswer == 2) || (RecCaseAnswer == 2)
    set(handles.txtWait,'String','Reading Data, Please Wait ... ');
    set(handles.txtWait,'Visible','on');
    fh = findall(0,'Type','Figure');
    
    for i=1:length(fh)
        if isempty(fh(i).Tag)==1
            close(fh(i))
        end
    end

    plot(objFinal,'simple','','ReadData');
    if length(handles.objFilenameFwd.FileNumber) ==2
        filenumber = strcat(handles.objFilenameFwd.FileNumber(1),'_',num2str(handles.objFilenameFwd.FileNumber(2)));
    elseif length(handles.objFilenameFwd.FileNumber) ==1
        filenumber = num2str(handles.objFilenameFwd.FileNumber);
    end
    filename = [filenumber,'_corr.mat'];
    %setup path to save the results of the picking routine
    fs = filesep;
    filepath = pwd;    
    Savepath = strcat([filepath fs 'Seismics' fs 'Processed_files']);
    %test the existence of a Processed files directory for saving the file.
    %If the directory does not exist, make one then save the files to it.
    if exist(Savepath,'dir')
        save([Savepath fs,filename],'objFinal');
    else
        mkdir (Savepath)
        save([Savepath fs ,filename],'objFinal');
    end
        
    set(handles.txtWait,'Visible','off');
    msgbox(strcat('Your correction file has been saved with (', filename, ' ) name'));
end

%%%%*********All the Figures should be closed for next step, So ask user
%%%%*********to save and close figures and then Program will
%%%%*********automatically close all figures at opening the next step
CreateStruct.Interpreter = 'tex';
CreateStruct.WindowStyle = 'modal';
% msgString = {'Please save your figures that you may need' ...
%              ,'and close all figures before going to the next step.'...
%              ,'If you do not the program will close but NOT save them automatically!'};
% uiwait(msgbox(msgString,'Warning','error',CreateStruct));
msgString = {'Thanks for verifying your data' ...
             ,'Please select the "Pick first arrival time" button on the SeismicGUI'...
             ,'to proceed to the next step!'};
uiwait(msgbox(msgString,'Warning','error',CreateStruct));

AFigure = findobj(0, 'Tag', 'seismicsGUI');
uistack(AFigure,'top');
%%%%*******************************************************
%**** define a flag: if is forward handles.flg = 1 or reverse handles.flg = 2
handles.flg = 1;

guidata(hObject, handles);  % END OPEN INPUT FILE
setappdata(handles.seismicsGUI,'objFilenameFwd',handles.objFilenameFwd);



% --- Executes on button press in pushbnPickForward.
function pushbnPickForward_Callback(hObject, eventdata, handles)

set(handles.pushbnReadData,'Enable','off');
set(handles.pushbnReadData,'BackgroundColor',[0.86,0.86,0.86]);
set(handles.pushbnPickTime,'Enable','off');
set(handles.pushbnPickTime,'BackgroundColor',[0.86,0.86,0.86]);
set(handles.pushbnVelocity,'Enable','off');
set(handles.pushbnVelocity,'BackgroundColor',[0.86,0.86,0.86]);
set(handles.pushbnForward,'Enable','off');
set(handles.pushbnForward,'BackgroundColor',[0.831,0.816,0.784]);
set(handles.pushbnReverse,'Enable','on');
set(handles.pushbnReverse,'BackgroundColor',[0.831,0.816,0.784]);
set(handles.pushbnPickForward,'Enable','off');
set(handles.pushbnPickForward,'BackgroundColor',[0.831,0.816,0.784]);
set(handles.pushbnPickReverse,'Enable','off');
set(handles.pushbnPickReverse,'BackgroundColor',[0.831,0.816,0.784]);
set(handles.pushbnVelocityDip,'Enable','off');
set(handles.pushbnVelocityDip,'BackgroundColor',[0.831,0.816,0.784]);
varargout = picksGUI(figure(picksGUI));


% --- Executes on button press in radiobnSingle.
function radiobnSingle_Callback(hObject, eventdata, handles)
% hObject    handle to radiobnSingle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobnSingle
if get(handles.radiobnSingle, 'Value') == 1
    set(handles.txtWait,'Visible','off');
    set(handles.radiobnDipping, 'Value', 0);
    set(handles.pushbnReadData,'Enable','on');
    set(handles.pushbnReadData,'BackgroundColor',[0.831,0.816,0.784]);
    set(handles.pushbnPickTime,'Enable','off');
    set(handles.pushbnPickTime,'BackgroundColor',[0.831,0.816,0.784]);
    set(handles.pushbnVelocity,'Enable','off');
    set(handles.pushbnVelocity,'BackgroundColor',[0.831,0.816,0.784]);
    set(handles.pushbnForward,'Enable','off');
    set(handles.pushbnForward,'BackgroundColor',[0.86,0.86,0.86]);
    set(handles.pushbnReverse,'Enable','off');
    set(handles.pushbnReverse,'BackgroundColor',[0.86,0.86,0.86]);
    set(handles.pushbnPickForward,'Enable','off');
    set(handles.pushbnPickForward,'BackgroundColor',[0.86,0.86,0.86]);
    set(handles.pushbnPickReverse,'Enable','off');
    set(handles.pushbnPickReverse,'BackgroundColor',[0.86,0.86,0.86]);
    set(handles.pushbnVelocityDip,'Enable','off');
    set(handles.pushbnVelocityDip,'BackgroundColor',[0.86,0.86,0.86]);
else
    set(handles.txtWait,'Visible','off');
    set(handles.radiobnDipping, 'Value', 1);
    set(handles.pushbnReadData,'Enable','off');
    set(handles.pushbnReadData,'BackgroundColor',[0.86,0.86,0.86]);
    set(handles.pushbnPickTime,'Enable','off');
    set(handles.pushbnPickTime,'BackgroundColor',[0.86,0.86,0.86]);
    set(handles.pushbnVelocity,'Enable','off');
    set(handles.pushbnVelocity,'BackgroundColor',[0.86,0.86,0.86]);
    set(handles.pushbnForward,'Enable','on');
    set(handles.pushbnForward,'BackgroundColor',[0.831,0.816,0.784]);
    set(handles.pushbnReverse,'Enable','off');
    set(handles.pushbnReverse,'BackgroundColor',[0.831,0.816,0.784]);
    set(handles.pushbnPickForward,'Enable','off');
    set(handles.pushbnPickForward,'BackgroundColor',[0.831,0.816,0.784]);
    set(handles.pushbnPickReverse,'Enable','off');
    set(handles.pushbnPickReverse,'BackgroundColor',[0.831,0.816,0.784]);
    set(handles.pushbnVelocityDip,'Enable','off');
    set(handles.pushbnVelocityDip,'BackgroundColor',[0.831,0.816,0.784]);
end


% --- Executes on button press in radiobnDipping.
function radiobnDipping_Callback(hObject, eventdata, handles)
% hObject    handle to radiobnDipping (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobnDipping
if get(handles.radiobnDipping, 'Value') == 1
    set(handles.txtWait,'Visible','off');
    set(handles.radiobnSingle, 'Value', 0);
    set(handles.pushbnReadData,'Enable','off');
    set(handles.pushbnReadData,'BackgroundColor',[0.86,0.86,0.86]);
    set(handles.pushbnPickTime,'Enable','off');
    set(handles.pushbnPickTime,'BackgroundColor',[0.86,0.86,0.86]);
    set(handles.pushbnVelocity,'Enable','off');
    set(handles.pushbnVelocity,'BackgroundColor',[0.86,0.86,0.86]);
    set(handles.pushbnForward,'Enable','on');
    set(handles.pushbnForward,'BackgroundColor',[0.831,0.816,0.784]);
    set(handles.pushbnReverse,'Enable','off');
    set(handles.pushbnReverse,'BackgroundColor',[0.831,0.816,0.784]);
    set(handles.pushbnPickForward,'Enable','off');
    set(handles.pushbnPickForward,'BackgroundColor',[0.831,0.816,0.784]);
    set(handles.pushbnPickReverse,'Enable','off');
    set(handles.pushbnPickReverse,'BackgroundColor',[0.831,0.816,0.784]);
    set(handles.pushbnVelocityDip,'Enable','off');
    set(handles.pushbnVelocityDip,'BackgroundColor',[0.831,0.816,0.784]);
else
    set(handles.txtWait,'Visible','off');
    set(handles.radiobnSingle, 'Value', 1);
    set(handles.pushbnReadData,'Enable','on');
    set(handles.pushbnReadData,'BackgroundColor',[0.831,0.816,0.784]);
    set(handles.pushbnPickTime,'Enable','off');
    set(handles.pushbnPickTime,'BackgroundColor',[0.831,0.816,0.784]);
    set(handles.pushbnVelocity,'Enable','off');
    set(handles.pushbnVelocity,'BackgroundColor',[0.831,0.816,0.784]);
    set(handles.pushbnForward,'Enable','off');
    set(handles.pushbnForward,'BackgroundColor',[0.86,0.86,0.86]);
    set(handles.pushbnReverse,'Enable','off');
    set(handles.pushbnReverse,'BackgroundColor',[0.86,0.86,0.86]);
    set(handles.pushbnPickForward,'Enable','off');
    set(handles.pushbnPickForward,'BackgroundColor',[0.86,0.86,0.86]);
    set(handles.pushbnPickReverse,'Enable','off');
    set(handles.pushbnPickReverse,'BackgroundColor',[0.86,0.86,0.86]);
    set(handles.pushbnVelocityDip,'Enable','off');
    set(handles.pushbnVelocityDip,'BackgroundColor',[0.86,0.86,0.86]);
    
end


% --- Executes on button press in SeisKit_help_button.
function SeisKit_help_button_Callback(hObject, eventdata, handles)
% hObject    handle to SeisKit_help_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
open SeisKit_how_to.pdf
