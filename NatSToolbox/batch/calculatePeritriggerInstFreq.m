function [resultStructure,parameters] = calculatePeritriggerInstFreq(inputStructure, parameters)

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
  %  Collect events
  %% --------------------------
  eventVector = getMarkersByField(inputStructure, parameters.channel.event.name);
  %% --------------------------
  
  %% --------------------------
  % Collect events around trigger
  %% --------------------------
  peritriggerEventArray = collectPeritriggerEvents(triggerVector, eventVector, parameters.analysis.collectRadius);
  %% --------------------------  
  
  %% --------------------------
  %  Calculate instantaneous freq.
  %% --------------------------
  timeVector = createTimeVector(parameters, 1e-5);  % time vector for interpolation
  instFreqMatrix = zeros(length(peritriggerEventArray), length(timeVector)); % initialize result matrix
  
  % Loop through all sweep (trigger)
  for i = 1 : length(peritriggerEventArray)
    instFreqMatrix(i,:) = calculateInstantaneousFrequencyWaveform(timeVector, peritriggerEventArray{i})';
  end
  instFreqMatrix((sum(isnan(instFreqMatrix),2)>0),:) = [];
  
  if size(instFreqMatrix,1)==0
    message = 'No sweep with instantaneous firing frequency!';
    throw(MException('BatchProcess:EmptyResult',message));
  end
  %% --------------------------

  %% --------------------------
  %  Store results in structure
  %% --------------------------
  resultStructure.mode = 'single';
  resultStructure.timeVector          = timeVector;
  resultStructure.instFrequencyMatrix = instFreqMatrix;
  %% --------------------------
 
  %% --------------------------
  %  Save results if needed
  %% --------------------------
  if isSave(parameters)
    fileName = strjoin({inputStructure.title,'instant_frequency_around',lower(parameters.channel.trigger.title)},'_');
    dataPath = strcat(getOutputDir(parameters),'/',fileName,'.mat');
    save(dataPath, 'resultStructure');
  end  
  %% --------------------------
  
end

% This function creates the time vector for instantaneous frequency
% averaging.
function timeVector = createTimeVector(parameters, SI)

  radius     = parameters.analysis.collectRadius; 
  timeVector = linspace(radius(1), radius(2), round(diff(radius)/SI) + 1);
 
end

% This function checks pararmeter structure.
function parameters = checkParameters(oldParameters) 
  parameters = oldParameters;
  
  %% ------------------------------
  %  Check radius
  %% ------------------------------
  analysisParameters = parameters.analysis;
  
  analysisParameters.collectRadius  = mirrorInterval(analysisParameters.collectRadius);
  
  parameters.analysis = analysisParameters;
  %% ------------------------------
  
  %% ------------------------------
  %  Set plot parameters
  %% ------------------------------
  if ~isfield(parameters.plot, 'paletteName')
    parameters.plot.paletteName = 'DEFAULT';
  end
  parameters.plot.palette = getPaletteByName(parameters.plot.paletteName);
  parameters.plot.xTick   = linspace(analysisParameters.collectRadius(1),analysisParameters.collectRadius(2),parameters.plot.xTickStep);
  parameters.plot.binSize = analysisParameters.resolution;
  parameters.plot.mode    = 'bnd';
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