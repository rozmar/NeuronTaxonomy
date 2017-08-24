% calculateISI calculates the interval histogram of values between events
% in the vector passed to the script. The maximal range and size of bins
% can be specified. The values can be normalized.
%
% Parameters
%  eventVector - nx1 vector containing the events
%  parameters  - parameter structure with fields
%    range    - maximal range
%    binSize  - size of bins
%    plotType - type of plot
%                   'count' - event count (default)
%                   'norm'  - sum normalized to 1 (~ probability)
% Returned values
%  ISIbins   - values in each bin
%  ISIBounds - x values of bins
function [ISIbins,ISIBounds] = calculateEventISI(eventVector, parameters)

  %% ----------------------
  %  Get ISI parameters
  %% ----------------------
  range   = parameters.range;   % max value
  binSize = parameters.binSize; % size of bin
  edges   = 0:binSize:range;       % edges of bins
  
  % Add fractional bin
  if edges(end)<range
    edges = [ edges , range ]; 
  end
  
  ISIBounds = edges(1:end-1) + (binSize/2);
  %% ----------------------
  
  %% ----------------------
  %  Calculate event differences
  %% ----------------------
  eventVector = sort(eventVector); % sort events for sure
  ISI         = diff(eventVector); % calculate diff between events
  ISI         = ISI(ISI<range);    % cut after range
  %% ----------------------
    
  %% ----------------------
  %  Calculate bins
  %% ----------------------
  ISIbins     = histc(ISI, edges);
  ISIbins     = ISIbins(1:end-1);
  %% ----------------------
    
  %% ----------------------
  %  Normalize if needed
  %% ----------------------
  if isfield(parameters,'plotType') && ...
          strcmpi(parameters.plotType, 'norm')
    ISIbins = ISIbins ./ sum(ISIbins);
  end
  %% ----------------------
  
end