%
	
function [F1, ACC] = CVTrainWithInitialTests(l, allTemplates, allStats, allTests, allLabels, display)
  if nargin < 6
    display = 0;
  end
  
  l
  ACC = 0;
  F1 = 0;
  CFM = zeros(2,2);
  foldsNumber = length(allTemplates);
  for i = 1 : foldsNumber
    fprintf('%dth fold...\n', i);
    fflush(stdout);
    [acc, f1, cfm] = evaluateSet(allTemplates{i}, allTests{i}, allLabels{i}, allStats{i}, l);
    ACC = ACC + acc;
    F1 = F1 + f1;
    CFM = CFM .+ cfm;
  end
  
  ACC = ACC / foldsNumber;
  F1 = F1 / foldsNumber;
  
  CFM = CFM ./ foldsNumber;
end