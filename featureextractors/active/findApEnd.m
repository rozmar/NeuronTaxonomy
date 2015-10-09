%
% Returns the following values:
% apend apendV apendCorrector apendVCorrected
function apEndFeatures = findApEnd(startpos,iv,derivative,thresholdValue)
	
	apEndFeatures = [];		%collector of the features
	
	if nargin < 4
		%at which derivative find AP
		thresholdValue = 10;
	end
	
	%go below 10mV
	ae = find(iv(startpos+1:end)<=0.01,1,'first');
	
	if length(ae)==0
		ae = startpos;
	else
		ae = ae + startpos + 1;
	end
	
	%don't start too early
	if ae>length(iv)-15
		ae=length(iv)-16;
	end

	
	apend = find(derivative(ae:end)>=(-thresholdValue/2),1,'first');	%find the derivative where larger than the half of the thresholdValue
	
	if length(apend)==0
		apend=ae;
	else
		apend = apend + ae;
	end
	
	%don't start too early
	if apend>length(iv)-15
		apend=length(iv)-16;
	end
	
	apEndFeatures = [ apEndFeatures apend ];	%add apend position to the output
	
	apendV = iv(apend+1);			%get apend voltage
	
	apEndFeatures = [ apEndFeatures apendV ];	%add apend value to the output
	
	%calculate the corrector
	denominator = derivative(apend)-derivative(apend-1);
	if denominator == 0 
		apendCorrector = 0.5;	
	else
		apendCorrector = abs((derivative(apend)+(thresholdValue/2)) / (denominator));
		if apendCorrector > 1 || apendCorrector < 0
			apendCorrector = 0.5;
		end
	end
	
	%apendV = apendV + abs(apendCorrector*(iv(apend) - iv(apend-1)));	%correct the apend value
	apEndFeatures = [ apEndFeatures apendCorrector apendV ];		%add apend corrector and corrected value to the output
end