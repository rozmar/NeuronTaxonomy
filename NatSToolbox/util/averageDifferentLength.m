% averageDifferentLength resamples all timeseries given in parameters to
% the same samplerate and averages them. The new reference vector (sampled
% with the new samplerate) will be given in second parameter.
% 
% Parameters
%  - inputStructure - nx1 structure array, each element has 2 fields
%     - time - kx1 vector, the old reference vector for the signal
%     - values - txk matrix, signals sampled with the old samplerate. These
%       signals will be averaged, then the average will be resampled.
%  - commonTime - a mx1 vector, the new reference vector sampled with the
%    new sampling rate
% Return value
%  - averagedVector - a 1xm length vector, the resampled and averaged
%                     timeseries
function averagedVector = averageDifferentLength(inputStructure, commonTime)

  %% -----------------------------
  %% Initialization
  %% -----------------------------
  nTimeseries = length(inputStructure);
  newLength   = length(commonTime);
  %% -----------------------------
  
  %% -----------------------------
  %% Resample each given vector
  %% -----------------------------
  warning('off', 'MATLAB:linearinter:noextrap'); 
  resampledSeries = zeros(nTimeseries, newLength);
  for j = 1 : nTimeseries
    thisStructure     = inputStructure(j);
    displayInterval   = thisStructure.displayInterval;
    if isfield(thisStructure, 'displayTimeVector')
      displayTimeVector = thisStructure.displayTimeVector;   
    else
      displayTimeVector = thisStructure.timeVector(displayInterval);
    end

    seriesStructure = timeseries(mean(thisStructure.sliceMatrix(:,displayInterval),1), displayTimeVector);
    seriesStructure = resample(seriesStructure, commonTime);
    resampledSeries(j,:) = seriesStructure.data;
  end
  warning('on', 'MATLAB:linearinter:noextrap');
  %% -----------------------------
  
  %% -----------------------------
  %% Average result
  %% -----------------------------
  averagedVector = mean(resampledSeries,1);
  %% -----------------------------
    
end