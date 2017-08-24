% findSegmentIndices find the indices of sample points of the segments.
% 
% Parameters
%  - segmentStructure - segment structure containing two sx1 vector which
%    represents the segments' start and end markers
%  - timeVector - tx1 vector which contains the timestamp for each 
%    signal-point.
% Return value
%  - sliceIndexMatrix - sx1 cell array, where each row contains an index vector
function segmentArray = findSegmentIndices(segmentStructure, timeVector)

  %% -----------------------------
  %  Initialization
  %% -----------------------------
  nSegment     = length(segmentStructure.start);
  segmentArray = cell(nSegment, 1);
  SI           = diff(timeVector(1:2));
  binEdges     = [timeVector-(SI/2);timeVector(end)+(SI/2)];
  
  markerMatrix = [segmentStructure.start, segmentStructure.end];
  %% -----------------------------

  %% -----------------------------
  %  Take each trigger
  %% -----------------------------
  for i = 1 : nSegment
      
    % Find this segment's position
    [~,startIndex] = histc(markerMatrix(i,1), binEdges);
    [~,endIndex]   = histc(markerMatrix(i,2), binEdges);
    
    % Each index during segment
    segmentArray{i} = startIndex:endIndex;   
  end
  %% -----------------------------
  
end