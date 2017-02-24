% Plots the peritrigger histogram.

function plotPeritriggerEvent(resultStructure, parameters)

  %% ----------------------------
  %  Collect data
  %% ----------------------------
  if isempty(resultStructure)
    return;
  end
  
  valueVector = getCurrentValue(resultStructure, 'mean', parameters.plot.yScale);
  
  if needSem(parameters, resultStructure)
    semVector = getCurrentValue(resultStructure, 'sem', parameters.plot.yScale);
  else
    semVector = zeros(size(valueVector));
  end
  %% ----------------------------
  
  %% ---------------------------
  %  Log result if needed
  %% ---------------------------
  if toLog
    global logFile; %#ok<TLEV>
    fprintf(logFile, 'mean %s by category\n', parameters.plot.yScale);
    for i = 1 : size(valueVector,1)
      fprintf(logFile, 'Category %d;', i);  
      for j = 1 : size(valueVector,2)
        if j>1
          fprintf(logFile,';');
        end
        fprintf(logFile, '%f', valueVector(i,j)); 
      end
      fprintf(logFile, '\n');
    end
    
    if needSem(parameters, resultStructure)
      fprintf(logFile, 'sem %s by category\n', parameters.plot.yScale);
      for i = 1 : size(semVector,1)
        fprintf(logFile, 'Category %d;', i);  
        for j = 1 : size(semVector,2)
          if j>1
            fprintf(logFile,';');
          end
          fprintf(logFile, '%f', semVector(i,j)); 
        end
        fprintf(logFile, '\n');
      end 
    end
  end
  %% ---------------------------
  
  %% ----------------------------
  %  Generate plot title prefix
  %% ----------------------------
  mainTitle = generateTitle(parameters, resultStructure.mode);
  %% ----------------------------
  
  %% ----------------------------
  %  Do the plot
  %% ----------------------------
  figure;
  if size(valueVector, 1)==1
    parameters.plot.title = mainTitle;
    plotOneCategory(valueVector, semVector, parameters.plot); 
  else
    [r,c] = getSubplotDimension(size(valueVector, 1), 'rect');
    for i = 1 : size(valueVector, 1)
      subplot(r,c,i);
      parameters.plot.title = '';
      plotOneCategory(valueVector(i,:), semVector(i,:), parameters.plot, strjoin({'Category',num2str(i)})); 
    end
    suptitle(mainTitle);
  end
  %% ----------------------------
  
  %% ----------------------------
  %  Save the plot
  %% ----------------------------
  if isSave(parameters)
    savePlot(gcf, resultStructure.mode, parameters);
  end
  %% ----------------------------
  
  %% ----------------------------
  %  Do the raster
  %% ----------------------------  
  if needRaster(parameters)
    figure;
    plotPeritriggerEventRaster(resultStructure.peritriggerEvents, parameters.plot);
    suptitle(generateRasterTitle(parameters, resultStructure.mode));
  end
  %% ----------------------------  
  
end

%% =========================
%  Save plot function
%% =========================
% Save the plot to the output directory.
function savePlot(figHandle, plotMode, parameters)

  outputDirName  = getOutputDir(parameters);
  outputFileName = generateFileName(parameters, plotMode);
  outputFileName = strjoin({outputFileName,parameters.plot.mode},'_');
  
  if needCategory(parameters)
    outputFileName = strcat(outputFileName,'_bycategory');
  end
  
  saveas(figHandle, strcat(outputDirName,'fig/',outputFileName,'.fig'));
  print(figHandle, strcat(outputDirName,'png/',outputFileName,'.png'), '-dpng');
end

% Generate filename for the plots
function generatedFileName = generateFileName(parameters, plotMode)

  if strcmpi(plotMode, 'single')
    prefix = parameters.plot.fileName;
  else
    prefix = 'average';
  end
  
  generatedFileName = strjoin({prefix,lower(parameters.channel.event.title),'around', lower(parameters.channel.trigger.title)},'_');
end

% Plot histogram for a single category. It expects in parameter the mean
% vector of one category, and optionally, the sem vector for that category.
% Suffix will be the category name (or empty string, if one category
% present). The parameters are the plotParameters.
function plotOneCategory(meanVector, semVector, parameters, suffix)

  % Add category name to the title
  if nargin>3
    parameters.title = strjoin({parameters.title, suffix});
  end

  plotMeanAndSem(meanVector, semVector, parameters);
  
  yLimits = ylim;
  yLimits(1) = 0;
  ylim(yLimits);
end
%% =========================

% Get the specified values from the given input structure. The
% possibilities are: 
%  - mean, count or frequency
%  - mean or sem
% If have only one category, the return value will be a vector. If we use
% more than one category, the result will be cxb matrix, (c - number of
% categories, b - number of bins)
function valueVector = getCurrentValue(inputStructure, valueType, valueMode)
 
  fieldName = strjoin({valueType, upper(valueMode(1)), 'Histogram'}, '');
  
  valueVector = inputStructure.(fieldName);
end

% Generate plot title based on the plotting type (overall or single)
function generatedTitle = generateTitle(parameters, plotMode)
  if strcmpi(plotMode, 'single')
    generatedTitle = strjoin({parameters.plot.title, 'for', strrep(parameters.plot.fileName,'_','\_')});
  else
    generatedTitle = strjoin({'Average', parameters.plot.title});
  end
  generatedTitle = strjoin({generatedTitle, toStringAllCondition(parameters.channel)},' ');
end

function generatedTitle = generateRasterTitle(parameters, plotMode)
  if strcmpi(plotMode, 'single')
    generatedTitle = strjoin({'Raster for', strrep(parameters.plot.fileName,'_','\_'), toStringAllCondition(parameters.channel)});
  else
    generatedTitle = strjoin({'Average raster', toStringAllCondition(parameters.channel)});  
  end
end

% Decide the necessity of the raster plot
function decision = needRaster(parameters)
  decision = parameters.plot.raster;
end

% Decide the necessity of the SEM values
function decision = needSem(parameters, resultStructure)
  decision = ~(strcmpi(parameters.plot.mode,'mean') || strcmpi(resultStructure.mode, 'single'));
end