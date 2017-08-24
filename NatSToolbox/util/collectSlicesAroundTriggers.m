% collectSlicesAroundTriggers finds and collects slices from signal
% channel(s) to the corresponding trigger and time vector. First, it
% searches for the position of the triggers, then select those samplepoints
% which are in the given interval. If only one signal was given in the
% input structure, the slices will be cut from it. Else, if one (or more)
% additional filtered channel were given, cut the slices from all of them
% and returns it in a matrix array.
% 
% Parameters
%  - triggerVector - nx1 vector, contains the triggers around which the cut
%    will be performed
%  - signalStructure - structure which contains the signal (from which to
%    cut the slices)
%  - timeVector - tx1 vector, the time vector of the slice
% Return value
%  - sliceMatrix - nxt matrix, contains the slices for each trigger or
%  (f+1)xnxt array of matrices where f filtered value was provided
function sliceMatrix = collectSlicesAroundTriggers(triggerVector, signalStructure, timeVector)

  sliceSizeInPoints  = (length(timeVector)-1)/2;    %size of slice
  sliceIndexMatrix   = findSliceIndices(triggerVector, signalStructure.times, sliceSizeInPoints); 
  sliceMatrix        = collectSlices(signalStructure.values, sliceIndexMatrix);
  
  if isfield(signalStructure, 'filtered')
    sliceMatrix = {sliceMatrix};
    for i = 1 : length(signalStructure.filtered)
      sliceMatrix = [sliceMatrix;collectSlices(signalStructure.filtered{i}, sliceIndexMatrix)]; %#ok<AGROW>
    end
  end
end