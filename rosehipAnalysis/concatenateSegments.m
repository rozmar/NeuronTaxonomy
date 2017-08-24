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
  sampleInterval = diff(sliceStructure(1).times(1:2));
  
  % Glue initial slices together
  transformedSlices = cellfun(@(x) x', {sliceStructure(:).values}, 'UniformOutput', 0);
  newSliceStructure.values = [transformedSlices{:}]';
  % Calculate the new length (sum of old lengths)
  newSliceStructure.length = length(newSliceStructure.values);
  
  % Mean value of signal
  newSliceStructure.meanVal = mean([sliceStructure(:).meanVal]);
  
  % Generate new time vector
  newSliceStructure.times  =...
      generateTimeVector(newSliceStructure.length, sampleInterval);

  % Duration of segment in seconds
  newSliceStructure.duration = diff(newSliceStructure.times([1,end]));
end

function timeVector = generateTimeVector(vectorLength, sInterval)
  timeVector = linspace(0, vectorLength, vectorLength)*sInterval;
end