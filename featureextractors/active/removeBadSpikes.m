function [ apFeatures apNums ] = removeBadSpikes(apFeats,apNums)
	apFeatures = [];
	if size(apFeats,1)==0
		return;
	end
	sweeps = unique(apFeats(:,1));
	for i=1:length(sweeps)
		sweepspikes = apFeats(find(apFeats(:,1)==sweeps(i)),:);
				
		toRemove = [];
        
		for j=1:size(sweepspikes,1)
			f=sweepspikes(j,:);
			if (f(15)<0.05) || (f(15)>20) || (isnan(f(15))) || (f(16)<10) || (f(16)>200)
				%disp(["halfWidth ",num2str(f(15))]);
				%disp(["amplitude ",num2str(f(16))]);
				toRemove = [ toRemove j ];
            end
            
            
            repeatingSpike = find(sweepspikes(j+1:end,4)==f(4));
            if ~isempty(repeatingSpike)
                repeatingSpike = repeatingSpike + ones(size(repeatingSpike,1),1)*j;
                toRemove = [ toRemove repeatingSpike' ];
            end
            
		end
		
		
						
		if length(toRemove)>100
			toRemove = [ (1:1:size(sweepspikes)) ];
		end
		
		sweepspikes(toRemove,:) = [];
															
		if ( size(sweepspikes,1)>400 ) 
			sweepspikes(find(sweepspikes(:,1)==sweeps(i)),:)=[];	
        end  
        
		apFeatures = [ apFeatures ; sweepspikes ];
		apNums(sweeps(i))=size(sweepspikes,1);
	end
end