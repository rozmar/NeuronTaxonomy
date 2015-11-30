% Counts the AP by IV.
%
% In parameter, gets the time, IVs,
% taustart and pulseEnd (to cut off
% the middle segment) and the dvrs to
% corrigate the voltage.
% Returns the mask and the num of APs by IV.
function [apMasks apNums] = labelAP(x,Y,taustart,pulseEnd,dvrs,hundredMicsStep,minapampl,current)
    h = fspecial('average', [1 hundredMicsStep]);
    hslow=fspecial('average', [1 hundredMicsStep*50]);
	xPulse = x(taustart:pulseEnd);
%     YPulse = Y(:,taustart:pulseEnd);
	YPulse = imfilter(Y(:,taustart:pulseEnd),h,'replicate')-imfilter(Y(:,taustart:pulseEnd),hslow,'replicate');
    
% 	realIV = YPulse + repmat(dvrs,1,size(YPulse,2));
% 	apmaskFirst = realIV>0;
	    
    apmaskFirst=bsxfun(@(x,y) x.*y,YPulse>minapampl/1000,current>0); % only APs during positive current injection
	for i=1:size(apmaskFirst,1)
		[apMasks(i,:), apNums(i)] = bwlabel(apmaskFirst(i,:));
	end
	
end