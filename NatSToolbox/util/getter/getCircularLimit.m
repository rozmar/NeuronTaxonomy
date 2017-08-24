% getCircularLimit find the value of the outermost circle on a circular
% plot (either barchart or bounded line). If a concrete value was given,
% the search will be based on it, else we take the maximal plot value. We
% find the next unit of a plot.
% 
% Parameters
%  valueVector - nx1 vector contains the values to plot. All of its value
%  have to fit in the limits.
%  parameters - parameter structure in which we can give our limit for
%  plot. (optional)
function circularLimit = getCircularLimit(valueVector, parameters)

  %% -----------------------------
  %  Get the initial value for search
  %% -----------------------------
  if nargin>1&&isfield(parameters,'circularLimit')&&(parameters.circularLimit~=0)
    circularLimit = parameters.circularLimit;
  else
    circularLimit = max(valueVector);
  end
  %% -----------------------------
  
  %% -----------------------------
  %  Find the xlimit for the value
  %% -----------------------------
  testWindow = figure('visible','off');
  plot([-1,1].*circularLimit, [0,0]);
  circularLimit = max(xlim);
  close(testWindow);
  %% -----------------------------
end