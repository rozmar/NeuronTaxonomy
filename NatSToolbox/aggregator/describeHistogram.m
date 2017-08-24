function describeHistogram(resultStructArray, parameters)

   resultStructArray = convertArrayOfStruct(resultStructArray);
   
   allHistogramMatrix = collectAllHistogram(resultStructArray);
   
   timeVector = createTimeVector(size(allHistogramMatrix,2), parameters.source.range);
   
   [sliceMatrix,timeSlice] = cutSliceHistogram(allHistogramMatrix, timeVector,  round(parameters.analysis.range./min(diff(timeVector))));
   
   slopeVector = alignAllSlope(sliceMatrix, timeSlice);
      
   plotDataWithSlope(timeSlice, sliceMatrix, slopeVector, find(timeSlice==0));
   
   printSlope(resultStructArray, slopeVector);
end

function allHistogramMatrix = collectAllHistogram(resultStructure)

  nHistogram = length(resultStructure);
  allHistogramMatrix = zeros(nHistogram, size(resultStructure(1).value,2));
  
  for i = 1 : nHistogram
    allHistogramMatrix(i,:) = resultStructure(i).value; 
  end
end

function timeVector = createTimeVector(binNumber, range)
  timeVector = linspace(range(1), range(2), binNumber+1);
end

function [sliceMatrix,timeSlice] = cutSliceHistogram(histogramMatrix, timeVector, range)

  sliceIndexMatrix = findSliceIndices(0, timeVector, range);
  sliceMatrix      = histogramMatrix(:,sliceIndexMatrix);
  timeSlice        = timeVector(sliceIndexMatrix);

end

function printSlope(resultStructure, slopeValues)
  fprintf('%25s%25s%25s\n', 'Cell name', 'Slope before Hz/10ms', 'Slope after Hz/10ms');
  for i = 1 : length(resultStructure)
    fprintf('%25s%25.f%25.f\n', resultStructure(i).name, slopeValues(i,1)/100, slopeValues(i,2)/100);
  end
end

function plotDataWithSlope(timeVector, sliceMatrix, slopeVector, extremePoint)
  figure;
  hold on;
  
  plot(timeVector, sliceMatrix, '-', 'linewidth', 2);
  
  for i = 1 : size(sliceMatrix,1)
    
    upSlope = slopeVector(i,1).*timeVector(1:extremePoint);
    upSlope = upSlope - min(upSlope);
    downSlope = max(upSlope) + slopeVector(i,2).*timeVector(extremePoint:end);
    
    plot(timeVector(1:extremePoint), upSlope, 'b-');
    plot(timeVector(extremePoint:end), downSlope, 'g-');
  end
  
  hold off;
  
end

function slopeVector = alignAllSlope(sliceMatrix, timeVector)
  nSlice      = size(sliceMatrix,1);
  slopeVector = zeros(nSlice,2);
  
  for i = 1 : nSlice
     slopeVector(i,:) = findFittingLines(timeVector, sliceMatrix(i,:), find(timeVector==0));
  end
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