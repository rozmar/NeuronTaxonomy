% dropPeaksByProminence calculates the prominence values for the found
% peaks on a distribution function and discards the peaks which prominence
% are below the threshold value. The threshold will be the multiple
% of the maximal prominence and a given threshold ratio.
%
% Parameters
%  - timeVector - nx1 vector, the x value of the distribution function
%  - signalVector - nx1 vector, the value of the distribution function
%  - peakLocation - px1 vector, the positions of found peaks
%  - thresholdRatio - ratio to calculate the prominence threshold
% Return values
%  - remainingPeak - the position index of the prominent peaks
function remainingPeak = dropPeaksByProminence(timeVector, signalVector, peakLocation, threshold)

  % Calculate prominence of peaks
  prominenceVector   = calculatePeakProminence(timeVector, signalVector, peakLocation);
  
  % Set default threshold
  if nargin<4
    threshold = 0.1;
  end
  
  % Select remaining peaks
  remainingPeak      = peakLocation(prominenceVector >= max(prominenceVector)*threshold);
end