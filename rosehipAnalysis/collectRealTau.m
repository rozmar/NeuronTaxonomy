
projectPath = 'E:\03_Munka\RHProject\';
dataSumDir = strcat(projectPath, 'datasums\');
dataFeatDir = strcat(projectPath, 'datafiles\');

groupLabels = listDirsInDir(dataSumDir);
numberOfGroups = length(groupLabels);
groupNames = {'RH', 'NGF', 'INT', 'PUTRH'};
featureNames = {'tau'};

factor = 0.9;

resultStructure = struct();
featureMatrixPerGroups = cell(numberOfGroups, 1);

for g = 1 : numberOfGroups
  dsgroupDir = strcat(dataSumDir,groupLabels{g},'\');
  fegroupDir = strcat(dataFeatDir, groupLabels{g}, '\');
  
  filesInGroup = listFilesInDir(dsgroupDir);
  numberOfFilesInGroup = length(filesInGroup);
  tauVector = zeros(numberOfFilesInGroup, 1);
  
  for f = 1 : numberOfFilesInGroup
    nameStructure = splitDatasumFilename(filesInGroup{f});
    featureFileName = createFeatureFilenameFromStruct(nameStructure);
    
    load(strcat(dsgroupDir, filesInGroup{f}));  % load datasum
    load(strcat(fegroupDir, featureFileName));  %load features
    
    iv = datasum.iv;
    sampleInterval = diff(iv.time([1,2]));
    signalMatrix = collectSignalsToMatrix(iv);
    negSweeps = iv.current < 0;
    
    signalMatrix = signalMatrix(negSweeps, :);
    tauStart = cellStruct.taustart;
    tauEnds = cellStruct.tauend;
    
    thisTau = getTauRiseTimeWithFactor(signalMatrix, tauStart, tauEnds, sampleInterval, factor);
    
    tauVector(f) = mean(thisTau);
    
    clear datasum cellStruct;
  end
  
  featureMatrixPerGroups{g} = tauVector;
  
  avgFeature = mean(tauVector, 1);
  sdFeature = std(tauVector, 0, 1);
  
  fprintf('%s\n', groupNames{g});
  for fe = 1 : length(featureNames)
    fprintf('%s,%f,%f\n', featureNames{fe}, avgFeature(fe), sdFeature(fe));
  end
  
end
% 
% pairs = [1 2;1 3;1 4;2 3;2 4;3 4];
% 
% for fe = 1 : length(featureNames)
%   for pair = 1 : size(pairs, 1)
%     thisPair = pairs(pair, :);
%     firstPopulation = featureMatrixPerGroups{thisPair(1)};
%     secondPopulation = featureMatrixPerGroups{thisPair(2)};
%     [p, h] = ranksum(firstPopulation(:,fe), secondPopulation(:,fe));
%     fprintf('%s,%s,%s,%f,%d\n', featureNames{fe}, groupNames{pairs(pair, 1)}, groupNames{pairs(pair, 2)}, p, h);
%   end
% end
