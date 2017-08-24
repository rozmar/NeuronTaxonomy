% collectNeighboringEvents collects the neighboring events from the left
% and right side of the given triggers which are in a given interval radius.
% It returns only those triggers which had neighbors on both side.
% 
% Parameters
%  - triggerVector - tx1 vector, contains the triggers which neighbors we
%    are looking for
%  - eventVector   - nx1 vector which contains the events we want to find
%  - interval      - a scalar which represents the maximal radius where a
%    neighbor can appear
%
% Return values
%  - triggers - ttx1 vector, which contains those triggers which have
%    neighbors on both side in the given interval
%  - neighbors - ttx2 matrix, contains the found neighbors for each trigger
function [triggers, neighbors] = collectNeighboringEvents(triggerVector, eventVector, interval)

  %% --------------------------
  %  Initialization
  %% --------------------------
  interval  = mirrorInterval(interval);  %interval ends
  neighbors = zeros(length(triggerVector),2);       %output matrix
  %% --------------------------
  
  %% --------------------------
  %  Find neighbors of each trigger
  %% --------------------------
  for i = 1 : length(triggerVector)
    neighbors(i,:) = findNeighborMarkers(triggerVector(i), eventVector, interval);
  end
  %% --------------------------
  
  %% --------------------------
  %  Prepare output
  %% --------------------------
  [triggers, neighbors] = clearOutput(neighbors, triggerVector);
  %% --------------------------
  
end

% This function removes those triggers which haven't got both neighbors.
function [triggers, neighbors] = clearOutput(neighborsOld, triggerOld)
  
  % Find non-NaN rows
  wNeighbor = logical(sum(~isnan(neighborsOld),2));
  
  % Remaining elements
  neighbors = neighborsOld(wNeighbor,:);
  triggers  = triggerOld(wNeighbor);
  
  % Convert to relative
  neighbors = neighbors - (triggers*[1,1]);
end

