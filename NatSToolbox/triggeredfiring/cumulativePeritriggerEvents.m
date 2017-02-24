% cumulativePeritriggerEvents creates a cumulative event vector from more
% input event vector. Collects cumulative event for each cell, then
% concatenate it to a global vector. The output will be sorted.
% 
% Parameters
%  triggerVectorArray - cx1 cell array which holds the trigger vector for
%  each input
%  eventVectorArray - cx1 cell array, which holds the event vector for each
%  input
%  parameters - parameter structure which contains at least 1 field
%    radius - radius around the trigger where search for event will be
%    performed
% Return values
%   cumulativeEventVector - vector which contains all cells' all events'
%   around the trigger
function cumulativeEventVector = cumulativePeritriggerEvents(triggerVectorArray, eventVectorArray, parameters)

  %% --------------------------
  %  Initialization
  %% --------------------------
  nCell = length(triggerVectorArray);
  cumulativeEventByCell = cell(nCell, 1);    
  %% --------------------------
    
  %% --------------------------
  %  Collect perievent vector
  %  for each input and concate-
  %  nate it.
  %% --------------------------
  for c = 1 : nCell
    thisPerieventArray = collectPeritriggerEvents(triggerVectorArray{c}, eventVectorArray{c}, parameters);
    cumulativeEventByCell{c} = cell2mat(thisPerieventArray);
  end
  %% --------------------------
    
  %% --------------------------
  %  Concatenate all event
  %% --------------------------
  cumulativeEventVector = sort(cell2mat(cumulativeEventByCell));
  %% --------------------------
end