clear all;
clear sound;

synthgui()

function synthgui
    global file1 file2 file3
    global track1 track2 track3
    global y1 y2 y3
    global Fs1 Fs2 Fs3
    global t1 t2 t3
    global amp1 amp2 amp3
    global speed1 speed2 speed3
    global track1player track2player track3player
    
    global gui
    global playbtn
    global stopbtn
    global speed1sld
    global speed2sld
    
    global p1 p2 p3
       
    % define track1 (static)
    file1 = 'track1.mp3';
    track1 = audioinfo(file1);
    [y1,Fs1] = audioread(file1);
    
    amp1 = 1;
    speed1 = 1;
    
    t1 = 0:seconds(1/Fs1*speed1):seconds(track1.Duration);
    t1 = t1(1:end-1);
    
    track1player = audioplayer(y1*amp1,Fs1*speed1);
    
    % define track2 (static)
    file2 = 'track2.mp3';
    track2 = audioinfo(file2);
    [y2,Fs2] = audioread(file2);
    
    amp2 = 1;
    speed2 = 1;
    
    t2 = 0:seconds(1/Fs2*speed2):seconds(track2.Duration);
    t2 = t2(1:end-1);

    track2player = audioplayer(y2*amp2,Fs2*speed2);

    %  Create and then hide the UI as it is being constructed.
    gui = figure('Visible','off','Position',[360,500,450,285]);
    
    %  Construct the components.
    controlsText = uicontrol('Style','text','String','Controls:','Position',[325,250,60,30]);

    loadTrack1 = uicontrol('Style','pushbutton','String','Load Track 1','Position',[315,225,70,25],'Callback', @loadTrack1_Callback);

    playbtn = uicontrol('Style','pushbutton','String','Play','Position',[315,200,70,25],'Callback', @play_Callback);
    stopbtn = uicontrol('Style','pushbutton','String','Stop/Rewind','Position',[315,175,70,25],'Callback', @stop_Callback);
    
    speed1sld = uicontrol('Style', 'slider', 'Min',0.1,'Max',1.5,'Value',1,'Position', [315,150,70,25],'Callback', @speed1sld_Callback); 
    speed2sld = uicontrol('Style', 'slider', 'Min',0.1,'Max',1.5,'Value',1,'Position', [315,125,70,25],'Callback', @speed2sld_Callback); 
    
    ha = axes('Units','Pixels','Position',[50,60,200,185]);
    align([loadTrack1,playbtn,stopbtn,speed1sld,speed2sld,controlsText],'Center','None');

    % plot tracks
    p1 = subplot(3,1,1);
    plot(t1,y1*amp1,'k');
    hold on
    % plot other stuff here...
    xlabel('Time')
    ylabel('Audio Signal')
    hold off

    p2 = subplot(3,1,2);
    plot(t2,y2*amp2,'g');
    hold on
    % plot other stuff here...
    xlabel('Time')
    ylabel('Audio Signal')
    hold off

    p3 = subplot(3,1,3);
    plot(t2,y2*amp2,'r');
    hold on
    % plot other stuff here...
    xlabel('Time')
    ylabel('Audio Signal')
    hold off
   
    linkaxes([p1,p2,p3],'x')
    
    % dx = 30;                                % width of the x axis window
    % set(gcf,'doublebuffer','on');           % This avoids flickering
    % set(gca,'xlim',[0 dx])
    % pos = get(gca,'position');
    % Newpos = [pos(1) pos(2)-0.105 pos(3) 0.03]; %Slider position

    % xmax = max(t1, t2, t3);
    % S = ['set(gca,''xlim'',get(gcbo,''value'')+[0 ' num2str(dx) '])'];
    % h = uicontrol('style','slider','units','normalized','position',Newpos,'sliderstep',[dx/xmax,10*dx/xmax],'callback',S,'min',0,'max',xmax-dx);

    % Make the UI visible.
    gui.Visible = 'on';
end

function loadTrack1_Callback(hObject, eventdata, handles)
    global track1
    global y1
    global Fs1
    global track1player
    global amp1
    global speed1

    [FileName1,PathName] = uigetfile('*.mp3','Select a mp3 file');
    
    if FileName1 ~= 0
        track1 = audioinfo(FileName1);
        [y1,Fs1] = audioread(FileName1);
        track1player = audioplayer(y1*amp1,Fs1*speed1);
    end
end

function play_Callback(src, event)
    global track1player
    global track2player
    global playbtn

	if isplaying(track1player) || isplaying(track2player)
        playbtn.String = 'Play';
        pause(track1player)
        pause(track2player)
    else
        % play(track1player)
        playbtn.String = 'Pause';
        resume(track1player)
        resume(track2player)
	end
end

function stop_Callback(src, event)
    global track1player
    global track2player
    stop(track1player)
    stop(track2player)
end

function speed1sld_Callback(src, event)
    global track1player
    global y1
    global amp1
    global Fs1
    global speed1
   
    % get current position
    pos = track1player.CurrentSample;
    
    % stop ajust speed
    stop(track1player)
    speed1 = src.Value;
    track1player = audioplayer(y1*amp1,Fs1*speed1);
    
    % calculate new position play from there
    play(track1player, int64(pos*(1/speed1)))
end

function speed2sld_Callback(src, event)
    global track2player
    global y2
    global amp2
    global Fs2
    global speed2
    
    % get current position
    pos = track2player.CurrentSample;
    
    % stop ajust speed
    stop(track2player)
    speed2 = src.Value;
    if speed2 >= 1
        track2player = audioplayer(y2*speed2,Fs2*speed2);
    else
        track2player = audioplayer(downsample(y2,int64(1/speed2))*amp2,Fs2*speed2);   
    end
    % calculate new position play from there
    play(track2player, int64(pos*(1/speed2)))
end