function [shapeStructure,parameters] = calculateShapelet(inputStructure, parameters)

  %% ------------------------------
  %  Check parameters
  %% ------------------------------
  parameters = checkParameters(parameters);
  %% ------------------------------
  
  %% ------------------------------
  %  Preprocess signal
  %% ------------------------------
  [inputStructure,signalStructure]  = preprocessSignal(inputStructure, parameters);
  %% ------------------------------
        
  %% ------------------------------
  %  Create time axis
  %% ------------------------------
  timeVector = createTimeVector(parameters, getSI(signalStructure));
  %% ------------------------------
           
  %% ------------------------------
  %  Collect triggers
  %% ------------------------------
  [triggerVector,positionVector] = collectTriggers(inputStructure, parameters.channel); %#ok<NASGU>
  %% ------------------------------
    
  %% ------------------------------
  %  Cut slices around triggers
  %% ------------------------------
  sliceArray = collectSlicesAroundTriggers(triggerVector, signalStructure, timeVector);
  %% ------------------------------  
  
  %% ------------------------------
  %  Create result structure
  %% ------------------------------
  shapeStructure = ...
      createShapeStructure(sliceArray, timeVector, inputStructure.title, parameters);
  %% ------------------------------
       
  %% ------------------------------
  %  Clear the raw files
  %% ------------------------------
  clear inputStructure signalStructure;
  %% ------------------------------

  %% ------------------------------
  %  Cluster each slice
  %% ------------------------------
  if parameters.shapelet.toCluster
    nCluster   = parameters.shapelet.clusterNum;
    nReplicate = parameters.shapelet.replicates;
  
    for f = 1 : length(shapeStructure)
      shapeStructure(f).class = kmeans(...
          shapeStructure(f).slice, nCluster,...
          'Display',     'off', ...
          'Replicate',   nReplicate, ... 
          'EmptyAction', 'singleton');      
    end
  end
  %% ------------------------------
  
  %% ------------------------------
  %  Display and save results
  %% ------------------------------  
  if parameters.plot.overallAverage
    plotResults(shapeStructure, parameters, 'overall');
  end
  
  if parameters.plot.showClusters
    plotResults(shapeStructure, parameters, 'clustered');
  end
  %% ------------------------------  

  %% ------------------------------
  %  Save data
  %% ------------------------------  
  if isSave(parameters)
    saveData(shapeStructure, parameters);
  end
  %% ------------------------------
  
end

% Save the given plot with given name parameters
function savePlot(h, outputDir, fullName, suffix)
      
  outputPath = strjoin({...
      outputDir, ...
      [generateFileName(fullName, suffix),'.fig']},'/');
  
  saveas(h, outputPath);
end

% Save the given result structure with given name
function saveData(shapeletStructure, parameters)

  % Get filename
  fullName = shapeletStructure(1).name;

  % Generate output path
  outputPath = strjoin({...
      parameters.output.dir, ...
      [generateFileName(fullName),'.mat']},'/');

  save(outputPath, 'shapeletStructure', '-v7.3');
end

% Generates output file name from input filename and suffix
function fileName = generateFileName(fullName, suffix)
  if nargin>1 && ~isempty(suffix)
    fileName = strjoin({fullName,suffix,'shapelet'},'_');
  else
    fileName = strjoin({fullName,'shapelet'},'_');
  end
end

% Plots the given subset of result.
function plotResults(shapeStructure, parameters, type)
  
  for i = 1 : length(shapeStructure)
      
    %% ---------------------------------
    %  Get values for plotting
    %% ---------------------------------
    % Get slices for this filter setting
    thisSlice  = shapeStructure(i).slices;
    % Get time for this setting
    thisTime   = shapeStructure(i).time;
    % Get filter parameters
    thisFilter = shapeStructure(i).filter;
    % Get filename
    thisName   = shapeStructure(i).name;
    % Create plot title
    thisTitle  = strjoin({strrep(thisName,'_',''), filterToString(thisFilter)});
    %% ---------------------------------
    
    % Set class vector
    if strcmpi(type, 'overall')
      thisClass = ones(size(thisSlice,1),1);
    else
      thisClass = shapeStructure(i).class;
    end
    
    % Plot slices
    plotClusteredSlices(thisTime, thisSlice, thisClass, parameters.plot);

    % Set plot title
    if strcmpi(type, 'overall')
      title(thisTitle);  
    else
      suptitle(thisTitle);
    end
    
    % Save plot
    if isSave(parameters)
      savePlot(gcf, ...
          parameters.output.dir, ...
          thisName, ... 
          createShapeletSuffix(thisFilter, parameters));
    end
    
  end

end

% This function creates the time vector for shapelet
function timeVector = createTimeVector(parameters, SI)
  radius     = parameters.shapelet.radius;
  timeVector = linspace(radius(1), radius(2), diff(round(radius./SI))+1);
end

% Create shape structure from a slice array
function shapeStructure = createShapeStructure(sliceArray, timeVector, fileName, parameters)

  % Put slices to the structure
  shapeStructure = struct('slices', sliceArray);
  
  % Put time vector to structure
  [shapeStructure(:).time] = deal(timeVector);
  
  % Put file name to structure
  [shapeStructure(:).name] = deal(fileName);

  % Put filter parameters to structure
  for i = 2 : length(sliceArray)
    shapeStructure(i).filter = parameters.filter.filterBounds(i-1,:);
  end
end

%% =================================
% Preprocessing functions
%% =================================
% This function performs the required preprocessing steps. Returns the
% modified input structure (S) and the signal structure.
function [S,signalStructure] = preprocessSignal(Sin, parameters)
 
  S = Sin;
  signalChannelName = parameters.channel.signal;
  signalStructure   = S.(signalChannelName);
  
  % Downsample recording
  if parameters.toDownSample
    signalStructure.times    = downsample(signalStructure.times, parameters.downSampleRate);
    signalStructure.values   = downsample(signalStructure.values, parameters.downSampleRate);
    signalStructure.interval = signalStructure.interval*parameters.downSampleRate;
    
    Fs = getFS(signalStructure);
    printStatus(sprintf('Downsampling to %.0dHz',Fs),'*');
  end

  % Cut the recording
  if parameters.isCut
    S = cutRecording(S, parameters.cutInterval);
  end  
  
  % Despike signal
  if parameters.toDespike
      
    % Check if spike field exists
    checkFieldExist(S, 'spk');
    
    % Perform despiking
    signalStructure = despikeRecording(signalStructure, S.spike);  
  end
  
  %  Filter signal
  if parameters.toFilter
    filtParam    = parameters.filter;
    
    % Assemble filter parameter structure
    filtParam.Fs = getFS(signalStructure);
    fBounds      = filtParam.filterBounds;
    nFilter      = size(fBounds,1); % number of filters
    filtered     = cell(nFilter,1); % array for filtered signals
    
    % Filter in each frequency band
    for i = 1 : nFilter
      filtParam.filterBounds = fBounds(i,:);
      filtered{i} = doFiltering(filtParam, signalStructure);
    end
    
    % If only one filter band was given, have to replace raw signal
    if nFilter==1
      signalStructure.values   = filtered{1};    
    else % else, we put it 
      signalStructure.filtered = filtered;
    end
    
  end
  
  S.(signalChannelName)  = signalStructure;     
end

% Despike recording
function despikedSignal = despikeRecording(signalStructure, spikeStruct)

  % --------------------------
  % Initialize
  % --------------------------
  despikedSignal = signalStructure;
  signalVector            = signalStructure.values;
  timeVector              = signalStructure.times;
  spikeVector             = spikeStruct.times;
  nSpike                  = length(spikeVector);
  
  Fs = getFS(signalStructure);
  SI = getSI(signalStructure);
  
  spikeRadius       = [-0.0005, 0.0015];
  spikeRadiusOffset = round(spikeRadius/SI);
  spikeTrain        = zeros(size(timeVector));
  % --------------------------
  
  fprintf('Start despiking.');
  fprintf('Fit power spectrum.\n');

  % --------------------------
  % Fit power spectrum for start
  % --------------------------
  g  = fitLFPpowerSpectrum(signalVector, 0.01, 1000, Fs);
  % --------------------------  

  % --------------------------
  % Create spike train
  % --------------------------  
  for i = 1 : nSpike
    spikeTrain(find(timeVector>=spikeVector(i),1,'first')+spikeRadiusOffset(1)) = 1;
  end  
  % --------------------------  
  
  % --------------------------
  % Run despiking
  % --------------------------   
  Bs = eye(diff(spikeRadiusOffset));
  fprintf('Perform despiking.\n');
  results  = despikeLFP(signalVector, spikeTrain, Bs, g, struct('displaylevel', 0));
  close gcf;
  % --------------------------   
  
  % --------------------------
  % Create output
  % --------------------------   
  despikedSignal.values = results.z;
  % --------------------------   
  
end

% This function performs filtering on the given signal with the given band
function filteredSignal = doFiltering(parameters, signalStructure)

  parameters.Fs = getFS(signalStructure);
  
  % -------------------------
  % Print status
  % -------------------------
  statusMsg = 'Bandpass filtering %s';
  statusMsg = sprintf(statusMsg, signalStructure.title);
  printStatus(statusMsg, '*');
  fprintf('%s\n\n', filterToString(parameters.filterBounds));
  % -------------------------
  
  filteredSignal = filterSignal(signalStructure.values, parameters);
end
%% =================================

%% =================================
%  Validation functions
%% =================================
function parameters = checkParameters(inParameters)

  parameters = inParameters;
  
  %% ---------------------------
  %  Generate xtick
  %% ---------------------------
  plotParam  = parameters.plot;
  
  parameters.shapelet.radius = mirrorInterval(parameters.shapelet.radius);
  plotParam.timeBound        = parameters.shapelet.radius;
  
  % Units of the x axis
  plotParam.xTick = ...
      plotParam.timeBound(1):...
      plotParam.xTickStep:...
      plotParam.timeBound(2);
  
  plotParam.xTickLabel = plotParam.xTick;

  % Scale x labels to ms
  if isfield(plotParam,'inMiliseconds') && plotParam.inMiliseconds
    plotParam.xTickLabel = plotParam.xTickLabel * 1000;
  end 
  parameters.plot = plotParam;
  %% ---------------------------  
  
  %% ---------------------------
  %  Set categorization function
  %% ---------------------------
  [parameters.categorization.categorizationFunction, ...
      parameters.categorization.categorizationBase] = ... 
      getCategorizeFunction(parameters.categorization.categorizationMode);
  %% ---------------------------
  
end
%% =================================