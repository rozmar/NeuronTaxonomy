% collectTriggers collects triggers from the input structure and removes
% those which don't satisfy every conditions. Section and trigger
% conditions can be given separately (one of them, both, or none of
% them). If no condition was given, returns all triggers. If no trigger
% remain, throws an error. If any section was given, for each trigger, a
% position index will be assigned, which represents its position inside the
% section. If no section was given, all trigger get the same value.
%
% Parameters
%  - inputStructure - structure which contains necessary fields: trigger
%    channel, section channel (if section condition given), marker channels
%    to which any condition refers.
%  - parameters - structure which contains the conditions. Fields:
%    - trigger - structure referring to triggers (optional)
%      - name - name of the trigger
%      - conditions - condition structure referring to triggers
%    - section - structure referring to sections (optional)
%      - name - name of the section
%      - conditions - condition structure referring to sections
% Return value
%  - triggerVector - nx1 vector which contains all trigger which staisfied 
%    every given condition 
%  - labelVector - nx1 vector which contains all trigger's label 
%    which staisfied every given condition. The label is based on the
%    trigger's position in the section. If no section was given, all
%    trigger belongs to the same class.
function [triggerVector,positionVector] = collectTriggers(inputStructure, parameters)

    checkTriggerParameters(parameters);

    % Default, all of the trigger needed
    triggerVector = getMarkersByField(inputStructure, parameters.trigger.name);
    % Default, all of the trigger will belong to the same class
    positionVector   = ones(size(triggerVector));
  
    if toLog
      global logFile; %#ok<TLEV>
    end
    
    % If section condition(s) is/are given process them.
    if hasSectionCondition(parameters)
      
      try 
        % Collect sections to which the conditions refer
        segmentStructure = getSingleSegment(inputStructure, parameters.section);
      catch Exception
          
        if strcmpi(Exception.identifier, 'Segment:hasSegment')
          warning( Exception.message );
          segmentStructure = createSegmentFromMarker(triggerVector, struct('maxTimeDifference',0.15));
        end
      end
    
      % Process the section conditions
      flagVector = processSectionConditions(segmentStructure, inputStructure, parameters.section);
      
      fprintf('Remaining %s: %d\n', parameters.section.title, sum(flagVector));
  
      if toLog
        fprintf(logFile, '%s remained;%d\n', parameters.section.title, sum(flagVector));  
      end
    
      % Remove segments which violate any of the conditions
      segmentStructure = removeSegments(segmentStructure, ~flagVector);
    
      % Collect triggers during sections
      eventsBySegment = collectEventInSegment(triggerVector, segmentStructure);
      % Create label for all trigger
      eventLabelBySegment = labelSegments(eventsBySegment);
    
      % Create trigger vector
      triggerVector = sort(cell2mat(eventsBySegment));
      % Create trigger label vector
      positionVector   = cell2mat(eventLabelBySegment);
    
     % End run, if none of the triggers remained.
      warnEmptyTrigger(triggerVector);
    end
  
    % If trigger condition(s) is/are given process them.
    if hasTriggerCondition(parameters)
        
      % Process trigger conditions
      flagVector = processMarkerConditions(triggerVector, inputStructure, parameters.trigger);
    
      fprintf('Remaining trigger: %d\n', sum(flagVector));
    
      if toLog
        fprintf(logFile, '%s remained;%d\n', parameters.trigger.title, sum(flagVector));
      end
      
      % Retain triggers and their labels which satisfy every condition
      triggerVector = triggerVector(flagVector);
      % Retain those triggers' labels
      positionVector   = positionVector(flagVector);
    
      % End run, if none of the triggers remained.
      warnEmptyTrigger(triggerVector);
    end
end

% Labels each trigger in each segment by its position
function eventLabelBySegment = labelSegments(eventsBySegment)
  nSegment = length(eventsBySegment);
  eventLabelBySegment = cell(nSegment, 1);
  
  for i = 1 : length(eventsBySegment)
     eventLabelBySegment{i} = (1:length(eventsBySegment{i}))';
  end
end

% Checks if the given vector is empty.
% If yes, throw an error.
function warnEmptyTrigger(triggerVector)
  if isempty(triggerVector)
    message = 'None of the triggers has satisfied every condition!';
    throw(MException('CollectTrigger:EmptyTrigger',message));
  end
end

% Check if trigger name was given.
function checkTriggerParameters(parameters)
  if ~isfield(parameters, 'trigger')
    showError('Trigger parameter wasn''t given!');
  end
  
  if ~isfield(parameters.trigger, 'name')
    showError('Trigger name wasn''t given!'); 
  end
  
  
end

% Removes segements from the segment structure 
% which are indicated by remove flag
function segmentStructure = removeSegments(oldSegmentStructure, toRemoveFlag)
  segmentStructure = oldSegmentStructure;
  segmentStructure.start(toRemoveFlag) = [];
  segmentStructure.end(toRemoveFlag)   = [];
end

% If any marker condition was given.
function answer = hasTriggerCondition(parameters)
  answer = isfield(parameters, 'trigger');
end

% If any section condition was given.
function answer = hasSectionCondition(parameters)
  answer = isfield(parameters, 'section');
end