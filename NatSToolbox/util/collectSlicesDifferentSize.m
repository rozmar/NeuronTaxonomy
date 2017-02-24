% collectSlicesDifferentSize collects slices from a signal designated 
% with the slice index array. The slices don't have to be at the same size.
% 
% Parameters
%  - signalVector  - tx1 vector which contains the values which have to be
%    cut
%  - sliceIndexArray - sx1 array, where each row contains indices of a 
%    slice
% Return value
%  - sliceArray - sx1 array, where each element contains a slice from the
%    signal
function sliceArray = collectSlicesDifferentSize(signalVector, sliceIndexArray)
  sliceArray = cell(length(sliceIndexArray),1);
  
  for i = 1 : length(sliceIndexArray)
    sliceArray{i} = signalVector(sliceIndexArray{i}); 
  end
  
end