%   calculatePeakProminence calculates the prominence of the given peaks
%   in a dataseries.
%
%   [REFERENCE_POINT,PEAK_LEVEL] =
%   CALCULATE_PEAK_PROMINENCE(DATA,PEAK_LOCATION) calculates the prominence
%   of all peaks given in parameter. 
function [prominence] = calculatePeakProminence(timeVector, timeSeries, peakLocations)

  DEBUG=0;

  %-------------------------------
  % Initialization
  %-------------------------------
  nPeak         = length(peakLocations);
  peakLevels    = timeSeries(peakLocations);
  neighbors     = zeros(nPeak, 2);
  reference     = zeros(nPeak,1);
  prominence    = zeros(nPeak,1);
  prominentSide = zeros(nPeak,1);
  %-------------------------------
  
  %-------------------------------
  % Collect prominence for each peak
  %-------------------------------
  for i = 1 : nPeak
    thisPeak       = peakLocations(i);
    thisLevel      = peakLevels(i);
    [leftNeighbor, leftValley] ...
                   = getNeighbor(timeSeries, thisPeak, 'left');
    [rightNeighbor, rightValley] ...
                   = getNeighbor(timeSeries, thisPeak, 'right');
               
    neighbors(i,:) = [leftNeighbor,rightNeighbor];
        
    [reference(i), prominentSide(i)] = max([leftValley,rightValley]);
    prominence(i) = thisLevel-reference(i);
    
  end
  %-------------------------------
  
  %-------------------------------
  % Plot peaks and prominences
  %------------------------------- 
  if DEBUG>=1
    plotPeaksAndProminences(timeVector, timeSeries, peakLocations, neighbors, prominentSide, reference);
  end
  %------------------------------- 
    
end


%############################
%      Helper functions
%############################

%-------------------------------
% Get the neighboring intersection 
% from the timeseries.
%-------------------------------
function [neighborLocation,valley] = getNeighbor(timeSeries, peakLocation, direction)

  peakLevel = timeSeries(peakLocation);
  
  %-------------------------------
  % Find intersection
  %-------------------------------
  if strcmpi(direction, 'left')
    neighborLocation = find(timeSeries(1:peakLocation-1)>=peakLevel, ...
                            1, 'last');
  elseif strcmpi(direction, 'right')
    neighborLocation = find(timeSeries(peakLocation+1:end)>=peakLevel, ...
                            1, 'first');          
  end
  %-------------------------------
 
  %-------------------------------
  % If intersection wasn't found,
  % set the end/start of the timeseries.
  %-------------------------------
  if isempty(neighborLocation)
    if strcmpi(direction, 'left')
      neighborLocation = 1; 
    elseif strcmpi(direction, 'right')
      neighborLocation = length(timeSeries);
    end
  %-------------------------------
  else
    %-------------------------------
    % Right neighbor have to be shifted
    % with the peak position.
    %-------------------------------
    if strcmpi(direction, 'right')
      neighborLocation = neighborLocation + peakLocation;
    end
    %-------------------------------
  end
  %-------------------------------
  
  %-------------------------------
  % Find valleys
  %-------------------------------
  if strcmpi(direction, 'left')
    valley     = min(timeSeries(neighborLocation:peakLocation));
  elseif strcmpi(direction, 'right')
    valley     = min(timeSeries(peakLocation:neighborLocation));
  end
  %-------------------------------
  
end