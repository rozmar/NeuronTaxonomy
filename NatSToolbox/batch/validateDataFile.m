function [resultStructure, newparameters] = validateDataFile(inputStructure, parameters)

  fprintf('Check delta waves\n');
  validateDelta(inputStructure);
  fprintf('Check spindle waves\n');
  validateSpindle(inputStructure);
  fprintf('Check K-Complex\n');
  validateKComplex(inputStructure);
  fprintf('Check spindle-delta overlap\n');
  checkDifferentSegmentOverlap(inputStructure, 'delta', 'spdl');
  
  resultStructure = [];
  newparameters = parameters;
end

function validateSpindle(inputStructure)
  % Check if the spindle start and end fields exist
  checkFieldExist(inputStructure, 'spdl_st');
  checkFieldExist(inputStructure, 'spdl_end');
  % Check if the spindle trough markers exists
  checkFieldExist(inputStructure, 'spdl_0');
  
  % Collect the segments
  spindleStructure = getSingleSegment(inputStructure, ...
      struct('name','spdl','title','Spindle'));
  
  % Validate segments: has the same number of start & end
  nSpdl = validateSegmentStructure(spindleStructure);
  
  % Check overlapping spindle segments
  checkOverlap(spindleStructure, nSpdl);  
  
  % Warn if some spindle is too small or large
  checkLengthConstraints(spindleStructure, 0.4, 2);
  
  troughVector = getMarkersByField(inputStructure, 'spdl_0');
  
  troughInSpindle = collectEventInSegment(troughVector, spindleStructure);
  
  checkTriggerOutsideSegment(troughVector, troughInSpindle);
    
end

% This function compares two set of trigger. First parameter is the global
% event vector, the second parameter is the vector of triggers during the
% segment. If the length of the two vector is the same, then all trigger is
% inside a segment. Else, the function go through the first vector and
% display the time of outliers.
function checkTriggerOutsideSegment(triggerVector, triggerInSegment)
  
  inSegmentTriggers = [];
  for i = 1 : length(triggerInSegment)
    inSegmentTriggers = cat(1, inSegmentTriggers, triggerInSegment{i});
  end
  
  if length(triggerVector)~=length(inSegmentTriggers)
    errorMsg = sprintf('Some of the triggers fall outside of its segment!\n');
    for i = 1 : length(triggerVector)
      if ~any(triggerVector(i)==inSegmentTriggers)
        errorMsg = sprintf('%s%f\n', errorMsg, triggerVector(i)); 
      end
    end
    error(errorMsg);
  end
  
end

function validateDelta(inputStructure)

  % Check if the delta start and end fields exist
  checkFieldExist(inputStructure, 'delta_st');
  checkFieldExist(inputStructure, 'delta_end');
  
  % Collect the segments
  deltaStructure = getSingleSegment(inputStructure, ...
      struct('name','delta','title','Delta'));
  
  % Validate segments: has the same number of start & end
  nDelta = validateSegmentStructure(deltaStructure);
  
  % Check overlapping delta segments
  checkOverlap(deltaStructure, nDelta);
  
  % Warn if some delta is too small or large
  checkLengthConstraints(deltaStructure, 0.1, 1);
  
end

function checkDifferentSegmentOverlap(inputStructure, firstChannel, secondChannel)
  firstSegmentStructure = getSingleSegment(inputStructure, ...
      struct('name',firstChannel,'title',firstChannel));
  secondSegmentStructure = getSingleSegment(inputStructure, ...
      struct('name',secondChannel,'title',secondChannel));
  
  pooledSegment = struct('start',[firstSegmentStructure.start;secondSegmentStructure.start], ...
      'end', [firstSegmentStructure.end;secondSegmentStructure.end],...
      'title', 'Spindle & delta');
  
  checkOverlap(pooledSegment, length(pooledSegment.start));
end

function checkOverlap(segmentStructure, nSegment)

  % Put each interval end to the same vector
  allIntervalEnd      = cat(1,segmentStructure.start,segmentStructure.end);
  % Add interval type (start or end) to that vector
  allIntervalEnd(:,2) = cat(1, ones(nSegment,1), ones(nSegment,1)*2);
  
  % Sort them by time
  [~,newOrder] = sort(allIntervalEnd(:,1));
  % Reorder edges
  allIntervalEnd = allIntervalEnd(newOrder,:);
  
  openedInterval = 0;
  for i = 1 : size(allIntervalEnd,1)
      
    % Open or close interval respectively
    if allIntervalEnd(i,2)==1
      openedInterval = openedInterval + 1;
    elseif allIntervalEnd(i,2)==2
      openedInterval = openedInterval - 1;
    end
    
    % Check possible error of intervals
    if openedInterval<0
      showError(sprintf('Surplus %s end found at %.3f.', segmentStructure.title, allIntervalEnd(i,1)));
    elseif openedInterval>1
      showError(sprintf('Some %s overlap found around %.3f', segmentStructure.title, allIntervalEnd(i,1)));
    end
    
  end
end

% Checks if the K-Complex markers are correct. Marking is correct if
% K-Complex is only during delta, and during one delta only one K-Complex
% appears.
function validateKComplex(inputStructure)

  % Check if k-complex marker exists
  checkFieldExist(inputStructure, 'kcomplex');
  % Get K-Complex markers
  kComplexVector = inputStructure.kcomplex.times;
  % Collect the segments
  deltaStructure = getSingleSegment(inputStructure, ...
      struct('name','delta','title','Delta'));
  
  % Find K-Complex in delta
  kComplexInDelta = collectEventInSegment(kComplexVector, deltaStructure);
  % Check if there is any K-Complex outside the delta
  checkTriggerOutsideSegment(kComplexVector, kComplexInDelta);
end

% Check if the segments violate any length constraint (minimal or maximal
% length).
function checkLengthConstraints(segmentStructure, minLength, maxLength)

  segmentEnds = cat(2, [segmentStructure(:).start], [segmentStructure(:).end]);
  segmentLengths = diff(segmentEnds, 1, 2);
  allSegment = size(segmentEnds,1);
  
  warning off backtrace;
  
  if any(segmentLengths<minLength)
    smallSegment = sum(segmentLengths<minLength);
    warning('%d/%d (%.2f%%) %s is narrower than %.3f s', smallSegment, allSegment, 100*smallSegment/allSegment, segmentStructure.title, minLength);
    
    for i = 1 : length(segmentLengths)
      if segmentLengths(i)<minLength
        fprintf('Start: %.3f, Length: %.3f\n', segmentEnds(i,1), segmentLengths(i)); 
      end
    end
    
  end
  
  if any(segmentLengths>maxLength)
    largeSegment = sum(segmentLengths>maxLength);
    warning('%d/%d (%.2f%%) %s is wider than %.3f s', largeSegment, allSegment, 100*largeSegment/allSegment, segmentStructure.title, maxLength);
    
    for i = 1 : length(segmentLengths)
      if segmentLengths(i)>maxLength
        fprintf('Start: %.3f, Length: %.3f\n', segmentEnds(i,1), segmentLengths(i)); 
      end
    end
    
  end
  
  warning on backtrace;
  
end