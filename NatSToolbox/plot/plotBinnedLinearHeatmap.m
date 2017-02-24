% This function plots a heatmap which displays the change of occurence of
% events in function of recording time. With toShift parameter, we can
% shift the values from interval [0,2pi] to [-pi,pi]. With toPad, we can
% duplicate the heatmap to see 2 cycles next to each other.
%
% Parameters
%  - binnedEventMatrix - nxb matrix, which contains event numbers in n
%  section divided into b bins
%  - toShift - logical variable, do we want to shift the values
%  - toPad   - logical variable, do we want to replicate the values
%  - toSmooth - logical variable, do we want to smooth the map
function plotBinnedLinearHeatmap(binnedEventMatrix, parameters)

  %% --------------------
  %  Initialize settings
  %% --------------------
  yRange   = [0,360]; % initial range
  yWidth   = diff(yRange);
  pixelMap = binnedEventMatrix'; % pixelmap is the transposed matrix
  binHalf  = round(size(binnedEventMatrix,2)/2); % number of bins
  
   toShift  = 1;
   toPad    = 1;
   toSmooth = parameters.smooth.plot;
  %% --------------------
  
  %% --------------------
  %  Transform map
  %% --------------------  
  if toShift
    pixelMap = shiftMap(pixelMap, binHalf); %shift zero to middle
    yRange   = yRange - yWidth/2;           % new range
  end
  
  if toPad
    pixelMap = padMap(pixelMap, binHalf);   % replicate to full cycle
    yRange   = yRange.*2;                   % new range
  end
  %% --------------------  
 
  if isfield(parameters,'normalize')&&parameters.normalize
    % Normalize the values
    pixelMap = normalizeByColumn(pixelMap);
  end
  
  % Generate axis values
  [xValues,yValues,yTick] = generateAxes(yRange, pixelMap);
  
  %% --------------------
  %  Smooth map
  %% --------------------  
  if toSmooth
    gaussWinSize = parameters.smooth.winSize;
    gaussSD      = parameters.smooth.smSD;
    halfWinSize  = floor(gaussWinSize/2);
    epochNumber  = size(pixelMap, 2);
    
    % Create filter
    h = fspecial('gaussian', gaussWinSize, gaussSD);
    
    % Add padding to the pixelmap
    padMatrix = zeros(halfWinSize, epochNumber);
    pixelMap  = [padMatrix;pixelMap;padMatrix];
    
    % Filter the pixelmap
    pixelMap = imfilter(pixelMap, h, 'symmetric');
    
    % Remove padding after filter
    pixelMap = pixelMap(halfWinSize+1:end-halfWinSize,:);
  end
  %% --------------------  

  %% --------------------
  %  Show the plots
  %% --------------------  
  displayHeatmap(xValues, yValues, pixelMap);
  set(gca, 'YTick', yTick);
  ylim(yRange);
  %% --------------------  
  
end

%% ===========================================
% Helper functions for the pixel map creataion
%% ===========================================
%  Shift the initial matrix by its half. The 
%  original bottom starts from the middle and 
%  the top will be below that.
function shifted = shiftMap(M, offset)
  shifted = [ M(offset+1:end,:) ; M(1:offset,:) ];
end

% Replicates the initial matrix by adding the 
% other half to each side. 
% The result will be two full cycle.
function padded = padMap(M, offset) 
  padded = [ M(offset+1:end,:) ; M ; M(1:offset,:) ];
end
%% ===========================================

% Normalize the values of a matrix by column.
function normMatrix = normalizeByColumn(initialMatrix)

  sumVector  = sum(initialMatrix, 1);
  rowNumber  = size(initialMatrix,1);
  divMatrix  = ones(rowNumber,1) * sumVector;
  
  normMatrix = initialMatrix ./ divMatrix;
  normMatrix(isnan(normMatrix)) = 0;
end

% Generate y and x values
function [xValues,yValues,yTick] = generateAxes(yRange, pixelMap)

  [binNumber, epochNumber] = size(pixelMap);

  xValues = 1:epochNumber;
  
  y = linspace(yRange(1), yRange(2), binNumber+1);
  yValues = y(1:end-1);
  
  yTick = flipud((yRange(1):90:yRange(2)))';
end
%% ===========================================