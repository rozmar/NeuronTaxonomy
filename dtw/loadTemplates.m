function [templates, classes] = loadTemplates(inputDirs,classLabels)
  counter = 1;
  for i = 1 : size(classLabels,1)
    if length(inputDirs)<i
      fprintf("Not enough input parameter! Too few input dir!\n");
      exit;
    end
    
    templateList = eval(['ls ',inputDirs{i}]);
    for j = 1 : size(templateList,1)
      templates{counter} = load([inputDirs{i},'/',strtrim(templateList(j,:))]).template;
      classes(counter) = classLabels(i);
      counter = counter + 1;
    end
  end
  if length(inputDirs)>i
    fprintf("Not enough parameters! Too few class label!\n");
    exit;
  end
end