% Calculates the noiselevel.
%
% In parameter get the IV and the samplingRate. Create a butterworth filter
% and filter the IV with it. After that calculates the average difference from the average by the 
% original and the filtered IV.
function [noiselevel filtnoiselevel] = calculateNoiseLevel(y,samplingRate)
	fNorm = 1000 / (samplingRate/2);
	[b a] = butter(6, fNorm, 'low');
	yFilt = filtfilt(b, a, y);
	temp = mean(y);
	noiselevel=mean(abs(y-temp))*1000;
	filtnoiselevel=mean(abs(yFilt-temp))*1000;
end