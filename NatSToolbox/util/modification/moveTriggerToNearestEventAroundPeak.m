% moveTriggerToNearestEventAroundPeak find the largest intensity peak
% around the trigger using the KDE based peak-finding. Then search for the
% nearest event and move the trigger to that position.
%
% Parameters
%  - triggerVector - nx1 vector, the initial trigger around which the
%  intensity peak and the nearest spike have to be searched
%  - inputStructure - structure which contains the input channels
%  - parameters - parameter structure which contains the settings for
%  trigger modification. Mandatory fields are:
%    - 
function modifiedTriggerVector = moveTriggerToNearestEventAroundPeak(triggerVector, inputStructure, parameters)

  % Find maximal intensity peak around triggers
  maxPeakLatency = findMaxPeakLatency(inputStructure, parameters);
  close gcf;
  
  % Shift the triggers to the maximal peak
  initialTrigger = triggerVector;
  triggerVector  = triggerVector + maxPeakLatency;
  
  % Move trigger to the nearest event to the peak
  modifiedTriggerVector = ...
      moveTriggerToNearestEvent(triggerVector, inputStructure, parameters);
    
  plotPeritriggerEventRaster(mat2cell(modifiedTriggerVector-initialTrigger, ones(size(modifiedTriggerVector))), struct('color','r'));
  
  fprintf('Modification: move trigger to the nearest event around the intensity peak\n');
  fprintf('The intensity peak latency was: %.4f\n', maxPeakLatency);
  
  
end

function maxPeakLatency = findMaxPeakLatency(inputStructure, parameters)
  [resultStructure] = ...
      calculatePeritriggerDistribution(inputStructure, parameters);
  
  maxPeakLatency = getMaximalPeakTime(resultStructure);
end

function maxPeakLatency  = getMaximalPeakTime(resultStructure)
  maxPeakPosition = getMaximalPeak(resultStructure);
  timeVector = resultStructure.densityTime;
  maxPeakLatency = timeVector(maxPeakPosition);
end

% Get the maximal peak index
function maxPeakPosition = getMaximalPeak(resultStructure)
  peakIndices = resultStructure.peakLocations;
  peakValues  = resultStructure.densityFunction(peakIndices);
  [~,maxPeakPosition] = max(peakValues);
  maxPeakPosition = peakIndices(maxPeakPosition);
end
