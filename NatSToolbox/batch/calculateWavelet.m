function [resultStructure,parameters] = calculateWavelet(inputStructure, parameters)

  %% ------------------------------
  %  Check parameters
  %% ------------------------------
  parameters = checkParameters(parameters);
  %% ------------------------------
  
  %% ------------------------------
  %  Preprocess signal
  %% ------------------------------ 
  [inputStructure,signalStructure]  = preprocessSignal(inputStructure, parameters);
  parameters.wavelet.interval       = getSI(signalStructure);
  %% ------------------------------
        
  %% ------------------------------
  %  Create time axis
  %% ------------------------------  
  [timeVector, displayInterval, baselineInterval] = ...
      createTimeVector(parameters, getSI(signalStructure));
  %% ------------------------------
           
  %% ------------------------------
  %  Collect trigger markers
  %% ------------------------------
  [triggerVector,positionVector] = collectTriggers(inputStructure, parameters.channel); %#ok<NASGU>
  %% ------------------------------
  
  %% ------------------------------
  %  Collect triggers' neighbors
  %% ------------------------------
  if needNeighbors(parameters)
      
    [triggerVector,neighborMatrix] = ...
        collectTriggerNeighbors(triggerVector, inputStructure, parameters.neighbor);
  end
  %% ------------------------------
    
  %% ------------------------------
  %  Cut slices around triggers
  %% ------------------------------
  sliceMatrix = collectSlicesAroundTriggers(triggerVector, signalStructure, timeVector);
  %% ------------------------------

  %% ------------------------------
  %  Categorize triggers
  %% ------------------------------
  if needCategory(parameters)
    categoryBaseVector = eval(parameters.categorization.categorizationBase);
    categorizationFunc = parameters.categorization.categorizationFunction;
    categoryVector     = categorizationFunc([], categoryBaseVector, parameters.categorization);
  end
  %% ------------------------------
    
  %% ------------------------------
  %  Tidy up memory
  %% ------------------------------
  clear signalStructure triggerVector;
  %% ------------------------------
    
  %% ------------------------------
  %  Perform wavelet TFD
  %% ------------------------------  
  % If we want plot every single trial,
  % or we want to categorize trials, or
  % we want to normalize individually,
  % we need the individual power matrices
  if ~isGlobalBaseline(parameters)||needSingle(parameters)||needCategory(parameters)
    [powerMatrix, frequencyVector, ~, powerPerTrial] = calculateTFDPower(sliceMatrix', parameters.wavelet);  
  else
    [powerMatrix, frequencyVector]                   = calculateTFDPower(sliceMatrix', parameters.wavelet);
  end
  %% ------------------------------  

  %% ------------------------------
  %  Create result structure
  %% ------------------------------
  % Administrative data
  resultStructure.type             = 'single';   %this is a single file
  resultStructure.fileName         = inputStructure.title;   %file name
  
  % X and Y axis
  resultStructure.frequencyVector  = frequencyVector';
  resultStructure.timeVector       = timeVector;
  resultStructure.baselineInterval = baselineInterval;
  resultStructure.displayInterval  = displayInterval;
  
  resultStructure.sliceMatrix      = sliceMatrix;
  if needCategory(parameters)
    resultStructure.categoryVector   = categoryVector; 
  end
  
  % Save neighbor matrix
  if needNeighbors(parameters)
    resultStructure.neighborMatrix = neighborMatrix;
  end
  
  % Save averaged raw power matrix
  if isGlobalBaseline(parameters)
    resultStructure.powerMatrix    = powerMatrix;
  end
  
  % Save per trial power matrices
  if exist('powerPerTrial', 'var')
    resultStructure.pPerTrial      = powerPerTrial;
  end 
  
  %% ------------------------------
  %  Normalize and plot overall
  %  average power spectrogram.
  %% ------------------------------
  if needOverall(parameters)
    resultStructure = showSpectrogram(resultStructure, parameters, 'overall');
  end
  %% ------------------------------  
  
  %% ------------------------------
  %  Normalize and plot single 
  %  power spectrogram.
  %% ------------------------------
  if needSingle(parameters)    
    showSpectrogram(resultStructure, parameters, 'individual');
  end
  %% ------------------------------  
  
  %% ------------------------------
  %  Normalize and plot category 
  %  power spectrogram.
  %% ------------------------------  
  if needCategory(parameters)
    resultStructure = showSpectrogram(resultStructure, parameters, 'categorization');
  end
  %% ------------------------------  

  if isfield(resultStructure, 'pPerTrial')
    % Remove power per trial from result structure to spare memory
    resultStructure = rmfield(resultStructure,'pPerTrial');
  end
  
  % Save data to file
  if isSave(parameters)
    saveData(resultStructure, parameters);
  end  
  
  
end

% Averages each matrix given in the input array
function averageMatrix = averageIndividualMatrix(individualMatrixArray)

  %% --------------------------
  %  Initialization
  %% --------------------------
  nMatrix = length(individualMatrixArray);  
  averageMatrix = zeros(size(individualMatrixArray{1}));
  %% --------------------------
  
  %% --------------------------
  %  Sum matrices
  %% --------------------------
  for i = 1 : nMatrix
     averageMatrix = averageMatrix + individualMatrixArray{i};
  end
  % Divide sum matrix with element number
  averageMatrix = averageMatrix./nMatrix;
  %% --------------------------
  
end

% This function collects and returns the neighboring markers around the
% trigger within a given radius. Removes those triggers which don't have
% both neighbors.
function [triggerVector,neighborMatrix] = collectTriggerNeighbors(triggerVectorOld, inputStructure, parameter)

  % collect the neighbor markers
  neighborVector = getMarkersByField(inputStructure, parameter.name);
  
  % select the neighboring markers
  [triggerVector, neighborMatrix] = ...
      collectNeighboringEvents(triggerVectorOld, neighborVector, parameter.interval);
end

% This function performs the spectrogram display: normalize with the given
% method then show the plot. 
function resultOut = showSpectrogram(resultStructure, parameters, type)
    
  timeVector       = resultStructure.timeVector;
  frequencyVector  = resultStructure.frequencyVector;
  baselineInterval = resultStructure.baselineInterval;
  displayInterval  = resultStructure.displayInterval;
  sliceMatrix      = resultStructure.sliceMatrix;
  
  resultOut        = resultStructure;
    
  if strcmpi(type, 'overall')

    parameters.plot.title = createSpectrogramTitle(resultStructure.fileName, parameters);
  
    if isGlobalBaseline(parameters)
      powerMatrix     = resultStructure.powerMatrix;   
      normalizedPower = normalizeSpectrogramGlobal(powerMatrix, displayInterval, baselineInterval, parameters);
    else
      pPerTrial        = resultStructure.pPerTrial;
      neighborMatrix  = resultStructure.neighborMatrix;
      normalizedPower = normalizeSpectrogramIndividual(pPerTrial, displayInterval, timeVector, neighborMatrix, parameters);
    end
    
    figure;
    displaySpectrogram(timeVector(displayInterval), frequencyVector, normalizedPower, sliceMatrix(:,displayInterval), parameters.plot);
    
    if isSave(parameters)
      parameters.output.fileName = resultStructure.fileName;
      savePlot(gcf, 'average', parameters)
    end
    
    resultOut.normPower = normalizedPower;
    
  elseif strcmpi(type, 'individual')
    pPerTrial        = resultStructure.pPerTrial;
    for t = 1 : length(pPerTrial)
        
      parameters.plot.title = createSpectrogramTitle(resultStructure.fileName, parameters);
      parameters.plot.title = strjoin({parameters.plot.title, 'Trial', num2str(t)},' ');
  
      powerMatrix = pPerTrial{t};
      
      if isGlobalBaseline(parameters)
        normalizedPower = normalizeSpectrogramGlobal(powerMatrix, displayInterval, baselineInterval, parameters);
      else
        neighborMatrix   = resultStructure.neighborMatrix;
        normalizedPower = normalizeSpectrogramIndividual(powerMatrix, displayInterval, timeVector, neighborMatrix(t,:), parameters);
      end
    
      figure;
      displaySpectrogram(timeVector(displayInterval), frequencyVector, normalizedPower, sliceMatrix(t,displayInterval), parameters.plot);
    
      if isSave(parameters)
        parameters.output.fileName = resultStructure.fileName;
        savePlot(gcf, strjoin({'trial',num2str(t)},'_'), parameters);
      end
    end
  elseif strcmpi(type, 'categorization')
    
    printStatus('Trigger number by category');
    
    % Remove specific color limit
    if isfield(parameters.categorization,'categoryColorLimit')
      parameters.plot.colorLimit = parameters.categorization.categoryColorLimit;
    else
      parameters.plot.colorLimit = [0,1];
    end
    
    categoryVector = resultStructure.categoryVector;
    
    categoryLabels       = getCategoryLabels(parameters, categoryVector);
    categoryAverage      = cell(length(categoryLabels),1);
    normCategoryAverage  = cell(length(categoryLabels),1);
    categoryAverageSlice = cell(length(categoryLabels),1);
    pPerTrial        = resultStructure.pPerTrial;
    
    for c = 1 : length(categoryLabels)
        
        
      % Filter to current category
      thisCategoryFlag = (categoryVector==categoryLabels(c));
      
      if sum(thisCategoryFlag)==0
        continue;
      end
      
      % Power matrices in this category
      categoryAverage{c} = averageIndividualMatrix(pPerTrial(thisCategoryFlag));
            
      fprintf('Category %s %d:\t%3d\n', parameters.categorization.categorizationName, c, sum(thisCategoryFlag));
      
      if toLog
        global logFile; %#ok<*TLEV>
        fprintf(logFile, 'category %s %d;%d\n', parameters.categorization.categorizationName, c, sum(thisCategoryFlag));
      end
      
      % Normalized power in this category
      thisCategoryNormPower   = normalizeSpectrogramGlobal(categoryAverage{c}, displayInterval, baselineInterval, parameters);  
      normCategoryAverage{c}  = thisCategoryNormPower;
      categoryAverageSlice{c} = mean(sliceMatrix(thisCategoryFlag,:),1);
          
      parameters.plot.title = createSpectrogramTitle(resultStructure.fileName, parameters);
      parameters.plot.title = strjoin({parameters.plot.title, 'Category', num2str(c)},' ');
                
      figure;
      displaySpectrogram(timeVector(displayInterval), frequencyVector, thisCategoryNormPower, sliceMatrix(thisCategoryFlag,displayInterval), parameters.plot);
      
      if isSave(parameters)
        parameters.output.fileName = resultStructure.fileName;
        savePlot(gcf, sprintf('%d_category',c), parameters)
      end
    end
    
    % If we need categorization, save category vector and category average
    if needCategory(parameters)
      resultOut.categoryAverageRaw = categoryAverage;
      resultOut.categoryAverageNorm = normCategoryAverage;
      resultOut.categoryAverageSlice = categoryAverageSlice;
    end
    
  end
  
end

% This function calculates averaged normalized spectrogram with individual
% baseline. Individual baseline will be the section between neighbors.
function normalizedPower = normalizeSpectrogramIndividual(matrixArray, displayInterval, timeVector, neighborMatrix, parameters)

  % Normalization type
  normType = parameters.wavelet.normalization.type;
       
  % If the normalization baseline will be individual,  
  normalizedPower = normalizeMatrixByGroup(timeVector, matrixArray, neighborMatrix, normType);
  normalizedPower = normalizedPower(:,displayInterval);
          
end

% This function normalize the averaged matrix if the baseline is global.
function normPowerMatrix = normalizeSpectrogramGlobal(powerMatrix, displayInterval, baselineInterval, parameters)

  % Normalization type
  normType = parameters.wavelet.normalization.type;

  % Select power belongs to baseline
  baselinePower   = powerMatrix(:,baselineInterval);
  displayPower    = powerMatrix(:,displayInterval);
  
  % Normalize the power matrix with the baseline
  normPowerMatrix = normalizeMatrixWithBaseline(displayPower, baselinePower, normType);
          
end

% This function creates a spectrogram from the given normalized power
% matrix, and plots the waveform if needed.
function displaySpectrogram(timeVector, frequencyVector, powerMatrix, sliceMatrix, parameters)
    
    % Plot overall averaged spectrogram
    plotPowerSpectrum(timeVector, frequencyVector, powerMatrix, parameters);
    
    % Plot waveform if needed
    if parameters.plotWaveform
      plotWaveform(timeVector, sliceMatrix, parameters);
    end
    
end

% Creates plot title from parameters and filename
function finalTitle = createSpectrogramTitle(fileName, parameters)
  
  triggerText       = parameters.channel.trigger.title;        %title of trigger
  normalizationType = parameters.wavelet.normalization.type;   %type of normalization
  fileNameEscaped   = strrep(fileName,'_','\_');               %name of file
    
  finalTitle = strjoin({triggerText,'triggered', fileNameEscaped, '(', normalizationType, 'norm.',')'}, ' ');
end

% This function creates the time vector for spectrogram 
% and define the time interval to show on plot.
function [timeVector,displayInterval,baselineInterval] = createTimeVector(parameters, SI)

  timeBound = parameters.plot.timeBound;
  radius    = parameters.wavelet.triggerRadius;
  
  timeVector      = linspace(-radius, radius, 2*round(radius/SI) + 1);
  displayInterval = (timeBound(1)<=timeVector&timeVector<=timeBound(2));
  
  if isGlobalBaseline(parameters)
    baseTime         = parameters.wavelet.normalization.baselineTime;
    baselineInterval = (baseTime(1)<=timeVector&timeVector<=baseTime(2));
  else
    baselineInterval = [];
  end  

end

% =================================
% Preprocessing functions
% =================================
% This function performs the required preprocessing steps. Returns the
% modified input structure (S) and the signal structure.
function [S,signalStructure] = preprocessSignal(Sin, parameters)
 
  S = Sin;
  signalChannelName = parameters.channel.signal;
  signalStructure   = S.(signalChannelName);
  
  if parameters.toDownSample
    signalStructure.times = downsample(signalStructure.times, parameters.downSampleRate);
    signalStructure.values = downsample(signalStructure.values, parameters.downSampleRate);
    signalStructure.interval = signalStructure.interval*parameters.downSampleRate;
    Fs = round(1/signalStructure.interval);
    printStatus(sprintf('Downsampling to %.0dHz',Fs),'*');
  end

  % Cut the recording
  if parameters.isCut
    S = cutRecording(S, parameters.cutInterval);
  end  
  
  % Despike signal
  if parameters.toDespike
      
    % Check if spike field exists
    checkFieldExist(S, 'spike');
    
    % Perform despiking
    signalStructure.values = despikeRecording(signalStructure, S.spike, signalStructure.interval);  
  end
  
  %  Filter signal
  if parameters.toFilter
    filtParam    = parameters.filter;
    filtParam.Fs = round(1/signalStructure.interval);
    
    printStatus(sprintf('Bandpass filtering %s', signalStructure.title), '*');
    fprintf('[%d, %d] Hz\n\n', filtParam.filterBounds);
    
    signalStructure.values = filterSignal(signalStructure.values, filtParam);
  end
  
  S.(signalChannelName)  = signalStructure;     
end

% Despike recording
function despiked = despikeRecording(widebandStruct, spikeStruct, SI)

  fprintf('Start despiking. Fit power spectrum.\n');
  
  Fs = round(1/SI);
  
  g = fitLFPpowerSpectrum(widebandStruct.values,0.01,1000, Fs);
  
  spikeRadius = [-0.0005, 0.0015];
  spikeRadiusOffset = round(spikeRadius/SI);
  spikeTrain = zeros(size(widebandStruct.times));
  
  for i = 1 : length(spikeStruct.times)
    spikeTrain(find(widebandStruct.times>=spikeStruct.times(i),1,'first')+spikeRadiusOffset(1)) = 1;
  end  
  
  Bs = eye(diff(spikeRadiusOffset));
  fprintf('Perform despiking.\n');
  results = despikeLFP(widebandStruct.values, spikeTrain, Bs, g, struct('displaylevel', 0));
  despiked = results.z;
  close gcf;
  
end
% =================================

% =================================
% Validation functions
% =================================
% Validates the given parameters.
function parameters = checkParameters(inParameters)

  parameters = inParameters;
  
  %% ---------------------------
  %  Check if the display limit
  %  is inside of process limit
  %% ---------------------------
  waveParam = parameters.wavelet;
  waveLimit = sort([waveParam.min, waveParam.max]);
  wPlotLim  = sort(parameters.plot.frequencyBound);
  
  wPlotLim(1) = max([wPlotLim(1),waveLimit(1)]);
  wPlotLim(2) = min([wPlotLim(2),waveLimit(2)]);
  
  parameters.plot.frequencyBound = wPlotLim;
  %% ---------------------------

  %% ---------------------------
  %  Generate xtick and ytick
  %% ---------------------------  
  %  Plot parameter struct
  plotParam = parameters.plot;
  
  % Units of the x axis
  plotParam.xTick = plotParam.timeBound(1):plotParam.xTickStep:plotParam.timeBound(2);
  plotParam.xTickLabel = plotParam.xTick;

  % Scale x labels to ms
  if isfield(plotParam,'inMiliseconds') && plotParam.inMiliseconds
    plotParam.xTickLabel = plotParam.xTickLabel * 1000;
  end
  
  % Units of the y axis
  if length(plotParam.yTickStep)==1
    plotParam.yTick = plotParam.frequencyBound(1):plotParam.yTickStep:plotParam.frequencyBound(2);
  else
    plotParam.yTick = plotParam.yTickStep;
  end
  
  parameters.plot = plotParam;
  %% ---------------------------  
 
  %% ---------------------------
  %  Set baseline for window norm.
  %% ---------------------------    
  if strcmpi(parameters.wavelet.normalization.baseline, 'window')
    parameters.wavelet.normalization.baselineTime = plotParam.timeBound; 
  end
  
  parameters.globalBaseline = ...
      regexpi(parameters.wavelet.normalization.baseline, '(trigger|window)');
  %% ---------------------------
  
  %% ---------------------------
  %  Set categorization function
  %% ---------------------------
  [parameters.categorization.categorizationFunction, ...
      parameters.categorization.categorizationBase] = ... 
      getCategorizeFunction(parameters.categorization.categorizationMode);
  %% ---------------------------
  
  
end
% =================================

% =================================
% Save functions
% =================================
% Save plot
function savePlot(figHandle, nameInfix, parameters)
  outputDirName  = getOutputDir(parameters);
  outputFileName = strjoin({parameters.output.fileName,nameInfix,'wavelet_power'},'_');
  saveas(figHandle, strcat(outputDirName,'fig/',outputFileName,'.fig'));
  print(figHandle, strcat(outputDirName,'png/',outputFileName,'.png'), '-dpng');
end

% Save result data
function saveData(resultStructure, parameters)
  outputDirName  = getOutputDir(parameters);
  outputFileName = strjoin({resultStructure.fileName,'wavelet_power'},'_');
  save(strcat(outputDirName,outputFileName,'.mat'), 'resultStructure', '-v7.3');
end
% =================================

% =================================
% Getter functions
% =================================
% Do we need overall average plot?
function answer = needOverall(parameters)
  answer = parameters.plot.overallAverage;
end

% Do we need categorize triggers?
function answer = needCategory(parameters)
  answer = false;
  if isfield(parameters,'categorization')
    answer = parameters.categorization.toCategorize; 
  end
end

% Do we need single trial plot?
function answer = needSingle(parameters)
  answer = parameters.plot.singlePlot;
end

% Is baseline global or individual?
function answer = isGlobalBaseline(parameters)
  answer = parameters.globalBaseline;
end

% Do we need neighbor markers?
function answer = needNeighbors(parameters)

  % We need neighbors if we use individual baseline for each trial
  answer = ~isGlobalBaseline(parameters);
  
  % Or, if we want to categorize by the cycle length or frequency
  answer = answer || ...
      (parameters.categorization.toCategorize&& ...
      (strcmpi(parameters.categorization.categorizationMode,'cycle_length')||...
       strcmpi(parameters.categorization.categorizationMode,'cycle_frequency')));
  
  % Check existence of neighbor channel
  if answer && ~isfield(parameters, 'neighbor')
    showError('Neighbor channels name hasn''t been given!');
  end
end

% Get the required labels if it's limited, else, return all label
function categoryLabels = getCategoryLabels(parameters, categoryVector)
    if isfield(parameters.categorization,'categorizationLimit')
      % If category display was limited, show only those
      categoryLabels = parameters.categorization.categorizationLimit;
    else
      % Else, show all valid (non zero) category
      categoryLabels = unique(categoryVector(categoryVector~=0));
    end
end
% =================================