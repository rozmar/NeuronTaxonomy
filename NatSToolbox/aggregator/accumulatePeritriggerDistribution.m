function accumulatePeritriggerDistribution(resultStructureArray, parameters)

  %% -----------------------------
  %  Initial check: we don't have
  %  to accumulate single cell.
  %% -----------------------------
  if length(resultStructureArray)==1
    return; 
  end
  
  % Convert to structure array
  resultStructureArray = convertArrayOfStruct(resultStructureArray);
  %% -----------------------------
  
  averageOfMeansDistribution = calculateDistributionAverage(resultStructureArray);
  timeVector  = (parameters.analysis.radius(1):0.0001:parameters.analysis.radius(2))';

  peakLocations = findProminentPeaks(averageOfMeansDistribution, timeVector, parameters.analysis);
  title('Overall average');
  close gcf;
  
  printStatus('Overall average');
  for i = 1 : length(peakLocations)
    fprintf('%.4f\t', timeVector(peakLocations(i)));
  end
  fprintf('\n');
  
  % Get position of the maximal detected peak
  [~,maxPeakPosition] = max(averageOfMeansDistribution(peakLocations));
  maxPeakPosition = peakLocations(maxPeakPosition);
  
  slopeVector = ...
      findFittingLines(timeVector', averageOfMeansDistribution, maxPeakPosition);
  
  fprintf('%f %f\n', circ_rad2ang(atan(slopeVector./1000)));
  
  plotDataWithSlope(timeVector, averageOfMeansDistribution, slopeVector, maxPeakPosition);
  title('Overall average slope');
  
end

function averageOfMeansDistribution = calculateDistributionAverage(resultStructure)

  nResult   = length(resultStructure);
  avgMatrix = zeros(nResult, length(resultStructure(1).densityFunction));
  
  for i = 1 : nResult
    avgMatrix(i,:) = resultStructure(i).densityFunction;
  end
  
  averageOfMeansDistribution = mean(avgMatrix,1);
  
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