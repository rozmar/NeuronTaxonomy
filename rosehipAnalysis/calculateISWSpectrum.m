function calculateISWSpectrum(parameters)

  %% -------------------------
  %  Collect containing dir
  %% -------------------------
  datasumDir = parameters.datasumDir;
  featureDir = parameters.featureDir;
  
  [groupArray, datasumDir] = listDirsInDir(datasumDir);
  [~, featureDir]          = listDirsInDir(featureDir);

  nGroup   = length(groupArray);
  overallResult = cell(1,nGroup);
  fileCounter = 0;
  allFileName   = {};
  %% -------------------------
    
  %% -------------------------
  %  Load all file
  %% -------------------------
  for g = 1 : nGroup
      
    fprintf('Group %d/%d\n', g, nGroup);
      
    % Files in this dir
    thisGroupLabel = groupArray{g};
    thisDatasumDir = sprintf('%s%s/', datasumDir, thisGroupLabel);
    thisFeatureDir = sprintf('%s/%s/', featureDir, thisGroupLabel);
    dataFileList   = listFilesInDir(thisDatasumDir);
    numFile        = length(dataFileList);
    
    fileNameArray   = cell(1, numFile);
    resultStructure = cell(1, numFile);
    for i = 1 : numFile
      
      fileCounter = fileCounter + 1;
        
      fprintf('Group %d, file %d/%d\n', g, i, numFile);
      % Name of datasum and feature file
      thisDatasumName = dataFileList{i};
      nameStructure   = splitDatasumFilename(thisDatasumName);
      thisFeatureFileName = ...
          sprintf('data_iv_%s_%s_%s.mat', ...
          nameStructure.id, ...
          nameStructure.fname, ...
          nameStructure.post);
      
      fileNameArray{i} = nameStructure.fname;
      
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
      thisResult = calculateSingleCellWavelet(inputStructure, parameters);
      
      if isempty(thisResult)
        continue;
      end
      
      thisResult.group   = ones(1,thisResult.numSweep).*g;
      thisResult.ID      = ones(1,thisResult.numSweep).*fileCounter;
      resultStructure{i} = thisResult;
    end 
    
    % Convert array of struct to struct array
    resultStructure            = [resultStructure{:}];
    overallResult{g}           = resultStructure;
    allFileName      = cat(2,allFileName,fileNameArray);
  end
  %% -------------------------
  
  overallResult = [overallResult{:}];
  nAllSweep     = length(overallResult);
  
  powerMatrix = cell2mat([overallResult(:).meanPowerSpectrum]); % all power spectrum for all sweep
  frequencyVector =  overallResult(1).frequencyVector;
  maxPowerValues = [overallResult(:).maxPower];
  maxPowerFreqs  = [overallResult(:).maxPowerFreq];
  membPotentials = [overallResult(:).meanMembranePotential];
  segmentLength = [overallResult(:).segmentLength];
  groupLabel     = [overallResult(:).group];
  fileNames      = [overallResult(:).ID];
  fileNames      = {allFileName{fileNames}};
  
  %% -------------------------
  %  Plot all data
  %% -------------------------

%   colors = ['r', 'b', 'g'];

%   figure;
%   hold on;
%   for i = 1 : 3
%     scatter(membPotentials(groupLabel==i), ones(sum(groupLabel==i),1).*i, colors(i));
%   end

%   binEdges = -0.05:0.001:0;
%   figure;
%   hold on;
%   legendText = cell(3,1);
%   for i = 1 : 3
%     %binValues = histc(membPotentials(groupLabel==i), binEdges);
%     binValues = ksdensity(membPotentials(groupLabel==i), binEdges);
%     plot(binEdges, binValues, 'Color', colors(i));
%     legendText{i} = sprintf('n = %d', sum(groupLabel==i));
%   end
%   legend(legendText);
%   title('Distribution of average membrane potential by sweep');

  figure;
  hist(segmentLength, 0:0.05:1);
  title('Distribution of sweep segment length');
  
  [groupingLabel,binEdges] = classifyMembranePotential(membPotentials, parameters.plot.categoryNumber, parameters.plot.categoryRange);
  
  numCategory = parameters.plot.categoryNumber;
  
  colors = ['r', 'b', 'g'];
  groupLabel(groupLabel==3) = 2;
  for i = 1 : numCategory
    figure;
    hold on;
    
    legendTitles = cell(2,1);
    for j = 1 : 2
      thisCategoryThisClass = (groupLabel==j & groupingLabel==i);
      
      if sum(thisCategoryThisClass) == 0
        continue;
      end
      
      plot(frequencyVector, mean(powerMatrix(:,thisCategoryThisClass),2), '-', 'Color', colors(j));
      
      legendTitles{j} = sprintf('n = %d', sum(thisCategoryThisClass));
    end
    title(sprintf('Average power with memb. pot. [%.4f,%.4f]', binEdges(i), binEdges(i+1)));
    legend(legendTitles);
    hold off;
  end
  
  figure;
  hold on;
  legendTitles = cell(2,1);
  for j = 1 : 2
    thisCategoryThisClass = (groupLabel==j);

    if sum(thisCategoryThisClass) == 0
      continue;
    end

    plot(frequencyVector, mean(powerMatrix(:,thisCategoryThisClass),2), '-', 'Color', colors(j));

    legendTitles{j} = sprintf('n = %d', sum(thisCategoryThisClass));
  end
  title(sprintf('Average power'));
  legend(legendTitles);
  hold off;
  
%   figure;
%   hold on;
%   for i = 1 : 5
%     scatter(membPotentials(groupingLabel==i&groupLabel==1), ones(sum(groupingLabel==i&groupLabel==1),1).*i, 'r');
%     scatter(membPotentials(groupingLabel==i&groupLabel==2), ones(sum(groupingLabel==i&groupLabel==2),1).*i, 'b');
%     scatter(membPotentials(groupingLabel==i&groupLabel==3), ones(sum(groupingLabel==i&groupLabel==3),1).*i, 'g');
%   end
  %% -------------------------  

  %% -------------------------
  %  Save results to file
  %% -------------------------
  outputPath = strcat(datasumDir,'../','oscillation_features.xlsx');
  outHeader  = {...
      'File name', ...
      'Group label',...
      'Freq with max power',...
      'Max power',...
      'Membrane potential'};
  outArray   = [groupLabel', maxPowerFreqs', maxPowerValues', membPotentials'];
  outArray   = [fileNames',num2cell(outArray, [nAllSweep,4])];  
  outArray   = [outHeader;outArray];
  xlwrite(outputPath, outArray);
  %% -------------------------     

end

function [groupingLabel,binEdges] = classifyMembranePotential(dataVector, numGroup, range)
  binEdges = linspace(range(1), range(2), numGroup + 1);
  [~,groupingLabel] = histc(dataVector, binEdges);
end

% Split datasum's filename into parts
function nameStructure = splitDatasumFilename(fileName)
  pattern = ['(?<pref>(datasum))', '_', '(?<id>(0*\d+))', '_', '(?<fname>(\d{7}\w{1,2}\d?\.mat))', '_', '(?<post>(g\d+_s\d+_c\d+))', '.mat'];
  nameStructure = regexp(fileName, pattern, 'names');
end
