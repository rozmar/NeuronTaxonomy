% findNearestPairs find the nearest events from a vector for each element
% of another vector (reference). The searching radius can be restricted
% with parameter.
%
% Parameters
%  - referenceVector - nx1 vector, triggers to which the pairs have to be
%  found
%  - pairingEvents - ex1 vector, events which have to be paired to the
%  triggers
%  - parameters - settings for search
%    - searchRadius (optional) - maximal distance where events can be found
%    - emptyMode (optional) - what to do with trigger which don't have any
%      event around it in the given radius, possible values: 
%       - 'discard' - drop that trigger
%       - 'retain'  - that trigger doesn't change
% Return values
%  - nearestPairVector - nx1 vector which contains the nearest pairing
%  events to the references
function nearestPairVector = findNearestPairs(referenceVector, pairingEvents, parameters)

  % Initialize return value
  nearestPairVector      = zeros (size(referenceVector));
  
  % Create segment indicating interval around trigger
  periReferenceStructure = createPeritriggerSegment(referenceVector, ...
      struct('analysis', ...
      struct('radius',parameters.searchRadius)));
  
  % Collect events in the given radius
  eventsInRadius = collectEventInSegment(pairingEvents, periReferenceStructure);
  
  % Examine each trigger's interval
  for i = 1 : length(eventsInRadius)
      
    % Find the closest event to the reference value
    closestValue = getClosest(referenceVector(i), eventsInRadius{i});
    
    % Handle the case when there isn't any event in the given interval
    if isempty(closestValue)
      if strcmpi(parameters.emptyMode, 'discard')
        closestValue = NaN; 
      elseif strcmpi(parameters.emptyMode, 'retain')
        closestValue = referenceVector(i);
      end
    end
    
    % Save to output
    nearestPairVector(i) = closestValue;
    
  end
  
end

% Returns the closest value from an array to a reference.
function closestValue = getClosest(toWhich, fromWhat)

  [~,minPos]   = min(abs(fromWhat - toWhich));
  closestValue = fromWhat(minPos);
    
end