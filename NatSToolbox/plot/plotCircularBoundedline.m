% plotCircularBoundedline creates a circular shaded plot which
% displays the mean and SEM of the given values. The mean value will be a 
% solid curve, the SEM will be the shaded area around it. 
% The resulant mean vector of the given values will be calculated and 
% plotted as a green line. If the single mean vector directions have been 
% given, it will be plotted on the outer circle as red dots.
%
% Parameters
%   meanVector - 1xn vector, mean values
%   semVector -  1xn vector, sem values
%   parameters - parameters structure with following fields
%     circularLimit - value of the outermost radial
%     hideLabels    - flag to hide labels or not
%     isTouching    - if given, we can control the appearance of the
%     resultant mean vector. If this flag false, resultant mean vector will
%     be proportional to the circle. Else, the vector will reach the curve
%     palette       - palette structure to set plotting colors
%     title         - title for the plot
%   meanVectorVector - if it isn't empty, contains the single resultant mean
%   vector directions in complex number representation
function plotCircularBoundedline(meanVector, semVector, parameters, meanVectorVector)

  %% --------------------------
  %  Parameter setting
  %% --------------------------
  
  % Get the limit of the circles
  circularLimit = getCircularLimit(meanVector+semVector, parameters);
  % Resultant mean vector will touch
  % the plot default. If we don't want
  % so, we can specify with that flag.
  isTouching    = ~isfield(parameters,'isTouching')||parameters.isTouching;
  %% --------------------------
  
  %% --------------------------
  %  Draw the values
  %% --------------------------
  % Draw the empty, customized polar plot
  plotCustomPolar(circularLimit);
  % Draw the bounded line on it
  drawCircularBoundedLine(meanVector, semVector, parameters.palette.fc);
  % Set title
  title(strrep(parameters.title,'_','\_'));
  %% --------------------------
  
  %% --------------------------
  %  Plot the resultant mean vector
  %% --------------------------
  resultantMeanVector = calculateMeanvector(meanVector');
  
  %  If we want the drawed line to touch the mean curve,
  %  we get the exact value at that angle. Else, we set
  %  the length relative to the outer circle's value.
  if isTouching
    newLength         = getValueAtAngle(meanVector, angle(resultantMeanVector));
  else
    newLength         = abs(resultantMeanVector)*max(abs(xlim)); 
  end
  
  resultantMeanVector = newLength * exp(1i * angle(resultantMeanVector));
  drawLine([0,0], [real(resultantMeanVector),imag(resultantMeanVector)], 'g', 3);
  %% --------------------------
  
  %% --------------------------
  %  Plot single mean directions
  %% --------------------------
  if ~isempty(meanVectorVector)
    % Push values to the outer circle
    meanVectorVector = circularLimit .* exp(1i .* angle(meanVectorVector));
    % Plot values as red dots
    plot(real(meanVectorVector),imag(meanVectorVector),'ro','MarkerFaceColor','r');
  end
  %% --------------------------

  %% --------------------------
  %  Plot single mean directions
  %% --------------------------
  if parameters.hideLabels
    removeLabelsPlot();
  end
  %% --------------------------

end

% Draw with a circular lineplot the mean, and with shaded area the SEM
function drawCircularBoundedLine(meanVector, semVector, fillColor)

  % Calculate the angles for plot    
  angles    = circ_ang2rad(linspace(0, 360, length(meanVector)+1));
  
  % Make the vector circular
  meanVector = meanVector([1:end,1]);
  semVector  = semVector([1:end,1]);
  
  % Plot the shaded area
  shadeArea(angles, meanVector+semVector, meanVector-semVector, fillColor);
  
  % On top of that, plot the mean curve
  plot(meanVector.*cos(angles), meanVector.*sin(angles), 'Color', fillColor, 'LineWidth', 3);
end

% Plot a shaded area bounded by upper and lower values
function shadeArea(angles, upperValue, lowerValue, fillColor)

  xCoords = [upperValue,lowerValue].*cos([angles,angles]);
  yCoords = [upperValue,lowerValue].*sin([angles,angles]);

  patch(xCoords, yCoords, fillColor, 'facealpha', 0.3, 'edgecolor', 'none');
end

% Get or Calculate the value at a specific angle
function value = getValueAtAngle(meanVector, expectedAngle)
  
  % Convert angle from [-pi,pi] to [0,2pi]
  if expectedAngle<0
    expectedAngle = 2*pi + expectedAngle;
  end

  % Make mean vector circular
  meanVector = meanVector([1:end,1]);
  % Generate the angles
  angles = circ_ang2rad(linspace(0, 360, length(meanVector)));
  
  % Find the value if presented 
  index = find(angles==expectedAngle,1,'first');
  
  % If we found that, that will be the real value
  if ~isempty(index)
    value = meanVector(index); 
    return;
  end
  
  % Find the neighboring points
  indices = [find(angles<expectedAngle,1,'last') find(angles>expectedAngle,1,'first')];
  
  % Neighboring values
  neighborAngles = angles(indices);
  neighborValues = meanVector(indices);
  
  % Relative angular difference between the left neighbor and the expected
  delta = (expectedAngle-neighborAngles(1))/diff(neighborAngles);
  
  % Calculate triangle sides
  cosVals = cos(neighborAngles).*neighborValues;
  sinVals = sin(neighborAngles).*neighborValues;
  
  newCos = cosVals(1) + diff(cosVals)*delta;
  newSin = sinVals(1) + diff(sinVals)*delta;
  
  % Pythagoras theorem
  value = sqrt(newCos^2 + newSin^2);
  
end
