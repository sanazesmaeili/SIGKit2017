function PicksUI(varargin)
%Use this function to set the gain on the waveform figures and control when
%picking begins.

Tmin =varargin{1};
Tmax = varargin{2};
ax = varargin{3};

%create the pick activation buttons - btn2 will allow the user to keep the
%original pick while btn allows the user to change his/her pick
btn1 = uicontrol('Style', 'pushbutton', 'String', 'Keep Pick', 'Position',...
    [175 288 75 20], 'Callback', 'btn_gcbf = gcbf;  btn_gcbf.Name = num2str(1);');

btn2 = uicontrol('Style', 'pushbutton', 'String', 'Change Pick', 'Position',...
    [275 288 75 20], 'Callback', 'btn_gcbf = gcbf;  btn_gcbf.Name = num2str(2);');

btn3 = uicontrol('Style', 'pushbutton', 'String', 'Skip Trace', 'Position',...
    [375 288 75 20], 'Callback', 'btn_gcbf = gcbf;  btn_gcbf.Name = num2str(3);');

% Create slider to adjust gain
sld = uicontrol('Style', 'slider',...
    'Min',Tmin,'Max',Tmax,'Value',0,...
    'Position',[180 100 120 20],...
    'Callback', @plotylim);

% Add a text uicontrol to label the slider.
txt = uicontrol('Style','text',...
    'Position',[180 112 120 20],...
    'String','Gain');

% Make figure visble after adding all components
f.Visible = 'on';
% This code uses dot notation to set properties.
% Dot notation runs in R2014b and later.
% For R2014a and earlier: set(f,'Visible','on');


    function plotylim(source,callbackdata)
        val = 1- source.Value;
        
        ylim(ax,[-val val]);
    end

end
