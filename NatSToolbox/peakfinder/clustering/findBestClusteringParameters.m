function [relabeledCluster,bestPurity] = findBestClusteringParameters(featureMatrix, classLabel, featureNameArray)
  nFeature = size(featureMatrix,2);
  nItem    = length(classLabel);
  featureMatrix = zscore(featureMatrix);
  
  %------------------------------
  % Take every feature at the same
  % time and remove it 1 by 1
  %------------------------------
  bestCombinationPur = zeros(nFeature,1);
  bestCombinationFeat(nFeature) = struct();
  for i = nFeature : -1 : 1
    %------------------------------
    % Create feature combinations
    %------------------------------
    combinations = nchoosek(1:nFeature, i);
    nCombination = size(combinations,1);
    purity       = zeros(nCombination, 1);
    for j = 1 : nCombination
      D   = linkage(featureMatrix(:,combinations(j,:)), 'ward');
      idx = cluster(D, 5);
      purity(j) = calculateClusterPurity(classLabel, idx);
    end
    [mP, mI] = max(purity);
    bestCombinationPur(i) = mP;
    bestCombinationFeat(i).comb = combinations(mI,:);
  end
  %------------------------------
  
  bestPur =  max(bestCombinationPur);
  fprintf('The best purity can be achieved is %.3f\n', bestPur);
  bestPurIdx = find(bestCombinationPur==bestPur);
  
  for bp = 1 : length(bestPurIdx)
    fprintf('This combination contains %d features:\n', length(bestCombinationFeat(bestPurIdx(bp)).comb));
    for i = 1 : length(bestCombinationFeat(bestPurIdx(bp)).comb)
      fprintf('%s\n', featureNameArray{bestCombinationFeat(bestPurIdx(bp)).comb(i)});
    end
  end
  
  D = linkage(featureMatrix(:,bestCombinationFeat(bestPurIdx(1)).comb), 'ward');
  idx = cluster(D, 5);
  dendrogram(D, 'ColorThreshold', 2);
  [bestPurity,relabeledCluster] = calculateClusterPurity(classLabel, idx, true);
  
end