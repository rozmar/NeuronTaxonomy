function [resultStructure,parameters] = calculatePeritriggerEvent(inputStructure, parameters)
  
  %% --------------------------
  %  Check parameters
  %% --------------------------
  parameters = checkParameters(parameters);
  
  % Cut the recording
  if isCut(parameters)
    inputStructure = cutRecording(inputStructure, parameters.cutInterval);
  end 
  %% --------------------------

  %% --------------------------
  %  Collect triggers
  %% --------------------------
  fprintf('Collect triggers...\n');
  [triggerVector,positionVector] = collectTriggers(inputStructure, parameters.channel); %#ok<NASGU>
  %% --------------------------

  %% --------------------------
  %  Categorize triggers
  %% --------------------------
  if needCategory(parameters)
    categoryBaseVector = eval(parameters.categorization.categorizationBase);
    categorizationFunc = parameters.categorization.categorizationFunction;
    categoryVector     = categorizationFunc([], categoryBaseVector, parameters.categorization);
  else
    categoryVector     = ones(size(triggerVector));
  end  
  %% --------------------------  
  
  %% --------------------------
  %  Collect events
  %% --------------------------
  eventVector = getMarkersByField(inputStructure, parameters.channel.event.name);
  %% --------------------------
  
  %% --------------------------
  %  Modify triggers
  %% --------------------------  
  if parameters.modification.toModify
    modFun = parameters.modification.modificationFunction;
    triggerVector = modFun(triggerVector, inputStructure, parameters.modification);
    
    removedTriggers = isnan(triggerVector);
    categoryVector(removedTriggers) = [];
    triggerVector(removedTriggers) = [];
    
    fprintf('Modify triggers.\n');
    fprintf('After modification, %d trigger remained.\n', length(triggerVector));
  end
  %% --------------------------  
  
  %% --------------------------
  % Collect events around trigger
  %% --------------------------
  peritriggerEventArray = collectPeritriggerEvents(triggerVector, eventVector, parameters.analysis.radius);
  %% --------------------------
  
  %% --------------------------
  %  Calculate histogram values
  %  (count, mean, sem)
  %% --------------------------
  %[countHistogramGlobal,meanHistogramGlobal] = calculateMeanHistogram(eventArray, parameters);
  
  %if needCategory(parameters)
    [countHistogramCategory,meanHistogramCategory] = calculateMeanHistogramByCategory(peritriggerEventArray, parameters.analysis, categoryVector);
  %end
  
  if isSelfTrigger(parameters)
    countHistogramCategory = removeZeroShift(countHistogramCategory, parameters);
    meanHistogramCategory  = removeZeroShift(meanHistogramCategory, parameters);
  end
  %% --------------------------
  
  %% --------------------------
  %  Put result to output structure
  %% --------------------------
  if size(countHistogramCategory,1)==0
    resultStructure = [];
    return;
  end
  
  resultStructure.mode              = 'single';
  resultStructure.meanCHistogram    = countHistogramCategory; % cumulative event count
  resultStructure.meanMHistogram    = meanHistogramCategory;  % mean event count
  resultStructure.meanFHistogram    = meanHistogramCategory./parameters.analysis.binSize; % mean event frequency
  resultStructure.meanPHistogram    = meanHistogramCategory./length(eventVector); % mean probability of event in bins
  resultStructure.peritriggerEvents = peritriggerEventArray;
  %% --------------------------
    
  %% ---------------------------
  %  Save data if needed
  %% ---------------------------
  if isSave(parameters)
    fileName = strjoin({inputStructure.title,lower(parameters.channel.event.title),'around',lower(parameters.channel.trigger.title)},'_');
    dataPath = strcat(parameters.output.dir,'/',fileName,'.mat');
    save(dataPath, 'resultStructure');
  end  
  %% ---------------------------  

end



% This function calculates the mean and sem 
% histograms of events for each trigger-category
function [countHistogramMatrix,meanHistogramMatrix,semHistogramMatrix] = calculateMeanHistogramByCategory(peritriggerEventArray, parameters, categoryVector)

  %% ----------------------------
  %  Category properties
  %% ----------------------------
  categoryLabels   = unique(categoryVector(categoryVector~=0)); % get assigned categories
  numberOfCategory = length(categoryLabels); % count categories
  %% ----------------------------
  
  %% ----------------------------
  %  Initialize output values
  %  One row - one category
  %% ----------------------------
  countHistogramMatrix = zeros(numberOfCategory, parameters.binNumber);
  meanHistogramMatrix  = zeros(numberOfCategory, parameters.binNumber);
  semHistogramMatrix   = zeros(numberOfCategory, parameters.binNumber);
  %% ----------------------------
  
  %% ----------------------------
  %  Accumulate categories
  %% ----------------------------
  for i = 1 : numberOfCategory
      
    thisCategory = (categoryVector==categoryLabels(i)); % flag for this cat.
    thisEvents   = peritriggerEventArray(thisCategory); % elements in this cat.
    
    [countHistogramMatrix(i,:),meanHistogramMatrix(i,:),semHistogramMatrix(i,:)] = calculateMeanHistogram(thisEvents, parameters);
  end
  %% ----------------------------
  
end

% This function calculates the mean and sem 
% histograms of a given set of peritrigger event
function [countHistogram,meanHistogram,sdHistogram] = calculateMeanHistogram(eventArray, parameters)
  
  %% ----------------------------
  % Initialization
  %% ----------------------------
  binEdges = getBinEdges(parameters);
  % Create histogram for each trigger
  histogramMatrix = zeros(length(eventArray), length(binEdges));
  %% ----------------------------
  
  %% ----------------------------
  % Count elements per bin for a trigger
  %% ----------------------------
  for i = 1 : length(eventArray)
    histogramMatrix(i,:) = histc(eventArray{i}, binEdges);
  end
  %% ----------------------------
  
  %% ----------------------------
  %  Accumulate values
  %% ----------------------------
  histogramMatrix = histogramMatrix(:,1:end-1);
  countHistogram = sum(histogramMatrix,1);
  meanHistogram  = mean(histogramMatrix,1);
  sdHistogram    = std(histogramMatrix,0,1);
  %% ----------------------------
  
end

function newBinnedMatrix = removeZeroShift(binnedMatrix, parameters)
  newBinnedMatrix = binnedMatrix;
  binEdges        = getBinEdges(parameters.analysis);
  indexOfCenter   = find(binEdges>=0,1,'first');
  
  newBinnedMatrix(:,indexOfCenter) = 0;
end

% This function create histogram bin edges 
% from analysis range and number of bins
function binEdges = getBinEdges(parameters)
  binEdges = parameters.radius(1):parameters.binSize:parameters.radius(2);
end

% This function checks pararmeter structure.
function parameters = checkParameters(oldParameters) 
  parameters = oldParameters;
  
  %% ------------------------------
  %  Check radius
  %% ------------------------------
  analysisParameters = parameters.analysis;
  
  analysisParameters.radius  = mirrorInterval(analysisParameters.radius);
  analysisParameters.binSize = diff(analysisParameters.radius)/analysisParameters.binNumber;
  
  parameters.analysis = analysisParameters;
  %% ------------------------------
  
  %% ---------------------------
  %  Set categorization function
  %% ---------------------------  
  [parameters.categorization.categorizationFunction, ...
      parameters.categorization.categorizationBase] = ... 
      getCategorizeFunction(parameters.categorization.categorizationMode);  
  %% ---------------------------
  
  %% ---------------------------
  %  Get modification function
  %% ---------------------------
  [parameters.modification.modificationFunction] = ...
      getModificationFunction(parameters.modification.modificationType);
  %% ---------------------------
  
  %% ------------------------------
  %  Set plot parameters
  %% ------------------------------
  if ~isfield(parameters.plot, 'paletteName')
    parameters.plot.paletteName = 'DEFAULT';
  end
  parameters.plot.palette = getPaletteByName(parameters.plot.paletteName);
  parameters.plot.binSize = analysisParameters.binSize;
  %% ------------------------------
  
  %% ------------------------------
  %  Check channel parameters
  %% ------------------------------  
  if ~isfield(parameters.channel, 'event')
    showError('Event parameter wasn''t given!');
  end
  
  if ~isfield(parameters.channel.event, 'name')
    showError('Event name wasn''t given!'); 
  end
  %% ------------------------------
end

% Determine if we used one of the events as trigger
function answer = isSelfTrigger(parameters)

  answer = false;

  % If there is no trigger modification, can't be self trigger
  if ~isfield(parameters,'modification')||~parameters.modification.toModify
    return;
  end
  
  modificationParam = parameters.modification;
  
  % If we aligned to a nearest event
  if strcmpi(modificationParam.modificationType,'align_nearest')||strcmpi(modificationParam.modificationType,'align_peak_nearest')
    if strcmpi(modificationParam.eventName,modificationParam.channel.event.name)
      answer = true; 
    end
  end
  
  return;
end

function answer = isCut(parameters)
  answer = isfield(parameters,'isCut')&&parameters.isCut;
end