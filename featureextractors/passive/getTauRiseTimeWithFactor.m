%
%
%
function tauVector = getTauRiseTimeWithFactor(signalMatrix,tauStart,tauEnd,sampleInterval, factor)
	
  %% ----------------------
  %  Set parameters
  %% ----------------------
  numberOfSignal = size(signalMatrix, 1);
  tauVector = zeros(numberOfSignal, 1);
  %% ----------------------

  %% ----------------------
  %  Set filter parameters
  %% ----------------------
  lowpassFrequency = 500;
  filterOrder = 6;
  % Normalized cutoff frequency
  fNorm = lowpassFrequency / ((1 / sampleInterval) / 2); 
  % Create filter
  [b,a] = butter(filterOrder, fNorm, 'low');
  %% ----------------------
	
	%% ----------------------
  %  Calculate tau
  %% ----------------------
  for i = 1 : numberOfSignal
    
    filteredSignal = filtfilt(b, a, signalMatrix(i,:));
    risingPart = filteredSignal(tauStart:tauEnd(i));
    risingRange = abs(diff(risingPart([1, end])));
    risingThreshold = risingPart(1) - risingRange * factor;
	
		thresholdIndex = find(risingPart < risingThreshold, 1, 'first');
    tauVector(i) = thresholdIndex * sampleInterval;
    
  end
  %% ----------------------
		
end