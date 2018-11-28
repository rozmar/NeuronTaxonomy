function [ apFeatures apNums ] = removeBadSpikes(apFeats,apNums)

  apFeatures = [];
    
  if size(apFeats,1)==0
    return;
  end
    
  sweepNumber  = unique(apFeats(:,1));
  nSweeps      = length(sweepNumber);
  
  for i = 1 : nSweeps
    thisSweepNumber = sweepNumber(i);
    thisSweepIdx    = (apFeats(:,1)==thisSweepNumber);
    nSpikeInSweep   = sum(thisSweepIdx);
    thisSweepSpikes = apFeats(thisSweepIdx,:);
        
%     if thisSweepSpikes(1,1)==20
%       hold on;
%       scatter(thisSweepSpikes(:,4), thisSweepSpikes(:,5), 'r', 'filled');
%       hold off;
%     end
				
	toRemove = false(nSpikeInSweep,1);
        
    for j = 1 : nSpikeInSweep
	  thisSpike    = thisSweepSpikes(j,:);
      
      if (thisSpike(15)<0.05)||(thisSpike(15)>20)||(isnan(thisSpike(15)))
        fprintf('Half-width out of range: %f', thisSpike(15)); 
        toRemove(j) = true;
      end
      
      if (thisSpike(16)<10)||(thisSpike(16)>200)
        if thisSpike(1)==20
          hold on;
          plot(thisSpike(4), thisSpike(5), 'kx', 'linewidth', 2, 'markersize', 10);
          hold off;
        end
        toRemove(j) = true;
        fprintf('Amplitude out of range: %f\n', thisSpike(16));
      end
      
      if toRemove(j) == false
          % Spike with the same threshold time will be noise
          repeatingSpike = find(thisSweepSpikes(j+1:end,4)==thisSpike(4));
          if ~isempty(repeatingSpike)
              repeatingSpike = repeatingSpike + ones(size(repeatingSpike,1),1)*j;
              toRemove(repeatingSpike) = true;
          end
      end
    end
						
    % If too many spikes have to be removed, all
    % spike will be removed
	if length(toRemove)>100
	  toRemove = true(nSpikeInSweep,1);
	end
		
	thisSweepSpikes(toRemove,:) = [];
						
    % If too many spikes left,  remove everything
    if ( size(thisSweepSpikes,1)>400 ) 
	  thisSweepSpikes((thisSweepSpikes(:,1)==thisSweepNumber),:)=[];	
    end  
        
	apFeatures = [ apFeatures ; thisSweepSpikes ];
	apNums(thisSweepNumber)=size(thisSweepSpikes,1);
  end
end