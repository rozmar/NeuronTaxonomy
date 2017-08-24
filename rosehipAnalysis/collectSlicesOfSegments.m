% collectSlicesOfSegments finds and collects slices from signal
%   channel(s) to the corresponding segments.
% First, it searches for the position of the segments, then select those 
% samplepoints which are in the given segment.
% 
% Parameters
%  - segmentStructure - segment structure, contains two sx1 vector (start
%    and end) which contains the segment start and end markers.
%  - signalStructure - structure which contains the signal (from which to
%    cut the slices)
% Return value
%  - sliceMatrix - nxt matrix, contains the slices for each segment
function sliceArray = collectSlicesOfSegments(segmentStructure, signalStructure)
  
  sliceIndexArray = findSegmentIndices(segmentStructure, signalStructure.times); 
  sliceArray      = collectSlicesDifferentSize(signalStructure.values, sliceIndexArray);
 
end