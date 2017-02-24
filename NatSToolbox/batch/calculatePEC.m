function [resultStructure, parameters] = calculatePEC(inputStructure, parameters)
    
  %% --------------------------
  %  Validate and preprocess parameters
  %% --------------------------
  parameters = checkParameters(parameters);
  %% --------------------------

  %% --------------------------
  %  Collect cycle sections
  %  and events in cycles
  %% --------------------------
  % Get the events which we want to count
  eventVector   = getMarkersByField(inputStructure, parameters.channel.eventName);
  
  % Get the segments representing the cycles
  cycleSegments = getCycles(inputStructure, parameters.channel);
  %% --------------------------
  
  %% --------------------------
  %  Sort events to cycles
  %% --------------------------
  eventsInCycle = collectEventInSegment(eventVector, cycleSegments);
  %% --------------------------
  
  %% --------------------------
  %  Count events in each bin
  %  and the length of cycle
  %% --------------------------
  [binnedMatrix, cycleLengthVector] = calculateHistogramInSegment(cycleSegments, eventsInCycle, parameters.analysis.binNumber);
  %% --------------------------
  
  %% --------------------------
  %  Calculate circular statistic
  %% --------------------------
  meanVectorVector = calculateMeanVectors(binnedMatrix);
  %% --------------------------
  
  %% --------------------------
  %  Put results to output structure
  %% --------------------------
  %  TODO with categorys
  resultStructure.mode = 'single';                      % Single cell's data
  resultStructure.fname = inputStructure.title;         % Save filename later
  resultStructure.cycleSegments = cycleSegments;        % Segments representing cycles
  resultStructure.cycleEvents = eventsInCycle;          % Events in each cycle
  resultStructure.cycleEventsBinned = binnedMatrix;     % Events in each cycle relative to cycle start
  resultStructure.cycleLength = cycleLengthVector;      % Length of each cycle
  resultStructure.meanVectorByCycle = meanVectorVector; % Mean vector for each cycle
  resultStructure.countHistogram  = sum(binnedMatrix,1);  % Sum of events
  resultStructure.meanHistogram = mean(binnedMatrix,1); % Mean event number
  
  resultStructure.cumulativeMean = calculateMeanvector(mean(binnedMatrix,1)');
  %% --------------------------
  
  %% --------------------------
  %  Print the statistic value
  %% --------------------------
  printCircularStatistic(resultStructure);
  %% --------------------------
  
  %% --------------------------
  %  Save output result
  %% --------------------------
  if isSave(parameters)
    outputFilename = strjoin({inputStructure.title,lower(parameters.channel.eventTitle),lower(parameters.channel.sectionName),'phase_coupling'},'_');
    outputDirname  = parameters.output.dir;
    save(strcat(outputDirname, outputFilename,'.mat'), 'resultStructure');
  end
  %% --------------------------
  
end

% Get the cycles from the input structure
function cycleSegments = getCycles(inputStructure, parameters)

  % Get all cycle markers during the recording.
  % These are the cycle start and -end markers
  cycleMarkerVector = getMarkersByField(inputStructure, parameters.cycleMarkerName); 

  try 
      
    % Collect the segments which we want to divide into cycles
    segmentStructure = getSingleSegment(inputStructure, parameters);
  catch ex
      
    warning( ex.message );
    segmentStructure = createSegmentFromMarker(cycleMarkerVector, parameters);
  end

  cycleMarkerBySegment = collectEventInSegment(cycleMarkerVector, segmentStructure);
  % Remove segments where we can't find cycle marker
  removeEmptySegment;
  
  % Group cycle markers to the corresponding segment
  
    function removeEmptySegment

      % Find segments without event in it
      emptySegmentFlag = cellfun(@isempty, cycleMarkerBySegment);
      % or only with 1 event (it can't be a cycle)
      emptySegmentFlag = emptySegmentFlag|(cellfun(@length, cycleMarkerBySegment)<2);
  
      % Retain non-empty segments
      cycleMarkerBySegment = cycleMarkerBySegment(~emptySegmentFlag);
    end   

  
  % Collect cycles from collected cycle markers and remove empty segments
  cycleSegments = splitSegmentsToCycles(cycleMarkerBySegment);
end

% Create segment from consecutive markers
function cyclesSegmentStructure = splitSegmentsToCycles(segmentEventArray)
  cyclesMatrix = [];
  for i = 1 : length(segmentEventArray)
    thisSegmentsMarkers = segmentEventArray{i};
    thisSegmentsMarkers = [thisSegmentsMarkers(1:end-1) thisSegmentsMarkers(2:end)];
    cyclesMatrix        = cat(1,cyclesMatrix, thisSegmentsMarkers);
  end
  
  cyclesSegmentStructure = struct('start',cyclesMatrix(:,1),'end',cyclesMatrix(:,2),'title','Cycle','color',[]);
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
  
  if isfield(analysisParameters,'categorizationMode')
    analysisParameters.categorizationFunction = getCategorizeFunction(analysisParameters.categorizationMode);
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