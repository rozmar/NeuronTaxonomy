%
%
%
function [apFeats rhump ] = offsetVoltage(apFeatures,apNum,hump,current,dvrs)
	apFeats = [];
	rhump = [];
	sweepNum = size(dvrs,1);
	for i=1:sweepNum
		sweepSpikes = apFeatures(find(apFeatures(:,1)==i),:);
		if apNum(i)>0
			
			newApMax = sweepSpikes(:,2) + repmat(dvrs(i),size(sweepSpikes,1),1);
			newThresholdV = sweepSpikes(:,5) + repmat(dvrs(i),size(sweepSpikes,1),1);
			newDvMaxV = sweepSpikes(:,19) + repmat(dvrs(i),size(sweepSpikes,1),1);
			newDvMinV = sweepSpikes(:,23) + repmat(dvrs(i),size(sweepSpikes,1),1);
			sweepSpikes = [ sweepSpikes newApMax newThresholdV newDvMaxV newDvMinV ];
			apFeats = [ apFeats ; sweepSpikes ];
		end
		if size(hump,2)>0
			sweepHump = hump(find(hump(:,1)==i),:);
			if apNum(i)==0 && current(i)>0
				dvhump = dvrs(i)-sweepHump(1,2);
				rhump = [ rhump ; (-dvhump / (current(i))*1000000) ];
			end
		else
			dvhump = 0;
			rhump = [ rhump ; 0 ];
		end
	end
	
end