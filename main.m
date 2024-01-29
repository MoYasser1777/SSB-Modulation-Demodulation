%-----------------------------1.Choosing The Audio-----------------------------%
[audio1, FS] = audioread("input1.wav");
[audio2, FS] = audioread("input2.wav");
[audio3, FS] = audioread("input3.wav");

%-------------------------2.Design and apply LPF filter------------------------%

%Plotting the three audios before filtering
figure(1);

subplot(3,1,1);
plotMagnitudeSpectrum(audio1, FS, 'Magnitude Spectrum - Audio 1 Before Filtering');

subplot(3,1,2);
plotMagnitudeSpectrum(audio2, FS, 'Magnitude Spectrum - Audio 2 Before Filtering');

subplot(3,1,3);
plotMagnitudeSpectrum(audio3, FS, 'Magnitude Spectrum - Audio 3 Before Filtering');

% Choosing the cutoff frequency
cutoff_frequency = 6000;
sample_rate=3*FS;
% Determine the maximum length of the audio signals
maxLength = max([length(audio1), length(audio2), length(audio3)]);
audio1 = [audio1;zeros(maxLength -length(audio1),1)];
audio2 = [audio2;zeros(maxLength -length(audio2),1)];
audio3 = [audio3;zeros(maxLength -length(audio3),1)];

% Resampling the signals
audio1 = resample(audio1, sample_rate, FS);
audio2 = resample(audio2, sample_rate, FS);
audio3 = resample(audio3, sample_rate, FS);

% Design a low-pass filter for audios
lpf = designfilt('lowpassfir', 'FilterOrder', 200, 'CutoffFrequency', cutoff_frequency, 'SampleRate', FS);

% Apply the filter to audio1
filtered_input1 = filter(lpf, audio1);

% Apply the filter to audio2
filtered_input2 = filter(lpf, audio2);

% Apply the filter to audio3
filtered_input3 = filter(lpf, audio3);

%Plotting the three audios after filtering
figure(2);

subplot(3,1,1);
plotMagnitudeSpectrum(filtered_input1, sample_rate, 'Magnitude Spectrum - Audio 1 After Filtering');

subplot(3,1,2);
plotMagnitudeSpectrum(filtered_input2, sample_rate, 'Magnitude Spectrum - Audio 2 After Filtering');

subplot(3,1,3);
plotMagnitudeSpectrum(filtered_input3, sample_rate, 'Magnitude Spectrum - Audio 3 After Filtering');


%---------------------------3.Perform SSB Modulation---------------------------%
%𝑦(𝑡) = (𝑥(𝑡)) cos 𝜔t
FC=20000;

% Create a time vector with the maximum length
t = linspace(0,maxLength*3/sample_rate,maxLength*3);

% Modulate the three audios
modulatedSignal1 = filtered_input1'.*cos(2*pi*(FC)*t);
modulatedSignal2 = filtered_input2'.*cos(2*pi*(2*FC)*t);
modulatedSignal3 = filtered_input3'.*cos(2*pi*(3*FC)*t);

% Plotting the three audios after modulating
figure(3);

subplot(3,1,1);
plotMagnitudeSpectrum(modulatedSignal1, sample_rate, 'Magnitude Spectrum - Audio 1 After Modulating');

subplot(3,1,2);
plotMagnitudeSpectrum(modulatedSignal2, sample_rate, 'Magnitude Spectrum - Audio 2 After Modulating');

subplot(3,1,3);
plotMagnitudeSpectrum(modulatedSignal3, sample_rate, 'Magnitude Spectrum - Audio 3 After Modulating');


% Design the bandpass filters
bandpassFilter1 = designfilt('bandpassfir','FilterOrder', 700,'CutoffFrequency1', 20000,'CutoffFrequency2', 26000,'SampleRate', sample_rate);
bandpassFilter2 = designfilt('bandpassfir','FilterOrder', 700,'CutoffFrequency1', 40000,'CutoffFrequency2', 46000,'SampleRate', sample_rate);
bandpassFilter3 = designfilt('bandpassfir','FilterOrder', 700,'CutoffFrequency1', 60000,'CutoffFrequency2', 66000,'SampleRate', sample_rate);

SSB1=filter(bandpassFilter1, modulatedSignal1);
SSB2=filter(bandpassFilter2, modulatedSignal2);
SSB3=filter(bandpassFilter3, modulatedSignal3);

% Plotting the three audios after modulating
figure(4);

subplot(3,1,1);
plotMagnitudeSpectrum(SSB1, sample_rate, 'Magnitude Spectrum - SSB of Audio1');

subplot(3,1,2);
plotMagnitudeSpectrum(SSB2, sample_rate, 'Magnitude Spectrum - SSB of Audio2');

subplot(3,1,3);
plotMagnitudeSpectrum(SSB3, sample_rate, 'Magnitude Spectrum - SSB of Audio3');

% Summing the siganls to make FDM system
SSB_total =SSB1+SSB2+SSB3;

figure(5);
plotMagnitudeSpectrum(SSB_total, sample_rate, 'Magnitude Spectrum - Total SSB');

%---------------------------3.Perform SSB Demodulation---------------------------%
demodulatedAudio1 = SSB_total.*cos(2*pi*(FC)*t);
demodulatedAudio2 = SSB_total.*cos(2*pi*(2*FC)*t);
demodulatedAudio3 = SSB_total.*cos(2*pi*(3*FC)*t);

% Design a low-pass filter for audios
lpf2 = designfilt('lowpassfir', 'FilterOrder', 200, 'CutoffFrequency', cutoff_frequency, 'SampleRate', sample_rate);

% Apply the filter to demodulatedAudio1
output1 = filter(lpf2, demodulatedAudio1);
audiowrite('output1.wav', output1, sample_rate);

% Apply the filter to demodulatedAudio2
output2 = filter(lpf2, demodulatedAudio2);
audiowrite('output2.wav', output2, sample_rate);

% Apply the filter to demodulatedAudio3
output3 = filter(lpf2, demodulatedAudio3);
audiowrite('output3.wav', output3, sample_rate);

% Plotting the outputs
figure(6);

subplot(3,1,1);
plotMagnitudeSpectrum(output1, sample_rate, 'Magnitude Spectrum - Output1');

subplot(3,1,2);
plotMagnitudeSpectrum(output2, sample_rate, 'Magnitude Spectrum - Output2');

subplot(3,1,3);
plotMagnitudeSpectrum(output3, sample_rate, 'Magnitude Spectrum - Output3');