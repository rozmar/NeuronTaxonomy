% calculateClusterPurity calculates the purity of the result of the
% clustering regards to the known labels.
% 
% Parameters
%  - classLabel - nx1 vector, contains the known labels
%  - clusterIdx - nx1 vector, the labels based on clustering
%  - relabel - logical value, indicates relabeling, default if false
% Return values
%  - purity - measure of purity
%  - relabeled - the new, relabeled index vector
function [purity,relabeled] = calculateClusterPurity(classLabel, clusterIdx, relabel)

  if nargin<3
    relabel = false;
  end

  if relabel && nargout<2
    error('This script returns the relabeled clustering.');
  end

  classLabels = unique(classLabel);
  clusterIdxs = unique(clusterIdx);
  nClass      = length(classLabels);
  nCluster    = length(clusterIdxs);
  
  if relabel
    relabeled = zeros(size(classLabel)); 
  end
  
  purity = 0;
  
  for k = 1 : nCluster
    inThisCluster = (clusterIdx==clusterIdxs(k));
    nClassInCluster = zeros(nClass,1);
    for c = 1 : nClass
      nClassInCluster(c) = sum(classLabel(inThisCluster)==classLabels(c));
    end
    
    if relabel
      [~,argMax]               = max(nClassInCluster);
      relabeled(inThisCluster) = classLabels(argMax);
    end
    
    purity = purity + max(nClassInCluster);
  end
  
  purity = purity / length(classLabel);
end