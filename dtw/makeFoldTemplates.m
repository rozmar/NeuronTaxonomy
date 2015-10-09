function [allTemplate, allStat] = makeFoldTemplates(allTrain)
  for i = 1 : length(allTrain)
    template = createTemplate(allTrain{i},1);
    statObject = calculateStatistics(template, allTrain{i});
    allTemplate{i} = template;
    allStat{i} = statObject;
  end
end