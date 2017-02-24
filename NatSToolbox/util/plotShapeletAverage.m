function handleVector = plotShapeletAverage(averageStructure)

  resampledArray = averageStructure.resampledMatrix;
  commonTime     = averageStructure.commonTime;
  nFilter        = length(resampledArray);
  
  handleVector = zeros(2*nFilter,1);

  handleVector(1:nFilter)     = plotAverage(commonTime, resampledArray, 'bdl');
  handleVector(nFilter+1:end) = plotAverage(commonTime, resampledArray, 'sup');
  
end

function hVector = plotAverage(commonTime, resampledArray, mode)

  % Color specifier
  plotColors = 'rbgcmk';
  hVector = zeros(length(resampledArray), 1);
  for p = 1 : length(resampledArray)
      
    thisMatrix = resampledArray{p};
    
    hVector(p) = figure;
    
    if strcmpi(mode, 'bdl')
      boundedline(commonTime, mean(thisMatrix,1), std(thisMatrix,0,1), [plotColors(p),'-']);
    elseif strcmpi(mode, 'sup')
      plot(commonTime, thisMatrix);
    end
  end
end