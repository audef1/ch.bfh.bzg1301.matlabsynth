clear sound;

synthgui()

function synthgui
    global file1
    global track1
    global y1
    global Fs1
    global t1
    global amplitude1
    global speed1
    global track1player
    
    global gui
    global playbtn
    global stopbtn
    
    % define track1 (static)
    file1 = 'track1.mp3';
    track1 = audioinfo(file1);
    [y1,Fs1] = audioread(file1);
    
    amplitude1 = 1;
    speed1 = 1;
    
    t1 = 0:seconds(1/Fs1*speed1):seconds(track1.Duration);
    t1 = t1(1:end-1);

    track1player = audioplayer(y1*amplitude1,Fs1*speed1);

    %  Create and then hide the UI as it is being constructed.
    gui = figure('Visible','off','Position',[360,500,450,285]);

    %  Construct the components.
    controlsText = uicontrol('Style','text','String','Controls:','Position',[325,250,60,30]);

    loadTrack1 = uicontrol('Style','pushbutton','String','Load Track 1','Position',[315,225,70,25],'Callback', @loadTrack1_Callback);

    playbtn = uicontrol('Style','pushbutton','String','Play','Position',[315,200,70,25],'Callback', @play_Callback);
    stopbtn = uicontrol('Style','pushbutton','String','Stop/Rewind','Position',[315,175,70,25],'Callback', @stop_Callback);

    ha = axes('Units','Pixels','Position',[50,60,200,185]);
    align([loadTrack1,playbtn,stopbtn,controlsText],'Center','None');

    % plot track 1
    plot(t1,y1*amplitude1);
    xlabel('Time')
    ylabel('Audio Signal')

    % Make the UI visible.
    gui.Visible = 'on';

end

function loadTrack1_Callback(hObject, eventdata, handles)
    global track1
    global y1
    global Fs1
    global track1player
    global amplitude1
    global speed1

    [FileName1,PathName] = uigetfile('*.mp3','Select a mp3 file');
    
    if FileName1 ~= 0
        track1 = audioinfo(FileName1);
        [y1,Fs1] = audioread(FileName1);
        track1player = audioplayer(y1*amplitude1,Fs1*speed1);
    end
end

function play_Callback(src, event)
    global track1player
    global playbtn

	if isplaying(track1player)
        playbtn.String = 'Play';
        pause(track1player)
    else
        % play(track1player)
        playbtn.String = 'Pause';
        resume(track1player)
	end
end

function stop_Callback(src, event)
    global track1player
    stop(track1player)
end