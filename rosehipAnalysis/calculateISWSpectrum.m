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
  
  maxPowerValues = [overallResult(:).maxPower];
  maxPowerFreqs  = [overallResult(:).maxPowerFreq];
  membPotentials = [overallResult(:).meanMembranePotential];
  groupLabel     = [overallResult(:).group];
  fileNames      = [overallResult(:).ID];
  fileNames      = {allFileName{fileNames}};
  
  %% -------------------------
  %  Plot all data
  %% -------------------------    
  figure;
  subplot(1,2,1);
  scatter(membPotentials, maxPowerValues);
  title('Membrane potential vs. Maximal power');
  subplot(1,2,2);
  scatter(membPotentials, maxPowerFreqs);
  title('Membrane potential vs. Frequency with maximal power');
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

% Split datasum's filename into parts
function nameStructure = splitDatasumFilename(fileName)
  pattern = ['(?<pref>(datasum))', '_', '(?<id>(0*\d+))', '_', '(?<fname>(\d{7}\w{1,2}\.mat))', '_', '(?<post>(g\d+_s\d+_c\d+))', '.mat'];
  nameStructure = regexp(fileName, pattern, 'names');
end
