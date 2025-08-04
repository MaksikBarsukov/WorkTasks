clear all;

FilterType = 1;
SampleRate = 1000;
SignalLength = 1;

Wnd = uifigure('Units', 'pixels',"Position", [100, 100, 1400, 700]);

hSignal = axes(Wnd, 'Units', 'pixels', "Position", [50, 450, 800, 200]);
hSignalInRange = axes(Wnd, 'Units', 'pixels', "Position", [50, 200, 800, 200]);

hOriginalRange = axes(Wnd, 'Units', 'pixels', "Position", [900, 450, 300, 200]);
hFilteredRange = axes(Wnd, 'Units', 'pixels', "Position", [900, 200, 300, 200]);

dt = 1 / SampleRate;
t = (0:dt:SignalLength)';

OriginalSignal = 20*sin(2*pi*10*t) + 20*sin(2*pi*100*t) + 30*sin(2*pi*250*t);


bpfilt = designfilt('lowpassfir', ...
                   'FilterOrder',25, ...         
                   'PassbandFrequency',10, ...  
                   'StopbandFrequency',150, ...
                   'SampleRate',SampleRate);


FilteredSignal = filtfilt(bpfilt, OriginalSignal);

freqz(bpfilt.Coefficients,1,[],1000);

[f, as, n] = GetSpectrum(OriginalSignal, SampleRate);
stem (hOriginalRange, f, as(1:(n/2)));
hOriginalRange.Title.String = "OriginalSpec";

[f, as, n] = GetSpectrum(FilteredSignal, SampleRate);
stem (hFilteredRange, f, as(1:(n/2)));
hFilteredRange.Title.String = "FilteredSpec";

plot(hSignal, OriginalSignal,'k');
hold (hSignal, "on");
plot(hSignal, FilteredSignal,'m');

plot(hSignalInRange, OriginalSignal(500:650),'k');
hold (hSignalInRange, "on");

plot(hSignalInRange, FilteredSignal(500:650),'m');
hSignalInRange.Title.String = "From 500 to 650";





