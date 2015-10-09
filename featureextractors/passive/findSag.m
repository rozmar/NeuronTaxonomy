% Finds the sag at the given IVs.
%
% Parameters:
%  x - time
%  Y - IVs by negative current
%  samplingRate - samplingRate
%  segment -length of segments in milisecundum
function [vsag dvsag rsag tauend] = findSag(x,Y,taustart,vrs,samplingRate,segment,current)
	YY = Y;				%save original value

	%filter the IVs
	fNorm = 500 / (samplingRate/2);              	%# normalized cutoff frequency
	[b,a] = butter(6, fNorm, 'low');  		%# 10th order filter

	%filter the IVs
	for i=1:size(Y,1)
		Y(i,:) = filtfilt(b, a, Y(i,:));
	end
											
	relevantY= Y(:,taustart:length(find(x<0.4+segment(1)/1000)))';
	
	if size(relevantY,1)==0 || size(relevantY,2)==0
		error('Error by sag search.');
	end
				
	[vsag temp] = min(relevantY);
	
	%transpose vsag and temp
	vsag = vsag';
	temp = temp';
	dvsag = vrs - vsag;
	rsag = -dvsag./(current)*1000000;
	tauend = taustart+temp;
end
