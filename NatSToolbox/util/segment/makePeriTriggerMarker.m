% makePeriTriggerMarker creates a segment structure from a given trigger
% vector with a given neighborhood.
%
% Parameters
%   triggerVector - nx1 vector containing the triggers
%   radius        - 1x2 vector, contains the left and right end of interval
%                   1x1 scalar, size of the symmetric radius
% Return values
%   nearTriggerStructure - a structure containing the following fields
%     start - nx1 vector, contains the segment starts
%     end   - nx1 vector, contains the segment ends
function nearTriggerStructure = makePeriTriggerMarker(triggerVector, radius)
    
  %% -------------------------
  %  Create interval from radius
  %% -------------------------
  interval = mirrorInterval(radius);
  %% -------------------------

  %% -------------------------
  %  Create starts and ends
  %% -------------------------
  nearTriggerStructure = createSegmentFromInterval(triggerVector, interval);
  %% -------------------------
  
end