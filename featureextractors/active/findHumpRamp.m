%
%
%
function [hump ramp rhump] = findHumpRamp(x,Y,current,apNums,samplingRate,segment,vrs)
	
	hump = [];
	ramp = [];
	rhump = [];

	yPos = Y(intersect(find(current>0),find(apNums==0)),:);		%IVs for hump
	yPos = [ intersect(find(current>0),find(apNums==0)) yPos ];
	
	fNorm = 500 / (samplingRate/2);               %# normalized cutoff frequency
	[b,a] = butter(6, fNorm, 'low');  %# 10th order filter
	
	%filter time
	sag(1,:) = filtfilt(b, a, x(1:length(find(x<0.4+segment(1)/1000))));
	
	for i=1:size(yPos,1)
		sag(2,:) = filtfilt(b, a, yPos(i,2:length(find(x<0.4+segment(1)/1000))+1));
		[ humpVal humpPos ] = max(sag(2,:));		
		dvhump =humpVal-vrs(yPos(i,1));
		ninetydvhump = 0.9*dvhump;
		ninetydvhumpPos = find(sag(2,:)>=vrs(yPos(i,1))+ninetydvhump,1,'first');

		%	figure(2);
		%	clf;
			%plot(sag(1,:),sag(2,:),"b-",sag(1,length(find(x<segment(1)/1000))),sag(2,length(find(x<segment(1)/1000))),'r@',sag(1,humpPos),sag(2,humpPos),'g@',segment(1)/1000,sag(2,length(find(x<segment(1)/1000)))+ninetydvhump,"ko")

		%hump090risetime = ninetydvhumpPos/samplingRate;
		rhump = [ rhump ; (dvhump / (current(yPos(i,1)))*1000000) ];
		%hump = [ hump ; yPos(i,1) humpVal humpPos hump090risetime ];
		hump = [ hump ; yPos(i,1) humpVal humpPos ];
	end
	
	rampstart=round(0.2*samplingRate);
	for i=1:size(Y,1)
		ramp= [ ramp ; polyfit( x(rampstart:end)', Y(i,rampstart:end),1) ];
	end

	rampstart=find(x<.1+segment(1)/1000 ,1,'last');
	
	for i=1:size(yPos,1)
		sag(2,:) = filtfilt(b, a, yPos(i,2:length(find(x<0.4+segment(1)/1000))+1));
		ramp(yPos(i,1),1:2) = polyfit(sag(1,rampstart:end),sag(2,rampstart:end),1);
	end
	
end
