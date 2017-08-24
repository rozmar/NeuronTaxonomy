% findConsecutiveSegments find each segment pairs where the first and
% second segment type is different and the distance between the is not
% greater than a given interval. Returns the segment pairs in a structure
% array.
%
% Parameters
%
% Return value
function findConsecutiveSegments()

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