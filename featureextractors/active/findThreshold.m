%
% Returns the following values:
% threshold thresholdV threshCorrector threshVCorrected
function thresholdFeatures = findThreshold(startpos,iv,derivative,thresholdValue, SI)
%%
	thresholdFeatures = [];		%collector of the features
	
	if nargin < 4
		%at which derivative find AP
		thresholdValue = 10;
    end
	
    % Old method: find dvMax from the AP max
    if nargin<6 %edited by marci from nargin<5
	  %go below 20mV
	  th = find(iv(1:startpos)<0.02,1,'last');
		
	  if size(th,2)==0
	  	th = startpos-1;
      end
	
	  %don't start too early
	  if th<5
  		th=5;
      end

	  %find the maximal derivative
	  [t tPos]=max(derivative(th-3:startpos-2));		%ezt átírni paraméteresre
	
	  threshold = th -3 + tPos;
      
    % Newer method: find dvMax
    else
      % We look back 2ms
      stepSize = round(2e-3/SI);
      if stepSize>=startpos
        stepSize = startpos-1; 
      end
      [~,threshold] = max(derivative(startpos+(-stepSize:0)));
      threshold = threshold + startpos - stepSize;
    end

	threshold=find(derivative(1:threshold)<=thresholdValue,1,'last')+1;	%find the derivative where smaller than thresholdValue
	
	if size(threshold,2)==0
	  threshold = th + tPos - 2;	
	end
	
	%don't start too early	
	if threshold<5
		threshold=5;
	end
			
	thresholdFeatures = [ thresholdFeatures threshold ];	%add threshold position to the output
		
	thresholdV = iv(threshold);			%get threshold voltage
						
	thresholdFeatures = [ thresholdFeatures thresholdV ];	%add threshold value to the output
		
	%calculate the corrector
	denominator = derivative(threshold)-derivative(threshold-1);
	if denominator == 0 
		threshCorrector = 0.5;	
	else
		threshCorrector = 1-abs((derivative(threshold)-thresholdValue) / (denominator));
		if threshCorrector > 1 || threshCorrector < 0
			threshCorrector = 0.5;
		end
	end
	
	%thresholdV = thresholdV - abs(threshCorrector*(iv(threshold) - iv(threshold-1)));	%correct the threshold value
	thresholdFeatures = [ thresholdFeatures threshCorrector thresholdV ];	%add threshold corrector and corrected value to the output
end