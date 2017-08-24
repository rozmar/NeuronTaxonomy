% calculateInstantaneousFrequency calculates the instantaneous frequency
% for each event. This function will return a value vector which contains
% the inst. freq. for each samplepoint where spike presents. Everywhere
% else the value will be zero.
% 
% Parameters
%  - timeVector - tx1 vector, where we want to evaluate inst. freq.
%  - eventVector - ex1 vector, the vector containing the events time
% Return value
%  - frequencyVector - tx1 vector, contains the instantaneous frequency for
%    each time sample point where spike was present, or zero elsewhere
function frequencyVector = calculateInstantaneousFrequency(timeVector, eventVector)

  %% -------------------------
  %  Initialization
  %% -------------------------  
  
  % Instantenous frequency isn't 
  % on 1 spike
  if length(eventVector) <= 1 
    frequencyVector = NaN;
    return; 
  end
  
  frequencyVector = zeros(size(timeVector)); % inst. freq. container
  sampleInterval = diff(timeVector(1:2));  %sample interval
  %% -------------------------
  
  %% -------------------------
  %  Find the position of the events
  %% -------------------------
  positionMarker = markEventOnTime(timeVector, eventVector, sampleInterval);
  %% -------------------------
  
  %% -------------------------
  %  Prepare for the algorithm
  %% -------------------------
  lastEvent = getNext(positionMarker, 0);
  currentEvent = getNext(positionMarker, lastEvent);
  while ~isempty(currentEvent)
    
    frequencyVector(currentEvent) = ...
      1/tdiff(lastEvent, currentEvent, sampleInterval);
    
    % Step forward
    lastEvent = currentEvent;
    currentEvent = getNext(positionMarker, currentEvent);
  end
  %% -------------------------
  
  
end

% Create a 0-1 vector for the time vector to indicate the position of event
function positionMarker = markEventOnTime(timeVector, eventVector, sampleInterval)
  shiftedTime = shiftValues(timeVector, -(sampleInterval / 2)); 
  [~,positionIndices] = histc(eventVector, shiftedTime);
  
  positionMarker = false(size(timeVector));
  positionMarker(positionIndices) = true;
end

% This function find the next marker position from the last position
function nextPos = getNext(markerVector, lastPos)
  nextPos = find(markerVector(lastPos+1:end) == 1, 1, 'first');
  nextPos = nextPos + lastPos;
end

% Shift all values of a vector with a given amount
function shiftedVector = shiftValues(initialVector, shiftValue)
  shiftedVector = initialVector + shiftValue;
end

% Calculates the duration in seconds between 2 samplepoint
function timeDiff = tdiff(pos1, pos2, SI)
  timeDiff = (pos2 - pos1) * SI;
end