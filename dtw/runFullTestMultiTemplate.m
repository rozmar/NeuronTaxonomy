
function [ACC,F1,CFM] = runFullTestMultiTemplate(templates, labels, onWhatEvaluate)
  ACC = 0;
  F1 = 0;
  CFM = zeros(2,2);

  if nargin<3
    onWhatEvaluate=1
  end
    	 
  [trainSets,testSets,trainlabels,testlabels] = makeTestSetGivenProportion(templates, labels, 2);
  [allTemplate] = makeFoldTemplatesFromMoreClasses(trainSets,trainlabels);
  
  for i = 1 : length(allTemplate)
    if onWhatEvaluate==1
      [acc,f1,cfm] = evaluateSetMultiTemplate(allTemplate{i},testSets{i},testlabels{i});
      fprintf('Accuracy on %d. test set: %f\nF1-score on %d. test set: %f\n',i,acc,i, f1);
    elseif onWhatEvaluate==2
      [acc,f1,cfm] = evaluateSetMultiTemplate(allTemplate{i},trainSets{i},trainlabels{i});
      fprintf('Accuracy on %d. train set: %f\nF1-score on %d. train set: %f\n',i,acc,i, f1);
    end
    
    ACC = ACC + acc;
    F1 = F1 + f1;
    CFM = CFM .+ cfm;
       
  end
   
  ACC = ACC ./ length(allTemplate);
  F1 = F1 ./ length(allTemplate);
  CFM = CFM ./ length(allTemplate);
        
  fprintf('Accuracy on full ');
  if onWhatEvaluate==1
    fprintf('test');
  elseif onWhatEvaluate==1
    fprintf('train');
  end
  fprintf(' set: %f\nF1-score on full test set: %f\n', ACC, F1);
  fprintf('Confusion matrix average\n%f %f\n%f %f\n', CFM(1,1), CFM(1,2), CFM(2,1), CFM(2,2));
        
end
