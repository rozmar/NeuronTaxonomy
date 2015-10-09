function plotSpecifiedFeature(dataset,y,featureIndex,featureList)
	v1 = dataset(find(y(:,end)==1),featureIndex);
	v2 = dataset(find(y(:,end)==2),featureIndex);
	plotFeature1D(v1',v2',featureList{featureIndex});
end