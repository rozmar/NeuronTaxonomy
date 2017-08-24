% findEventContainingSegment function create a flag vector what indicates
% which segment contains at least one event. The events have to be given in
% a vector as parameter. The condition can be inverted to "not contain".
% 
% Parameters
%  segmentStructure - structure array with the following fields
%    start - mx1 vector, start markers of the current segment
%    end   - mx1 vector, end markers of the current segment
%  eventVector - nx1 vector contains events which have to be checked
%    mode    - mode of inclusion
%            'within'  - retain those segments which contain event 
%            'without' - retain those segments which don't contain event
% Return value
%  flagVector - mx1 logical vector indicates which segment fulfils the
%  condition
function containFlag = findSegmentWithEvent(segmentStructure, eventVector, mode)
  
  %% -------------------
  %  Extract boundaries
  %% -------------------
  [borderMatrix,nSection] = extractBorders(segmentStructure);
  %% -------------------
  
  %% -------------------
  %  Create edges for 
  %  classification
  %% -------------------
  containFlag = false(nSection,1);
  if ~isempty(eventVector)
    for i = 1 : nSection
      containFlag(i) = isEventInSegment(eventVector, borderMatrix(i,:));
    end
  end
  
  % Invert flags if we want check exclusion
  if strcmpi(mode, 'without')
    containFlag = ~containFlag;
  end
  %% -------------------
  
end

% Decide if there is any event in the given segment.
function isEvent = isEventInSegment(eventVector, segmentBorders)
  isEvent = sum(segmentBorders(1)<eventVector&eventVector<segmentBorders(2)) > 0;
end

% Create boundary matrix from structure fields
function [borderMatrix,nSection] = extractBorders(structure)
  
  % Create the border matrix from the start and end markers
  borderMatrix = [toCol(structure.start), toCol(structure.end)];
  % Count the segments
  nSection = size(borderMatrix, 1);
end