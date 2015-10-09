% Find the hyperpolarization V value and the dvin value.
%
% Parameters
%  x - time
%  Y - IVs
%  segments - length of the segments
%  lastHypSecToCount - lenght of hyperpolarization searching interval
function [vhyp dvin] = findHyperPolarization(x,Y,segment,lastHypSecToCount,vrs)
	
	x_temp = abs(x - ((segment(1)+segment(2))/1000));		%find end of the second segment
	hypend = find(x_temp==min(x_temp));			%it will be the end of hyperpolarization
	hypstart = find(x < (x(hypend)-lastHypSecToCount),1,'last');	%go back lastHypSecToCount from end, it will be the start
		
	relevantY = Y(:,hypstart:hypend)';				%cut the relevant part of IVs
	vhyp = mean(relevantY)';				%calculate the hyperpolarization V
	dvin = vrs-vhyp;					%calculate the dvin
end