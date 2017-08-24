function aggregateShapelet(resultStructArray, parameters) 
  
  nFile             = length(resultStructArray);

  %% ------------------
  % If more file has been processed
  % Calculate and plot the average
  %% ------------------
  if nFile==1
    return; 
  end

  % Convert the cell array of structures to structure array
  resultStructArray = [resultStructArray{:}];
  
  % Average each shapelet for the same cell and same filter
  overallAverageStructure = averageShapelets(resultStructArray, parameters.plot.timeBound);
  
  % Plot averaged shapelets 
  handleVector = plotShapeletAverage(overallAverageStructure);
    
  if isSave(parameters)
    
    saveData(overallAverageStructure, parameters);
    
    filterMatrix = overallAverageStructure.filterMatrix;
      
    saveAverage(handleVector, filterMatrix, {'global','superimposed'}, parameters);
    
  end
  %% ------------------
end

% This function saves the collected accumulated data
function saveData(averageStructure, parameters)
  
  dataPath = strjoin({parameters.output.dir,'averageStructure.mat'}, '/');
  save(dataPath, 'averageStructure');
  
end

function saveAverage(handleVector, filterMatrix, modeArray, parameters)

  outputDir = parameters.output.dir;
  nFilter   = size(filterMatrix,1);

  for i = 1 : length(handleVector)
      
    % Mode of current plot
    thisMode   = modeArray{floor((i-1)/nFilter)+1};
    % Current plot's filter
    thisFilterText = filterToString(filterMatrix{mod(i-1,nFilter)+1});
    
    thisTitle    = strjoin({thisFilterText, thisMode, 'average'});
    thisFileName = regexprep(regexprep(thisTitle, '([\[\]]|(Hz))',''),'(,|\ )','_');
    
    % Select current figure
    figure(handleVector(i));
    
    % Set properties
    title(thisTitle);
    set(gca, 'XTickLabel', parameters.plot.xTickLabel);
    
    % Save to file
    saveas(handleVector(i), strjoin({outputDir,'fig',[thisFileName,'.fig']},'/'));
    print(handleVector(i),  strjoin({outputDir,'png',[thisFileName,'.png']},'/'), '-dpng');        
    
  end
  
end