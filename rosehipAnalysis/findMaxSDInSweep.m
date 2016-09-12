function maxSD = findMaxSDInSweep(recRange, cutInt, nMinAP, APF)

  allSwNums  = APF(:,1);
  sweepNums  = unique(allSwNums);
  nSweep     = length(sweepNums);
  % Collect ISI which satisfy the conditions
  found = false;
  ISIvector = zeros(nSweep,1);
  for s = 1 : nSweep
          
    % Get current sweep's APs
    thisSweepNum = sweepNums(s);
    thisSweepAP  = APF(allSwNums==thisSweepNum,:);
    nAP          = size(thisSweepAP,1);
       
    % Skip sweeps which can't satisfy cond.
    if nAP<nMinAP
      ISIvector(s) = NaN;
      continue;
    end
       
    % Get the AP peak times
    thisAP = thisSweepAP(:,12);
       
    % Find AP between the given bands
    relevantRange = recRange + [1,-1]*cutInt;
    relevantAPIdx = (relevantRange(1)<=thisAP&thisAP<=relevantRange(2));
        
    % If no or less AP remained after cut, skip this sweep
    if isempty(relevantAPIdx) || length(relevantAPIdx)<nMinAP
      ISIvector(s) = NaN;
      continue; 
    end
        
    % Calculate the ISI for the remaining spikes
    thisAP  = thisAP(relevantAPIdx);
    thisISI = diff(thisAP);
       
    % Calculate the SD of ISIs
    ISIstd  = std(thisISI);
       
    % Add to the previous ISIs
    ISIvector(s) = ISIstd;
    found        = true;
  end
     
  % Select max SD
  if ~found
    fprintf('No sweep with at least %d AP has been found.\n', nMinAP);
    maxSD = NaN;
  else
    maxSD = nanmax(ISIvector);
  end
  
end