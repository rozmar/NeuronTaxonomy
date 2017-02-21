function calculateSingleCellWavelet(inputStructure, parameters)

  ivStruct   = inputStructure.iv;
  featStruct = inputStructure.cellStruct;

  apFeatures  = featStruct.apFeatures;
  apSweepId   = apFeatures(:,1);
  sweepWithAP = unique(apSweepId);
  numAPSweep  = length(sweepWithAP);
  
  parameters.segmentBnd = ivStruct.segment./1000;
  
  signalStructure.times = ivStruct.time;
  
  fprintf('Number of sweep with AP: %d\n', numAPSweep);
  averagePowerSpectrum = [];
  for i = 1 : numAPSweep
      
    fprintf('Process %d/%d sweep\n', i, numAPSweep);
      
    thisSweepAP = apFeatures(apSweepId==sweepWithAP(i),:);
    signalStructure.values = getSweep(ivStruct, sweepWithAP(i));
    slicesBetweenSpike = cutSlicesBetweenSpikes(signalStructure, thisSweepAP, parameters);
    
    if isempty(slicesBetweenSpike)
      fprintf('There wasn''t any slice on sweep %d\n', sweepWithAP(i));
      continue;
    end
    
    averagePowerMatrix = [];
    weights = zeros(length(slicesBetweenSpike),1);
    
    for s = 1 : length(slicesBetweenSpike)
      [PowerMatrix, freqVector] = calculateTFDPower(slicesBetweenSpike(s).values, parameters);
      
      if parameters.plot.plotSpectrogram
        figure;
        plotPowerSpectrum(slicesBetweenSpike(s).times, freqVector, PowerMatrix, parameters.plot);
        title(sprintf('Sweep %d, Slice %d', sweepWithAP(i), s));
      end
      
      weights(s) = size(PowerMatrix,2);
      averagePowerMatrix = [averagePowerMatrix, nanmean(PowerMatrix,2).*weights(s)];
      
    end
    
    averagePowerMatrix = sum(averagePowerMatrix,2)./sum(weights);
    averagePowerSpectrum = [averagePowerSpectrum;averagePowerMatrix'];
    
    figure;
    plot(freqVector, averagePowerMatrix);
    if isfield(parameters.plot, 'frequencyBound')
      xlim(parameters.plot.frequencyBound);
    end
    title(sprintf('Power Spectrum weighted average for sweep %d', sweepWithAP(i)));
    
  end
  
  figure;
  plot(freqVector, nanmean(averagePowerSpectrum,1));
  if isfield(parameters.plot, 'frequencyBound')
    xlim(parameters.plot.frequencyBound);
  end
  title('Average over sweeps');
  
end


function sliceStructure = cutSlicesBetweenSpikes(signalStructure, thisSweepAP, parameters)

  segmentStructure = createBetweenSpikeSegment(signalStructure.times, thisSweepAP, parameters);
  sliceArray = collectSlicesOfSegments(segmentStructure, signalStructure);
  
  signalStructure.values = signalStructure.times;
  timeSliceArr = collectSlicesOfSegments(segmentStructure, signalStructure);
  
  sliceStructure = struct('times', timeSliceArr, 'values', sliceArray);
end

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

function APMatrix = cutSweepEnds(timeVector, APMatrix, segments, cutInterval)
  
  apTime = timeVector(APMatrix(:,3));
  goodAPIdx = (segments(1)+cutInterval<=apTime&...
      apTime<=sum(segments(1:2))-cutInterval);
  APMatrix = APMatrix(goodAPIdx,:);
  
end

function sweepVector = getSweep(ivStruct, sweepID)
  sweepName = sprintf('v%d', sweepID);
  sweepVector = ivStruct.(sweepName);
end