function [resultStructure, parameters] = calculateSingleCellWavelet(inputStructure, parameters)

  %% ---------------------------
  %  Initialization
  %% ---------------------------
  parameters = checkParameters(inputStructure, parameters);
  
  % Resample signal if needed
  inputStructure = preprocessData(inputStructure, parameters);
  %% ---------------------------
  
  %% ---------------------------
  %  Get the data
  %% ---------------------------
  ivStructure = inputStructure.iv;
  featStruct  = inputStructure.cellStruct;

  apFeatures = featStruct.apFeatures;
  apSweepId = apFeatures(:,1);
  firingSweepID = unique(apSweepId);
  numFiringSweep = length(firingSweepID);
  spectralMode = parameters.spectral.mode;
  plotVector = getPlottingVector(parameters.plot);
  
  parameters.segmentBnd = ivStructure.segment./1000;
  sampleInterval = min(diff(ivStructure.time));
  parameters.wavelet.interval = sampleInterval;
  
  parameters.fourier.samplingRate = 1 / min(diff(ivStructure.time));
  
  meanPowerSpectrum = cell(1,numFiringSweep);
  meanMembPotential = zeros(1,numFiringSweep).*NaN;
  segmentLength = zeros(1, numFiringSweep) .* NaN;
  sweepISIVector = cell(1, numFiringSweep);
  slicePerSweep = cell(1, numFiringSweep);
  %% ---------------------------
  
  % ---------------------------
  %  Loop through each firing sweep
  % ---------------------------
  for i = 1 : numFiringSweep
    
    % Collect slices between spikes
    slicesBetweenSpike = ...
        collectSliceBetweenSpike(ivStructure, ...
        apFeatures, ...
        firingSweepID(i), ...
        apSweepId==firingSweepID(i), ...
        parameters);
    
    % Number of valid slices
    numSlice = length(slicesBetweenSpike);
    
    % Sweep without slice will be skipped
    if numSlice == 0 
      continue;
    end
    
    % Remove too short segments
    if numSlice == 1 && isConcat(parameters) && (slicesBetweenSpike(1).duration < 0.2)
      continue;
    end
    
    % Prepare for wavelet transformation
    meanPowerMatrix = cell(1, numSlice);
    avgSlice        = zeros(1,numSlice);
    weights = [slicesBetweenSpike.length];
    segmentLength(i) = slicesBetweenSpike.duration;
    weights = weights./sum(weights);
    
    % --------------------
    % Do spectral analysis
    % for each slice.
    % --------------------
    for s = 1 : numSlice
      
      % Calculate membrane potential
      % as the mean of the slice
      thisSlice = slicesBetweenSpike(s).values;
      avgSlice(s) = slicesBetweenSpike(s).meanVal;
            
      if strcmpi(spectralMode, 'wvl') % Mode == wavelet
          
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
          title(sprintf('Sweep %d, Slice %d', firingSweepID(i), s));
        end
      
        % Average over time by frequency
        meanPowerMatrix{s} = nanmean(PowerMatrix,2).*weights(s);
        
      elseif strcmpi(spectralMode, 'fft')  % Mode == FFT
          
        % Calculate the FFT power
        [fftPower, frequencyVector] = ...
            performFFT(thisSlice, parameters.fourier);
         
        % Trim frequency band which won't be plotted
        [fftPower, frequencyVector] = ...
          trimBoundaries(fftPower, frequencyVector, parameters);
          
        if ~isConcat(parameters)
          
        end
        
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
    
    sweepISIVector{i} =...
      collectISIForSweep(...
      apFeatures(apSweepId==firingSweepID(i), :),...
      min(diff(ivStructure.time))); 
    
    % Plot current sweep's average power spectrum
    if plotVector(2)
        
      figure;
      subplot(2,1,1);
      plot(frequencyVector, meanPowerSpectrum{i});
      
      if isfield(parameters.plot, 'frequencyBound')
        xlim(parameters.plot.frequencyBound);
      end
      
      title(sprintf('Power Spectrum average, sweep %d (%.3f sec), membrane potential: %f', firingSweepID(i), slicesBetweenSpike(s).length*1/parameters.fourier.samplingRate, meanMembPotential(i)));
      
      subplot(2,1,2);
      plot(slicesBetweenSpike(s).times, slicesBetweenSpike(s).values);
    end
    
    slicePerSweep{i} = slicesBetweenSpike;
    
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
  segmentLength(emptyMemPot) = [];
  sweepISIVector(emptyMemPot) = [];
  
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
  maxPowerFreq = frequencyVector(maxPowerPos);
  %% --------------------------
  
  %% --------------------------
  %  Assemble result set
  %% --------------------------
  resultStructure.numSweep = length(meanMembPotential);
  resultStructure.frequencyVector = frequencyVector;
  resultStructure.meanPowerSpectrum = meanPowerSpectrum;
  resultStructure.meanMembranePotential = meanMembPotential;
  resultStructure.maxPower = maxPowerValue;
  resultStructure.maxPowerFreq = maxPowerFreq;
  resultStructure.segmentLength = segmentLength;
  resultStructure.sweepISIVector = sweepISIVector;
  resultStructure.slicePerSweep = slicePerSweep;
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
    retainIndex = (boundary(1)<=freqVector & freqVector<=boundary(2));
    freqVector = freqVector(retainIndex);
    PowerMatrix = PowerMatrix(retainIndex,:);
  end
end

% This function find and cut the slices between spikes
function sliceStructure = cutSlicesBetweenSpikes(signalStructure, thisSweepAP, parameters)

  % Find and cut values
  segmentStructure = createBetweenSpikeSegments(signalStructure.times, thisSweepAP, parameters);
  sliceArray = collectSlicesOfSegments(segmentStructure, signalStructure);
  
  % Find and cut times
  signalStructure.values = signalStructure.times;
  timeSliceArr = collectSlicesOfSegments(segmentStructure, signalStructure);
  
  % Create structure
  sliceStructure = struct('times', timeSliceArr, 'values', sliceArray);
  
  % If none of the segments 
  % satisfy minimal length condition
  if isempty(timeSliceArr)
    return;
  end
  
  % Lengths of segments
  lengthBySegment = cellfun(@length, sliceArray);
 
  % Store values 
  duration = 0;
  for i = 1 : length(lengthBySegment)
    sliceStructure(i).length = lengthBySegment(i);
    sliceStructure(i).meanVal = mean(sliceStructure(i).values);
    sliceStructure(i).values = detrend(sliceStructure(i).values, 'linear');
   
    thisTimeSlice = timeSliceArr{i};
    sliceStructure(i).duration = diff(thisTimeSlice([1,end]));
  end
  
end

% This function creates segment structures for non-spiking segments
function segmentStructure = createBetweenSpikeSegments(timeVector, APMatrix, parameters)
  
  thresholdTime = timeVector(APMatrix(:,4));
  apMaxTime = timeVector(APMatrix(:,3));
  
  cutStartTime = shiftWithScalar(apMaxTime, parameters.gapAfterSpike);
  cutEndTime   = [thresholdTime(2:end);getSweepEnd(parameters.segmentBnd)];
  cutEndTime = cutEndTime - parameters.gapBeforeThreshold;
  
  sliceLength = diff([cutStartTime, cutEndTime],1,2);
  goodSlice   = (sliceLength>parameters.minSliceLength);
  
  segmentStructure = struct(...
    'start', cutStartTime(goodSlice),...
    'end', cutEndTime(goodSlice));

end

function inputStructure = preprocessData(inputStructure, parameters)
  if parameters.resample
    
    oldSR = round(inputStructure.cellStruct.samplingRate);
    newSR = parameters.newSampleRate;
    
    if oldSR == newSR
      return;
    end
    
    fprintf('Need to resample. Old SR = %dHz\n', oldSR);
    
    numberOfSweep = inputStructure.iv.sweepnum;
    
    for i = 1 : numberOfSweep
      thisSweep = getSweep(inputStructure.iv, i);
      thisSweep = resample(thisSweep, newSR, oldSR);
      inputStructure.iv = setSweep(inputStructure.iv, i, thisSweep);
    end
    
    oldTime = inputStructure.iv.time;
    inputStructure.iv.time = linspace(min(oldTime), max(oldTime),length(thisSweep))';
    
    apFeatures = inputStructure.cellStruct.apFeatures;
    apFeatures(:,3) = round(apFeatures(:,3) .* (newSR / oldSR));
    apFeatures(:,4) = round(apFeatures(:,4) .* (newSR / oldSR));
    inputStructure.cellStruct.apFeatures = apFeatures;
    
  end
end

function isiVector = collectISIForSweep(apFeatures, sampleInterval)
  isiInPoint = apFeatures(2:end, 3) - apFeatures(1:(end-1), 3);
  isiVector = isiInPoint * sampleInterval;
end

function ivStructure = setSweep(ivStructure, sweepID, newSweep)
  sweepName = sprintf('v%d', sweepID);
  ivStructure.(sweepName) = newSweep;
end

% Getter function for a specific sweep.
function sweepVector = getSweep(ivStruct, sweepID)
  sweepName = sprintf('v%d', sweepID);
  sweepVector = ivStruct.(sweepName);
end

% Calculates the end of sweep from segment values
function sweepEndTime = getSweepEnd(segmentBorders)
  sweepEndTime = sum(segmentBorders(1:2));
end

% Parameter validator functon
function parameters = checkParameters(~, parameters)

  % If we use wavelet, we need to check parameters
  if strcmpi(parameters.spectral.mode, 'wvl')
    
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