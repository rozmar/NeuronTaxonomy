% findSliceIndices find the indices of sample points around the trigger
% with given radius.
% 
% Parameters
%  - triggerVector - tx1 vector which contains the reference points
%  - timeVector    - sx1 vector which contains the timestamp for each
%  signal-point.
%  - radiusPoint   - scalar or 1x2 vector which contains the radius around
%  the trigger to cut measured in sampling point. If scalar was given, the
%  radius will be symmetric.
%
% Return value
%  - sliceIndexMatrix - txr matrix, where each row contains an index vector
function sliceIndexMatrix = findSliceIndices(triggerVector, timeVector, radiusPoint)

  %% -----------------------------
  %  Initialization
  %% -----------------------------
  if length(radiusPoint)==1
    radiusPoint = [-1,1]*radiusPoint; 
  end
  
  sSlice           = diff(radiusPoint) + 1;
  nTrigger         = length(triggerVector);
  sliceIndexMatrix = zeros(nTrigger, sSlice);
  %% -----------------------------

  waitbarMsg  = 'Find section around triggers %d/%d';
  lastLabel   = sprintf(waitbarMsg, 0, nTrigger);
  multiWaitbar(lastLabel, 0);
  
  %% -----------------------------
  %  Take each trigger
  %% -----------------------------
  for i = 1 : nTrigger
      
    % Find this trigger's position
    thisTrigger   = triggerVector(i);
    [~,thisIndex] = histc(thisTrigger, timeVector);
    
    % Assign to nearest trigger
    timePoints     = [0,1] + thisIndex;
    [~,thisIndex]  = min(abs(timeVector(timePoints)-thisTrigger));
    thisIndex      = timePoints(thisIndex);
    
    % Each index during radius
    sliceIndexMatrix(i,:) = (radiusPoint(1):radiusPoint(2)) + thisIndex;

    % If slice would reach over the end of recording
    if sliceIndexMatrix(i,end)>length(timeVector) || sliceIndexMatrix(i,1)<0
      warning('Trigger was too close to the end of recording.');
      sliceIndexMatrix(i,:) = sliceIndexMatrix(i,:)*NaN;
    end
    
    newLabel  = sprintf(waitbarMsg, i, nTrigger);
    multiWaitbar(lastLabel, 'Value', (i/nTrigger), 'Relabel', newLabel );  
    lastLabel = newLabel;
    
  end
  
  % Delete invalid slice indices
  sliceIndexMatrix(logical(sum(isnan(sliceIndexMatrix),2)),:) = [];
  %% -----------------------------
  
  multiWaitbar(lastLabel, 'Close');
end