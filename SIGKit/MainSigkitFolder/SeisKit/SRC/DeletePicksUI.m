function  DeletePicksUI( )
%DeletePICKUI Creates a push button in a figure so that the user can delete
%bad picks from their data file

btn2 = uicontrol('Style', 'pushbutton', 'String', 'Finished', 'Position',...
    [850 100 75 20], 'Callback', 'btn_gcbf = gcbf;  btn_gcbf.Name = num2str(1);');

btn = uicontrol('Style', 'pushbutton', 'String', 'Delete Pick (s)', 'Position',...
    [950 100 75 20], 'Callback', 'btn_gcbf = gcbf;  btn_gcbf.Name = num2str(2);');

g.Visible = 'on';
end

