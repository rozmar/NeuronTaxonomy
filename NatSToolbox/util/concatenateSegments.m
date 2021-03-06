% concatenateSegments glue segments together containen in the segment
% structure. It will update the time vector and the length of the signal.
% 
% Parameters
%  - sliceStructure - sx1 structure representing the initial slices, have
%    to have the following fields
%     - times - tx1 vector, the original timestamps for the slice
%     - values - tx1 vector, the slice values
%     - length - scalar, contains the length of slice
% Return value
%  newSliceStructure - single structure with the same structure as the
%  input was, contains a single signal (previous signals glued together)
function newSliceStructure = concatenateSegments(sliceStructure)

  % Calculate sample interval
  sampleInterval = diff(sliceStructure.times(1:2));
  
  % Glue initial slices together
  newSliceStructure.values = [sliceStructure(:).values];
  % Calculate the new length (sum of old lengths)
  newSliceStructure.length = length(newSliceStructure.values);
  
  % Generate new time vector
  newSliceStructure.times  =...
      generateTimeVector(newSliceStructure.length, sampleInterval);

end

function timeVector = generateTimeVector(vectorLength, sInterval)
  timeVector = linspace(0, vectorLength, vectorLength)*sInterval;
end