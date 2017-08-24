% Perform bandpass filtering on a given timeseries with given parameters.
%
% filteredSignal = filterSignal(originalSignal, parameters)
%   originalSignal - the original timeseries which have to be filtered
%   parameters
%               - filterType: 'butter' Butterworth filter
%                             'fir' FIR filter
%               - filterOrder: order of the filter
%               - filterBounds: lower and upper frequency value for filter
%               - Fs: sampling frequency
function filteredSignal = filterSignal(originalSignal, parameters)

  if ~isfield(parameters, 'filterMode')
    parameters.filterMode = 'bandpass';
  end

  if strcmpi(parameters.filterType, 'butter')
    [b, a] = butter( parameters.filterOrder, parameters.filterBounds ./ (parameters.Fs/2) , parameters.filterMode);
  elseif strcmpi(parameters.filterType, 'fir')
    b = fir1( parameters.filterOrder, parameters.filterBounds ./ (parameters.Fs/2) , parameters.filterMode);
    a = 1;
  end
  
  filteredSignal = filtfilt(b, a, originalSignal);
end