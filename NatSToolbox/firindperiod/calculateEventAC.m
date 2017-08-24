% calculateEventAutocorrelation performs event autocorrelation between
% event of the given vector. The result can be converted to event rate.
%
% Parameters
%  eventVector - nx1 vector containing the events
%  parameters  - parameter structure with fields
%    maxRange - maximal range
%    binSize   - size of bins
%    plotType  - type of plot
%                   'count' - event count (default)
%                   'rate'  - converted to event rate (~ frequency)
% Returned values
%  AC    - values in each bin
%  lags  - lags of AC
function [AC, lags] = calculateEventAC(eventVector, parameters)
  
  %% ----------------------
  %  Get AC parameters
  %% ----------------------
  binSize   = parameters.binSize;
  maxRange  = parameters.maxRange;
  nEvent    = length(eventVector);
  halfSweep = ceil(maxRange/binSize);
  lSweep    = 2*halfSweep;
  
  edges     = fliplr(-binSize:-binSize:-maxRange);
  if edges(1)>-maxRange
    edges = [ -maxRange , edges ];
  end
  
  edges     = [ edges , (0:binSize:maxRange)];
  if edges(end)<maxRange
    edges = [ edges , maxRange ];
  end
     
  lags      = edges(1:end-1) + (binSize/2);
  %% ----------------------
  
  %% ----------------------
  %  Initialize
  %% ----------------------
  ACMatrix = zeros(nEvent, lSweep);
  %% ----------------------

  %% ----------------------
  %  Process each event
  %% ----------------------
  for i = 1 : nEvent
    thisEvent     = eventVector(i);
    thisEdge      = edges + thisEvent;
    eventInRange  = eventVector(thisEdge(1)<=eventVector&eventVector<=thisEdge(end));
    eventInRange(eventInRange==thisEvent) = [];
    eventInRange  = eventInRange - thisEvent;
    currentSweep  = histc(eventInRange, edges);
    ACMatrix(i,:) = currentSweep(1:end-1);
  end
  %% ----------------------

  %% ----------------------
  %  Aggregate result
  %% ----------------------
  AC = sum(ACMatrix, 1);
  %% ----------------------

  %% ----------------------
  %  Convert to event rate
  %% ----------------------
  if isfield(parameters,'plotType') && ...
          strcmpi(parameters.plotType, 'rate')
    AC = (AC ./ nEvent) ./ binSize;
  end
  %% ----------------------
 
end