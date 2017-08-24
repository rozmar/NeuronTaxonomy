% collectSlices collects slices from a signal designated with the slice
% index matrix
% 
% Parameters
%  - signalVector  - sx1 vector which contains the values which have to be
%  cut
%  - sliceIndexMatrix - txr matrix, where each row contains indices of a 
%  slice
%
% Return value
%  - sliceMatrix - txr matrix, where each row contains a slice from the
%  signal
function sliceMatrix = collectSlices(signalVector, sliceIndexMatrix)
  sliceMatrix = signalVector(sliceIndexMatrix);
  if size(sliceIndexMatrix,1)==1
    sliceMatrix = sliceMatrix'; 
  end
end