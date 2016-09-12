function runClassification(parameters)

  %% -------------------------
  %  Collect parameters
  %% -------------------------
  dataDir = parameters.dataFile;
  dsDir   = parameters.dataSums;
  cutInt  = parameters.cutInterval;
  nMinAP  = parameters.nMinAp;
  feature = {'maxISIstd','sag'};
  %% -------------------------
  
  %% -------------------------
  %  Preprocess directories
  %% -------------------------
  [groupArray, dataDir] = listDirsInDir(dataDir);
  [~, dsDir] = listDirsInDir(dsDir);
  %% -------------------------
  
  %% -------------------------
  %  Load all file
  %% -------------------------
  nGroup   = length(groupArray);
  nAllCell = 0;
  wb1      = waitbar(0, sprintf('0/%d group processed', nGroup));
  for g = 1 : nGroup
    % Files in this dir
    thisdsDir   = sprintf('%s%s/', dsDir, groupArray{g});
    thisdataDir = sprintf('%s%s/', dataDir, groupArray{g});
    
    dsfileList = listFilesInDir(thisdsDir);
    
    nFile    = length(dsfileList);
    wb2      = waitbar(0, sprintf('0/%d file in group processed', nFile));
    for i = 1 : nFile
        
      % Name of datasum file
      dsName   = dsfileList{i};
      dsPath   = sprintf('%s%s', thisdsDir, dsName);
      
      % Name of data file
      dataName = sprintf('data_iv_%s', dsName(length('datasum_')+1:end));
      dataPath = sprintf('%s%s', thisdataDir, dataName);
      
      % This cell datasum
      cellDS       = load(dsPath);
      cellDS       = cellDS.datasum;
      cellDS.class = g;
      dsName       = dsName(length('datasum_')+1:end);
      firstUS      = strfind(dsName,'_');
      cellDS.id    = str2double(dsName(1:firstUS-1));
      cellDS.name  = dsName(firstUS+1:end);
      
      % This cell data
      cellData   = load(dataPath);
      cellData   = cellData.cellStruct;
      
      % End and start of sweep
      recStart   = cellDS.iv.time(cellData.taustart);
      recEnd     = recStart + cellDS.iv.segment(2)/1000;
      recRange   = [recStart,recEnd];
      
      % This cell active sweeps
      thisAPF    = cellData.apFeatures;      
      maxSD = findMaxSDInSweep(recRange, cutInt, nMinAP, thisAPF);
      cellDS.maxISIstd = maxSD;
      
      % Group cells
      nAllCell   = nAllCell + 1;
      humanRosehip(nAllCell) = cellDS;  %#ok<AGROW>
      wb2 = waitbar(i/nFile, wb2, sprintf('%d/%d file in group processed', i, nFile));
    end
    close(wb2);
    wb1 = waitbar(g/nGroup, wb1, sprintf('%d/%d group processed', g, nGroup));
  end
  close(wb1);
  %% -------------------------

  %% -------------------------
  %  Create data matrix
  %% -------------------------
  nFeature   = length(feature);
  dataMatrix = zeros(nAllCell, nFeature);
  for f = 1 : nFeature
    dataMatrix(:,f) = [humanRosehip(:).(feature{f})]';
  end
  %% -------------------------  
  
  %% -------------------------
  %  Select grouping variable
  %% -------------------------
  labelVector = [humanRosehip(:).class]';
  groupName   = {'first known','second known','unknown'};
  classVector = zeros(size(labelVector));
  
  for g = 1 : 3
    newLabels = findGroupElements(labelVector, groupName{g});
    checkSelection(classVector, newLabels);
    classVector = classVector + newLabels;
  end
  %% -------------------------
  
  %% -------------------------
  %  Classify by SVM
  %% -------------------------
  trainSetIdx = (classVector>-1);
  svmLabel    = classVector(trainSetIdx);
  %% -------------------------
  
  %% -------------------------
  %  Train and plot SVM
  %% -------------------------  
  figure;
  modell   = svmtrain(dataMatrix(trainSetIdx,:), svmLabel, 'showplot', true);
  classIdx = svmclassify(modell, dataMatrix(trainSetIdx,:));
  nonNan   = ~isnan(classIdx);
  hitNum   = sum(classIdx(nonNan)==svmLabel(nonNan));
  hitRate  = hitNum/sum(nonNan);
  %% -------------------------
  
  fprintf('Correct: %.2f (%d/%d)\n', 100*hitRate, hitNum, sum(nonNan));
  
  %% -------------------------
  %  Plot all data
  %% -------------------------  
  hold on;
  plotElement = get(gca,'Children');
  lineHand = plotElement(1);
  set(lineHand, 'LineWidth', 3);
  colorVec = ['r', 'b', 'g'];
  n = 1;
  for g = [1,2,-1]
    plot(dataMatrix(classVector==g,1), dataMatrix(classVector==g,2), [colorVec(n),'o'], 'MarkerFaceColor', colorVec(n), 'MarkerSize', 10);
    n = n + 1;
  end
  delete(plotElement(2:end));
  legend({'First group','Second group', 'Unknown group', 'Separating line'});
  hold on;
  %% -------------------------
  
  %% -------------------------
  %  Print result
  %% -------------------------    
  outputDir  = strcat(dataDir,'../');
  outputPath = strcat(outputDir,'features.xlsx');
  outArray   = cell(nAllCell, 5);
  for i = 1 : nAllCell
    outArray{i,1} = humanRosehip(i).class;
    outArray{i,2} = humanRosehip(i).id;
    outArray{i,3} = humanRosehip(i).name;
    outArray{i,4} = dataMatrix(i,1);
    outArray{i,5} = dataMatrix(i,2);
  end
  outArray = [{'group','id','name','maxISIstd','sag'};outArray];
  xlwrite(outputPath, outArray);
  
  %% -------------------------    
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