% Prepares the instances for the x-fold cross validation.
%
% Splits the initial set x times to train and test set.
% trainSet - initial set
% labels - real labels
% foldsNumber - x
function [trainSets,testSets,trainLabels, testLabels] = makeTestSetGivenProportion(trainSet, labels, foldsNumber)
	
  numInFold = length(trainSet)/foldsNumber;
  
  class = unique(labels);
  
  instancesByClass = {};
  
  for i = 1 : length(class)
    instancesByClass{i} = trainSet(labels==class(i));
    instancesByClass{i} = shuffleArray(instancesByClass{i});
    foldSize(i)= length(instancesByClass{i})/foldsNumber;
  end
  
  
  for i = 1 : foldsNumber
    tr = {};
    te = {};
    trlab = [];
    telab = [];
    for j = 1 : length(class)
      foldStart = 1 + round((i-1)*foldSize(j));
      foldEnd = round(i*foldSize(j));
      currentClassInstances = instancesByClass{j};
      for k = 1 : foldStart-1
        tr{length(tr)+1} = currentClassInstances{k};
        trlab = [ trlab ; class(j) ];
      end
      for k = foldStart : foldEnd
        te{length(te)+1} = currentClassInstances{k};
        telab = [ telab ; class(j) ];
      end
      for k = foldEnd+1 : length(currentClassInstances)
        tr{length(tr)+1} = currentClassInstances{k};
        trlab = [ trlab ; class(j) ];
      end
    end
    trainSets{i} = tr;
    testSets{i} = te;
    trainLabels{i} = trlab;
    testLabels{i} = telab;
  end
    
end