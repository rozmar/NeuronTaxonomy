function calculateInterburstFrequency(parameters)

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
    
    if g>1
      break;
    end
    
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
      thisResult = calculateSingleCellBurst(inputStructure, parameters);
      
      if isempty(thisResult)
        fileNumberPerGroup(g) = fileNumberPerGroup(g) - 1;
        continue;
      end
      
      % Add labels to result
      thisResult.group   = g;
      thisResult.ID      = fileCounter;
      
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
    
  groupLabel = [];
  fileIDs = [];
  pooledFrequency = [];
  pooledLength = [];
  outlier_files = [];
  maximalBurstLength = 0;
  numberOfBursts = 0;
  numberOfCell = length(overallResult);
  for c = 1 : numberOfCell
    pooledFrequency = cat(1, pooledFrequency, cell2mat(overallResult(c).burstFrequency));
    pooledLength = cat(1, pooledLength, cell2mat(overallResult(c).burstLength));
    numberOfSweep = length(overallResult(c).burstISI);
    for s = 1 : numberOfSweep
      thisSweepBursts = overallResult(c).burstISI{s};
      if isempty(thisSweepBursts)
        continue;
      end
      numberOfBursts = numberOfBursts + length(thisSweepBursts);
      maximalBurstLength = max([maximalBurstLength; cellfun(@length, thisSweepBursts)]);
      
      groupLabel = cat(1, groupLabel, ones(length(thisSweepBursts), 1) .* overallResult(c).group);
      fileIDs = cat(1, fileIDs, ones(length(thisSweepBursts), 1) .* overallResult(c).ID);
      
      outlying_spikes = find(overallResult(c).burstFrequency{s}>200, 1);
      
      if ~isempty(outlying_spikes)
        outlier_files = cat(1, outlier_files, [c s]);
      end
      
    end
  end
  
%   for i = 1 : size(outlier_files, 1)
%     figure;
%     cellNum = outlier_files(i,1);
%     sweepNum = outlier_files(i,2);
%     sweepBurstFreqs = overallResult(cellNum).burstFrequency{sweepNum};
%     tooFastBurst = find(sweepBurstFreqs>200);
%     hold on;
%     plot(overallResult(cellNum).timeVector, overallResult(cellNum).sweepIV{sweepNum});
%     for b = 1 : length(tooFastBurst)
%       thisBurst = overallResult(cellNum).burstArray{sweepNum};
%       thisBurst = thisBurst{tooFastBurst(b)};
%       plot(thisBurst([1,end]), [0.1,0.1], 'r-');
%     end
%     hold off;
%     title([strrep(allFileName{c},'_','\_'),' Sweep ',num2str(sweepNum)]);
%     print(gcf,strcat(datasumDir,'../',allFileName{cellNum},'_sweep_',num2str(sweepNum),'.png'), '-dpng', '-r600');
%   end
  
  pooledBurstISI = cell(numberOfBursts, maximalBurstLength);
  burstCounter = 1;
  for c = 1 : numberOfCell
    for s = 1 : length(overallResult(c).burstISI)
      thisSweepBursts = overallResult(c).burstISI{s};
      for b = 1 : length(thisSweepBursts)
        if isempty(thisSweepBursts{b})
          continue;
        end
        isiInThisBurst = length(thisSweepBursts{b});
        burstAsCell = num2cell(thisSweepBursts{b}');
        pooledBurstISI(burstCounter, (1:isiInThisBurst)) = burstAsCell;
        burstCounter = burstCounter + 1;
      end
    end
  end
  
  fileNames = allFileName(fileIDs);
  %% -------------------------
  
  %% -------------------------
  %  Plot all data
  %% -------------------------
  if parameters.plot.individual
    for i = 1 : length(overallResult)
      cellResult = overallResult(i);
      numOfSweep = length(cellResult.sweepIV);
      [r, c] = getSubplotDimension(numOfSweep);
      thisFileTitle = allFileName{cellResult.ID};
      figure;
      for j = 1 : numOfSweep
        subplot(r, c, j);
        hold on;
        plot(cellResult.timeVector, cellResult.sweepIV{j}, 'b-');
        sweepBurst = cellResult.burstArray{j};
        for s = 1 : length(sweepBurst)
          currentBurst = sweepBurst{s};
          plot(currentBurst([1,end]), [1, 1] .* max(cellResult.sweepIV{j}), 'r-');
        end
        hold off;
      end
      suptitle(strrep(thisFileTitle,'_','\_'));
    end
  end
  %% -------------------------  

  %% -------------------------
  %  Save results to file
  %% -------------------------
%   cumulativeIdArray = [fileNames', num2cell(groupLabel)];
%   cumulativeDataFile = strcat(datasumDir,'../','burst_features.xlsx');
%   cumulativeArray = {'File name', 'Group', 'Burst length', 'Burst avg. freq.'};
%   cumulativeArray = [cumulativeArray;[cumulativeIdArray, num2cell(pooledLength), num2cell(pooledFrequency)]];
%   xlwrite(cumulativeDataFile, cumulativeArray);
%   
%   singleBurstDataFile = strcat(datasumDir,'../','burst_isi.xlsx');
%   singleBurstArray = [cumulativeIdArray, pooledBurstISI];
%   xlwrite(singleBurstDataFile, singleBurstArray);
  %% -------------------------     

end

% Split datasum's filename into parts
function nameStructure = splitDatasumFilename(fileName)
  pattern = ['(?<pref>(datasum))', '_', '(?<id>(0*\d+))', '_', '(?<fname>(\d{7}\w{1,2}\d?\.mat))', '_', '(?<post>(g\d+_s\d+_c\d+))', '.mat'];
  nameStructure = regexp(fileName, pattern, 'names');
end
