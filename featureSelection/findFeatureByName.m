


function index = findFeatureByName(name,featureList)
	for i=1:length(featureList)
		if strcmp(featureList{i},name)==1
			index=i;
			return;
		end
	end	
end