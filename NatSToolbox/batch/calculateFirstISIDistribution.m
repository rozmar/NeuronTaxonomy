function [resultStructure,parameters] = calculateFirstISIDistribution(inputStructure, parameters)

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
  %  Calculate the results
  %% --------------------------
  firstIsi = zeros(length(peritriggerEventArray),2);
  for i = 1 : length(peritriggerEventArray)
    firstIsi(i,:) = calculateFirstISIAroundTrigger(peritriggerEventArray{i});
  end
  isiDist = calculateDistribution(firstIsi, parameters);
  %% --------------------------
  
  %% --------------------------
  %  Store the results 
  %% --------------------------
  resultStructure.mode           = 'single';
  resultStructure.firstIsiBefore = firstIsi(:,1);
  resultStructure.firstIsiAfter  = firstIsi(:,2);
  resultStructure.isiDistributionBefore = isiDist(1:end-1,1);
  resultStructure.isiDistributionAfter  = isiDist(1:end-1,2);
  %% --------------------------
  
  %% ---------------------------
  %  Save data if needed
  %% ---------------------------
  if isSave(parameters)
    fileName = strjoin({inputStructure.title,'first_isi_around',lower(parameters.channel.trigger.title)},'_');
    dataPath = strcat(parameters.output.dir,'/',fileName,'.mat');
    save(dataPath, 'resultStructure');
  end  
  %% ---------------------------   
  
end

function isiDist = calculateDistribution(firstIsi, parameters)
  binEdges = linspace(parameters.analysis.calcRadius(1),parameters.analysis.calcRadius(2),parameters.analysis.binNumber+1);
  isiDist  = [histc(firstIsi(:,1),binEdges), histc(firstIsi(:,2),binEdges)]; 
end


function firstISI = calculateFirstISIAroundTrigger(thisTriggerEvents)
  
  beforeTrigger = thisTriggerEvents(thisTriggerEvents<0);
  afterTrigger  = thisTriggerEvents(thisTriggerEvents>0);
  
  firstISI = [calculateFirstISI(-1*beforeTrigger),calculateFirstISI(afterTrigger)];
end

function firstISI = calculateFirstISI(eventVector)
  eventVector = sort(eventVector);
  if length(eventVector)<2
    firstISI = NaN;
    return;
  end
  
  firstISI = diff(eventVector(1:2));
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
  parameters.plot.xTick   = linspace(analysisParameters.calcRadius(1),analysisParameters.calcRadius(2),parameters.plot.xTickStep);
  parameters.plot.binSize = diff(analysisParameters.calcRadius)/analysisParameters.binNumber;
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