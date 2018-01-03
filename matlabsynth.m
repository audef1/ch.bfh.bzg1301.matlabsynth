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
    global trackplayer1 trackplayer2 trackplayer3
    
    global gui
    global playbtn
    global stopbtn
    global speedsld1 speedsld2 speedsld3
    
    global p1 p2 p3
       
    % define track1 (static)
    file1 = 'track1.mp3';
    track1 = audioinfo(file1);
    [y1,Fs1] = audioread(file1);
    
    amp1 = 1;
    speed1 = 1;
    
    t1 = 0:seconds(1/Fs1*speed1):seconds(track1.Duration);
    t1 = t1(1:end-1);
    
    trackplayer1 = audioplayer(downsample(y1*amp1, 3),(Fs1*speed1)/3);
    
    % define track2 (static)
    file2 = 'track2.mp3';
    track2 = audioinfo(file2);
    [y2,Fs2] = audioread(file2);
    
    amp2 = 1;
    speed2 = 1;
    
    t2 = 0:seconds(1/Fs2*speed2):seconds(track2.Duration);
    t2 = t2(1:end-1);

    trackplayer2 = audioplayer(y2*amp2,Fs2*speed2);
    
     % define track3 (static)
    file3 = 'track3.mp3';
    track3 = audioinfo(file3);
    [y3,Fs3] = audioread(file3);
    
    amp3 = 1;
    speed3 = 1;
    
    t3 = 0:seconds(1/Fs3*speed3):seconds(track3.Duration);
    t3 = t3(1:end-1);

    trackplayer3 = audioplayer(y3*amp3,Fs3*speed3);

    %  Create and then hide the UI as it is being constructed.
    gui = figure('Visible','off','Position',[360,500,900,600]);
    set(gui,'Resize','off');
    
    %  Construct the components.
    loadTrack1 = uicontrol('Style','pushbutton','String','Load Track 1','Position',[45,435,90,30],'Callback', @loadTrack1_Callback);
    loadTrack2 = uicontrol('Style','pushbutton','String','Load Track 2','Position',[45,285,90,30],'Callback', @loadTrack2_Callback);
    loadTrack3 = uicontrol('Style','pushbutton','String','Load Track 3','Position',[45,135,90,30],'Callback', @loadTrack3_Callback);
    
    speedsld1 = uicontrol('String', 'speed', 'Style', 'slider', 'Min',0.1,'Max',1.5,'Value',1,'Position', [500,435,250,25],'Callback', @track1_Callback); 
    speedsld2 = uicontrol('String', 'speed', 'Style', 'slider', 'Min',0.1,'Max',1.5,'Value',1,'Position', [500,285,250,25],'Callback', @track2_Callback); 
    speedsld3 = uicontrol('String', 'speed', 'Style', 'slider', 'Min',0.1,'Max',1.5,'Value',1,'Position', [500,135,250,25],'Callback', @track3_Callback); 
    
    ampsld1 = uicontrol('String', 'amplitude', 'Style', 'slider', 'Min',0.1,'Max',1.5,'Value',1,'Position', [800,435,20,135],'Callback', @track1_Callback); 
    ampsld2 = uicontrol('String', 'amplitude', 'Style', 'slider', 'Min',0.1,'Max',1.5,'Value',1,'Position', [800,285,20,135],'Callback', @track2_Callback); 
    ampsld3 = uicontrol('String', 'amplitude', 'Style', 'slider', 'Min',0.1,'Max',1.5,'Value',1,'Position', [800,135,20,135],'Callback', @track3_Callback); 

    playbtn = uicontrol('Style','pushbutton','String','Play','Position',[45,20,75,75],'Callback', @play_Callback);
    stopbtn = uicontrol('Style','pushbutton','String','Stop','Position',[125,20,75,75],'Callback', @stop_Callback);
    
    % plot dimensions in percent
    pwidth = 0.8;
    pheight = 0.15;
    
    % plot tracks
    p1 = subplot(3,1,1);
    set(p1 , 'position' , [0.05,0.8,pwidth,pheight]);
    set(p1 , 'XAxisLocation', 'top')
    set(p1)
    plot(t1,y1*amp1,'k');
    hold on
    % plot other stuff here...
    xlabel('Time');
    ylabel('Audio Signal')
    hold off

    p2 = subplot(3,1,2);
    set(p2 , 'position' , [0.05,0.55,pwidth,pheight]);
    plot(t2,y2*amp2,'g');
    hold on
    % plot other stuff here...
    xlabel('Time')
    ylabel('Audio Signal')
    hold off

    p3 = subplot(3,1,3);
    set(p3 , 'position' , [0.05,0.3,pwidth,pheight]);
    plot(t3,y3*amp3,'r');
    hold on
    % plot other stuff here...
    xlabel('Time')
    ylabel('Audio Signal')
    hold off
   
    % use the same x-axes
    linkaxes([p1,p2,p3],'x')
    
    %dx = 30;
    %set(gcf,'doublebuffer','on');
    %set(gca,'xlim',[0 dx])
    %pos = get(gca,'position');
    %Newpos = [pos(1) pos(2)-0.105 pos(3) 0.03]; %Slider position

    %xmax = max(t1, t2, t3);
    %S = ['set(gca,''xlim'',get(gcbo,''value'')+[0 ' num2str(dx) '])'];
    %h = uicontrol('style','slider','units','normalized','position',Newpos,'sliderstep',[dx/xmax,10*dx/xmax],'callback',S,'min',0,'max',xmax-dx);

    % Make the UI visible.
    gui.Visible = 'on';
end

function loadTrack1_Callback(hObject, eventdata, handles)
    global track1
    global y1
    global Fs1
    global trackplayer1
    global amp1
    global speed1

    [FileName1,PathName] = uigetfile('*.mp3','Select a mp3 file');
    
    if FileName1 ~= 0
        track1 = audioinfo(FileName1);
        [y1,Fs1] = audioread(FileName1);
        trackplayer1 = audioplayer(y1*amp1,Fs1*speed1);
    end
end

function loadTrack2_Callback(hObject, eventdata, handles)
    global track2
    global y2
    global Fs2
    global trackplayer2
    global amp2
    global speed2

    [FileName2,PathName] = uigetfile('*.mp3','Select a mp3 file');
    
    if FileName2 ~= 0
        track2 = audioinfo(FileName2);
        [y2,Fs2] = audioread(FileName2);
        trackplayer2 = audioplayer(y2*amp2,Fs2*speed2);
    end
end

function loadTrack3_Callback(hObject, eventdata, handles)
    global track3
    global y3
    global Fs3
    global trackplayer3
    global amp3
    global speed3

    [FileName3,PathName] = uigetfile('*.mp3','Select a mp3 file');
    
    if FileName3 ~= 0
        track3 = audioinfo(FileName3);
        [y3,Fs3] = audioread(FileName3);
        trackplayer3 = audioplayer(y3*amp3,Fs3*speed3);
    end
end

function play_Callback(src, event)
    global trackplayer1
    global trackplayer2
    global trackplayer3
    global playbtn

	if isplaying(trackplayer1) || isplaying(trackplayer2) || isplaying(trackplayer3)
        playbtn.String = 'Play';
        pause(trackplayer1)
        pause(trackplayer2)
        pause(trackplayer3)
    else
        % play(trackplayer1)
        playbtn.String = 'Pause';
        resume(trackplayer1)
        resume(trackplayer2)
        resume(trackplayer3)
	end
end

function stop_Callback(src, event)
    global trackplayer1
    global trackplayer2
    global trackplayer3
    global playbtn
   
    playbtn.String = 'Play';
    stop(trackplayer1)
    stop(trackplayer2)
    stop(trackplayer3)
end

function track1_Callback(src, event)
    global trackplayer1
    global y1
    global amp1
    global Fs1
    global speed1
   
    % get current position
    pos = trackplayer1.CurrentSample;
    
    % stop ajust speed
    stop(trackplayer1)
    
    % adjust speed or amplitude
    if strcmp(src.String,'speed')
        speed1 = src.Value;
    else
        amp1 = src.Value;
    end
    
    trackplayer1 = audioplayer(y1*amp1,Fs1*speed1);
    
    % calculate new position play from there
    play(trackplayer1, int64(pos*(1/speed1)))
end

function track2_Callback(src, event)
    global trackplayer2
    global y2
    global amp2
    global Fs2
    global speed2
    
    % get current position
    pos = trackplayer2.CurrentSample;
    
    % stop ajust speed
    stop(trackplayer2)
    
    % adjust speed or amplitude
    if strcmp(src.String,'speed')
        speed2 = src.Value;
    else
        amp2 = src.Value;
    end
    
    trackplayer2 = audioplayer(y2*speed2,Fs2*speed2);
    
    % Downsample the audio if speed is less than 1
    %if speed2 >= 1
    %    trackplayer2 = audioplayer(y2*speed2,Fs2*speed2);
    %else
    %    trackplayer2 = audioplayer(downsample(y2,int64(1/speed2))*amp2,Fs2*speed2);   
    %end
    
    % calculate new position play from there
    play(trackplayer2, int64(pos*(1/speed2)))
end

function track3_Callback(src, event)
    global trackplayer3
    global y3
    global amp3
    global Fs3
    global speed3
    
    % get current position
    pos = trackplayer3.CurrentSample;
    
    % stop ajust speed
    stop(trackplayer3)
    
    % adjust speed or amplitude
    if strcmp(src.String,'speed')
        speed3 = src.Value;
    else
        amp3 = src.Value;
    end
    
    trackplayer3 = audioplayer(y3*speed3,Fs3*speed3);
    
    % Downsample audio if speed is less than 1
    %if speed3 >= 1
    %    trackplayer3 = audioplayer(y3*speed3,Fs3*speed3);
    %else
    %    trackplayer3 = audioplayer(downsample(y3,int64(1/speed3))*amp3,Fs3*speed3);   
    %end
    
    % calculate new position play from there
    play(trackplayer3, int64(pos*(1/speed3)))
end