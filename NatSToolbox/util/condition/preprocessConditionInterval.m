% preprocessConditionInterval take each interval from a given condition 
% structure and perform the preprocessing steps:
%  * splits the interval around 0
%  * remove interval inclusion/intersection
% Parameters
%  - conditions - mx1 struct, where each struct represents a condition. A
%    condition structure has the following fields
%     - type - type of condition, possible values
%       1 - this condition have to be true for this interval
%       0 - this condition have to be false for this interval
%     - interval - 1x2 vector, the interval in which the condition will be
%       interpreted. The borders of the interval are given relatively to the
%       trigger
%     - marker - the name of the marker to which this condition refers to
% Return value
%  - newConditions - condition structure with the previously given fields,
%    but each interval will be disjoint
function newConditions = preprocessConditionInterval(conditions)

  %% ---------------------------
  %  In case of empty condition
  %  structure we do nothing.
  %% ---------------------------
  if isempty(conditions)
    newConditions = conditions;
    return; 
  end

  %% ----------------------------
  %  Split intervals 
  %% ----------------------------  
  conditions = splitInterval(conditions);
  %% ----------------------------

  %% ----------------------------
  %  Initialization
  %% ----------------------------
  makerNameArray = {conditions(:).marker};
  markerTypeNames = unique(makerNameArray);
  nMarkerType     = length(markerTypeNames);
  newConditions   = [];
  %% ----------------------------
  
  %% ----------------------------
  %  Split intersecting intervals.
  %% ----------------------------
  for i = 1 : nMarkerType
      
    %% ----------------------------
    %  Select conditions referring 
    %  to this marker
    %% ----------------------------
    thisMarkerName  = markerTypeNames{i};
    thisMarkerConds = ...
        collectConditionsByMarker(conditions, makerNameArray, thisMarkerName);
    %% ----------------------------
    
    %% ----------------------------
    %  Handle interval intersections
    %% ----------------------------
    thisMarkerConds = handleIntersection(thisMarkerConds);  
    [thisMarkerConds(:).marker] = deal(thisMarkerName);
    %% ----------------------------
    
    % Append to output
    newConditions = [ newConditions , thisMarkerConds ]; %#ok<AGROW>
  end
  %% ----------------------------
  
end

% Collect those conditions which refer to the same marker.
function conditionsForMarker = collectConditionsByMarker(conditions, nameArray, currentName)
  conditionsForMarker = conditions(strcmpi(nameArray, currentName));
end