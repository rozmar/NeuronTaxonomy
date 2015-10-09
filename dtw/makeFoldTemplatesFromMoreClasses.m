function [allTemplate] = makeFoldTemplatesFromMoreClasses(allTrain, labels)
  class = unique(labels{1});
  allTemplate = {};
  for i = 1 : length(allTrain)
    fprintf('Making template for %i. fold...\n', i);
    fflush(stdout);
    templateByClass = {};
    labs = labels{i};
    train = allTrain{i};
    for j = 1 : length(class)
      template = createTemplate(train(labs==class(j)),1);
      templateByClass{j} = template;	
    end
    allTemplate{i} = templateByClass;
    fprintf('Template made for all classes in %d. fold.\n',i);
    fflush(stdout);
  end
  fprintf('All template for all folds made.\n');
  fflush(stdout);
end