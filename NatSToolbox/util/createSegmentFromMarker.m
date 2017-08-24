% createSegmentFromMarker define segments from markers based on the 
% given rules. It is used when the segment start and end fields are
% missing. 
% Parameters
%  markerVector - nx1 vector contains the markers which constitute the
%  segment
%  parameters - parameter structure which contains the rule of segmentation
%    - maxTimeDifference - value which is acceptible 
%    - sectionTitle      - name of the original segment
%    - color             - color of the original segment
function segmentStructure = createSegmentFromMarker(markerVector, parameters)

  %% -----------------------
  %  Default values
  %% -----------------------
  sectionTitle = 'Automatic detected sections';
  colorVector  = [0,0,1];
  %% -----------------------
  
  %% -----------------------
  %  Get the given parameters
  %% -----------------------
  if isfield(parameters, 'colorVector')
    colorVector = parameters.colorVector; 
  end
  
  if isfield(parameters, 'sectionTitle')
    sectionTitle = strcat(parameters.sectionTitle,'_auto');
  end
  %% -----------------------
  
  %% -----------------------
  %  Preprocess values
  %% -----------------------
  markerVector = sort(markerVector);
  markerDiff   = [Inf;diff(markerVector)];
  %% -----------------------
  
  %% -----------------------
  % Find the segment ends, calculate
  % the start and end indices from it
  %% -----------------------
  segmentStarts = find(markerDiff>parameters.maxTimeDifference);
  segmentEnds   = [segmentStarts(2:end)-1;length(markerVector)];
  %% -----------------------
  
  %% -----------------------
  % Create the segment structure
  %% -----------------------
  segmentStructure = struct( ...
      'start', markerVector(segmentStarts), ...
      'end', markerVector(segmentEnds), ...
      'title', sectionTitle, ...
      'color', colorVector);
  %% -----------------------
    
end