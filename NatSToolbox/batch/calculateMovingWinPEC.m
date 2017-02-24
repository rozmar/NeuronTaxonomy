function [resultStructure, parameters] = calculateMovingWinPEC(inputStructure, parameters)

  %% --------------------------
  %  Validate and preprocess parameters
  %% --------------------------
  parameters = checkParameters(parameters);
  %% --------------------------

  %% --------------------------
  %  Collect cycle sections
  %  and events in cycles
  %% --------------------------
  eventVector   = getMarkersByField(inputStructure, parameters.channel.event.name); % Event vector (eg. spike)
  
  % Get the segments representing the cycles
  [cycleSegments,segmentLabel] = getCycles(inputStructure, parameters.channel); %  
  
  %  Sort events to cycles
  eventsInCycle = collectEventInSegment(eventVector, cycleSegments);
  %% --------------------------
  
  %% --------------------------
  %  Run the moving window MVL 
  %  calculation for each segment
  %% --------------------------  
  mvlVectorMW = calculateMvlAll(cycleSegments, segmentLabel, eventsInCycle, @calculateMvlMovingWindowSingle, parameters);
  
  mvlVectorRE = calculateMvlAll(cycleSegments, segmentLabel, eventsInCycle, @calculateMvlSingle, parameters);
  %% --------------------------  
  
  %% --------------------------
  %  Plot the smoothed MVL for
  %  each segment.
  %% --------------------------  
  for i = 1 : length(mvlVectorMW)
    thisSegmentMVLM = mvlVectorMW{i};
    thisSegmentMVLR = mvlVectorRE{i};
    figure;
    hold on;
    plot(1:length(thisSegmentMVLM), thisSegmentMVLM, 'b-', 'linewidth', 2);
    plot(1:length(thisSegmentMVLR), thisSegmentMVLR, 'r-', 'linewidth', 2);
    hold off;
  end
  %% --------------------------
  
  %% --------------------------
  %  Save results to structure
  %% --------------------------  
  resultStructure.mode          = 'single';
  resultStructure.fname         = inputStructure.title; % Save filename
  resultStructure.mvlMovingWin  = mvlVectorMW;          % Save moving win MVL
  resultStructure.mvlMovingReal = mvlVectorRE;          % Save normal MVL
  %% --------------------------
  
end

% This function calculates the moving averaged MVL-trace for each segment.
function mvlVector = calculateMvlAll(cycleSegments, segmentLabel, eventVector, calculatorFunction, parameters)

  segmentLabels = unique(segmentLabel);
  nSegment      = length(segmentLabels);
  mvlVector     = cell(nSegment,1);
  
  for i = 1 : nSegment
    thisSegmentLabel = segmentLabels(i);
    thisCyclesFlag   = (segmentLabel==thisSegmentLabel);
    thisCycleArray   = sliceSegment(cycleSegments, thisCyclesFlag);
    mvlVector{i}     = calculatorFunction(thisCycleArray, eventVector(thisCyclesFlag), parameters);  
  end
end

% This function calculates the moving averaged MVL-trace for a single
% segment. It expects in parameter the cycles only for the same segment.
function mvlValue = calculateMvlMovingWindowSingle(thisCycleArray, eventVector, parameters)
  
  segmentLength = length(thisCycleArray.start);
  mvlValue      = zeros(segmentLength,1);
  winSize       = parameters.analysis.windowSize;
  winHalf       = floor(winSize/2);
  binNumber     = parameters.analysis.binNumber;
  
  for i = 1 : segmentLength
    windowLeft    = max(1, i-winHalf);
    windowRight   = min(segmentLength, i+winHalf);
    windowIndices = windowLeft:windowRight;
    cycleInWindow = sliceSegment(thisCycleArray, windowIndices);
    binnedMatrix  = ...
        calculateHistogramInSegment(cycleInWindow, eventVector(windowIndices), binNumber);
    mvlValue(i)   = abs(calculateMeanvector(mean(binnedMatrix,1)'));
  end
end

% This function calculates the real MVL-trace for a single
% segment. It expects in parameter the cycles only for the same segment.
function mvlValue = calculateMvlSingle(thisCycleArray, eventVector, parameters)
  
  segmentLength = length(thisCycleArray.start);
  binNumber     = parameters.analysis.binNumber;
  mvlValue      = zeros(segmentLength,1);
  
  for i = 1 : segmentLength
    thisCycle     = sliceSegment(thisCycleArray, i);
    binnedMatrix  = ...
          calculateHistogramInSegment(thisCycle, eventVector(i), binNumber);
    mvlValue(i)   = abs(calculateMeanvector(mean(binnedMatrix,1)'));
  end
  
end

% This function checks pararmeter structure.
function parameters = checkParameters(oldParameters) 
  parameters = oldParameters;
  
  %% ------------------------------
  %  Check bin size. Size of the
  %  bin have to be whole fraction
  %  of the cycle (360).
  %% ------------------------------
  analysisParameters = parameters.analysis;
  
  analysisParameters.binSize  = round(360/analysisParameters.binNumber);
  if mod(360,analysisParameters.binNumber)~=0
    analysisParameters.binNumber = 360/analysisParameters.binSize;
  end
  
  parameters.plot.binSize = analysisParameters.binSize;
  %% ------------------------------
  
  %% ------------------------------
  %  Create palette
  %% ------------------------------
  parameters.plot.palette = getPaletteByName(parameters.plot.paletteName);
  %% ------------------------------
  
  parameters.analysis = analysisParameters;
end