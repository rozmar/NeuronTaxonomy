function aggregateWavelet(resultStructArray, parameters)

  %% -----------------------------
  %  Initial check: we don't have
  %  to aggregate single cell.
  %% -----------------------------
  nCell = length(resultStructArray);

  if nCell==1
    return; 
  end
  
  % Convert to structure array
  resultStructArray = [resultStructArray{:}];
  %% -----------------------------
  
  %% ---------------------------
  %  Initialization
  %% ---------------------------
  frequencyVector  = resultStructArray(1).frequencyVector;
  commonTimeVector = createCommonTime(resultStructArray, parameters);
  %% ---------------------------
  
  %% ---------------------------
  %  Calculate averages of the 
  %  average matrices.
  %% ---------------------------
  averageMatrix    = calculateGlobalAverage(resultStructArray, commonTimeVector, parameters);
  averagedWaveform = averageDifferentLength(resultStructArray, commonTimeVector);
  %% ---------------------------
  
  %% ---------------------------
  %  Save accumulated data
  %% ---------------------------  
  if isSave(parameters)
    saveData(averageMatrix, parameters);
  end
  %% ---------------------------  
  
  %% ---------------------------
  %  Plot global average
  %% ---------------------------
  if needOverall(parameters)
    parameters.plot.titleSuffix = 'overall';
    plotAvergedSpectrogram(commonTimeVector, frequencyVector, averageMatrix, averagedWaveform, parameters);
  end
  %% ---------------------------
  
  %% ---------------------------
  %  Accumulate and plot by category
  %% ---------------------------  
  if needCategory(parameters)
    
    % Remove specific color limit
    if isfield(parameters.categorization,'categoryColorLimit')
      parameters.plot.colorLimit = parameters.categorization.categoryColorLimit;
    else
      parameters.plot.colorLimit = [0,1];
    end
    
    % Loop through each category
    categoryStructure(1:nCell) = struct('normPower',[],'displayTimeVector',[],'sliceMatrix',[]);
    for c = 1 : getNumberOfCategory(parameters)
      
      for f = 1 : nCell
        % Get average of the current category
        categoryStructure(f).normPower = resultStructArray(f).categoryAverageNorm{c};
        % Get display time for this cell
        displayInterval = resultStructArray(f).displayInterval;
        categoryStructure(f).displayTimeVector = resultStructArray(f).timeVector(displayInterval);
        categoryStructure(f).sliceMatrix = resultStructArray(f).categoryAverageSlice{c};
      end
      
      averageMatrix    = calculateGlobalAverage(categoryStructure, commonTimeVector, parameters);
      averagedWaveform = averageDifferentLength(resultStructArray, commonTimeVector);
      parameters.plot.titleSuffix = sprintf('Category %d', c);
      
      plotAvergedSpectrogram(commonTimeVector, frequencyVector, averageMatrix, averagedWaveform, parameters)
           
    end  
  end
  %% --------------------------- 
  
  
  
end

% Plot averaged spectrogram
function plotAvergedSpectrogram(timeVector, frequencyVector, averageMatrix, averagedWaveform, parameters)
 
  plotParameter       = parameters.plot;
  conditionToString   = toStringAllCondition(parameters.channel);
  plotParameter.title = strcat('Averaged wavelet ',conditionToString, plotParameter.titleSuffix);
  
  figure;
  plotPowerSpectrum(timeVector, frequencyVector, averageMatrix, plotParameter);
  
  if needWaveform(plotParameter)
    hold on;
    plotWaveform(timeVector, averagedWaveform, plotParameter);
    hold off;
  end
  
  if isSave(parameters)
    savePlot(gcf, plotParameter.titleSuffix, parameters);
  end
end

% This function creates the time vector of the averaged matrix.
function commonTime = createCommonTime(resultStructArray, parameters)
  % Count how many sample points are in the time vectors
  sPointVector = cellfun(@sum,{resultStructArray(:).displayInterval}); 
  % Get interval ends of the interval shown
  timeBound    = parameters.plot.timeBound;
  % Create new time vector with the best sampling rate
  commonTime   = linspace(timeBound(1), timeBound(end), max(sPointVector));
end

% Calculates the average of the averaged normalized matrices 
function averageMatrix = calculateGlobalAverage(resultArray, commonTime, parameters)
  
  % If we use decibel normalized power
  % convert it to linear scale from
  if isDecibel(parameters)
    resultArray = iterateStructure(resultArray, 'normPower', @convertFromDecibel);
  end
  
  % Resample and average matrices
  averageMatrix = calculateResampledAverage(resultArray, commonTime);
  
  % If we used decibel normalization, 
  % convert the result to decibel
  if isDecibel(parameters)
    averageMatrix = convertToDecibel(averageMatrix);
  end  
  
end

%% ===================================
%  Saving functions
%% ===================================
% Save result data
function saveData(averageMatrix, parameters) %#ok<INUSL>
  outputDirName  = getOutputDir(parameters);
  save(strcat(outputDirName,'average_wavelet_power.mat'), 'averageMatrix', '-v7.3');
end

% Save plot
function savePlot(figHandle, namePost, parameters)
  outputDirName  = getOutputDir(parameters);
  outputFileName = strjoin({'average_wavelet',namePost},'_');
  saveas(figHandle, strcat(outputDirName,'fig/',outputFileName,'.fig'));
  print(figHandle, strcat(outputDirName,'png/',outputFileName,'.png'), '-dpng');
end
%% ===================================

%% ===================================
%  Getter functions
%% ===================================
% Do we need overall average plot?
function answer = needOverall(parameters)
  answer = parameters.plot.overallAverage;
end

% Do we need waveform on the spectrogram?
function answer = needWaveform(parameters)
  answer = isfield(parameters, 'plotWaveform') && parameters.plotWaveform;
end

% Do we need categorize triggers?
function answer = needCategory(parameters)
  answer = false;
  if isfield(parameters,'categorization')
    answer = parameters.categorization.toCategorize; 
  end
end

% Do we use decibel scale?
function answer = isDecibel(parameters)
  answer = strcmpi(parameters.wavelet.normalization.type,'decibel');
end

% Get the number of category to handle
function nCategory = getNumberOfCategory(parameters)
  nCategory = length(parameters.categorization.categorizationLimit);
end
%% ===================================