% collectSlicesOfSegments finds and collects slices from signal
% channel(s) to the corresponding segments.
% First, it searches for the position of the triggers, then select those 
% samplepoints which are in the given segment. If only one signal was given
% in the input structure, the slices will be cut from it. Else, if one 
% (or more) additional filtered channel were given, cut the slices from 
% all of them and returns it in a matrix array.
% 
% Parameters
%  - segmentStructure - segment structure, contains two sx1 vector (start
%    and end) which contains the segment start and end markers.
%  - signalStructure - structure which contains the signal (from which to
%    cut the slices)
% Return value
%  - sliceMatrix - nxt matrix, contains the slices for each segment or
%  (f+1)xnxt array of matrices where f filtered value was provided
function sliceArray = collectSlicesOfSegments(segmentStructure, signalStructure)
  
  sliceIndexArray = findSegmentIndices(segmentStructure, signalStructure.times); 
  sliceArray      = collectSlicesDifferentSize(signalStructure.values, sliceIndexArray);
  
  if isfield(signalStructure, 'filtered')
    sliceArrayArray    = cell(1 + length(signalStructure.filtered),1);
    sliceArrayArray{1} = sliceArray;
    for i = 1 : length(signalStructure.filtered)
      sliceArrayArray{1+i} = collectSlices(signalStructure.filtered{i}, sliceIndexArray);
    end
  end
end