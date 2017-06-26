function varargout = GPRGUI(varargin)
% GPRGUI MATLAB code for GPRGUI.fig
%      GPRGUI, by itself, creates a new GPRGUI or raises the existing
%      singleton*.
%
%      H = GPRGUI returns the handle to a new GPRGUI or the handle to
%      the existing singleton*.
%
%      GPRGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GPRGUI.M with the given input arguments.
%
%      GPRGUI('Property','Value',...) creates a new GPRGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GPRGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GPRGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GPRGUI

% Last Modified by GUIDE v2.5 05-Nov-2016 14:50:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GPRGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GPRGUI_OutputFcn, ...
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


% --- Executes just before GPRGUI is made visible.
function GPRGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GPRGUI (see VARARGIN)
set(handles.pushbtnLoad,'Enable','off');
set(handles.txtDisply,'Visible','off');

% before selecting and loading the data user shouldn't enable to apply process step
set(handles.pushbtnDewow, 'Enable', 'off')
set(handles.edtWindowDewow, 'Enable', 'off')
set(handles.txtWindowDewow, 'Enable', 'off')
set(handles.pushbtnTimeZero, 'Enable', 'off')
set(handles.edtShiftValue, 'Enable', 'off')
set(handles.txtShiftValue, 'Enable', 'off')
set(handles.pushbtnGain, 'Enable', 'off')
set(handles.edtWindowSize, 'Enable', 'off')
set(handles.txtWinSize, 'Enable', 'off')
set(handles.edtMaxGain, 'Enable', 'off')
set(handles.txtMaxgain, 'Enable', 'off')
set(handles.chkBoxAGC, 'Enable', 'off')
set(handles.chkBoxSEC, 'Enable', 'off')
set(handles.pushbtnHyperbola, 'Enable', 'off')
set(handles.edtDielectric, 'Enable', 'off')
set(handles.edtVelocity, 'Enable', 'off')
set(handles.edtHypDepth, 'Enable', 'off')
set(handles.txtDielectric, 'Enable', 'off')
set(handles.txtVelocity, 'Enable', 'off')
set(handles.txtHypDepth, 'Enable', 'off')

% Choose default command line output for GPRGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GPRGUI wait for user response (see UIRESUME)
% uiwait(handles.GPRGUI);


% --- Outputs from this function are returned to the command line.
function varargout = GPRGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbtnSelect.
function pushbtnSelect_Callback(hObject, eventdata, handles)
% hObject    handle to pushbtnSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.txtDisply,'Visible','off');
if get(handles.radiobtnRaw,'Value')== 1
    if get(handles.rdbtnGSSI,'Value')== 1
        strext = '*.DZT';
    elseif get(handles.rdbtnSS,'Value')== 1
        strext = '*.DT1';
    elseif get(handles.rdbtnMALA,'Value')== 1
        strext = '*.rd3';
    end
elseif get(handles.radiobtnTimeZero,'Value')== 1
    strext = '*_TimeZero.mat';
elseif get(handles.radiobtnDewow,'Value')== 1
    strext = '*_Dewow.mat';
elseif get(handles.radiobtnAGC,'Value')== 1
    strext = '*_AGC.mat';
elseif get(handles.radiobtnSEC,'Value')== 1
    strext = '*_SEC.mat';
end


[filenameInput,filepathInput]=uigetfile({strext},...
  'Select Input File');
if filenameInput ~= 0 
     FileName = filenameInput(1:(length(filenameInput)-4));
     set(handles.txtFileName,'Visible','on');
     set(handles.txtFileName,'String',FileName);

else 

    return
end

set(handles.pushbtnLoad,'Enable','on');
handles.filenameInput = filenameInput;
handles.filepathInput = filepathInput;
guidata(hObject, handles);

%% --- Executes on button press in pushbtnLoad.
function pushbtnLoad_Callback(hObject, eventdata, handles)
% Clicking the “Load” button will initialize file read in and display the data
radarfile = strcat(handles.filepathInput,handles.filenameInput);
if get(handles.rdbtnGSSI, 'Value') ==1 && get(handles.radiobtnRaw, 'Value') ==1
    radarviewnew_plusobj(radarfile,1);
elseif get(handles.rdbtnSS, 'Value') ==1 && get(handles.radiobtnRaw, 'Value') ==1
    ekko2mat_plusobj(strcat(radarfile(1:strfind(radarfile,'.')-1)))
end

load (strcat(radarfile(1:strfind(radarfile,'.')-1),'.mat'));
displaydata(filename)
set(handles.txtDisply,'Visible','on');
str = strcat('"',handles.filenameInput((1:(length(handles.filenameInput)-4))), '" is loaded');
set(handles.txtDisply,'String', str);
set(handles.pushbtnDewow, 'Enable', 'on')
set(handles.edtWindowDewow, 'Enable', 'on')
set(handles.edtWindowDewow, 'String', '')
set(handles.txtWindowDewow, 'Enable', 'on')
set(handles.pushbtnTimeZero, 'Enable', 'on')
set(handles.edtShiftValue, 'Enable', 'on')
set(handles.edtShiftValue, 'String', '')
set(handles.txtShiftValue, 'Enable', 'on')
set(handles.pushbtnGain, 'Enable', 'on')
set(handles.edtWindowSize, 'Enable', 'on')
set(handles.edtWindowSize, 'String', '')
set(handles.txtWinSize, 'Enable', 'on')
set(handles.edtMaxGain, 'Enable', 'on')
set(handles.edtMaxGain, 'String', '')
set(handles.txtMaxgain, 'Enable', 'on')
set(handles.chkBoxAGC, 'Enable', 'on')
set(handles.chkBoxSEC, 'Enable', 'on')
set(handles.pushbtnHyperbola, 'Enable', 'on')
set(handles.edtDielectric, 'Enable', 'on')
set(handles.edtDielectric, 'String', '')
set(handles.edtVelocity, 'Enable', 'on')
set(handles.edtVelocity, 'String', '')
set(handles.edtHypDepth, 'Enable', 'on')
set(handles.edtHypDepth, 'String', '')
set(handles.txtDielectric, 'Enable', 'on')
set(handles.txtVelocity, 'Enable', 'on')
set(handles.txtHypDepth, 'Enable', 'on')
setappdata(gcf, 'filename',filename)
%%


% --- Executes on button press in pushbnZoomIn.
function pushbnZoomIn_Callback(hObject, eventdata, handles)
% hObject    handle to pushbnZoomIn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zoom on

% --- Executes on button press in pushbnZoomOut.
function pushbnZoomOut_Callback(hObject, eventdata, handles)
% hObject    handle to pushbnZoomOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zoom out
zoom off


% --- Executes on button press in pushbnPan.
function pushbnPan_Callback(hObject, eventdata, handles)
% hObject    handle to pushbnPan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = pan;
if strcmpi(h.enable , 'on')
    pan off
else
    pan on
end


% --- Executes on button press in pushbtnGain.
function pushbtnGain_Callback(hObject, eventdata, handles)
% hObject    handle to pushbtnGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename = getappdata(gcf, 'filename');
if get(handles.chkBoxAGC, 'Value')==1
    agcwindow = get(handles.edtWindowSize, 'String');
    agcmax = get(handles.edtMaxGain, 'String');
    if isempty(agcwindow)==1 || isempty(agcmax)==1 
        uiwait(msgbox('"window size" and "maximum gain" boxes should be filled','Error','Error'));
        return
    end
    AGCobj(filename,str2double(agcwindow),str2double(agcmax));
    set(handles.txtDisply,'Visible','on');
    str = strcat('"',filename.Filename, '_AGC" is loaded');
    set(handles.txtDisply,'String', str);
elseif get(handles.chkBoxSEC, 'Value')==1
    
end

% --- Executes on button press in chkBoxAGC.
function chkBoxAGC_Callback(hObject, eventdata, handles)
% hObject    handle to chkBoxAGC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkBoxAGC
set(handles.chkBoxAGC,'Value',1);
set(handles.chkBoxSEC,'Value',0);

% --- Executes on button press in chkBoxSEC.
function chkBoxSEC_Callback(hObject, eventdata, handles)
% hObject    handle to chkBoxSEC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkBoxSEC
set(handles.chkBoxAGC,'Value',0);
set(handles.chkBoxSEC,'Value',1);


function edtWindowSize_Callback(hObject, eventdata, handles)
% hObject    handle to edtwindowdewow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtwindowdewow as text
%        str2double(get(hObject,'String')) returns contents of edtwindowdewow as a double


% --- Executes during object creation, after setting all properties.
function edtWindowSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtwindowdewow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edtMaxGain_Callback(hObject, eventdata, handles)
% hObject    handle to edtMaxGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtMaxGain as text
%        str2double(get(hObject,'String')) returns contents of edtMaxGain as a double


% --- Executes during object creation, after setting all properties.
function edtMaxGain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtMaxGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbtnDewow.
function pushbtnDewow_Callback(hObject, eventdata, handles)
% hObject    handle to pushbtnDewow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

filename = getappdata(gcf, 'filename');
windowSize = get(handles.edtWindowDewow,'String');
if isempty(windowSize)==1 
    uiwait(msgbox('"window size" box should be filled','Error','Error'));
    return
end
Dewowobj(filename,str2double(windowSize))
set(handles.txtDisply,'Visible','on');
str = strcat('"',filename.Filename, '_Dewow" is loaded');
set(handles.txtDisply,'String', str);


function edtWindowDewow_Callback(hObject, eventdata, handles)
% hObject    handle to edtWindowDewow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtWindowDewow as text
%        str2double(get(hObject,'String')) returns contents of edtWindowDewow as a double


% --- Executes during object creation, after setting all properties.
function edtWindowDewow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtWindowDewow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbtnHyperbola.
function pushbtnHyperbola_Callback(hObject, eventdata, handles)
% hObject    handle to pushbtnHyperbola (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename = getappdata(gcf, 'filename');
DEC = get(handles.edtDielectric,'String');
if isempty(DEC)==1 
    uiwait(msgbox('"Dielectric" box should be filled','Error','Error'));
    return
end
[velocity,depth]= Hyperbola_Drawing_obj(filename,str2double(DEC));
set(handles.edtVelocity,'String', velocity);  
set(handles.edtHypDepth,'String', depth); 

set(handles.txtDisply,'Visible','on');
str = strcat('"',filename.Filename, '_PickHyperbola" is loaded');
set(handles.txtDisply,'String', str);


function edtDielectric_Callback(hObject, eventdata, handles)
% hObject    handle to edtDielectric (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtDielectric as text
%        str2double(get(hObject,'String')) returns contents of edtDielectric as a double


% --- Executes during object creation, after setting all properties.
function edtDielectric_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtDielectric (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edtVelocity_Callback(hObject, eventdata, handles)
% hObject    handle to edtVelocity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtVelocity as text
%        str2double(get(hObject,'String')) returns contents of edtVelocity as a double


% --- Executes during object creation, after setting all properties.
function edtVelocity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtVelocity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edtHypDepth_Callback(hObject, eventdata, handles)
% hObject    handle to edtHypDepth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtHypDepth as text
%        str2double(get(hObject,'String')) returns contents of edtHypDepth as a double


% --- Executes during object creation, after setting all properties.
function edtHypDepth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtHypDepth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbtnTimeZero.
function pushbtnTimeZero_Callback(hObject, eventdata, handles)
% hObject    handle to pushbtnTimeZero (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename = getappdata(gcf, 'filename');
tsh = get(handles.edtShiftValue, 'String');
if isempty(tsh)==1
    uiwait(msgbox('"shift value" box should be filled','Error','Error'));
    return
end   
T0shifts_obj(filename,-str2double(tsh))
set(handles.txtDisply,'Visible','on');
str = strcat('"',filename.Filename, '_TimeZero" is loaded');
set(handles.txtDisply,'String', str);


function edtShiftValue_Callback(hObject, eventdata, handles)
% hObject    handle to edtShiftValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtShiftValue as text
%        str2double(get(hObject,'String')) returns contents of edtShiftValue as a double


% --- Executes during object creation, after setting all properties.
function edtShiftValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtShiftValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
