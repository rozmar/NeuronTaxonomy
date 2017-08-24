% processMarkerConditions process the conditions which refer to an 
% interval around a given trigger-marker.
% Parameters
%  - triggerVector - vector of the trigger markers. It is needed to
%    provide individual method invocation.
%  - inputStructure - input structure, which have to contain every channel 
%    which will be examined 
%  - parameters - parameter structure with the following fields
%    - isSilent - (optional) supress status message, default false
%    - conditions - mx1 struct, where each struct represents a condition. A
%      condition structure has the following fields
%       - type - type of condition, possible values
%           1 - this condition have to be true for this interval
%           0 - this condition have to be false for this interval
%       - interval - 1x2 vector, the interval in which the condition will be
%       interpreted. The borders of the interval are given relatively to the
%       trigger
%       - marker - the name of the marker to which this condition refers to
% Return values
%  - flagVector - nx1 boolean vector, where n is the number of
%    trigger markers and each element will mark that that marker satisfies
%    all of the conditions or not.
function flagVector = processMarkerConditions(triggerVector, inputStructure, parameters)

  %% -------------------------
  %  Initial decisions
  %% -------------------------
  flagVector = true(size(triggerVector));   % initialize  return value
  isSilent   = isfield(parameters,'isSilent')&&parameters.isSilent;
  
  if ~isSilent
    fprintf('All %s: %d\n', parameters.title, length(triggerVector));
    
    if toLog
      global logFile; %#ok<TLEV>
      fprintf(logFile, 'all %s;%d\n', parameters.title, length(triggerVector));
    end
  end

  % If there isn't any condition,
  if ~isfield(parameters, 'conditions')
      
    % we retain all of the markers.
    if ~isSilent
      fprintf('No trigger condition was given.\n');
    end
    return;
  end
  %% -------------------------
  
  %% -------------------------
  % Preprocess condition intervals 
  % * handle intersection
  % * split around 0
  %% -------------------------
  conditions = preprocessConditionInterval(parameters.conditions);
  nCondition = length(conditions);
  %% -------------------------
      
  %% -------------------------
  %  Process each condition
  %% -------------------------
  for i = 1 : nCondition
      
    % Select current condition
    thisCondition = conditions(i);
    thisInterval  = thisCondition.interval;
      
    % Create segment from condition interval
    segmentStructure = createSegmentFromInterval(triggerVector, thisInterval);
    % Execute the current condition
    thisFlagVector   = executeCondition(inputStructure, segmentStructure, thisCondition);
    % Set flags 
    flagVector       = flagVector&thisFlagVector;
    
    % Print status
    if ~isSilent
      fprintf('%d trigger violated condition: %s\n', sum(~thisFlagVector), conditionToString(thisCondition));
      
      if toLog
        fprintf(logFile, '%s;%d\n',  conditionToString(thisCondition, 'inv'), sum(~thisFlagVector));
      end
    end
    
  end
  
  %% -------------------------
  
end

% This function executes a single condition on the given segments.
function flagVector = executeCondition(inputStructure, segmentStructure, condition)
  
  % Get type of condition
  mode = getConditionType(condition);
  % Get the event markers to which the condition refers
  conditionMarkerVector = getMarkersByField(inputStructure, condition.marker);
  % Find flags where the condition has been met
  flagVector  = findSegmentWithEvent(segmentStructure, conditionMarkerVector, mode);
end

% Translate condition type signal to text.
function mode = getConditionType(condition)
  if condition.type==1
    mode = 'within';
  elseif condition.type==0
    mode = 'without';
  end
end 