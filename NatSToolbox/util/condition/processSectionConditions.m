% processSectionConditions process those conditions which refer to the  
% intervals before/after or inside a given section.
% Parameters
%  - segmentStructure - segment structure which contains the segments to
%    examine. It is needed to provide individual invocation.
%  - inputStructure - input structure, which has to contain every channel 
%    which will be examined 
%  - parameters - parameter structure with the following fields
%    - conditions  - mx1 struct, where each element represents a condition. 
%      A condition structure has the following fields
%       - type - type of condition, possible values
%           1 - this condition have to be true for this interval
%           0 - this condition have to be false for this interval
%       - interval - 1x2 vector, the interval in which the condition will be
%       interpreted. The borders of the interval are given relatively to the
%       section itself, eg. negative values will be calculated relative to
%       the section start, positive values relative to the section end. 
%       Empty interval will mean that condition will be interpreted inside 
%       the section.
%       - marker - the name of the marker to which this condition refers to
% Return values
%  - flagVector - nx1 boolean vector, where n is the number of
%    segments and each element will mark that that segment satisfies all 
%    of the conditions or not.
function flagVector = processSectionConditions(segmentStructure, inputStructure, parameters)

  %% -------------------------
  %  Initial decisions
  %% -------------------------
  flagVector = true(length(segmentStructure.start),1);   % initialize return value
  
  fprintf('All %s: %d\n', parameters.title, length(flagVector));
  
  if toLog()
    global logFile; %#ok<TLEV>
    fprintf(logFile, 'all %s;%d\n', parameters.title, length(flagVector)); 
  end

  % If there isn't any condition,
  if ~isfield(parameters, 'conditions')
      
    % we retain all of the markers.
    fprintf('No section condition was given.\n');
    return;
  end
  %% -------------------------
  
  %% -------------------------
  %  Preprocess conditions
  %  * split interval around 0
  %  * handle intersections
  %  * divide by reference (start, end, inside)
  %% -------------------------
  conditions = preprocessConditionInterval(parameters.conditions);
  conditionByReference = ...
      divideConditionByReference(conditions);
  referenceArray = ...
      {toCol(segmentStructure.start), [], toCol(segmentStructure.end)};
  referenceText  = {'before', '', 'after'};
  %% -------------------------
      
  %% -------------------------
  %  Process each type of condition.
  %  Before- and after conditions 
  %  will be translated into marker-
  %  conditions. Inside segment conditinos
  %  will be treated separately.
  %% -------------------------
  for type = [1,3]
    thisTypeCondition = conditionByReference{type}; 
    thisReference     = referenceArray{type};
    
    % Take each condition and process that
    for i = 1 : length(thisTypeCondition)

        thisFlagVector    = ...
          processMarkerConditions(thisReference, inputStructure, struct('conditions',thisTypeCondition(i),'isSilent',1));
  
      % Update flag vector
      flagVector        = flagVector&thisFlagVector;
    
%       proofPlotCondition(thisReference, flagVector, inputStructure, thisTypeCondition(i));
      
      % Print status
      fprintf('%d section violates condition: %s %s\n', sum(~thisFlagVector), conditionToString(thisTypeCondition(i)), referenceText{type});
      
      if toLog
        fprintf(logFile, '%s %s;%d\n', conditionToString(thisTypeCondition(i), 'inv'), referenceText{type}, sum(~thisFlagVector));
      end
    end
  end
  %% -------------------------

end

% Cell array which will contain structure arrays 
  % with the same reference. The reference can be
  % segment start, segment end, inside segment
function dividedArray = divideConditionByReference(conditions)
    
  %% ---------------------
  %  Initialize
  %% ---------------------
  dividedArray  = cell(3,1);
  nConditions  = length(conditions);
  classVector  = zeros(nConditions,1); 
  %% ---------------------
  
  %% ---------------------
  %  Check each interval
  %% ---------------------
  for i = 1 : nConditions
      
    thisInterval = conditions(i).interval;
    classVector(i) = 2 + sum(sign(thisInterval));
  end
  %% ---------------------
  
  %% ---------------------
  %  Divide by class
  %% ---------------------
  for i = 1 : 3
    dividedArray{i} = conditions(classVector==i); 
  end
  %% ---------------------
end

%% =========================
%% DEBUG
%% =========================
%  This function plot each section aligned below each other
%  and plot markers (as circles) to which the condition refers. 
%  If the condition is a "have to" and there is a circle on each line 
%  the condition processor script works well.
function proofPlotCondition(thisReference, flagVector, inputStructure, thisTypeCondition)
  %% DEBUG: Plot segment markers and markers
  figure;
  hold on, plot(zeros(size(thisReference(flagVector))), (1:length(thisReference(flagVector)))', 'b-');
  for line = 1 : sum(flagVector), plot([-0.3,0],[line,line],'b-'), end;
  markerMatrix = ones(size(thisReference(flagVector)))*getMarkersByField(inputStructure, thisTypeCondition.marker)';
  referenceMatrix = thisReference(flagVector)*ones(1,size(markerMatrix,2));
  markerMatrix = markerMatrix - referenceMatrix;
  plot(markerMatrix, (1:length(thisReference(flagVector)))'*ones(1,size(markerMatrix,2)), 'ro');
  xlim([-0.3,0]);
  title(sprintf('DEBUG: section %s', conditionToString(thisTypeCondition)));
  hold off;      
end
%% =========================

%% =========================
%  Backup
%% =========================
%% -------------------------
%   %  Process conditions if 
%   %  trigger was section
%   %% -------------------------
%   if regexpi(trType, '^section(st|end)$')
%     
%     % Save section name
%     secName = trName;
%     % Get the real trigger name
%     trName  = strcat(trName, '_', trType(length('section')+1:end));
%     % Count conditions
%     nCond   = length(condSt);
%     
%     % Collect the segments for the sections
%     segments.name       = {secName};
%     parameters.segments = segments;
%     segmentStructure    = collectSegments(inputStructure, parameters);
%     nSegment            = length(segmentStructure.start);
%         
%     % Initialize for search
%     flagVector = true(nSegment,1);
%     for i = 1 : nCond
%         
%        % If interval was given, skip
%        if ~isempty(condSt(i).interval)
%          continue;
%        end
%        
%        flagVector = executeCondition(inputStructure, segmentStructure, condSt(i), flagVector);
%        
%     end
%     
%   end
  %% -------------------------