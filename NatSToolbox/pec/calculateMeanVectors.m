% calculateMeanVectors calculates the resultant mean vectors for each
% segment, whose binned data was given in parameter.
%
% Parameters
%  binnedMatrix - sxb matrix, contains histograms for s segments, each
%  divided to b bin
% Return value
%  meanVectorVector - sx1 vector which contains the sth segment's resultant
%  mean vector in a complex number representation
function meanVectorVector = calculateMeanVectors(binnedMatrix)
    
  %% --------------------------
  %  Initialization
  %% --------------------------
  nSegment  = size(binnedMatrix,1);
  
  meanVectorVector = zeros(nSegment,1);
  %% --------------------------
  
  %% --------------------------
  %  Loop through each segment
  %  and calculate its mean vector
  %% --------------------------
  for i = 1 : nSegment
    meanVectorVector(i) = calculateMeanvector(binnedMatrix(i,:)');
  end
  %% --------------------------
  
end