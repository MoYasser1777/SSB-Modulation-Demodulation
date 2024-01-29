% Function to plot the spectrum of siganls
function plotMagnitudeSpectrum(signal, fs, titleText)
    dfs = fs / length(signal);
    freqRange = (-fs / 2 : dfs : fs / 2 - dfs); 
    ffreq = fft(signal);
    fSignal = fftshift(ffreq);
    plot(freqRange, abs(fSignal));
    title(titleText);
    xlabel('Frequency (Hz)');
    ylabel('Amplitude');
end
