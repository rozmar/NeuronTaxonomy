
function runFullTest(templates, labels, mode)
  ACC = 0;
  F1 = 0;
  testSet = {};
  trainSet = {};
  validationSet = {};
  
  for i = 1 : length(templates)
    if labels(i)==1
      trainSet{length(trainSet)+1}=templates{i};
    elseif labels(i)==2
      testSet{length(testSet)+1}=templates{i};
    end	
  end
  	
  trainSet = shuffleArray(trainSet);
  testSet = shuffleArray(testSet);
  	
  validationSetSize = round(length(testSet)/2);
  
  for i = 1 : validationSetSize
    validationSet{length(validationSet)+1}=testSet{i};	
  end
  
  testSet(1:validationSetSize)=[];
  
  [allTrainFull, allTestFull, allLabelsFull ] = makeTestSetOneClassTrain(trainSet, testSet);
  
  for i = 1 : length(allTrainFull)
    [allTrain,allTest,allLabels] = makeTestSetOneClassTrain(allTrainFull{i}, validationSet);
    [allTemplate, allStat] = makeFoldTemplates(allTrain);
    [f1,acc] = CVTrainWithInitialTests(0.65, allTemplate, allStat, allTest, allLabels, 0)
    fprintf('Accuracy on %d. validation set: %f\nF1-score on %d. validation set: %f\n',i,acc,i, f1);
    ACC = ACC + acc;
    F1 = F1 + acc;
    
    break
  end
   
  ACC = ACC ./ length(allTrainFull);
  F1 = F1 ./ length(allTrainFull);
        
  fprintf('Accuracy on full test set: %f\nF1-score on full test set: %f\n', ACC, F1);
        
end
