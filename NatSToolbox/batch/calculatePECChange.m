function [resultStructure, parameters] = calculatePECChange(inputStructure, parameters)

  %% --------------------------
  %  Validate and preprocess parameters
  %% --------------------------
  parameters = checkParameters(parameters);
  %% --------------------------
  
  %% --------------------------
  %  Collect segments, cycles,
  %  divide cycles to segments,
  %  divide events to cycles
  %% --------------------------
  % Event vector (eg. spike)
  eventVector = getMarkersByField(inputStructure, parameters.channel.event.name);
  % Get the segments representing the cycles
  [cycleSegments,segmentLabel] = getCycles(inputStructure, parameters.channel);
  % Get the cycle markers
  cycleMarkerVector = getMarkersByField(inputStructure, parameters.channel.cycle.name);
  % Get segment structure
  segmentStructure = getSingleSegment(inputStructure, parameters.channel.segment);
  % Sort events to cycles
  eventPerCycle = collectEventInSegment(eventVector, cycleSegments);
  % Calculate binned histogram for each cycle
  binnedMatrix = calculateHistogramInSegment(cycleSegments, eventPerCycle, parameters.analysis.binNumber);
  % Get mean vectors for each cycle  
  meanVectors = calculateMvAll(cycleSegments, segmentLabel, eventPerCycle, @calculateMvSingle, parameters);
  % Get the slices for all segment
  tempSignalStructure = inputStructure.(parameters.channel.signal.name);
  sliceArray = collectSlicesOfSegments(segmentStructure, tempSignalStructure);
  tempSignalStructure.values = tempSignalStructure.times;
  timeSliceArray = collectSlicesOfSegments(segmentStructure, tempSignalStructure);
  clear tempSignalStructure;
  %% --------------------------  
  
  %% ----------------------------------
  %  Print global statistics
  %% ----------------------------------
  fprintf('File:\t\t%s\n', inputStructure.title);
  fprintf('# of cycles:\t\t%d\n', length(eventPerCycle));
  fprintf('# of segments:\t\t%d\n', length(unique(segmentLabel)));
  %% ----------------------------------
  
  %% ----------------------------------
  %  Store results
  %% ----------------------------------
  resultStructure.mode = 'single';
  resultStructure.SI   = getSI(inputStructure.(parameters.channel.signal.name));
  resultStructure.eventPerCycle     = eventPerCycle;
  resultStructure.binnedEventMatrix = binnedMatrix;
  resultStructure.meanVector        = meanVectors;
  resultStructure.segmentLabel      = segmentLabel;
  resultStructure.segmentSlice      = sliceArray;
  resultStructure.segmentSliceTime  = timeSliceArray;
  resultStructure.cycleMarker       = cycleMarkerVector;
  %% ----------------------------------

  %% ----------------------------------
  %  Save analysis result
  %% ----------------------------------
%   if isSave(parameters)
%     outDir = parameters.output.dir;
%     outName = strjoin({inputStructure.title, 'mvd_circular_distribution_heatmap'},'_');
%     saveas(vectorFigure, strcat(outDir,outName,'.fig'));
%     print(vectorFigure, strcat(outDir,'png/',outName,'.png'),'-dpng');
%   end
  %% ----------------------------------
  
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
  
  if mod(360,analysisParameters.binNumber)~=0
    binSize = round(360/analysisParameters.binNumber);
    analysisParameters.binNumber = 360/binSize;
  end
  %% ------------------------------
  
  parameters.analysis = analysisParameters;
end

% This function calculates the moving averaged MVL-trace for each segment.
function mvlVector = calculateMvAll(cycleSegments, segmentLabel, eventVector, calculatorFunction, parameters)

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

% This function calculates the real MVL-trace for a single segment.
% It expects in parameter the cycles only for the same segment.
function mvlValue = calculateMvSingle(thisCycleArray, eventVector, parameters)
  
  segmentLength = length(thisCycleArray.start);
  binNumber     = parameters.analysis.binNumber;
  mvlValue      = zeros(segmentLength,1);
  
  for i = 1 : segmentLength
    thisCycle     = sliceSegment(thisCycleArray, i);
    binnedMatrix  = ...
          calculateHistogramInSegment(thisCycle, eventVector(i), binNumber);
    mvlValue(i)   = calculateMeanvector(mean(binnedMatrix,1)');
  end
  
end