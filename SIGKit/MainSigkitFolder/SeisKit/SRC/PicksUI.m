function PicksUI(varargin)
%Use this function to set the gain on the waveform figures and control when
%picking begins.

Tmin =varargin{1};
Tmax = varargin{2};
ax = varargin{3};
btn2 = varargin{4};

%create the pick activation buttons - btn2 will allow the user to keep the
%original pick while btn allows the user to change his/her pick
btn1 = uicontrol('Style', 'pushbutton', 'String', 'Keep Pick', 'Position',...
    [20 250 75 20], 'Units','normalized', 'Callback', 'btn_gcbf = gcbf;  btn_gcbf.Name = num2str(1);');

btn2 = uicontrol('Style', 'pushbutton', 'String', btn2 , 'Position',...
    [20 200 75 20], 'Units','normalized', 'Callback', 'btn_gcbf = gcbf;  btn_gcbf.Name = num2str(2);');

btn3 = uicontrol('Style', 'pushbutton', 'String', 'Skip Trace', 'Position',...
    [20 150 75 20], 'Units','normalized', 'Callback', 'btn_gcbf = gcbf;  btn_gcbf.Name = num2str(3);');

btn4 = uicontrol('Style', 'pushbutton', 'String', 'Go Back to Previous Trace', 'Position',...
    [20 100 135 20], 'Units','normalized', 'Callback', 'btn_gcbf = gcbf;  btn_gcbf.Name = num2str(4);');

% Create slider to adjust gain
sld = uicontrol('Style', 'slider',...
    'Min',Tmin,'Max',Tmax,'Value',0,...
    'Position',[180 100 120 20],...
    'Callback', @plotylim);

% Add a text uicontrol to label the slider.
txt = uicontrol('Style','text',...
    'Position',[180 112 120 20],'Units','normalized',...
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
