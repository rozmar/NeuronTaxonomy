function [resultStructure, parameters] = calculateSingleCellWavelet(inputStructure, parameters)

  %% ---------------------------
  %  Initialization
  %% ---------------------------
  parameters = checkParameters(inputStructure, parameters);
  %% ---------------------------
  
  %% ---------------------------
  %  Get the data
  %% ---------------------------
  ivStructure = inputStructure.iv;
  featStruct  = inputStructure.cellStruct;

  apFeatures  = featStruct.apFeatures;
  apSweepId   = apFeatures(:,1);
  sweepWithAP = unique(apSweepId);
  numAPSweep  = length(sweepWithAP);
  
  parameters.segmentBnd = ivStructure.segment./1000;
  parameters.interval   = 1/featStruct.samplingRate;
  
  meanPowerSpectrum = cell(1,numAPSweep);
  %% ---------------------------
  
  %% ---------------------------
  %  Loop through each firing sweep
  %% ---------------------------
  for i = 1 : numAPSweep
    
    % Collect slices between spikes
    slicesBetweenSpike = ...
        collectSliceBetweenSpike(ivStructure, ...
        apFeatures, ...
        sweepWithAP(i), ...
        (apSweepId==sweepWithAP(i)), ...
        parameters);
    
    numSlice = length(slicesBetweenSpike);
    
    % Sweep without slice will be skipped
    if numSlice == 0 
      continue;
    end
    
    % Prepare for wavelet transformation
    meanPowerMatrix = cell(1, numSlice);
    weights = [slicesBetweenSpike.length];
    
    % Do wavelet transform
    for s = 1 : numSlice
        
      % Calculate wavelet power
      [PowerMatrix, freqVector] = calculateTFDPower(slicesBetweenSpike(s).values, parameters);
      % Trim parts which won't be plotted
      [PowerMatrix, freqVector] = trimBoundaries(PowerMatrix, freqVector, parameters);
      
      PowerMatrix = trimTime(PowerMatrix);
      slicesBetweenSpike(s).times = trimTime(slicesBetweenSpike(s).times);
      
      if parameters.plot.plotSpectrogram
        figure;
        plotPowerSpectrum(slicesBetweenSpike(s).times, freqVector, PowerMatrix, parameters.plot);
        title(sprintf('Sweep %d, Slice %d', sweepWithAP(i), s));
      end
      
      % Average over time by frequency
      meanPowerMatrix{s} = nanmean(PowerMatrix,2).*weights(s);
      
    end
    
    % Calculate weighted power average for sweep
    meanPowerSpectrum{i} = sum(cell2mat(meanPowerMatrix),2)./sum(weights);
    
    % Plot current sweep's average power spectrum
    if isfield(parameters.plot, 'plotSinglePowerSpect') && parameters.plot.plotSinglePowerSpect
        
      figure;
      plot(freqVector, meanPowerSpectrum{i});
      if isfield(parameters.plot, 'frequencyBound')
        xlim(parameters.plot.frequencyBound);
      end
      title(sprintf('Power Spectrum weighted average for sweep %d', sweepWithAP(i)));
    end
    
  end
  %% ---------------------------
  
  %% --------------------------
  %  Find the maximal power
  %% --------------------------
  meanPowerSpectrum(cellfun(@isempty, meanPowerSpectrum)) = [];
  [maxPowerValue, maxPowerPos] = max(cell2mat(meanPowerSpectrum));
  maxPowerFreq = freqVector(maxPowerPos);
  %% --------------------------
  
  %% --------------------------
  %  Assemble result set
  %% --------------------------
  resultStructure.meanPowerSpectrum = meanPowerSpectrum;
  resultStructure.maxPower          = maxPowerValue;
  resultStructure.maxPowerFreq      = maxPowerFreq;
  %% --------------------------
  
end

% This function cut slices between spikes from a given sweep
function slicesBetweenSpike = collectSliceBetweenSpike(ivStructure, apFeatures, sweepNumber, thisSweepFlag, parameters)
  thisSweepAP = apFeatures(thisSweepFlag,:);
  
  signalStructure.times  = ivStructure.time;
  signalStructure.values = getSweep(ivStructure, sweepNumber);
  
  slicesBetweenSpike = ...
      cutSlicesBetweenSpikes(signalStructure, thisSweepAP, parameters);
end

% This function trim the frequency outside the frequency boundary
function [PowerMatrix, freqVector] = trimBoundaries(PowerMatrix, freqVector, parameters)
  if isfield(parameters.plot, 'frequencyBound')
    boundary = parameters.plot.frequencyBound;
    retainIndex = (boundary(1)<=freqVector&freqVector<=boundary(2));
    freqVector = freqVector(retainIndex);
    PowerMatrix = PowerMatrix(retainIndex,:);
  end
end

function PowerMatrix = trimTime(PowerMatrix)

  if size(PowerMatrix,2)==1
    numSamplePoint = length(PowerMatrix);
  else
    numSamplePoint = size(PowerMatrix,2);
  end
  
  quarterLength  = round(0.25*numSamplePoint);
  
  if size(PowerMatrix,2)==1
    PowerMatrix = PowerMatrix(quarterLength+1:numSamplePoint-quarterLength);
  else
    PowerMatrix = PowerMatrix(:,quarterLength+1:numSamplePoint-quarterLength);
  end
  
end

% This function find and cut the slices between spikes
function sliceStructure = cutSlicesBetweenSpikes(signalStructure, thisSweepAP, parameters)

  % Find and cut values
  segmentStructure = createBetweenSpikeSegment(signalStructure.times, thisSweepAP, parameters);
  sliceArray       = collectSlicesOfSegments(segmentStructure, signalStructure);
  
  % Find and cut times
  signalStructure.values = signalStructure.times;
  timeSliceArr = collectSlicesOfSegments(segmentStructure, signalStructure);
  
  % Create structure
  sliceStructure = struct('times', timeSliceArr, 'values', sliceArray);
  
  if isempty(timeSliceArr)
    return;
  end
  
  lengthBySegment = cellfun(@length, sliceArray);
  lengthArray = mat2cell(lengthBySegment, ones(length(sliceArray),1), 1);
  [sliceStructure.length] = deal(lengthArray{:});
  %[sliceStructure(:).length] = ...
  %    deal(mat2cell(lengthBySegment,ones(length(sliceArray),1),1));
end

% This function creates segment structures for non-spiking segments
function segmentStructure = createBetweenSpikeSegment(timeVector, APMatrix, parameters)

  gapAfterSpike = parameters.gapAfterSpike;
  
  if isfield(parameters, 'cutFromEnd')
    APMatrix = cutSweepEnds(timeVector, APMatrix, parameters.segmentBnd, parameters.cutFromEnd);
  end
  
  thresholdTime = timeVector(APMatrix(:,4));
  apMaxTime     = timeVector(APMatrix(:,3));
  cutStartTime  = apMaxTime + ones(size(apMaxTime))*gapAfterSpike;
  cutEndTime   = [thresholdTime(2:end);sum(parameters.segmentBnd(1:2))];
  
  sliceLength = diff([cutStartTime, cutEndTime],1,2);
  goodSlice   = (sliceLength>parameters.minSliceLength);
  
  segmentStructure = struct('start', cutStartTime(goodSlice), 'end', cutEndTime(goodSlice));

end

% This function deletes the given interval from both end of the given
% matrix
function APMatrix = cutSweepEnds(timeVector, APMatrix, segments, cutInterval)
  
  apTime = timeVector(APMatrix(:,3));
  goodAPIdx = (segments(1)+cutInterval<=apTime&...
      apTime<=sum(segments(1:2))-cutInterval);
  APMatrix = APMatrix(goodAPIdx,:);
  
end

% Getter function for a specific sweep.
function sweepVector = getSweep(ivStruct, sweepID)
  sweepName = sprintf('v%d', sweepID);
  sweepVector = ivStruct.(sweepName);
end

% Parameter validator functon
function parameters = checkParameters(~, parameters)
  freqBound = parameters.plot.frequencyBound;
  freqBound(1) = max([freqBound(1), ceil(1/parameters.minSliceLength)]);
  freqBound(2) = min([freqBound(2), parameters.max]);
  
  parameters.plot.frequencyBound = freqBound;
end