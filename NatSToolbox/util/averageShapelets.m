% 
function averageStructure = averageShapelets(shapeletStructure, timeRange)
  
  %% ---------------------------
  %  Number of cells and filters
  %% ---------------------------
  [nFilter,nCell] = size(shapeletStructure);
  %% ---------------------------
  
  %% ---------------------------
  %  Initialize
  %% ---------------------------
  % Individual mean for each cell for each filter
  averageStructure.sliceArray      = cell(nFilter, nCell);
  % Individual mean resampled
  averageStructure.resampledMatrix = cell(nFilter, 1);
  % Number of samplepoints per cell
  samplingPointNumber = zeros(nCell,1);
  %% ---------------------------
  
  %% ---------------------------
  %  Average slices per cell
  %% ---------------------------
  for c = 1 : nCell
      [averageStructure.sliceArray(:,c),samplingPointNumber(c)]...
          = averageCellSlices(shapeletStructure(:,c));
  end
  %% ---------------------------
  
  %% ---------------------------
  %  Create new time vector
  %% ---------------------------
  averageStructure.commonTime = ...
      createCommonTime(samplingPointNumber, timeRange);
  %% ---------------------------
  
  %% ---------------------------
  %  Resample and average
  %% ---------------------------
  averageStructure.filterMatrix = cell(nFilter,1);
  for f = 1 : nFilter
    
    averageStructure.resampledMatrix{f} = ...
        resampleCells(...
        shapeletStructure(f,:),...
        averageStructure.sliceArray(f,:),...
        averageStructure.commonTime);  
    
    averageStructure.filterMatrix{f} = shapeletStructure(f,1).filter;
  end
  %% ---------------------------
  
end

% This function averages the current cells shapes for each filter.
function [cellAverages,samplePoint] = averageCellSlices(thisShapelet)

  nFilter      = length(thisShapelet);  % number of filter
  cellAverages = cell(nFilter,1);       % average per filter
      
  % Calculate average for each cell for each filter
  for f = 1 : nFilter
    % Slices filtered with this parameters
    shapeMatrix     = thisShapelet(f).slices;
    % Average of this slices
    cellAverages{f} = mean(shapeMatrix, 1); 
  end
      
  % Count number of samplepoints
  samplePoint = length(thisShapelet(1).time);
end

% This function creates a time vector within the given time interval,
% with the given number of samplepoints.
function commonTime = createCommonTime(samplingPointVector, timeRange)
  commonTime = linspace(timeRange(1), timeRange(2), max(samplingPointVector));
end

% This function resamples the given slices according to the given time
% vector
function resampledMatrix = resampleCells(shapeletStructure, sliceStructure, commonTime)

  resampledMatrix = zeros(length(shapeletStructure), length(commonTime));
  
  for c = 1 : length(shapeletStructure)
      
    % Create timeseries object from data
    timeSeries = timeseries(...
        sliceStructure{c}',...
        shapeletStructure(c).time');
    
    % Resample according to new time
    newTimeSeries = resample(timeSeries, commonTime);
    resampledMatrix(c,:) = newTimeSeries.data';
    
  end
end
