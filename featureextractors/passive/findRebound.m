% Find the rebound position, time, V value, calculates dvrebound.
%
% Parameters
%  x - time
%  y - IVs
%  samplingRate
%  segment - length of segments in milisecundums
%  vhyp - V of hyperpolarization
%  dvrs - size of voltage drop
function [vrebound trebound dvrebound reb090risetime] = findRebound(x,Y,samplingRate,segment,vhyp,dvrs)

	
	YY = Y';				%save original value

	%filter the IVs
	fNorm = 500 / (samplingRate/2);              	%# normalized cutoff frequency
	[b,a] = butter(6, fNorm, 'low');  		%# 10th order filter

	%filter the IVs
	for i=1:size(Y,1)
		Y(i,:) = filtfilt(b, a, Y(i,:));
	end

	
	%Possible rebound can be between the start of the third segment and the last 10% of the 3. segment.
	startPos = find(x>sum(segment(1:2))/1000,1,'first');
	endPos = length(x) - round(segment(3)/10000*samplingRate);
	
	%cut out the relevant part of filtered matrix
	relevantY = Y(:,startPos:endPos)';
	
	%Rebound position: highest voltage in the possible interval on the filtered values
	for i=1:size(relevantY,2)
		reboundPos(i) = startPos +  find(relevantY(:,i)==max(relevantY(:,i)));
		vrebound(i) = max(relevantY(:,i));
	end
	
	%Search for real rebound value: the maximal value in the 0.01 sec radius of the found rebound position
	reboundLeft = reboundPos-round(.01*samplingRate);
	reboundRight = reboundPos+round(.01*samplingRate);
	
	%if right end of interval too long, cut it
	reboundRight(reboundRight>length(x))=length(x);
			
	%cut the relevant part of unfiltered value
	relevantYY = YY(reboundLeft:reboundRight,:);
	
	%[vrebound t] = max(relevantYY);		%get the real maximal values
	vrebound=vrebound';
					
	%realReboundPos = t+reboundLeft;	%convert to real value
	%realReboundPos(realReboundPos>length(x))=length(x);		%cut off too large value
	
	%trebound = x(realReboundPos);				%get rebound time
	trebound = x(reboundPos);
	dvrebound = vrebound-vhyp-dvrs;				%get rebound difference
												
	ninetydvrebound = 0.9*(vrebound-vhyp);
		
	reb90risetime = [];
	for i=1:size(relevantYY,2)
		if size(find(relevantYY(:,i)>=vhyp(i)+ninetydvrebound(i),1,'first'),1)==0
		  reb90risetime(i)=NaN;
		  continue;
		end
		ninetyPos(i) = find(relevantYY(:,i)>=vhyp(i)+ninetydvrebound(i),1,'first') + reboundLeft(i);
		reb090risetime(i) = ninetyPos(i)./samplingRate;
	end
	

end