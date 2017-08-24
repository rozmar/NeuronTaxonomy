% moveTriggerToNearestEvent moves the given triggers to the nearest event
% vector. The event channel's name have to be given in parameters structure
% and have to be present in inputStructure.
%
% Parameters
%  - triggerVector - nx1 vector, the initial trigger vector which have to
%    be modified
%  - inputStructure - input structure with fields representing the
%    channels. It has to contain at least the necessary channels.
%  - parameters - parameter structure which contains the settings for the
%    analysis. Fields:
%     - searchRadius - the radius around the trigger where the possible
%     closest event will be searched. If is empty, the whole recording will
%     be searched.
%     - eventName - name of the channel which contain the events to search.
function modifiedTriggerVector = moveTriggerToNearestEvent(triggerVector, inputStructure, parameters)

  % Check existence of event channel
  checkFieldExist(inputStructure, parameters.eventName);

  % Find the nearest evet for each trigger
  nearestPairVector = ...
      findNearestPairs(triggerVector, ...
      inputStructure.(parameters.eventName).times, parameters);
  
  % Save new trigger to the output
  modifiedTriggerVector = nearestPairVector; 
  
  % Remove NaN if only the valid triggers are needed
  if isfield(parameters,'needNan')&&~parameters.needNan
    modifiedTriggerVector(isnan(nearestPairVector)) = [];
  end
  
end