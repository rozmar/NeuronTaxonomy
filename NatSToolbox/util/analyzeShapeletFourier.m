function analyzeShapeletFourier(inputStructure, parameters)

  %% ------------------------
  %  Collect the signal and 
  %  the from triggers from
  %  the input structure.
  %% ------------------------
  [signalVector, timeVector, SI] = getSignal(inputStructure, parameters.channel);
  triggerVector = getTrigger(inputStructure, parameters.channel);
  %% ------------------------

  %% ------------------------
  %  Filter raw signal
  %% ------------------------
  filteredSignal = doSignalFiltering(signalVector, parameters.filter, SI);
  %% ------------------------
  
  %% ------------------------
  %  Collect shapelets and 
  %  add padding to the ends.
  %% ------------------------
  shapeletMatrix = collectShapelets(triggerVector, timeVector, filteredSignal, getShapeletSize(SI, parameters.analysis));    
  shapeletMatrix = padBetween(shapeletMatrix, getPadsize(parameters.analysis), SI);
  %% ------------------------
  
  %% ------------------------
  %  Glue shapelets after
  %  each other.
  %% ------------------------
  [nShapelet, sShapelet] = size(shapeletMatrix);    
  gluedSignal = reshape(shapeletMatrix', 1, nShapelet*sShapelet);
  %% ------------------------
  
  %% ------------------------
  %  Do the FFT
  %% ------------------------
  [pxx, f] = periodogram(gluedSignal, [], parameters.analysis.nfft, round(1/SI));
  %% ------------------------
  
  %% ------------------------
  %  Plot periodogram
  %% ------------------------
  plotPeriodogram(pxx, f, parameters.plot)
  %% ------------------------  
  
end

%% ------------------------
%  Do the periodogram plot
%% ------------------------
function plotPeriodogram(power, frequency, parameters)
  figure;
  plot(frequency, power);
  xlim(parameters.xLimit);
end
%% ------------------------

%% ------------------------
%  Add padding to the sides 
%  of the shapelets
%% ------------------------
function shapeletMatrixOut = padBetween(shapeletMatrix, padSize, SI)
  
  padSize = round(padSize./SI);
  
  nSlice = size(shapeletMatrix,1);
  
  padLeft = zeros(nSlice, padSize);
  padRight = zeros(nSlice, padSize);
  
  shapeletMatrixOut = [ padLeft , shapeletMatrix , padRight ];
  
end
%% ------------------------

%% ------------------------
%  Do signal filtering
%% ------------------------
function filteredSignal = doSignalFiltering(rawVector, parameters, SI)
  parameters.Fs = round(1/SI);
    
  printStatus('Bandpass filtering', '*');
  fprintf('[%d, %d] Hz\n\n', parameters.filterBounds);
    
  filteredSignal = filterSignal(rawVector, parameters);
end
%% ------------------------

%% ------------------------
%  Get shapelet size
%% ------------------------
function shapeletSize = getShapeletSize(SI, parameters)
  triggerInterval = parameters.triggerRadius;
  
  if length(triggerInterval)==1
    triggerInterval = sort([-1,1]*triggerInterval);
  end
  
  shapeletSize = round(triggerInterval./SI);
end
%% ------------------------

%% ------------------------
%  Get padding size
%% ------------------------
function padSize = getPadsize(parameters)
  padSize = parameters.paddingSize;
end
%% ------------------------

%% ------------------------
%  Collects the shapelets
%  from the signal.
%% ------------------------
function shapeletMatrix = collectShapelets(triggerVector, timeVector, signalVector, shapeletSize)
  sliceIndexMatrix = findSliceIndices(triggerVector, timeVector, shapeletSize);
  shapeletMatrix = collectSlices(signalVector, sliceIndexMatrix);
end
%% ------------------------

%% ------------------------
%  Collects the triggers 
%  from the input structure
%% ------------------------
function triggerVector = getTrigger(inputStructure, parameters)
  triggerVector = inputStructure.(parameters.triggerName).times;
end
%% ------------------------

%% ------------------------
%  Collects the signal from
%  the input structure
%% ------------------------
function [signalVector, timeVector, SI] = getSignal(inputStructure, parameters)
  signalName   = parameters.signal;
  signalStr    = inputStructure.(signalName);
  signalVector = signalStr.values;
  timeVector   = signalStr.times;
  SI           = signalStr.interval;
end
%% ------------------------