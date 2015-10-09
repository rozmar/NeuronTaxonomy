% Calculates the interSpikes. 
%
% Requires the time and apMax positions by sweep.
% If there is at least two spike, calculates the interspike
% intervals, and calculates the mean ISI.
function [apFeats meanISI ] = getInterSpike(x,apFeatures)
	[locations]=marcicucca_locations;
	load([locations.taxonomy.fetureextractorlocation,'/apFeatures.mat'],'featS');
% 	load('/home/borde/Munka/NeuroScience/featureextractors/apFeatures.mat','featS');
	
	
	
	apFeats = [];
	meanISI = [];
	sweeps = unique(apFeatures(:,featS.sweepNum));		%contain sweep
	for i=1:length(sweeps)
		swSpikes = apFeatures(find(apFeatures(:,featS.sweepNum)==sweeps(i)),:);
		
		%if there is only one spike, interspike is unavailable
		if size(swSpikes,1)==1
			apFeats = [ apFeats ; swSpikes(1,:) 0 ] ;
			continue;	
		else
			apMaxTimes = x(swSpikes(:,featS.apMaxPos));
			
			apFeats = [ apFeats ; swSpikes(1,:) 0 ] ;
			
			ISRow = apMaxTimes(2:end)-apMaxTimes(1:end-1);
            
            if min(ISRow)<0
                pause
            end
			apFeats = [ apFeats ; swSpikes(2:end,:) ISRow ];
		
			meanISI = [ meanISI ; mean(ISRow) ];
		end
	end
end