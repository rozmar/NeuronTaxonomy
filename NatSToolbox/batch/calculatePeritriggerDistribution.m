function [resultStructure,parameters] = calculatePeritriggerDistribution(inputStructure, parameters)

  % Collect peritrigger events from the file
  eventParameters = struct(...
      'triggerName', parameters.channel.trigger.name,...
      'eventName', parameters.channel.event.name,...
      'radius', parameters.analysis.radius);
  
  % Collect pooled peritrigger event vector
  eventVector = collectPeriTriggerEventVector(inputStructure, eventParameters);
  
  % Store value in result structure
  resultStructure.name              = inputStructure.title;
  resultStructure.peritriggerEvents = eventVector;
  
  % Estimate distribution with KDE
  [resultStructure.densityFunction,resultStructure.densityTime] ...
      = doEstimation(eventVector, parameters.analysis);
  
  % Find the prominent peaks on the dist. function
  resultStructure.peakLocations = findProminentPeaks(...
      resultStructure.densityFunction, ...
      resultStructure.densityTime, parameters.analysis);
  
  title(strrep(resultStructure.name, '_', '\_'));
  
%   printStatus([inputStructure.title,' peak locations']);
%   for i = 1 : length(resultStructure.peakLocations)
%     fprintf('%.4f\t', resultStructure.densityTime(resultStructure.peakLocations(i)));
%   end
%   fprintf('\n');
  
end

% Collect events around the trigger and pool them to a vector
function eventVector = collectPeriTriggerEventVector(inputStructure, parameters)

  triggerVector = getMarkersByField(inputStructure, parameters.triggerName);
  eventVector   = getMarkersByField(inputStructure, parameters.eventName);
  
  peritriggerEvents = cell(length(triggerVector),1);

  for i = 1 : length(triggerVector)
    peritriggerEvents{i} = collectEventsBetweenMarker(eventVector, parameters.radius + triggerVector(i)) - triggerVector(i);
  end
  
  figure;
  plotPeritriggerEventRaster(peritriggerEvents, []);
  
  eventVector = sort(cell2mat(peritriggerEvents));
end

% Estimate the distribution function of the given events with the given
% parameters.
function [densityFunction,densityTime] = doEstimation(eventVector, parameters)

  timeVector  = (parameters.radius(1):0.0001:parameters.radius(2))';

  [densityFunction,densityTime] = estimateWithKDE(eventVector, timeVector, parameters.smoothingPValue);
end
