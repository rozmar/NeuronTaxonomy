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
  spectralMode = parameters.spectral.mode;
  plotVector = getPlottingVector(parameters.plot);
  
  parameters.segmentBnd = ivStructure.segment./1000;
  parameters.wavelet.interval   = 1/featStruct.samplingRate;
  
  parameters.fourier.samplingRate = featStruct.samplingRate;
  
  meanPowerSpectrum = cell(1,numAPSweep);
  meanMembPotential = zeros(1,numAPSweep).*NaN;
  %% ---------------------------
  
  % ---------------------------
  %  Loop through each firing sweep
  % ---------------------------
  for i = 1 : numAPSweep
    
    % Collect slices between spikes
    slicesBetweenSpike = ...
        collectSliceBetweenSpike(ivStructure, ...
        apFeatures, ...
        sweepWithAP(i), ...
        apSweepId==sweepWithAP(i), ...
        parameters);
    
    % Number of valid slices
    numSlice = length(slicesBetweenSpike);
    
    % Sweep without slice will be skipped
    if numSlice == 0 
      continue;
    end
    
    % Prepare for wavelet transformation
    meanPowerMatrix = cell(1, numSlice);
    avgSlice        = zeros(1,numSlice);
    weights = [slicesBetweenSpike.length];
    weights = weights./sum(weights);
    
    % --------------------
    % Do spectral analysis
    % for each slice.
    % --------------------
    for s = 1 : numSlice
      
      % Calculate membrane potential
      % as the mean of the slice
      thisSlice = slicesBetweenSpike(s).values;
      avgSlice(s) = mean(thisSlice);
      
      if spectralMode == 1  % Mode == wavelet
          
        % Calculate wavelet power
        [PowerMatrix, frequencyVector] = calculateTFDPower(thisSlice, parameters.wavelet);
        % Trim frequency band which won't be plotted
        [PowerMatrix, frequencyVector] = ...
          trimBoundaries(PowerMatrix, frequencyVector, parameters);
      
        % Do the spectrogram
        if plotVector(1)
          
          thisTime = slicesBetweenSpike(s).times;
          
          figure;
          plotPowerSpectrum(thisTime, frequencyVector, PowerMatrix, parameters.plot);
          title(sprintf('Sweep %d, Slice %d', sweepWithAP(i), s));
        end
      
        % Average over time by frequency
        meanPowerMatrix{s} = nanmean(PowerMatrix,2).*weights(s);
        
      elseif spectralMode == 2  % Mode == FFT
          
        % Calculate the FFT power
        [fftPower, frequencyVector] = ...
            performFFT(thisSlice, parameters.fourier);
         
        % Trim frequency band which won't be plotted
        [fftPower, frequencyVector] = ...
          trimBoundaries(fftPower, frequencyVector, parameters);
          
        % Save the weighted power
        meanPowerMatrix{s} = fftPower.*weights(s);
      end
      
    end
    % End of the spectral
    % analysis
    % --------------------
    
    % Calculate weighted average of power for a sweep
    meanPowerSpectrum{i} = sum(cell2mat(meanPowerMatrix),2);
    
    % Calculate weighted average of membrane potential
    meanMembPotential(i) = sum(avgSlice.*weights);
    
    % Plot current sweep's average power spectrum
    if plotVector(2)
        
      figure;
      subplot(2,1,1);
      plot(frequencyVector, meanPowerSpectrum{i});
      
      if isfield(parameters.plot, 'frequencyBound')
        xlim(parameters.plot.frequencyBound);
      end
      
      title(sprintf('Power Spectrum weighted average for sweep %d (%.3f sec)', sweepWithAP(i), slicesBetweenSpike(s).length*1/featStruct.samplingRate));
      
      subplot(2,1,2);
      plot(slicesBetweenSpike(s).times, slicesBetweenSpike(s).values);
    end
    
  end
  % End of processing a sweep
  % ---------------------------
  
  %% --------------------------
  %  Remove sweep without slice
  %% --------------------------
  emptyPower = cellfun(@isempty, meanPowerSpectrum);
  emptyMemPot = isnan(meanMembPotential);
  meanPowerSpectrum(emptyPower) = [];
  meanMembPotential(emptyMemPot) = [];
  
  if isempty(meanMembPotential)
      resultStructure = [];
      return;
  end
  %% --------------------------
  
  %% --------------------------
  %  Find the maximal power
  %  value and frequency
  %% --------------------------  
  [maxPowerValue,maxPowerPos] = cellfun(@max, meanPowerSpectrum);
  %[maxPowerValue, maxPowerPos] = max(cell2mat(meanPowerSpectrum));
  maxPowerFreq = frequencyVector(maxPowerPos);
  %% --------------------------
  
  %% --------------------------
  %  Assemble result set
  %% --------------------------
  resultStructure.numSweep = length(meanMembPotential);
  resultStructure.meanPowerSpectrum = meanPowerSpectrum;
  resultStructure.meanMembranePotential = meanMembPotential;
  resultStructure.maxPower = maxPowerValue;
  resultStructure.maxPowerFreq = maxPowerFreq;
  %% --------------------------
  
end

% This function cut slices between spikes from a given sweep
function slicesBetweenSpike = collectSliceBetweenSpike(ivStructure, apFeatures, sweepNumber, thisSweepFlag, parameters)

  % Get AP features for this sweep
  thisSweepAP = apFeatures(thisSweepFlag,:);
  
  % Get sweep's time and signal
  signalStructure.times  = ivStructure.time;
  signalStructure.values = getSweep(ivStructure, sweepNumber);
  
  % Cut slices for each segment
  slicesBetweenSpike = ...
      cutSlicesBetweenSpikes(signalStructure, thisSweepAP, parameters);
  
  % Concatenate slices 
  if ~isempty(slicesBetweenSpike) && isConcat(parameters)
    slicesBetweenSpike = concatenateSegments(slicesBetweenSpike);
  end
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
  if length(sliceArray) == 1
    sliceStructure.length = lengthBySegment;
    return;
  end
  
  lengthArray = num2cell(lengthBySegment, [length(sliceArray),1]);
  [sliceStructure.length] = deal(lengthArray{:});
  
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

% This function deletes the given interval 
% from both end of the given matrix
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

  if parameters.spectral.mode == 1
    
    freqBound = parameters.plot.frequencyBound;
    freqBound(1) = max([freqBound(1), ceil(1/parameters.minSliceLength)]);
    freqBound(2) = min([freqBound(2), parameters.max]);
  
    parameters.plot.frequencyBound = freqBound;
  end
end

% Creates a flag vector to indicate needed plot
function plotVector = getPlottingVector(parameters)
  plotVector(2) = ...
      isfield(parameters, 'plotSinglePowerSpect') && ...
      parameters.plotSinglePowerSpect;

  plotVector(1) = ...
    isfield(parameters, 'plotSpectrogram') && ...
    parameters.plotSpectrogram;
end

% Decide if we should perform concatenation
function answer = isConcat(parameters)
  answer = isfield(parameters, 'concatSlices') && parameters.concatSlices;
end