% collectSegments collect the segment start and segment end markers from
% the given input file and creates a compatible segment structure from
% them. A segment which contains "all event" will always be created. 
% Besides that, other segment names have to be enumerated. Else, all
% possible segment will be collected.
% 
% Parameters
%  inputStructure - structure which contains the required channels. The
%    following channels are mandatory. At least one event channel is
%    mandatory. If peritrigger segment was given, the trigger channel is
%    expected too. If one or more segment is given a start and an end has to
%    be given.
% Return
%  segmentStructure - mx1 structure array with the following fields
%    start - start markers of the current segment
%    end   - end markers of the current segment
%    title - title of the segment (for plot legend)
%    color - color code of the segment (plot line)
function segmentStructure = collectSegments(inputStructure, parameters)

  %% -------------------------
  %  If segments were given, 
  %  collect them, else process 
  %  all possible segment.
  %% -------------------------
  if isfield(parameters, 'segments')
    segmentNames   = parameters.segments.name;
    nSegment       = length(segmentNames);
  else
    % Field names in file
    fieldNames       = fieldnames(inputStructure); 
    % Get segment start channels
    segmStartCh      = ~cellfun(@isempty, regexp(fieldNames, '^.*_st$')); 
    segmStartChNames = fieldNames(segmStartCh);
    
    nSegment         = length(segmStartChNames);
    segmentNames     = cell(nSegment, 1);
    for i = 1 : nSegment
      thisChannelName   = segmStartChNames{i};
      segmentNames{i}   = thisChannelName(1:end-3);
    end
  end
  
  %% -------------------------

  %% -------------------------
  %  Create segment for near 
  %  peri-trigger event
  %% -------------------------
%   createPeritriggerSegment(triggerVector, parameters);
  %% -------------------------  
  
  %% -------------------------
  %  Create segment for other
  %  event.
  %% ------------------------- 
  segmentStructure(1:nSegment) = struct('start',[],'end',[],'title','','color',[]);
  for i = 1 : nSegment
    segmentStructure(i) = getSingleSegment(inputStructure, struct('name',segmentNames{i}));
  end
  %% -------------------------
      
end

