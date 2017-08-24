% collectEventsBySegment collects events from the given vector which
% corresponds to the segment. More different segmenting can be given.
% 
% Parameters
%  eventVector - nx1 vector which contains all event
%  segmentStructure - mx1 structure, which contains segments
%    name  - name of segment type
%    start - nx1 vector, contains the segments' starts
%    end   - nx1 vector, contains the segments' ends (must be the same number
%    as the start vector and both have to be given
% Returns
%  segmentEvents - an mx1 structure extended with the collected event vect.
function segmentEvents = collectEventsBySegment(eventVector, segmentStructure)
        
  %% -------------------------
  %  Initialization
  %% -------------------------
  nSegmentType  = length(segmentStructure);
  segmentEvents = segmentStructure;
  %% -------------------------
    
  %% -------------------------
  %  Loop through each segment
  %% -------------------------
  for i = 1 : nSegmentType
        
    %% -------------------------
    %  Collect events for segment
    %% -------------------------
    segmentEventArray = collectEventInSegment(eventVector, segmentStructure(i));
    segmentEvents(i).eventVector = cell2mat(segmentEventArray);
    %% -------------------------
    
  end %end segment loop
  %% -------------------------

end