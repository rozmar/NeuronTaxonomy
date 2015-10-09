% Find the pulse end of the iv.
%	
% In parameter get the time axis and the length 
% of segments. Returns the end of the pulse, so
% the end of the second segment.
function pulseEnd = getPulseEnd(x,segment)
	xAbs = abs(x-sum(segment(1:2))/1000);
	pulseEnd = find(xAbs==min(xAbs))-1;
end