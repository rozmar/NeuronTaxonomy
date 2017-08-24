% collectEventInSegment collects events from eventVector for each segment
% in segmentStructure. The events in segments will be collected separately.
% 
% Parameters
%  - eventVector - nx1 vector, the events to collect
%  - segmentStructure - structure which contains the m segments
% Return values
%  - segmentEventArray - mx1 array which contains the events for each segment
function [segmentEventArray,eventLabel] = collectEventInSegment(eventVector, segmentStructure)
  
  %% -----------------------
  %  Initialization
  %% -----------------------
  nSegment          = validateSegmentStructure(segmentStructure);
  segmentEventArray = cell(nSegment,1);
  eventLabel        = zeros(size(eventVector));
  %% -----------------------
  
  %% -----------------------
  %  Loop through each segment
  %% -----------------------
  for i = 1 : nSegment    
    % Ends of this interval
    thisEdges = [segmentStructure.start(i),segmentStructure.end(i)];
    % Flag for event in this interval
    thisSectionIndex = (thisEdges(1)<=eventVector & eventVector<=thisEdges(2));
    % Label those events
    eventLabel(thisSectionIndex) = i;
    % Collect events
    segmentEventArray{i} = eventVector(thisSectionIndex);
  end
  %% -----------------------
  
end
