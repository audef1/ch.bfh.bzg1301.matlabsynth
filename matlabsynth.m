clear sound;

synthgui()

function synthgui

    % define tracks
    file1 = 'track1.mp3';

    track1 = audioinfo(file1);
    [y1,Fs1] = audioread(file1);

    amplitude1 = 1;
    speed1 = 1;

    t1 = 0:seconds(1/Fs1*speed1):seconds(track1.Duration);
    t1 = t1(1:end-1);

    track1player = audioplayer(y1*amplitude1,Fs1*speed1);

    % play(track1player);
    % stop(track1player);
    % resume(track1player);
    % pause(track1player);


    %  Create and then hide the UI as it is being constructed.
       gui = figure('Visible','off','Position',[360,500,450,285]);

       %  Construct the components.
       
       controlsText = uicontrol('Style','text','String','Controls:','Position',[325,250,60,30]);

       loadTrack1 = uicontrol('Style','pushbutton','String','Load Track 1','Position',[315,220,70,25],'Callback', @loadTrack1_Callback);

       play = uicontrol('Style','pushbutton','String','Play','Position',[315,200,70,25],'Callback', {@play_Callback,track1player});
       stop = uicontrol('Style','pushbutton','String','Stop','Position',[315,175,70,25],'Callback', @stop_Callback);
       pause = uicontrol('Style','pushbutton','String','Pause','Position',[315,150,70,25],'Callback', @pause_Callback); 
       resume = uicontrol('Style','pushbutton','String','Pause','Position',[315,125,70,25],'Callback', @resume_Callback); 

       ha = axes('Units','Pixels','Position',[50,60,200,185]);
       align([loadTrack1,play,stop,pause,resume,controlsText],'Center','None');

       
       plot(t1,y1*amplitude1);

       xlabel('Time')
       ylabel('Audio Signal')
       

       % Make the UI visible.
       gui.Visible = 'on';

end classdef

function loadTrack1_Callback(hObject, eventdata, handles)
    [FileName1,PathName] = uigetfile('*.mp3','Select a mp3 file');
    track1 = audioinfo(FileName1);
    [y1,Fs1] = audioread(FileName1);
end

function play_Callback(hObject, eventdata, handles, player)
   start(player)
end

function pause_Callback(hObject, eventdata, handles)
   pause(track1player)
end

function stop_Callback(hObject, eventdata, handles)
   stop(track1player)
end

function resume_Callback(hObject, eventdata, handles)
   resume(track1player)
end




