function plotAllFeature(database,fields)
	for col=1:length(fields)-1
		plotSpecifiedFeature(database,fields,col);
	end
end