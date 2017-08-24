function [resultStructure,parameters] = calculateSegmentFiringStatistic(inputStructure, parameters)

  

  segmentStructure = collectSegments(inputStructure, parameters.statistic);

  eventVector   = getMarkersByField(inputStructure, parameters.statistic.event);
    
  [meanEventFreq, sumOfEvents, sumOfLength] = ...
      calculateMeanFrequency(segmentStructure, eventVector);
  
  [segmentStructure(:).meanFrequency] = deal(meanEventFreq{:});
  [segmentStructure(:).sumEvent]      = deal(sumOfEvents{:});
  [segmentStructure(:).sumLength]     = deal(sumOfLength{:});
  resultStructure = segmentStructure;
  
  printResults(resultStructure);

end

function [meanEventFreq,sumOfEvents,sumOfLength] ...
    = calculateMeanFrequency(segmentStructure, eventVector)

  %% --------------------------------------
  %  Initialization
  %% --------------------------------------
  nSegments = length(segmentStructure);
  meanEventFreq = cell(nSegments,1);  
  sumOfEvents = cell(nSegments,1);
  sumOfLength = cell(nSegments,1);
  %% --------------------------------------
  
  for i = 1 : nSegments
    segmentEventArray = collectEventInSegment(eventVector, segmentStructure(i));
    segmentEventCountVector = countEventInSegment(segmentEventArray);
    segmentLengthVector = calculateSegmentLength(segmentStructure(i));
    segmentEventCountVector(segmentLengthVector==0)=[];
    segmentLengthVector(segmentLengthVector==0) = [];
    meanEventFreq{i} = nanmean(segmentEventCountVector./segmentLengthVector);
    sumOfEvents{i} = sum(segmentEventCountVector);
    sumOfLength{i} = sum(segmentLengthVector);
  end

end

function segmentEventCountVector = countEventInSegment(segmentEventArray)
  segmentEventCountVector = cellfun(@length,segmentEventArray);
end

function segmentLengthVector = calculateSegmentLength(segmentStructure)
  segmentLengthVector = segmentStructure.end - segmentStructure.start;
end

function printResults(resultStructure)
  for i = 1 : length(resultStructure)
    fprintf('%s:', resultStructure(i).title);
    fprintf('%d event on %.3f sec (%.2fHz)\n', ...
        resultStructure(i).sumEvent, ...
        resultStructure(i).sumLength, ...
        resultStructure(i).meanFrequency);
  end
end