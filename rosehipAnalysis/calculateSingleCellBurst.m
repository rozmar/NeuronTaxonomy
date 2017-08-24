function resultStructure = calculateSingleCellBurst(inputStructure, parameters)
 
  %% ---------------------------
  %  Get the data
  %% ---------------------------
  ivStructure = inputStructure.iv;
  featureStruct = inputStructure.cellStruct;

  apFeatures = featureStruct.apFeatures;
  apSweepId = apFeatures(:,1);
  firingSweepID = unique(apSweepId);
  numFiringSweep = length(firingSweepID);
  
  timeVector = ivStructure.time;
  
  sweepIV = cell(numFiringSweep, 1);
  sweepBurstArray = cell(numFiringSweep, 1);
  sweepBurstLength = cell(numFiringSweep, 1);
  sweepBurstFrequency = cell(numFiringSweep, 1);
  sweepBurstISI = cell(numFiringSweep, 1);
  %% ---------------------------
  
  % ---------------------------
  % Loop through each firing sweep
  % ---------------------------
  for i = 1 : numFiringSweep
    
    apInSweep = apFeatures(firingSweepID(i) == apSweepId, :);
    apMaxTime = timeVector(apInSweep(:,3));
    
    if length(apMaxTime) == 1 
      continue;
    end
    
    sweepIV{i} = getSweep(ivStructure, firingSweepID(i));
    
    burstArray = findBurstsInSweep(apMaxTime, parameters, ivStructure.segment(1)/1000);
    
    if isempty(burstArray)
      continue;
    end
    
    burstLength = cellfun(@(x) diff(x([1, end])), burstArray);
    
    if length(burstLength) == 1 && burstLength > parameters.maxSingleBurstLength
      continue;
    end
    
    sweepIV{i} = getSweep(ivStructure, firingSweepID(i));
    sweepBurstArray{i} = burstArray;
    sweepBurstLength{i} = burstLength;
    sweepBurstFrequency{i} = calculateBurstFreuqency(burstArray, burstLength);
    sweepBurstISI{i} = cellfun(@diff, burstArray, 'UniformOutput', 0);  % Calculate ISI by burst
      
  end
  % End of processing a sweep
  % ---------------------------
  
  %% --------------------------
  %  Remove invalid bursts
  %% --------------------------
  sweepWithoutBurst = cellfun(@isempty, sweepIV);
  
  sweepIV(sweepWithoutBurst) = [];
  sweepBurstArray(sweepWithoutBurst) = [];
  sweepBurstLength(sweepWithoutBurst) = [];
  sweepBurstFrequency(sweepWithoutBurst) = [];
  sweepBurstISI(sweepWithoutBurst) = [];
  %% --------------------------
  
  resultStructure.numSweep = length(sweepIV);
  resultStructure.timeVector = timeVector;
  resultStructure.sweepIV = sweepIV;
  resultStructure.burstArray = sweepBurstArray;
  resultStructure.burstLength = sweepBurstLength;
  resultStructure.burstFrequency = sweepBurstFrequency;
  resultStructure.burstISI = sweepBurstISI;
  
end

function burstFrequency = calculateBurstFreuqency(burstArray, burstLength)
  
  eventInBurst = cellfun(@length, burstArray);
  burstFrequency = eventInBurst ./ burstLength;
  
end

function burstArray = findBurstsInSweep(apVector, parameters, segmentStart)

  isiVector = diff(apVector(apVector>=(segmentStart+0.02)));
  minIsi = min(isiVector);
  isiVector = diff(apVector);
  
  if isempty(minIsi)
    minIsi = min(isiVector);
  end
  
  if minIsi > parameters.maxIntraBurstValue
    burstArray = {};
    return;
  end;
  
  intraBurstLimit = minIsi * parameters.intraBurstFactor;
  
  burstFlag = (intraBurstLimit >= isiVector);
  
  burstArray = cell(length(apVector), 1);
  numOfBurst = 0;
  while ~isempty(burstFlag)
    firstSpikeInBurst = find(burstFlag, 1, 'first');
    
    if isempty(firstSpikeInBurst)
      break;
    end
    
    lastSpikeInBurst = (firstSpikeInBurst - 1) + find(~burstFlag(firstSpikeInBurst:end), 1, 'first') - 1;
    
    if isempty(lastSpikeInBurst)
      lastSpikeInBurst = length(burstFlag);
    end
    
    numOfBurst = numOfBurst + 1;
    burstArray{numOfBurst} = apVector(firstSpikeInBurst:(lastSpikeInBurst + 1));
    
    burstFlag(1:lastSpikeInBurst) = [];
    apVector(1:(lastSpikeInBurst)) = [];
    
  end
  
  burstArray((numOfBurst + 1):end) = [];
  
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