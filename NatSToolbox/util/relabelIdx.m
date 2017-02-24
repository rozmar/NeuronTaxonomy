% relabelIdx relabels a clustering according to the first element in the
% group. Selects the first element with the given label, and if it isn't
% the same as the real label, change that.
%  
% Parameters
%  - realIdx - nx1 vector contains the real, known indices
%  - clusterIdx - nx1 vector, contains the given indices came from
%  clustering/classification
% 
% Return values
%  - relabeledIdx - nx1 vector, where each element got the initial label as
%  if it is possible
function relabeledIdx = relabelIdx(realIdx, clusterIdx)

  
  clusterLabels = unique(realIdx);
  nCluster      = length(clusterLabels);
  
  for i = 1 : nCluster
    firstFromThisClass = find(realIdx==clusterLabels(i),1,'first');
    if realIdx(firstFromThisClass)==clusterIdx(firstFromThisClass)
      continue;
    end
    
    temp = clusterIdx(firstFromThisClass);
    clusterIdx(clusterIdx==clusterLabels(i)) = 0;
    clusterIdx(clusterIdx==temp) = realIdx(firstFromThisClass);
    clusterIdx(clusterIdx==0) = temp;
  end
  relabeledIdx = clusterIdx;
end