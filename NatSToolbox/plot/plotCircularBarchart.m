% plotCircularBarchart displays the a given values on a circular
% barchart. The values can be normalized (~ distribution) before the plot.
%
% Parameters
%  valueVector - the values to plot on barchart
%  parameters - parameter structure with given fields
%    normalize - 1 (true), if we want to normalize the barchart, else the
%    absolute values will be plotted
%    title     - title of the plot
%    hideLabel - hide the labels from the plot (default false)
%    meanVector - calculate and plot mean vector (default false)
% Return values
%   returns the figure handle
function plotCircularBarchart(valueVector, parameters)

  %% -----------------------
  %  Parameter setting
  %% -----------------------
  isNormalized  = isfield(parameters,'normalize')&&parameters.normalize;
  isHideLabel   = isfield(parameters,'hideLabel')&&parameters.hideLabel;
  hasMeanVector = ~isfield(parameters,'meanVector')||parameters.meanVector; % default we show the mean vector
  isFilled      = ~isfield(parameters,'filled')||parameters.filled;         % default we want filled barchart
  
  plotTitle     = parameters.title;
  palette       = parameters.palette;
  %% -----------------------
  
  %% -----------------------
  %  Normalize if needed
  %% -----------------------
  if isNormalized
    valueVector = valueVector ./ sum(valueVector);  
  end
  
  valueVector = toCol(valueVector);
  %% -----------------------

  %% -----------------------
  %  Create and display plot
  %% -----------------------
  %  Create bars
  [t,r] = createCircularBarchart(valueVector);
  
  %  Plot bars
  %polar(t,r);
  plotCustomPolar(getCircularLimit(max(valueVector)));

  %  Fill bars
  if isFilled
    fillCircularBarchart(t, r, palette);
  end
  
  %  Set title
  title(strrep(plotTitle,'_','\_'));
  %% -----------------------
  
  %% -----------------------
  %  Draw mean vector if needed
  %% -----------------------
  if hasMeanVector
    % Calculate mean vector of data
    meanVector = calculateMeanvector(valueVector);
    % Plot the mean vector
    plotMeanVector(meanVector, xlim);
  end
  %% -----------------------
  
  %% -----------------------
  %  Hide labels
  %% -----------------------
  if isHideLabel
    removeLabelsPlot;
  end
  %% -----------------------
        
end

% Plots the calculated mean vector
function plotMeanVector(meanVector, xlimits) 

  % Scale to the current plot
  meanVector = meanVector*xlimits(2);
    
  % Plot
  hold on;
  plot([0,real(meanVector)],[0,imag(meanVector)],'g-', 'linewidth', 2);
  hold off;  
end

% Fill the created circular barchart
function fillCircularBarchart(t, r, palette)
  [xout, yout] = pol2cart(t, r);
  set(gca, 'nextplot', 'add');
  h = fill(xout, yout, palette.fc);
  set(h,'edgecolor', palette.bc);
end

% This function calculates the polar plots coordinates.
function [t,r] = createCircularBarchart(values)

  % -----------------------
  %  Calculate coordinates
  % -----------------------
  [t,~] = rose([0,2*pi], length(values));
  
  r = zeros(size(t));
  r(2:4:length(r)-2) = values;
  r(3:4:length(r)-1) = values;
  % -----------------------

end

% Make column vector
function colVector = toCol(inputVector)
  colVector = inputVector;
  
  [r,c] = size(colVector);
  
  if c>r
    colVector = colVector'; 
  end
  
end
