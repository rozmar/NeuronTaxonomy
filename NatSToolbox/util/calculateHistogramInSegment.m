% calculateHistogramInSegment divides each given segment to the specified
% number of bins, then count the number of events in each bin. Returns the
% binned histogram for each segment, and the length of segments.
% 
% Parameters
%  segmentStructure - contains the examined segments
%    start - sx1 vector, segment starts
%    end   - sx1 vector, segment ends
%  eventVector - sx1 array, which contains events for each segment
%  binNumber   - number of bins to divide the segment
%  Return values
%   binnedMatrix - sxbinNumber matrix, which contains for each cycle the
%   event histogram
%   segmentLengthVector - sx1 vector which contains the lengths' of the
%   segments
function [binnedMatrix, segmentLengthVector] = calculateHistogramInSegment(segmentStructure, eventVector, binNumber)

  %% --------------------------
  %  Initialization
  %% --------------------------
  nSegment            = length(eventVector);
  binnedMatrix        = zeros(nSegment, binNumber);
  segmentLengthVector = zeros(nSegment,1);
  segmentMatrix       = [segmentStructure.start, segmentStructure.end];
  %% --------------------------
  
  %% --------------------------
  % Loop through each segment
  %% --------------------------
  for i = 1 : nSegment
    % Count events in each bin
    binEdges  = linspace(segmentMatrix(i,1),segmentMatrix(i,2), binNumber+1);
    numInBins = histc(eventVector{i}, binEdges);
    
    % Save value
    binnedMatrix(i,:)      = numInBins(1:end-1)';
    segmentLengthVector(i) = diff(segmentMatrix(i,:));
  end
  %% --------------------------
  
end