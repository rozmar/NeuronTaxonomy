function plotMVDByArrow(resultStructure, parameters)

  if isMultiChannel(parameters)&&parameters.analysis.numOfChannel>1
    numberOfChannels = parameters.analysis.numOfChannel;
    resultStructureArray = cell(numberOfChannels,1);
    for ch = 1 : numberOfChannels
      resultStructureArray{ch} = resultStructure(ch); 
    end
  else 
    numberOfChannels = 1;
    resultStructureArray = {resultStructure};
  end

  figure;
  handles = cell(1+numberOfChannels,1);
  for rs = 1 : numberOfChannels
      
      resultStructure = resultStructureArray{rs};

      
      %% ------------------------------
      %  Get result data
      %% ------------------------------
      meanVector       = resultStructure.meanVector;
      segmentSlice     = resultStructure.segmentSlice;
      segmentSliceTime = resultStructure.segmentSliceTime;
      segmentLabel     = resultStructure.segmentLabel;
      eventPerCycle    = resultStructure.eventPerCycle;
      cycleMarker      = resultStructure.cycleMarker;
      nSegment         = length(meanVector);
      %% ------------------------------

      % Duplicate the last marker's label
      oldSegmentLab = segmentLabel;
      segmentLabel = duplicateLastLabel(segmentLabel);

      lastEndTime = 0;  
      for s = 1 : nSegment;    
        % Calculate the absolute end of this segment
        thisTime    = segmentSliceTime{s};

        %% ---------------------
        % Assemble the plot
        %% ---------------------
        spBottom = subplot(1+3*numberOfChannels,1,1+(rs-1)*3+(1:3));
        hold on;

        % Plot the segments' signal
        plotSegmentSignalWithTime(segmentSlice{s}, translateValues(thisTime, lastEndTime));

        % Plot dashed line to segment borders
        if s>1
          plotSegmentBorders(lastEndTime, 1);
        end

        % ---------------------
        % Plot the cycle markers
        % ---------------------
        thisCycleMarker = cycleMarker(segmentLabel==s); % filter cycles of segment
        markerOffset    = calculateMarkerOffset(thisTime, thisCycleMarker, lastEndTime); % absolute value
        cycleMarkers    = plotCycleMarkers(thisCycleMarker, markerOffset, 0.1); % plot makers
        thisEventMarker = sort(cell2mat(eventPerCycle(oldSegmentLab==s)));
        translatedEvent = translateMarkers(thisTime, thisEventMarker, lastEndTime);
        hold off;
        %% ---------------------

        % Calculate the end of the merged signal
        fprintf('%d. segment abs. start: %f\n', s, lastEndTime);
        lastEndTime = lastEndTime + getSegmentDurationFromTime(thisTime);

        %% ---------------------
        %  Plot the mean vector
        %  directions with arrow
        %% ---------------------    
        cycleVectors = meanVector{s}; % Mean vector of cycles in current segment
        nVector      = length(cycleVectors);
        for i = 1 : nVector

          if isnan(cycleVectors(i))
            continue;
          end

          arrowPosition = cycleMarkers(i) + (diff(cycleMarkers([i,i+1]))/2);
          arrowCoords = createTransformedArrow(angle(cycleVectors(i)), [arrowPosition;1], 0.05);
          colorValue  = getColorToIntensity(abs(cycleVectors(i)), colormap('jet'));

          hold on;
          plotShapeFromMatrix(arrowCoords, colorValue);
          hold off;
        end
        %% ---------------------    

        %% ---------------------
        %  Calculate the frequency
        %  of the cycles in segment
        %% ---------------------        
        segmentFreqs  = 1./(diff(thisCycleMarker)); 
        hold on;
        plotFrequencyColorBar(segmentFreqs, cycleMarkers, 2, 0.2);
        hold off;
        %% ---------------------   

        %% ---------------------
        %  Calculate the instantaneous
        %  frequency in during cycles  
        %% ---------------------
        instantFreq  = 1./(diff(thisEventMarker)); 
        spTop =  subplot(1+3*numberOfChannels,1,1);
        hold on;
        plot(translatedEvent, [NaN;instantFreq], 'b-', 'LineWidth', 2);
        hold off;
        %% ---------------------   

      end

      xlim(spBottom, [0,lastEndTime]);
      xlim(spTop, [0,lastEndTime]);
      ylim(spBottom, [-1,2.3]);

      colormap('jet');

      handles{1} = spTop;
      handles{rs+1} = spBottom;
  end
  
  %% --------------------------
  %  Create control buttons
  %% --------------------------
  uicontrol('Style', 'pushbutton', ...
      'String', '<<',...
      'Units', 'normalized', ...
      'Position', [0.35 0.01 0.03 0.05],...
      'Callback', {@stepWindow, -0.5, lastEndTime, handles});
  uicontrol('Style', 'pushbutton', ...
      'String', '<',...
      'Units', 'normalized', ...
      'Position', [0.38 0.01 0.03 0.05],...
      'Callback', {@stepWindow, -0.1, lastEndTime, handles});  
  
  uicontrol('Style', 'pushbutton', ...
      'String', '---',...
      'Units', 'normalized', ...
      'Position', [0.41 0.01 0.03 0.05],...
      'Callback', {@zoomIn, -10, lastEndTime, handles});  
  uicontrol('Style', 'pushbutton', ...
      'String', '--',...
      'Units', 'normalized', ...
      'Position', [0.44 0.01 0.03 0.05],...
      'Callback', {@zoomIn, -2, lastEndTime, handles});
  uicontrol('Style', 'pushbutton', ...
      'String', '-',...
      'Units', 'normalized', ...
      'Position', [0.47 0.01 0.03 0.05],...
      'Callback', {@zoomIn, -1, lastEndTime, handles});  
  
  uicontrol('Style', 'pushbutton', ...
      'String', '+',...
      'Units', 'normalized', ...
      'Position', [0.5 0.01 0.03 0.05],...
      'Callback', {@zoomIn, 1, lastEndTime, handles});
  uicontrol('Style', 'pushbutton', ...
      'String', '++',...
      'Units', 'normalized', ...
      'Position', [0.53 0.01 0.03 0.05],...
      'Callback', {@zoomIn, 2, lastEndTime, handles});
  uicontrol('Style', 'pushbutton', ...
      'String', '+++',...
      'Units', 'normalized', ...
      'Position', [0.56 0.01 0.03 0.05],...
      'Callback', {@zoomIn, 10, lastEndTime, handles});
  
  
  uicontrol('Style', 'pushbutton', ...
      'String', '>',...
      'Units', 'normalized', ...
      'Position', [0.59 0.01 0.03 0.05],...
      'Callback', {@stepWindow, 0.1, lastEndTime, handles});
  uicontrol('Style', 'pushbutton', ...
      'String', '>>',...
      'Units', 'normalized', ...
      'Position', [0.62 0.01 0.03 0.05],...
      'Callback', {@stepWindow, 0.5, lastEndTime, handles});
  
  uicontrol('Style', 'pushbutton', ...
      'String', '>',...
      'Units', 'normalized', ...
      'Position', [0.59 0.01 0.03 0.05],...
      'Callback', {@stepWindow, 0.1, lastEndTime, handles});
  uicontrol('Style', 'pushbutton', ...
      'String', '>>',...
      'Units', 'normalized', ...
      'Position', [0.62 0.01 0.03 0.05],...
      'Callback', {@stepWindow, 0.5, lastEndTime, handles});
  %% --------------------------
  
end

function stepWindow(~, ~, stepSize, maxValue, handles)
  currentXLimit = xlim;
  range = diff(currentXLimit);
  currentXLimit = currentXLimit + [1,1].*(range*stepSize);
  if currentXLimit(2) > maxValue
    currentXLimit = [1,1].*maxValue - [range,0];
  end  
  if currentXLimit(1)<0
    currentXLimit = [0,range]; 
  end
  
  for i = 1 : length(handles)
    xlim(handles{i}, currentXLimit);
  end
end

function zoomIn(~, ~, stepSize, maxValue, handles)
  currentXLimit = xlim;
  if stepSize>0 && diff(currentXLimit)>2*stepSize
    currentXLimit = currentXLimit + [stepSize,-stepSize];  
  elseif stepSize<0
    currentXLimit = currentXLimit + [stepSize,-stepSize];
    range = diff(currentXLimit);
    if currentXLimit(1)<0 || currentXLimit(2)>maxValue
      currentXLimit = [0,maxValue]; 
    end
  end
  
  for i = 1 : length(handles)
    xlim(handles{i}, currentXLimit);
  end
end

% Find the appropriate color for a given intensity value
function colorValue = getColorToIntensity(intensity, colorMap, intensityRange)

  if nargin<3
    intensityRange = [0,1];
  end

  colorBounds = getColorIntensityBorders(colorMap, intensityRange);

  intensity   = min(intensity, intensityRange(2));
 [~,colorI]   = histc(intensity, colorBounds);
 colorI = min(colorI, size(colorMap,1));
 
 colorValue   = colorMap(colorI,:);
end

% Creates the intensity borders for colormap
function colorBorders = getColorIntensityBorders(cmap, intensityRange)
  nColor       = size(cmap,1);    % number of colors
  colorBorders = linspace(intensityRange(1), intensityRange(2)+eps, nColor+1); %create borders
end

% Create and transform an arrow
function arrowCoords = createTransformedArrow(rotationAngle, translationVector, scalingFactor)
  arrowCoords = drawArrowHead;
  arrowCoords = rotateShape(arrowCoords, rotationAngle);
  arrowCoords = scaleShape(arrowCoords, scalingFactor);
  arrowCoords = translateShape(arrowCoords, translationVector);

end

% Plot the cycle end markers
function cycleMarkers = plotCycleMarkers(cycleMarkers, offset, yRange)
  cycleMarkers = translateValues(cycleMarkers, offset);

  for i = 1 : length(cycleMarkers)
    plot([1,1].*cycleMarkers(i), [-1,1].*yRange, 'r-', 'linewidth', 2); 
  end
end

function plotFrequencyColorBar(cycleFrequency, cycleMarkers, yOffset, barHeight)
  nCycle = length(cycleFrequency);
  
  for i = 1 : nCycle
    colorValue = getColorToIntensity(cycleFrequency(i), colormap('copper'), [0,14]);
    plotRectangle([cycleMarkers(i),yOffset+barHeight], [cycleMarkers(i+1),yOffset], colorValue);
  end
end

% Calculates the offset for cycle markers. The lastAbsolute is the absolute
% value of the segment. This base is the segments real value. Marker vector
% contains the real timevalues for the markers.
function offset = calculateMarkerOffset(thisBase, markerVector, lastAbsolute)
  difference = markerVector(1) - thisBase(1);
  offset     = difference + lastAbsolute;
end

% Shift the values of the vector to the newZero position
function newValues = translateValues(oldValues, newZero)
  newValues  = oldValues - oldValues(1) + newZero;
end

function translatedMarkers = translateMarkers(baseTime, eventMarker, lastTime)
  eventOffset       = calculateMarkerOffset(baseTime, eventMarker, lastTime);
  translatedMarkers = translateValues(eventMarker, eventOffset);
end

% Plots the signal of a segment with the given time vector
function plotSegmentSignalWithTime(signalSlice, sliceTime)
    plot(sliceTime, signalSlice, 'b-');
end

% Plot the borders of a segment
function plotSegmentBorders(timeValue, yRange)
  plot([1,1].*timeValue, [-1,1].*yRange, 'k--', 'linewidth', 2);
end

% Calculates the duration as the length of a time vector
function duration = getSegmentDurationFromTime(sliceTime)
  duration = diff(sliceTime([1,end]));
end

% Duplicates the last label of each segment to indicate the last marker
function duplicatedLabel = duplicateLastLabel(initialLabel)

  duplicatedLabel = initialLabel;
  availableLabel  = unique(initialLabel);

  for i = 1 : length(availableLabel)
    segmentLastIndex = find(initialLabel==availableLabel(i),1,'last');
    duplicatedLabel  = insertToVector(duplicatedLabel, segmentLastIndex+1, availableLabel(i));
  end
end

% Inserts the given element into the given vector to the given position
function newVector = insertToVector(oldVector, position, element)
  newVector = [oldVector(1:position-1);element;oldVector(position:end)];
end