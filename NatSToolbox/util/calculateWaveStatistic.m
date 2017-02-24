% calculateWaveStatistic calculates the statistics 
function [slopeMatrix,lengthMatrix,amplitudeMatrix] = calculateWaveStatistic(waveformArray, filteredArray, SI, parameters)

  %% -----------------------
  %  Initialization
  %% -----------------------
  nWave           = length(waveformArray);
  slopeMatrix     = zeros(nWave, 2);
  lengthMatrix    = zeros(nWave, 1);
  amplitudeMatrix = zeros(nWave, 1);
  %% -----------------------
  
  %% -----------------------
  %  Process each wave
  %% -----------------------
  for i = 1 : nWave
    
    %% -----------------------
    %  Get current slices
    %% -----------------------
    thisRaw  = waveformArray{i};
    thisFilt = filteredArray{i};
    %% -----------------------
    
    %% -----------------------
    %  Create time vector
    %% -----------------------
    [timeVector, lengthMatrix(i)] = createTimeVector(thisRaw, SI);
    %% -----------------------
    
    %% -----------------------
    %  Calculate wave amplitude
    %% -----------------------
    amplitudeMatrix(i) = calculateAmplitude(thisFilt);
    %% -----------------------
    
    %% -----------------------
    %  Find the extreme value of the wave
    %% -----------------------
    extremeValue = findExtremeValue(thisFilt);
    %% -----------------------
    
    %% -----------------------
    %  Calculate the slope
    %% -----------------------
    slopeMatrix(i,:) = findFittingLines(timeVector, thisRaw, extremeValue);
    %% -----------------------
    
    %% -----------------------
    % Plot individual waveform with slope
    %% -----------------------
    if debugPlot(parameters)
      plotSliceWithSlope(timeVector, thisRaw, thisFilt, extremeValue, slopeMatrix(i,:));
    end
    %% -----------------------
    
  end
  %% -----------------------
end

function plotSliceWithSlope(timeVector, rawSlice, filtSlice, extremeValue, slope)
      hold on;
      
      % Plot slices
      plot(timeVector, rawSlice, 'b-');
      plot(timeVector, filtSlice, 'g-');
      
      % Plot extreme value
      plot(timeVector(extremeValue), rawSlice(extremeValue), 'go');
      
      % Plot slopes
      plotLineWithEquation(timeVector(1:extremeValue), slope);
      
      hold off;
end

function plotLineWithEquation(timeVector, slope)
  plot(timeVector, slope(2) + slope(1)*timeVector, 'r-');
end

function slopeVector = findFittingLines(timeVector, sliceVector, extremeValue)

    % Find the different parts of the slice
    firstPartIndex  = (1:extremeValue);
    secondPartIndex = (extremeValue:length(sliceVector));
    
    % Fit line to both parts
    firstLine  = polyfit(timeVector(firstPartIndex), sliceVector(firstPartIndex), 1);
    secondLine = polyfit(timeVector(secondPartIndex), sliceVector(secondPartIndex), 1);
    
    % Get the slope from equation
    slopeVector = [firstLine(1) secondLine(1)];
end

function extremeValue = findExtremeValue(sliceVector)

    % Find the polarity of the signal
    polarity = findWavePolarity(sliceVector);
    
    % Find the position of extreme value
    if polarity>0
      [~,extremeValue] = max(sliceVector);
    else
      [~,extremeValue] = min(sliceVector);        
    end
end

function polarity = findWavePolarity(sliceVector)
  meanOfEnds   = mean(sliceVector([1,end]));
  meanOfSignal = mean(sliceVector);
  
  if meanOfSignal>meanOfEnds
    polarity = 1;
  else
    polarity = -1;
  end
end

function amplitude = calculateAmplitude(sliceVector)
  amplitude = abs(max(sliceVector) - min(sliceVector));
end

function [timeVector, waveLength] = createTimeVector(sliceVector, SI)
  % Calculate wavelength
  sliceLength = length(sliceVector);    
  waveLength  = sliceLength*SI;
    
  % Create time vector
  timeVector = (1:sliceLength)';
  timeVector = timeVector.*SI;
end

function answer = debugPlot(parameters)
  answer = isfield(parameters.plot, 'debug')&&parameters.plot.debug;
end