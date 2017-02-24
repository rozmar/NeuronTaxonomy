function [resultStructure,parameters] = calculateSectionWavelet(inputStructure, parameters)

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
  if ~isfield(parameters.wavelet, 'timeLimits')
    parameters.wavelet.timeLimits   = getTimeLimits(signalStructure);
  end
  sliceVector = signalStructure.values;
  %% ------------------------------
        
  %% ------------------------------
  %  Create time axis
  %% ------------------------------  
  [timeVector, displayInterval, baselineInterval] = ...
      createTimeVector(parameters, getSI(signalStructure));
  %% ------------------------------
    
  %% ------------------------------
  %  Tidy up memory
  %% ------------------------------
  clear signalStructure;
  %% ------------------------------
    
  %% ------------------------------
  %  Perform wavelet TFD
  %% ------------------------------
  [powerMatrix, frequencyVector] = calculateTFDPower(sliceVector, parameters.wavelet);
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
  resultStructure.displayInterval  = displayInterval;
  resultStructure.baselineInterval = baselineInterval;
  resultStructure.sliceVector      = sliceVector;
  resultStructure.powerMatrix      = powerMatrix;
    
  %% ------------------------------
  %  Normalize and plot overall
  %  average power spectrogram.
  %% ------------------------------
  resultStructure = showSpectrogram(resultStructure, parameters);
  %% ------------------------------  
 
  % Save data to file
  if isSave(parameters)
    saveData(resultStructure, parameters);
  end  
  
  
end

% This function performs the spectrogram display: normalize with the given
% method then show the plot. 
function resultOut = showSpectrogram(resultStructure, parameters)
  
  resultOut        = resultStructure;
  timeVector       = resultStructure.timeVector;
  frequencyVector  = resultStructure.frequencyVector;
  baselineInterval = resultStructure.baselineInterval;
  displayInterval  = resultStructure.displayInterval;
  sliceVector      = resultStructure.sliceVector;
  powerMatrix      = resultStructure.powerMatrix;   
    
  parameters.plot.title = ...
      createSpectrogramTitle(resultStructure.fileName, parameters);
  
  normalizedPower = ...
      normalizeSpectrogramGlobal(powerMatrix, displayInterval, baselineInterval, parameters);
    
  figure;
  displaySpectrogram(timeVector(displayInterval), frequencyVector, normalizedPower, sliceVector(displayInterval), parameters.plot);
    
  if isSave(parameters)
    parameters.output.fileName = resultStructure.fileName;
    savePlot(gcf, 'average', parameters)
  end
    
  resultOut.normPower = normalizedPower;

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
    plotWaveform(timeVector, sliceMatrix', parameters);
  end
    
end

% Creates plot title from parameters and filename
function finalTitle = createSpectrogramTitle(fileName, parameters)
  
  normalizationType = parameters.wavelet.normalization.type;   %type of normalization
  fileNameEscaped   = strrep(fileName,'_','\_');               %name of file
    
  finalTitle = strjoin({fileNameEscaped, '(', normalizationType, 'norm.',')'}, ' ');
end

% This function creates the time vector for spectrogram 
% and define the time interval to show on plot.
function [timeVector,displayInterval,baselineInterval] = createTimeVector(parameters, SI)

  timeBound = parameters.plot.timeBound;
  radius    = parameters.wavelet.timeLimits;
  
  timeVector      = linspace(radius(1), radius(2), round(diff(radius)/SI) + 1);
  displayInterval = (timeBound(1)<=timeVector&timeVector<=timeBound(2));
  
  baseTime         = parameters.wavelet.normalization.baselineTime;
  baselineInterval = (baseTime(1)<=timeVector&timeVector<=baseTime(2));

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
  
  parameters.globalBaseline = true;
  %% ---------------------------
  
end
% =================================

%% =================================
% Save functions
%% =================================
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
%% =================================

%% =================================
% Getter functions
%% =================================
% Get the time bounds of the whole recording
function timeLimits = getTimeLimits(signalStructure)
  timeLimits = [signalStructure.times(1),signalStructure.times(end)];
end
%% =================================