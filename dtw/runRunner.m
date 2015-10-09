function runRunner(runType, inputDirs, restarts)
  class = [1;2];
  if nargin<3
    restarts = 20;
  end


  ACC = 0;
  F1 = 0;
  CFM = zeros(2,2);

  fprintf('Running test with ');

  if runType==1
    fprintf('single template\n');
  elseif runType==2
    fprintf('multi template\n');
  end

  fprintf('Loading templates from dir...\n');
  fflush(stdout);
  
  [templates,labels]=loadTemplates(inputDirs,class);

  fprintf('Templates loaded. Running %d test.\n', restarts);
  fflush(stdout);

  for i = 1 : restarts 
    fprintf('Run %d/%d.\n', i, restarts);
    fflush(stdout);
    if runType==1
      [acc,f1,cfm] = runFullTest(templates,labels);
    elseif runType==2
      [acc,f1,cfm] = runFullTestMultiTemplate(templates,labels,2);
    end
    ACC = ACC + acc;
    F1 = F1 + f1;
    CFM = CFM .+ cfm;
  end

  ACC = ACC / restarts;
  F1 = F1 / restarts;
  CFM = CFM ./ restarts;

  fprintf('With %d restarts, the results:\n', restarts);
  fprintf('Accuracy: %f\nF1-score %f\nConfusion matrix:\n%f %f\n%f %f\n',ACC,F1,CFM(1,1),CFM(1,2),CFM(2,1),CFM(2,2));
  fflush(stdout);

end
