% plotMeanAndSem displays the mean and sem given in parameter. The type of
% the plot can be selected with parameters. Three possible forms can be
% choosen: barchart, barchart with error bars, bounded line with shading.
% If sem values weren't given, it will be considered as zero.
% 
% Parameters
%  - meanVector - 1xn vector, containing the mean values
%  - semVector - (optional) 1xn vector, containing the SEM values
%  - parameters - parameter structure to customize the plot. Fields:
%    - mode - type of plot: avg, msd, bnd
%    - title - title of the plot
%    - binSize - difference between sample values on plot
%    - range - limits of x axis
%    - xTickStep - difference between X axis ticks
%    - inMiliseconds (optional) - do we need to convert to miliseconds
%    - palette (optional) - RGB values for plot color
function plotMeanAndSem(meanVector, semVector, parameters)
    
  %% -------------------------
  %  Transpose to row vector
  %% -------------------------
  meanVector = toRow(meanVector);
  semVector  = toRow(semVector);
  %% -------------------------
  
  %% -------------------------
  %  Assemble values
  %% -------------------------
  % Create x axis
  [xValue, xTicks, xLabels] = createX(parameters);
    
  % Create dummy SEM vector if not given
  if isempty(semVector)
    semVector = zeros(size(meanVector));
  end  
  %% -------------------------

  %% -------------------------
  %  Plot data
  %% -------------------------
  hold on;
  plotMode = parameters.mode;
  palette  = getPalette(parameters);
  
  if strcmp(plotMode, 'bnd')
    colormap = generateColormap(length(meanVector), palette);
    boundedline(xValue, meanVector, semVector, 'cmap', colormap);
  elseif strcmp(plotMode, 'msd') || strcmp(plotMode, 'avg')
    plotColoredHistogram(xValue, meanVector, palette);
    if strcmp(plotMode, 'msd')
      plotErrorSticks(xValue, meanVector, semVector, palette);
    end
  end
  
  hold off;
  %% -------------------------
 
  %% -------------------------
  %  Customize plot
  %% -------------------------
  title(parameters.title);
  set(gca, 'XTick', xTicks);
  set(gca, 'TickDir', 'out');
  set(gca, 'XTickLabel', xLabels);
  xlim(parameters.range);   
  %% -------------------------
    
end

%% ================================
%  Plot functions
%% ================================
% Plot a barchar with given colors
function plotColoredHistogram(xAxis, yAxis, palette)
  bar(xAxis, yAxis, 'BarWidth', 1, 'EdgeColor', palette.bc, 'FaceColor', palette.fc);
end

%  Plot error sticks with given values
function plotErrorSticks(xAxis, yValue, yError, palette)
  for i = 1 : length(yError)
    drawVerticalLine(xAxis(i), yValue(i), yValue(i)+yError(i), palette.bc, 1);
    drawVerticalLine(xAxis(i), yValue(i), yValue(i)-yError(i), zeros(1,3), 1);
  end
end
%% ================================

%% ================================
%  Helper function
%% ================================
%  Create x axis
function [xValues, xTicks, xLabels] = createX(parameters)
  binSize     = parameters.binSize;
  xRange      = parameters.range;
  tickSpacing = parameters.xTickStep;
  
  xValues  = (xRange(1):binSize:(xRange(2)-binSize)) + (binSize/2);
  xTicks   = xRange(1):tickSpacing:xRange(2);
  
  xLabels  = num2str(xTicks');
  if isfield(parameters,'inMiliseconds') && parameters.inMiliseconds
    xLabels = num2str(xTicks'*1000); 
  end
end
%% ================================

%% ================================
%  Convert column vector to row
%% ================================
function rowVector = toRow(inputVector)
  rowVector = inputVector;
  if size(rowVector,1)>size(rowVector,2)
    rowVector = rowVector';
  end
end
%% ================================
%  Generate colormap for bounded line plot
function colormap = generateColormap(mapSize, palette)
  colormap = ones(mapSize,1)*palette.fc;
end
%% ================================
%  Get the palette from parameters
function palette = getPalette(parameters)

  if ~isfield(parameters, 'palette')
    palette.fc = [0,0,1];
    palette.bc = [0,0,0.8];
  else
    palette = parameters.palette;
  end
  
end
%% ================================
