function calculateISWSpectrum(parameters)

  %% -------------------------
  %  Collect containing dir
  %% -------------------------
  datasumDir = parameters.datasumDir;
  featureDir = parameters.featureDir;
  
  [groupArray, datasumDir] = listDirsInDir(datasumDir);
  [~, featureDir] = listDirsInDir(featureDir);

  numberOfGroup = length(groupArray);
  overallResult = cell(1,numberOfGroup);
  fileCounter = 0;
  allFileName = {};
  fileNumberPerGroup = zeros(numberOfGroup, 1);
  %% -------------------------
    
  %% -------------------------
  %  Load all file
  %% -------------------------
  for g = 1 : numberOfGroup
    
    fprintf('Group %d/%d\n', g, numberOfGroup);
      
    % -------------------------
    % Files in this dir
    % -------------------------
    thisGroupLabel = groupArray{g};
    thisDatasumDir = sprintf('%s%s/', datasumDir, thisGroupLabel);
    thisFeatureDir = sprintf('%s/%s/', featureDir, thisGroupLabel);
    dataFileList = listFilesInDir(thisDatasumDir);
    numFile = length(dataFileList);
    fileNumberPerGroup(g) = numFile;
    % -------------------------
    
    % -------------------------
    % Process each file 
    % -------------------------
    fileNameArray   = cell(1, numFile);
    resultStructure = cell(1, numFile);
    for i = 1 : numFile
      
      fileCounter = fileCounter + 1;
        
      fprintf('Group %d, file %d/%d\n', g, i, numFile);
      
      % Name of datasum and feature file
      thisDatasumName = dataFileList{i};
      nameStructure = splitDatasumFilename(thisDatasumName);
      
      thisFeatureFileName = ...
          sprintf('data_iv_%s_%s_%s.mat', ...
          nameStructure.id, ...
          nameStructure.fname, ...
          nameStructure.post);
      
      fileNameArray{i} = [nameStructure.fname,'_',nameStructure.post];
      
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
      inputStructure.iv = ivStruct;
      
      % Calculate power for all sweep in this cell
      thisResult = calculateSingleCellWavelet(inputStructure, parameters);
      
      if isempty(thisResult)
        fileNumberPerGroup(g) = fileNumberPerGroup(g) - 1;
        continue;
      end
      
      % Add labels to result
      thisResult.group   = ones(1,thisResult.numSweep).*g;
      thisResult.ID      = ones(1,thisResult.numSweep).*fileCounter;
      
      resultStructure{i} = thisResult;
    end 
    % -------------------------
    
    % Convert array of struct to struct array
    resultStructure = [resultStructure{:}];
    overallResult{g} = resultStructure;
    allFileName = cat(2, allFileName, fileNameArray);
  end
  %% -------------------------
  
  %% -------------------------
  %  Prepare to accumulate data
  %% -------------------------
  overallResult = [overallResult{:}];
  nAllSweep = length(overallResult);
  powerMatrix = cell2mat([overallResult(:).meanPowerSpectrum]); % all power spectrum for all sweep
  frequencyVector =  overallResult(1).frequencyVector;
  membPotentials = [overallResult(:).meanMembranePotential];
  segmentLength = [overallResult(:).segmentLength];
  groupLabel = [overallResult(:).group];
  fileNames = [overallResult(:).ID];
  fileNames = allFileName(fileNames);
  %% -------------------------
  
  %% -------------------------
  %  Plot all data
  %% -------------------------
  figure;
  hist(segmentLength, 0:0.05:1);
  title('Distribution of sweep segment length');
  
  numCategory = parameters.plot.categoryNumber;
  [groupingLabel,binEdges] = ...
    classifyMembranePotential(...
    membPotentials,...
    numCategory,...
    parameters.plot.categoryRange);
  
  numberOfType = length(unique(groupLabel));
  colors = ['r', 'b', 'g'];
  for i = 1 : numCategory
    
    figure;
    hold on;
    
    legendTitles = cell(numberOfType,1);
    for j = 1 : numberOfType
      thisCategoryThisClass = (groupLabel==j & groupingLabel==i);
      
      if sum(thisCategoryThisClass) == 0
        continue;
      end
      
      plot(frequencyVector, mean(powerMatrix(:,thisCategoryThisClass),2), '-', 'Color', colors(j));
      
      legendTitles{j} = sprintf('n = %d (%d sweep)', fileNumberPerGroup(j), sum(thisCategoryThisClass));
    end
    
    title(sprintf('Average power with memb. pot. [%.4f,%.4f]', binEdges(i), binEdges(i+1)));
    legend(legendTitles);
    hold off;
  end
  
  figure;
  hold on;
  for j = 1 : numberOfType
    thisCategoryThisClass = (groupLabel==j);

    if sum(thisCategoryThisClass) == 0
      continue;
    end

    plot(frequencyVector, mean(powerMatrix(:,thisCategoryThisClass),2), '-', 'Color', colors(j));

    legendTitles{j} = sprintf('n = %d (%d sweep)', fileNumberPerGroup(j), sum(thisCategoryThisClass));
  end
  title(sprintf('Average power'));
  legend(legendTitles);
  hold off;
  %% -------------------------  

  %% -------------------------
  %  Save results to file
  %% -------------------------
  idArray = [fileNames', num2cell(groupLabel')];
  idHeader = {'File', 'Group'};
  
  metadataPath = strcat(datasumDir,'../','oscillation_features_metadata.xlsx');
  metaHeader  = {...
      idHeader{:},...
      'Average membrane potential',...
      'Length of segment'};
    
  metaArray = [membPotentials', segmentLength'];
  metaArray = [idArray, num2cell(metaArray)];  
  metaArray = [metaHeader; metaArray];
  xlwrite(metadataPath, metaArray);
  
  powerdataPath = strcat(datasumDir,'../','oscillation_features_powerspectrum.xlsx');
  frequencyAsArray = num2cell(frequencyVector);
  powerHeader = [idHeader, frequencyAsArray{:}];
  powerMatrix = powerMatrix';
  
  powerArray = cell(size(powerMatrix,1), 2 + length(frequencyVector));
  for i = 1 : size(powerMatrix,1)
    thisRow = num2cell(powerMatrix(i, :));
    powerArray(i,:) = {fileNames{i}, groupLabel(i), thisRow{:}};
  end
  
  powerArray = [powerHeader;powerArray];
  xlwrite(powerdataPath, powerArray);
  
  overalldataPath = strcat(datasumDir,'../','oscillation_features_all.xlsx');
  overallHeader = [metaHeader, frequencyAsArray];
  overallData = [metaArray(2:end,:), powerArray(2:end,3:end)];
  xlwrite(overalldataPath, [overallHeader; overallData]);
  
  numberOfFiles = length(overallResult);
  numberOfISIPerSweep = zeros(length(groupLabel), 1);
  
  sweepCounter = 1;
  for f = 1 : numberOfFiles
    for s = 1 : overallResult(f).numSweep
      numberOfISIPerSweep(sweepCounter) = length(overallResult(f).sweepISIVector{s});
      sweepCounter = sweepCounter + 1;
    end
  end
  maxIsiPerSweep = max(numberOfISIPerSweep);
  
  sweepCounter = 1;
  isiArray = cell(length(groupLabel), maxIsiPerSweep);
  for f = 1 : numberOfFiles
    for s = 1 : overallResult(f).numSweep
      thisSweepISI = overallResult(f).sweepISIVector{s};
      isiArray(sweepCounter,1:numberOfISIPerSweep(sweepCounter)) = num2cell(thisSweepISI);
      sweepCounter = sweepCounter + 1;
    end
  end
  
  isiArray = [idArray , isiArray];
  isidataPath = strcat(datasumDir,'../','oscillation_features_isi.xlsx');
  xlwrite(isidataPath, isiArray);
  %% -------------------------     

end

function [groupingLabel,binEdges] = classifyMembranePotential(dataVector, numGroup, range)
  binEdges = linspace(range(1), range(2), numGroup + 1);
  [~,groupingLabel] = histc(dataVector, binEdges);
end

