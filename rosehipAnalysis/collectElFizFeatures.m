
projectPath = 'E:\RHDATA\ANALYSISdata\marci\_Taxonomy\human_rosehip\';
dataSumDir = strcat(projectPath, 'datasums\');

groupLabels = listDirsInDir(dataSumDir);
numberOfGroups = length(groupLabels);
groupNames = {'RH', 'NGF', 'INT', 'PUTRH'};

resultStructure = struct();
featureNames = {'apamplitude1', 'aphalfwidth1', 'threshold1', 'rin', 'tau0_90risetime'};
featureMatrixPerGroups = cell(4, 1);

for g = 1 : 4
  groupDir = strcat(dataSumDir,groupLabels{g},'\');
  filesInGroup = listFilesInDir(groupDir);
  numberOfFilesInGroup = length(filesInGroup);
  featureMatrix = zeros(numberOfFilesInGroup, 5);
  for f = 1 : numberOfFilesInGroup
    load(strcat(groupDir, filesInGroup{f}));
    for fe = 1 : length(featureNames)
      featureMatrix(f,fe) = datasum.(featureNames{fe});
    end
    clear datasum;
  end
  
  featureMatrixPerGroups{g} = featureMatrix;
  avgFeature = mean(featureMatrix, 1);
  sdFeature = std(featureMatrix, 0, 1);
  
  fprintf('%s\n', groupNames{g});
  for fe = 1 : length(featureNames)
    fprintf('%s,%f,%f\n', featureNames{fe}, avgFeature(fe), sdFeature(fe));
  end
  
end

pairs = [1 2;1 3;1 4;2 3;2 4;3 4];

for fe = 1 : length(featureNames)
  for pair = 1 : size(pairs, 1)
    thisPair = pairs(pair, :);
    firstPopulation = featureMatrixPerGroups{thisPair(1)};
    secondPopulation = featureMatrixPerGroups{thisPair(2)};
    [p, h] = ranksum(firstPopulation(:,fe), secondPopulation(:,fe));
    fprintf('%s,%s,%s,%f,%d\n', featureNames{fe}, groupNames{pairs(pair, 1)}, groupNames{pairs(pair, 2)}, p, h);
  end
end


