%
%
%
function [ rheobase steady ] = getRheobaseSteady(x,Y,taustart,pulseEnd,apNums,current,sampleInterval)
	if apNums(end)>0 && current(end)>=0
		rheobase = find(apNums==0,1,'last')+1;
		
		if length(rheobase) == 0 
			rheobase=2;
		end
		
		 steady=find(abs(apNums-8)==min(abs(apNums-8)),1,'first');

		 if apNums(rheobase)>8
		 	steady=rheobase;
		 end
		 
		 st = find(apNums>=8,1,'first');

		 if size(st,2)>0

		 	steady=st;
		 end
		 
	else
		rheobase = length(apNums);
		steady = rheobase;
	end
end