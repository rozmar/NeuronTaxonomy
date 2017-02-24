% describeWaveform describes a given waveform with the following
% properties:
%  - wavelength:         difference between the wave start and end
%  - uprising slope:     slope of ascending phase
%  - downfalling slope:  slope of descending phase
%  - waveform amplitude: difference between a maximal/minimal value and the
%    lower/higher endpoint
%  - following difference: difference between the wave's end and the
%    following section start
%  - does contain marker: decision if the wave contains a give marker in it
% 
% Parameters
%  - inputStructure - input structure which contain all data needed
%  - parameters - parameter structure which describe the parameters for
%  analysis: 
%    - filter  - properties of bandpass filter for slope finding
%    - segment - properties for channel which contains waveform
%      - name  - name of the waveform segment channel
%      - title - title of segment channel, for status messages
%    - following.section - properties of following channel
%      - name - name of the follower section channel
%    - following.trigger - triggers which make the section
%      - name - name of the trigger channel
%    - contained.trigger - trigger what the wave have to contain
%      - name - name of the channel
function [resultStructure,parameters] = describeWaveform(inputStructure, parameters)
  
  %% -------------------------
  %  Collect parameters and data
  %% -------------------------  
  filterParam     = parameters.filter;
  signalStructure = inputStructure.(parameters.channel.signal);
  filterParam.Fs  = getFS(signalStructure);
  %% -------------------------
  
  %% -------------------------
  %  Do the filtering
  %% -------------------------
  filteredSignalStructure        = signalStructure;
  filteredSignalStructure.values = filterSignal(filteredSignalStructure.values, filterParam);
  %% -------------------------
  
  %% -------------------------
  %  Collect waveform segment
  %% -------------------------
  waveformParameters = struct(...
      'name',parameters.segment.name,...
      'title',parameters.segment.title);
  waveformStructure = getSingleSegment(inputStructure, waveformParameters);
  %% -------------------------
  
  %% -------------------------
  %  Collect waveform slices
  %% -------------------------
  rawSegment      = cutSegments(signalStructure, waveformStructure);
  filteredSegment = cutSegments(filteredSignalStructure, waveformStructure);
  %% -------------------------
  
  %% -------------------------
  %  Describe segment
  %% -------------------------
  [slopeMatrix,lengthVector,amplitudeVector] = ...
      calculateWaveStatistic(rawSegment, filteredSegment, getSI(signalStructure), parameters);
  %% -------------------------
  
  %% -------------------------
  %  Store results
  %% -------------------------
  resultStructure = struct(...
      'fileName', inputStructure.title, ...
      'upSlope', slopeMatrix(:,1), ...
      'downSlope', slopeMatrix(:,2), ...
      'waveLength', lengthVector, ...
      'waveAmplitude', amplitudeVector, ...
      'difference', zeros(size(lengthVector)));
  
  resultStructure.waveForms = rawSegment;
  %% -------------------------
  
  %% -------------------------
  %  Calculate distance from 
  %  following segment
  %% -------------------------  
  if isfield(parameters, 'following')

    % Collect trigger contained by section 
    % which were preceeded by the waveform
    [triggerVector,positionVector] = ...
        collectTriggers(inputStructure, parameters.following);
    
    % Collect preceding waveform
    waveEndVector = ...
        collectPrecedingWaveEnds(triggerVector(positionVector==1), ...
        waveformStructure.end);
      
    % Collect second troughs from spindle
    secondTroughs = triggerVector(positionVector==2);
    
    % Subtract
    difference = secondTroughs-waveEndVector;
    
    % Structure to store segment to cut
    lastTriggers = findLastTriggers(triggerVector, positionVector);
    
    % Take each waveform
    resultStructure.waveForms = cell(length(waveformStructure.start),1);
    resultStructure.waveSpikes = cell(length(waveformStructure.start),1);
    resultStructure.waveFormLength = zeros(length(waveformStructure.start),1);
    for i = 1 : length(waveformStructure.end)
        
      % Find it's position
      idx = find(waveformStructure.end(i)==waveEndVector);
      
      % If this waveworm wasn't followed by a section
      % difference will be NaN, else de real difference.
      if isempty(idx)
        resultStructure.difference(i) = NaN;
      else
        resultStructure.difference(i) = difference(idx);
    
        toCutSection = struct('start', waveformStructure.start(i), ...
            'end', lastTriggers(idx));
        
        filteredSignalStructure        = signalStructure;
        filterParam.filterBounds       = 250;
        filterParam.filterMode         = 'low';
        filteredSignalStructure.values = filterSignal(filteredSignalStructure.values, filterParam);
        
        thisSliceEnds = cutSegments(filteredSignalStructure, toCutSection);
        
        resultStructure.waveForms{i} = thisSliceEnds{1};
        resultStructure.waveFormLength(i) = lastTriggers(idx)-waveformStructure.start(i);
        
        segmentEventArray = collectEventInSegment(inputStructure.spk.times, toCutSection);
        resultStructure.waveSpikes{i} = segmentEventArray{1} - waveformStructure.start(i);
      end
    end
       
  end
  %% -------------------------
  
  %% -------------------------
  %  Find wave with trigger
  %% -------------------------  
  resultStructure.class = ones(size(lengthVector));
  if isfield(parameters, 'contained')
    flagVector = findSegmentWithEvent(waveformStructure, inputStructure.(parameters.contained.trigger.name).times, 'with');
    resultStructure.class = flagVector;
  end
  %% -------------------------  
  
  %% -------------------------
  %  Categorize wave by condition
  %% -------------------------
  if parameters.categorize.toCategorize
    flagVector = ...
        processSectionConditions(waveformStructure, inputStructure, parameters.categorize);
    flagVector = double(flagVector);
    flagVector(~flagVector) = 2;
    resultStructure.class = flagVector;
  end
  %% -------------------------
  
  %% -------------------------
  %  Print statistics
  %% -------------------------
  printStatistics(resultStructure);
  %% -------------------------
  
  
end

function printStatistics(resultStructure)

  fprintf('Mean slope of first part: %f\n', mean(resultStructure.upSlope));
  fprintf('Mean slope of second part: %f\n', mean(resultStructure.downSlope));
  fprintf('Mean wave length: %f\n', mean(resultStructure.waveLength));
  fprintf('Mean wave amplitude: %f\n', mean(resultStructure.waveAmplitude));
  fprintf('Mean difference between wave and following marker: %f\n', nanmean(resultStructure.difference));

end

function precedingVector = collectPrecedingWaveEnds(referenceVector, precedingVector)
    precedingInterval = makePeriTriggerMarker(referenceVector, [-0.1,0]);
    precedingVector   = collectEventInSegment(precedingVector, precedingInterval);
    precedingVector   = sort([precedingVector{:}])';
end

function lastTriggerVector = findLastTriggers(triggerVector, positionVector)
  % Find first triggers
  firstIndices    = find(positionVector==1);
  % Remove the very first trigger
  firstIndices(1) = [];
  % Shift indices back
  lastIndices       = firstIndices - 1;
  % Add the very last to the vector
  lastIndices       = [lastIndices;length(positionVector)];
  % Find last triggers
  lastTriggerVector = triggerVector(lastIndices);
 
end