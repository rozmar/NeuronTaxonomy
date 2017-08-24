function frequencyWaveform = calculateInstantaneousFrequencyWaveform(timeVector, eventVector)

  %% -------------------------
  %  Initialization
  %% -------------------------  
  frequencyWaveform = zeros(size(timeVector));  % output vector
  
  if length(eventVector)<3  % If we have less than 3 spikes, we can't calculate inst. freq.
    frequencyWaveform = frequencyWaveform*NaN;
    return; 
  end
  
  positionVector    = zeros(size(timeVector));  % marker vector
  SI                = diff(timeVector(1:2));
  %% -------------------------
  
  %% -------------------------
  %  Mark the position of the events
  %% -------------------------
  [~,positionMarker] = histc(eventVector, timeVector-(SI/2));
  positionVector(positionMarker) = 1;
  %% -------------------------
  
  %% -------------------------
  %  Prepare for the algorithm
  %% -------------------------
  lastEvent    = getNext(positionVector, 0);
  currentEvent = getNext(positionVector, lastEvent);
  while true
    
    lastISI      = tdiff(lastEvent, currentEvent, SI);      
    nextEvent    = getNext(positionVector, currentEvent);
    
    if isempty(nextEvent)
      break; 
    end
    
    frequencyWaveform = setIF(frequencyWaveform, currentEvent, nextEvent, lastISI, SI);
        
    lastEvent = currentEvent;
    currentEvent = nextEvent;
  end
  %% -------------------------
  
  
end

function frequencyWaveform = setIF(frequencyWaveform, currentEvent, nextEvent, lastISI, SI)
  
  lastISIInPoint = floor(lastISI/SI); % How many samplepoint needed for the last ISI
  constantBound  = min([nextEvent, currentEvent+lastISIInPoint]); % the point until which the freq. remain constant
  frequencyWaveform(currentEvent:constantBound) = 1/lastISI;    % set the constant value
  
  frequencyWaveform(constantBound:nextEvent) = 1./(lastISI+((constantBound:nextEvent)-constantBound)*SI);
  
end

% This function find the next marker position from the last position
function nextPos = getNext(markerVector, lastPos)
  nextPos = find(markerVector(lastPos+1:end)==1,1,'first');
  nextPos = nextPos + lastPos;
end

function timeDiff = tdiff(pos1, pos2, SI)
  timeDiff = (pos2-pos1)*SI;
end