% This function returns a given slice of a segment structure.
%
% Parameters
%  - initialStructure - segment structure which have to be sliced
%  - sliceIndex - indices of the necessary slice, it can be numeric or
%  logical
% Return value
%  - sliceStructure - a segment structure with the needed segments
function sliceStructre = sliceSegment(initialStructure, sliceIndex)
  sliceStructre = initialStructure;
  
  sliceStructre.start = sliceStructre.start(sliceIndex);
  sliceStructre.end   = sliceStructre.end(sliceIndex);
end