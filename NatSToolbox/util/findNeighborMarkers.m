% findNeighborMarkers finds the closest neighbors of the given trigger in
% a given interval. If there isn't any neighbor, returns NaN.
%
% Parameters
%  - trigger - the trigger time which neighbors have to be found
%  - eventVector - nx1 vector, contains all potential neighbor from we have
%    to select
%  - interval - 1x2 vector, the endpoints of the interval
% Return value
%  - neighbors - 1x2 vector which contain the closest neighbors in the
%    interval from left and right, or [NaN,NaN], if any of the neighbors
%    couldn't found
function neighbors = findNeighborMarkers(trigger, eventVector, intervalEnds)

  % Calculate interval endpoints
  intervalEnds  = intervalEnds + trigger;
    
  % Find neighbors
  leftNeighbor  = find(intervalEnds(1)<=eventVector&eventVector<=trigger,1,'last');
  rightNeighbor = find(trigger<=eventVector&eventVector<=intervalEnds(2),1,'first');
    
  % Get neighbor markers from position
  if isempty(leftNeighbor)||isempty(rightNeighbor)
    neighbors = [NaN,NaN];
  else
    neighbors = eventVector([leftNeighbor,rightNeighbor]);
  end
end