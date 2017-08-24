% createSegmentFromInterval create segment structure from a list of
% events and an interval.
%
% Parameters
%  - eventVector - mx1 vector which contains the reference events
%  - interval    - 1x2 vector which contains the ends of the interval
% Return value
%  - segmentStructure - structure array with the following fields
%    start - mx1 vector, start markers of the current segment
%    end   - mx1 vector, end markers of the current segment
function segmentStructure = createSegmentFromInterval(eventVector, interval)
  
  segmentStructure.start = eventVector+interval(1);
  segmentStructure.end   = eventVector+interval(2);
  
end