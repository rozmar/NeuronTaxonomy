% batchCalculatePAC 
% 
% Parameters
%  inputStructure - input structure, which contains the events, section
%  boundaries, the trigger (if needed) and the name of the file
%  parameters - structure containing the processing and plotting parameters
% Return value
%  resultStructure - structure which contains the values: filtering
%  parameters (phase and amplitude), average values, MI, surrogate p
function resultStructure = batchCalculatePAC(inputStructure, parameters)

  %% -------------------------
  %  Parameter setting
  %% -------------------------
  
  % Cut the recording if needed
  if parameters.isCut
    inputStructure = cutRecording(inputStructure, parameters.cutInterval);
  end
  
  % Get the raw signal
  sigName = parameters.channel.signal;
  sigChan = inputStructure.(sigName);
  % Pull to zero
  sigChan.values = sigChan.values - mean(sigChan.values);
  
  % Initialize filter parameters
  filterParam.filterType  = 'butter';
  filterParam.filterOrder = 2;
  filterParam.Fs          = round(1/sigChan.interval);
  
  % Get binsize
  sBin       = parameters.binSize;
  phaseEdges = (0:sBin:360)';
  
  if parameters.isSave
    outDir = parameters.output.dir; 
  end
  %% -------------------------

  %% -------------------------
  %  Collect good cycle bounds
  %  (Good cycle = no event in it)
  %% -------------------------
  
  printStatus('Collect cycles');
  correctCycleMask = findCorrectCycle(inputStructure, parameters.channel);
  %% -------------------------

  %% -------------------------
  %  Calculate phase
  %% -------------------------
  
  % Filter for phase
  filterParam.filterBounds = parameters.filter.phase;
  filtForPhase             = filterSignal(sigChan.values, filterParam);
  
  fprintf('Perform Hilbert-transform to obtain phase information.\n');
  
  % Calculate phase with Hilbert transform
  phaseValue = angle(hilbert(filtForPhase)) + pi;
  % Keep only the values in relevant cycles
  % And convert it to degrees
  phaseValue = mod(radtodeg(phaseValue(correctCycleMask)), 360);
  
  clear filtForPhase;
  %% -------------------------

  %% -------------------------
  %  Calculate amplitudes
  %% -------------------------
  
  % Collect filter parameters
  amplBands = parameters.filter.amplitude;
  nAmplBand = size(amplBands,1);
  ampStruct(nAmplBand) = struct('value',[],'band',[]);
  
  fprintf('Perform Hilbert-transform to obtain amplitude information at\n');
  
  % For each band
  for a = 1 : nAmplBand
      
    fprintf('%d-%d Hz\n', amplBands(a,:));
     
    % Filter for amplitude
    filterParam.filterBounds = amplBands(a,:);
    filtForAmp               = filterSignal(sigChan.values, filterParam);
    % Perform Hilbert-transform to obtain amplitude value
    ampValue                 = abs(hilbert(filtForAmp));
    
    clear filtForAmp;
    
    ampStruct(a).value = ampValue(correctCycleMask);
  end
  %% -------------------------
  
  %% -------------------------
  %  Aggregate values in cycle
  %% -------------------------
  
  % Initialize vector for average
  resultStructure(nAmplBand) = struct('value',[]);
  
  % Bin phases of cycle
  [~,phaseCategory] = histc(phaseValue, phaseEdges);
  
  % Loop through each amplitude band
  for a = 1 : nAmplBand
    averageValue = sortAndAverageIntoBins(phaseCategory, ampStruct(a).value, sBin);
    
    resultStructure(a).value = averageValue;
    resultStructure(a).norm  = averageValue./sum(averageValue);
    resultStructure(a).band  = amplBands(a,:);
  end
  %% -------------------------
    
  %% -------------------------
  %  Plot values
  %% -------------------------
  if ~isempty(parameters.plotType)
      
    nPlot = length(parameters.plotType);
    for p = 1 : nPlot
      thisPlotType = parameters.plotType{p};
      
      thisPlotType = strsplit(thisPlotType, '_');
      whatPlot     = thisPlotType(1);
      howPlot      = thisPlotType(2);
      
      for a = 1 : nAmplBand
          
        plotTitle = sprintf('%s %d-%d Hz',inputStructure.title,amplBands(a,:));
        fileName  = sprintf('%s_%d-%d',inputStructure.title,amplBands(a,:));
                  
        if strcmp(whatPlot, 'exp')
          yvector = resultStructure(a).value;
          plotTitle = sprintf('%s expected value', plotTitle);
          fileName  = sprintf('%s_exp', fileName);
        elseif  strcmp(whatPlot, 'norm')
          plotTitle = sprintf('%s distribution', plotTitle);
          fileName  = sprintf('%s_dist', fileName);
          yvector = resultStructure(a).norm;
        end
        
        if strcmp(howPlot, 'circ')
            
          fileName  = sprintf('%s_circ', fileName);
            
          plotParam.meanVector = true;
          plotParam.title = plotTitle;
          plotHandle = plotCircularBarchart(yvector, plotParam);
        elseif strcmp(howPlot, 'lin')
           
          fileName  = sprintf('%s_hist', fileName);
            
          plotParam.range = [-360,360];
          plotParam.sBin  = sBin;
          plotParam.tickSpacing = 90;
          plotParam.plotMode = 'bar';
          plotParam.title = plotTitle;
          yvector = yvector([1:end,1:end,1]);
          plotHandle = plotMeanAndSem(yvector, [], plotParam);
        end
        
        clear yvector plotParam;
        
        if parameters.isSave
          saveas(plotHandle, sprintf('%s\\%s.fig', outDir, fileName));
          print(plotHandle, sprintf('%s\\png\\%s.png', outDir, fileName), '-dpng'); 
        end
      end
    end
  end
  %% -------------------------

  %% -------------------------
  %  Calculate statistics
  %% -------------------------
  fprintf('Modulation index for \n');
  for a = 1 : nAmplBand
    normValue = resultStructure(a).norm;
    nBin      = 360/sBin;
    MI = calculateModulationIndex(normValue, nBin);
    
    fprintf('%d-%d Hz: %f\n', amplBands(a,:), MI);
  end
  %% -------------------------
  
end

%% ===========================
%  Calculate Kullback-Leibler
%  divergence based Modulation Index.
%% ===========================
function SMI = calculateModulationIndex(binDist, binNum)
  SShannonEntropy = -1*sum(binDist.*log(binDist));
  SD_KL = log(binNum) - SShannonEntropy;
  SMI = SD_KL / log(binNum);
end
%% ===========================

%% ===========================
%  Sort each value by its phase
%  and then average by bins.
%% ===========================
function averageValue = sortAndAverageIntoBins(phases, values, sBin)

  %% ------------------------
  %  Initialization
  %% ------------------------
  nBin           = 360/sBin;
  averageValue   = zeros(nBin, 1);
  %% ------------------------
    
  %% ------------------------
  %  Collect each degree
  %% ------------------------
  for d = 1 : nBin
    valuesAtDegree = values(phases==d);
    averageValue(d)  = mean(valuesAtDegree);
  end
  %% ------------------------
end
%% ===========================