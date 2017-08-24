function [resultStructure,parameters] = collectPeritriggerDistributions(inputStructure, parameters)

  % Calculate peritrigger distribution and find peaks on it
  [resultStructure,parameters] = ...
      calculatePeritriggerDistribution(inputStructure, parameters);
  close gcf;
  
  % Get position of the maximal detected peak
  maxPeakPosition = getMaximalPeak(resultStructure);
  
  % Get the time and value vector for slope calculation
  [timeVector, sliceVector] = ...
      deal(resultStructure.densityTime, resultStructure.densityFunction);
  
  slopeVector = findFittingLines(timeVector, sliceVector, maxPeakPosition);
  
  fprintf('%f %f\n', circ_rad2ang(atan(slopeVector./1000)));
  
  plotDataWithSlope(timeVector, sliceVector', slopeVector, maxPeakPosition);
  title(strrep(inputStructure.title,'_','\_'));
  
  resultStructure.slopeVector = slopeVector;
  
end

% Get the maximal peak index
function maxPeakPosition = getMaximalPeak(resultStructure)
  peakIndices = resultStructure.peakLocations;
  peakValues  = resultStructure.densityFunction(peakIndices);
  [~,maxPeakPosition] = max(peakValues);
  maxPeakPosition = peakIndices(maxPeakPosition);
end


function plotDataWithSlope(timeVector, sliceMatrix, slopeVector, extremePoint)
  
  figure;
  hold on;
  
  plot(timeVector, sliceMatrix, 'b-', 'linewidth', 2);
  plot(timeVector(extremePoint), sliceMatrix(extremePoint), 'ro', 'markerfacecolor', 'r');
  for i = 1 : size(sliceMatrix,1)
    
    upSlope = slopeVector(i,1).*timeVector(1:extremePoint);
    upSlope = (sliceMatrix(i,extremePoint)-max(upSlope)) + upSlope;
    downSlope = slopeVector(i,2).*timeVector(extremePoint:end);
    downSlope = (max(upSlope)-max(downSlope)) + downSlope;
    
    plot(timeVector(1:extremePoint), upSlope, 'r--', 'linewidth', 2);
    plot(timeVector(extremePoint:end), downSlope, 'g--', 'linewidth', 2);
  end
  
  hold off;
  
end

function slopeVector = findFittingLines(timeVector, sliceVector, extremeValue)

    % Find the different parts of the slice
    firstPartIndex  = (1:extremeValue);
    secondPartIndex = (extremeValue:length(sliceVector));
    
    % Fit line to both parts
    firstLine  = polyfit(timeVector(firstPartIndex), sliceVector(firstPartIndex), 1);
    secondLine = polyfit(timeVector(secondPartIndex), sliceVector(secondPartIndex), 1);
    
    % Get the slope from equation
    slopeVector = [firstLine(1) secondLine(1)];
end