% Calculates the halfwidht features.
%
% Requires the iv, the ap maximal position and the threshold and apend positions.
% Returns the following:
% hWStartTime hWVoltage hWStop hWLength
function halfwidthFeatures = findHalfWidth(x,y,threshold,apMax,apEnd)

	halfwidthFeatures = [];
	
	halfWidthV = y(threshold) + (y(apMax)-y(threshold))/2;	%voltage at expected half widht

	 halfWidth = find(y(threshold:end)>=halfWidthV,1,'first');	%position of the half width
	
	if length(halfWidth)==0
		halfWidth=threshold;
	else
		halfWidth = halfWidth + threshold-1;
	end
		
	if halfWidth>length(y)
		halfWidth = length(y);	
	end

	if halfWidth==1 || (y(halfWidth)==y(halfWidth-1))
		halfWidthStart = x(halfWidth);
	else 
		corrigator = (halfWidthV-y(halfWidth-1))/(y(halfWidth)-y(halfWidth-1));	%corrigating quotient
		halfWidthStart = corrigator*(x(2)-x(1))+x(halfWidth-1);		%corrigated start time		
	end
	
	halfWidth = find(y(apMax:end)<=halfWidthV,1,'first');		%position of the hw end
	
	if length(halfWidth)==0
		halfWidth=apMax;
	else
		halfWidth = halfWidth + apMax;
	end	
	
	if halfWidth>length(y)
		halfWidth = length(y);	
	end
	
	if halfWidth==1 || (y(halfWidth)==y(halfWidth-1))
		halfWidthStop = x(halfWidth);
	else
		corrigator = (halfWidthV-y(halfWidth-1))/(y(halfWidth)-y(halfWidth-1));	%corrigating quotient
		halfWidthStop = corrigator*(x(2)-x(1))+x(halfWidth-1);		%corrigated end time
	end

	halfWidthLength = (halfWidthStop - halfWidthStart)*1000;
	halfwidthFeatures = [ halfWidthStart halfWidthV halfWidthStop halfWidthLength ];
end
