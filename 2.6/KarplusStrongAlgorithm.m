function KarplusStrongAlgorithm

    global FsButton F0Button DurationButton aup
    
    hWnd = uifigure('Position', [130, 100, 250, 160]);
    
    Fs = 44100;
    F0 = 80;
    Duration = 1;
    
    FsButton = uicontrol(hWnd, 'Style', 'Edit', 'Position', [60, 95, 70, 20]);
    FsButton.String = num2str(Fs);
    FsText = uicontrol(hWnd, 'Style', 'Text', 'String', 'Fs', 'Position', [5, 95, 50, 20]);
    
    F0Button = uicontrol(hWnd, 'Style', 'Edit', 'Position', [60, 65, 70, 20]);
    F0Button.String = num2str(F0);
    F0Text = uicontrol(hWnd, 'Style', 'Text', 'String', 'F0', 'Position', [5, 65, 50, 20]);
    
    DurationButton = uicontrol(hWnd, 'Style', 'Edit', 'Position', [60, 35, 70, 20]);
    DurationButton.String = num2str(Duration);
    DurationText = uicontrol(hWnd, 'Style', 'Text', 'String', 'Duration', 'Position', [5, 35, 50, 20]);
    
    GenerateButton = uibutton(hWnd, 'Text', 'Generate', 'Position', [5, 5, 125, 20], ...
        "ButtonPushedFcn", @(src,event) Generate);
    
    Generate();
    
    PlayButton = uibutton(hWnd, 'Text', 'Play', 'Position', [140, 95, 100, 20], ...
        "ButtonPushedFcn", @(src,event) OnPlayMode(1));
    
    PauseButton = uibutton(hWnd, 'Text', 'Pause', 'Position', [140, 65, 100, 20], ...
        "ButtonPushedFcn", @(src,event) OnPlayMode(2));
    
    ResumeButton = uibutton(hWnd, 'Text', 'Resume', 'Position', [140, 35, 100, 20], ...
        "ButtonPushedFcn", @(src,event) OnPlayMode(3));
    
    StopButton = uibutton(hWnd, 'Text', 'Stop', 'Position', [140, 5, 100, 20], ...
        "ButtonPushedFcn", @(src,event) OnPlayMode(4));

    ExportButton = uibutton(hWnd, 'Text', 'ToTxt', 'Position', [5, 125, 240, 20], ...
        "ButtonPushedFcn", @(src,event) OnExport);

end

function Generate()
    
    global FsButton F0Button DurationButton aup Samples

    Fs = str2double(FsButton.String);
    F0 = str2double(F0Button.String);
    Duration = str2double(DurationButton.String);

    D = round(Fs/F0);

    Samples = zeros(Fs*Duration, 1);
    b  = firls(42, [0 1/D 2/D 1], [0 0 1 1]);
    a  = [1 zeros(1,D) -0.5 -0.5];
    Noise = rand(max(length(b),length(a)) - 1, 1);

    Samples = filter(b,a,Samples,Noise);
    Samples = detrend(Samples,0);
    Samples = Samples / max(abs(Samples));

    aup = audioplayer(Samples, Fs);
    

end

function OnExport()

    global Samples

    IntSamples = int16(Samples * 32767);
    writematrix(IntSamples,'Samples.txt');

end

function OnPlayMode(mode)

    global aup

    switch(mode)
        case 1
            play(aup);
        case 2
            pause(aup);
        case 3
            resume(aup);
        case 4
            stop(aup);
    end
end


