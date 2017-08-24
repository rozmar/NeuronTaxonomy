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
  
  if ~isfield(parameters, 'classMode') || strcmpi(parameters.classMode, 'svm')
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
    xlabel(feature{1});
    ylabel(feature{2});
    legend({'Separating line', 'First group','Second group', 'Unknown group'});
    hold off;
    %% -------------------------

    newLineX = (inputdlg('Value:', 'New separating line', 1));
    newLineX = str2double(newLineX{1});
    hold on;
    plot([1,1]*newLineX, ylim, 'k-', 'linewidth', 3);
    hold off;

    allClassIDX = svmclassify(modell, dataMatrix);
    classVector1 = (allClassIDX==1);
    classVector2 = (dataMatrix(:,1)>newLineX);
    classVector  = classVector1&classVector2;
    classifiedVector = ones(size(classVector)).*2;
    classifiedVector(classVector) = 1;
    classifiedVector(~nonNan) = NaN;

    %% -------------------------
    %  Print result
    %% -------------------------    
    outputDir  = strcat(dataDir,'../');
    outputPath = strcat(outputDir,'features.xlsx');
    outArray   = cell(nAllCell, 6);
    for i = 1 : nAllCell
      outArray{i,1} = humanRosehip(i).class;
      outArray{i,2} = humanRosehip(i).id;
      outArray{i,3} = humanRosehip(i).name;
      outArray{i,4} = dataMatrix(i,1);
      outArray{i,5} = dataMatrix(i,2);
      outArray{i,6} = classifiedVector(i);
    end
    outArray = [{'group','id','name','maxISIstd','sag','class'};outArray];
    xlwrite(outputPath, outArray);
    %% -------------------------  
  elseif strcmpi(parameters.classMode, 'gmm')
    groupVector = [humanRosehip(:).class]'; % collect class labels
    groupVector(groupVector~=1) = 2;  % convert to 2 class
    
    PMatrix = calculatePosterior(dataMatrix, groupVector);
    
    sureRosehip = PMatrix(:,1) > 0.6;
    sureNRosehip = PMatrix(:,2) > 0.6;
    
    maybeRosehip = (abs(PMatrix(:,1) - 0.5) < 0.1)&(PMatrix(:,1) > 0.5);
    maybeNRosehip = (abs(PMatrix(:,2) - 0.5) < 0.1)&(PMatrix(:,2) > 0.5);
    
    legendArray = {};
    
    if sum(sureRosehip)>0
      legendArray = [legendArray;'Probably rosehip'];
    end
    
    if sum(sureNRosehip)>0
      legendArray = [legendArray;'Probably non-rosehip'];
    end
    
    if sum(maybeRosehip)>0
      legendArray = [legendArray;'Maybe rosehip'];
    end
    
    if sum(maybeNRosehip)>0
      legendArray = [legendArray;'Maybe non-rosehip'];
    end
    
    if sum(groupVector==1)>0
      legendArray = [legendArray;'Identified rosehip'];
    end
    
    if sum(groupVector==2)>0
      legendArray = [legendArray;'Identified non-rosehip'];
    end    
    
    %% -------------------------
    %  Plot result
    %% -------------------------     
    figure;
    hold on;
    scatter(dataMatrix(sureRosehip,1), dataMatrix(sureRosehip,2), 'r', 'filled');
    scatter(dataMatrix(sureNRosehip,1), dataMatrix(sureNRosehip,2), 'b', 'filled');
    
    scatter(dataMatrix(maybeRosehip,1), dataMatrix(maybeRosehip,2), 'r');
    scatter(dataMatrix(maybeNRosehip,1), dataMatrix(maybeNRosehip,2), 'b');
    
    plot(dataMatrix(groupVector==1, 1), dataMatrix(groupVector==1, 2), 'r.');
    plot(dataMatrix(groupVector==2, 1), dataMatrix(groupVector==2, 2), 'b.');
    hold off;
    
    legend(legendArray);
    %% -------------------------
    
    %% -------------------------
    %  Print result
    %% -------------------------  
    if isSave(parameters)
      outputDir  = strcat(dataDir,'../');
      outputPath = strcat(outputDir,'probabilities.xlsx');
      outArray   = cell(nAllCell, 5);
      for i = 1 : nAllCell
        outArray{i,1} = humanRosehip(i).id;
        outArray{i,2} = humanRosehip(i).name;
        outArray{i,3} = humanRosehip(i).class;
        outArray{i,4} = PMatrix(i,1);
        outArray{i,5} = PMatrix(i,2);
      end
      outArray = [{'Cell id', 'Filename', 'Real class', 'P in Rosehip', 'P in non-rosehip'};outArray];
      xlwrite(outputPath, outArray);
    end
    %% -------------------------     
    
  end
end

function answer = isSave(parameters)
  answer = isfield(parameters, 'toSave') && parameters.toSave;
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