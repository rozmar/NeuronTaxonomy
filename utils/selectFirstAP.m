% This function selects the first ap, which is followed by at least 1 another AP.
%
% In paramtere, expects the aps, returns the first and the second AP
function apVector = selectFirstAP(apFeatures)
	firingSweep=unique(apFeatures(:,1));
	for i=1:size(firingSweep,1)
		apForithSweep = apFeatures(find(apFeatures==firingSweep(i)),:);
		if size(apForithSweep,1)<2
			continue;
		end
		apVector=apForithSweep(1:2,:);
		return
	end
end