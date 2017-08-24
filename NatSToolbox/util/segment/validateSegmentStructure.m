% validateSegmentStructure validates the given segment structure given as
% input: checks if there are start and end markers, and if their number are
% the same? If something is wrong, an error occured, else it returns the
% number of segments.
% 
% Parameter
%  - segmentStructure - structure which contains the segments. It has to
%  have at least two fields: start and end. These two fields are vectors of
%  the same length.
%
% Return values
%  - nSegment - number of segment, if the structure was valid
function nSegment = validateSegmentStructure(segmentStructure)

  % Check field existence
  if ~isfield(segmentStructure, 'start') || ~isfield(segmentStructure, 'end')
    showError('Start or end markers are missing');
  end
        
  % Check the size consistence
  if length(segmentStructure.start)~=length(segmentStructure.end)
    showError('Not the same number of section start and end!');
  end
  
  % Check the correct ordering
  if sum(segmentStructure.start>segmentStructure.end)>0
    [errorMsg, errorDetails] = checkOrdering(segmentStructure);
    fprintf('Problem with the following markers:\n');
    fprintf(errorDetails);
    showError(errorMsg);
  end
  
  % Count segments
  nSegment = length(segmentStructure.start);
end

function [errorMsg,errorDetails] = checkOrdering(segmentStructure)
  errorMsg = 'Wrong order of start and end!';
  errorDetails = '';
  
  for i = 1 : length(segmentStructure.start)
    if segmentStructure.start(i)>=segmentStructure.end(i)
      errorDetails = strjoin({errorDetails, 'start=', num2str(segmentStructure.start(i)), 'end=', num2str(segmentStructure.end(i)), '\n'});
    end
  end
end