function runSingleWavelet(parameters)

  %% -------------------------
  %  Collect containing dir
  %% -------------------------
  datasumDir = parameters.datasumDir;
  featureDir = parameters.featureDir;
  [groupArray, datasumDir] = listDirsInDir(datasumDir);
  [~, featureDir]          = listDirsInDir(featureDir);
  nGroup   = length(groupArray);
  %% -------------------------
    
  %% -------------------------
  %  Load all file
  %% -------------------------
  for g = 1 : nGroup
      
    % Files in this dir
    thisGroupLabel = groupArray{g};
    thisDatasumDir = sprintf('%s%s/', datasumDir, thisGroupLabel);
    thisFeatureDir = sprintf('%s/%s/', featureDir, thisGroupLabel);
    dataFileList   = listFilesInDir(thisDatasumDir);
    numFile        = length(dataFileList);
    
    resultStructure = cell(1, numFile);
    for i = 1 : numFile
      
      % Name of datasum and feature file
      thisDatasumName = dataFileList{i};
      nameStructure   = splitDatasumFilename(thisDatasumName);
      thisFeatureFileName = ...
          sprintf('data_iv_%s_%s_%s.mat', ...
          nameStructure.id, ...
          nameStructure.fname, ...
          nameStructure.post);
      
      % Full path (dir + filename)
      featurePath = sprintf('%s%s', thisFeatureDir, thisFeatureFileName);
      datasumPath = sprintf('%s%s', thisDatasumDir, thisDatasumName);
       
      % This cell's feature data
      cellData   = load(featurePath);
      cellData   = cellData.cellStruct;
      % This cell's datasum file
      dataSum    = load(datasumPath);
      ivStruct   = dataSum.datasum.iv;
      
      % Create input structure
      inputStructure.cellStruct = cellData;
      inputStructure.iv         = ivStruct;
      
      % Calculate power for all sweep in this cell
      resultStructure{i} = calculateSingleCellWavelet(inputStructure, parameters);
    end
    
    % Convert array of struct to struct array
    resultStructure = [resultStructure{:}];
    
  end
  %% -------------------------
  
  maxPowersValues = [resultStructure(:).maxPower];
  maxPowersFreqs  = [resultStructure(:).maxPowerFreq];

  %% -------------------------
  %  Create data matrix
  %% -------------------------
%   nFeature   = length(feature);
%   dataMatrix = zeros(nAllCell, nFeature);
%   for f = 1 : nFeature
%     dataMatrix(:,f) = [humanRosehip(:).(feature{f})]';
%   end
  %% -------------------------  
  
  %% -------------------------
  %  Select grouping variable
  %% -------------------------
%   labelVector = [humanRosehip(:).class]';
%   groupName   = {'first known','second known','unknown'};
%   classVector = zeros(size(labelVector));
%   
%   for g = 1 : 3
%     newLabels = findGroupElements(labelVector, groupName{g});
%     checkSelection(classVector, newLabels);
%     classVector = classVector + newLabels;
%   end
  %% -------------------------
  
  %% -------------------------
  %  Classify by SVM
  %% -------------------------
%   trainSetIdx = (classVector>-1);
%   svmLabel    = classVector(trainSetIdx);
  %% -------------------------
  
  %% -------------------------
  %  Train and plot SVM
  %% -------------------------  
%   figure;
%   modell   = svmtrain(dataMatrix(trainSetIdx,:), svmLabel, 'showplot', true);
%   classIdx = svmclassify(modell, dataMatrix(trainSetIdx,:));
%   nonNan   = ~isnan(classIdx);
%   hitNum   = sum(classIdx(nonNan)==svmLabel(nonNan));
%   hitRate  = hitNum/sum(nonNan);
  %% -------------------------
  
%   fprintf('Correct: %.2f (%d/%d)\n', 100*hitRate, hitNum, sum(nonNan));
  
  %% -------------------------
  %  Plot all data
  %% -------------------------  
%   hold on;
%   plotElement = get(gca,'Children');
%   lineHand = plotElement(1);
%   set(lineHand, 'LineWidth', 3);
%   colorVec = ['r', 'b', 'g'];
%   n = 1;
%   for g = [1,2,-1]
%     plot(dataMatrix(classVector==g,1), dataMatrix(classVector==g,2), [colorVec(n),'o'], 'MarkerFaceColor', colorVec(n), 'MarkerSize', 10);
%     n = n + 1;
%   end
%   delete(plotElement(2:end));
%   xlabel(feature{1});
%   ylabel(feature{2});
%   legend({'Separating line', 'First group','Second group', 'Unknown group'});
%   hold off;
  %% -------------------------
  
%   newLineX = (inputdlg('Value:', 'New separating line', 1));
%   newLineX = str2double(newLineX{1});
%   hold on;
%   plot([1,1]*newLineX, ylim, 'k-', 'linewidth', 3);
%   hold off;
%  
%   allClassIDX = svmclassify(modell, dataMatrix);
%   classVector1 = (allClassIDX==1);
%   classVector2 = (dataMatrix(:,1)>newLineX);
%   classVector  = classVector1&classVector2;
%   classifiedVector = ones(size(classVector)).*2;
%   classifiedVector(classVector) = 1;
%   classifiedVector(~nonNan) = NaN;
  
  %% -------------------------
  %  Print result
  %% -------------------------    
%   outputDir  = strcat(dataDir,'../');
%   outputPath = strcat(outputDir,'features.xlsx');
%   outArray   = cell(nAllCell, 6);
%   for i = 1 : nAllCell
%     outArray{i,1} = humanRosehip(i).class;
%     outArray{i,2} = humanRosehip(i).id;
%     outArray{i,3} = humanRosehip(i).name;
%     outArray{i,4} = dataMatrix(i,1);
%     outArray{i,5} = dataMatrix(i,2);
%     outArray{i,6} = classifiedVector(i);
%   end
%   outArray = [{'group','id','name','maxISIstd','sag','class'};outArray];
%   xlwrite(outputPath, outArray);

  %% -------------------------    
end

function nameStructure = splitDatasumFilename(fileName)
  pattern = ['(?<pref>(datasum))', '_', '(?<id>(0*\d+))', '_', '(?<fname>(\d{7}\w{2}\.mat))', '_', '(?<post>(g\d+_s\d+_c\d+))', '.mat'];
  nameStructure = regexp(fileName, pattern, 'names');
end

function classIdVec = findGroupElements(labelVector, groupName)

  labelTypes  = unique(labelVector);
  str         = {num2str(labelTypes)};

  [s,v] = listdlg('PromptString',sprintf('Select %s group',groupName), 'SelectionMode','multi', 'ListString',str);
  if strcmpi(groupName, 'unknown')
    multiplier = -1;
  elseif regexpi(groupName, '(first|second) known')    
    if regexpi(groupName,'first')
      multiplier = 1;
    elseif regexpi(groupName, 'second')
      multiplier = 2;
    end
  end
  
  if ~v
    errordlg('You have to select at least 1 label!');
    exception = MException('RunClassification:Unselect', 'You have to select at least 1 label!\n');
    throw(exception);
  end
  
  classIdVec = zeros(size(labelVector));
  for i = 1 : length(s)
    classIdVec = classIdVec + (labelVector==s(i))*multiplier;
  end
  
end

function checkSelection(classificationVector, newLabels)
  if sum((classificationVector~=0)&(newLabels~=0))>0
    errordlg('Each label can belong to one group!');
    exception = MException('RunClassification:Unselect', 'Each label can belong to one group!\n');
    throw(exception);
  end  
end
%calculateSingleCellWavelet(inputStructure, parameters);

