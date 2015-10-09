function [trainSets,testSets,labels] = makeTestSetOneClassTrain(trainSet, testSet)
	
  foldsNumber = round(length(trainSet)/length(testSet))
  numInFold = length(trainSet)/foldsNumber;
  
  for i = 1 : foldsNumber
    train = trainSet;
    eval = testSet;
    toDelete = [];
    label = ones(length(testSet),1).*2;
    fprintf('%dth fold...\n', i);
    for j = round((i-1)*numInFold)+1 : round(i*numInFold)
      eval{length(eval)+1} = train{j};
      toDelete = [ toDelete ; j ];
      label = [ label ; 1 ];
    end
    train(toDelete)=[];
    trainSets{i} = train;
    testSets{i} = eval;
    labels{i} = label;
  end
end