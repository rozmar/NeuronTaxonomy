% handleIntersection process the condition intersection of intervals for
% each reference marker. If an interval contains another, "make a hole" on
% the larger interval.
% Parameters
%  - conditions - mx1 struct, where each struct represents a condition. A
%    condition structure has the following fields
%     - type - type of condition, possible values
%         1 - this condition have to be true for this interval
%         0 - this condition have to be false for this interval
%     - interval - 1x2 vector, the interval in which the condition will be
%     interpreted. The borders of the interval are given relatively to the
%     trigger
%     - marker - the name of the marker to which this condition refers to
% Return value
%  - interval - nx1 structure with the following fields as the input. This
%    contains the new, disjoint conditions
function interval = handleIntersection(conditions)

  %% ---------------------------
  %  Initialization
  %% ---------------------------
  nCondition = length(conditions);
  intBounds  = zeros(nCondition,2);
  intMarker  = zeros(nCondition,1);
  %% ---------------------------
  
  %% ---------------------------
  %  Collect interval properties
  %% ---------------------------
  for i = 1 : nCondition
    intBounds(i,:) = conditions(i).interval;
    intMarker(i)   = conditions(i).type;
  end
  %% ---------------------------
  
  %% ---------------------------
  %  Split intersecting intervals
  %% ---------------------------
  [intMat,typeVec] = intersectIntervals(intBounds, intMarker);
  %% ---------------------------
  
  %% ---------------------------
  %  Reassemble interval struct
  %% ---------------------------
  interval = struct( ...
      'type',     num2cell(typeVec,2), ...
      'interval', num2cell(intMat,2), ...
      'marker',   '');
  %% ---------------------------
  
end