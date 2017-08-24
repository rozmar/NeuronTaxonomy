function plotPEC(resultStructure, parameters)
  
  if strcmpi(resultStructure.mode, 'single');
    
    parameters.plot.mode     = 'avg';                 % Single plot can only be 'avg'
    parameters.plot.fileName = resultStructure.fname; % Get filename for suffix
    
    yValue = getValue(resultStructure, getScale(parameters), '');% Get the values to plot  
    
    plotSingleData(yValue, getType(parameters), parameters.plot);
    
    isSingle = 1;
    
  else
    
    yValue = getValue(resultStructure, getScale(parameters), 'mean');% Get the values to plot
    yError = getValue(resultStructure, getScale(parameters), 'sem'); % Get the SEM to plot
        
    mVector = resultStructure.meanVectorVector;
    
    plotMultiData(yValue, yError, mVector, getType(parameters), parameters.plot);
    
    isSingle = 0;
  end
  
  %% ------------------------
  %  Save plot if needed
  %% ------------------------
  if isSave(parameters)
    outputFilename = generateFileName(parameters, isSingle);
    outputDirname  = parameters.output.dir;
    
    saveas(gcf, strcat(outputDirname, outputFilename, '.fig'));
    print(gcf, strcat(outputDirname, 'png/', outputFilename, '.png'), '-dpng');
  end
  %% ------------------------

end


function plotMultiData(yValue, yError, meanVectorVector, plotType, parameters)
  
  figure;
  if strcmpi(plotType, 'lin')
    parameters.title = strjoin({'Overall', parameters.title, 'histogram'});
       
    plotMeanAndSem(repmat(yValue,1,2), yError, parameters);
  elseif strcmpi(plotType, 'circ')
    parameters.title = strjoin({'Overall', parameters.title, 'circular histogram'});
    
    if strcmpi(parameters.mode,'avg')||strcmpi(parameters.mode,'msd')
      plotCircularBarchart(yValue, parameters);
    elseif strcmpi(parameters.mode,'bnd')
      plotCircularBoundedline(yValue, yError, parameters, meanVectorVector);       
    end
  end
end

% Plot data for a single input
function plotSingleData(yValue, plotType, parameters)

  % Set plot title suffix
  suffix = strjoin({'histogram for', parameters.fileName});
  
  figure;
  if strcmpi(plotType, 'lin')
    parameters.title = strjoin({parameters.title, suffix});
       
    plotMeanAndSem(repmat(yValue,1,2), [], parameters);
  elseif strcmpi(plotType, 'circ')
    parameters.title = strjoin({parameters.title, 'circular', suffix});
    
    plotCircularBarchart(yValue, parameters);
  end
  
end

% Generate filename for the plots
function genFName = generateFileName(parameters, isSingle)
  
  if isSingle
    prefix = parameters.plot.fileName;
  else
    prefix = 'average';
  end
  
  genFName = strjoin({prefix, lower(parameters.channel.eventTitle),lower(parameters.channel.sectionTitle),'phase_coupling'},'_');
end

% Get the appropriate value from resultStructure
function yValue = getValue(resultStructure, plotScale, fieldPrefix)

  if strcmpi(plotScale, 'mean')
    fieldName = strcat(fieldPrefix,'mean');
  elseif strcmpi(plotScale, 'cnt')||strcmpi(plotScale, 'prob')
    fieldName = strcat(fieldPrefix,'count');
  end
  
  yValue = resultStructure.(strcat(fieldName,'Histogram'));
  
  if strcmpi(plotScale, 'prob')
    % If we want to normalize, we have to divide
    % mean with the sum of all element, but we 
    % have to divide the SEM too with the same value.
    if strcmpi(fieldPrefix,'sem')
      meanFieldName = ['mean',fieldName(4:end)];
      ySum = sum(resultStructure.([meanFieldName,'Histogram']));
    else 
      ySum   = sum(yValue);
    end
    
    yValue = yValue ./ ySum;
    
  end
  
end

% Get the type of plot
function plotType = getType(parameters)
  plotType = parameters.plot.type;
end

% Get what to show on plot
function plotScale = getScale(parameters)
  plotScale = parameters.plot.yScale;
end