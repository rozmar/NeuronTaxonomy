function plotPECChange(resultStructure, parameters)

  %% ----------------------------------
  %  Get results from result structure
  %% ----------------------------------
  binnedEventMatrix = resultStructure.binnedEventMatrix;
  segmentLabel      = resultStructure.segmentLabel;
  meanVector        = resultStructure.meanVector;
  %% ----------------------------------  

  %% ----------------------------------
  %  Plot individual event histogram for each cycle
  %% ----------------------------------
  if isEventDistribution(parameters)
    figure;
    plotBinnedLinearHeatmap(binnedEventMatrix, parameters.plot);
    plotSegmentBoundary(segmentLabel, ylim);
    plotTitle = strjoin({parameters.plot.fileName,'change of event distribution'});
    title(plotTitle);
  end
  %% ----------------------------------  
  
  %% ----------------------------------
  %  Plot individual MVD plot
  %% ----------------------------------  
  if isMeanVectorDirection(parameters)
    binnedVectorMatrix = binMeanVectors(meanVector, parameters);
    
    figure;
    parameters.plot.normalize = 0;
    parameters.plot.smooth.plot = 0;
    plotBinnedLinearHeatmap(binnedVectorMatrix, parameters.plot);
    parameters.plot.normalize = 1;
    parameters.plot.smooth.plot = 1;
    plotSegmentBoundary(segmentLabel, ylim);
    plotTitle = strjoin({parameters.plot.fileName,'change of mean vector direction&length'});
    title(plotTitle);
  end
  %% ----------------------------------

end

function plotSegmentBoundary(segmentLabel, yWidth)
  segmentLabels = unique(segmentLabel);
  nSegment      = length(segmentLabels);
  
  segmentChange = [0;diff(segmentLabel)];
  changeIndex   = find(segmentChange==1);
  
  hold on;
  for i = 1 : nSegment-1
    plot([1,1]*changeIndex(i), yWidth, 'k--', 'LineWidth', 2);
  end
  hold off;
  
end

function binnedVectorMatrix = binMeanVectors(meanVector, parameters)
  binNumber  = parameters.analysis.binNumber;
  binEdges   = linspace(0,2*pi,binNumber+1);
  meanVector = cell2mat(meanVector);
  nVector    = length(meanVector);
  binnedVectorMatrix = zeros(nVector, binNumber+1);
  
  for i = 1 : nVector
    thisVectorDir           = angle(meanVector(i));
    thisVectorLen           = abs(meanVector(i));
    binnedVectorMatrix(i,:) = histc(thisVectorDir,binEdges);
    if ~isnan(thisVectorLen)
      binnedVectorMatrix(i,:) = binnedVectorMatrix(i,:).*thisVectorLen;
    end
  end
  
  binnedVectorMatrix(:,end) = [];
end

function answer = isEventDistribution(parameters)
  answer = parameters.plot.plotEventDist;
end

function answer = isMeanVectorDirection(parameters)
  answer = parameters.plot.meanVectorDir;
end