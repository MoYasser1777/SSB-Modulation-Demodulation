%-------------------1.Record voice segments and set sampling frequency---------------%

% Set the sampling frequency (Fs) appropriately.
Fs = 44100;

% Record three voice segments of 10 seconds each
recording1 = audiorecorder(Fs, 16, 1); % 16 bits, 1 channel
disp('Start speaking for the first segment input.');
recordblocking(recording1, 10);
disp('Recording input1 is completed.');
input1 = getaudiodata(recording1);
audiowrite('input1.wav', input1, Fs);

recording2 = audiorecorder(Fs, 16, 1); % 16 bits, 1 channel
disp('Start speaking for the second segment input.');
recordblocking(recording2, 10);
disp('Recording input2 is completed.');
input2 = getaudiodata(recording2);
audiowrite('input2.wav', input2, Fs);

recording3 = audiorecorder(Fs, 16, 1); % 16 bits, 1 channel
disp('Start speaking for the third segment input.');
recordblocking(recording3, 10);
disp('Recording input3 is completed.');
input3 = getaudiodata(recording3);
audiowrite('input3.wav', input3, Fs);