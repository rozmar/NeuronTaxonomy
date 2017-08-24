% getSingleSegment get the given segment's start and end times from input
% and creates a segmentStructure from them. If title and/or color has been
% given, this will be set too. Else, default values will be used. 
% Parameters
%  inputStructure - structure which contains the start and end of a segment
%  as field. If either of them isn't present, error will be shown.
%  parameters - the segment parameters, following possible fields
%    segmentName/name   - (mandatory) name of the expected segment 
%    segmentTitle/title - (optional) name of a segment for plot/display
%    segmentColor/color - (optional) color of this segment for plot
% Return value
%  segmentStructure - structure representing the given segment, has the
%  following fields
%    start - starts of the segments
%    end   - ends of the segments
%    title - string for plot title or status display
%    color - color for multiple plot
function segmentStructure = getSingleSegment(inputStructure, parameters)
  
  %% --------------------------
  %  Get the segment names
  %  It is mandatory, so don't 
  %  need to check.
  %% --------------------------
  if isfield(parameters,'segmentName')
    segmentName = parameters.segmentName;
  elseif isfield(parameters, 'name')
    segmentName = parameters.name;
  end
  %% --------------------------

  %% --------------------------
  %  Check existence of fields
  %% --------------------------
  hasSegment(inputStructure, strjoin({segmentName,'st'},'_'));
  hasSegment(inputStructure, strjoin({segmentName,'end'},'_'));
  %% --------------------------
  
  %% --------------------------
  %  Load field for segments
  %% --------------------------
  [startVector, endVector] = loadSegment(inputStructure, segmentName);
  checkIsEqual(startVector, endVector);
  %% --------------------------
  
  %% --------------------------
  %  Create result structure
  %% --------------------------
  segmentStructure.start  = startVector;
  segmentStructure.end    = endVector;
  segmentStructure.title  = segmentName;
  segmentStructure.color  = [0,0,1];
  %% --------------------------
    
  %% --------------------------
  %  Customize segment
  %% --------------------------
  if isfield(parameters, 'segmentTitle')
    segmentStructure.title = parameters.segmentTitle;
  end
    
  if isfield(parameters, 'segmentColor')
    segmentStructure.color = parameters.segmentColor./255;
  end
  %% --------------------------
  
end

function checkIsEqual(vector1, vector2)
  if length(vector1)~=length(vector2)
    throw(MException('Segment:isEqual', sprintf('Segment start and end aren''t the same length.'))); 
  end
end

% Check whether inputStructure has the given segments
function hasSegment(inputStructure, segmentName)
  if ~isfield(inputStructure, segmentName)
    throw(MException('Segment:hasSegment', sprintf('No field named %s in input.',segmentName)));
  end
end

% Collcets the segments from the input structure
function [startVector, endVector] = loadSegment(inputStructure, segmentName)
  startVector = inputStructure.(strjoin({segmentName,'st'},'_')).times;
  endVector = inputStructure.(strjoin({segmentName,'end'},'_')).times;
end