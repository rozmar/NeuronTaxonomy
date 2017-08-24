% This function collect each cycle from each segment and put them into a
% segment structure. It remembers which cycle belongs to which segment.
function [cycleSegments,segmentLabel] = getCycles(inputStructure, parameters)

  % Get all cycle markers during the recording.
  % These are the cycle start and -end markers
  cycleMarkerVector = getMarkersByField(inputStructure, parameters.cycle.name); 

  % Create segment structure
  try 
    % Collect the segments which we want to divide into cycles
    segmentStructure = getSingleSegment(inputStructure, parameters.segment);
  catch ex
      
    warning( ex.message );
    segmentStructure = createSegmentFromMarker(cycleMarkerVector, parameters);
  end

  % Assign cycle markers to segments
  cycleMarkerBySegment = collectEventInSegment(cycleMarkerVector, segmentStructure);
  
  % Remove segments where we can't find cycle marker
  removeEmptySegment;
  
  function removeEmptySegment

      % Find segments without event in it
      emptySegmentFlag = cellfun(@isempty, cycleMarkerBySegment);
      % or only with 1 event (it can't be a cycle)
      emptySegmentFlag = emptySegmentFlag|(cellfun(@length, cycleMarkerBySegment)<2);
  
      % Retain non-empty segments
      cycleMarkerBySegment = cycleMarkerBySegment(~emptySegmentFlag);
    end   

  % Create segment from cycles
  [cycleSegments,segmentLabel] = splitSegmentsToCycles(cycleMarkerBySegment);
end

% This function creates a segment structure containing individual cycles
function [cyclesSegmentStructure,segmentLabel] = splitSegmentsToCycles(segmentEventArray)
  cyclesMatrix = [];
  segmentLabel = [];
  
  for i = 1 : length(segmentEventArray)
    thisSegmentsMarkers = segmentEventArray{i};
    thisSegmentsMarkers = [thisSegmentsMarkers(1:end-1) thisSegmentsMarkers(2:end)];
    cyclesMatrix        = cat(1,cyclesMatrix, thisSegmentsMarkers);
    segmentLabel        = cat(1,segmentLabel,ones(size(thisSegmentsMarkers,1),1)*i);
  end
  
  cyclesSegmentStructure = struct('start',cyclesMatrix(:,1),'end',cyclesMatrix(:,2),'title','Cycle','color',[]);
end